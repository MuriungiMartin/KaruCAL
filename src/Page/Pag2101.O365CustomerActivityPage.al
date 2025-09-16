#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2101 "O365 Customer Activity Page"
{
    Caption = 'Customers';
    CardPageID = "O365 Sales Customer Card";
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = Customer;
    SourceTableView = sorting(Name);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Caption = '';
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';
                }
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';

                    trigger OnDrillDown()
                    begin
                        OpenCustomerLedgerEntries(false);
                    end;
                }
                field("Balance Due (LCY)";"Balance Due (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies payments from the customer that are overdue per today''s date.';

                    trigger OnDrillDown()
                    begin
                        OpenCustomerLedgerEntries(true);
                    end;
                }
                field("Sales (LCY)";"Sales (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total net amount of sales to the customer in $.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NewSalesInvoice)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'New Invoice';
                Gesture = RightSwipe;
                Image = NewSalesInvoice;
                Promoted = true;
                PromotedIsBig = true;
                RunPageMode = Create;
                Scope = Repeater;
                ToolTip = 'Create a sales invoice for the customer.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Init;
                    SalesHeader.Validate("Document Type",SalesHeader."document type"::Invoice);
                    SalesHeader.Validate("Sell-to Customer No.","No.");
                    SalesHeader.Insert(true);
                    Commit;

                    Page.Run(Page::"O365 Sales Invoice",SalesHeader);
                end;
            }
        }
    }
}

