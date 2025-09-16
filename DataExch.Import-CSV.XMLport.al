#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 1220 "Data Exch. Import - CSV"
{
    Caption = 'Data Exch. Import - CSV';
    Direction = Import;
    Format = VariableText;
    Permissions = TableData "Data Exch. Field"=rimd;
    TextEncoding = WINDOWS;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            MinOccurs = Zero;
            tableelement("Data Exch.";"Data Exch.")
            {
                AutoSave = false;
                XmlName = 'DataExchDocument';
                textelement(col1)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'col1';

                    trigger OnAfterAssignVariable()
                    begin
                        ColumnNo := 1;
                        CheckLineType;
                        InsertColumn(ColumnNo,col1);
                    end;
                }
                textelement(colx)
                {
                    MinOccurs = Zero;
                    Unbound = true;
                    XmlName = 'colx';

                    trigger OnAfterAssignVariable()
                    begin
                        ColumnNo += 1;
                        InsertColumn(ColumnNo,colx);
                    end;
                }

                trigger OnAfterInitRecord()
                begin
                    FileLineNo += 1;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    ValidateHeaderTag;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        if (not LastLineIsFooter and SkipLine) or HeaderWarning then
          Error(LastLineIsHeaderErr);
    end;

    trigger OnPreXmlPort()
    begin
        InitializeGlobals;
    end;

    var
        DataExchField: Record "Data Exch. Field";
        DataExchEntryNo: Integer;
        ImportedLineNo: Integer;
        FileLineNo: Integer;
        HeaderLines: Integer;
        HeaderLineCount: Integer;
        ColumnNo: Integer;
        HeaderTag: Text;
        FooterTag: Text;
        SkipLine: Boolean;
        LastLineIsFooter: Boolean;
        HeaderWarning: Boolean;
        LineType: Option Unknown,Header,Footer,Data;
        CurrentLineType: Option;
        FullHeaderLine: Text;
        LastLineIsHeaderErr: label 'The imported file contains unexpected formatting. One or more lines may be missing in the file.';
        WrongHeaderErr: label 'The imported file contains unexpected formatting. One or more headers are incorrect.';
        DataExchLineDefCode: Code[20];

    local procedure InitializeGlobals()
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        DataExchEntryNo := "Data Exch.".GetRangeMin("Entry No.");
        "Data Exch.".Get(DataExchEntryNo);
        DataExchLineDefCode := "Data Exch."."Data Exch. Line Def Code";
        DataExchDef.Get("Data Exch."."Data Exch. Def Code");
        HeaderLines := DataExchDef."Header Lines";
        ImportedLineNo := 0;
        FileLineNo := 0;
        HeaderTag := DataExchDef."Header Tag";
        FooterTag := DataExchDef."Footer Tag";
        HeaderLineCount := 0;
        CurrentLineType := Linetype::Unknown;
        FullHeaderLine := '';
        currXMLport.FieldSeparator(DataExchDef.ColumnSeparatorChar);
        case DataExchDef."File Encoding" of
          DataExchDef."file encoding"::"MS-DOS":
            currXMLport.TextEncoding(Textencoding::MSDos);
          DataExchDef."file encoding"::"UTF-8":
            currXMLport.TextEncoding(Textencoding::UTF8);
          DataExchDef."file encoding"::"UTF-16":
            currXMLport.TextEncoding(Textencoding::UTF16);
          DataExchDef."file encoding"::WINDOWS:
            currXMLport.TextEncoding(Textencoding::Windows);
        end;
    end;

    local procedure CheckLineType()
    begin
        IdentifyLineType;
        ValidateNonDataLine;
        TrackNonDataLines;
        SkipLine := CurrentLineType <> Linetype::Data;

        if not SkipLine then begin
          HeaderLineCount := 0;
          ImportedLineNo += 1;
        end;
    end;

    local procedure IdentifyLineType()
    begin
        case true of
          FileLineNo <= HeaderLines:
            CurrentLineType := Linetype::Header;
          (HeaderTag <> '') and (StrLen(col1) <= HeaderTagLength) and (StrPos(HeaderTag,col1) = 1):
            CurrentLineType := Linetype::Header;
          (FooterTag <> '') and (StrLen(col1) <= FooterTagLength) and (StrPos(FooterTag,col1) = 1):
            CurrentLineType := Linetype::Footer;
          else
            CurrentLineType := Linetype::Data;
        end;
    end;

    local procedure ValidateNonDataLine()
    begin
        if CurrentLineType = Linetype::Header then begin
          if (HeaderTag <> '') and (StrLen(col1) <= HeaderTagLength) and (StrPos(HeaderTag,col1) = 0) then
            Error(WrongHeaderErr);
        end;
    end;

    local procedure TrackNonDataLines()
    begin
        case CurrentLineType of
          Linetype::Header:
            begin
              HeaderLineCount += 1;
              if not HeaderWarning and (HeaderLines > 0) and (HeaderLineCount > HeaderLines) then
                HeaderWarning := true;
            end;
          Linetype::Data:
            if (HeaderLines > 0) and (HeaderLineCount > 0) and (HeaderLineCount < HeaderLines) then
              HeaderWarning := true;
          Linetype::Footer:
            LastLineIsFooter := true;
        end;
    end;

    local procedure HeaderTagLength(): Integer
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        exit(GetFieldLength(Database::"Data Exch. Def",DataExchDef.FieldNo("Header Tag")));
    end;

    local procedure FooterTagLength(): Integer
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        exit(GetFieldLength(Database::"Data Exch. Def",DataExchDef.FieldNo("Footer Tag")));
    end;

    local procedure GetFieldLength(TableNo: Integer;FieldNo: Integer): Integer
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.Open(TableNo);
        FieldRef := RecRef.Field(FieldNo);
        exit(FieldRef.Length);
    end;

    local procedure InsertColumn(columnNumber: Integer;var columnValue: Text)
    var
        savedColumnValue: Text;
    begin
        savedColumnValue := columnValue;
        columnValue := '';
        if SkipLine then begin
          if (CurrentLineType = Linetype::Header) and (HeaderTag <> '') then
            FullHeaderLine += savedColumnValue + ';';
          exit;
        end;
        if savedColumnValue <> '' then begin
          DataExchField.Init;
          DataExchField.Validate("Data Exch. No.",DataExchEntryNo);
          DataExchField.Validate("Line No.",ImportedLineNo);
          DataExchField.Validate("Column No.",columnNumber);
          DataExchField.Validate(Value,CopyStr(savedColumnValue,1,MaxStrLen(DataExchField.Value)));
          DataExchField.Validate("Data Exch. Line Def Code",DataExchLineDefCode);
          DataExchField.Insert(true);
        end;
    end;

    local procedure ValidateHeaderTag()
    begin
        if SkipLine and (CurrentLineType = Linetype::Header) and (HeaderTag <> '') then
          if StrPos(FullHeaderLine,HeaderTag) = 0 then
            Error(WrongHeaderErr);
    end;
}

