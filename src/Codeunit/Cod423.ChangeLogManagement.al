#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 423 "Change Log Management"
{
    Permissions = TableData "Change Log Setup"=r,
                  TableData "Change Log Setup (Table)"=r,
                  TableData "Change Log Setup (Field)"=r,
                  TableData "Change Log Entry"=ri;
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        ChangeLogSetup: Record "Change Log Setup";
        ChangeLogSetupTable: Record "Change Log Setup (Table)";
        TempChangeLogSetupTable: Record "Change Log Setup (Table)" temporary;
        ChangeLogSetupField: Record "Change Log Setup (Field)";
        TempChangeLogSetupField: Record "Change Log Setup (Field)" temporary;
        TempField: Record "Field" temporary;
        ChangeLogSetupRead: Boolean;


    procedure GetDatabaseTableTriggerSetup(TableID: Integer;var LogInsert: Boolean;var LogModify: Boolean;var LogDelete: Boolean;var LogRename: Boolean)
    begin
        if COMPANYNAME = '' then
          exit;

        if TableID = Database::"Change Log Entry" then
          exit;

        if TableID in
           [Database::User,
            Database::"User Property",
            Database::"Access Control",
            Database::"Permission Set",
            Database::Permission,
            Database::"Change Log Setup",
            Database::"Change Log Setup (Table)",
            Database::"Change Log Setup (Field)"]
        then begin
          LogInsert := true;
          LogModify := true;
          LogDelete := true;
          LogRename := true;
          exit;
        end;

        if not ChangeLogSetupRead then begin
          if ChangeLogSetup.Get then;
          ChangeLogSetupRead := true;
        end;

        if not ChangeLogSetup."Change Log Activated" then
          exit;

        if not TempChangeLogSetupTable.Get(TableID) then begin
          if not ChangeLogSetupTable.Get(TableID) then begin
            TempChangeLogSetupTable.Init;
            TempChangeLogSetupTable."Table No." := TableID;
          end else
            TempChangeLogSetupTable := ChangeLogSetupTable;
          TempChangeLogSetupTable.Insert;
        end;

        with TempChangeLogSetupTable do begin
          LogInsert := "Log Insertion" <> "log insertion"::" ";
          LogModify := "Log Modification" <> "log modification"::" ";
          LogRename := "Log Modification" <> "log modification"::" ";
          LogDelete := "Log Deletion" <> "log deletion"::" ";
        end;
    end;

    local procedure IsLogActive(TableNumber: Integer;FieldNumber: Integer;TypeOfChange: Option Insertion,Modification,Deletion): Boolean
    begin
        if TableNumber in
           [Database::User,
            Database::"User Property",
            Database::"Access Control",
            Database::"Permission Set",
            Database::Permission,
            Database::"Change Log Setup",
            Database::"Change Log Setup (Table)",
            Database::"Change Log Setup (Field)"]
        then
          exit(true);

        if not ChangeLogSetupRead then begin
          if ChangeLogSetup.Get then;
          ChangeLogSetupRead := true;
        end;
        if not ChangeLogSetup."Change Log Activated" then
          exit(false);
        if not TempChangeLogSetupTable.Get(TableNumber) then begin
          if not ChangeLogSetupTable.Get(TableNumber) then begin
            TempChangeLogSetupTable.Init;
            TempChangeLogSetupTable."Table No." := TableNumber;
          end else
            TempChangeLogSetupTable := ChangeLogSetupTable;
          TempChangeLogSetupTable.Insert;
        end;

        with TempChangeLogSetupTable do
          case TypeOfChange of
            Typeofchange::Insertion:
              if "Log Insertion" = "log insertion"::"Some Fields" then
                exit(IsFieldLogActive(TableNumber,FieldNumber,TypeOfChange))
              else
                exit("Log Insertion" = "log insertion"::"All Fields");
            Typeofchange::Modification:
              if "Log Modification" = "log modification"::"Some Fields" then
                exit(IsFieldLogActive(TableNumber,FieldNumber,TypeOfChange))
              else
                exit("Log Modification" = "log modification"::"All Fields");
            Typeofchange::Deletion:
              if "Log Deletion" = "log deletion"::"Some Fields" then
                exit(IsFieldLogActive(TableNumber,FieldNumber,TypeOfChange))
              else
                exit("Log Deletion" = "log deletion"::"All Fields");
          end;
    end;

    local procedure IsFieldLogActive(TableNumber: Integer;FieldNumber: Integer;TypeOfChange: Option Insertion,Modification,Deletion): Boolean
    begin
        if FieldNumber = 0 then
          exit(true);

        if not TempChangeLogSetupField.Get(TableNumber,FieldNumber) then begin
          if not ChangeLogSetupField.Get(TableNumber,FieldNumber) then begin
            TempChangeLogSetupField.Init;
            TempChangeLogSetupField."Table No." := TableNumber;
            TempChangeLogSetupField."Field No." := FieldNumber;
          end else
            TempChangeLogSetupField := ChangeLogSetupField;
          TempChangeLogSetupField.Insert;
        end;

        with TempChangeLogSetupField do
          case TypeOfChange of
            Typeofchange::Insertion:
              exit("Log Insertion");
            Typeofchange::Modification:
              exit("Log Modification");
            Typeofchange::Deletion:
              exit("Log Deletion");
          end;
    end;

    local procedure InsertLogEntry(var FldRef: FieldRef;var xFldRef: FieldRef;var RecRef: RecordRef;TypeOfChange: Option Insertion,Modification,Deletion;IsReadable: Boolean)
    var
        ChangeLogEntry: Record "Change Log Entry";
        KeyFldRef: FieldRef;
        KeyRef1: KeyRef;
        i: Integer;
    begin
        ChangeLogEntry.Init;
        ChangeLogEntry."Date and Time" := CurrentDatetime;
        ChangeLogEntry.Time := Dt2Time(ChangeLogEntry."Date and Time");

        ChangeLogEntry."User ID" := UserId;

        ChangeLogEntry."Table No." := RecRef.Number;
        ChangeLogEntry."Field No." := FldRef.Number;
        ChangeLogEntry."Type of Change" := TypeOfChange;
        if (RecRef.Number = Database::"User Property") and (FldRef.Number in [2..5]) then begin // Password like
          ChangeLogEntry."Old Value" := '*';
          ChangeLogEntry."New Value" := '*';
        end else begin
          if TypeOfChange <> Typeofchange::Insertion then
            if IsReadable then
              ChangeLogEntry."Old Value" := Format(xFldRef.Value,0,9)
            else
              ChangeLogEntry."Old Value" := '';
          if TypeOfChange <> Typeofchange::Deletion then
            ChangeLogEntry."New Value" := Format(FldRef.Value,0,9);
        end;

        ChangeLogEntry."Record ID" := RecRef.RecordId;
        ChangeLogEntry."Primary Key" := RecRef.GetPosition(false);

        KeyRef1 := RecRef.KeyIndex(1);
        for i := 1 to KeyRef1.FieldCount do begin
          KeyFldRef := KeyRef1.FieldIndex(i);

          case i of
            1:
              begin
                ChangeLogEntry."Primary Key Field 1 No." := KeyFldRef.Number;
                ChangeLogEntry."Primary Key Field 1 Value" := Format(KeyFldRef.Value,0,9);
              end;
            2:
              begin
                ChangeLogEntry."Primary Key Field 2 No." := KeyFldRef.Number;
                ChangeLogEntry."Primary Key Field 2 Value" := Format(KeyFldRef.Value,0,9);
              end;
            3:
              begin
                ChangeLogEntry."Primary Key Field 3 No." := KeyFldRef.Number;
                ChangeLogEntry."Primary Key Field 3 Value" := Format(KeyFldRef.Value,0,9);
              end;
          end;
        end;
        ChangeLogEntry.Insert;
    end;


    procedure LogInsertion(var RecRef: RecordRef)
    var
        FldRef: FieldRef;
        i: Integer;
    begin
        if RecRef.IsTemporary then
          exit;

        if not IsLogActive(RecRef.Number,0,0) then
          exit;
        for i := 1 to RecRef.FieldCount do begin
          FldRef := RecRef.FieldIndex(i);
          if HasValue(FldRef) then
            if IsNormalField(RecRef.Number,FldRef.Number) then
              if IsLogActive(RecRef.Number,FldRef.Number,0) then
                InsertLogEntry(FldRef,FldRef,RecRef,0,true);
        end;
    end;


    procedure LogModification(var RecRef: RecordRef)
    var
        xRecRef: RecordRef;
        FldRef: FieldRef;
        xFldRef: FieldRef;
        i: Integer;
        IsReadable: Boolean;
    begin
        if RecRef.IsTemporary then
          exit;

        if not IsLogActive(RecRef.Number,0,1) then
          exit;

        xRecRef.Open(RecRef.Number);
        if xRecRef.ReadPermission then begin
          IsReadable := true;
          if not xRecRef.Get(RecRef.RecordId) then
            exit;
        end;

        for i := 1 to RecRef.FieldCount do begin
          FldRef := RecRef.FieldIndex(i);
          xFldRef := xRecRef.FieldIndex(i);
          if IsNormalField(RecRef.Number,FldRef.Number) then
            if Format(FldRef.Value) <> Format(xFldRef.Value) then
              if IsLogActive(RecRef.Number,FldRef.Number,1) then
                InsertLogEntry(FldRef,xFldRef,RecRef,1,IsReadable);
        end;
    end;


    procedure LogRename(var RecRef: RecordRef;var xRecRef: RecordRef)
    var
        FldRef: FieldRef;
        xFldRef: FieldRef;
        i: Integer;
    begin
        if RecRef.IsTemporary then
          exit;

        if not IsLogActive(RecRef.Number,0,1) then
          exit;
        xRecRef.Get(xRecRef.RecordId);
        for i := 1 to RecRef.FieldCount do begin
          FldRef := RecRef.FieldIndex(i);
          xFldRef := xRecRef.FieldIndex(i);
          if IsNormalField(RecRef.Number,FldRef.Number) then
            if Format(FldRef.Value) <> Format(xFldRef.Value) then
              if IsLogActive(RecRef.Number,FldRef.Number,1) then
                InsertLogEntry(FldRef,xFldRef,RecRef,1,true);
        end;
    end;


    procedure LogDeletion(var RecRef: RecordRef)
    var
        FldRef: FieldRef;
        i: Integer;
    begin
        if RecRef.IsTemporary then
          exit;

        if not IsLogActive(RecRef.Number,0,2) then
          exit;
        for i := 1 to RecRef.FieldCount do begin
          FldRef := RecRef.FieldIndex(i);
          if HasValue(FldRef) then
            if IsNormalField(RecRef.Number,FldRef.Number) then
              if IsLogActive(RecRef.Number,FldRef.Number,2) then
                InsertLogEntry(FldRef,FldRef,RecRef,2,true);
        end;
    end;

    local procedure IsNormalField(TableNumber: Integer;FieldNumber: Integer): Boolean
    var
        "Field": Record "Field";
    begin
        if TableNumber<>61118 then begin
        GetField(TableNumber,FieldNumber,Field);
        exit(Field.Class = TempField.Class::Normal) ;
        end
        else
          exit(true)
    end;

    local procedure GetField(TableNumber: Integer;FieldNumber: Integer;var Field2: Record "Field")
    var
        "Field": Record "Field";
    begin
        if not TempField.Get(TableNumber,FieldNumber) then begin
          Field.Get(TableNumber,FieldNumber);
          TempField := Field;
          TempField.Insert;
        end;
        Field2 := TempField;
    end;

    local procedure HasValue(FldRef: FieldRef): Boolean
    var
        "Field": Record "Field";
        HasValue: Boolean;
        Int: Integer;
        Dec: Decimal;
        D: Date;
        T: Time;
    begin
        Evaluate(Field.Type,Format(FldRef.Type));

        case Field.Type of
          Field.Type::Boolean:
            HasValue := FldRef.Value;
          Field.Type::Option:
            HasValue := true;
          Field.Type::Integer:
            begin
              Int := FldRef.Value;
              HasValue := Int <> 0;
            end;
          Field.Type::Decimal:
            begin
              Dec := FldRef.Value;
              HasValue := Dec <> 0;
            end;
          Field.Type::Date:
            begin
              D := FldRef.Value;
              HasValue := D <> 0D;
            end;
          Field.Type::Time:
            begin
              T := FldRef.Value;
              HasValue := T <> 0T;
            end;
          Field.Type::Blob:
            HasValue := false;
          else
            HasValue := Format(FldRef.Value) <> '';
        end;

        exit(HasValue);
    end;


    procedure InitChangeLog()
    begin
        ChangeLogSetupRead := false;
        TempChangeLogSetupField.DeleteAll;
        TempChangeLogSetupTable.DeleteAll;
    end;


    procedure EvaluateTextToFieldRef(InputText: Text;var FieldRef: FieldRef): Boolean
    var
        IntVar: Integer;
        DecimalVar: Decimal;
        DateVar: Date;
        TimeVar: Time;
        DateTimeVar: DateTime;
        BoolVar: Boolean;
        DurationVar: Duration;
        BigIntVar: BigInteger;
        GUIDVar: Guid;
        DateFormulaVar: DateFormula;
    begin
        if (Format(FieldRef.CLASS) = 'FlowField') or (Format(FieldRef.CLASS) = 'FlowFilter') then
          exit(true);

        case Format(FieldRef.Type) of
          'Integer','Option':
            if Evaluate(IntVar,InputText) then begin
              FieldRef.Value := IntVar;
              exit(true);
            end;
          'Decimal':
            if Evaluate(DecimalVar,InputText,9) then begin
              FieldRef.Value := DecimalVar;
              exit(true);
            end;
          'Date':
            if Evaluate(DateVar,InputText,9) then begin
              FieldRef.Value := DateVar;
              exit(true);
            end;
          'Time':
            if Evaluate(TimeVar,InputText,9) then begin
              FieldRef.Value := TimeVar;
              exit(true);
            end;
          'DateTime':
            if Evaluate(DateTimeVar,InputText,9) then begin
              FieldRef.Value := DateTimeVar;
              exit(true);
            end;
          'Boolean':
            if Evaluate(BoolVar,InputText,9) then begin
              FieldRef.Value := BoolVar;
              exit(true);
            end;
          'Duration':
            if Evaluate(DurationVar,InputText,9) then begin
              FieldRef.Value := DurationVar;
              exit(true);
            end;
          'BigInteger':
            if Evaluate(BigIntVar,InputText) then begin
              FieldRef.Value := BigIntVar;
              exit(true);
            end;
          'GUID':
            if Evaluate(GUIDVar,InputText,9) then begin
              FieldRef.Value := GUIDVar;
              exit(true);
            end;
          'Code','Text':
            begin
              if StrLen(InputText) > FieldRef.Length then begin
                FieldRef.Value := PadStr(InputText,FieldRef.Length);
                exit(false);
              end;
              FieldRef.Value := InputText;
              exit(true);
            end;
          'DateFormula':
            if Evaluate(DateFormulaVar,InputText,9) then begin
              FieldRef.Value := DateFormulaVar;
              exit(true);
            end;
        end;

        exit(false);
    end;
}

