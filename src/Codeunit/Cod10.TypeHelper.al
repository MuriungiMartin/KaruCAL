#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10 "Type Helper"
{

    trigger OnRun()
    begin
    end;

    var
        UnsupportedTypeErr: label 'The Type is not supported by the Evaluate function.';
        KeyDoesNotExistErr: label 'The requested key does not exist.';
        InvalidMonthErr: label 'An invalid month was specified.';
        StringTooLongErr: label 'This function only allows strings of length up to %1.', Comment='%1=a number, e.g. 1024';


    procedure Evaluate(var Variable: Variant;String: Text;Format: Text;CultureName: Text): Boolean
    begin
        // Variable is return type containing the string value
        // String is input to evaluate
        // Format is in format "MM/dd/yyyy" only supported on date, search MSDN for more details ("CultureInfo.Name Property")
        // CultureName is in format "en-US", search MSDN for more details ("Custom Date and Time Format Strings")
        case true of
          Variable.IsDate:
            exit(TryEvaluateDate(String,Format,CultureName,Variable));
          Variable.IsDecimal:
            exit(TryEvaluateDecimal(String,CultureName,Variable));
          Variable.Isinteger:
            exit(TryEvaluateInteger(String,CultureName,Variable));
          else
            Error(UnsupportedTypeErr);
        end;
    end;

    local procedure TryEvaluateDate(DateText: Text;Format: Text;CultureName: Text;var EvaluatedDate: Date): Boolean
    var
        CultureInfo: dotnet CultureInfo;
        DotNetDateTime: dotnet DateTime;
        DateTimeStyles: dotnet DateTimeStyles;
        XMLConvert: dotnet XmlConvert;
    begin
        if (Format = '') and (CultureName = '') then
          DotNetDateTime := XMLConvert.ToDateTimeOffset(DateText).DateTime
        else begin
          DotNetDateTime := DotNetDateTime.DateTime(0);
          CultureInfo := CultureInfo.GetCultureInfo(CultureName);
          case Format of
            '':
              if not DotNetDateTime.TryParse(DateText,CultureInfo,DateTimeStyles.None,DotNetDateTime) then
                exit(false);
            else
              if not DotNetDateTime.TryParseExact(DateText,Format,CultureInfo,DateTimeStyles.None,DotNetDateTime) then
                exit(false);
          end;
        end;

        EvaluatedDate := Dmy2date(DotNetDateTime.Day,DotNetDateTime.Month,DotNetDateTime.Year);
        exit(true);
    end;

    local procedure TryEvaluateDecimal(DecimalText: Text;CultureName: Text;var EvaluatedDecimal: Decimal): Boolean
    var
        CultureInfo: dotnet CultureInfo;
        DotNetDecimal: dotnet Decimal;
        NumberStyles: dotnet NumberStyles;
    begin
        EvaluatedDecimal := 0;
        if DotNetDecimal.TryParse(DecimalText,NumberStyles.Number,CultureInfo.GetCultureInfo(CultureName),EvaluatedDecimal) then
          exit(true);
        exit(false)
    end;

    local procedure TryEvaluateInteger(IntegerText: Text;CultureName: Text;var EvaluatedInteger: Integer): Boolean
    var
        CultureInfo: dotnet CultureInfo;
        DotNetInteger: dotnet Int32;
        NumberStyles: dotnet NumberStyles;
    begin
        EvaluatedInteger := 0;
        if DotNetInteger.TryParse(IntegerText,NumberStyles.Number,CultureInfo.GetCultureInfo(CultureName),EvaluatedInteger) then
          exit(true);
        exit(false)
    end;


    procedure GetLocalizedMonthToInt(Month: Text): Integer
    var
        TestMonth: Text;
        Result: Integer;
    begin
        Month := Lowercase(Month);

        for Result := 1 to 12 do begin
          TestMonth := Lowercase(Format(CalcDate(StrSubstNo('<CY+%1M>',Result)),0,'<Month Text>'));
          if Month = TestMonth then
            exit(Result);
        end;

        Error(InvalidMonthErr);
    end;


    procedure FormatDate(DateToFormat: Date;LanguageId: Integer): Text
    var
        CultureInfo: dotnet CultureInfo;
        DateTimeFormatInfo: dotnet DateTimeFormatInfo;
        DotNetDateTime: dotnet DateTime;
    begin
        CultureInfo := CultureInfo.GetCultureInfo(LanguageId);
        DateTimeFormatInfo := CultureInfo.DateTimeFormat;
        DotNetDateTime := DotNetDateTime.DateTime(Date2dmy(DateToFormat,3),Date2dmy(DateToFormat,2),Date2dmy(DateToFormat,1));
        exit(DotNetDateTime.ToString('d',DateTimeFormatInfo));
    end;


    procedure LanguageIDToCultureName(LanguageID: Integer): Text
    var
        CultureInfo: dotnet CultureInfo;
    begin
        CultureInfo := CultureInfo.GetCultureInfo(LanguageID);
        exit(CultureInfo.Name);
    end;


    procedure GetOptionNo(Value: Text;OptionString: Text): Integer
    var
        OptionNo: Integer;
        OptionsQty: Integer;
    begin
        Value := UpperCase(Value);
        OptionString := UpperCase(OptionString);

        if (Value = '') and (StrPos(OptionString,' ') = 1) then
          exit(0);
        if (Value <> '') and (StrPos(OptionString,Value) = 0) then
          exit(-1);

        OptionsQty := GetNumberOfOptions(OptionString);
        if OptionsQty > 0 then begin
          for OptionNo := 0 to OptionsQty - 1 do begin
            if OptionsAreEqual(Value,CopyStr(OptionString,1,StrPos(OptionString,',') - 1)) then
              exit(OptionNo);
            OptionString := DelStr(OptionString,1,StrPos(OptionString,','));
          end;
          OptionNo += 1;
        end;

        if OptionsAreEqual(Value,OptionString) then
          exit(OptionNo);

        exit(-1);
    end;


    procedure GetNumberOfOptions(OptionString: Text): Integer
    begin
        exit(StrLen(OptionString) - StrLen(DelChr(OptionString,'=',',')));
    end;

    local procedure OptionsAreEqual(Value: Text;CurrentOption: Text): Boolean
    begin
        exit((Value = CurrentOption) or ((Value = '') and (DelChr(CurrentOption,'=',' ') = '')));
    end;


    procedure GetFieldLength(TableNo: Integer;FieldNo: Integer): Integer
    var
        "Field": Record "Field";
    begin
        if Field.Get(TableNo,FieldNo) then
          exit(Field.Len);

        exit(0);
    end;


    procedure Equals(ThisRecRef: RecordRef;OtherRecRef: RecordRef;SkipBlob: Boolean): Boolean
    var
        "Field": Record "Field";
        "Key": Record "Key";
        OtherFieldRef: FieldRef;
        ThisFieldRef: FieldRef;
    begin
        if ThisRecRef.Number <> OtherRecRef.Number then
          exit(false);

        if ThisRecRef.KeyCount = ThisRecRef.FieldCount then
          exit(false);

        Field.SetRange(TableNo,ThisRecRef.Number);
        Field.FindSet;

        repeat
          if not Key.Get(ThisRecRef.Number,Field."No.") then begin
            ThisFieldRef := ThisRecRef.Field(Field."No.");
            OtherFieldRef := OtherRecRef.Field(Field."No.");

            case Field.Type of
              Field.Type::Blob,Field.Type::Binary:
                if not SkipBlob then
                  if ReadBlob(ThisFieldRef) <> ReadBlob(OtherFieldRef) then
                    exit(false);
              else
                if ThisFieldRef.Value <> OtherFieldRef.Value then
                  exit(false);
            end;
          end;
        until Field.Next = 0;

        exit(true);
    end;


    procedure ReadBlob(var BlobFieldRef: FieldRef) Content: Text
    var
        TempBlob: Record TempBlob;
        InStream: InStream;
    begin
        BlobFieldRef.CalcField;

        TempBlob.Init;
        TempBlob.Blob := BlobFieldRef.Value;

        TempBlob.Blob.CreateInstream(InStream);
        InStream.Read(Content);
    end;


    procedure ReadTextBlob(var BlobFieldRef: FieldRef;LineSeparator: Text): Text
    begin
        exit(ReadTextBlobWithEncoding(BlobFieldRef,LineSeparator,Textencoding::MSDos));
    end;


    procedure WriteTextToBlobIfChanged(var BlobFieldRef: FieldRef;NewContent: Text;Encoding: TextEncoding): Boolean
    var
        TempBlob: Record TempBlob temporary;
        OutStream: OutStream;
        OldContent: Text;
    begin
        // Returns TRUE if the value was changed, FALSE if the old value was identical and no change was needed
        OldContent := ReadTextBlobWithTextEncoding(BlobFieldRef,Encoding);
        if NewContent = OldContent then
          exit(false);

        TempBlob.Init;
        TempBlob.Blob.CreateOutstream(OutStream,Encoding);
        OutStream.WriteText(NewContent);
        TempBlob.Insert;

        BlobFieldRef.Value := TempBlob.Blob;
        exit(true);
    end;

    local procedure ReadTextBlobWithEncoding(var BlobFieldRef: FieldRef;LineSeparator: Text;Encoding: TextEncoding): Text
    var
        TempBlob: Record TempBlob;
    begin
        BlobFieldRef.CalcField;

        TempBlob.Init;
        TempBlob.Blob := BlobFieldRef.Value;

        exit(TempBlob.ReadAsText(LineSeparator,Encoding));
    end;


    procedure IsMatch(Input: Text;RegExExpression: Text): Boolean
    var
        Regex: dotnet Regex;
        AlphanumericRegEx: dotnet Regex;
    begin
        AlphanumericRegEx := Regex.Regex(RegExExpression);
        exit(AlphanumericRegEx.IsMatch(Input));
    end;


    procedure IsAlphanumeric(Input: Text): Boolean
    begin
        exit(IsMatch(Input,'^[a-zA-Z0-9]*$'));
    end;


    procedure ReadTextBlobWithTextEncoding(var BlobFieldRef: FieldRef;Encoding: TextEncoding) BlobContent: Text
    var
        TempBlob: Record TempBlob;
        InStream: InStream;
    begin
        TempBlob.Init;
        BlobFieldRef.CalcField;
        TempBlob.Blob := BlobFieldRef.Value;
        TempBlob.Blob.CreateInstream(InStream,Encoding);
        if InStream.Read(BlobContent) = 0 then;
    end;

    [TryFunction]

    procedure GetUserTimezoneOffset(var Duration: Duration)
    var
        UserPersonalization: Record "User Personalization";
        TimeZoneInfo: dotnet TimeZoneInfo;
        TimeZone: Text;
    begin
        UserPersonalization.Get(UserSecurityId);
        TimeZone := UserPersonalization."Time Zone";
        TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZone);

        Duration := TimeZoneInfo.BaseUtcOffset;
    end;


    procedure EvaluateUnixTimestamp(Timestamp: BigInteger): DateTime
    var
        ResultDateTime: DateTime;
        EpochDateTime: DateTime;
        TimezoneOffset: Duration;
        TimestampInMilliseconds: BigInteger;
    begin
        if not GetUserTimezoneOffset(TimezoneOffset) then
          TimezoneOffset := 0;

        EpochDateTime := CreateDatetime(Dmy2date(1,1,1970),0T);

        TimestampInMilliseconds := Timestamp * 1000;

        ResultDateTime := EpochDateTime + TimestampInMilliseconds + TimezoneOffset;

        exit(ResultDateTime);
    end;


    procedure UrlEncode(var Value: Text): Text
    var
        HttpUtility: dotnet HttpUtility;
    begin
        Value := HttpUtility.UrlEncode(Value);
        exit(Value);
    end;


    procedure GetKeyAsString(RecordVariant: Variant;KeyIndex: Integer): Text
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
        SelectedKeyRef: KeyRef;
        KeyFieldRef: FieldRef;
        I: Integer;
        KeyString: Text;
        Separator: Text;
    begin
        DataTypeManagement.GetRecordRef(RecordVariant,RecRef);

        if RecRef.KeyCount < KeyIndex then
          Error(KeyDoesNotExistErr);

        SelectedKeyRef := RecRef.KeyIndex(KeyIndex);

        for I := 1 to SelectedKeyRef.FieldCount do begin
          KeyFieldRef := SelectedKeyRef.FieldIndex(I);
          KeyString += Separator + KeyFieldRef.Name;
          Separator := ',';
        end;

        exit(KeyString);
    end;


    procedure SortRecordRef(var RecRef: RecordRef;CommaSeparatedFieldsToSort: Text;"Ascending": Boolean)
    var
        OrderString: Text;
    begin
        if Ascending then
          OrderString := 'ORDER(Ascending)'
        else
          OrderString := 'ORDER(Descending)';

        RecRef.SetView(StrSubstNo('SORTING(%1) %2',CommaSeparatedFieldsToSort,OrderString));
        if RecRef.FindSet then ;
    end;


    procedure TextDistance(Text1: Text;Text2: Text): Integer
    var
        Array1: array [1026] of Integer;
        Array2: array [1026] of Integer;
        i: Integer;
        j: Integer;
        Cost: Integer;
        MaxLen: Integer;
    begin
        // Returns the number of edits to get from Text1 to Text2
        // Reference: https://en.wikipedia.org/wiki/Levenshtein_distance
        if (StrLen(Text1) + 2 > ArrayLen(Array1)) or (StrLen(Text2) + 2 > ArrayLen(Array1)) then
          Error(StringTooLongErr,ArrayLen(Array1) - 2);
        if Text1 = Text2 then
          exit(0);
        if Text1 = '' then
          exit(StrLen(Text2));
        if Text2 = '' then
          exit(StrLen(Text1));

        if StrLen(Text1) >= StrLen(Text2) then
          MaxLen := StrLen(Text1)
        else
          MaxLen := StrLen(Text2);

        for i := 0 to MaxLen + 1 do
          Array1[i + 1] := i;

        for i := 0 to StrLen(Text1) - 1 do begin
          Array2[1] := i + 1;
          for j := 0 to StrLen(Text2) - 1 do begin
            if Text1[i + 1] = Text2[j + 1] then
              Cost := 0
            else
              Cost := 1;
            Array2[j + 2] := MinimumInt3(Array2[j + 1] + 1,Array1[j + 2] + 1,Array1[j + 1] + Cost);
          end;
          for j := 1 to MaxLen + 2 do
            Array1[j] := Array2[j];
        end;
        exit(Array2[StrLen(Text2) + 1]);
    end;

    local procedure MinimumInt3(i1: Integer;i2: Integer;i3: Integer): Integer
    begin
        if (i1 <= i2) and (i1 <= i3) then
          exit(i1);
        if (i2 <= i1) and (i2 <= i3) then
          exit(i2);
        exit(i3);
    end;


    procedure GetGuidAsString(GuidValue: Guid): Text[36]
    begin
        // Converts guid to string
        // Example: Converts {21EC2020-3AEA-4069-A2DD-08002B30309D} to 21ec2020-3aea-4069-a2dd-08002b30309d
        exit(Lowercase(CopyStr(Format(GuidValue),2,36)));
    end;


    procedure WriteRecordLinkNote(var RecordLink: Record "Record Link";Note: Text)
    var
        BinWriter: dotnet BinaryWriter;
        OStr: OutStream;
    begin
        // Writes the Note BLOB into the format the client code expects
        RecordLink.Note.CreateOutstream(OStr,Textencoding::UTF8);
        BinWriter := BinWriter.BinaryWriter(OStr);
        BinWriter.Write(Note);
    end;
}

