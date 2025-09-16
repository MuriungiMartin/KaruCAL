#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 22 "Customer List"
{
    ApplicationArea = Basic;
    Caption = 'Customer List';
    CardPageID = "Customer Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Approve,New Document,Request Approval,Customer';
    SourceTable = Customer;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                }
                field(Name;Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the responsibility center that will administer this customer by default.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies from which location sales to this customer will be processed by default.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ZIP code.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s IC partner code, if the customer is one of your intercompany partners.';
                    Visible = false;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code for the salesperson who normally handles this customer''s account.';
                    Visible = false;
                }
                field("Customer Posting Group";"Customer Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s tax specification to link transactions made for this customer to.';
                    Visible = false;
                }
                field("Customer Price Group";"Customer Price Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer price group code, which you can use to set up special sales prices in the Sales Prices window.';
                    Visible = false;
                }
                field("Customer Disc. Group";"Customer Disc. Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.';
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code that indicates the payment terms that you require of the customer.';
                    Visible = false;
                }
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how reminders about late payments are handled for this customer.';
                    Visible = false;
                }
                field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies finance charges are calculated for the customer.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the default currency for the customer.';
                    Visible = false;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the language to be used on printouts for this customer.';
                    Visible = false;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an alternate name that you can use to search for a customer when you cannot remember the value in the Name field.';
                    Visible = false;
                }
                field("Credit Limit (LCY)";"Credit Limit (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which transactions with the customer that cannot be blocked, for example, because the customer is declared insolvent.';
                    Visible = false;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when the customer card was last modified.';
                    Visible = false;
                }
                field("Application Method";"Application Method")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how to apply payments to entries for this customer.';
                    Visible = false;
                }
                field("Combine Shipments";"Combine Shipments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if several orders delivered to the customer can appear on the same sales invoice.';
                    Visible = false;
                }
                field(Reserve;Reserve)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether items will never, automatically (Always), or optionally be reserved for this customer. Optional means that you must manually reserve items for this customer.';
                    Visible = false;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the customer accepts partial shipment of orders.';
                    Visible = false;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which shipping company is used when you ship items to the customer.';
                    Visible = false;
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a customizable calendar for shipment planning that includes the customer''s working days and holidays.';
                    Visible = false;
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
        area(factboxes)
        {
            part(Control99;"CRM Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No."=field("No.");
                Visible = CRMIsCoupledToRecord;
            }
            part(Control35;"Social Listening FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Source Type"=const(Customer),
                              "Source No."=field("No.");
                Visible = SocialListeningVisible;
            }
            part(Control33;"Social Listening Setup FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Source Type"=const(Customer),
                              "Source No."=field("No.");
                UpdatePropagation = Both;
                Visible = SocialListeningSetupVisible;
            }
            part(SalesHistSelltoFactBox;"Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("No."),
                              "Currency Filter"=field("Currency Filter"),
                              "Date Filter"=field("Date Filter"),
                              "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
            }
            part(SalesHistBilltoFactBox;"Sales Hist. Bill-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No."=field("No."),
                              "Currency Filter"=field("Currency Filter"),
                              "Date Filter"=field("Date Filter"),
                              "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                Visible = false;
            }
            part(CustomerStatisticsFactBox;"Customer Statistics FactBox")
            {
                SubPageLink = "No."=field("No."),
                              "Currency Filter"=field("Currency Filter"),
                              "Date Filter"=field("Date Filter"),
                              "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
            }
            part(CustomerDetailsFactBox;"Customer Details FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("No."),
                              "Currency Filter"=field("Currency Filter"),
                              "Date Filter"=field("Date Filter"),
                              "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                Visible = false;
            }
            part(Control1907829707;"Service Hist. Sell-to FactBox")
            {
                SubPageLink = "No."=field("No."),
                              "Currency Filter"=field("Currency Filter"),
                              "Date Filter"=field("Date Filter"),
                              "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                Visible = false;
            }
            part(Control1902613707;"Service Hist. Bill-to FactBox")
            {
                SubPageLink = "No."=field("No."),
                              "Currency Filter"=field("Currency Filter"),
                              "Date Filter"=field("Date Filter"),
                              "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                Visible = false;
            }
            systempart(Control1900383207;Links)
            {
            }
            systempart(Control1905767507;Notes)
            {
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
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(18),
                                      "No."=field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Cust: Record Customer;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Cust);
                            DefaultDimMultiple.SetMultiCust(Cust);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Customer Bank Account List";
                    RunPageLink = "Customer No."=field("No.");
                    ToolTip = 'View or set up the customer''s bank accounts. You can set up any number of bank accounts for each customer.';
                }
                action("Direct Debit Mandates")
                {
                    ApplicationArea = Basic;
                    Caption = 'Direct Debit Mandates';
                    Image = MakeAgreement;
                    RunObject = Page "SEPA Direct Debit Mandates";
                    RunPageLink = "Customer No."=field("No.");
                    ToolTip = 'View the direct-debit mandates that reflect agreements with customers to collect invoice payments from their bank account.';
                }
                action(ShipToAddresses)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-&to Addresses';
                    Image = ShipAddress;
                    RunObject = Page "Ship-to Address List";
                    RunPageLink = "Customer No."=field("No.");
                    ToolTip = 'View or edit alternate shipping addresses where the customer wants items delivered if different from the regular address.';
                }
                action("C&ontact")
                {
                    AccessByPermission = TableData Contact=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'C&ontact';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'View or edit detailed information about the contact person at the customer.';

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
                action("Cross Re&ferences")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cross Re&ferences';
                    Image = Change;
                    RunObject = Page "Cross References";
                    RunPageLink = "Cross-Reference Type"=const(Customer),
                                  "Cross-Reference Type No."=field("No.");
                    RunPageView = sorting("Cross-Reference Type","Cross-Reference Type No.");
                    ToolTip = 'Set up the customer''s own identification of items that you sell to the customer. Cross-references to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
                }
                action(OnlineMap)
                {
                    ApplicationArea = All;
                    Caption = 'Online Map';
                    Image = Map;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'View the address on an online map.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        DisplayMap;
                    end;
                }
                action(ApprovalEntries)
                {
                    AccessByPermission = TableData "Approval Entry"=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoAccount)
                {
                    ApplicationArea = All;
                    Caption = 'Account';
                    Image = CoupledCustomer;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM account.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(RecordId);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record"=IM;
                    ApplicationArea = All;
                    Caption = 'Synchronize Now';
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        Customer: Record Customer;
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        CustomerRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(Customer);
                        Customer.Next;

                        if Customer.Count = 1 then
                          CRMIntegrationManagement.UpdateOneNow(Customer.RecordId)
                        else begin
                          CustomerRecordRef.GetTable(Customer);
                          CRMIntegrationManagement.UpdateMultipleNow(CustomerRecordRef);
                        end
                    end;
                }
                action(UpdateStatisticsInCRM)
                {
                    ApplicationArea = All;
                    Caption = 'Update Account Statistics';
                    Enabled = CRMIsCoupledToRecord;
                    Image = UpdateXML;
                    ToolTip = 'Send customer statistics data to Dynamics CRM to update the Account Statistics FactBox.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.CreateOrUpdateCRMAccountStatistics(Rec);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment='Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record"=IM;
                        ApplicationArea = All;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM account.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.DefineCoupling(RecordId);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record"=IM;
                        ApplicationArea = All;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM account.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(RecordId);
                        end;
                    }
                }
                group(Create)
                {
                    Caption = 'Create';
                    Image = NewCustomer;
                    action(CreateInCRM)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Account in Dynamics CRM';
                        Image = NewCustomer;
                        ToolTip = 'Generate the account in the coupled Microsoft Dynamics CRM account.';

                        trigger OnAction()
                        var
                            Customer: Record Customer;
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                            CustomerRecordRef: RecordRef;
                        begin
                            CurrPage.SetSelectionFilter(Customer);
                            Customer.Next;

                            if Customer.Count = 1 then
                              CRMIntegrationManagement.CreateNewRecordInCRM(RecordId,false)
                            else begin
                              CustomerRecordRef.GetTable(Customer);
                              CRMIntegrationManagement.CreateNewRecordsInCRM(CustomerRecordRef);
                            end
                        end;
                    }
                    action(CreateFromCRM)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Customer in Dynamics NAV';
                        Image = NewCustomer;
                        ToolTip = 'Generate the customer in the coupled Microsoft Dynamics CRM account.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.ManageCreateNewRecordFromCRM(Database::Customer);
                        end;
                    }
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action(CustomerLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
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
                action("S&ales")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&ales';
                    Image = Sales;
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                }
                action("Entry Statistics")
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                }
                action("Statistics by C&urrencies")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics by C&urrencies';
                    Image = Currencies;
                    RunObject = Page "Cust. Stats. by Curr. Lines";
                    RunPageLink = "Customer Filter"=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Date Filter"=field("Date Filter");
                }
                action("Item &Tracking Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    var
                        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                    begin
                        ItemTrackingDocMgt.ShowItemTrackingForMasterData(1,"No.",'','','','','');
                    end;
                }
            }
            group(ActionGroup24)
            {
                Caption = 'S&ales';
                Image = Sales;
                action(Sales_InvoiceDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code=field("Invoice Disc. Code");
                    ToolTip = 'Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.';
                }
                action(Sales_Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type"=const(Customer),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                    ToolTip = 'View or set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
                action(Sales_LineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type"=const(Customer),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                    ToolTip = 'Set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
                action("Prepa&yment Percentages")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Sales Type"=const(Customer),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                }
                action("S&td. Cust. Sales Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&td. Cust. Sales Codes';
                    Image = CodesList;
                    RunObject = Page "Standard Customer Sales Codes";
                    RunPageLink = "Customer No."=field("No.");
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Quotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page "Sales Quotes";
                    RunPageLink = "Sell-to Customer No."=field("No.");
                    RunPageView = sorting("Sell-to Customer No.");
                }
                action(Orders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Order List";
                    RunPageLink = "Sell-to Customer No."=field("No.");
                    RunPageView = sorting("Sell-to Customer No.");
                }
                action("Return Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Order List";
                    RunPageLink = "Sell-to Customer No."=field("No.");
                    RunPageView = sorting("Sell-to Customer No.");
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    Image = Documents;
                    action("Issued &Reminders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Reminders';
                        Image = OrderReminder;
                        RunObject = Page "Issued Reminder List";
                        RunPageLink = "Customer No."=field("No.");
                        RunPageView = sorting("Customer No.","Posting Date");
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Finance Charge Memos';
                        Image = FinChargeMemo;
                        RunObject = Page "Issued Fin. Charge Memo List";
                        RunPageLink = "Customer No."=field("No.");
                        RunPageView = sorting("Customer No.","Posting Date");
                    }
                }
                action("Blanket Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page "Blanket Sales Orders";
                    RunPageLink = "Sell-to Customer No."=field("No.");
                    RunPageView = sorting("Document Type","Sell-to Customer No.");
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = ServiceItem;
                action("Service Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Orders';
                    Image = Document;
                    RunObject = Page "Service Orders";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Document Type","Customer No.");
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
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.","Ship-to Code","Item No.","Serial No.");
                }
            }
        }
        area(creation)
        {
            action(NewSalesBlanketOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Blanket Sales Order';
                Image = BlanketOrder;
                RunObject = Page "Blanket Sales Order";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
            }
            action(NewSalesQuote)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Quote';
                Image = NewSalesQuote;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                RunObject = Page "Sales Quote";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a new sales quote where you offer items or services to a customer.';
            }
            action(NewSalesInvoice)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Invoice';
                Image = NewSalesInvoice;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                RunObject = Page "Sales Invoice";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a sales invoice for the customer.';
            }
            action(NewSalesOrder)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                RunObject = Page "Sales Order";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a sales order for the customer.';
            }
            action(NewSalesCrMemo)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Credit Memo';
                Image = CreditMemo;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                RunObject = Page "Sales Credit Memo";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a new sales credit memo to revert a posted sales invoice.';
            }
            action(NewSalesReturnOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Order';
                Image = ReturnOrder;
                RunObject = Page "Sales Return Order";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
            }
            action(NewServiceQuote)
            {
                ApplicationArea = Basic;
                Caption = 'Service Quote';
                Image = Quote;
                RunObject = Page "Service Quote";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
            }
            action(NewServiceInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Service Invoice';
                Image = Invoice;
                RunObject = Page "Service Invoice";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
            }
            action(NewServiceOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Service Order';
                Image = Document;
                RunObject = Page "Service Order";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
            }
            action(NewServiceCrMemo)
            {
                ApplicationArea = Basic;
                Caption = 'Service Credit Memo';
                Image = CreditMemo;
                RunObject = Page "Service Credit Memo";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
            }
            action(NewReminder)
            {
                ApplicationArea = Basic;
                Caption = 'Reminder';
                Image = Reminder;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page Reminder;
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
            }
            action(NewFinChargeMemo)
            {
                ApplicationArea = Basic;
                Caption = 'Finance Charge Memo';
                Image = FinChargeMemo;
                RunObject = Page "Finance Charge Memo";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            group(ActionGroup104)
            {
                Caption = 'History';
                Image = History;
                action(CustomerLedgerEntriesHistory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
            group(PricesAndDiscounts)
            {
                Caption = 'Prices and Discounts';
                action(Prices_InvoiceDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code=field("Invoice Disc. Code");
                    Scope = Repeater;
                    ToolTip = 'Set up different discounts applied to invoices for the selected customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.';
                }
                action(Prices_Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type"=const(Customer),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                    Scope = Repeater;
                    ToolTip = 'View or set up different prices for items that you sell to the selected customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
                action(Prices_LineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type"=const(Customer),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                    Scope = Repeater;
                    ToolTip = 'Set up different discounts for items that you sell to the selected customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Enabled = (not OpenApprovalEntriesExist) and EnabledApprovalWorkflowsExist;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send an approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) then
                          ApprovalsMgmt.OnSendCustomerForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
                    end;
                }
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                action(CreateApprovalWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Approval Workflow';
                    Enabled = not EnabledApprovalWorkflowsExist;
                    Image = CreateWorkflow;
                    ToolTip = 'Set up an approval workflow for creating or changing customers, by going through a few pages that will guide you.';

                    trigger OnAction()
                    begin
                        Page.RunModal(Page::"Cust. Approval WF Setup Wizard");
                        SetWorkflowManagementEnabledState;
                    end;
                }
                action(ManageApprovalWorkflows)
                {
                    ApplicationArea = Suite;
                    Caption = 'Manage Approval Workflows';
                    Enabled = EnabledApprovalWorkflowsExist;
                    Image = WorkflowSetup;
                    ToolTip = 'View or edit existing approval workflows for creating or changing customers.';

                    trigger OnAction()
                    var
                        WorkflowManagement: Codeunit "Workflow Management";
                    begin
                        WorkflowManagement.NavigateToWorkflows(Database::Customer,EventFilter);
                        SetWorkflowManagementEnabledState;
                    end;
                }
            }
            action("Cash Receipt Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cash Receipt Journal";
            }
            action("Sales Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Journal";
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(AssignTaxArea)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Assign Tax Area';
                    Image = RefreshText;
                    RunObject = Report "Assign Tax Area to Customer";
                    ToolTip = 'Assign a tax area to the customer to manage sales tax.';
                }
            }
        }
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';
                group(SalesReports)
                {
                    Caption = 'Sales Reports';
                    Image = "Report";
                    action("Customer - Top 10 List")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer - Top 10 List';
                        Image = "Report";
                        RunObject = Report "Customer - Top 10 List";
                        ToolTip = 'View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.';
                    }
                    action("Customer - Sales List")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer - Sales List';
                        Image = "Report";
                        RunObject = Report "Customer - Sales List";
                        ToolTip = 'View customer sales in a period, for example, to report sales activity to customs and tax authorities.';
                    }
                    action("Sales Statistics")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sales Statistics';
                        Image = "Report";
                        RunObject = Report "Customer Sales Statistics";
                        ToolTip = 'View customers'' total costs, sales, and profits over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted costs, sales, profits, invoice discounts, payment discounts, and profit percentage in three adjustable periods.';
                    }
                }
                group(FinanceReports)
                {
                    Caption = 'Finance Reports';
                    Image = "Report";
                    action(Action90)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Statement';
                        Image = "Report";
                        RunObject = Codeunit "Customer Layout - Statement";
                        ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
                    }
                    action("Customer - Balance to Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer - Balance to Date';
                        Image = "Report";
                        RunObject = Report "Customer - Balance to Date";
                        ToolTip = 'View, print, or save a customer''s balance on a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.';
                    }
                    action("Customer - Trial Balance")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Trial Balance';
                        Image = "Report";
                        RunObject = Report "Customer - Trial Balance";
                        ToolTip = 'View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.';
                    }
                    action("Customer - Detail Trial Bal.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer - Detail Trial Bal.';
                        Image = "Report";
                        RunObject = Report "Customer - Detail Trial Bal.";
                        ToolTip = 'View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.';
                    }
                    action("Customer - Summary Aging")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer - Summary Aging';
                        Image = "Report";
                        RunObject = Report "Customer - Summary Aging Simp.";
                        ToolTip = 'View, print, or save a summary of each customer''s total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer''s creditworthiness, or to prepare liquidity analyses.';
                    }
                    action("Aged Accounts Receivable")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Aged Accounts Receivable';
                        Image = "Report";
                        RunObject = Report "Aged Accounts Receivable";
                        ToolTip = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                    }
                    action("Customer - Payment Receipt")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Payment Receipt';
                        Image = "Report";
                        RunObject = Report "Customer - Payment Receipt";
                        ToolTip = 'View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.';
                    }
                }
            }
            group(General)
            {
                Caption = 'General';
                action("Customer Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Register';
                    Image = "Report";
                    RunObject = Report "Customer Register";
                }
                action(Action1907152806)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Top 10 List';
                    Image = "Report";
                    RunObject = Report "Customer - Top 10 List";
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;
                action("Customer - Order Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Order Summary';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Customer - Order Summary";
                }
                action("Customer - Order Detail")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Order Detail';
                    Image = "Report";
                    RunObject = Report "Customer - Order Detail";
                }
                action(Action1906073506)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Sales List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Customer - Sales List";
                }
                action(Action1904190506)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Statistics';
                    Image = "Report";
                    RunObject = Report "Customer Sales Statistics";
                }
            }
            group(Finance)
            {
                Caption = 'Finance';
                Image = "Report";
                action(Action1906871306)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Detail Trial Bal.';
                    Image = "Report";
                    RunObject = Report "Customer - Detail Trial Bal.";
                }
                action(Statement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Codeunit "Customer Layout - Statement";
                }
                action(Reminder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reminder';
                    Image = Reminder;
                    RunObject = Report Reminder;
                }
                action(Action1900711606)
                {
                    ApplicationArea = Basic;
                    Caption = 'Aged Accounts Receivable';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Aged Accounts Receivable";
                }
                action(Action1902299006)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Balance to Date';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Customer - Balance to Date";
                }
                action(Action1906359306)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Trial Balance';
                    Image = "Report";
                    RunObject = Report "Customer - Trial Balance";
                }
                action(Action1904039606)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Payment Receipt';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Customer - Payment Receipt";
                }
                action("Update Cust Ledger")
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    begin
                        CustLedger.Reset;
                        CustLedger.SetRange("Customer No.",Rec."No.");
                        if CustLedger.FindSet then begin
                          repeat
                            CustLedger."Customer posting Group":=Rec."Customer Posting Group";
                            CustLedger.Modify;

                            until CustLedger.Next=0;
                          end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        SetSocialListeningFactboxVisibility;

        CRMIsCoupledToRecord :=
          CRMCouplingManagement.IsRecordCoupledToCRM(RecordId) and CRMIntegrationEnabled;
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;

    trigger OnAfterGetRecord()
    begin
        SetSocialListeningFactboxVisibility;
    end;

    trigger OnInit()
    begin
        SetCustomerNoVisibilityOnFactBoxes;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

        SetWorkflowManagementEnabledState;
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SocialListeningSetupVisible: Boolean;
        SocialListeningVisible: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        EventFilter: Text;
        CustLedger: Record "Detailed Cust. Ledg. Entry";


    procedure GetSelectionFilter(): Text
    var
        Cust: Record Customer;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Cust);
        exit(SelectionFilterManagement.GetSelectionFilterForCustomer(Cust));
    end;


    procedure SetSelection(var Cust: Record Customer)
    begin
        CurrPage.SetSelectionFilter(Cust);
    end;

    local procedure SetSocialListeningFactboxVisibility()
    var
        SocialListeningMgt: Codeunit "Social Listening Management";
    begin
        SocialListeningMgt.GetCustFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    end;

    local procedure SetCustomerNoVisibilityOnFactBoxes()
    begin
        CurrPage.SalesHistSelltoFactBox.Page.SetCustomerNoVisibility(false);
        CurrPage.SalesHistBilltoFactBox.Page.SetCustomerNoVisibility(false);
        CurrPage.CustomerDetailsFactBox.Page.SetCustomerNoVisibility(false);
        CurrPage.CustomerStatisticsFactBox.Page.SetCustomerNoVisibility(false);
    end;

    local procedure SetWorkflowManagementEnabledState()
    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
          WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(Database::Customer,EventFilter);
    end;
}

