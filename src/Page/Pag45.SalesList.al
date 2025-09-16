#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 45 "Sales List"
{
    Caption = 'Sales List';
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the sales document.';
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number that the customer uses in their own system to refer to this sales document.';
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact at the customer.';
                    Visible = false;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer to whom you will send the sales invoice when this customer is different from the sell-to customer.';
                    Visible = false;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';
                    Visible = false;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you should contact at the customer who you are sending the invoice to.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                    Visible = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person at the address that products will be shipped to.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the sales header.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the sales header.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the sales person who is assigned to the customer.';
                    Visible = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency of amounts on the sales document.';
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which you created the sales document.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
                Visible = false;
            }
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the customer.';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        PageManagement.PageRun(Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Sales Reservation Avail.")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Reservation Avail.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Sales Reservation Avail.";
                ToolTip = 'View, print, or save an overview of availability of items for shipment on sales documents, filtered on shipment status.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnOpenPage()
    begin
        CopySellToCustomerFilter;
    end;
}

