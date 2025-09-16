#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2109 "O365 Customer Sales Documents"
{
    Caption = 'Invoices for Customer';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "O365 Sales Document";
    SourceTableTemporary = true;
    SourceTableView = sorting("Sell-to Customer Name");

    layout
    {
        area(content)
        {
            repeater(Control15)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the document.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number that references the document.';
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
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the person to contact at the customer that the items were sold to.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which you created the sales document.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the currency of amounts on the sales document.';
                }
                field("Currency Symbol";"Currency Symbol")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the currency with its symbol, such as $ for Dollar. ';
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document Status";"Document Status")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the document that represents the forecast entry.';
                }
                field("Brick Total";"Brick Total")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total invoices amount, displayed in Brick view.';
                }
                field("Brick Outstanding";"Brick Outstanding")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the outstanding amount, meaning the amount not paid, displayed in Brick view.';
                }
                field("Document Icon";"Document Icon")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the visual identifier of the document format.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(View)
            {
                ApplicationArea = Basic,"#Suite";
                Caption = 'View';
                Image = DocumentEdit;
                Scope = Repeater;
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    if Posted then begin
                      if not SalesInvoiceHeader.Get("No.") then
                        exit;
                      SalesInvoiceHeader.SetRecfilter;
                      Page.Run(Page::"O365 Posted Sales Invoice",SalesInvoiceHeader);
                    end else begin
                      if not SalesHeader.Get("Document Type","No.") then
                        exit;
                      SalesHeader.SetRecfilter;
                      Page.Run(Page::"O365 Sales Invoice",SalesHeader);
                    end;
                end;
            }
            group(Payments)
            {
                Caption = 'Payments';
                action(ShowPayments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Payments';
                    Image = Payment;
                    Scope = Repeater;
                    ToolTip = 'Show a list of payments made for this invoice.';
                    Visible = Posted;

                    trigger OnAction()
                    begin
                        O365SalesInvoicePayment.ShowHistory("No.");
                    end;
                }
                action(MarkAsPaid)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Mark as paid';
                    Gesture = RightSwipe;
                    Image = Payment;
                    Scope = Repeater;
                    ToolTip = 'Pay the invoice as specified in the default Payment Registration Setup.';
                    Visible = Posted and ("outstanding amount" > 0);

                    trigger OnAction()
                    begin
                        O365SalesInvoicePayment.MarkAsPaid("No.");
                    end;
                }
                action(MarkAsUnpaid)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Mark as unpaid';
                    Gesture = RightSwipe;
                    Image = Cancel;
                    Scope = Repeater;
                    ToolTip = 'Mark the invoice as unpaid.';
                    Visible = Posted and ("outstanding amount" = 0);

                    trigger OnAction()
                    begin
                        O365SalesInvoicePayment.CancelSalesInvoicePayment("No.");
                    end;
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(OnFind(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(OnNext(Steps));
    end;

    var
        O365SalesInvoicePayment: Codeunit "O365 Sales Invoice Payment";
}

