#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7009 "Get Sales Line Disc."
{
    Caption = 'Get Sales Line Disc.';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Line Discount";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Sales Type";"Sales Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sales type of the sales line discount. The sales type defines whether the sales price is for an individual customer, customer discount group, all customers, or for a campaign.';
                }
                field("Sales Code";"Sales Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies one of the following values, depending on the value in the Sales Type field.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the sales line discount price.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of item that the sales discount line is valid for. That is, either an item or an item discount group.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies one of two values, depending on the value in the Type field.';
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
                    ToolTip = 'Specifies the unit of measure code that the sales line discount is valid for.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the minimum quantity that the customer must purchase in order to gain the agreed discount.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the discount percentage to use to calculate the sales line discount.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date from which the sales line discount is valid.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date to which the sales line discount is valid.';
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

