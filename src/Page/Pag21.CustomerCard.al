#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 21 "Customer Card"
{
    Caption = 'Customer Card';
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,New Document,Approve,Request Approval,Prices and Discounts,Navigate,Customer';
    RefreshOnActivate = true;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                    Visible = NoFieldVisible;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.';
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies an alternate name that you can use to search for a customer.';
                    Visible = false;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s IC partner code, if the customer is one of your intercompany partners.';
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
                field("Credit Limit (LCY)";"Credit Limit (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';

                    trigger OnValidate()
                    begin
                        StyleTxt := SetStyle;
                    end;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which transactions with the customer that cannot be blocked, for example, because the customer is insolvent.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies a code for the salesperson who normally handles this customer''s account.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the responsibility center that will administer this customer by default.';
                }
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Contains the code for the service zone that is assigned to the customer.';
                }
                field(BlockedCustomer;BlockedCustomer)
                {
                    ApplicationArea = All;
                    Caption = 'Blocked';
                    Enabled = DynamicEditable;
                    OptionCaption = ' ,,,All';
                    ToolTip = 'Specifies if transactions with the customer are blocked, for example, because the customer is insolvent.';
                    Visible = FoundationOnly;

                    trigger OnValidate()
                    begin
                        if BlockedCustomer then
                          Blocked := Blocked::All
                        else
                          Blocked := Blocked::" ";
                    end;
                }
                field("Document Sending Profile";"Document Sending Profile")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the preferred method of sending documents to this customer, so that you do not have to select a sending option every time that you post and send a document to the customer. Sales documents to this customer will be sent using the specified sending profile and will override the default document sending profile.';
                }
                field(TotalSales2;GetTotalSales)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Total Sales';
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies your total sales turnover with the customer in the current fiscal year. It is calculated from amounts excluding tax on all completed and open invoices and credit memos.';
                }
                field("Customer Type";"Customer Type")
                {
                    ApplicationArea = Basic;
                }
                field("CustSalesLCY - CustProfit - AdjmtCostLCY";CustSalesLCY - CustProfit - AdjmtCostLCY)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Costs ($)';
                    ToolTip = 'Specifies how much cost you have incurred from the customer in the current fiscal year.';
                }
                field(AdjCustProfit;AdjCustProfit)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies how much profit you have made from the customer in the current fiscal year.';
                }
                field(AdjProfitPct;AdjProfitPct)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies how much profit you have made from the customer in the current fiscal year, expressed as a percentage of the customer’s total sales.';
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the language to be used on printouts for this customer.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the customer card was last modified.';
                }
            }
            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                group(AddressDetails)
                {
                    Caption = 'Address';
                    field(Address;Address)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                    }
                    field("Address 2";"Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field(City;City)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the customer''s city.';
                    }
                    field(County;County)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Post Code";"Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Country/Region Code";"Country/Region Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap;ShowMapLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the customer''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.Update(true);
                            DisplayMap;
                        end;
                    }
                }
                group(ContactDetails)
                {
                    Caption = 'Contact';
                    field("Primary Contact No.";"Primary Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Primary Contact Code';
                        ToolTip = 'Specifies the primary contact number for the customer.';
                    }
                    field(ContactName;Contact)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact Name';
                        Editable = ContactEditable;
                        Importance = Promoted;
                        ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';

                        trigger OnValidate()
                        begin
                            ContactOnAfterValidate;
                        end;
                    }
                    field("Phone No.";"Phone No.")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the customer''s telephone number.';
                    }
                    field("E-Mail";"E-Mail")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the customer''s email address.';
                    }
                    field("Fax No.";"Fax No.")
                    {
                        ApplicationArea = Basic;
                        Importance = Additional;
                        ToolTip = 'Specifies the customer''s fax number.';
                    }
                    field("Home Page";"Home Page")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the customer''s home page address.';
                    }
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Importance = Additional;
                    ToolTip = 'Specifies a different customer who will be invoiced for products that you sell to the customer in the Name field on the customer card.';
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s tax registration number for customers in EU countries/regions.';

                    trigger OnDrillDown()
                    var
                        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
                    begin
                    end;
                }
                field(GLN;GLN)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer in connection with electronic document sending.';
                }
                field("Copy Sell-to Addr. to Qte From";"Copy Sell-to Addr. to Qte From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which customer address is inserted on sales quotes that you create for the customer.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                    Visible = UseSalesTax;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                    Visible = UseSalesTax;
                }
                field("Tax Identification Type";"Tax Identification Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax identification type for the customer. This information is used for tax reporting. The identification type used for a customer depends on whether the customer is classified as a company or as a person.';
                }
                field("Tax Exemption No.";"Tax Exemption No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s tax exemption number. If the customer has been registered exempt for sales and use tax this number would have been assigned by the taxing authority.';
                }
                field("RFC No.";"RFC No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the federal registration number for taxpayers.';
                    Visible = CountryCodeIsMX;
                }
                field("CURP No.";"CURP No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the unique fiscal card identification number. The CURP number must contain 18 digits.';
                    Visible = CountryCodeIsMX;
                }
                field("State Inscription";"State Inscription")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax ID number that is assigned by state tax authorities to every person or corporation.';
                    Visible = CountryCodeIsMX;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the customer''s trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s tax specification to link transactions made for this customer to.';
                    Visible = UseVAT;
                }
                field("Customer Posting Group";"Customer Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                }
                field("Invoice Copies";"Invoice Copies")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how many copies of a invoice for the customer will be printed at a time.';
                }
                group(PricesandDiscounts)
                {
                    Caption = 'Prices and Discounts';
                    field("Currency Code";"Currency Code")
                    {
                        ApplicationArea = Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the default currency for the customer.';
                    }
                    field("Customer Price Group";"Customer Price Group")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the customer price group code, which you can use to set up special sales prices in the Sales Prices window.';
                    }
                    field("Customer Disc. Group";"Customer Disc. Group")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.';
                    }
                    field("Allow Line Disc.";"Allow Line Disc.")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies if a sales line discount is calculated when a special sales price is offered according to setup in the Sales Prices window.';
                    }
                    field("Invoice Disc. Code";"Invoice Disc. Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        NotBlank = true;
                        ToolTip = 'Specifies a code for the invoice discount terms that you have defined for the customer.';
                    }
                    field("Prices Including VAT";"Prices Including VAT")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies if the Unit Price and Line Amount fields on sales lines for this customer should be shown with or without tax.';
                        Visible = UseVAT;
                    }
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Prepayment %";"Prepayment %")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Contains a prepayment percentage that applies to all orders for this customer, regardless of the items or services on the order lines.';
                }
                field("Application Method";"Application Method")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how to apply payments to entries for this customer.';
                }
                field("Partner Type";"Partner Type")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies for direct debit collections if the customer that the payment is collected from is a person or a company.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a code that indicates the payment terms that you require of the customer.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how the customer usually submits payment, such as bank transfer or check.';
                }
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies how reminders about late payments are handled for this customer.';
                }
                field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies finance charges are calculated for the customer.';
                }
                field("Cash Flow Payment Terms Code";"Cash Flow Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies a payment term that will be used to calculate cash flow for the customer.';
                }
                field("Print Statements";"Print Statements")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to include this customer when you print the Statement report.';
                }
                field("Last Statement No.";"Last Statement No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the last statement that was printed for this customer.';
                }
                field("Block Payment Tolerance";"Block Payment Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that the customer is not allowed a payment tolerance.';
                }
                field("Preferred Bank Account Code";"Preferred Bank Account Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s bank account that will be used by default when you process refunds to the customer and direct debit collections.';
                }
                field("Bank Communication";"Bank Communication")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the language of the check image.';
                }
                field("Check Date Format";"Check Date Format")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how the date will appear on the printed check image for this bank account.';
                }
                field("Check Date Separator";"Check Date Separator")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the character that separates Month, Day and Year of the date that prints on the check image.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies from which location sales to this customer will be processed by default.';
                }
                field("Combine Shipments";"Combine Shipments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if several orders delivered to the customer can appear on the same sales invoice.';
                }
                field(Reserve;Reserve)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether items will never, automatically (Always), or optionally be reserved for this customer.';
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies if the customer accepts partial shipment of orders.';
                }
                group("Shipment Method")
                {
                    Caption = 'Shipment Method';
                    field("Shipment Method Code";"Shipment Method Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Code';
                        Importance = Promoted;
                        ToolTip = 'Specifies which shipment method to use when you ship items to the customer.';
                    }
                    field("Shipping Agent Code";"Shipping Agent Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Agent';
                        Importance = Additional;
                        ToolTip = 'Specifies which shipping company is used when you ship items to the customer.';
                    }
                    field("Shipping Agent Service Code";"Shipping Agent Service Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Agent Service';
                        Importance = Additional;
                        ToolTip = 'Specifies the code for the shipping agent service to use for this customer.';
                    }
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the shipping time of the order.';
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies a customizable calendar for shipment planning that holds the customer''s working days and holidays.';
                }
                field("Customized Calendar";CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."source type"::Customer,"No.",'',"Base Calendar Code"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized Calendar';
                    Editable = false;
                    ToolTip = 'Specifies that you have set up a customized version of a base calendar.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        TestField("Base Calendar Code");
                        CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."source type"::Customer,"No.",'',"Base Calendar Code");
                    end;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                Editable = false;
                Visible = FoundationOnly;
                group(Balance)
                {
                    Caption = 'Balance';
                    field("Balance (LCY)2";"Balance (LCY)")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Money Owed - Current';
                        ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
                    }
                    field(GetMoneyOwedExpected;GetMoneyOwedExpected)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Money Owed - Expected';
                        Importance = Additional;
                        ToolTip = 'Specifies the payment amount that the customer will owe when ongoing sales invoices and credit memos are completed.';

                        trigger OnDrillDown()
                        begin
                            CustomerMgt.DrillDownMoneyOwedExpected("No.");
                        end;
                    }
                    field(TotalMoneyOwed;"Balance (LCY)" + GetMoneyOwedExpected)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Money Owed - Total';
                        Style = Strong;
                        StyleExpr = true;
                        ToolTip = 'Specifies the payment amount that the customer owes for completed sales plus sales that are still ongoing. The value is the sum of the values in the Money Owed - Current and Money Owed - Expected fields.';
                    }
                    field(CreditLimit;"Credit Limit (LCY)")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Credit Limit';
                        ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
                    }
                    field(CalcCreditLimitLCYExpendedPct;CalcCreditLimitLCYExpendedPct)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Usage Of Credit Limit';
                        ExtendedDatatype = Ratio;
                        Style = Attention;
                        StyleExpr = BalanceExhausted;
                        ToolTip = 'Specifies how much of the customer’s payment balance consists of credit.';
                    }
                }
                group(Control108)
                {
                    Caption = 'Payments';
                    field("Balance Due";CalcOverdueBalance)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionClass = FORMAT(STRSUBSTNO(OverduePaymentsMsg,FORMAT(WORKDATE)));
                        ToolTip = 'Specifies the sum of outstanding payments from the customer.';

                        trigger OnDrillDown()
                        var
                            DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                            CustLedgEntry: Record "Cust. Ledger Entry";
                        begin
                            DtldCustLedgEntry.SetFilter("Customer No.","No.");
                            Copyfilter("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                            Copyfilter("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                            Copyfilter("Currency Filter",DtldCustLedgEntry."Currency Code");
                            CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                        end;
                    }
                    field("Payments (LCY)";"Payments (LCY)")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Payments This Year';
                        ToolTip = 'Specifies the sum of payments received from the customer in the current fiscal year.';
                    }
                    field("CustomerMgt.AvgDaysToPay(""No."")";CustomerMgt.AvgDaysToPay("No."))
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Average Collection Period (Days)';
                        DecimalPlaces = 0:1;
                        Importance = Additional;
                        ToolTip = 'Specifies how long the customer typically takes to pay invoices in the current fiscal year.';
                    }
                    field(DaysPaidPastDueDate;DaysPastDueDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Average Late Payments (Days)';
                        DecimalPlaces = 0:1;
                        Importance = Additional;
                        Style = Attention;
                        StyleExpr = AttentionToPaidDay;
                        ToolTip = 'Specifies the average number of days the customer is late with payments.';
                    }
                }
                group("Sales This Year")
                {
                    Caption = 'Sales This Year';
                    field(GetAmountOnPostedInvoices;GetAmountOnPostedInvoices)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionClass = STRSUBSTNO(PostedInvoicesMsg,FORMAT(NoPostedInvoices));
                        ToolTip = 'Specifies your sales to the customer in the current fiscal year based on posted sales invoices. The figure in parenthesis Specifies the number of posted sales invoices.';

                        trigger OnDrillDown()
                        begin
                            CustomerMgt.DrillDownOnPostedInvoices("No.")
                        end;
                    }
                    field(GetAmountOnCrMemo;GetAmountOnCrMemo)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionClass = STRSUBSTNO(CreditMemosMsg,FORMAT(NoPostedCrMemos));
                        ToolTip = 'Specifies your expected refunds to the customer in the current fiscal year based on posted sales credit memos. The figure in parenthesis shows the number of posted sales credit memos.';

                        trigger OnDrillDown()
                        begin
                            CustomerMgt.DrillDownOnPostedCrMemo("No.")
                        end;
                    }
                    field(GetAmountOnOutstandingInvoices;GetAmountOnOutstandingInvoices)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionClass = STRSUBSTNO(OutstandingInvoicesMsg,FORMAT(NoOutstandingInvoices));
                        ToolTip = 'Specifies your expected sales to the customer in the current fiscal year based on ongoing sales invoices. The figure in parenthesis shows the number of ongoing sales invoices.';

                        trigger OnDrillDown()
                        begin
                            CustomerMgt.DrillDownOnUnpostedInvoices("No.")
                        end;
                    }
                    field(GetAmountOnOutstandingCrMemos;GetAmountOnOutstandingCrMemos)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionClass = STRSUBSTNO(OutstandingCrMemosMsg,FORMAT(NoOutstandingCrMemos));
                        ToolTip = 'Specifies your refunds to the customer in the current fiscal year based on ongoing sales credit memos. The figure in parenthesis shows the number of ongoing sales credit memos.';

                        trigger OnDrillDown()
                        begin
                            CustomerMgt.DrillDownOnUnpostedCrMemos("No.")
                        end;
                    }
                    field(Totals;Totals)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Total Sales';
                        Style = Strong;
                        StyleExpr = true;
                        ToolTip = 'Specifies your total sales turnover with the customer in the current fiscal year. It is calculated from amounts excluding tax on all completed and open invoices and credit memos.';
                    }
                    field(CustInvDiscAmountLCY;CustInvDiscAmountLCY)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Invoice Discounts';
                        ToolTip = 'Specifies the total of all invoice discounts that you have granted to the customer in the current fiscal year.';
                    }
                }
                part(AgedAccReceivableChart;"Aged Acc. Receivable Chart")
                {
                    SubPageLink = "No."=field("No.");
                    Visible = ShowCharts;
                }
            }
            part(PriceAndLineDisc;"Sales Price and Line Discounts")
            {
                ApplicationArea = All;
                Caption = 'Special Prices & Discounts';
                Visible = FoundationOnly;
            }
        }
        area(factboxes)
        {
            part(Control149;"Customer Picture")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("No.");
                Visible = not IsOfficeAddin;
            }
            part(Control135;"Office Customer Details")
            {
                ApplicationArea = All;
                Caption = 'Details';
                SubPageLink = "No."=field("No.");
                Visible = IsOfficeAddin;
            }
            part(AgedAccReceivableChart2;"Aged Acc. Receivable Chart")
            {
                ApplicationArea = All;
                SubPageLink = "No."=field("No.");
                Visible = IsOfficeAddin;
            }
            part(Control39;"CRM Statistics FactBox")
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
            part(Control27;"Social Listening Setup FactBox")
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
            part(Control1905532107;"Dimensions FactBox")
            {
                SubPageLink = "Table ID"=const(18),
                              "No."=field("No.");
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
            part(WorkflowStatus;"Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
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
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(18),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    RunObject = Page "Customer Bank Account List";
                    RunPageLink = "Customer No."=field("No.");
                    ToolTip = 'View or set up the customer''s bank accounts. You can set up any number of bank accounts for each customer.';
                }
                action("Direct Debit Mandates")
                {
                    ApplicationArea = Basic;
                    Caption = 'Direct Debit Mandates';
                    Image = MakeAgreement;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    RunObject = Page "SEPA Direct Debit Mandates";
                    RunPageLink = "Customer No."=field("No.");
                    ToolTip = 'View the direct-debit mandates that reflect agreements with customers to collect invoice payments from their bank account.';
                }
                action(ShipToAddresses)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ship-&to Addresses';
                    Image = ShipAddress;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    RunObject = Page "Ship-to Address List";
                    RunPageLink = "Customer No."=field("No.");
                    ToolTip = 'View or edit alternate shipping addresses where the customer wants items delivered if different from the regular address.';
                }
                action(Contact)
                {
                    AccessByPermission = TableData Contact=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'C&ontact';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View or edit detailed information about the contact person at the customer.';

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
                action("Cross Re&ferences")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cross Re&ferences';
                    Image = Change;
                    RunObject = Page "Cross References";
                    RunPageLink = "Cross-Reference Type"=const(Customer),
                                  "Cross-Reference Type No."=field("No.");
                    RunPageView = sorting("Cross-Reference Type","Cross-Reference Type No.");
                    ToolTip = 'Set up the customer''s own identification of items that you sell to the customer. Cross-references to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
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
                action(ApprovalEntries)
                {
                    AccessByPermission = TableData "Approval Entry"=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);
                    end;
                }
                action(CustomerReportSelections)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document Layouts';
                    Image = Quote;
                    ToolTip = 'Set up a layout for different types of documents such as invoices, quotes, and credit memos.';

                    trigger OnAction()
                    var
                        CustomReportSelection: Record "Custom Report Selection";
                    begin
                        CustomReportSelection.SetRange("Source Type",Database::Customer);
                        CustomReportSelection.SetRange("Source No.","No.");
                        Page.RunModal(Page::"Customer Report Selections",CustomReportSelection);
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
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.UpdateOneNow(RecordId);
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
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageView = sorting("Customer No.")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action(Action76)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
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
                separator(Action140)
                {
                }
            }
            group("Prices and Discounts")
            {
                Caption = 'Prices and Discounts';
                action("Invoice &Discounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category7;
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code=field("Invoice Disc. Code");
                    ToolTip = 'Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.';
                }
                action(Prices)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type"=const(Customer),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                    ToolTip = 'View or set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
                action("Line Discounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type"=const(Customer),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                    ToolTip = 'Set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
            }
            group(ActionGroup82)
            {
                Caption = 'S&ales';
                Image = Sales;
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
                action("Recurring Sales Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring Sales Lines';
                    Ellipsis = true;
                    Image = CustomerCode;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category5;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Standard Customer Sales Codes";
                    RunPageLink = "Customer No."=field("No.");
                    ToolTip = 'Set up recurring sales lines for the customer, such as a monthly replenishment order, that can quickly be inserted on a sales document for the customer.';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Quotes)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page "Sales Quotes";
                    RunPageLink = "Sell-to Customer No."=field("No.");
                    RunPageView = sorting("Document Type","Sell-to Customer No.");
                    ToolTip = 'View a list of ongoing sales quotes for the customer.';
                }
                action(Orders)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Order List";
                    RunPageLink = "Sell-to Customer No."=field("No.");
                    RunPageView = sorting("Document Type","Sell-to Customer No.");
                    ToolTip = 'View a list of ongoing sales orders for the customer.';
                }
                action("Return Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Order List";
                    RunPageLink = "Sell-to Customer No."=field("No.");
                    RunPageView = sorting("Document Type","Sell-to Customer No.");
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
                        ToolTip = 'View the reminders that you have sent to the customer.';
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Finance Charge Memos';
                        Image = FinChargeMemo;
                        RunObject = Page "Issued Fin. Charge Memo List";
                        RunPageLink = "Customer No."=field("No.");
                        RunPageView = sorting("Customer No.","Posting Date");
                        ToolTip = 'View the finance charge memos that you have sent to the customer.';
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
                action("&Jobs")
                {
                    ApplicationArea = Basic;
                    Caption = '&Jobs';
                    Image = Job;
                    RunObject = Page "Job List";
                    RunPageLink = "Bill-to Customer No."=field("No.");
                    RunPageView = sorting("Bill-to Customer No.");
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
            action(NewBlanketSalesOrder)
            {
                AccessByPermission = TableData "Sales Header"=RIM;
                ApplicationArea = Basic;
                Caption = 'Blanket Sales Order';
                Image = BlanketOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page "Blanket Sales Order";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a blanket sales order for the customer.';
            }
            action(NewSalesQuote)
            {
                AccessByPermission = TableData "Sales Header"=RIM;
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Quote';
                Image = NewSalesQuote;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                RunObject = Page "Sales Quote";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a new sales quote where you offer items or services to a customer.';
            }
            action(NewSalesInvoice)
            {
                AccessByPermission = TableData "Sales Header"=RIM;
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Invoice';
                Image = NewSalesInvoice;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                RunObject = Page "Sales Invoice";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a sales invoice for the customer.';
            }
            action(NewSalesOrder)
            {
                AccessByPermission = TableData "Sales Header"=RIM;
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                RunObject = Page "Sales Order";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a sales order for the customer.';
            }
            action(NewSalesCreditMemo)
            {
                AccessByPermission = TableData "Sales Header"=RIM;
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Credit Memo';
                Image = CreditMemo;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                RunObject = Page "Sales Credit Memo";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a new sales credit memo to revert a posted sales invoice.';
            }
            action(NewSalesReturnOrder)
            {
                AccessByPermission = TableData "Sales Header"=RIM;
                ApplicationArea = Basic;
                Caption = 'Sales Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page "Sales Return Order";
                RunPageLink = "Sell-to Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a sales return order for the customer.';
            }
            action(NewServiceQuote)
            {
                AccessByPermission = TableData "Service Header"=RIM;
                ApplicationArea = Basic;
                Caption = 'Service Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page "Service Quote";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a service quote for the customer.';
            }
            action(NewServiceInvoice)
            {
                AccessByPermission = TableData "Service Header"=RIM;
                ApplicationArea = Basic;
                Caption = 'Service Invoice';
                Image = Invoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page "Service Invoice";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a service invoice for the customer.';
            }
            action(NewServiceOrder)
            {
                AccessByPermission = TableData "Service Header"=RIM;
                ApplicationArea = Basic;
                Caption = 'Service Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page "Service Order";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a service order for the customer.';
            }
            action(NewServiceCreditMemo)
            {
                AccessByPermission = TableData "Service Header"=RIM;
                ApplicationArea = Basic;
                Caption = 'Service Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page "Service Credit Memo";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a service credit memo for the customer.';
            }
            action(NewReminder)
            {
                AccessByPermission = TableData "Reminder Header"=RIM;
                ApplicationArea = Basic;
                Caption = 'Reminder';
                Image = Reminder;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page Reminder;
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a remainder for the customer.';
            }
            action(NewFinanceChargeMemo)
            {
                AccessByPermission = TableData "Finance Charge Memo Header"=RIM;
                ApplicationArea = Basic;
                Caption = 'Finance Charge Memo';
                Image = FinChargeMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page "Finance Charge Memo";
                RunPageLink = "Customer No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a finance charge memo for the customer.';
            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                Visible = OpenApprovalEntriesExistCurrUser;
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'View or add comments.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = (not OpenApprovalEntriesExist) and EnabledApprovalWorkflowsExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
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
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
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
                    ApplicationArea = Basic;
                    Caption = 'Create Approval Workflow';
                    Enabled = not EnabledApprovalWorkflowsExist;
                    Image = CreateWorkflow;
                    ToolTip = 'Set up an approval workflow for creating or changing customers, by going through a few pages that will guide you.';

                    trigger OnAction()
                    begin
                        Page.RunModal(Page::"Cust. Approval WF Setup Wizard");
                    end;
                }
                action(ManageApprovalWorkflows)
                {
                    ApplicationArea = Basic;
                    Caption = 'Manage Approval Workflows';
                    Enabled = EnabledApprovalWorkflowsExist;
                    Image = WorkflowSetup;
                    ToolTip = 'View or edit existing approval workflows for creating or changing customers.';

                    trigger OnAction()
                    var
                        WorkflowManagement: Codeunit "Workflow Management";
                    begin
                        WorkflowManagement.NavigateToWorkflows(Database::Customer,EventFilter);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Templates)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Templates';
                    Image = Template;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Config Templates";
                    RunPageLink = "Table ID"=const(18);
                    ToolTip = 'View or edit customer templates.';
                }
                action(ApplyTemplate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'Apply a customer template to quickly register this customer.';

                    trigger OnAction()
                    var
                        MiniCustomerTemplate: Record "Mini Customer Template";
                    begin
                        MiniCustomerTemplate.UpdateCustomerFromTemplate(Rec);
                    end;
                }
                action(SaveAsTemplate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Save as Template';
                    Ellipsis = true;
                    Image = Save;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    ToolTip = 'Save the customer card as a template that can be reused to create new customer cards. Customer templates contain preset information to help you fill fields on customer cards.';

                    trigger OnAction()
                    var
                        TempMiniCustomerTemplate: Record "Mini Customer Template" temporary;
                    begin
                        TempMiniCustomerTemplate.SaveAsTemplate(Rec);
                    end;
                }
            }
            action("Post Cash Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'Post Cash Receipts';
                Ellipsis = true;
                Image = CashReceiptJournal;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Cash Receipt Journal";
                ToolTip = 'Create a cash receipt journal line for the customer, for example, to post a payment receipt.';
            }
            action("Sales Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Journal';
                Image = Journals;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Journal";
            }
        }
        area(reporting)
        {
            action("Aged Accounts Receivable")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View, print, or save an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';

                trigger OnAction()
                begin
                    RunReport(Report::"Aged Accounts Receivable","No.");
                end;
            }
            action("Customer Labels")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer Labels';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'Create mailing labels with the customers'' names and addresses. The report can be used to send sales letters, for example.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer Labels","No.");
                end;
            }
            action("Customer Account Detail")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer Account Detail';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                ToolTip = 'View the detailed account activity for each customer for any period of time. The report lists all activity with running account balances, or only open items or only closed items with totals of either. The report can also show the application of payments to invoices.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer Account Detail","No.");
                end;
            }
            action("Cash Applied")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Cash Applied';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View how the cash received from customers has been applied to documents. The report includes the number of the document and type of document to which the payment has been applied.';

                trigger OnAction()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgerEntry.SetRange("Customer No.","No.");
                    Report.Run(Report::"Cash Applied",true,true,CustLedgerEntry);
                end;
            }
            action("Open Customer Entries")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Open Customer Entries';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                ToolTip = 'View the aged remaining balances for each customer. Customer transactions are listed by date or due date.';

                trigger OnAction()
                begin
                    RunReport(Report::"Open Customer Entries","No.");
                end;
            }
            action("Customer/Item Statistics")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer/Item Statistics';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View statistics about what items have been purchased by which customers.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer/Item Statistics","No.");
                end;
            }
            action("Customer Jobs (Cost)")
            {
                ApplicationArea = Jobs;
                Caption = 'Customer Jobs (Cost)';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View jobs and job costs by customer. The report only includes jobs that are marked as completed.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer Jobs (Cost)","No.");
                end;
            }
            action("Customer Jobs (Price)")
            {
                ApplicationArea = Jobs;
                Caption = 'Customer Jobs (Price)';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View jobs and job prices by customer. The report only includes jobs that are marked as completed.';

                trigger OnAction()
                begin
                    RunReport(Report::"Customer Jobs (Price)","No.");
                end;
            }
            action("Report Statement")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Statement';
                Image = "Report";
                RunObject = Codeunit "Customer Layout - Statement";
                ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        CreateCustomerFromTemplate;
        ActivateFields;
        StyleTxt := SetStyle;
        ShowWorkflowStatus := CurrPage.WorkflowStatus.Page.SetFilterOnWorkflowRecord(RecordId);
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        GetSalesPricesAndSalesLineDisc;
        DynamicEditable := CurrPage.Editable;

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);

        EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
          WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(Database::Customer,EventFilter);
    end;

    trigger OnAfterGetRecord()
    var
        AgedAccReceivable: Codeunit "Aged Acc. Receivable";
    begin
        ActivateFields;
        StyleTxt := SetStyle;
        BlockedCustomer := (Blocked = Blocked::All);
        BalanceExhausted := 10000 <= CalcCreditLimitLCYExpendedPct;
        DaysPastDueDate := AgedAccReceivable.InvoicePaymentDaysAverage("No.");
        AttentionToPaidDay := DaysPastDueDate > 0;
    end;

    trigger OnInit()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
    begin
        FoundationOnly := ApplicationAreaSetup.IsFoundationEnabled;

        SetCustomerNoVisibilityOnFactBoxes;

        ContactEditable := true;

        OpenApprovalEntriesExistCurrUser := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        if GuiAllowed then
          if "No." = '' then
            if DocumentNoVisibility.CustomerNoSeriesIsDefault then
              NewMode := true;
    end;

    trigger OnOpenPage()
    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        OfficeManagement: Codeunit "Office Management";
    begin
        ActivateFields;

        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        SetNoFieldVisible;
        IsOfficeAddin := OfficeManagement.IsAvailable;

        CurrPage.PriceAndLineDisc.Page.InitPage(false);

        ShowCharts := "No." <> '';
        if ShowCharts then begin
          CurrPage.AgedAccReceivableChart.Page.SetPerCustomer;
          CurrPage.AgedAccReceivableChart2.Page.SetPerCustomer;
        end;
        SetFilter("Date Filter",CustomerMgt.GetCurrentYearFilter);

        CompanyInfo.Get;
        CountryCodeIsMX := CompanyInfo."Country/Region Code" = 'MX';

        GLSetup.Get;
        UseVAT := GLSetup."VAT in Use";
        UseSalesTax := not UseVAT;
    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CustomizedCalendar: Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomerMgt: Codeunit "Customer Mgt.";
        StyleTxt: Text;
        BlockedCustomer: Boolean;
        [InDataSet]
        ContactEditable: Boolean;
        [InDataSet]
        SocialListeningSetupVisible: Boolean;
        [InDataSet]
        SocialListeningVisible: Boolean;
        [InDataSet]
        ShowCharts: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        NoFieldVisible: Boolean;
        BalanceExhausted: Boolean;
        AttentionToPaidDay: Boolean;
        DynamicEditable: Boolean;
        IsOfficeAddin: Boolean;
        NoPostedInvoices: Integer;
        NoPostedCrMemos: Integer;
        NoOutstandingInvoices: Integer;
        NoOutstandingCrMemos: Integer;
        Totals: Decimal;
        AmountOnPostedInvoices: Decimal;
        AmountOnPostedCrMemos: Decimal;
        AmountOnOutstandingInvoices: Decimal;
        AmountOnOutstandingCrMemos: Decimal;
        AdjmtCostLCY: Decimal;
        AdjCustProfit: Decimal;
        CustProfit: Decimal;
        AdjProfitPct: Decimal;
        CustInvDiscAmountLCY: Decimal;
        CustPaymentsLCY: Decimal;
        CustSalesLCY: Decimal;
        OverduePaymentsMsg: label 'Overdue Payments as of %1', Comment='Overdue Payments as of 27-02-2012';
        DaysPastDueDate: Decimal;
        PostedInvoicesMsg: label 'Posted Invoices (%1)', Comment='Invoices (5)';
        CreditMemosMsg: label 'Posted Credit Memos (%1)', Comment='Credit Memos (3)';
        OutstandingInvoicesMsg: label 'Ongoing Invoices (%1)', Comment='Ongoing Invoices (4)';
        OutstandingCrMemosMsg: label 'Ongoing Credit Memos (%1)', Comment='Ongoing Credit Memos (4)';
        ShowMapLbl: label 'Show on Map';
        FoundationOnly: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CountryCodeIsMX: Boolean;
        UseSalesTax: Boolean;
        UseVAT: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        NewMode: Boolean;
        EventFilter: Text;

    local procedure GetTotalSales(): Decimal
    begin
        NoPostedInvoices := 0;
        NoPostedCrMemos := 0;
        NoOutstandingInvoices := 0;
        NoOutstandingCrMemos := 0;
        Totals := 0;

        AmountOnPostedInvoices := CustomerMgt.CalcAmountsOnPostedInvoices("No.",NoPostedInvoices);
        AmountOnPostedCrMemos := CustomerMgt.CalcAmountsOnPostedCrMemos("No.",NoPostedCrMemos);

        AmountOnOutstandingInvoices := CustomerMgt.CalculateAmountsOnUnpostedInvoices("No.",NoOutstandingInvoices);
        AmountOnOutstandingCrMemos := CustomerMgt.CalculateAmountsOnUnpostedCrMemos("No.",NoOutstandingCrMemos);

        Totals := AmountOnPostedInvoices + AmountOnPostedCrMemos + AmountOnOutstandingInvoices + AmountOnOutstandingCrMemos;

        CustomerMgt.CalculateStatistic(
          Rec,
          AdjmtCostLCY,AdjCustProfit,AdjProfitPct,
          CustInvDiscAmountLCY,CustPaymentsLCY,CustSalesLCY,
          CustProfit);
        exit(Totals)
    end;

    local procedure GetAmountOnPostedInvoices(): Decimal
    begin
        exit(AmountOnPostedInvoices)
    end;

    local procedure GetAmountOnCrMemo(): Decimal
    begin
        exit(AmountOnPostedCrMemos)
    end;

    local procedure GetAmountOnOutstandingInvoices(): Decimal
    begin
        exit(AmountOnOutstandingInvoices)
    end;

    local procedure GetAmountOnOutstandingCrMemos(): Decimal
    begin
        exit(AmountOnOutstandingCrMemos)
    end;

    local procedure GetMoneyOwedExpected(): Decimal
    begin
        exit(CustomerMgt.CalculateAmountsWithVATOnUnpostedDocuments("No."))
    end;

    local procedure GetSalesPricesAndSalesLineDisc()
    begin
        if "No." <> CurrPage.PriceAndLineDisc.Page.GetLoadedCustNo then begin
          CurrPage.PriceAndLineDisc.Page.LoadCustomer(Rec);
          CurrPage.PriceAndLineDisc.Page.Update(false);
        end;
    end;

    local procedure ActivateFields()
    begin
        SetSocialListeningFactboxVisibility;
        ContactEditable := "Primary Contact No." = '';
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure SetSocialListeningFactboxVisibility()
    var
        SocialListeningMgt: Codeunit "Social Listening Management";
    begin
        SocialListeningMgt.GetCustFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    end;

    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        NoFieldVisible := DocumentNoVisibility.CustomerNoIsVisible;
    end;

    local procedure SetCustomerNoVisibilityOnFactBoxes()
    begin
        CurrPage.SalesHistSelltoFactBox.Page.SetCustomerNoVisibility(false);
        CurrPage.SalesHistBilltoFactBox.Page.SetCustomerNoVisibility(false);
        CurrPage.CustomerStatisticsFactBox.Page.SetCustomerNoVisibility(false);
    end;


    procedure RunReport(ReportNumber: Integer;CustomerNumber: Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("No.",CustomerNumber);
        Report.RunModal(ReportNumber,true,true,Customer);
    end;

    local procedure CreateCustomerFromTemplate()
    var
        MiniCustomerTemplate: Record "Mini Customer Template";
        Customer: Record Customer;
    begin
        if NewMode then begin
          if MiniCustomerTemplate.NewCustomerFromTemplate(Customer) then begin
            Copy(Customer);
            CurrPage.Update;
          end;
          NewMode := false;
        end;
    end;
}

