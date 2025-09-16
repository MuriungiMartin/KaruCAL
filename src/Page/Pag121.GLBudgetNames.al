#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 121 "G/L Budget Names"
{
    ApplicationArea = Basic;
    Caption = 'G/L Budget Names';
    PageType = List;
    SourceTable = "G/L Budget Name";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the general ledger budget.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the general ledger budget name.';
                }
                field("Budget Dimension 1 Code";"Budget Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code for a budget dimension. You can specify four additional dimensions on each budget that you create.';
                }
                field("Budget Dimension 2 Code";"Budget Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code for a budget dimension. You can specify four additional dimensions on each budget that you create.';
                }
                field("Budget Dimension 3 Code";"Budget Dimension 3 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code for a budget dimension. You can specify four additional dimensions on each budget that you create.';
                }
                field("Budget Dimension 4 Code";"Budget Dimension 4 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code for a budget dimension. You can specify four additional dimensions on each budget that you create.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that entries cannot be created for the budget. ';
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
                ApplicationArea = Suite;
                Caption = 'Edit Budget';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Specify budgets that you can create in the general ledger application area. If you need several different budgets, you can create several budget names.';

                trigger OnAction()
                var
                    Budget: Page Budget;
                begin
                    Budget.SetBudgetName(Name);
                    Budget.Run;
                end;
            }
            action("Budget Comparison")
            {
                ApplicationArea = Basic;
                Image = CapableToPromise;
                Promoted = true;
                RunObject = Page "FIN-Budgetary Comparison List";
                RunPageLink = "Budget Name"=field(Name);
            }
            action("Budget Periods")
            {
                ApplicationArea = Basic;
                Image = AccountingPeriods;
                Promoted = true;
                RunObject = Page "FIN-Budget Periods Setup";
            }
            action(UpdateBudget)
            {
                ApplicationArea = Basic;
                Image = WarrantyLedger;
                Promoted = true;

                trigger OnAction()
                begin

                    Rec.UpdateBudget();
                end;
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        GLBudgetName: Record "G/L Budget Name";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(GLBudgetName);
        exit(SelectionFilterManagement.GetSelectionFilterForGLBudgetName(GLBudgetName));
    end;
}

