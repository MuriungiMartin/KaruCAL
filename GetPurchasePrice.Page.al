#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7190 "Get Purchase Price"
{
    Caption = 'Get Purchase Price';
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Price";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the vendor who offers the line discount on the item.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the purchase price.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item that the purchase price applies to.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure code that the purchase price is valid for.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the minimum quantity of the item that you must buy from the vendor in order to get the purchase price.';
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the direct cost of one item unit.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date from which the purchase price is valid.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date to which the purchase price is valid.';
                }
            }
        }
    }

    actions
    {
    }
}

