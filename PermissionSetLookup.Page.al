#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9841 "Permission Set Lookup"
{
    Caption = 'Permission Set Lookup';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Aggregate Permission Set";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Role ID";"Role ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a profile.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the record.';
                }
                field("App Name";"App Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Extension Name';
                    ToolTip = 'Specifies the name of an extension.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        SelectedRecord := Rec;
    end;

    var
        SelectedRecord: Record "Aggregate Permission Set";


    procedure GetSelectedRecord(var CurrSelectedRecord: Record "Aggregate Permission Set")
    begin
        CurrSelectedRecord := SelectedRecord;
    end;
}

