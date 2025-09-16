#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9023 "Accounting Services RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1;"Accounting Services Activities")
            {
            }
            part(Control2;"My Customers")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                action("Sales Quote")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Quote';
                    Image = NewSalesQuote;
                    RunObject = Page "Sales Quote";
                    RunPageMode = Create;
                }
                action("Sales Invoice")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Invoice';
                    Image = NewSalesInvoice;
                    RunObject = Page "Sales Invoice";
                    RunPageMode = Create;
                }
            }
        }
        area(embedding)
        {
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                RunObject = Page "Item List";
            }
            action("Posted Sales Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Sales Invoices';
                RunObject = Page "Posted Sales Invoices";
            }
        }
    }
}

