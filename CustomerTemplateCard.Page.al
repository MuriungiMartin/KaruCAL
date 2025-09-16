#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5157 "Customer Template Card"
{
    Caption = 'Customer Template Card';
    PageType = Card;
    SourceTable = "Customer Template";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the customer template. You can set up as many codes as you want. The code must be unique. You cannot have the same code twice in one table.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the customer template.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code for the customer template.';
                }
                field("Territory Code";"Territory Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the territory code for the customer template.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code for the customer template.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the customer is liable for sales tax.';
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a tax area code for the company.';
                }
                field(State;State)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the state/province of customers created from this template.';
                }
                field("Credit Limit (LCY)";"Credit Limit (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the maximum credit (in $) that can be extended to customer''s created from a template.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general business posting group for the customer template. To see the general business posting groups in the Gen. Business Posting Groups window, click the field.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a Tax business posting group for the customer template. To see the Tax business posting groups in the Tax Business Posting Groups window, click the field.';
                }
                field("Customer Posting Group";"Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the customer posting group to which the customer template will belong. To see the customer posting group codes in the Customer Posting Groups window, click the field.';
                }
                field("Customer Price Group";"Customer Price Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the customer price group to which the customer template will belong. To see the price group codes in the Customer Price Groups window, click the field.';
                }
                field("Customer Disc. Group";"Customer Disc. Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the customer discount group to which the customer template will belong. To see the customer discount group codes in the Customer Discount Group table, click the field.';
                }
                field("Allow Line Disc.";"Allow Line Disc.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that a line discount is calculated when the sales price is offered.';
                }
                field("Invoice Disc. Code";"Invoice Disc. Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the invoice discount code for the customer template.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the payment terms code for the customer template.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the payment method code for the customer template.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the shipment method code for the customer template.';
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
            group("&Customer Template")
            {
                Caption = '&Customer Template';
                Image = Template;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(5105),
                                  "No."=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                Image = Sales;
                action("Invoice &Discounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code=field("Invoice Disc. Code");
                }
            }
        }
    }
}

