#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5341 "CRM Int. Table. Subscriber"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        CannotFindSyncedProductErr: label 'Cannot find a synchronized product for %1.', Comment='%1=product identifier';
        CannotSynchOnlyLinesErr: label 'Cannot synchronize invoice lines separately.';
        CannotSynchProductErr: label 'Cannot synchronize the product %1.', Comment='%1=product identification';
        RecordNotFoundErr: label 'Cannot find %1 in table %2.', Comment='%1 = The lookup value when searching for the source record, %2 = Source table caption';
        RecordMustBeCoupledErr: label '%1 must be coupled to a Microsoft Dynamics CRM Account.', Comment='%1 = Record ID';
        ContactsMustBeRelatedToCompanyErr: label 'The contact %1 must have a contact company that has a business relation to a customer.', Comment='%1 = Contact No.';
        ContactMissingCompanyErr: label 'The contact cannot be created because the company does not exist.';
        CRMSynchHelper: Codeunit "CRM Synch. Helper";
        CRMUnitGroupExistsAndIsInactiveErr: label 'The %1 %2 already exists in Microsoft Dynamics CRM, but it cannot be synchronized, because it is inactive.', Comment='%1=table caption: Unit Group,%2=The name of the indicated Unit Group';
        CRMUnitGroupContainsMoreThanOneUoMErr: label 'The Microsoft Dynamics CRM %1 %2 contains more than one %3. This setup cannot be used for synchronization.', Comment='%1=table caption: Unit Group,%2=The name of the indicated Unit Group,%3=table caption: Unit.';
        CustomerHasChangedErr: label 'Cannot create the invoice in Microsoft Dynamics CRM. The customer from the original Microsoft Dynamics CRM sales order %1 was changed or is no longer coupled.', Comment='%1=CRM sales order number';
        NoCoupledSalesInvoiceHeaderErr: label 'Cannot find the coupled Microsoft Dynamics CRM invoice header.';
        NoCoupledPricelevelErr: label 'Cannot find the coupled Microsoft Dynamics CRM price list.';
        PostedSalesInvInFCYErr: label 'Only posted sales invoices in the local currency can be coupled to Microsoft CRM.';
        CRMRecordMustBeCoupledErr: label '%1 %2 must be coupled to a record in %3.', Comment='%1 =field caption, %2 = field value, %3 - product name ';
        NAVRecordMustBeCoupledErr: label '%1 %2 must be coupled to a record in Dynamics CRM.', Comment='%1 =field caption, %2 = field value';
        MappingMustBeSetForGUIDFieldErr: label 'Table %1 must be mapped to table %2 to transfer value between fields %3  and %4.', Comment='%1 and %2 are table IDs, %3 and %4 are field captions.';


    procedure ClearCache()
    begin
        CRMSynchHelper.ClearCache;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnBeforeTransferRecordFields', '', false, false)]

    procedure OnBeforeTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
        case GetSourceDestCode(SourceRecordRef,DestinationRecordRef) of
          'Sales Price-CRM Productpricelevel':
            UpdateCRMProductPricelevelBeforeTransferRecordFields(SourceRecordRef,DestinationRecordRef);
          'Sales Invoice Header-CRM Invoice':
            CheckItemOrResourceIsNotBlocked(SourceRecordRef);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Record Synch.", 'OnTransferFieldData', '', false, false)]

    procedure OnTransferFieldData(SourceFieldRef: FieldRef;DestinationFieldRef: FieldRef;var NewValue: Variant;var IsValueFound: Boolean;var NeedsConversion: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        OptionValue: Integer;
    begin
        if ConvertTableToOption(SourceFieldRef,OptionValue) then begin
          NewValue := OptionValue;
          IsValueFound := true;
          NeedsConversion := true;
          exit;
        end;

        if AreFieldsRelatedToMappedTables(SourceFieldRef,DestinationFieldRef,IntegrationTableMapping) then begin
          IsValueFound := FindNewValueForCoupledRecordPK(IntegrationTableMapping,SourceFieldRef,DestinationFieldRef,NewValue);
          NeedsConversion := false;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnAfterTransferRecordFields', '', false, false)]

    procedure OnAfterTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var AdditionalFieldsWereModified: Boolean;DestinationIsInserted: Boolean)
    begin
        case GetSourceDestCode(SourceRecordRef,DestinationRecordRef) of
          'CRM Account-Customer':
            AdditionalFieldsWereModified :=
              UpdateCustomerBlocked(SourceRecordRef,DestinationRecordRef) or
              UpdateCustomerSalespersonCode(SourceRecordRef,DestinationRecordRef);
          'CRM Contact-Contact':
            AdditionalFieldsWereModified :=
              UpdateContactSalespersonCode(SourceRecordRef,DestinationRecordRef);
          'Customer-CRM Account':
            AdditionalFieldsWereModified :=
              UpdateCRMAccountOwnerID(SourceRecordRef,DestinationRecordRef);
          'Contact-CRM Contact':
            AdditionalFieldsWereModified :=
              UpdateCRMContactOwnerID(SourceRecordRef,DestinationRecordRef);
          'Currency-CRM Transactioncurrency':
            AdditionalFieldsWereModified :=
              UpdateCRMTransactionCurrencyAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
          'Item-CRM Product',
          'Resource-CRM Product':
            AdditionalFieldsWereModified :=
              UpdateCRMProductAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef,DestinationIsInserted);
          'CRM Product-Item':
            AdditionalFieldsWereModified :=
              UpdateItemAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
          'CRM Product-Resource':
            AdditionalFieldsWereModified :=
              UpdateResourceAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
          'Unit of Measure-CRM Uomschedule':
            AdditionalFieldsWereModified :=
              UpdateCRMUoMScheduleAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
          else
            AdditionalFieldsWereModified := false;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnBeforeInsertRecord', '', false, false)]

    procedure OnBeforeInsertRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
        case GetSourceDestCode(SourceRecordRef,DestinationRecordRef) of
          'CRM Contact-Contact':
            UpdateContactParentCompany(SourceRecordRef,DestinationRecordRef);
          'Contact-CRM Contact':
            UpdateCRMContactParentCustomerId(SourceRecordRef,DestinationRecordRef);
          'Currency-CRM Transactioncurrency':
            UpdateCRMTransactionCurrencyBeforeInsertRecord(DestinationRecordRef);
          'Customer Price Group-CRM Pricelevel':
            UpdateCRMPricelevelBeforeInsertRecord(SourceRecordRef,DestinationRecordRef);
          'Item-CRM Product',
          'Resource-CRM Product':
            UpdateCRMProductBeforeInsertRecord(DestinationRecordRef);
          'Sales Invoice Header-CRM Invoice':
            UpdateCRMInvoiceBeforeInsertRecord(SourceRecordRef,DestinationRecordRef);
          'Sales Invoice Line-CRM Invoicedetail':
            UpdateCRMInvoiceDetailsBeforeInsertRecord(SourceRecordRef,DestinationRecordRef);
        end;

        if DestinationRecordRef.Number = Database::"Salesperson/Purchaser" then
          UpdateSalesPersOnBeforeInsertRecord(DestinationRecordRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnAfterInsertRecord', '', false, false)]

    procedure OnAfterInsertRecord(SourceRecordRef: RecordRef;DestinationRecordRef: RecordRef)
    begin
        case GetSourceDestCode(SourceRecordRef,DestinationRecordRef) of
          'Customer Price Group-CRM Pricelevel':
            ResetCRMProductpricelevelFromCRMPricelevel(SourceRecordRef,DestinationRecordRef);
          'Item-CRM Product',
          'Resource-CRM Product':
            UpdateCRMProductAfterInsertRecord(DestinationRecordRef);
          'Sales Invoice Header-CRM Invoice':
            UpdateCRMInvoiceAfterInsertRecord(SourceRecordRef,DestinationRecordRef);
          'Sales Invoice Line-CRM Invoicedetail':
            UpdateCRMInvoiceDetailsAfterInsertRecord(SourceRecordRef,DestinationRecordRef);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnBeforeModifyRecord', '', false, false)]

    procedure OnBeforeModifyRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
        case GetSourceDestCode(SourceRecordRef,DestinationRecordRef) of
          'Customer Price Group-CRM Pricelevel':
            UpdateCRMPricelevelBeforeModifyRecord(SourceRecordRef,DestinationRecordRef);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnAfterModifyRecord', '', false, false)]

    procedure OnAfterModifyRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    begin
        case GetSourceDestCode(SourceRecordRef,DestinationRecordRef) of
          'Customer Price Group-CRM Pricelevel':
            ResetCRMProductpricelevelFromCRMPricelevel(SourceRecordRef,DestinationRecordRef);
        end;

        if DestinationRecordRef.Number = Database::Customer then
          CRMSynchHelper.UpdateContactOnModifyCustomer(DestinationRecordRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Integration Table Synch.", 'OnQueryPostFilterIgnoreRecord', '', false, false)]

    procedure OnQueryPostFilterIgnoreRecord(SourceRecordRef: RecordRef;var IgnoreRecord: Boolean)
    begin
        case SourceRecordRef.Number of
          Database::Contact:
            IgnoreRecord := HandleContactQueryPostFilterIgnoreRecord(SourceRecordRef);
          Database::"Sales Invoice Line":
            Error(CannotSynchOnlyLinesErr);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnFindUncoupledDestinationRecord', '', false, false)]

    procedure OnFindUncoupledDestinationRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;var DestinationIsDeleted: Boolean;var DestinationFound: Boolean)
    begin
        case GetSourceDestCode(SourceRecordRef,DestinationRecordRef) of
          'Unit of Measure-CRM Uomschedule':
            DestinationFound := CRMUoMScheduleFindUncoupledDestinationRecord(SourceRecordRef,DestinationRecordRef);
          'Currency-CRM Transactioncurrency':
            DestinationFound := CRMTransactionCurrencyFindUncoupledDestinationRecord(SourceRecordRef,DestinationRecordRef);
        end;
    end;

    local procedure GetSourceDestCode(SourceRecordRef: RecordRef;DestinationRecordRef: RecordRef): Text
    begin
        if (SourceRecordRef.Number <> 0) and (DestinationRecordRef.Number <> 0) then
          exit(StrSubstNo('%1-%2',SourceRecordRef.Name,DestinationRecordRef.Name));
        exit('');
    end;

    local procedure UpdateCustomerBlocked(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef): Boolean
    var
        Customer: Record Customer;
        CRMAccount: Record "CRM Account";
        DestinationFieldRef: FieldRef;
        SourceFieldRef: FieldRef;
        OptionValue: Integer;
    begin
        // Blocked - we're only handling from Active > Inactive meaning Blocked::"" > Blocked::"All"
        SourceFieldRef := SourceRecordRef.Field(CRMAccount.FieldNo(StatusCode));
        OptionValue := SourceFieldRef.Value;
        if OptionValue = CRMAccount.Statuscode::Inactive then begin
          DestinationFieldRef := DestinationRecordRef.Field(Customer.FieldNo(Blocked));
          OptionValue := DestinationFieldRef.Value;
          if OptionValue = Customer.Blocked::" " then begin
            DestinationFieldRef.Value := Customer.Blocked::All;
            exit(true);
          end;
        end;
    end;

    local procedure UpdateCustomerSalespersonCode(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef): Boolean
    var
        Customer: Record Customer;
        CRMAccount: Record "CRM Account";
    begin
        exit(
          CRMSynchHelper.UpdateSalesPersonCodeIfChanged(
            SourceRecordRef,DestinationRecordRef,
            CRMAccount.FieldNo(OwnerId),CRMAccount.FieldNo(OwnerIdType),CRMAccount.Owneridtype::systemuser,
            Customer.FieldNo("Salesperson Code")))
    end;

    local procedure UpdateContactSalespersonCode(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef): Boolean
    var
        CRMContact: Record "CRM Contact";
        Contact: Record Contact;
    begin
        exit(
          CRMSynchHelper.UpdateSalesPersonCodeIfChanged(
            SourceRecordRef,DestinationRecordRef,
            CRMContact.FieldNo(OwnerId),CRMContact.FieldNo(OwnerIdType),CRMContact.Owneridtype::systemuser,
            Contact.FieldNo("Salesperson Code")))
    end;

    local procedure UpdateContactParentCompany(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    var
        CRMContact: Record "CRM Contact";
        SourceFieldRef: FieldRef;
        ParentCustomerId: Guid;
    begin
        // When inserting we also want to set the company contact id
        // We only allow creation of new contacts if the company has already been created
        SourceFieldRef := SourceRecordRef.Field(CRMContact.FieldNo(ParentCustomerId));
        ParentCustomerId := SourceFieldRef.Value;
        if not CRMSynchHelper.SetContactParentCompany(ParentCustomerId,DestinationRecordRef) then
          Error(ContactMissingCompanyErr);
    end;

    local procedure HandleContactQueryPostFilterIgnoreRecord(SourceRecordRef: RecordRef) IgnoreRecord: Boolean
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        if not FindContactRelatedCustomer(SourceRecordRef,ContactBusinessRelation) then
          IgnoreRecord := true;
    end;

    local procedure UpdateSalesPersOnBeforeInsertRecord(var DestinationRecordRef: RecordRef)
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        DestinationFieldRef: FieldRef;
        NewCodePattern: Text;
        NewCodeId: Integer;
    begin
        // We need to create a new code for this SP.
        // To do so we just do a SP A
        NewCodePattern := 'SP NO. %1';
        NewCodeId := 1;
        while SalespersonPurchaser.Get(StrSubstNo(NewCodePattern,NewCodeId)) do
          NewCodeId := NewCodeId + 1;

        DestinationFieldRef := DestinationRecordRef.Field(SalespersonPurchaser.FieldNo(Code));
        DestinationFieldRef.Value := StrSubstNo(NewCodePattern,NewCodeId);
    end;

    local procedure UpdateCRMAccountOwnerID(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef): Boolean
    var
        CRMAccount: Record "CRM Account";
        Customer: Record Customer;
    begin
        exit(
          CRMSynchHelper.UpdateOwnerIfChanged(
            SourceRecordRef,DestinationRecordRef,Customer.FieldNo("Salesperson Code"),CRMAccount.FieldNo(OwnerId),
            CRMAccount.FieldNo(OwnerIdType),CRMAccount.Owneridtype::systemuser))
    end;

    local procedure UpdateCRMContactOwnerID(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef): Boolean
    var
        CRMContact: Record "CRM Contact";
        Contact: Record Contact;
    begin
        exit(
          CRMSynchHelper.UpdateOwnerIfChanged(
            SourceRecordRef,DestinationRecordRef,Contact.FieldNo("Salesperson Code"),CRMContact.FieldNo(OwnerId),
            CRMContact.FieldNo(OwnerIdType),CRMContact.Owneridtype::systemuser))
    end;

    local procedure UpdateCRMContactParentCustomerId(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    var
        CRMContact: Record "CRM Contact";
        ParentCustomerIdFieldRef: FieldRef;
    begin
        // Tranfer the parent company id to the ParentCustomerId
        ParentCustomerIdFieldRef := DestinationRecordRef.Field(CRMContact.FieldNo(ParentCustomerId));
        ParentCustomerIdFieldRef.Value := FindParentCRMAccountForContact(SourceRecordRef);
    end;

    local procedure UpdateCRMInvoiceAfterInsertRecord(SourceRecordRef: RecordRef;DestinationRecordRef: RecordRef)
    var
        CRMInvoice: Record "CRM Invoice";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        SourceLinesRecordRef: RecordRef;
    begin
        SourceRecordRef.SetTable(SalesInvoiceHeader);
        DestinationRecordRef.SetTable(CRMInvoice);

        SalesInvoiceLine.SetRange("Document No.",SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindFirst then begin
          SourceLinesRecordRef.GetTable(SalesInvoiceLine);
          CRMIntegrationTableSynch.SynchRecordsToIntegrationTable(SourceLinesRecordRef,false,false);
        end;

        CRMSynchHelper.UpdateCRMInvoiceStatus(CRMInvoice,SalesInvoiceHeader);
        CRMSynchHelper.SetSalesInvoiceHeaderCoupledToCRM(SalesInvoiceHeader);
    end;

    local procedure UpdateCRMInvoiceBeforeInsertRecord(SourceRecordRef: RecordRef;DestinationRecordRef: RecordRef)
    var
        CRMAccount: Record "CRM Account";
        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMInvoice: Record "CRM Invoice";
        CRMPricelevel: Record "CRM Pricelevel";
        CRMSalesorder: Record "CRM Salesorder";
        Customer: Record Customer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ShipmentMethod: Record "Shipment Method";
        CRMSalesOrderToSalesOrder: Codeunit "CRM Sales Order to Sales Order";
        TypeHelper: Codeunit "Type Helper";
        DestinationFieldRef: FieldRef;
        AccountId: Guid;
    begin
        SourceRecordRef.SetTable(SalesInvoiceHeader);

        // Shipment Method Code -> go to table Shipment Method, and from there extract the description and add it to
        if ShipmentMethod.Get(SalesInvoiceHeader."Shipment Method Code") then begin
          DestinationFieldRef := DestinationRecordRef.Field(CRMInvoice.FieldNo(Description));
          TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef,ShipmentMethod.Description,Textencoding::UTF16);
        end;

        DestinationRecordRef.SetTable(CRMInvoice);
        if CRMSalesOrderToSalesOrder.GetCRMSalesOrder(CRMSalesorder,SalesInvoiceHeader."Your Reference") then begin
          CRMInvoice.OpportunityId := CRMSalesorder.OpportunityId;
          CRMInvoice.SalesOrderId := CRMSalesorder.SalesOrderId;
          CRMInvoice.PriceLevelId := CRMSalesorder.PriceLevelId;
          CRMInvoice.Name := CRMSalesorder.Name;

          if not CRMSalesOrderToSalesOrder.GetCoupledCustomer(CRMSalesorder,Customer) then begin
            if not CRMSalesOrderToSalesOrder.GetCRMAccountOfCRMSalesOrder(CRMSalesorder,CRMAccount) then
              Error(CustomerHasChangedErr,CRMSalesorder.OrderNumber);
            if not CRMSynchHelper.SynchRecordIfMappingExists(Database::"CRM Account",CRMAccount.AccountId) then
              Error(CustomerHasChangedErr,CRMSalesorder.OrderNumber);
          end;
          if Customer."No." <> SalesInvoiceHeader."Sell-to Customer No." then
            Error(CustomerHasChangedErr,CRMSalesorder.OrderNumber);
          CRMInvoice.CustomerId := CRMSalesorder.CustomerId;
          CRMInvoice.CustomerIdType := CRMSalesorder.CustomerIdType;
        end else begin
          if SalesInvoiceHeader."Currency Code" <> '' then
            Error(PostedSalesInvInFCYErr);
          CRMInvoice.Name := SalesInvoiceHeader."No.";
          Customer.Get(SalesInvoiceHeader."Sell-to Customer No.");

          if not CRMIntegrationRecord.FindIDFromRecordID(Customer.RecordId,AccountId) then
            if not CRMSynchHelper.SynchRecordIfMappingExists(Database::Customer,Customer.RecordId) then
              Error(CustomerHasChangedErr,CRMSalesorder.OrderNumber);
          CRMInvoice.CustomerId := AccountId;
          CRMInvoice.CustomerIdType := CRMInvoice.Customeridtype::account;
          CRMSynchHelper.GetOrCreateCRMDefaultPriceList(CRMPricelevel);
          CRMInvoice.PriceLevelId := CRMPricelevel.PriceLevelId;
        end;
        DestinationRecordRef.GetTable(CRMInvoice);
    end;

    local procedure UpdateCRMInvoiceDetailsAfterInsertRecord(SourceRecordRef: RecordRef;DestinationRecordRef: RecordRef)
    var
        CRMInvoicedetail: Record "CRM Invoicedetail";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SourceRecordRef.SetTable(SalesInvoiceLine);
        DestinationRecordRef.SetTable(CRMInvoicedetail);

        CRMInvoicedetail.BaseAmount := SalesInvoiceLine.Amount;
        CRMInvoicedetail.ExtendedAmount := SalesInvoiceLine."Amount Including VAT";
        CRMInvoicedetail.Modify;

        DestinationRecordRef.GetTable(CRMInvoicedetail);
    end;

    local procedure UpdateCRMInvoiceDetailsBeforeInsertRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    var
        CRMInvoicedetail: Record "CRM Invoicedetail";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMSalesInvoiceHeaderId: Guid;
    begin
        SourceRecordRef.SetTable(SalesInvoiceLine);
        DestinationRecordRef.SetTable(CRMInvoicedetail);

        // Get the NAV and CRM invoice headers
        SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.");
        if not CRMIntegrationRecord.FindIDFromRecordID(SalesInvoiceHeader.RecordId,CRMSalesInvoiceHeaderId) then
          Error(NoCoupledSalesInvoiceHeaderErr);

        // Initialize the CRM invoice lines
        InitializeCRMInvoiceLineFromCRMHeader(CRMInvoicedetail,CRMSalesInvoiceHeaderId);
        InitializeCRMInvoiceLineFromSalesInvoiceLine(CRMInvoicedetail,SalesInvoiceLine);
        InitializeCRMInvoiceLineWithProductDetails(CRMInvoicedetail,SalesInvoiceLine);

        DestinationRecordRef.GetTable(CRMInvoicedetail);
    end;

    local procedure UpdateCRMPricelevelBeforeInsertRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    var
        CRMPricelevel: Record "CRM Pricelevel";
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        CustomerPriceGroup: Record "Customer Price Group";
        TypeHelper: Codeunit "Type Helper";
        DestinationFieldRef: FieldRef;
    begin
        SourceRecordRef.SetTable(CustomerPriceGroup);
        CheckCustPriceGroupForSync(CRMTransactioncurrency,CustomerPriceGroup);

        DestinationFieldRef := DestinationRecordRef.Field(CRMPricelevel.FieldNo(TransactionCurrencyId));
        CRMSynchHelper.UpdateCRMCurrencyIdIfChanged(CRMTransactioncurrency.ISOCurrencyCode,DestinationFieldRef);

        DestinationFieldRef := DestinationRecordRef.Field(CRMPricelevel.FieldNo(Description));
        TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef,CustomerPriceGroup.Description,Textencoding::UTF16);
    end;

    local procedure UpdateCRMPricelevelBeforeModifyRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    var
        CRMPricelevel: Record "CRM Pricelevel";
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        SourceRecordRef.SetTable(CustomerPriceGroup);
        CheckCustPriceGroupForSync(CRMTransactioncurrency,CustomerPriceGroup);

        DestinationRecordRef.SetTable(CRMPricelevel);
        CRMPricelevel.TestField(TransactionCurrencyId,CRMTransactioncurrency.TransactionCurrencyId);
    end;

    local procedure ResetCRMProductpricelevelFromCRMPricelevel(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    var
        CRMPricelevel: Record "CRM Pricelevel";
        CRMProductpricelevel: Record "CRM Productpricelevel";
        CustomerPriceGroup: Record "Customer Price Group";
        SalesPrice: Record "Sales Price";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        SalesPriceRecordRef: RecordRef;
    begin
        SourceRecordRef.SetTable(CustomerPriceGroup);
        DestinationRecordRef.SetTable(CRMPricelevel);

        CRMProductpricelevel.SetRange(PriceLevelId,CRMPricelevel.PriceLevelId);
        CRMProductpricelevel.DeleteAll;

        SalesPrice.SetRange("Sales Type",SalesPrice."sales type"::"Customer Price Group");
        SalesPrice.SetRange("Sales Code",CustomerPriceGroup.Code);
        if SalesPrice.FindFirst then begin
          SalesPriceRecordRef.GetTable(SalesPrice);
          CRMIntegrationTableSynch.SynchRecordsToIntegrationTable(SalesPriceRecordRef,false,false);
        end;
    end;

    local procedure UpdateCRMProductPricelevelBeforeTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef)
    var
        CRMProductpricelevel: Record "CRM Productpricelevel";
        CustomerPriceGroup: Record "Customer Price Group";
        SalesPrice: Record "Sales Price";
        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMPriceLevelId: Guid;
    begin
        SourceRecordRef.SetTable(SalesPrice);
        DestinationRecordRef.SetTable(CRMProductpricelevel);

        // Get the NAV Customer Price Group and CRM Pricelevel
        CustomerPriceGroup.Get(SalesPrice."Sales Code");
        if not CRMIntegrationRecord.FindIDFromRecordID(CustomerPriceGroup.RecordId,CRMPriceLevelId) then
          Error(NoCoupledPricelevelErr);

        // Initialize the CRM Product Pricelevels
        InitializeCRMProductPricelevelFromCRMPricelevel(CRMProductpricelevel,CRMPriceLevelId);
        InitializeCRMProductPricelevelFromSalesPrice(CRMProductpricelevel,SalesPrice);

        DestinationRecordRef.GetTable(CRMProductpricelevel);
    end;

    local procedure UpdateCRMProductAfterTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;DestinationIsInserted: Boolean) AdditionalFieldsWereModified: Boolean
    var
        Item: Record Item;
        Resource: Record Resource;
        CRMProduct: Record "CRM Product";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TypeHelper: Codeunit "Type Helper";
        DescriptionItemFieldRef: FieldRef;
        DescriptionProductFieldRef: FieldRef;
        DestinationFieldRef: FieldRef;
        UnitOfMeasureCodeFieldRef: FieldRef;
        UnitOfMeasureCode: Code[10];
        ProductTypeCode: Option;
        Blocked: Boolean;
    begin
        // Update CRM UoM ID, UoMSchedule Id. The CRM UoM Name and UoMScheduleName will be cascade-updated from their IDs by CRM
        if SourceRecordRef.Number = Database::Item then begin
          Blocked := SourceRecordRef.Field(Item.FieldNo(Blocked)).Value;
          UnitOfMeasureCodeFieldRef := SourceRecordRef.Field(Item.FieldNo("Base Unit of Measure"));
          ProductTypeCode := CRMProduct.Producttypecode::SalesInventory;
          // Update Description
          DescriptionItemFieldRef := SourceRecordRef.Field(Item.FieldNo("Description 2"));
          DescriptionProductFieldRef := DestinationRecordRef.Field(CRMProduct.FieldNo(Description));
          if TypeHelper.WriteTextToBlobIfChanged(DescriptionProductFieldRef,Format(DescriptionItemFieldRef.Value),Textencoding::UTF16) then
            AdditionalFieldsWereModified := true;
        end;

        if SourceRecordRef.Number = Database::Resource then begin
          Blocked := SourceRecordRef.Field(Resource.FieldNo(Blocked)).Value;
          UnitOfMeasureCodeFieldRef := SourceRecordRef.Field(Resource.FieldNo("Base Unit of Measure"));
          ProductTypeCode := CRMProduct.Producttypecode::Services;
        end;

        UnitOfMeasureCodeFieldRef.TestField;
        UnitOfMeasureCode := Format(UnitOfMeasureCodeFieldRef.Value);

        // Update CRM Currency Id (if changed)
        GeneralLedgerSetup.Get;
        DestinationFieldRef := DestinationRecordRef.Field(CRMProduct.FieldNo(TransactionCurrencyId));
        if CRMSynchHelper.UpdateCRMCurrencyIdIfChanged(Format(GeneralLedgerSetup."LCY Code"),DestinationFieldRef) then
          AdditionalFieldsWereModified := true;

        DestinationRecordRef.SetTable(CRMProduct);
        if CRMSynchHelper.UpdateCRMProductUoMFieldsIfChanged(CRMProduct,UnitOfMeasureCode) then
          AdditionalFieldsWereModified := true;

        // If the CRMProduct price is negative, update it to zero (CRM doesn't allow negative prices)
        if CRMSynchHelper.UpdateCRMProductPriceIfNegative(CRMProduct) then
          AdditionalFieldsWereModified := true;

        // If the CRM Quantity On Hand is negative, update it to zero
        if CRMSynchHelper.UpdateCRMProductQuantityOnHandIfNegative(CRMProduct) then
          AdditionalFieldsWereModified := true;

        // Create or update the default price list
        if CRMSynchHelper.CreatePriceListElementsOnProduct(CRMProduct) then
          AdditionalFieldsWereModified := true;

        // Update the Vendor Name
        if CRMSynchHelper.UpdateCRMProductVendorNameIfChanged(CRMProduct) then
          AdditionalFieldsWereModified := true;

        // Set the ProductTypeCode, to later know if this product came from an item or from a resource
        if CRMSynchHelper.UpdateCRMProductTypeCodeIfChanged(CRMProduct,ProductTypeCode) then
          AdditionalFieldsWereModified := true;

        if DestinationIsInserted then
          if CRMSynchHelper.UpdateCRMProductStateCodeIfChanged(CRMProduct,Blocked) then
            AdditionalFieldsWereModified := true;

        if AdditionalFieldsWereModified then
          DestinationRecordRef.GetTable(CRMProduct);
    end;

    local procedure UpdateCRMProductAfterInsertRecord(var DestinationRecordRef: RecordRef)
    var
        CRMProduct: Record "CRM Product";
    begin
        DestinationRecordRef.SetTable(CRMProduct);
        CRMSynchHelper.CreatePriceListElementsOnProduct(CRMProduct);
        CRMSynchHelper.SetCRMProductStateToActive(CRMProduct);
        CRMProduct.Modify;
        DestinationRecordRef.GetTable(CRMProduct);
    end;

    local procedure UpdateCRMProductBeforeInsertRecord(var DestinationRecordRef: RecordRef)
    var
        CRMProduct: Record "CRM Product";
    begin
        DestinationRecordRef.SetTable(CRMProduct);
        CRMSynchHelper.SetCRMDecimalsSupportedValue(CRMProduct);
        DestinationRecordRef.GetTable(CRMProduct);
    end;

    local procedure UpdateItemAfterTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean
    var
        Item: Record Item;
        CRMProduct: Record "CRM Product";
        Blocked: Boolean;
    begin
        SourceRecordRef.SetTable(CRMProduct);
        DestinationRecordRef.SetTable(Item);

        Blocked := CRMProduct.StateCode <> CRMProduct.Statecode::Active;
        if CRMSynchHelper.UpdateItemBlockedIfChanged(Item,Blocked) then begin
          DestinationRecordRef.GetTable(Item);
          AdditionalFieldsWereModified := true;
        end;
    end;

    local procedure UpdateResourceAfterTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean
    var
        Resource: Record Resource;
        CRMProduct: Record "CRM Product";
        Blocked: Boolean;
    begin
        SourceRecordRef.SetTable(CRMProduct);
        DestinationRecordRef.SetTable(Resource);

        Blocked := CRMProduct.StateCode <> CRMProduct.Statecode::Active;
        if CRMSynchHelper.UpdateResourceBlockedIfChanged(Resource,Blocked) then begin
          DestinationRecordRef.GetTable(Resource);
          AdditionalFieldsWereModified := true;
        end;
    end;

    local procedure UpdateCRMTransactionCurrencyBeforeInsertRecord(var DestinationRecordRef: RecordRef)
    var
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        DestinationCurrencyPrecisionFieldRef: FieldRef;
    begin
        // Fill in the target currency precision, taken from CRM precision defaults
        DestinationCurrencyPrecisionFieldRef := DestinationRecordRef.Field(CRMTransactioncurrency.FieldNo(CurrencyPrecision));
        DestinationCurrencyPrecisionFieldRef.Value := CRMSynchHelper.GetCRMCurrencyDefaultPrecision;
    end;

    local procedure UpdateCRMTransactionCurrencyAfterTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean
    var
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        Currency: Record Currency;
        CurrencyCodeFieldRef: FieldRef;
        DestinationExchangeRateFieldRef: FieldRef;
    begin
        // Fill-in the target currency Exchange Rate
        CurrencyCodeFieldRef := SourceRecordRef.Field(Currency.FieldNo(Code));
        DestinationExchangeRateFieldRef := DestinationRecordRef.Field(CRMTransactioncurrency.FieldNo(ExchangeRate));
        if CRMSynchHelper.UpdateFieldRefValueIfChanged(
             DestinationExchangeRateFieldRef,
             Format(CRMSynchHelper.GetCRMLCYToFCYExchangeRate(Format(CurrencyCodeFieldRef.Value))))
        then
          AdditionalFieldsWereModified := true;
    end;

    local procedure CRMTransactionCurrencyFindUncoupledDestinationRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef) DestinationFound: Boolean
    var
        Currency: Record Currency;
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        CurrencyCodeFieldRef: FieldRef;
    begin
        // Attempt to match currencies between NAV and CRM, on NAVCurrency.Code = CRMCurrency.ISOCode
        CurrencyCodeFieldRef := SourceRecordRef.Field(Currency.FieldNo(Code));

        // Find destination record
        CRMTransactioncurrency.SetRange(ISOCurrencyCode,Format(CurrencyCodeFieldRef.Value));
        // A match between the selected NAV currency and a CRM currency was found
        if CRMTransactioncurrency.FindFirst then
          DestinationFound := DestinationRecordRef.Get(CRMTransactioncurrency.RecordId);
    end;

    local procedure UpdateCRMUoMScheduleAfterTransferRecordFields(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean
    var
        CRMUomschedule: Record "CRM Uomschedule";
        DestinationFieldRef: FieldRef;
        UnitNameWasUpdated: Boolean;
        CRMUomScheduleName: Text[200];
        CRMUomScheduleStateCode: Option;
        UnitGroupName: Text[200];
        UnitOfMeasureName: Text[100];
        CRMID: Guid;
    begin
        // Prefix with NAV
        UnitOfMeasureName := CRMSynchHelper.GetUnitOfMeasureName(SourceRecordRef);
        UnitGroupName := CRMSynchHelper.GetUnitGroupName(UnitOfMeasureName); // prefix with "NAV "
        DestinationFieldRef := DestinationRecordRef.Field(CRMUomschedule.FieldNo(Name));
        CRMUomScheduleName := Format(DestinationFieldRef.Value);
        if CRMUomScheduleName <> UnitGroupName then begin
          DestinationFieldRef.Value := UnitGroupName;
          AdditionalFieldsWereModified := true;
        end;

        // Get the State Code
        DestinationFieldRef := DestinationRecordRef.Field(CRMUomschedule.FieldNo(StateCode));
        CRMUomScheduleStateCode := DestinationFieldRef.Value;

        DestinationFieldRef := DestinationRecordRef.Field(CRMUomschedule.FieldNo(UoMScheduleId));
        CRMID := DestinationFieldRef.Value;
        if not ValidateCRMUoMSchedule(CRMUomScheduleName,CRMUomScheduleStateCode,CRMID,UnitOfMeasureName,UnitNameWasUpdated) then
          exit;

        if UnitNameWasUpdated then
          AdditionalFieldsWereModified := true;
    end;

    local procedure CRMUoMScheduleFindUncoupledDestinationRecord(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef) DestinationFound: Boolean
    var
        CRMUomschedule: Record "CRM Uomschedule";
        UnitFieldWasUpdated: Boolean;
    begin
        // A match between the selected NAV Unit of Measure and a CRM <Unit Group, Unit> tuple was found
        if FindValidCRMUoMSchedule(CRMUomschedule,SourceRecordRef,UnitFieldWasUpdated) then
          DestinationFound := DestinationRecordRef.Get(CRMUomschedule.RecordId);
    end;

    local procedure FindValidCRMUoMSchedule(var CRMUomschedule: Record "CRM Uomschedule";SourceRecordRef: RecordRef;var UnitNameWasUpdated: Boolean): Boolean
    var
        UnitGroupName: Text[200];
        UnitOfMeasureName: Text[100];
    begin
        UnitOfMeasureName := CRMSynchHelper.GetUnitOfMeasureName(SourceRecordRef);
        UnitGroupName := CRMSynchHelper.GetUnitGroupName(UnitOfMeasureName); // prefix with "NAV "

        // If the CRM Unit Group does not exist, exit
        CRMUomschedule.SetRange(Name,UnitGroupName);
        if not CRMUomschedule.FindFirst then
          exit(false);

        ValidateCRMUoMSchedule(
          CRMUomschedule.Name,CRMUomschedule.StateCode,CRMUomschedule.UoMScheduleId,UnitOfMeasureName,UnitNameWasUpdated);

        exit(true);
    end;

    local procedure ValidateCRMUoMSchedule(CRMUomScheduleName: Text[200];CRMUomScheduleStateCode: Option;CRMUomScheduleId: Guid;UnitOfMeasureName: Text[100];var UnitNameWasUpdated: Boolean): Boolean
    var
        CRMUom: Record "CRM Uom";
        CRMUomschedule: Record "CRM Uomschedule";
    begin
        // If the CRM Unit Group is not active throw and error
        if CRMUomScheduleStateCode = CRMUomschedule.Statecode::Inactive then
          Error(CRMUnitGroupExistsAndIsInactiveErr,CRMUomschedule.TableCaption,CRMUomScheduleName);

        // If the CRM Unit Group contains > 1 Units, fail
        CRMUom.SetRange(UoMScheduleId,CRMUomScheduleId);
        if CRMUom.Count > 1 then
          Error(CRMUnitGroupContainsMoreThanOneUoMErr,CRMUomschedule.TableCaption,CRMUomScheduleName,CRMUom.TableCaption);

        // If the CRM Unit Group contains zero Units, then exit (no match found)
        if not CRMUom.FindFirst then
          exit(false);

        // Verify the CRM Unit name is correct, else update it
        if CRMUom.Name <> UnitOfMeasureName then begin
          CRMUom.Name := UnitOfMeasureName;
          CRMUom.Modify;
          UnitNameWasUpdated := true;
        end;

        exit(true);
    end;

    local procedure FindContactRelatedCustomer(SourceRecordRef: RecordRef;var ContactBusinessRelation: Record "Contact Business Relation"): Boolean
    var
        Contact: Record Contact;
        MarketingSetup: Record "Marketing Setup";
        CompanyNoFieldRef: FieldRef;
    begin
        // Tranfer the parent company id to the ParentCustomerId
        CompanyNoFieldRef := SourceRecordRef.Field(Contact.FieldNo("Company No."));
        if not Contact.Get(CompanyNoFieldRef.Value) then
          exit(false);

        MarketingSetup.Get;
        ContactBusinessRelation.SetFilter("Business Relation Code",MarketingSetup."Bus. Rel. Code for Customers");
        ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."link to table"::Customer);
        ContactBusinessRelation.SetFilter("Contact No.",Contact."No.");
        exit(ContactBusinessRelation.FindFirst);
    end;

    local procedure FindParentCRMAccountForContact(SourceRecordRef: RecordRef) AccountId: Guid
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        Customer: Record Customer;
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if not FindContactRelatedCustomer(SourceRecordRef,ContactBusinessRelation) then
          Error(ContactsMustBeRelatedToCompanyErr,SourceRecordRef.Field(Contact.FieldNo("No.")).Value);

        if not Customer.Get(ContactBusinessRelation."No.") then
          Error(RecordNotFoundErr,Customer.TableCaption,ContactBusinessRelation."No.");

        if not CRMIntegrationRecord.FindIDFromRecordID(Customer.RecordId,AccountId) then
          Error(RecordMustBeCoupledErr,Format(Customer.RecordId,0,1));
    end;

    local procedure InitializeCRMInvoiceLineFromCRMHeader(var CRMInvoicedetail: Record "CRM Invoicedetail";CRMInvoiceId: Guid)
    var
        CRMInvoice: Record "CRM Invoice";
    begin
        CRMInvoice.Get(CRMInvoiceId);
        CRMInvoicedetail.ActualDeliveryOn := CRMInvoice.DateDelivered;
        CRMInvoicedetail.TransactionCurrencyId := CRMInvoice.TransactionCurrencyId;
        CRMInvoicedetail.ExchangeRate := CRMInvoice.ExchangeRate;
        CRMInvoicedetail.InvoiceId := CRMInvoice.InvoiceId;
        CRMInvoicedetail.ShipTo_City := CRMInvoice.ShipTo_City;
        CRMInvoicedetail.ShipTo_Country := CRMInvoice.ShipTo_Country;
        CRMInvoicedetail.ShipTo_Line1 := CRMInvoice.ShipTo_Line1;
        CRMInvoicedetail.ShipTo_Line2 := CRMInvoice.ShipTo_Line2;
        CRMInvoicedetail.ShipTo_Line3 := CRMInvoice.ShipTo_Line3;
        CRMInvoicedetail.ShipTo_Name := CRMInvoice.ShipTo_Name;
        CRMInvoicedetail.ShipTo_PostalCode := CRMInvoice.ShipTo_PostalCode;
        CRMInvoicedetail.ShipTo_StateOrProvince := CRMInvoice.ShipTo_StateOrProvince;
        CRMInvoicedetail.ShipTo_Fax := CRMInvoice.ShipTo_Fax;
        CRMInvoicedetail.ShipTo_Telephone := CRMInvoice.ShipTo_Telephone;
    end;

    local procedure InitializeCRMInvoiceLineFromSalesInvoiceLine(var CRMInvoicedetail: Record "CRM Invoicedetail";SalesInvoiceLine: Record "Sales Invoice Line")
    begin
        CRMInvoicedetail.LineItemNumber := SalesInvoiceLine."Line No.";
        CRMInvoicedetail.Tax := SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine.Amount;
    end;

    local procedure InitializeCRMInvoiceLineWithProductDetails(var CRMInvoicedetail: Record "CRM Invoicedetail";SalesInvoiceLine: Record "Sales Invoice Line")
    var
        CRMProduct: Record "CRM Product";
        CRMProductId: Guid;
    begin
        CRMProductId := FindCRMProductId(SalesInvoiceLine);
        if IsNullGuid(CRMProductId) then begin
          // This will be created as a CRM write-in product
          CRMInvoicedetail.IsProductOverridden := true;
          CRMInvoicedetail.ProductDescription :=
            StrSubstNo('%1 %2.',Format(SalesInvoiceLine."No."),Format(SalesInvoiceLine.Description));
        end else begin
          // There is a coupled product or resource in CRM, transfer data from there
          CRMProduct.Get(CRMProductId);
          CRMInvoicedetail.TransactionCurrencyId := CRMProduct.TransactionCurrencyId;
          CRMInvoicedetail.ExchangeRate := CRMProduct.ExchangeRate;
          CRMInvoicedetail.ProductId := CRMProduct.ProductId;
          CRMInvoicedetail.UoMId := CRMProduct.DefaultUoMId;
        end;
    end;

    local procedure InitializeCRMProductPricelevelFromCRMPricelevel(var CRMProductpricelevel: Record "CRM Productpricelevel";CRMPricelevelId: Guid)
    var
        CRMPricelevel: Record "CRM Pricelevel";
    begin
        CRMPricelevel.Get(CRMPricelevelId);
        CRMProductpricelevel.PriceLevelId := CRMPricelevel.PriceLevelId;
        CRMProductpricelevel.TransactionCurrencyId := CRMPricelevel.TransactionCurrencyId;
    end;

    local procedure InitializeCRMProductPricelevelFromSalesPrice(var CRMProductpricelevel: Record "CRM Productpricelevel";SalesPrice: Record "Sales Price")
    var
        CRMUom: Record "CRM Uom";
    begin
        CRMProductpricelevel.ProductId := FindCRMProductIdForItem(SalesPrice."Item No.");
        CRMProductpricelevel.ProductNumber := SalesPrice."Item No.";
        CRMProductpricelevel.PricingMethodCode := CRMProductpricelevel.Pricingmethodcode::CurrencyAmount;

        FindCRMUoMIdForSalesPrice(SalesPrice,CRMUom);
        CRMProductpricelevel.UoMId := CRMUom.UoMId;
    end;

    local procedure AreFieldsRelatedToMappedTables(SourceFieldRef: FieldRef;DestinationFieldRef: FieldRef;var IntegrationTableMapping: Record "Integration Table Mapping"): Boolean
    var
        SourceTableID: Integer;
        DestinationTableID: Integer;
        Direction: Integer;
    begin
        if (SourceFieldRef.Relation <> 0) and (DestinationFieldRef.Relation <> 0) then begin
          SourceTableID := SourceFieldRef.Relation;
          DestinationTableID := DestinationFieldRef.Relation;
          if Format(DestinationFieldRef.Type) = 'GUID' then begin
            IntegrationTableMapping.SetRange("Table ID",SourceTableID);
            IntegrationTableMapping.SetRange("Integration Table ID",DestinationTableID);
            Direction := IntegrationTableMapping.Direction::ToIntegrationTable;
          end else begin
            IntegrationTableMapping.SetRange("Table ID",DestinationTableID);
            IntegrationTableMapping.SetRange("Integration Table ID",SourceTableID);
            Direction := IntegrationTableMapping.Direction::FromIntegrationTable;
          end;
          if IntegrationTableMapping.FindFirst then begin
            IntegrationTableMapping.Direction := Direction;
            exit(true);
          end;
          Error(
            MappingMustBeSetForGUIDFieldErr,
            SourceFieldRef.Relation,DestinationFieldRef.Relation,SourceFieldRef.Name,DestinationFieldRef.Name);
        end;
    end;

    local procedure IsTableMappedToCRMOption(TableID: Integer): Boolean
    var
        CRMOptionMapping: Record "CRM Option Mapping";
    begin
        CRMOptionMapping.SetRange("Table ID",TableID);
        exit(not CRMOptionMapping.IsEmpty);
    end;

    local procedure FindCRMProductId(SalesInvoiceLine: Record "Sales Invoice Line") CRMID: Guid
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        Resource: Record Resource;
    begin
        Clear(CRMID);
        case SalesInvoiceLine.Type of
          SalesInvoiceLine.Type::Item:
            CRMID := FindCRMProductIdForItem(SalesInvoiceLine."No.");
          SalesInvoiceLine.Type::Resource:
            begin
              Resource.Get(SalesInvoiceLine."No.");
              if not CRMIntegrationRecord.FindIDFromRecordID(Resource.RecordId,CRMID) then begin
                if not CRMSynchHelper.SynchRecordIfMappingExists(Database::Resource,Resource.RecordId) then
                  Error(CannotSynchProductErr,Resource."No.");
                if not CRMIntegrationRecord.FindIDFromRecordID(Resource.RecordId,CRMID) then
                  Error(CannotFindSyncedProductErr);
              end;
            end;
        end;
    end;

    local procedure FindCRMProductIdForItem(ItemNo: Code[20]) CRMID: Guid
    var
        Item: Record Item;
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        Item.Get(ItemNo);
        if not CRMIntegrationRecord.FindIDFromRecordID(Item.RecordId,CRMID) then begin
          if not CRMSynchHelper.SynchRecordIfMappingExists(Database::Item,Item.RecordId) then
            Error(CannotSynchProductErr,Item."No.");
          if not CRMIntegrationRecord.FindIDFromRecordID(Item.RecordId,CRMID) then
            Error(CannotFindSyncedProductErr);
        end;
    end;

    local procedure FindCRMUoMIdForSalesPrice(SalesPrice: Record "Sales Price";var CRMUom: Record "CRM Uom")
    var
        Item: Record Item;
        CRMUomschedule: Record "CRM Uomschedule";
        UoMCode: Code[10];
    begin
        if SalesPrice."Unit of Measure Code" = '' then begin
          Item.Get(SalesPrice."Item No.");
          UoMCode := Item."Base Unit of Measure";
        end else
          UoMCode := SalesPrice."Unit of Measure Code";
        CRMSynchHelper.GetValidCRMUnitOfMeasureRecords(CRMUom,CRMUomschedule,UoMCode);
    end;

    local procedure CheckSalesPricesForSync(CustomerPriceGroupCode: Code[10];ExpectedCurrencyCode: Code[10])
    var
        SalesPrice: Record "Sales Price";
        CRMUom: Record "CRM Uom";
    begin
        SalesPrice.SetRange("Sales Type",SalesPrice."sales type"::"Customer Price Group");
        SalesPrice.SetRange("Sales Code",CustomerPriceGroupCode);
        if SalesPrice.FindSet then
          repeat
            SalesPrice.TestField("Currency Code",ExpectedCurrencyCode);
            FindCRMProductIdForItem(SalesPrice."Item No.");
            FindCRMUoMIdForSalesPrice(SalesPrice,CRMUom);
          until SalesPrice.Next = 0;
    end;

    local procedure CheckCustPriceGroupForSync(var CRMTransactioncurrency: Record "CRM Transactioncurrency";CustomerPriceGroup: Record "Customer Price Group")
    var
        SalesPrice: Record "Sales Price";
    begin
        SalesPrice.SetRange("Sales Type",SalesPrice."sales type"::"Customer Price Group");
        SalesPrice.SetRange("Sales Code",CustomerPriceGroup.Code);
        if SalesPrice.FindFirst then begin
          CRMTransactioncurrency.Get(CRMSynchHelper.GetCRMTransactioncurrency(SalesPrice."Currency Code"));
          CheckSalesPricesForSync(CustomerPriceGroup.Code,SalesPrice."Currency Code");
        end else
          CRMSynchHelper.GetOrCreateNAVLCYInCRM(CRMTransactioncurrency);
    end;

    local procedure CheckItemOrResourceIsNotBlocked(SourceRecordRef: RecordRef)
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        Item: Record Item;
        Resource: Record Resource;
    begin
        SourceRecordRef.SetTable(SalesInvHeader);
        SalesInvLine.SetRange("Document No.",SalesInvHeader."No.");
        SalesInvLine.SetFilter(Type,'%1|%2',SalesInvLine.Type::Item,SalesInvLine.Type::Resource);
        if SalesInvLine.FindSet then
          repeat
            if SalesInvLine.Type = SalesInvLine.Type::Item then begin
              Item.Get(SalesInvLine."No.");
              Item.TestField(Blocked,false);
            end else begin
              Resource.Get(SalesInvLine."No.");
              Resource.TestField(Blocked,false);
            end;
          until SalesInvLine.Next = 0;
    end;

    local procedure ConvertTableToOption(SourceFieldRef: FieldRef;var OptionValue: Integer) TableIsMapped: Boolean
    var
        CRMOptionMapping: Record "CRM Option Mapping";
        RecordRef: RecordRef;
        RecID: RecordID;
    begin
        TableIsMapped := false;
        OptionValue := 0;
        if IsTableMappedToCRMOption(SourceFieldRef.Relation) then begin
          TableIsMapped := true;
          if FindRecordIDByPK(SourceFieldRef.Relation,SourceFieldRef.Value,RecID) then begin
            CRMOptionMapping.SetRange("Record ID",RecID);
            if CRMOptionMapping.FindFirst then
              OptionValue := CRMOptionMapping."Option Value";
          end;
          RecordRef.Close;
        end;
        exit(TableIsMapped);
    end;

    local procedure FindNewValueForCoupledRecordPK(IntegrationTableMapping: Record "Integration Table Mapping";SourceFieldRef: FieldRef;DestinationFieldRef: FieldRef;var NewValue: Variant) IsValueFound: Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecID: RecordID;
        CRMID: Guid;
    begin
        if FindNewValueForSpecialMapping(SourceFieldRef,NewValue) then
          exit(true);
        case IntegrationTableMapping.Direction of
          IntegrationTableMapping.Direction::ToIntegrationTable:
            begin
              if Format(SourceFieldRef.Value) = '' then begin
                NewValue := CRMID; // Blank GUID
                IsValueFound := true;
              end else
                if FindRecordIDByPK(SourceFieldRef.Relation,SourceFieldRef.Value,RecID) then
                  IsValueFound := CRMIntegrationRecord.FindIDFromRecordID(RecID,NewValue)
                else
                  Error(NAVRecordMustBeCoupledErr,SourceFieldRef.Name,SourceFieldRef.Value);
            end;
          IntegrationTableMapping.Direction::FromIntegrationTable:
            begin
              CRMID := SourceFieldRef.Value;
              if IsNullGuid(CRMID) then begin
                NewValue := '';
                IsValueFound := true;
              end else
                if CRMIntegrationRecord.FindRecordIDFromID(CRMID,DestinationFieldRef.Relation,RecID) then
                  IsValueFound := FindPKByRecordID(RecID,NewValue)
                else
                  Error(CRMRecordMustBeCoupledErr,SourceFieldRef.Name,CRMID,ProductName.Short);
            end;
        end;
    end;

    local procedure FindNewValueForSpecialMapping(SourceFieldRef: FieldRef;var NewValue: Variant) IsValueFound: Boolean
    var
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        CRMID: Guid;
    begin
        case SourceFieldRef.Relation of
          Database::Currency: // special handling of Local currency
            if Format(SourceFieldRef.Value) = '' then begin
              CRMSynchHelper.GetOrCreateNAVLCYInCRM(CRMTransactioncurrency);
              NewValue := CRMTransactioncurrency.TransactionCurrencyId;
              IsValueFound := true;
            end;
          Database::"CRM Transactioncurrency": // special handling of Local currency
            begin
              CRMID := SourceFieldRef.Value;
              if CRMSynchHelper.GetNavCurrencyCode(CRMID) = '' then begin
                NewValue := '';
                IsValueFound := true;
              end;
            end;
        end;
    end;

    local procedure FindPKByRecordID(RecID: RecordID;var PrimaryKey: Variant) Found: Boolean
    var
        RecordRef: RecordRef;
        KeyRef: KeyRef;
        FieldRef: FieldRef;
    begin
        Found := RecordRef.Get(RecID);
        KeyRef := RecordRef.KeyIndex(1);
        FieldRef := KeyRef.FieldIndex(1);
        PrimaryKey := FieldRef.Value;
    end;

    local procedure FindRecordIDByPK(TableID: Integer;PrimaryKey: Variant;var RecID: RecordID) Found: Boolean
    var
        RecordRef: RecordRef;
        KeyRef: KeyRef;
        FieldRef: FieldRef;
    begin
        RecordRef.Open(TableID);
        KeyRef := RecordRef.KeyIndex(1);
        FieldRef := KeyRef.FieldIndex(1);
        FieldRef.SetRange(PrimaryKey);
        Found := RecordRef.FindFirst;
        RecID := RecordRef.RecordId;
        RecordRef.Close;
    end;
}

