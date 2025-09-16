#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9374 "Budget Names Sales"
{
    ApplicationArea = Basic;
    Caption = 'Budget Names Sales';
    PageType = List;
    SourceTable = "Item Budget Name";
    SourceTableView = where("Analysis Area"=const(Sales));
    UsageCategory = ReportsandAnalysis;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the item budget.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item budget.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the item budget is blocked.';
                }
                field("Budget Dimension 1 Code";"Budget Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension code for Item Budget Dimension 1.';
                }
                field("Budget Dimension 2 Code";"Budget Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension code for Item Budget Dimension 2.';
                }
                field("Budget Dimension 3 Code";"Budget Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension code for Item Budget Dimension 3.';
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
        area(processing)
        {
            action(EditBudget)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Budget';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                var
                    SalesBudgetOverview: Page "Sales Budget Overview";
                begin
                    SalesBudgetOverview.SetNewBudgetName(Name);
                    SalesBudgetOverview.Run;
                end;
            }
        }
    }
}

