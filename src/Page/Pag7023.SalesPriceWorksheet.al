#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7023 "Sales Price Worksheet"
{
    ApplicationArea = Basic;
    Caption = 'Sales Price Worksheet';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Sales Price Worksheet";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the earliest date on which the item can be sold at the sales price.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the sales price agreement ends.';
                }
                field("Sales Type";"Sales Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of sale that the price is based on, such as All Customers or Campaign.';
                }
                field("Sales Code";"Sales Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Sales Type code.';
                }
                field("Sales Description";"Sales Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the sales type, such as Campaign, on the worksheet line.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the sales price.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item for which sales prices are being changed or set up.';
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item on the worksheet line.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the applicable variant code for the new unit price.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code for the item to which the sales price is applicable.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the minimum sales quantity that must be met to warrant the sales price.';
                }
                field("Current Unit Price";"Current Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit price of the item.';
                }
                field("New Unit Price";"New Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the new unit price that is valid for the selected combination of Sales Code, Currency Code and/or Starting Date.';
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if an invoice discount will be calculated when the sales price is offered.';
                    Visible = false;
                }
                field("Price Includes VAT";"Price Includes VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the sales price includes Tax.';
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)";"VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the Tax business posting group of customers for whom the sales prices will apply.';
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Suggest &Item Price on Wksh.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest &Item Price on Wksh.';
                    Ellipsis = true;
                    Image = SuggestItemPrice;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Suggest Item Price on Wksh.",true,true);
                    end;
                }
                action("Suggest &Sales Price on Wksh.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest &Sales Price on Wksh.';
                    Ellipsis = true;
                    Image = SuggestSalesPrice;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Suggest Sales Price on Wksh.",true,true);
                    end;
                }
                action("I&mplement Price Change")
                {
                    ApplicationArea = Basic;
                    Caption = 'I&mplement Price Change';
                    Ellipsis = true;
                    Image = ImplementPriceChange;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Implement Price Change",true,true,Rec);
                    end;
                }
            }
        }
    }
}

