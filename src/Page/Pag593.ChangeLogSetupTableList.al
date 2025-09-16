#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 593 "Change Log Setup (Table) List"
{
    Caption = 'Change Log Setup (Table) List';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = true;
    PageType = List;
    SourceTable = AllObjWithCaption;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'ID';
                    Editable = false;
                }
                field("Object Caption";"Object Caption")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(LogInsertion;ChangeLogSetupTable."Log Insertion")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Log Insertion';
                    OptionCaption = ' ,Some Fields,All Fields';

                    trigger OnAssistEdit()
                    begin
                        with ChangeLogSetupTable do
                          TestField("Log Insertion","log insertion"::"Some Fields");
                        AssistEdit;
                    end;

                    trigger OnValidate()
                    var
                        NewValue: Option;
                    begin
                        if ChangeLogSetupTable."Table No." <> "Object ID" then
                          begin
                          NewValue := ChangeLogSetupTable."Log Insertion";
                          GetRec;
                          ChangeLogSetupTable."Log Insertion" := NewValue;
                        end;

                        if xChangeLogSetupTable.Get(ChangeLogSetupTable."Table No.") then
                          begin
                          if (xChangeLogSetupTable."Log Insertion" = xChangeLogSetupTable."log insertion"::"Some Fields") and
                             (xChangeLogSetupTable."Log Insertion" <> ChangeLogSetupTable."Log Insertion")
                          then
                            if Confirm(
                                 StrSubstNo(Text002,xChangeLogSetupTable.FieldCaption("Log Insertion"),xChangeLogSetupTable."Log Insertion"),false)
                            then
                              ChangeLogSetupTable.DelChangeLogFields(0);
                        end;
                        ChangeLogSetupTableLogInsertio;
                    end;
                }
                field(LogModification;ChangeLogSetupTable."Log Modification")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Log Modification';
                    OptionCaption = ' ,Some Fields,All Fields';

                    trigger OnAssistEdit()
                    begin
                        with ChangeLogSetupTable do
                          TestField("Log Modification","log modification"::"Some Fields");
                        AssistEdit;
                    end;

                    trigger OnValidate()
                    var
                        NewValue: Option;
                    begin
                        if ChangeLogSetupTable."Table No." <> "Object ID" then
                          begin
                          NewValue := ChangeLogSetupTable."Log Modification";
                          GetRec;
                          ChangeLogSetupTable."Log Modification" := NewValue;
                        end;

                        if xChangeLogSetupTable.Get(ChangeLogSetupTable."Table No.") then
                          begin
                          if (xChangeLogSetupTable."Log Modification" = xChangeLogSetupTable."log modification"::"Some Fields") and
                             (xChangeLogSetupTable."Log Modification" <> ChangeLogSetupTable."Log Modification")
                          then
                            if Confirm(
                                 StrSubstNo(Text002,xChangeLogSetupTable.FieldCaption("Log Modification"),xChangeLogSetupTable."Log Modification"),false)
                            then
                              ChangeLogSetupTable.DelChangeLogFields(1);
                        end;
                        ChangeLogSetupTableLogModifica;
                    end;
                }
                field(LogDeletion;ChangeLogSetupTable."Log Deletion")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Log Deletion';
                    OptionCaption = ' ,Some Fields,All Fields';

                    trigger OnAssistEdit()
                    begin
                        with ChangeLogSetupTable do
                          TestField("Log Deletion","log deletion"::"Some Fields");
                        AssistEdit;
                    end;

                    trigger OnValidate()
                    var
                        NewValue: Option;
                    begin
                        if ChangeLogSetupTable."Table No." <> "Object ID" then
                          begin
                          NewValue := ChangeLogSetupTable."Log Deletion";
                          GetRec;
                          ChangeLogSetupTable."Log Deletion" := NewValue;
                        end;

                        if xChangeLogSetupTable.Get(ChangeLogSetupTable."Table No.") then
                          begin
                          if (xChangeLogSetupTable."Log Deletion" = xChangeLogSetupTable."log deletion"::"Some Fields") and
                             (xChangeLogSetupTable."Log Deletion" <> ChangeLogSetupTable."Log Deletion")
                          then
                            if Confirm(
                                 StrSubstNo(Text002,xChangeLogSetupTable.FieldCaption("Log Deletion"),xChangeLogSetupTable."Log Deletion"),false)
                            then
                              ChangeLogSetupTable.DelChangeLogFields(2);
                        end;
                        ChangeLogSetupTableLogDeletion;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GetRec;
    end;

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        SetRange("Object Type","object type"::Table);
        SetRange("Object ID",0,2000000000);
        FilterGroup(0);
    end;

    var
        ChangeLogSetupTable: Record "Change Log Setup (Table)";
        xChangeLogSetupTable: Record "Change Log Setup (Table)";
        Text002: label 'You have changed the %1 field to no longer be %2. Do you want to remove the field selections?';

    local procedure AssistEdit()
    var
        "Field": Record "Field";
        ChangeLogSetupFieldList: Page "Change Log Setup (Field) List";
    begin
        Field.FilterGroup(2);
        Field.SetRange(TableNo,"Object ID");
        Field.FilterGroup(0);
        with ChangeLogSetupTable do
          ChangeLogSetupFieldList.SelectColumn(
            "Log Insertion" = "log insertion"::"Some Fields",
            "Log Modification" = "log modification"::"Some Fields",
            "Log Deletion" = "log deletion"::"Some Fields");
        ChangeLogSetupFieldList.SetTableview(Field);
        ChangeLogSetupFieldList.Run;
    end;

    local procedure UpdateRec()
    begin
        with ChangeLogSetupTable do
          if ("Log Insertion" = "log insertion"::" ") and ("Log Modification" = "log modification"::" ") and
             ("Log Deletion" = "log deletion"::" ")
          then begin
            if Delete then;
          end else
            if not Modify then
              Insert;
    end;

    local procedure GetRec()
    begin
        if not ChangeLogSetupTable.Get("Object ID") then begin
          ChangeLogSetupTable.Init;
          ChangeLogSetupTable."Table No." := "Object ID";
        end;
    end;


    procedure SetSource()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        DeleteAll;

        AllObjWithCaption.SetCurrentkey("Object Type","Object ID");
        AllObjWithCaption.SetRange("Object Type","object type"::Table);
        AllObjWithCaption.SetRange("Object ID",0,2000000006);

        if AllObjWithCaption.Find('-') then
          repeat
            Rec := AllObjWithCaption;
            Insert;
          until AllObjWithCaption.Next = 0;
    end;

    local procedure ChangeLogSetupTableLogInsertio()
    begin
        UpdateRec;
    end;

    local procedure ChangeLogSetupTableLogModifica()
    begin
        UpdateRec;
    end;

    local procedure ChangeLogSetupTableLogDeletion()
    begin
        UpdateRec;
    end;
}

