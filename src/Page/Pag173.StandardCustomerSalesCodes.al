#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 173 "Standard Customer Sales Codes"
{
    Caption = 'Recurring Sales Lines';
    DataCaptionFields = "Customer No.";
    PageType = List;
    SourceTable = "Standard Customer Sales Code";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number of the customer to which the standard sales code is assigned.';
                    Visible = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a standard sales code from the Standard Sales Code table.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the standard sales code.';
                }
                field("Valid From Date";"Valid From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the first day when the Create Recurring Sales Inv. batch job can be used to create sales invoices.';
                }
                field("Valid To date";"Valid To date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last day when the Create Recurring Sales Inv. batch job can be used to create sales invoices.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment method for sales invoices with this standard customer sales code.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment method for sales invoices with this standard customer sales code.';
                }
                field("Direct Debit Mandate ID";"Direct Debit Mandate ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the direct-debit mandate that this standard customer sales code uses to create sales invoices for direct debit collection.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the standard customer sales code cannot be used.';
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
            group("&Sales")
            {
                Caption = '&Sales';
                Image = Sales;
                action(Card)
                {
                    ApplicationArea = Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Standard Sales Code Card";
                    RunPageLink = Code=field(Code);
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or create the standard sales line s that are represented by the code on the recurring sales line.';
                }
            }
        }
    }


    procedure GetSelected(var StdCustSalesCode: Record "Standard Customer Sales Code")
    begin
        CurrPage.SetSelectionFilter(StdCustSalesCode);
    end;
}

