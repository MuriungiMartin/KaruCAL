#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68124 "ACA-All Students List"
{
    Caption = 'All Students List';
    CardPageID = "ACA-Students Card";
    Editable = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=const(Student));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Town';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
                field("Barcode Picture";"Barcode Picture")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Student")
            {
                Caption = '&Student';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "ACA-Students Card";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    ShortCutKey = 'Shift+F7';
                }
                action("Student Billing")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "ACA-Student Billing";
                    RunPageLink = "No."=field("No.");
                }
                action("Hostel Allocation")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "ACA-Stud. Hostel Header";
                    RunPageLink = "No."=field("No.");
                }
                action("Student Registration")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "ACA-Student Card";
                    RunPageLink = "No."=field("No.");
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    action("Issued &Reminders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Reminders';
                        RunObject = Page "Issued Reminder";
                        RunPageLink = "Customer No."=field("No.");
                        RunPageView = sorting("Customer No.","Posting Date");
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Finance Charge Memos';
                        RunObject = Page "Issued Finance Charge Memo";
                        RunPageLink = "Customer No."=field("No.");
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
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(18),
                                      "No."=field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';

                        trigger OnAction()
                        var
                            Cust: Record Customer;
                        begin
                            CurrPage.SetSelectionFilter(Cust);
                            //DefaultDimMultiple.SetMultiCust(Cust);
                            //DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    RunObject = Page "Customer Bank Account Card";
                    RunPageLink = "Customer No."=field("No.");
                }
                action("Ship-&to Addresses")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-&to Addresses';
                    RunObject = Page "Ship-to Address";
                    RunPageLink = "Customer No."=field("No.");
                }
                action("C&ontact")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&ontact';

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
                separator(Action59)
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
                    ApplicationArea = Basic;
                    Caption = 'Statistics by C&urrencies';
                    RunObject = Page "Dimension Set ID Filter";
                    RunPageLink = Code=field("No."),
                                  Field56=field("Global Dimension 1 Filter"),
                                  Field57=field("Global Dimension 2 Filter"),
                                  Field55=field("Date Filter");
                }
                action("Entry Statistics")
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry Statistics';
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                }
                action("S&ales")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&ales';
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                }
                separator(Action44)
                {
                }
                action("Cross Re&ferences")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cross Re&ferences';
                    RunObject = Page "Cross References";
                    RunPageLink = "Cross-Reference Type"=const(Customer),
                                  "Cross-Reference Type No."=field("No.");
                    RunPageView = sorting("Cross-Reference Type","Cross-Reference Type No.");
                }
                separator(Action67)
                {
                }
                action("Ser&vice Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page "Customer Service Contracts";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.","Ship-to Code");
                }
                action("Service &Items")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Items';
                    RunObject = Page "Service Items";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.","Ship-to Code","Item No.","Serial No.");
                }
                separator(Action83)
                {
                }
                group(Sales)
                {
                    Caption = 'Sales';
                    action("Invoice &Discounts")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice &Discounts';
                        RunObject = Page "Cust. Invoice Discounts";
                        RunPageLink = Code=field("Invoice Disc. Code");
                    }
                    action(Prices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prices';
                        Image = ResourcePrice;
                        RunObject = Page "Sales Prices";
                        RunPageLink = "Sales Type"=const(Customer),
                                      "Sales Code"=field("No.");
                        RunPageView = sorting("Sales Type","Sales Code");
                    }
                    action("Line Discounts")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Line Discounts';
                        RunObject = Page "Sales Line Discounts";
                        RunPageLink = "Sales Type"=const(Customer),
                                      "Sales Code"=field("No.");
                        RunPageView = sorting("Sales Type","Sales Code");
                    }
                    action("Prepa&yment Percentages")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prepa&yment Percentages';
                        RunObject = Page "Sales Prepayment Percentages";
                        RunPageLink = "Sales Type"=const(Customer),
                                      "Sales Code"=field("No.");
                        RunPageView = sorting("Sales Type","Sales Code");
                    }
                    action("S&td. Cust. Sales Codes")
                    {
                        ApplicationArea = Basic;
                        Caption = 'S&td. Cust. Sales Codes';
                        RunObject = Page "Standard Customer Sales Codes";
                        RunPageLink = "Customer No."=field("No.");
                    }
                    separator(Action74)
                    {
                    }
                    action(Quotes)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Quotes';
                        Image = Quote;
                        RunObject = Page "Sales Quote";
                        RunPageLink = "Sell-to Customer No."=field("No.");
                        RunPageView = sorting("Sell-to Customer No.");
                    }
                    action("Blanket Orders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Blanket Orders';
                        Image = BlanketOrder;
                        RunObject = Page "Blanket Sales Order";
                        RunPageLink = "Sell-to Customer No."=field("No.");
                        RunPageView = sorting("Document Type","Sell-to Customer No.");
                    }
                    action(Orders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Orders';
                        Image = Document;
                        RunObject = Page "Sales Order";
                        RunPageLink = "Sell-to Customer No."=field("No.");
                        RunPageView = sorting("Sell-to Customer No.");
                    }
                    action("Return Orders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Return Orders';
                        Image = ReturnOrder;
                        RunObject = Page "Sales Return Order";
                    }
                    action("Service Orders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Orders';
                        Image = Document;
                        RunObject = Page "Service Order";
                        RunPageLink = "Customer No."=field("No.");
                        RunPageView = sorting("Document Type","Customer No.");
                    }
                    action("Item &Tracking Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;

                        trigger OnAction()
                        var
                            ItemTrackingMgt: Codeunit "Item Tracking Management";
                        begin
                            ItemTrackingMgt.CallItemTrackingEntryForm(1,"No.",'','','','','');
                        end;
                    }
                }
            }
        }
    }


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

