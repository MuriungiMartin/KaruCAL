#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 297 "Vendor Item Catalog"
{
    Caption = 'Vendor Item Catalog';
    DataCaptionFields = "Vendor No.";
    PageType = List;
    SourceTable = "Item Vendor";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor who offers the alternate direct unit cost.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item that the alternate direct unit cost is valid for.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number that the vendor uses for this item.';
                }
                field("Lead Time Calculation";"Lead Time Calculation")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a date formula for the amount of time that it takes to replenish the item.';
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
            group("Ve&ndor Item")
            {
                Caption = 'Ve&ndor Item';
                Image = Item;
                action("Purch. Prices")
                {
                    ApplicationArea = Suite;
                    Caption = 'Purch. Prices';
                    Image = Price;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Vendor No."=field("Vendor No.");
                    RunPageView = sorting("Item No.","Vendor No.");
                    ToolTip = 'Define purchase price agreements with vendors for specific items.';
                }
                action("P&urch. Line Discounts")
                {
                    ApplicationArea = Suite;
                    Caption = 'P&urch. Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Vendor No."=field("Vendor No.");
                    ToolTip = 'Define purchase line discounts with vendors. For example, you may get for a line discount if you buy items from a vendor in large quantities.';
                }
            }
        }
    }
}

