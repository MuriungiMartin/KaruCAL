#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9622 "Table Field Types ListPart"
{
    Caption = 'Table Field Types ListPart';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Table Field Types";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Display Name";"Display Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies Name displayed to users.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies description.';
                }
            }
        }
    }

    actions
    {
    }


    procedure GetSelectedRecord(var TableFieldTypes: Record "Table Field Types")
    begin
        CurrPage.SetSelectionFilter(TableFieldTypes);
    end;
}

