#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5334 "CRM Setup Defaults"
{

    trigger OnRun()
    begin
    end;

    var
        JobQueueEntryNameTok: label ' %1 - Dynamics CRM synchronization job.', Comment='%1 = The Integration Table Name to synchronized (ex. CUSTOMER)';
        IntegrationTablePrefixTok: label 'Dynamics CRM', Comment='{Locked} Product name';
        CustomStatisticsSynchJobDescTxt: label 'Customer Statistics - Dynamics CRM synchronization job.';
        CRMAccountConfigTemplateCodeTok: label 'CRMACCOUNT', Comment='Config. Template code for CRM Accounts created from Customers. Max length 10.';
        CRMAccountConfigTemplateDescTxt: label 'New CRM Account records created during synch.', Comment='Max. length 50.';
        CustomerConfigTemplateCodeTok: label 'CRMCUST', Comment='Customer template code for new customers created from CRM data. Max length 10.';
        CustomerConfigTemplateDescTxt: label 'New Customer records created during synch.', Comment='Max. length 50.';


    procedure ResetConfiguration(CRMConnectionSetup: Record "CRM Connection Setup")
    var
        TempCRMConnectionSetup: Record "CRM Connection Setup" temporary;
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        ConnectionName: Text;
        EnqueueJobQueEntries: Boolean;
    begin
        EnqueueJobQueEntries := not CRMConnectionSetup.IsTestConnection;
        ConnectionName := RegisterTempConnectionIfNeeded(CRMConnectionSetup,TempCRMConnectionSetup);
        if ConnectionName <> '' then
          SetDefaultTableConnection(Tableconnectiontype::CRM,ConnectionName,true);

        ResetSalesPeopleSystemUserMapping('SALESPEOPLE',EnqueueJobQueEntries);
        ResetCustomerAccountMapping('CUSTOMER',EnqueueJobQueEntries);
        ResetContactContactMapping('CONTACT',EnqueueJobQueEntries);
        ResetCurrencyTransactionCurrencyMapping('CURRENCY',EnqueueJobQueEntries);
        ResetUnitOfMeasureUoMScheduleMapping('UNIT OF MEASURE',EnqueueJobQueEntries);
        ResetItemProductMapping('ITEM-PRODUCT',EnqueueJobQueEntries);
        ResetResourceProductMapping('RESOURCE-PRODUCT',EnqueueJobQueEntries);
        ResetCustomerPriceGroupPricelevelMapping('CUSTPRCGRP-PRICE',EnqueueJobQueEntries);
        ResetSalesPriceProductPricelevelMapping('SALESPRC-PRODPRICE');
        ResetSalesInvoiceHeaderInvoiceMapping('POSTEDSALESINV-INV',EnqueueJobQueEntries);
        ResetSalesInvoiceLineInvoiceMapping('POSTEDSALESLINE-INV');

        ResetShippingAgentMapping('SHIPPING AGENT');
        ResetShipmentMethodMapping('SHIPMENT METHOD');
        ResetPaymentTermsMapping('PAYMENT TERMS');

        RecreateStatisticsJobQueueEntry(EnqueueJobQueEntries);

        if CRMIntegrationManagement.IsCRMSolutionInstalled then
          ResetCRMNAVConnectionData;

        ResetDefaultCRMPricelevel(CRMConnectionSetup);

        if ConnectionName <> '' then
          TempCRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);
    end;

    local procedure ResetSalesPeopleSystemUserMapping(IntegrationTableMappingName: Code[20];ShouldRecreateJobQueueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CRMSystemuser: Record "CRM Systemuser";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Salesperson/Purchaser",Database::"CRM Systemuser",
          CRMSystemuser.FieldNo(SystemUserId),CRMSystemuser.FieldNo(ModifiedOn),
          '','',true);

        CRMSystemuser.Reset;
        CRMSystemuser.SetRange(IsDisabled,false);
        CRMSystemuser.SetRange(IsLicensed,true);
        IntegrationTableMapping.SetIntegrationTableFilter(
          GetTableFilterFromView(Database::"CRM Systemuser",CRMSystemuser.TableCaption,CRMSystemuser.GetView));
        IntegrationTableMapping.Modify;

        // Email > InternalEMailAddress
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalespersonPurchaser.FieldNo("E-Mail"),
          CRMSystemuser.FieldNo(InternalEMailAddress),
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          '',true,false);

        // Name > FullName
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalespersonPurchaser.FieldNo(Name),
          CRMSystemuser.FieldNo(FullName),
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          '',true,false);

        // Phone No. > MobilePhone
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalespersonPurchaser.FieldNo("Phone No."),
          CRMSystemuser.FieldNo(MobilePhone),
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          '',true,false);

        RecreateJobQueueEntry(IntegrationTableMapping,30,ShouldRecreateJobQueueEntry);
    end;

    local procedure ResetCustomerAccountMapping(IntegrationTableMappingName: Code[20];ShouldRecreateJobQueueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CRMAccount: Record "CRM Account";
        Customer: Record Customer;
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::Customer,Database::"CRM Account",
          CRMAccount.FieldNo(AccountId),CRMAccount.FieldNo(ModifiedOn),
          ResetCustomerConfigTemplate,ResetAccountConfigTemplate,true);

        CRMAccount.SetRange(StateCode,CRMAccount.Statecode::Active);
        CRMAccount.SetRange(CustomerTypeCode,CRMAccount.Customertypecode::Customer);
        IntegrationTableMapping.SetIntegrationTableFilter(
          GetTableFilterFromView(Database::"CRM Account",CRMAccount.TableCaption,CRMAccount.GetView));
        IntegrationTableMapping.Modify;

        // Name > Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo(Name),
          CRMAccount.FieldNo(Name),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Contact > Address1_PrimaryContactName
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo(Contact),
          CRMAccount.FieldNo(Address1_PrimaryContactName),
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          '',false,false); // We do not validate contact name.

        // Address > Address1_Line1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo(Address),
          CRMAccount.FieldNo(Address1_Line1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Address 2 > Address1_Line2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Address 2"),
          CRMAccount.FieldNo(Address1_Line2),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Post Code > Address1_PostalCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Post Code"),
          CRMAccount.FieldNo(Address1_PostalCode),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // City > Address1_City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo(City),
          CRMAccount.FieldNo(Address1_City),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Country > Address1_Country
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Country/Region Code"),
          CRMAccount.FieldNo(Address1_Country),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Email > EmailAddress1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("E-Mail"),
          CRMAccount.FieldNo(EMailAddress1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Fax No > Fax
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Fax No."),
          CRMAccount.FieldNo(Fax),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Home Page > WebSiteUrl
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Home Page"),
          CRMAccount.FieldNo(WebSiteURL),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Phone No. > Telephone1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Phone No."),
          CRMAccount.FieldNo(Telephone1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Shipment Method Code > address1_freighttermscode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Shipment Method Code"),
          CRMAccount.FieldNo(Address1_FreightTermsCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Shipping Agent Code > address1_shippingmethodcode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Shipping Agent Code"),
          CRMAccount.FieldNo(Address1_ShippingMethodCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Payment Terms Code > paymenttermscode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Payment Terms Code"),
          CRMAccount.FieldNo(PaymentTermsCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Credit Limit (LCY) > creditlimit
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FieldNo("Credit Limit (LCY)"),
          CRMAccount.FieldNo(CreditLimit),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        RecreateJobQueueEntry(IntegrationTableMapping,2,ShouldRecreateJobQueueEntry);
    end;

    local procedure ResetContactContactMapping(IntegrationTableMappingName: Code[20];EnqueueJobQueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CRMContact: Record "CRM Contact";
        Contact: Record Contact;
        EmptyGuid: Guid;
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::Contact,Database::"CRM Contact",
          CRMContact.FieldNo(ContactId),CRMContact.FieldNo(ModifiedOn),
          '','',true);

        Contact.Reset;
        Contact.SetRange(Type,Contact.Type::Person);
        Contact.SetFilter("Company No.",'<>''''');
        IntegrationTableMapping.SetTableFilter(GetTableFilterFromView(Database::Contact,Contact.TableCaption,Contact.GetView));

        CRMContact.Reset;
        CRMContact.SetFilter(ParentCustomerId,'<>''%1''',EmptyGuid);
        CRMContact.SetRange(ParentCustomerIdType,CRMContact.Parentcustomeridtype::account);
        IntegrationTableMapping.SetIntegrationTableFilter(
          GetTableFilterFromView(Database::"CRM Contact",CRMContact.TableCaption,CRMContact.GetView));
        IntegrationTableMapping.Modify;

        // "Currency Code" > TransactionCurrencyId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Currency Code"),
          CRMContact.FieldNo(TransactionCurrencyId),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Address > Address1_Line1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo(Address),
          CRMContact.FieldNo(Address1_Line1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Address 2 > Address1_Line2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Address 2"),
          CRMContact.FieldNo(Address1_Line2),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Post Code > Address1_PostalCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Post Code"),
          CRMContact.FieldNo(Address1_PostalCode),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // City > Address1_City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo(City),
          CRMContact.FieldNo(Address1_City),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Country/Region Code > Address1_Country
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Country/Region Code"),
          CRMContact.FieldNo(Address1_Country),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Email > EmailAddress1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("E-Mail"),
          CRMContact.FieldNo(EMailAddress1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Fax No. > Fax
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Fax No."),
          CRMContact.FieldNo(Fax),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // First Name > FirstName
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("First Name"),
          CRMContact.FieldNo(FirstName),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Middle Name > MiddleName
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Middle Name"),
          CRMContact.FieldNo(MiddleName),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Surname > LastName
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo(Surname),
          CRMContact.FieldNo(LastName),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Home Page > WebSiteUrl
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Home Page"),
          CRMContact.FieldNo(WebSiteUrl),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Mobile Phone No. > MobilePhone
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Mobile Phone No."),
          CRMContact.FieldNo(MobilePhone),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Pager > Pager
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo(Pager),
          CRMContact.FieldNo(Pager),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Phone No. > Telephone1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("Phone No."),
          CRMContact.FieldNo(Telephone1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Type
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo(Type),0,
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          Format(Contact.Type::Person),true,false);

        // Contact."No." is to be blank to enable auto numbering.
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Contact.FieldNo("No."),0,
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          '',false,false);

        // CRMContact.ParentCustomerIdType::account
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          0,CRMContact.FieldNo(ParentCustomerIdType),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          Format(CRMContact.Parentcustomeridtype::account),false,false);

        RecreateJobQueueEntry(IntegrationTableMapping,2,EnqueueJobQueEntry);
    end;

    local procedure ResetCurrencyTransactionCurrencyMapping(IntegrationTableMappingName: Code[20];EnqueueJobQueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        Currency: Record Currency;
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::Currency,Database::"CRM Transactioncurrency",
          CRMTransactioncurrency.FieldNo(TransactionCurrencyId),
          CRMTransactioncurrency.FieldNo(ModifiedOn),
          '',
          '',
          true);

        // Code > ISOCurrencyCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Currency.FieldNo(Code),
          CRMTransactioncurrency.FieldNo(ISOCurrencyCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Code > CurrencySymbol
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Currency.FieldNo(Code),
          CRMTransactioncurrency.FieldNo(CurrencySymbol),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Description > CurrencyName
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Currency.FieldNo(Description),
          CRMTransactioncurrency.FieldNo(CurrencyName),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        RecreateJobQueueEntry(IntegrationTableMapping,2,EnqueueJobQueEntry);
    end;

    local procedure ResetItemProductMapping(IntegrationTableMappingName: Code[20];EnqueueJobQueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        Item: Record Item;
        CRMProduct: Record "CRM Product";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::Item,Database::"CRM Product",
          CRMProduct.FieldNo(ProductId),CRMProduct.FieldNo(ModifiedOn),
          '','',true);

        SetIntegrationTableFilterForCRMProduct(IntegrationTableMapping,CRMProduct,CRMProduct.Producttypecode::SalesInventory);

        // "No." > ProductNumber
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo("No."),
          CRMProduct.FieldNo(ProductNumber),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Description > Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo(Description),
          CRMProduct.FieldNo(Name),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Unit Price > Price
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo("Unit Price"),
          CRMProduct.FieldNo(Price),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Unit Cost > Standard Cost
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo("Unit Cost"),
          CRMProduct.FieldNo(StandardCost),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Unit Cost > Current Cost
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo("Unit Cost"),
          CRMProduct.FieldNo(CurrentCost),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Unit Volume > Stock Volume
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo("Unit Volume"),
          CRMProduct.FieldNo(StockVolume),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Gross Weight > Stock Weight
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo("Gross Weight"),
          CRMProduct.FieldNo(StockWeight),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Vendor No. > Vendor ID
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo("Vendor No."),
          CRMProduct.FieldNo(VendorID),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Vendor Item No. > Vendor part number
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo("Vendor Item No."),
          CRMProduct.FieldNo(VendorPartNumber),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Inventory > Quantity on Hand. If less then zero, it will later be set to zero
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FieldNo(Inventory),
          CRMProduct.FieldNo(QuantityOnHand),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        RecreateJobQueueEntry(IntegrationTableMapping,30,EnqueueJobQueEntry);
    end;

    local procedure ResetResourceProductMapping(IntegrationTableMappingName: Code[20];EnqueueJobQueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        Resource: Record Resource;
        CRMProduct: Record "CRM Product";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::Resource,Database::"CRM Product",
          CRMProduct.FieldNo(ProductId),CRMProduct.FieldNo(ModifiedOn),
          '','',true);

        SetIntegrationTableFilterForCRMProduct(IntegrationTableMapping,CRMProduct,CRMProduct.Producttypecode::Services);

        // "No." > ProductNumber
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Resource.FieldNo("No."),
          CRMProduct.FieldNo(ProductNumber),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Name > Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Resource.FieldNo(Name),
          CRMProduct.FieldNo(Name),
          IntegrationFieldMapping.Direction::Bidirectional,
          '',true,false);

        // Unit Price > Price
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Resource.FieldNo("Unit Price"),
          CRMProduct.FieldNo(Price),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Unit Cost > Standard Cost
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Resource.FieldNo("Unit Cost"),
          CRMProduct.FieldNo(StandardCost),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Unit Cost > Current Cost
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Resource.FieldNo("Unit Cost"),
          CRMProduct.FieldNo(CurrentCost),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Vendor No. > Vendor ID
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Resource.FieldNo("Vendor No."),
          CRMProduct.FieldNo(VendorID),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Capacity > Quantity on Hand. If less then zero, it will later be set to zero
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Resource.FieldNo(Capacity),
          CRMProduct.FieldNo(QuantityOnHand),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        RecreateJobQueueEntry(IntegrationTableMapping,2,EnqueueJobQueEntry);
    end;

    local procedure ResetSalesInvoiceHeaderInvoiceMapping(IntegrationTableMappingName: Code[20];EnqueueJobQueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        CRMInvoice: Record "CRM Invoice";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Sales Invoice Header",Database::"CRM Invoice",
          CRMInvoice.FieldNo(InvoiceId),CRMInvoice.FieldNo(ModifiedOn),
          '','',true);

        // "No." > InvoiceNumber
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("No."),
          CRMInvoice.FieldNo(InvoiceNumber),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Currency Code" > TransactionCurrencyId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Currency Code"),
          CRMInvoice.FieldNo(TransactionCurrencyId),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Due Date" > DueDate
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Due Date"),
          CRMInvoice.FieldNo(DueDate),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Payment Discount % > DiscountPercentage
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Payment Discount %"),
          CRMInvoice.FieldNo(DiscountPercentage),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Ship-to Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Ship-to Name"),
          CRMInvoice.FieldNo(ShipTo_Name),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Ship-to Address
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Ship-to Address"),
          CRMInvoice.FieldNo(ShipTo_Line1),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Ship-to Address 2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Ship-to Address 2"),
          CRMInvoice.FieldNo(ShipTo_Line2),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Ship-to City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Ship-to City"),
          CRMInvoice.FieldNo(ShipTo_City),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Ship-to Country/Region Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Ship-to Country/Region Code"),
          CRMInvoice.FieldNo(ShipTo_Country),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Ship-to Post Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Ship-to Post Code"),
          CRMInvoice.FieldNo(ShipTo_PostalCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Ship-to County"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Ship-to County"),
          CRMInvoice.FieldNo(ShipTo_StateOrProvince),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Shipment Date"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Shipment Date"),
          CRMInvoice.FieldNo(DateDelivered),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Bill-to Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Bill-to Name"),
          CRMInvoice.FieldNo(BillTo_Name),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Bill-to Address
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Bill-to Address"),
          CRMInvoice.FieldNo(BillTo_Line1),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Bill-to Address 2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Bill-to Address 2"),
          CRMInvoice.FieldNo(BillTo_Line2),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Bill-to City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Bill-to City"),
          CRMInvoice.FieldNo(BillTo_City),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Bill-to Country/Region Code
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Bill-to Country/Region Code"),
          CRMInvoice.FieldNo(BillTo_Country),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Bill-to Post Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Bill-to Post Code"),
          CRMInvoice.FieldNo(BillTo_PostalCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Bill-to County"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Bill-to County"),
          CRMInvoice.FieldNo(BillTo_StateOrProvince),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Amount
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Amount Including VAT"),
          CRMInvoice.FieldNo(TotalAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Amount
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Amount Including VAT"),
          CRMInvoice.FieldNo(TotalLineItemAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Shipping Agent Code > address1_shippingmethodcode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Shipping Agent Code"),
          CRMInvoice.FieldNo(ShippingMethodCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // Payment Terms Code > paymenttermscode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceHeader.FieldNo("Payment Terms Code"),
          CRMInvoice.FieldNo(PaymentTermsCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        RecreateJobQueueEntry(IntegrationTableMapping,30,EnqueueJobQueEntry);
    end;

    local procedure ResetSalesInvoiceLineInvoiceMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalesInvoiceLine: Record "Sales Invoice Line";
        CRMInvoicedetail: Record "CRM Invoicedetail";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Sales Invoice Line",Database::"CRM Invoicedetail",
          CRMInvoicedetail.FieldNo(InvoiceDetailId),CRMInvoicedetail.FieldNo(ModifiedOn),
          '','',false);

        // Quantity -> Quantity
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceLine.FieldNo(Quantity),
          CRMInvoicedetail.FieldNo(Quantity),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Line Discount Amount" -> "Manual Discount Amount"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceLine.FieldNo("Line Discount Amount"),
          CRMInvoicedetail.FieldNo(ManualDiscountAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Unit Price" > PricePerUnit
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceLine.FieldNo("Unit Price"),
          CRMInvoicedetail.FieldNo(PricePerUnit),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // TRUE > IsPriceOverridden
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          0,
          CRMInvoicedetail.FieldNo(IsPriceOverridden),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '1',true,false);

        // Amount -> BaseAmount
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceLine.FieldNo(Amount),
          CRMInvoicedetail.FieldNo(BaseAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        // "Amount Including VAT" -> ExtendedAmount
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesInvoiceLine.FieldNo("Amount Including VAT"),
          CRMInvoicedetail.FieldNo(ExtendedAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);
    end;

    local procedure ResetCustomerPriceGroupPricelevelMapping(IntegrationTableMappingName: Code[20];EnqueueJobQueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CustomerPriceGroup: Record "Customer Price Group";
        CRMPricelevel: Record "CRM Pricelevel";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Customer Price Group",Database::"CRM Pricelevel",
          CRMPricelevel.FieldNo(PriceLevelId),CRMPricelevel.FieldNo(ModifiedOn),
          '','',true);

        // Code > Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          CustomerPriceGroup.FieldNo(Code),
          CRMPricelevel.FieldNo(Name),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        RecreateJobQueueEntry(IntegrationTableMapping,30,EnqueueJobQueEntry);
    end;

    local procedure ResetSalesPriceProductPricelevelMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalesPrice: Record "Sales Price";
        CRMProductpricelevel: Record "CRM Productpricelevel";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Sales Price",Database::"CRM Productpricelevel",
          CRMProductpricelevel.FieldNo(ProductPriceLevelId),CRMProductpricelevel.FieldNo(ModifiedOn),
          '','',false);

        SalesPrice.Reset;
        SalesPrice.SetRange("Sales Type",SalesPrice."sales type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code",'<>''''');
        IntegrationTableMapping.SetTableFilter(
          GetTableFilterFromView(Database::"Sales Price",SalesPrice.TableCaption,SalesPrice.GetView));

        IntegrationTableMapping.Modify;

        // "Unit Price" > PricePerUnit
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesPrice.FieldNo("Unit Price"),
          CRMProductpricelevel.FieldNo(Amount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);
    end;

    local procedure ResetUnitOfMeasureUoMScheduleMapping(IntegrationTableMappingName: Code[20];EnqueueJobQueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        UnitOfMeasure: Record "Unit of Measure";
        CRMUomschedule: Record "CRM Uomschedule";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Unit of Measure",Database::"CRM Uomschedule",
          CRMUomschedule.FieldNo(UoMScheduleId),CRMUomschedule.FieldNo(ModifiedOn),
          '','',true);

        // Code > BaseUoM Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          UnitOfMeasure.FieldNo(Code),
          CRMUomschedule.FieldNo(BaseUoMName),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '',true,false);

        RecreateJobQueueEntry(IntegrationTableMapping,2,EnqueueJobQueEntry);
    end;

    local procedure ResetShippingAgentMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        ShippingAgent: Record "Shipping Agent";
        CRMAccount: Record "CRM Account";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Shipping Agent",Database::"CRM Account",
          CRMAccount.FieldNo(Address1_ShippingMethodCode),0,
          '','',false);

        // Code > "CRM Account".Address1_ShippingMethodCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          ShippingAgent.FieldNo(Code),
          CRMAccount.FieldNo(Address1_ShippingMethodCode),
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          '',true,false);

        CRMIntegrationTableSynch.SynchOption(IntegrationTableMapping);
    end;

    local procedure ResetShipmentMethodMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        ShipmentMethod: Record "Shipment Method";
        CRMAccount: Record "CRM Account";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Shipment Method",Database::"CRM Account",
          CRMAccount.FieldNo(Address1_FreightTermsCode),0,
          '','',false);

        // Code > "CRM Account".Address1_FreightTermsCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          ShipmentMethod.FieldNo(Code),
          CRMAccount.FieldNo(Address1_FreightTermsCode),
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          '',true,false);

        CRMIntegrationTableSynch.SynchOption(IntegrationTableMapping);
    end;

    local procedure ResetPaymentTermsMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        PaymentTerms: Record "Payment Terms";
        CRMAccount: Record "CRM Account";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping,IntegrationTableMappingName,
          Database::"Payment Terms",Database::"CRM Account",
          CRMAccount.FieldNo(PaymentTermsCode),0,
          '','',false);

        // Code > "CRM Account".PaymentTermsCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          PaymentTerms.FieldNo(Code),
          CRMAccount.FieldNo(PaymentTermsCode),
          IntegrationFieldMapping.Direction::FromIntegrationTable,
          '',true,false);

        CRMIntegrationTableSynch.SynchOption(IntegrationTableMapping);
    end;

    local procedure InsertIntegrationTableMapping(var IntegrationTableMapping: Record "Integration Table Mapping";MappingName: Code[20];TableNo: Integer;IntegrationTableNo: Integer;IntegrationTableUIDFieldNo: Integer;IntegrationTableModifiedFieldNo: Integer;TableConfigTemplateCode: Code[10];IntegrationTableConfigTemplateCode: Code[10];SynchOnlyCoupledRecords: Boolean)
    begin
        with IntegrationTableMapping do begin
          if Get(MappingName) then
            Delete(true);
          Init;
          Name := MappingName;
          "Table ID" := TableNo;
          "Integration Table ID" := IntegrationTableNo;
          "Synch. Codeunit ID" := Codeunit::"CRM Integration Table Synch.";
          Validate("Integration Table UID Fld. No.",IntegrationTableUIDFieldNo);
          "Int. Tbl. Modified On Fld. No." := IntegrationTableModifiedFieldNo;
          "Table Config Template Code" := TableConfigTemplateCode;
          "Int. Tbl. Config Template Code" := IntegrationTableConfigTemplateCode;
          Direction := GetDefaultDirection("Table ID");
          "Int. Tbl. Caption Prefix" := IntegrationTablePrefixTok;
          "Synch. Only Coupled Records" := SynchOnlyCoupledRecords;
          Insert;
        end;
    end;

    local procedure InsertIntegrationFieldMapping(IntegrationTableMappingName: Code[20];TableFieldNo: Integer;IntegrationTableFieldNo: Integer;SynchDirection: Option;ConstValue: Text;ValidateField: Boolean;ValidateIntegrationTableField: Boolean)
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        with IntegrationFieldMapping do begin
          Init;
          "No." := 0;
          "Integration Table Mapping Name" := IntegrationTableMappingName;
          "Field No." := TableFieldNo;
          "Integration Table Field No." := IntegrationTableFieldNo;
          Direction := SynchDirection;
          "Constant Value" := CopyStr(ConstValue,1,MaxStrLen("Constant Value"));
          "Validate Field" := ValidateField;
          "Validate Integration Table Fld" := ValidateIntegrationTableField;
          Insert;
        end;
    end;

    local procedure RecreateStatisticsJobQueueEntry(EnqueueJobQueEntry: Boolean)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with JobQueueEntry do begin
          SetRange("Object Type to Run","object type to run"::Codeunit);
          SetRange("Object ID to Run",Codeunit::"CRM Statistics Job");
          DeleteAll;

          Init;
          ID := CreateGuid;
          "Earliest Start Date/Time" := CreateDatetime(Today,Time);
          "Object Type to Run" := "object type to run"::Codeunit;
          "Object ID to Run" := Codeunit::"CRM Statistics Job";
          Priority := 1000;
          Description := CopyStr(CustomStatisticsSynchJobDescTxt,1,MaxStrLen(Description));
          "Recurring Job" := true;
          "No. of Minutes between Runs" := 30;
          "Run on Mondays" := true;
          "Run on Tuesdays" := true;
          "Run on Wednesdays" := true;
          "Run on Thursdays" := true;
          "Run on Fridays" := true;
          "Run on Saturdays" := true;
          "Run on Sundays" := true;
          "Maximum No. of Attempts to Run" := 2;
          Status := Status::"On Hold";
          "Rerun Delay (sec.)" := 30;
          if EnqueueJobQueEntry then
            Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry)
          else
            Insert;
        end;
    end;

    local procedure RecreateJobQueueEntry(IntegrationTableMapping: Record "Integration Table Mapping";IntervalInMinutes: Integer;ShouldRecreateJobQueueEntry: Boolean)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with JobQueueEntry do begin
          SetRange("Object Type to Run","object type to run"::Codeunit);
          SetRange("Object ID to Run",Codeunit::"Integration Synch. Job Runner");
          SetRange("Record ID to Process",IntegrationTableMapping.RecordId);
          DeleteAll(true);

          Init;
          ID := CreateGuid;
          "Earliest Start Date/Time" := CreateDatetime(Today,Time);
          "Object Type to Run" := "object type to run"::Codeunit;
          "Object ID to Run" := Codeunit::"Integration Synch. Job Runner";
          "Record ID to Process" := IntegrationTableMapping.RecordId;
          "Run in User Session" := false;
          Priority := 1000;
          Description := CopyStr(StrSubstNo(JobQueueEntryNameTok,IntegrationTableMapping.Name),1,MaxStrLen(Description));
          "Recurring Job" := true;
          "No. of Minutes between Runs" := IntervalInMinutes;
          "Run on Mondays" := true;
          "Run on Tuesdays" := true;
          "Run on Wednesdays" := true;
          "Run on Thursdays" := true;
          "Run on Fridays" := true;
          "Run on Saturdays" := true;
          "Run on Sundays" := true;
          "Maximum No. of Attempts to Run" := 10;
          Status := Status::Ready;
          "Rerun Delay (sec.)" := 30;
          if ShouldRecreateJobQueueEntry then
            Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry)
          else
            Insert;
        end;
    end;


    procedure ResetCRMNAVConnectionData()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationManagement.SetCRMNAVConnectionUrl(GetUrl(Clienttype::Web));
        CRMIntegrationManagement.SetCRMNAVODataUrlCredentials(
          GetUrl(Clienttype::OData,COMPANYNAME),'','');
    end;


    procedure GetAddPostedSalesDocumentToCRMAccountWallConfig(): Boolean
    begin
        exit(true);
    end;


    procedure GetAllowNonSecureConnections(): Boolean
    begin
        exit(false);
    end;


    procedure GetCRMTableNo(NAVTableID: Integer): Integer
    begin
        case NAVTableID of
          Database::Contact:
            exit(Database::"CRM Contact");
          Database::Currency:
            exit(Database::"CRM Transactioncurrency");
          Database::Customer:
            exit(Database::"CRM Account");
          Database::"Customer Price Group":
            exit(Database::"CRM Pricelevel");
          Database::Item,
          Database::Resource:
            exit(Database::"CRM Product");
          Database::"Sales Invoice Header":
            exit(Database::"CRM Invoice");
          Database::"Sales Invoice Line":
            exit(Database::"CRM Invoicedetail");
          Database::"Sales Price":
            exit(Database::"CRM Productpricelevel");
          Database::"Salesperson/Purchaser":
            exit(Database::"CRM Systemuser");
          Database::"Unit of Measure":
            exit(Database::"CRM Uomschedule");
        end;
    end;


    procedure GetDefaultDirection(NAVTableID: Integer): Integer
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
    begin
        case NAVTableID of
          Database::Contact,
          Database::Customer,
          Database::Item,
          Database::Resource:
            exit(IntegrationTableMapping.Direction::Bidirectional);
          Database::Currency,
          Database::"Customer Price Group",
          Database::"Sales Invoice Header",
          Database::"Sales Invoice Line",
          Database::"Sales Price",
          Database::"Unit of Measure":
            exit(IntegrationTableMapping.Direction::ToIntegrationTable);
          Database::"Payment Terms",
          Database::"Shipment Method",
          Database::"Shipping Agent",
          Database::"Salesperson/Purchaser":
            exit(IntegrationTableMapping.Direction::FromIntegrationTable);
        end;
    end;


    procedure GetProductQuantityPrecision(): Integer
    begin
        exit(2);
    end;


    procedure GetNameFieldNo(TableID: Integer): Integer
    var
        Contact: Record Contact;
        CRMContact: Record "CRM Contact";
        Currency: Record Currency;
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        Customer: Record Customer;
        CRMAccount: Record "CRM Account";
        CustomerPriceGroup: Record "Customer Price Group";
        CRMPricelevel: Record "CRM Pricelevel";
        Item: Record Item;
        Resource: Record Resource;
        CRMProduct: Record "CRM Product";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CRMSystemuser: Record "CRM Systemuser";
        UnitOfMeasure: Record "Unit of Measure";
        CRMUomschedule: Record "CRM Uomschedule";
    begin
        case TableID of
          Database::Contact:
            exit(Contact.FieldNo(Name));
          Database::"CRM Contact":
            exit(CRMContact.FieldNo(FullName));
          Database::Currency:
            exit(Currency.FieldNo(Code));
          Database::"CRM Transactioncurrency":
            exit(CRMTransactioncurrency.FieldNo(ISOCurrencyCode));
          Database::Customer:
            exit(Customer.FieldNo(Name));
          Database::"CRM Account":
            exit(CRMAccount.FieldNo(Name));
          Database::"Customer Price Group":
            exit(CustomerPriceGroup.FieldNo(Code));
          Database::"CRM Pricelevel":
            exit(CRMPricelevel.FieldNo(Name));
          Database::Item:
            exit(Item.FieldNo("No."));
          Database::Resource:
            exit(Resource.FieldNo("No."));
          Database::"CRM Product":
            exit(CRMProduct.FieldNo(ProductNumber));
          Database::"Salesperson/Purchaser":
            exit(SalespersonPurchaser.FieldNo(Name));
          Database::"CRM Systemuser":
            exit(CRMSystemuser.FieldNo(FullName));
          Database::"Unit of Measure":
            exit(UnitOfMeasure.FieldNo(Code));
          Database::"CRM Uomschedule":
            exit(CRMUomschedule.FieldNo(Name));
        end;
    end;

    local procedure GetTableFilterFromView(TableID: Integer;Caption: Text;View: Text): Text
    var
        FilterBuilder: FilterPageBuilder;
    begin
        FilterBuilder.AddTable(Caption,TableID);
        FilterBuilder.SetView(Caption,View);
        exit(FilterBuilder.GetView(Caption,true));
    end;


    procedure GetPrioritizedMappingList(var NameValueBuffer: Record "Name/Value Buffer")
    var
        "Field": Record "Field";
        IntegrationTableMapping: Record "Integration Table Mapping";
        NextPriority: Integer;
    begin
        NextPriority := 1;

        // 1) From CRM Systemusers
        AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,0,Database::"CRM Systemuser");
        // 2) From Currency
        AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,Database::Currency,0);
        // 3) From Unit of measure
        AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,Database::"Unit of Measure",0);
        // 4) To/From Customers/CRM Accounts
        AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,Database::Customer,Database::"CRM Account");
        // 5) To/From Contacts/CRM Contacts
        AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,Database::Contact,Database::"CRM Contact");
        // 6) From Items to CRM Products
        AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,Database::Item,Database::"CRM Product");
        // 7) From Resources to CRM Products
        AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,Database::Resource,Database::"CRM Product");

        IntegrationTableMapping.Reset;
        IntegrationTableMapping.SetFilter("Parent Name",'=''''');
        IntegrationTableMapping.SetRange("Int. Table UID Field Type",Field.Type::Guid);
        if IntegrationTableMapping.FindSet then
          repeat
            AddPrioritizedMappingToList(NameValueBuffer,NextPriority,IntegrationTableMapping.Name);
          until IntegrationTableMapping.Next = 0;
    end;

    local procedure AddPrioritizedMappingsToList(var NameValueBuffer: Record "Name/Value Buffer";var Priority: Integer;TableID: Integer;IntegrationTableID: Integer)
    var
        "Field": Record "Field";
        IntegrationTableMapping: Record "Integration Table Mapping";
    begin
        with IntegrationTableMapping do begin
          Reset;
          if TableID > 0 then
            SetRange("Table ID",TableID);
          if IntegrationTableID > 0 then
            SetRange("Integration Table ID",IntegrationTableID);
          SetRange("Int. Table UID Field Type",Field.Type::Guid);
          if FindSet then
            repeat
              AddPrioritizedMappingToList(NameValueBuffer,Priority,Name);
            until Next = 0;
        end;
    end;

    local procedure AddPrioritizedMappingToList(var NameValueBuffer: Record "Name/Value Buffer";var Priority: Integer;MappingName: Code[20])
    begin
        with NameValueBuffer do begin
          SetRange(Value,MappingName);

          if not FindFirst then begin
            Init;
            ID := Priority;
            Name := Format(Priority);
            Value := MappingName;
            Insert;
            Priority := Priority + 1;
          end;

          Reset;
        end;
    end;


    procedure GetTableIDCRMEntityNameMapping(var TempNameValueBuffer: Record "Name/Value Buffer" temporary)
    begin
        TempNameValueBuffer.Reset;
        TempNameValueBuffer.DeleteAll;

        AddEntityTableMapping('systemuser',Database::"Salesperson/Purchaser",TempNameValueBuffer);
        AddEntityTableMapping('systemuser',Database::"CRM Systemuser",TempNameValueBuffer);

        AddEntityTableMapping('account',Database::Customer,TempNameValueBuffer);
        AddEntityTableMapping('account',Database::"CRM Account",TempNameValueBuffer);

        AddEntityTableMapping('contact',Database::Contact,TempNameValueBuffer);
        AddEntityTableMapping('contact',Database::"CRM Contact",TempNameValueBuffer);

        AddEntityTableMapping('product',Database::Item,TempNameValueBuffer);
        AddEntityTableMapping('product',Database::Resource,TempNameValueBuffer);
        AddEntityTableMapping('product',Database::"CRM Product",TempNameValueBuffer);

        AddEntityTableMapping('salesorder',Database::"Sales Header",TempNameValueBuffer);
        AddEntityTableMapping('salesorder',Database::"CRM Salesorder",TempNameValueBuffer);

        AddEntityTableMapping('invoice',Database::"Sales Invoice Header",TempNameValueBuffer);
        AddEntityTableMapping('invoice',Database::"CRM Invoice",TempNameValueBuffer);

        // Only NAV
        AddEntityTableMapping('pricelevel',Database::"Customer Price Group",TempNameValueBuffer);
        AddEntityTableMapping('transactioncurrency',Database::Currency,TempNameValueBuffer);
        AddEntityTableMapping('uomschedule',Database::"Unit of Measure",TempNameValueBuffer);

        // Only CRM
        AddEntityTableMapping('incident',Database::"CRM Incident",TempNameValueBuffer);
        AddEntityTableMapping('opportunity',Database::"CRM Opportunity",TempNameValueBuffer);
        AddEntityTableMapping('quote',Database::"CRM Quote",TempNameValueBuffer);
    end;

    local procedure AddEntityTableMapping(CRMEntityTypeName: Text;TableID: Integer;var TempNameValueBuffer: Record "Name/Value Buffer" temporary)
    begin
        with TempNameValueBuffer do begin
          Init;
          ID := Count + 1;
          Name := CopyStr(CRMEntityTypeName,1,MaxStrLen(Name));
          Value := Format(TableID);
          Insert;
        end;
    end;

    local procedure ResetAccountConfigTemplate(): Code[10]
    var
        AccountConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateLine: Record "Config. Template Line";
        CRMAccount: Record "CRM Account";
    begin
        ConfigTemplateLine.SetRange(
          "Data Template Code",CopyStr(CRMAccountConfigTemplateCodeTok,1,MaxStrLen(AccountConfigTemplateHeader.Code)));
        ConfigTemplateLine.DeleteAll;
        AccountConfigTemplateHeader.SetRange(
          Code,CopyStr(CRMAccountConfigTemplateCodeTok,1,MaxStrLen(AccountConfigTemplateHeader.Code)));
        AccountConfigTemplateHeader.DeleteAll;

        AccountConfigTemplateHeader.Init;
        AccountConfigTemplateHeader.Code := CopyStr(CRMAccountConfigTemplateCodeTok,1,MaxStrLen(AccountConfigTemplateHeader.Code));
        AccountConfigTemplateHeader.Description :=
          CopyStr(CRMAccountConfigTemplateDescTxt,1,MaxStrLen(AccountConfigTemplateHeader.Description));
        AccountConfigTemplateHeader."Table ID" := Database::"CRM Account";
        AccountConfigTemplateHeader.Insert;
        ConfigTemplateLine.Init;
        ConfigTemplateLine."Data Template Code" := AccountConfigTemplateHeader.Code;
        ConfigTemplateLine."Line No." := 1;
        ConfigTemplateLine.Type := ConfigTemplateLine.Type::Field;
        ConfigTemplateLine."Table ID" := Database::"CRM Account";
        ConfigTemplateLine."Field ID" := CRMAccount.FieldNo(CustomerTypeCode);
        ConfigTemplateLine."Field Name" := CRMAccount.FieldName(CustomerTypeCode);
        ConfigTemplateLine."Default Value" := Format(CRMAccount.Customertypecode::Customer);
        ConfigTemplateLine.Insert;

        exit(CRMAccountConfigTemplateCodeTok);
    end;

    local procedure ResetCustomerConfigTemplate(): Code[10]
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        CustomerConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateLine: Record "Config. Template Line";
        CustomerConfigTemplateLine: Record "Config. Template Line";
        Customer: Record Customer;
        FoundTemplateCode: Code[10];
    begin
        CustomerConfigTemplateLine.SetRange(
          "Data Template Code",CopyStr(CustomerConfigTemplateCodeTok,1,MaxStrLen(CustomerConfigTemplateLine."Data Template Code")));
        CustomerConfigTemplateLine.DeleteAll;
        CustomerConfigTemplateHeader.SetRange(
          Code,CopyStr(CustomerConfigTemplateCodeTok,1,MaxStrLen(CustomerConfigTemplateHeader.Code)));
        CustomerConfigTemplateHeader.DeleteAll;

        // Base the customer config template off the first customer template with currency code '' (LCY);
        ConfigTemplateHeader.SetRange("Table ID",Database::Customer);
        if ConfigTemplateHeader.FindSet then
          repeat
            ConfigTemplateLine.SetRange("Data Template Code",ConfigTemplateHeader.Code);
            ConfigTemplateLine.SetRange("Field ID",Customer.FieldNo("Currency Code"));
            ConfigTemplateLine.SetFilter("Default Value",'');
            if ConfigTemplateLine.FindFirst then begin
              FoundTemplateCode := ConfigTemplateHeader.Code;
              break;
            end;
          until ConfigTemplateHeader.Next = 0;

        if FoundTemplateCode = '' then
          exit('');

        CustomerConfigTemplateHeader.Init;
        CustomerConfigTemplateHeader.TransferFields(ConfigTemplateHeader,false);
        CustomerConfigTemplateHeader.Code := CopyStr(CustomerConfigTemplateCodeTok,1,MaxStrLen(CustomerConfigTemplateHeader.Code));
        CustomerConfigTemplateHeader.Description :=
          CopyStr(CustomerConfigTemplateDescTxt,1,MaxStrLen(CustomerConfigTemplateHeader.Description));
        CustomerConfigTemplateHeader.Insert;

        ConfigTemplateLine.Reset;
        ConfigTemplateLine.SetRange("Data Template Code",ConfigTemplateHeader.Code);
        ConfigTemplateLine.FindSet;
        repeat
          CustomerConfigTemplateLine.Init;
          CustomerConfigTemplateLine.TransferFields(ConfigTemplateLine,true);
          CustomerConfigTemplateLine."Data Template Code" := CustomerConfigTemplateHeader.Code;
          CustomerConfigTemplateLine.Insert;
        until ConfigTemplateLine.Next = 0;

        exit(CustomerConfigTemplateCodeTok);
    end;

    local procedure RegisterTempConnectionIfNeeded(CRMConnectionSetup: Record "CRM Connection Setup";var TempCRMConnectionSetup: Record "CRM Connection Setup" temporary) ConnectionName: Text
    begin
        if CRMConnectionSetup."Is User Mapping Required" then begin
          ConnectionName := Format(CreateGuid);
          TempCRMConnectionSetup.TransferFields(CRMConnectionSetup);
          TempCRMConnectionSetup."Is User Mapping Required" := false;
          TempCRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
        end;
    end;

    local procedure ResetDefaultCRMPricelevel(CRMConnectionSetup: Record "CRM Connection Setup")
    begin
        CRMConnectionSetup.Find;
        Clear(CRMConnectionSetup."Default CRM Price List ID");
        CRMConnectionSetup.Modify;
    end;

    local procedure SetIntegrationTableFilterForCRMProduct(var IntegrationTableMapping: Record "Integration Table Mapping";CRMProduct: Record "CRM Product";ProductTypeCode: Option)
    begin
        CRMProduct.SetRange(ProductTypeCode,ProductTypeCode);
        IntegrationTableMapping.SetIntegrationTableFilter(
          GetTableFilterFromView(Database::"CRM Product",CRMProduct.TableCaption,CRMProduct.GetView));
        IntegrationTableMapping.Modify;
    end;
}

