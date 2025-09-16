#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2113 "O365 Posted Sales Invoice"
{
    Caption = 'Sent Invoice';
    Editable = false;
    PageType = Document;
    SourceTable = "Sales Invoice Header";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default. When you fill this field, most of the other fields on the document are filled from the customer card.';
                    Visible = false;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer Name';
                    Importance = Promoted;
                }
                field("Sell-to Address";"Sell-to Address")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Address';
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s sell-to address.';
                }
                field("Sell-to Address 2";"Sell-to Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the address of the customer that the items were sold to.';
                    Visible = false;
                }
                field("Sell-to City";"Sell-to City")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'City';
                    Importance = Additional;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the person to contact at the customer that the items were sold to.';
                    Visible = false;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = ' ZIP Code';
                    Importance = Additional;
                }
                field("Sell-to County";"Sell-to County")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the State of the customer that the items were sold to.';
                    Visible = false;
                }
                field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Country/Region Code';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoice Date';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the posting date of the record.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Due Date';
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the tax area code that is used to calculate and post sales tax.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies if the sales invoice contains sales tax.';
                }
                field("Quote No.";"Quote No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the sales quote that the sales order was created from. You can track the number to sales quote documents that you have printed, saved, or emailed.';
                    Visible = false;
                }
                group("Work Description")
                {
                    Caption = 'Work Description';
                    field(WorkDescription;WorkDescription)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the products or service being offered';
                    }
                }
            }
            part(Control21;"O365 Posted Sales Inv. Lines")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Lines';
                SubPageLink = "Document No."=field("No.");
            }
            field(Amount;Amount)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Net Total';
                Enabled = false;
                Importance = Promoted;
            }
            field("Amount Including VAT";"Amount Including VAT")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Total Including Tax';
                Enabled = false;
                Importance = Promoted;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Send)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Resend by email';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Sends the invoice as pdf by email.';

                trigger OnAction()
                begin
                    SetRecfilter;
                    LockTable;
                    Find;
                    EmailRecords(false);
                    Find;
                end;
            }
            action(ViewPdf)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'View Invoice';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View the final invoice as pdf.';

                trigger OnAction()
                var
                    ReportSelections: Record "Report Selections";
                    ReportViewer: Page "Report Viewer";
                begin
                    SetRecfilter;
                    LockTable;
                    Find;
                    ReportViewer.SetDocument(Rec,ReportSelections.Usage::"S.Invoice","Sell-to Customer No.");
                    ReportViewer.Run;
                    Find;
                end;
            }
            action(ShowPayments)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Payments';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show a list of payments made for this invoice.';

                trigger OnAction()
                begin
                    O365SalesInvoicePayment.ShowHistory("No.");
                end;
            }
            action(MarkAsPaid)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Mark as paid';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Pay the invoice as specified in the default Payment Registration Setup.';
                Visible = not IsFullyPaid;

                trigger OnAction()
                begin
                    O365SalesInvoicePayment.MarkAsPaid("No.");
                end;
            }
            action(MarkAsUnpaid)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Mark as unpaid';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Mark the invoice as unpaid.';
                Visible = IsFullyPaid;

                trigger OnAction()
                begin
                    O365SalesInvoicePayment.CancelSalesInvoicePayment("No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        DummyCustLedgerEntry: Record "Cust. Ledger Entry";
        O365SalesInvoicePayment: Codeunit "O365 Sales Invoice Payment";
    begin
        IsFullyPaid := O365SalesInvoicePayment.GetPaymentCustLedgerEntry(DummyCustLedgerEntry,"No.");
        WorkDescription := GetWorkDescription;
    end;

    var
        O365SalesInvoicePayment: Codeunit "O365 Sales Invoice Payment";
        IsFullyPaid: Boolean;
        WorkDescription: Text;
}

