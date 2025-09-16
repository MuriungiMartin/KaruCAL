#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7154 "Item Analy. View Budg. Entries"
{
    Caption = 'Analysis View Budget Entries';
    DataCaptionFields = "Analysis View Code";
    Editable = false;
    PageType = List;
    SourceTable = "Item Analysis View Budg. Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Budget Name";"Budget Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the budget that the analysis view budget entries are linked to.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location to which the analysis view budget entry was posted.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that the analysis view budget entry is linked to.';
                }
                field("Dimension 1 Value Code";"Dimension 1 Value Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which dimension value you have selected for the analysis view dimension that you defined as Dimension 1 on the analysis view card.';
                }
                field("Dimension 2 Value Code";"Dimension 2 Value Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which dimension value you have selected for the analysis view dimension that you defined as Dimension 2 on the analysis view card.';
                }
                field("Dimension 3 Value Code";"Dimension 3 Value Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which dimension value you have selected for the analysis view dimension that you defined as Dimension 1 on the analysis view card.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the item budget entries in an analysis view budget entry were posted.';
                }
                field("Sales Amount";"Sales Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item budget entry sales amount included in an analysis view budget entry.';

                    trigger OnDrillDown()
                    begin
                        DrillDown;
                    end;
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item budget entry cost amount included in an analysis view budget entry.';

                    trigger OnDrillDown()
                    begin
                        DrillDown;
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item budget entry quantity included in an analysis view budget entry.';

                    trigger OnDrillDown()
                    begin
                        DrillDown;
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if "Analysis View Code" <> xRec."Analysis View Code" then;
    end;

    local procedure DrillDown()
    var
        ItemBudgetEntry: Record "Item Budget Entry";
    begin
        ItemBudgetEntry.SetRange("Entry No.","Entry No.");
        Page.RunModal(0,ItemBudgetEntry);
    end;
}

