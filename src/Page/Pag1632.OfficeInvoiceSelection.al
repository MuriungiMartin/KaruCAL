#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1632 "Office Invoice Selection"
{
    Caption = 'Invoice Exists';
    DataCaptionExpression = COMPANYNAME;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    InstructionalText = 'An invoice already exists for this appointment.';
    ModifyAllowed = false;
    ShowFilter = false;
    SourceTable = "Office Invoice";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                Editable = false;
                InstructionalText = 'At least one sales invoice has already been created for this appointment. You may select an existing invoice or continue creating a new invoice for the appointment.';
            }
            field(NewInvoice;NewSalesInvoiceLbl)
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                ShowCaption = false;
                ToolTip = 'Specifies a new invoice.';

                trigger OnDrillDown()
                var
                    Customer: Record Customer;
                begin
                    Customer.Get(CurrentCustomerNo);
                    Customer.CreateAndShowNewInvoice;
                    CurrPage.Close;
                end;
            }
            repeater("Existing Sales Invoices")
            {
                field("No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the No. for the document.';

                    trigger OnDrillDown()
                    begin
                        ShowInvoice;
                    end;
                }
                field("Sell-to Customer Name";SellToCustomer)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sell-to Customer Name';
                    ToolTip = 'Specifies the name of the customer on the document.';
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posted';
                    ToolTip = 'Specifies whether the document has been posted.';
                }
                field("Posting Date";PostingDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date for the document.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the amount on the document.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if Posted then begin
          SalesInvoiceHeader.Get("Document No.");
          PostingDate := SalesInvoiceHeader."Posting Date";
          SalesInvoiceHeader.CalcFields(Amount);
          Amount := SalesInvoiceHeader.Amount;
          SellToCustomer := SalesInvoiceHeader."Sell-to Customer Name";
        end else begin
          SalesHeader.Get(SalesHeader."document type"::Invoice,"Document No.");
          SalesHeader.CalcFields(Amount);
          Amount := SalesHeader.Amount;
          SellToCustomer := SalesHeader."Sell-to Customer Name";
        end;
    end;

    trigger OnInit()
    begin
        CurrPage.Update;
    end;

    trigger OnOpenPage()
    begin
        CurrentCustomerNo := GetCustomer;
        CurrPage.Update;
    end;

    var
        SellToCustomer: Text[50];
        PostingDate: Date;
        Amount: Decimal;
        NewSalesInvoiceLbl: label 'Create a new sales invoice';
        CurrentCustomerNo: Code[20];
}

