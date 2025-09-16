#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5343 "CRM Sales Order to Sales Order"
{

    trigger OnRun()
    begin
    end;

    var
        CannotCreateSalesOrderInNAVTxt: label 'The sales order cannot be created.';
        CannotFindCRMAccountForOrderErr: label 'The Dynamics CRM account for CRM sales order %1 does not exist.', Comment='%1=Dynamics CRM Sales Order Name';
        ItemDoesNotExistErr: label '%1 The item %2 does not exist.', Comment='%1= the text: "The sales order cannot be created.", %2=product name';
        NoCustomerErr: label '%1 There is no potential customer defined on the Dynamics CRM sales order %2.', Comment='%1= the text: "The Dynamics CRM Sales Order cannot be created.", %2=sales order title';
        CRMSynchHelper: Codeunit "CRM Synch. Helper";
        LastSalesLineNo: Integer;
        NotCoupledCustomerErr: label '%1 There is no customer coupled to Dynamics CRM account %2.', Comment='%1= the text: "The Dynamics CRM Sales Order cannot be created.", %2=account name';
        NotCoupledCRMProductErr: label '%1 The Dynamics CRM product %2 is not coupled to an item.', Comment='%1= the text: "The Dynamics CRM Sales Order cannot be created.", %2=product name';
        NotCoupledCRMResourceErr: label '%1 The Dynamics CRM resource %2 is not coupled to a resource.', Comment='%1= the text: "The Dynamics CRM Sales Order cannot be created.", %2=resource name';
        NotCoupledCRMSalesOrderErr: label 'The Dynamics CRM sales order %1 is not coupled.', Comment='%1=sales order number';
        NotCoupledSalesHeaderErr: label 'The sales order %1 is not coupled to Dynamics CRM.', Comment='%1=sales order number';
        OverwriteCRMDiscountQst: label 'There is a discount on the Dynamics CRM sales order, which will be overwritten by %1 settings. You will have the possibility to update the discounts directly on the sales order, after it is created. Do you want to continue?', Comment='%1 - product name';
        ResourceDoesNotExistErr: label '%1 The resource %2 does not exist.', Comment='%1= the text: "The Dynamics CRM Sales Order cannot be created.", %2=product name';
        WriteInProductDoesNotExistErr: label '%1 The write-in product %2 does not exist.', Comment='%1= the text: "The Dynamics CRM Sales Order cannot be created.", %2=product name';
        UnexpectedProductTypeErr: label '%1 Unexpected value of product type code for product %2. The supported values are: sales inventory, services.', Comment='%1= the text: "The Dynamics CRM Sales Order cannot be created.", %2=product name';
        ZombieCouplingErr: label 'Although the coupling from Dynamics CRM exists, the sales order had been manually deleted. If needed, please use the menu to create it again in %1.', Comment='%1 - product name';

    local procedure ApplySalesOrderDiscounts(CRMSalesorder: Record "CRM Salesorder";var SalesHeader: Record "Sales Header")
    var
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        CRMDiscountAmount: Decimal;
    begin
        // No discounts to apply
        if (CRMSalesorder.DiscountAmount = 0 ) and (CRMSalesorder.DiscountPercentage = 0) then
          exit;

        // Attempt to set the discount, if NAV general and customer settings allow it
        // Using CRM discounts
        CRMDiscountAmount := CRMSalesorder.TotalLineItemAmount - CRMSalesorder.TotalAmountLessFreight;
        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(CRMDiscountAmount,SalesHeader);

        // NAV settings (in G/L Setup as well as per-customer discounts) did not allow using the CRM discounts
        // Using NAV discounts
        // But the user will be able to manually update the discounts after the order is created in NAV
        if not Confirm(StrSubstNo(OverwriteCRMDiscountQst,ProductName.Short),true) then
          Error('');
    end;

    local procedure CopyCRMOptionFields(CRMSalesorder: Record "CRM Salesorder";var SalesHeader: Record "Sales Header")
    var
        CRMAccount: Record "CRM Account";
        CRMOptionMapping: Record "CRM Option Mapping";
    begin
        if CRMOptionMapping.FindRecordID(
             Database::"CRM Account",CRMAccount.FieldNo(Address1_ShippingMethodCode),CRMSalesorder.ShippingMethodCode)
        then
          SalesHeader.Validate(
            "Shipping Agent Code",
            CopyStr(CRMOptionMapping.GetRecordKeyValue,1,MaxStrLen(SalesHeader."Shipping Agent Code")));

        if CRMOptionMapping.FindRecordID(
             Database::"CRM Account",CRMAccount.FieldNo(PaymentTermsCode),CRMSalesorder.PaymentTermsCode)
        then
          SalesHeader.Validate(
            "Payment Terms Code",
            CopyStr(CRMOptionMapping.GetRecordKeyValue,1,MaxStrLen(SalesHeader."Payment Terms Code")));

        if CRMOptionMapping.FindRecordID(
             Database::"CRM Account",CRMAccount.FieldNo(Address1_FreightTermsCode),CRMSalesorder.FreightTermsCode)
        then
          SalesHeader.Validate(
            "Shipment Method Code",
            CopyStr(CRMOptionMapping.GetRecordKeyValue,1,MaxStrLen(SalesHeader."Shipment Method Code")));
    end;

    local procedure CopyBillToInformationIfNotEmpty(CRMSalesorder: Record "CRM Salesorder";var SalesHeader: Record "Sales Header")
    begin
        // If the Bill-To fields in CRM are all empty, then let NAV keep its standard behavior (takes Bill-To from the Customer information)
        if ((CRMSalesorder.BillTo_Line1 = '') and
            (CRMSalesorder.BillTo_Line2 = '') and
            (CRMSalesorder.BillTo_City = '') and
            (CRMSalesorder.BillTo_PostalCode = '') and
            (CRMSalesorder.BillTo_Country = '') and
            (CRMSalesorder.BillTo_StateOrProvince = ''))
        then
          exit;

        SalesHeader.Validate("Bill-to Address",Format(CRMSalesorder.BillTo_Line1,MaxStrLen(SalesHeader."Bill-to Address")));
        SalesHeader.Validate("Bill-to Address 2",Format(CRMSalesorder.BillTo_Line2,MaxStrLen(SalesHeader."Bill-to Address 2")));
        SalesHeader.Validate("Bill-to City",Format(CRMSalesorder.BillTo_City,MaxStrLen(SalesHeader."Bill-to City")));
        SalesHeader.Validate("Bill-to Post Code",Format(CRMSalesorder.BillTo_PostalCode,MaxStrLen(SalesHeader."Bill-to Post Code")));
        SalesHeader.Validate(
          "Bill-to Country/Region Code",Format(CRMSalesorder.BillTo_Country,MaxStrLen(SalesHeader."Bill-to Country/Region Code")));
        SalesHeader.Validate("Bill-to County",Format(CRMSalesorder.BillTo_StateOrProvince,MaxStrLen(SalesHeader."Bill-to County")));
    end;

    local procedure CopyShipToInformationIfNotEmpty(CRMSalesorder: Record "CRM Salesorder";var SalesHeader: Record "Sales Header")
    begin
        // If the Ship-To fields in CRM are all empty, then let NAV keep its standard behavior (takes Bill-To from the Customer information)
        if ((CRMSalesorder.ShipTo_Line1 = '') and
            (CRMSalesorder.ShipTo_Line2 = '') and
            (CRMSalesorder.ShipTo_City = '') and
            (CRMSalesorder.ShipTo_PostalCode = '') and
            (CRMSalesorder.ShipTo_Country = '') and
            (CRMSalesorder.ShipTo_StateOrProvince = ''))
        then
          exit;

        SalesHeader.Validate("Ship-to Address",Format(CRMSalesorder.ShipTo_Line1,MaxStrLen(SalesHeader."Ship-to Address")));
        SalesHeader.Validate("Ship-to Address 2",Format(CRMSalesorder.ShipTo_Line2,MaxStrLen(SalesHeader."Ship-to Address 2")));
        SalesHeader.Validate("Ship-to City",Format(CRMSalesorder.ShipTo_City,MaxStrLen(SalesHeader."Ship-to City")));
        SalesHeader.Validate("Ship-to Post Code",Format(CRMSalesorder.ShipTo_PostalCode,MaxStrLen(SalesHeader."Ship-to Post Code")));
        SalesHeader.Validate(
          "Ship-to Country/Region Code",Format(CRMSalesorder.ShipTo_Country,MaxStrLen(SalesHeader."Ship-to Country/Region Code")));
        SalesHeader.Validate("Ship-to County",Format(CRMSalesorder.ShipTo_StateOrProvince,MaxStrLen(SalesHeader."Ship-to County")));
    end;

    local procedure CoupledSalesHeaderExists(CRMSalesorder: Record "CRM Salesorder"): Boolean
    var
        SalesHeader: Record "Sales Header";
        CRMIntegrationRecord: Record "CRM Integration Record";
        NAVSalesHeaderRecordId: RecordID;
    begin
        if not IsNullGuid(CRMSalesorder.SalesOrderId) then
          if CRMIntegrationRecord.FindRecordIDFromID(CRMSalesorder.SalesOrderId,Database::"Sales Header",NAVSalesHeaderRecordId) then
            exit(SalesHeader.Get(NAVSalesHeaderRecordId));
    end;


    procedure CreateInNAV(CRMSalesorder: Record "CRM Salesorder";var SalesHeader: Record "Sales Header"): Boolean
    begin
        CRMSalesorder.TestField(StateCode,CRMSalesorder.Statecode::Submitted);
        exit(CreateNAVSalesOrder(CRMSalesorder,SalesHeader));
    end;

    local procedure CreateNAVSalesOrder(CRMSalesorder: Record "CRM Salesorder";var SalesHeader: Record "Sales Header"): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if IsNullGuid(CRMSalesorder.SalesOrderId) then
          exit;

        CreateSalesOrderHeader(CRMSalesorder,SalesHeader);
        CreateSalesOrderLines(CRMSalesorder,SalesHeader);
        ApplySalesOrderDiscounts(CRMSalesorder,SalesHeader);
        CRMIntegrationRecord.CoupleRecordIdToCRMID(SalesHeader.RecordId,CRMSalesorder.SalesOrderId);
        // Flag sales order has been submitted to NAV.
        SetLastBackOfficeSubmit(CRMSalesorder,Today);
        exit(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]

    procedure ClearLastBackOfficeSubmitOnSalesHeaderDelete(var Rec: Record "Sales Header";RunTrigger: Boolean)
    var
        CRMSalesorder: Record "CRM Salesorder";
        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        if CRMIntegrationManagement.IsCRMIntegrationEnabled then
          if CRMIntegrationRecord.FindIDFromRecordID(Rec.RecordId,CRMSalesorder.SalesOrderId) then begin
            CRMSalesorder.Find;
            SetLastBackOfficeSubmit(CRMSalesorder,0D);
          end;
    end;

    local procedure CreateSalesOrderHeader(CRMSalesorder: Record "CRM Salesorder";var SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        SalesHeader.Init;
        SalesHeader.Validate("Document Type",SalesHeader."document type"::Order);
        SalesHeader.Validate(Status,SalesHeader.Status::Open);
        SalesHeader.InitInsert;
        GetCoupledCustomer(CRMSalesorder,Customer);
        SalesHeader.Validate("Sell-to Customer No.",Customer."No.");
        SalesHeader.Validate("Your Reference",CopyStr(CRMSalesorder.OrderNumber,1,MaxStrLen(SalesHeader."Your Reference")));
        SalesHeader.Validate("Currency Code",CRMSynchHelper.GetNavCurrencyCode(CRMSalesorder.TransactionCurrencyId));
        SalesHeader.Validate("Requested Delivery Date",CRMSalesorder.RequestDeliveryBy);
        CopyBillToInformationIfNotEmpty(CRMSalesorder,SalesHeader);
        CopyShipToInformationIfNotEmpty(CRMSalesorder,SalesHeader);
        CopyCRMOptionFields(CRMSalesorder,SalesHeader);
        SalesHeader.Validate("Payment Discount %",CRMSalesorder.DiscountPercentage);
        SalesHeader.Insert;
    end;

    local procedure CreateSalesOrderLines(CRMSalesorder: Record "CRM Salesorder";SalesHeader: Record "Sales Header")
    var
        CRMSalesorderdetail: Record "CRM Salesorderdetail";
        SalesLine: Record "Sales Line";
    begin
        // If any of the products on the lines are not found in NAV, err
        CRMSalesorderdetail.SetRange(SalesOrderId,CRMSalesorder.SalesOrderId); // Get all sales order lines

        if CRMSalesorderdetail.FindSet then begin
          repeat
            InitializeSalesOrderLine(CRMSalesorderdetail,SalesHeader,SalesLine);
            SalesLine.Insert;
          until CRMSalesorderdetail.Next = 0;
        end else begin
          SalesLine.Validate("Document Type",SalesHeader."Document Type");
          SalesLine.Validate("Document No.",SalesHeader."No.");
        end;

        SalesLine.InsertFreightLine(CRMSalesorder.FreightAmount);
    end;


    procedure CRMIsCoupledToValidRecord(CRMSalesorder: Record "CRM Salesorder";NAVTableID: Integer): Boolean
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        exit(CRMIntegrationManagement.IsCRMIntegrationEnabled and
          CRMCouplingManagement.IsRecordCoupledToNAV(CRMSalesorder.SalesOrderId,NAVTableID) and
          CoupledSalesHeaderExists(CRMSalesorder));
    end;


    procedure GetCRMSalesOrder(var CRMSalesorder: Record "CRM Salesorder";YourReference: Text[35]): Boolean
    begin
        CRMSalesorder.SetRange(OrderNumber,YourReference);
        exit(CRMSalesorder.FindFirst)
    end;


    procedure GetCoupledCRMSalesorder(SalesHeader: Record "Sales Header";var CRMSalesorder: Record "CRM Salesorder")
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        CoupledCRMId: Guid;
    begin
        if SalesHeader.IsEmpty then
          Error(NotCoupledSalesHeaderErr,SalesHeader."No.");

        if not CRMIntegrationRecord.FindIDFromRecordID(SalesHeader.RecordId,CoupledCRMId) then
          Error(NotCoupledSalesHeaderErr,SalesHeader."No.");

        if CRMSalesorder.Get(CoupledCRMId) then
          exit;

        // If we reached this point, a zombie coupling exists but the sales order most probably was deleted manually by the user.
        CRMIntegrationRecord.RemoveCouplingToCRMID(CoupledCRMId,Database::"Sales Header");
        Error(ZombieCouplingErr,ProductName.Short);
    end;


    procedure GetCoupledCustomer(CRMSalesorder: Record "CRM Salesorder";var Customer: Record Customer): Boolean
    var
        CRMAccount: Record "CRM Account";
        CRMIntegrationRecord: Record "CRM Integration Record";
        NAVCustomerRecordId: RecordID;
        CRMAccountId: Guid;
    begin
        if IsNullGuid(CRMSalesorder.CustomerId) then
          Error(NoCustomerErr,CannotCreateSalesOrderInNAVTxt,CRMSalesorder.Description);

        // Get the ID of the CRM Account associated to the sales order. Works for both CustomerType(s): account, contact
        if not GetCRMAccountOfCRMSalesOrder(CRMSalesorder,CRMAccount) then
          Error(CannotFindCRMAccountForOrderErr,CRMSalesorder.Name);
        CRMAccountId := CRMAccount.AccountId;

        if not CRMIntegrationRecord.FindRecordIDFromID(CRMAccountId,Database::Customer,NAVCustomerRecordId) then
          Error(NotCoupledCustomerErr,CannotCreateSalesOrderInNAVTxt,CRMAccount.Name);

        exit(Customer.Get(NAVCustomerRecordId));
    end;


    procedure GetCoupledSalesHeader(CRMSalesorder: Record "CRM Salesorder";var SalesHeader: Record "Sales Header"): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        NAVSalesHeaderRecordId: RecordID;
    begin
        if IsNullGuid(CRMSalesorder.SalesOrderId) then
          Error(NotCoupledCRMSalesOrderErr,CRMSalesorder.OrderNumber);

        // Attempt to find the coupled sales header
        if not CRMIntegrationRecord.FindRecordIDFromID(CRMSalesorder.SalesOrderId,Database::"Sales Header",NAVSalesHeaderRecordId) then
          Error(NotCoupledCRMSalesOrderErr,CRMSalesorder.OrderNumber);

        if SalesHeader.Get(NAVSalesHeaderRecordId) then
          exit(true);

        // If we reached this point, a zombie coupling exists but the sales order most probably was deleted manually by the user.
        CRMIntegrationRecord.RemoveCouplingToCRMID(CRMSalesorder.SalesOrderId,Database::"Sales Header");
        Error(ZombieCouplingErr);
    end;


    procedure GetCRMAccountOfCRMSalesOrder(CRMSalesorder: Record "CRM Salesorder";var CRMAccount: Record "CRM Account"): Boolean
    var
        CRMContact: Record "CRM Contact";
    begin
        if CRMSalesorder.CustomerIdType = CRMSalesorder.Customeridtype::account then
          exit(CRMAccount.Get(CRMSalesorder.CustomerId));

        if CRMSalesorder.CustomerIdType = CRMSalesorder.Customeridtype::contact then
          if CRMContact.Get(CRMSalesorder.CustomerId) then
            exit(CRMAccount.Get(CRMContact.ParentCustomerId));
        exit(false);
    end;


    procedure GetCRMContactOfCRMSalesOrder(CRMSalesorder: Record "CRM Salesorder";var CRMContact: Record "CRM Contact"): Boolean
    begin
        if CRMSalesorder.CustomerIdType = CRMSalesorder.Customeridtype::contact then
          exit(CRMContact.Get(CRMSalesorder.CustomerId));
    end;

    local procedure InitializeSalesOrderLine(CRMSalesorderdetail: Record "CRM Salesorderdetail";SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    var
        CRMProduct: Record "CRM Product";
    begin
        if IsNullGuid(CRMSalesorderdetail.ProductId) then // This is a CRM write-in product, not supported in NAV
          Error(WriteInProductDoesNotExistErr,CannotCreateSalesOrderInNAVTxt,CRMSalesorderdetail.ProductDescription);
        CRMProduct.Get(CRMSalesorderdetail.ProductId);
        CRMProduct.TestField(StateCode,CRMProduct.Statecode::Active);

        SalesLine.Init;
        SalesLine.Validate("Document Type",SalesHeader."Document Type");
        SalesLine.Validate("Document No.",SalesHeader."No.");
        LastSalesLineNo := LastSalesLineNo + 10000;
        SalesLine.Validate("Line No.",LastSalesLineNo);

        case CRMProduct.ProductTypeCode of
          CRMProduct.Producttypecode::SalesInventory:
            InitializeSalesOrderLineFromItem(CRMProduct,SalesLine);
          CRMProduct.Producttypecode::Services:
            InitializeSalesOrderLineFromResource(CRMProduct,SalesLine);
          else
            Error(UnexpectedProductTypeErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.ProductNumber);
        end;

        SalesLine.Validate(Quantity,CRMSalesorderdetail.Quantity);
        SalesLine.Validate("Unit Price",CRMSalesorderdetail.PricePerUnit);
        SalesLine.Validate(Amount,CRMSalesorderdetail.BaseAmount);
        SalesLine.Validate(
          "Line Discount Amount",
          CRMSalesorderdetail.Quantity * CRMSalesorderdetail.VolumeDiscountAmount +
          CRMSalesorderdetail.ManualDiscountAmount);
    end;

    local procedure InitializeSalesOrderLineFromItem(CRMProduct: Record "CRM Product";var SalesLine: Record "Sales Line")
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        Item: Record Item;
        NAVItemRecordID: RecordID;
    begin
        // Attempt to find the coupled item
        if not CRMIntegrationRecord.FindRecordIDFromID(CRMProduct.ProductId,Database::Item,NAVItemRecordID) then
          Error(NotCoupledCRMProductErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.Name);

        if not Item.Get(NAVItemRecordID) then
          Error(ItemDoesNotExistErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.ProductNumber);
        SalesLine.Validate(Type,SalesLine.Type::Item);
        SalesLine.Validate("No.",Item."No.");
    end;

    local procedure InitializeSalesOrderLineFromResource(CRMProduct: Record "CRM Product";var SalesLine: Record "Sales Line")
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        Resource: Record Resource;
        NAVResourceRecordID: RecordID;
    begin
        // Attempt to find the coupled resource
        if not CRMIntegrationRecord.FindRecordIDFromID(CRMProduct.ProductId,Database::Resource,NAVResourceRecordID) then
          Error(NotCoupledCRMResourceErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.Name);

        if not Resource.Get(CRMProduct.ProductNumber) then
          Error(ResourceDoesNotExistErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.ProductNumber);
        SalesLine.Validate(Type,SalesLine.Type::Resource);
        SalesLine.Validate("No.",Resource."No.");
    end;

    local procedure SetLastBackOfficeSubmit(var CRMSalesorder: Record "CRM Salesorder";NewDate: Date)
    begin
        if CRMSalesorder.LastBackofficeSubmit <> NewDate then begin
          CRMSalesorder.LastBackofficeSubmit := NewDate;
          CRMSalesorder.Modify(true);
        end;
    end;
}

