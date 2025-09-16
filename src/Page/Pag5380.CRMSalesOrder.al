#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5380 "CRM Sales Order"
{
    Caption = 'Microsoft Dynamics CRM Sales Order';
    Editable = false;
    PageType = Document;
    SourceTable = "CRM Salesorder";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(OrderNumber;OrderNumber)
                {
                    ApplicationArea = Suite;
                    Caption = 'Order ID';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the record.';
                }
                field(Account;CRMAccountName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Account';
                    ToolTip = 'Specifies the coupled Dynamics CRM account.';

                    trigger OnDrillDown()
                    var
                        CRMAccount: Record "CRM Account";
                    begin
                        CRMAccount.SetRange(StateCode,CRMAccount.Statecode::Active);
                        Page.Run(Page::"CRM Account List",CRMAccount);
                    end;
                }
                field(Contact;CRMContactName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the contact person at the customer.';

                    trigger OnDrillDown()
                    var
                        CRMContact: Record "CRM Contact";
                    begin
                        CRMContact.SetRange(AccountId,AccountId);
                        CRMContact.SetRange(StateCode,CRMContact.Statecode::Active);
                        Page.Run(Page::"CRM Contact List",CRMContact);
                    end;
                }
                field("Date Fulfilled";DateFulfilled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Date Fulfilled';
                    ToolTip = 'Specifies when the sales order was delivered.';
                }
                field(StateCode;StateCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status';
                }
                field(StatusCode;StatusCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status Reason';
                }
                field(Opportunity;OpportunityIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Opportunity';
                    ToolTip = 'Specifies the sales opportunity that is coupled to this Dynamics CRM opportunity.';

                    trigger OnDrillDown()
                    var
                        CRMOpportunity: Record "CRM Opportunity";
                    begin
                        CRMOpportunity.SetRange(AccountId,AccountId);
                        Page.Run(Page::"CRM Opportunity List",CRMOpportunity);
                    end;
                }
                field(Quote;QuoteIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Quote';

                    trigger OnDrillDown()
                    var
                        CRMQuote: Record "CRM Quote";
                    begin
                        CRMQuote.SetRange(AccountId,AccountId);
                        CRMQuote.SetRange(StateCode,CRMQuote.Statecode::Active);
                        Page.Run(Page::"CRM Quote List",CRMQuote);
                    end;
                }
            }
            part(Lines;"CRM Sales Order Subform")
            {
                ApplicationArea = Suite;
                Caption = 'Lines';
                Editable = false;
                SubPageLink = SalesOrderId=field(SalesOrderId);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(PaymentTermsCode;PaymentTermsCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Payment Terms';
                    ToolTip = 'Specifies the payment terms that you select from on customer cards to define when the customer must pay, such as within 14 days.';
                }
                field("Price List";PriceLevelIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Price List';
                    ToolTip = 'Specifies a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.';

                    trigger OnDrillDown()
                    var
                        CRMPricelevel: Record "CRM Pricelevel";
                    begin
                        CRMPricelevel.SetRange(TransactionCurrencyId,TransactionCurrencyId);
                        CRMPricelevel.SetRange(StateCode,CRMPricelevel.Statecode::Active);
                        Page.Run(Page::"CRM Pricelevel List");
                    end;
                }
                field(IsPriceLocked;IsPriceLocked)
                {
                    ApplicationArea = Suite;
                    Caption = 'Prices Locked';
                }
                field(TotalAmount;TotalAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Total Amount';
                }
                field(TotalLineItemAmount;TotalLineItemAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Total Detail Amount';
                }
                field(TotalAmountLessFreight;TotalAmountLessFreight)
                {
                    ApplicationArea = Suite;
                    Caption = 'Total Pre-Freight Amount';
                    ToolTip = 'Specifies data from a corresponding field in a Dynamics CRM entity. ';
                }
                field(TotalDiscountAmount;TotalDiscountAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Total Discount Amount';
                }
                field(TotalTax;TotalTax)
                {
                    ApplicationArea = Suite;
                    Caption = 'Total Tax';
                    ToolTip = 'Specifies the sum of TAX amounts on all lines in the document.';
                }
                field(Currency;TransactionCurrencyIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency';
                    ToolTip = 'Specifies the currency that amounts are shown in.';

                    trigger OnDrillDown()
                    var
                        CRMTransactioncurrency: Record "CRM Transactioncurrency";
                    begin
                        CRMTransactioncurrency.SetRange(StateCode,CRMTransactioncurrency.Statecode::Active);
                        Page.Run(Page::"CRM TransactionCurrency List",CRMTransactioncurrency);
                    end;
                }
                field(DiscountAmount;DiscountAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Order Discount Amount';
                }
                field(DiscountPercentage;DiscountPercentage)
                {
                    ApplicationArea = Suite;
                    Caption = 'Order Discount (%)';
                }
                field(BillTo_Name;BillTo_Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Name';
                    ToolTip = 'Specifies the name at the address that the invoice will be sent to.';
                }
                field(BillTo_ContactName;BillTo_ContactName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Contact Name';
                    Importance = Additional;
                    ToolTip = 'Specifies the contact person at the address that the invoice will be sent to.';
                }
                field(BillTo_Line1;BillTo_Line1)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Street 1';
                    Importance = Additional;
                    ToolTip = 'Specifies the street of the address that the invoice will be sent to.';
                }
                field(BillTo_Line2;BillTo_Line2)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Street 2';
                    Importance = Additional;
                    ToolTip = 'Specifies the additional street information of the address that the invoice will be sent to.';
                }
                field(BillTo_Line3;BillTo_Line3)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Street 3';
                    Importance = Additional;
                    ToolTip = 'Specifies the additional street information of the address that the invoice will be sent to.';
                }
                field(BillTo_City;BillTo_City)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To City';
                    Importance = Additional;
                    ToolTip = 'Specifies the city of the address that the invoice will be sent to.';
                }
                field(BillTo_StateOrProvince;BillTo_StateOrProvince)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To State/Province';
                    Importance = Additional;
                    ToolTip = 'Specifies the state/province of the address that the invoice will be sent to.';
                }
                field(BillTo_Country;BillTo_Country)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Country/Region';
                    Importance = Additional;
                    ToolTip = 'Specifies the country/region of the address that the invoice will be sent to.';
                }
                field(BillTo_PostalCode;BillTo_PostalCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To ZIP/Postal Code';
                    Importance = Additional;
                    ToolTip = 'Specifies the ZIP/postal code of the address that the invoice will be sent to.';
                }
                field(BillTo_Telephone;BillTo_Telephone)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Phone';
                    ToolTip = 'Specifies the phone number at the address that the invoice will be sent to.';
                }
                field(BillTo_Fax;BillTo_Fax)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Fax';
                    Importance = Additional;
                    ToolTip = 'Specifies the fax number at the address that the invoice will be sent to.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field(RequestDeliveryBy;RequestDeliveryBy)
                {
                    ApplicationArea = Suite;
                    Caption = 'Requested Delivery Date';
                }
                field(ShippingMethodCode;ShippingMethodCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Shipping Method';
                }
                field(FreightTermsCode;FreightTermsCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Freight Terms';
                    ToolTip = 'Specifies the shipment method.';
                }
                field(ShipTo_Name;ShipTo_Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Name';
                }
                field(ShipTo_Line1;ShipTo_Line1)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Street 1';
                    Importance = Additional;
                }
                field(ShipTo_Line2;ShipTo_Line2)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Street 2';
                    Importance = Additional;
                }
                field(ShipTo_Line3;ShipTo_Line3)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Street 3';
                    Importance = Additional;
                }
                field(ShipTo_City;ShipTo_City)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To City';
                    Importance = Additional;
                }
                field(ShipTo_StateOrProvince;ShipTo_StateOrProvince)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To State/Province';
                    Importance = Additional;
                }
                field(ShipTo_Country;ShipTo_Country)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Country/Region';
                    Importance = Additional;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(ShipTo_PostalCode;ShipTo_PostalCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To ZIP/Postal Code';
                    Importance = Additional;
                }
                field(ShipTo_Telephone;ShipTo_Telephone)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Phone';
                    Importance = Additional;
                }
                field(ShipTo_Fax;ShipTo_Fax)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship to Fax';
                    Importance = Additional;
                }
                field(ShipTo_FreightTermsCode;ShipTo_FreightTermsCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Freight Terms';
                    Importance = Additional;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGoToSalesOrderHyperlink)
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales Order';
                    Enabled = CRMIntegrationEnabled;
                    Image = CoupledOrder;
                    ToolTip = 'Open the coupled Dynamics NAV sales order.';
                    Visible = CRMIntegrationEnabled;

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        Hyperlink(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(Database::"CRM Salesorder",SalesOrderId));
                    end;
                }
            }
            group(ActionGroupNAV)
            {
                Caption = 'Dynamics NAV';
                Visible = CRMIntegrationEnabled;
                action(NAVOpenSalesOrderCard)
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales Order';
                    Enabled = CRMIsCoupledToRecord;
                    Image = "Order";
                    ToolTip = 'Open the coupled Dynamics NAV sales order.';
                    Visible = CRMIntegrationEnabled;

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        CRMSalesOrderToSalesOrder: Codeunit "CRM Sales Order to Sales Order";
                    begin
                        if CRMSalesOrderToSalesOrder.GetCoupledSalesHeader(Rec,SalesHeader) then
                          Page.RunModal(Page::"Sales Order",SalesHeader)
                        else
                          Message(GetLastErrorText);
                        RecalculateRecordCouplingStatus;
                    end;
                }
                action(CreateInNAV)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create in Dynamics NAV';
                    Enabled = CRMIntegrationEnabled and not CRMIsCoupledToRecord;
                    Image = New;
                    Promoted = true;

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        CRMSalesOrderToSalesOrder: Codeunit "CRM Sales Order to Sales Order";
                    begin
                        if CRMSalesOrderToSalesOrder.CreateInNAV(Rec,SalesHeader) then begin
                          Commit;
                          CRMIsCoupledToRecord :=
                            CRMCouplingManagement.IsRecordCoupledToNAV(SalesOrderId,Database::"Sales Header") and CRMIntegrationEnabled;
                          Page.RunModal(Page::"Sales Order",SalesHeader);
                        end;
                        RecalculateRecordCouplingStatus;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        RecalculateRecordCouplingStatus;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        SetCRMAccountAndContactName;
    end;

    var
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        CRMAccountName: Text[160];
        CRMContactName: Text[160];

    local procedure SetCRMAccountAndContactName()
    var
        CRMAccount: Record "CRM Account";
        CRMContact: Record "CRM Contact";
        CRMSalesOrderToSalesOrder: Codeunit "CRM Sales Order to Sales Order";
    begin
        if CRMSalesOrderToSalesOrder.GetCRMAccountOfCRMSalesOrder(Rec,CRMAccount) then
          CRMAccountName := CRMAccount.Name;

        if CRMSalesOrderToSalesOrder.GetCRMContactOfCRMSalesOrder(Rec,CRMContact) then
          CRMContactName := CRMContact.FullName;
    end;

    local procedure RecalculateRecordCouplingStatus()
    var
        CRMSalesOrderToSalesOrder: Codeunit "CRM Sales Order to Sales Order";
    begin
        CRMIsCoupledToRecord := CRMSalesOrderToSalesOrder.CRMIsCoupledToValidRecord(Rec,Database::"Sales Header");
    end;
}

