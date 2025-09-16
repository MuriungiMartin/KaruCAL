#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 513 "Item Disc. Groups"
{
    ApplicationArea = Basic;
    Caption = 'Item Disc. Groups';
    PageType = List;
    SourceTable = "Item Discount Group";
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
                    ToolTip = 'Specifies the code for the item discount group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description for the item discount group.';
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
            group("Item &Disc. Groups")
            {
                Caption = 'Item &Disc. Groups';
                Image = Group;
                action("Sales &Line Discounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales &Line Discounts';
                    Image = SalesLineDisc;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = Type=const("Item Disc. Group"),
                                  Code=field(Code);
                    RunPageView = sorting(Type,Code);
                    ToolTip = 'View the sales line discounts that are available. These discount agreements can be for individual customers, for a group of customers, for all customers or for a campaign.';
                }
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        ItemDiscGr: Record "Item Discount Group";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(ItemDiscGr);
        exit(SelectionFilterManagement.GetSelectionFilterForItemDiscountGroup(ItemDiscGr));
    end;
}

