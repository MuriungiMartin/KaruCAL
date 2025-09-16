#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1102 "Cost Allocation Sources"
{
    ApplicationArea = Basic;
    Caption = 'Cost Allocation Sources';
    CardPageID = "Cost Allocation";
    Editable = false;
    PageType = List;
    SourceTable = "Cost Allocation Source";
    SourceTableView = sorting(Level,"Valid From","Valid To","Cost Type Range");
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control8)
            {
                field(ID;ID)
                {
                    ApplicationArea = Basic;
                }
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                }
                field(Variant;Variant)
                {
                    ApplicationArea = Basic;
                }
                field("Valid From";"Valid From")
                {
                    ApplicationArea = Basic;
                }
                field("Valid To";"Valid To")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Type Range";"Cost Type Range")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Cost Center Code";"Cost Center Code")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Object Code";"Cost Object Code")
                {
                    ApplicationArea = Basic;
                }
                field("Credit to Cost Type";"Credit to Cost Type")
                {
                    ApplicationArea = Basic;
                }
                field("Total Share";"Total Share")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Allocation Source Type";"Allocation Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Allocation")
            {
                Caption = '&Allocation';
                Image = Allocate;
                action("&Allocation Target")
                {
                    ApplicationArea = Basic;
                    Caption = '&Allocation Target';
                    Image = Setup;
                    RunObject = Page "Cost Allocation Target List";
                    RunPageLink = ID=field(ID);
                    ShortCutKey = 'Ctrl+F7';
                }
                action(PageChartOfCostTypes)
                {
                    ApplicationArea = Basic;
                    Caption = '&Corresponding Cost Types';
                    Image = CompareCost;
                    RunObject = Page "Chart of Cost Types";
                    RunPageLink = "No."=field(filter("Cost Type Range"));
                }
            }
        }
        area(reporting)
        {
            action(Allocations)
            {
                ApplicationArea = Basic;
                Caption = 'Allocations';
                Image = Allocations;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Cost Allocations";
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                Image = "Action";
                action("&Allocate Costs")
                {
                    ApplicationArea = Basic;
                    Caption = '&Allocate Costs';
                    Enabled = true;
                    Image = Costs;
                    RunObject = Report "Cost Allocation";
                }
                action("&Calculate Allocation Bases")
                {
                    ApplicationArea = Basic;
                    Caption = '&Calculate Allocation Bases';
                    Image = Calculate;
                    RunObject = Codeunit "Cost Account Allocation";
                }
            }
        }
    }
}

