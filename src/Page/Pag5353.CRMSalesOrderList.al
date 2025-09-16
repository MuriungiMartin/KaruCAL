#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5353 "CRM Sales Order List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Sales Orders';
    CardPageID = "CRM Sales Order";
    Editable = false;
    PageType = List;
    SourceTable = "CRM Salesorder";
    SourceTableView = where(StateCode=filter(Submitted),
                            LastBackofficeSubmit=filter(''));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Coupled;CRMIsCoupledToRecord)
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies if the Dynamics CRM record is coupled to Dynamics NAV.';
                }
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
                field(TransactionCurrencyIdName;TransactionCurrencyIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Transaction Currency';
                }
                field(PriceLevelIdName;PriceLevelIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Price List';
                    ToolTip = 'Specifies a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.';
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
                field(RequestDeliveryBy;RequestDeliveryBy)
                {
                    ApplicationArea = Suite;
                    Caption = 'Requested Delivery Date';
                }
                field(DateFulfilled;DateFulfilled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Date Fulfilled';
                    ToolTip = 'Specifies when the sales order was delivered.';
                }
                field(ShippingMethodCode;ShippingMethodCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Shipping Method';
                }
                field(PaymentTermsCode;PaymentTermsCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Payment Terms';
                    ToolTip = 'Specifies the payment terms that you select from on customer cards to define when the customer must pay, such as within 14 days.';
                }
                field(FreightTermsCode;FreightTermsCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Freight Terms';
                    ToolTip = 'Specifies the shipment method.';
                }
                field(BillTo_Composite;BillTo_Composite)
                {
                    ApplicationArea = Suite;
                    Caption = 'Bill To Address';
                    ToolTip = 'Specifies the address that the invoice will be sent to.';
                }
                field(WillCall;WillCall)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To';
                }
                field(ShipTo_Composite;ShipTo_Composite)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Address';
                }
                field(OpportunityIdName;OpportunityIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Opportunity';
                    ToolTip = 'Specifies the sales opportunity that is coupled to this Dynamics CRM opportunity.';
                }
                field(QuoteIdName;QuoteIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Quote';
                }
                field(GetCustomerName;GetCustomerName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Account';
                    ToolTip = 'Specifies the coupled Dynamics CRM account.';
                }
                field(ContactIdName;ContactIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the contact person at the customer.';
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
                action(CRMGoToSalesOrder)
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales Order';
                    Enabled = HasRecords;
                    Image = CoupledOrder;
                    RunPageOnRec = true;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM sales order.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        if IsEmpty then
                          exit;
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

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        CRMSalesOrderToSalesOrder: Codeunit "CRM Sales Order to Sales Order";
                    begin
                        if IsEmpty then
                          exit;

                        if not CRMSalesOrderToSalesOrder.GetCoupledSalesHeader(Rec,SalesHeader) then
                          Error(GetLastErrorText);

                        Page.RunModal(Page::"Sales Order",SalesHeader);
                        RecalculateRecordCouplingStatus;
                    end;
                }
                action(CreateInNAV)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create in Dynamics NAV';
                    Enabled = not CRMIsCoupledToRecord;
                    Image = New;
                    Promoted = true;
                    ToolTip = 'Create a sales order in Dynamics NAV that is coupled to the CRM entity.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        CRMSalesOrderToSalesOrder: Codeunit "CRM Sales Order to Sales Order";
                    begin
                        if IsEmpty then
                          exit;

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

    trigger OnAfterGetRecord()
    begin
        HasRecords := not IsEmpty;
    end;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        HasRecords: Boolean;

    local procedure GetCustomerName(): Text
    var
        CRMAccount: Record "CRM Account";
        CRMContact: Record "CRM Contact";
    begin
        if (CustomerIdType = Customeridtype::account) and (not IsNullGuid(CustomerId)) then begin
          if CRMAccount.Get(CustomerId) then
            exit(CRMAccount.Name);
        end else
          if CustomerIdType = Customeridtype::contact then
            if  CRMContact.Get(CustomerId) then
              if CRMAccount.Get(CRMContact.ParentCustomerId) then
                exit(CRMAccount.Name);
    end;

    local procedure RecalculateRecordCouplingStatus()
    var
        CRMSalesOrderToSalesOrder: Codeunit "CRM Sales Order to Sales Order";
    begin
        CRMIsCoupledToRecord := false;
        if CRMIntegrationEnabled then
          CRMIsCoupledToRecord := CRMSalesOrderToSalesOrder.CRMIsCoupledToValidRecord(Rec,Database::"Sales Header")
    end;
}

