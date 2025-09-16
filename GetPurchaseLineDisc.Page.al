#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7189 "Get Purchase Line Disc."
{
    Caption = 'Get Purchase Line Disc.';
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Line Discount";

    layout
    {
        area(content)
        {
            repeater(Control1102628000)
            {
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the vendor who offers the line discount on the item.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the purchase line discount price.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item that the purchase line discount applies to.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the variant code for the item.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure code that the purchase line discount is valid for.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the minimum quantity of the item that you must buy from the vendor in order to receive the purchase line discount.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the discount percentage to use to calculate the purchase line discount.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date from which the purchase line discount is valid.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date to which the purchase line discount is valid.';
                }
            }
        }
    }

    actions
    {
    }
}

