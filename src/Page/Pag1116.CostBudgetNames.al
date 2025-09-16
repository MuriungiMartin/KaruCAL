#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1116 "Cost Budget Names"
{
    ApplicationArea = Basic;
    Caption = 'Cost Budget Names';
    PageType = List;
    SourceTable = "Cost Budget Name";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control11)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Cost Budget per Period")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Budget per Period';
                Image = LedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Cost Budget per Period";
                RunPageLink = "Budget Filter"=field(Name);
                ShortCutKey = 'Return';
            }
            action("Cost Budget by Cost Center")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Budget by Cost Center';
                Image = LedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cost Budget by Cost Center";
                RunPageLink = "Budget Filter"=field(Name);
            }
            action("Cost Budget by Cost Object")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Budget by Cost Object';
                Image = LedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cost Budget by Cost Object";
                RunPageLink = "Budget Filter"=field(Name);
            }
            action("Cost Budget/Movement")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Budget/Movement';
                Image = LedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cost Type Balance/Budget";
                RunPageLink = "Budget Filter"=field(Name);
            }
            group(Functions)
            {
                Caption = 'Functions';
                Image = "Action";
                action("Transfer Budget to Actual")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Budget to Actual';
                    Image = CopyCostBudgettoCOA;
                    RunObject = Report "Transfer Budget to Actual";
                }
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        CostBudgetName: Record "Cost Budget Name";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(CostBudgetName);
        exit(SelectionFilterManagement.GetSelectionFilterForCostBudgetName(CostBudgetName));
    end;
}

