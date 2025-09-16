#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1527 "Workflow Change List FactBox"
{
    Caption = 'Changes to Approve';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Workflow - Record Change";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Field";"Field Caption")
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    ToolTip = 'Specifies the caption of the field that changes.';
                }
                field(NewValue;NewValue)
                {
                    ApplicationArea = Suite;
                    Caption = 'New Value';
                    Style = StrongAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the field value after the field is changed.';
                }
                field(OldValue;OldValue)
                {
                    ApplicationArea = Suite;
                    Caption = 'Old Value';
                    ToolTip = 'Specifies the field value before the field is changed.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        NewValue := GetFormattedNewValue(true);
        OldValue := GetFormattedOldValue(true);
    end;

    var
        NewValue: Text;
        OldValue: Text;


    procedure SetFilterFromApprovalEntry(ApprovalEntry: Record "Approval Entry") ReturnValue: Boolean
    begin
        //SETRANGE("Record ID",ApprovalEntry."Record ID to Approve");
        //SETRANGE("Workflow Step Instance ID",ApprovalEntry."Workflow Step Instance ID");
        ReturnValue := FindSet;
        CurrPage.Update(false);
    end;
}

