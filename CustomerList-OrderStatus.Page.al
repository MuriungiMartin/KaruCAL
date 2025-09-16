#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36631 "Customer List - Order Status"
{
    ApplicationArea = Basic;
    Caption = 'Customer List - Order Status';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a country/region code for the customer. This field is mostly used for registering EU VAT and reporting INTRASTAT.';
                    Visible = false;
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount on sales documents. By default, the payment term from the customer card is entered.';
                }
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Credit Limit (LCY)";"Credit Limit (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the maximum credit (in $) that can be extended to the customer.';
                }
                field("Balance Due (LCY)";"Balance Due (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies payments from the customer that are overdue per today’s date.';
                }
                field("Balance on Date (LCY)";"Balance on Date (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a balance amount in local currency.';
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the customer is blocked from posting.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s phone number.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact person at the customer.';
                }
                field("Collection Method";"Collection Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method you normally use to collect payment from this customer, such as bank transfer or check.';
                    Visible = false;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Customer Price Group";"Customer Price Group")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the customer''s customer discount group. When you enter an item on the sales line, the code is used to check whether the customer should receive a sales line discount on the item.';
                    Visible = false;
                }
                field("Customer Disc. Group";"Customer Disc. Group")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the customer''s customer discount group. When you enter an item on the sales line, the code is used to check whether the customer should receive a sales line discount on the item.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the customer''s default currency.';
                    Visible = false;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Sales (LCY)";"Sales (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Profit (LCY)";"Profit (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1901235907;"Comment Sheet")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "Table Name"=const(Customer),
                              "No."=field("No.");
                Visible = true;
            }
            part(Control1904036707;"Order Header Status Factbox")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "Bill-to Customer No."=field("No.");
                Visible = true;
            }
            part(Control1904036807;"Order Lines Status Factbox")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "Bill-to Customer No."=field("No.");
                Visible = true;
            }
            part(Control1902018507;"Customer Statistics FactBox")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "No."=field("No.");
                Visible = true;
            }
            part(Control1903720907;"Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "No."=field("No.");
                Visible = true;
            }
            systempart(Control1905767507;Notes)
            {
                Editable = false;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {
                Caption = '&Customer';
                Image = Customer;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No."=field("No."),
                                  "Posting Date"=field(upperlimit("Date Filter")),
                                  "Date Filter"=field("Date Filter");
                    RunPageView = sorting("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    Image = History;
                    action("Issued &Reminders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Reminders';
                        Image = OrderReminder;
                        RunObject = Page "Issued Reminder List";
                        RunPageLink = "Customer No."=field("No."),
                                      "Document Date"=field("Date Filter");
                        RunPageView = sorting("Customer No.","Posting Date");
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Finance Charge Memos';
                        Image = FinChargeMemo;
                        RunObject = Page "Issued Fin. Charge Memo List";
                        RunPageLink = "Customer No."=field("No."),
                                      "Document Date"=field("Date Filter");
                        RunPageView = sorting("Customer No.","Posting Date");
                    }
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(Customer),
                                  "No."=field("No.");
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Customer Bank Account List";
                    RunPageLink = "Customer No."=field("No.");
                    ToolTip = 'View or set up the customer''s bank accounts. You can set up any number of bank accounts for each customer.';
                }
                action("C&ontact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'C&ontact';
                    Image = ContactPerson;
                    ToolTip = 'Open the card for the contact person at the customer.';

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
                separator(Action1020026)
                {
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("Statistics by C&urrencies")
                {
                    ApplicationArea = Suite;
                    Caption = 'Statistics by C&urrencies';
                    Image = Currencies;
                    RunObject = Page "Cust. Stats. by Curr. Lines";
                    RunPageLink = "Customer Filter"=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Date Filter"=field("Date Filter");
                    ToolTip = 'View the customer’s statistics for each currency for which there are transactions.';
                }
                action("Entry Statistics")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    ToolTip = 'View statistics for customer ledger entries.';
                }
                action("S&ales")
                {
                    ApplicationArea = Suite;
                    Caption = 'S&ales';
                    Image = Sales;
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Date Filter"=field("Date Filter");
                    ToolTip = 'View your sales to the customer by different periods.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange("Date Filter",0D,WorkDate - 1);
    end;


    procedure GetSelectionFilter(): Code[80]
    var
        Cust: Record Customer;
        FirstCust: Code[30];
        LastCust: Code[30];
        SelectionFilter: Code[250];
        CustCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Cust);
        CustCount := Cust.Count;
        if CustCount > 0 then begin
          Cust.Find('-');
          while CustCount > 0 do begin
            CustCount := CustCount - 1;
            Cust.MarkedOnly(false);
            FirstCust := Cust."No.";
            LastCust := FirstCust;
            More := (CustCount > 0);
            while More do
              if Cust.Next = 0 then
                More := false
              else
                if not Cust.Mark then
                  More := false
                else begin
                  LastCust := Cust."No.";
                  CustCount := CustCount - 1;
                  if CustCount = 0 then
                    More := false;
                end;
            if SelectionFilter <> '' then
              SelectionFilter := SelectionFilter + '|';
            if FirstCust = LastCust then
              SelectionFilter := SelectionFilter + FirstCust
            else
              SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
            if CustCount > 0 then begin
              Cust.MarkedOnly(true);
              Cust.Next;
            end;
          end;
        end;
        exit(SelectionFilter);
    end;


    procedure SetSelection(var Cust: Record Customer)
    begin
        CurrPage.SetSelectionFilter(Cust);
    end;
}

