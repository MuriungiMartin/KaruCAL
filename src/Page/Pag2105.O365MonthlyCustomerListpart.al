#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2105 "O365 Monthly Customer Listpart"
{
    Caption = 'Customers';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Customer;
    SourceTableTemporary = true;
    SourceTableView = sorting(Name);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Caption = '';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the customer.';
                    Visible = false;
                }
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
            action(View)
            {
                ApplicationArea = Basic,"#Suite";
                Caption = 'View';
                Gesture = None;
                Image = ViewDetails;
                RunObject = Page "O365 Customer Sales Documents";
                RunPageLink = "Sell-to Customer Name"=field(Name);
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
                Visible = false;
            }
        }
    }


    procedure InsertData(var TempCustomer: Record Customer temporary)
    begin
        TempCustomer.SetCurrentkey(Name);
        if not TempCustomer.FindSet then
          exit;

        DeleteAll;

        repeat
          Copy(TempCustomer);
          Insert;
        until TempCustomer.Next = 0;

        CurrPage.Update;
    end;
}

