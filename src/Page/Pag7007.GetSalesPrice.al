#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7007 "Get Sales Price"
{
    Caption = 'Get Sales Price';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Price";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Sales Type";"Sales Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sales price type, which defines whether the price is for an individual, group, all customers, or a campaign.';
                }
                field("Sales Code";"Sales Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code that belongs to the Sales Type.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the currency of the sales price.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item for which the sales price is valid.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code for the sales price, if you have specified the same code on the item card.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the minimum sales quantity required to warrant the sales price.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sales price per unit.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date from which the sales price is valid.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the calendar date when the sales price agreement ends.';
                }
                field("Price Includes VAT";"Price Includes VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the sales price includes tax.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if an invoice discount will be calculated when the sales price is offered.';
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)";"VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax business posting group for customers for whom you want the sales price (which includes tax) to apply.';
                    Visible = false;
                }
                field("Allow Line Disc.";"Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a line discount will be calculated when the sales price is offered.';
                    Visible = false;
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
}

