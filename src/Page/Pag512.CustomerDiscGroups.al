#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 512 "Customer Disc. Groups"
{
    ApplicationArea = Basic;
    Caption = 'Customer Disc. Groups';
    PageType = List;
    SourceTable = "Customer Discount Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code for the customer discount group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description for the customer discount group.';
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
        area(navigation)
        {
            group("Cust. &Disc. Groups")
            {
                Caption = 'Cust. &Disc. Groups';
                Image = Group;
                action(SalesLineDiscounts)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales &Line Discounts';
                    Image = SalesLineDisc;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type"=const("Customer Disc. Group"),
                                  "Sales Code"=field(Code);
                    RunPageView = sorting("Sales Type","Sales Code");
                    ToolTip = 'View the sales line discounts that are available. These discount agreements can be for individual customers, for a group of customers, for all customers or for a campaign.';
                }
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        CustDiscGr: Record "Customer Discount Group";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(CustDiscGr);
        exit(SelectionFilterManagement.GetSelectionFilterForCustomerDiscountGroup(CustDiscGr));
    end;
}

