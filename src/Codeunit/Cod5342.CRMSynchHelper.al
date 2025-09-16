#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5342 "CRM Synch. Helper"
{
    Permissions = TableData "Sales Invoice Header"=m;

    trigger OnRun()
    begin
    end;

    var
        CannotFindCRMSetupErr: label 'Cannot read the CRM Organization setup.';
        CRMBaseCurrencyNotFoundInNAVErr: label 'The currency with the ISO code ''%1'' cannot be found. Therefore, the exchange rate between ''%2'' and ''%3'' cannot be calculated.', Comment='%1,%2,%3=the ISO code of a currency (example: DKK);';
        DynamicsCRMTransactionCurrencyRecordNotFoundErr: label 'Cannot find the currency with the value ''%1'' in Microsoft Dynamics CRM.', Comment='%1=the currency code';
        DynamicsCRMUoMNotFoundInGroupErr: label 'Cannot find any unit of measure inside the unit group ''%1'' in Microsoft Dynamics CRM.', Comment='%1=Unit Group Name';
        DynamicsCRMUoMFoundMultipleInGroupErr: label 'Multiple units of measure were found in the unit group ''%1'' in Microsoft Dynamics CRM.', Comment='%1=Unit Group Name';
        IncorrectCRMUoMNameErr: label 'The unit of measure in the unit group ''%1'' has an incorrect name: expected name ''%2'', found name ''%3''.', Comment='%1=Unit Group name (ex: NAV PIECE), %2=Expected name (ex: PIECE), %3=Actual name (ex: BOX)';
        IncorrectCRMUoMQuantityErr: label 'The quantity on the unit of measure ''%1'' should be 1.', Comment='%1=unit of measure name (ex: PIECE).';
        DynamicsCRMUomscheduleNotFoundErr: label 'Cannot find the unit group ''%1'' in Microsoft Dynamics CRM.', Comment='%1 = unit group name';
        IncorrectCRMUoMStatusErr: label 'The unit of measure ''%1'' is not the base unit of measure of the unit group ''%2''.', Comment='%1=value of the unit of measure, %2=value of the unit group';
        InvalidDestinationRecordNoErr: label 'Invalid destination record number.';
        NavTxt: label 'NAV', Locked=true;
        RecordMustBeCoupledErr: label '%1 %2 must be coupled to a %3 record.', Comment='%1 = table caption, %2 = primary key value, %3 = CRM Table caption';
        RecordNotFoundErr: label '%1 could not be found in %2.', Comment='%1=value;%2=table name in which the value was searched';
        CanOnlyUseSystemUserOwnerTypeErr: label 'Only Dynamics CRM Owner of Type SystemUser can be mapped to Salespeople.', Comment='Dynamics CRM entity owner property can be of type team or systemuser. Only the type systemuser is supported.';
        DefaultNAVPriceListNameTxt: label '%1 Default Price List', Comment='%1 - product name';
        TempCRMPricelevel: Record "CRM Pricelevel" temporary;
        TempCRMTransactioncurrency: Record "CRM Transactioncurrency" temporary;
        TempCRMUom: Record "CRM Uom" temporary;
        TempCRMUomschedule: Record "CRM Uomschedule" temporary;


    procedure ClearCache()
    begin
        TempCRMPricelevel.Reset;
        TempCRMPricelevel.DeleteAll;
        Clear(TempCRMPricelevel);

        TempCRMTransactioncurrency.Reset;
        TempCRMTransactioncurrency.DeleteAll;
        Clear(TempCRMTransactioncurrency);

        TempCRMUom.Reset;
        TempCRMUom.DeleteAll;
        Clear(TempCRMUom);

        TempCRMUomschedule.Reset;
        TempCRMUomschedule.DeleteAll;
        Clear(TempCRMUomschedule);
    end;


    procedure CreateOrUpdateCRMPriceListItem(var CRMProduct: Record "CRM Product"): Boolean
    var
        CRMProductpricelevel: Record "CRM Productpricelevel";
        AdditionalFieldsWereModified: Boolean;
    begin
        if IsNullGuid(CRMProduct.ProductId) then
          exit(false);

        if SetCRMDefaultPriceListOnProduct(CRMProduct) then
          AdditionalFieldsWereModified := true;

        CRMProductpricelevel.SetRange(ProductId,CRMProduct.ProductId);
        if not CRMProductpricelevel.FindFirst then begin
          CRMProductpricelevel.Init;
          CRMProductpricelevel.PriceLevelId := CRMProduct.PriceLevelId;
          CRMProductpricelevel.UoMId := CRMProduct.DefaultUoMId;
          CRMProductpricelevel.UoMScheduleId := CRMProduct.DefaultUoMScheduleId;
          CRMProductpricelevel.ProductId := CRMProduct.ProductId;
          CRMProductpricelevel.Amount := CRMProduct.Price;
          CRMProductpricelevel.TransactionCurrencyId := CRMProduct.TransactionCurrencyId;
          CRMProductpricelevel.ProductNumber := CRMProduct.ProductNumber;
          CRMProductpricelevel.Insert;
          exit(true);
        end;

        if CRMProductpricelevel.PriceLevelId <> CRMProduct.PriceLevelId then begin
          CRMProductpricelevel.PriceLevelId := CRMProduct.PriceLevelId;
          AdditionalFieldsWereModified := true;
        end;

        if CRMProductpricelevel.UoMId <> CRMProduct.DefaultUoMId then begin
          CRMProductpricelevel.UoMId := CRMProduct.DefaultUoMId;
          AdditionalFieldsWereModified := true;
        end;

        if CRMProductpricelevel.UoMScheduleId <> CRMProduct.DefaultUoMScheduleId then begin
          CRMProductpricelevel.UoMScheduleId := CRMProduct.DefaultUoMScheduleId;
          AdditionalFieldsWereModified := true;
        end;

        if CRMProductpricelevel.ProductId <> CRMProduct.ProductId then begin
          CRMProductpricelevel.ProductId := CRMProduct.ProductId;
          AdditionalFieldsWereModified := true;
        end;

        if CRMProductpricelevel.Amount <> CRMProduct.Price then begin
          CRMProductpricelevel.Amount := CRMProduct.Price;
          AdditionalFieldsWereModified := true;
        end;

        if CRMProductpricelevel.TransactionCurrencyId <> CRMProduct.TransactionCurrencyId then begin
          CRMProductpricelevel.TransactionCurrencyId := CRMProduct.TransactionCurrencyId;
          AdditionalFieldsWereModified := true;
        end;

        if CRMProductpricelevel.ProductNumber <> CRMProduct.ProductNumber then begin
          CRMProductpricelevel.ProductNumber := CRMProduct.ProductNumber;
          AdditionalFieldsWereModified := true;
        end;

        if AdditionalFieldsWereModified then
          CRMProductpricelevel.Modify;

        exit(AdditionalFieldsWereModified);
    end;


    procedure CreatePriceListElementsOnProduct(var CRMProduct: Record "CRM Product"): Boolean
    begin
        exit(CreateOrUpdateCRMPriceListItem(CRMProduct));
    end;


    procedure FormatCurrencyToCRM(UnformattedCurrencyISOCode: Code[10]) FormattedCurrencyISOCode: Code[5]
    begin
        // NAV Currency ISO code is max 10 chars long, while CRM TransactionCurrency ISOCode is max 5

        // Trim to 5 chars
        FormattedCurrencyISOCode := Format(UnformattedCurrencyISOCode,5);

        // Remove any trailing whitespaces, ex: transform 'DKK  ' into 'DKK'
        FormattedCurrencyISOCode := DelChr(FormattedCurrencyISOCode);
    end;


    procedure GetOrCreateCRMDefaultPriceList(var CRMPricelevel: Record "CRM Pricelevel")
    var
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        CRMConnectionSetup: Record "CRM Connection Setup";
        DefaultCRMPriceLevelExists: Boolean;
        Name: Text[100];
    begin
        CRMConnectionSetup.Get;
        if not IsNullGuid(CRMConnectionSetup."Default CRM Price List ID") then begin
          CRMPricelevel.SetRange(PriceLevelId,CRMConnectionSetup."Default CRM Price List ID");
          DefaultCRMPriceLevelExists := FindCachedCRMPriceLevel(CRMPricelevel);
        end;

        if not DefaultCRMPriceLevelExists then begin
          Name := StrSubstNo(DefaultNAVPriceListNameTxt,ProductName.Short);
          CRMPricelevel.Reset;
          CRMPricelevel.SetRange(Name,Name);
          if not CRMPricelevel.FindFirst then begin
            CRMPricelevel.Name := Name;
            GetOrCreateNAVLCYInCRM(CRMTransactioncurrency);
            CRMPricelevel.TransactionCurrencyId := CRMTransactioncurrency.TransactionCurrencyId;
            CRMPricelevel.TransactionCurrencyIdName := CRMTransactioncurrency.CurrencyName;
            CRMPricelevel.Insert;
            AddToCacheCRMPriceLevel(CRMPricelevel);
          end;
          CRMConnectionSetup.Validate("Default CRM Price List ID",CRMPricelevel.PriceLevelId);
          CRMConnectionSetup.Modify;
        end;
    end;


    procedure GetOrCreateNAVLCYInCRM(var CRMTransactioncurrency: Record "CRM Transactioncurrency")
    var
        NAVLCYCode: Code[10];
    begin
        NAVLCYCode := GetNavLCYCode;
        CRMTransactioncurrency.SetRange(ISOCurrencyCode,NAVLCYCode);
        if FindCachedCRMTransactionCurrency(CRMTransactioncurrency) then
          exit;

        CRMTransactioncurrency.Init;
        CRMTransactioncurrency.ISOCurrencyCode := FormatCurrencyToCRM(NAVLCYCode);
        CRMTransactioncurrency.CurrencyName := CRMTransactioncurrency.ISOCurrencyCode;
        CRMTransactioncurrency.CurrencySymbol := CRMTransactioncurrency.ISOCurrencyCode;
        CRMTransactioncurrency.CurrencyPrecision := GetCRMCurrencyDefaultPrecision;
        CRMTransactioncurrency.ExchangeRate := GetCRMLCYToFCYExchangeRate(CRMTransactioncurrency.ISOCurrencyCode);
        CRMTransactioncurrency.Insert;
        AddToCacheCRMTransactionCurrency(CRMTransactioncurrency);
    end;


    procedure GetCRMCurrencyDefaultPrecision(): Integer
    var
        CRMOrganization: Record "CRM Organization";
    begin
        GetCRMOrganizationSetup(CRMOrganization);
        exit(CRMOrganization.CurrencyDecimalPrecision);
    end;

    local procedure GetCRMExchangeRateRoundingPrecision(): Decimal
    begin
        exit(0.0000000001);
    end;


    procedure GetCRMLCYToFCYExchangeRate(ToCurrencyISOCode: Text[10]): Decimal
    var
        CRMOrganization: Record "CRM Organization";
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
    begin
        // Calculate the exchange rate from CRM's base currency to the ToCurrencyISOCode

        // Search for CRM Base Currency by matching ISO code in NAV.
        GetCRMOrganizationSetup(CRMOrganization);
        if ToCurrencyISOCode = DelChr(CRMOrganization.BaseCurrencySymbol) then
          exit(1);

        CRMTransactioncurrency.SetRange(TransactionCurrencyId,CRMOrganization.BaseCurrencyId);
        if not FindCachedCRMTransactionCurrency(CRMTransactioncurrency) then
          Error(DynamicsCRMTransactionCurrencyRecordNotFoundErr,CRMOrganization.BaseCurrencySymbol);
        exit(GetFCYtoFCYExchangeRate(CRMTransactioncurrency.ISOCurrencyCode,ToCurrencyISOCode));
    end;


    procedure GetCRMOrganizationSetup(var CRMOrganization: Record "CRM Organization")
    begin
        if not CRMOrganization.FindFirst then
          Error(CannotFindCRMSetupErr);
    end;


    procedure GetFCYtoFCYExchangeRate(FromFCY: Code[10];ToFCY: Code[10]): Decimal
    var
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CalculatedExchangeRate: Decimal;
        NavLCYCode: Code[10];
    begin
        FromFCY := DelChr(FromFCY);
        ToFCY := DelChr(ToFCY);
        if (FromFCY = '') or (ToFCY = '') then
          Error(CRMBaseCurrencyNotFoundInNAVErr,'',ToFCY,FromFCY);

        if ToFCY = FromFCY then
          exit(1);

        NavLCYCode := GetNavLCYCode;
        if ToFCY = NavLCYCode then
          ToFCY := '';

        // NAV LCY and FromFCY are the same
        if NavLCYCode = FromFCY then
          exit(CurrencyExchangeRate.GetCurrentCurrencyFactor(ToFCY));

        if not Currency.Get(FromFCY) then
          Error(CRMBaseCurrencyNotFoundInNAVErr,FromFCY,ToFCY,FromFCY);

        // NAV LCY and FromFCY are different currencies
        CalculatedExchangeRate := CurrencyExchangeRate.ExchangeAmtFCYToFCY(WorkDate,ToFCY,FromFCY,1);
        CalculatedExchangeRate := ROUND(CalculatedExchangeRate,GetCRMExchangeRateRoundingPrecision,'=');
        exit(CalculatedExchangeRate);
    end;

    local procedure GetNavLCYCode(): Code[10]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        // LCY = Local CurrencY
        GeneralLedgerSetup.Get;
        GeneralLedgerSetup.TestField("LCY Code");
        exit(GeneralLedgerSetup."LCY Code");
    end;


    procedure GetUnitGroupName(UnitOfMeasureCode: Text): Text[200]
    begin
        exit(StrSubstNo('%1 %2',NavTxt,UnitOfMeasureCode));
    end;


    procedure GetUnitOfMeasureName(UnitOfMeasureRecordRef: RecordRef): Text[100]
    var
        UnitOfMeasure: Record "Unit of Measure";
        UnitOfMeasureCodeFieldRef: FieldRef;
    begin
        UnitOfMeasureCodeFieldRef := UnitOfMeasureRecordRef.Field(UnitOfMeasure.FieldNo(Code));
        exit(Format(UnitOfMeasureCodeFieldRef.Value));
    end;


    procedure SetCRMDecimalsSupportedValue(var CRMProduct: Record "CRM Product")
    var
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
    begin
        CRMProduct.QuantityDecimal := CRMSetupDefaults.GetProductQuantityPrecision;
    end;


    procedure SetCRMDefaultPriceListOnProduct(var CRMProduct: Record "CRM Product") AdditionalFieldsWereModified: Boolean
    var
        CRMPricelevel: Record "CRM Pricelevel";
    begin
        GetOrCreateCRMDefaultPriceList(CRMPricelevel);

        if CRMProduct.PriceLevelId <> CRMPricelevel.PriceLevelId then begin
          CRMProduct.PriceLevelId := CRMPricelevel.PriceLevelId;
          AdditionalFieldsWereModified := true;
        end;
    end;


    procedure SetCRMProductStateToActive(var CRMProduct: Record "CRM Product")
    begin
        CRMProduct.StateCode := CRMProduct.Statecode::Active;
        CRMProduct.StatusCode := CRMProduct.Statuscode::Active;
    end;


    procedure SetCRMProductStateToRetired(var CRMProduct: Record "CRM Product")
    begin
        CRMProduct.StateCode := CRMProduct.Statecode::Retired;
        CRMProduct.StatusCode := CRMProduct.Statuscode::Retired;
    end;


    procedure SetContactParentCompany(AccountID: Guid;DestinationContactRecordRef: RecordRef): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        ContactBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        Contact: Record Contact;
        LookupRecordID: RecordID;
        DestinationFieldRef: FieldRef;
    begin
        if DestinationContactRecordRef.Number <> Database::Contact then
          Error(InvalidDestinationRecordNoErr);

        if IsNullGuid(AccountID) then
          exit(false);

        if not CRMIntegrationRecord.FindRecordIDFromID(AccountID,Database::Customer,LookupRecordID) then begin
          if not SynchRecordIfMappingExists(Database::"CRM Account",AccountID) then
            exit(false);

          if not CRMIntegrationRecord.FindRecordIDFromID(AccountID,Database::Customer,LookupRecordID) then
            exit(false);
        end;

        if not Customer.Get(LookupRecordID) then
          exit(false);

        ContactBusinessRelation.SetCurrentkey("Link to Table","No.");
        ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."link to table"::Customer);
        ContactBusinessRelation.SetRange("No.",Customer."No.");
        if not ContactBusinessRelation.FindFirst then
          exit(false);

        if not Contact.Get(ContactBusinessRelation."Contact No.") then
          exit(false);

        DestinationFieldRef := DestinationContactRecordRef.Field(Contact.FieldNo("Company No."));
        DestinationFieldRef.Value := Contact."No.";
        DestinationFieldRef := DestinationContactRecordRef.Field(Contact.FieldNo("Company Name"));
        DestinationFieldRef.Value := Contact.Name;
        exit(true);
    end;


    procedure SynchRecordIfMappingExists(IntegrationTableNo: Integer;PrimaryKey: Variant): Boolean
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationSynchJob: Record "Integration Synch. Job";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        NewJobEntryId: Guid;
    begin
        if PrimaryKey.IsRecordId then
          if not GetMappingForTable(IntegrationTableNo,IntegrationTableMapping) then
            exit(false);
        if PrimaryKey.IsGuid and not GetIntegrationMappingForTable(IntegrationTableNo,IntegrationTableMapping) then
          exit(false);

        NewJobEntryId := CRMIntegrationTableSynch.SynchRecord(IntegrationTableMapping,PrimaryKey,true,false);
        if IsNullGuid(NewJobEntryId) or (not IntegrationSynchJob.Get(NewJobEntryId)) then
          exit(false);

        exit((IntegrationSynchJob.Inserted > 0) or
          (IntegrationSynchJob.Modified > 0) or
          (IntegrationSynchJob.Unchanged > 0));
    end;


    procedure UpdateCRMCurrencyIdIfChanged(CurrencyCode: Text;var DestinationCurrencyIDFieldRef: FieldRef): Boolean
    begin
        // Given a source NAV currency code, find a currency with the same ISO code in CRM and update the target CRM currency value if needed
        exit(UpdateFieldRefValueIfChanged(DestinationCurrencyIDFieldRef,GetCRMTransactioncurrency(CurrencyCode)));
    end;


    procedure UpdateCRMInvoiceStatus(var CRMInvoice: Record "CRM Invoice";SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Document No.",SalesInvoiceHeader."No.");
        CustLedgerEntry.SetRange("Document Type",CustLedgerEntry."document type"::Invoice);
        if not CustLedgerEntry.FindFirst then
          exit;
        CustLedgerEntry.CalcFields("Remaining Amount",Amount);
        if CustLedgerEntry."Remaining Amount" = 0 then begin
          CRMInvoice.StateCode := CRMInvoice.Statecode::Paid;
          CRMInvoice.StatusCode := CRMInvoice.Statuscode::Complete;
        end else
          if CustLedgerEntry."Remaining Amount" <> CustLedgerEntry.Amount then begin
            CRMInvoice.StateCode := CRMInvoice.Statecode::Active;
            CRMInvoice.StatusCode := CRMInvoice.Statuscode::Partial;
          end else begin
            CRMInvoice.StateCode := CRMInvoice.Statecode::Active;
            CRMInvoice.StatusCode := CRMInvoice.Statuscode::Billed;
          end;
        CRMInvoice.Modify;
    end;


    procedure UpdateCRMProductPriceIfNegative(var CRMProduct: Record "CRM Product"): Boolean
    begin
        // CRM doesn't allow negative prices. Update the price to zero, if negative (this preserves the behavior of the old CRM Connector)
        if CRMProduct.Price < 0 then begin
          CRMProduct.Price := 0;
          exit(true);
        end;

        exit(false);
    end;


    procedure UpdateCRMProductQuantityOnHandIfNegative(var CRMProduct: Record "CRM Product"): Boolean
    begin
        // Update to zero, if negative (this preserves the behavior of the old CRM Connector)
        if CRMProduct.QuantityOnHand < 0 then begin
          CRMProduct.QuantityOnHand := 0;
          exit(true);
        end;

        exit(false);
    end;


    procedure UpdateCRMProductTypeCodeIfChanged(var CRMProduct: Record "CRM Product";NewProductTypeCode: Integer): Boolean
    begin
        // We use ProductTypeCode::SalesInventory and ProductTypeCode::Services to trace back later,
        // where this CRM product originated from: a NAV Item, or a NAV Resource
        if CRMProduct.ProductTypeCode <> NewProductTypeCode then begin
          CRMProduct.ProductTypeCode := NewProductTypeCode;
          exit(true);
        end;

        exit(false);
    end;


    procedure UpdateCRMProductStateCodeIfChanged(var CRMProduct: Record "CRM Product";NewBlocked: Boolean): Boolean
    var
        NewStateCode: Option;
    begin
        if NewBlocked then
          NewStateCode := CRMProduct.Statecode::Retired
        else
          NewStateCode := CRMProduct.Statecode::Active;

        if NewStateCode <> CRMProduct.StateCode then begin
          if NewBlocked then
            SetCRMProductStateToRetired(CRMProduct)
          else
            SetCRMProductStateToActive(CRMProduct);
          exit(true);
        end;

        exit(false);
    end;


    procedure UpdateItemBlockedIfChanged(var Item: Record Item;NewBlocked: Boolean): Boolean
    begin
        if Item.Blocked <> NewBlocked then begin
          Item.Blocked := NewBlocked;
          exit(true);
        end;
    end;


    procedure UpdateResourceBlockedIfChanged(var Resource: Record Resource;NewBlocked: Boolean): Boolean
    begin
        if Resource.Blocked <> NewBlocked then begin
          Resource.Blocked := NewBlocked;
          exit(true);
        end;
    end;


    procedure UpdateCRMProductUoMFieldsIfChanged(var CRMProduct: Record "CRM Product";UnitOfMeasureCode: Code[10]): Boolean
    var
        CRMUom: Record "CRM Uom";
        CRMUomschedule: Record "CRM Uomschedule";
        AdditionalFieldsWereModified: Boolean;
    begin
        // Get the unit of measure ID used in this product
        // On that unit of measure ID, get the UoMName, UomscheduleID, UomscheduleName and update them in the product if needed

        GetValidCRMUnitOfMeasureRecords(CRMUom,CRMUomschedule,UnitOfMeasureCode);

        // Update UoM ID if changed
        if CRMProduct.DefaultUoMId <> CRMUom.UoMId then begin
          CRMProduct.DefaultUoMId := CRMUom.UoMId;
          AdditionalFieldsWereModified := true;
        end;

        // Update the Uomschedule ID if changed
        if CRMProduct.DefaultUoMScheduleId <> CRMUomschedule.UoMScheduleId then begin
          CRMProduct.DefaultUoMScheduleId := CRMUomschedule.UoMScheduleId;
          AdditionalFieldsWereModified := true;
        end;

        exit(AdditionalFieldsWereModified);
    end;


    procedure UpdateCRMProductVendorNameIfChanged(var CRMProduct: Record "CRM Product"): Boolean
    var
        Vendor: Record Vendor;
    begin
        if not Vendor.Get(CRMProduct.VendorPartNumber) then
          exit(false);

        if CRMProduct.VendorName <> Vendor.Name then begin
          CRMProduct.VendorName := Vendor.Name;
          exit(true);
        end;

        exit(false);
    end;


    procedure UpdateOwnerIfChanged(SourceRecordRef: RecordRef;DestinationRecordRef: RecordRef;SourceSalespersonCodeFieldNo: Integer;DestinationOwnerFieldNo: Integer;DestinationOwnerTypeFieldNo: Integer;DestinationOwnerTypeValue: Option): Boolean
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CRMIntegrationRecord: Record "CRM Integration Record";
        IntegrationTableMapping: Record "Integration Table Mapping";
        SalespersonCodeFieldRef: FieldRef;
        OwnerFieldRef: FieldRef;
        OwnerTypeFieldRef: FieldRef;
        OwnerGuid: Guid;
        CurrentOwnerGuid: Guid;
    begin
        IntegrationTableMapping.SetRange("Table ID",Database::"Salesperson/Purchaser");
        IntegrationTableMapping.SetRange("Integration Table ID",Database::"CRM Systemuser");
        if not IntegrationTableMapping.FindFirst then
          exit(false); // There are no mapping for salepeople to SystemUsers

        SalespersonCodeFieldRef := SourceRecordRef.Field(SourceSalespersonCodeFieldNo);

        // Ignore empty salesperson code.
        if Format(SalespersonCodeFieldRef.Value) = '' then
          exit(false);

        SalespersonPurchaser.SetFilter(Code,Format(SalespersonCodeFieldRef.Value));
        if not SalespersonPurchaser.FindFirst then
          Error(RecordNotFoundErr,SalespersonCodeFieldRef.Value,SalespersonPurchaser.TableCaption);

        if not CRMIntegrationRecord.FindIDFromRecordID(SalespersonPurchaser.RecordId,OwnerGuid) then
          Error(
            RecordMustBeCoupledErr,SalespersonPurchaser.TableCaption,SalespersonCodeFieldRef.Value,
            IntegrationTableMapping.GetExtendedIntegrationTableCaption);

        OwnerFieldRef := DestinationRecordRef.Field(DestinationOwnerFieldNo);
        CurrentOwnerGuid := OwnerFieldRef.Value;
        if CurrentOwnerGuid <> OwnerGuid then begin
          OwnerFieldRef.Value := OwnerGuid;
          OwnerTypeFieldRef := DestinationRecordRef.Field(DestinationOwnerTypeFieldNo);
          OwnerTypeFieldRef.Value := DestinationOwnerTypeValue;
          exit(true);
        end;

        exit(false);
    end;


    procedure UpdateContactOnModifyCustomer(RecRef: RecordRef)
    var
        Customer: Record Customer;
        CustContUpdate: Codeunit "CustCont-Update";
    begin
        if RecRef.Number = Database::Customer then begin
          RecRef.SetTable(Customer);
          CustContUpdate.OnModify(Customer);
        end;
    end;


    procedure UpdateSalesPersonCodeIfChanged(SourceRecordRef: RecordRef;var DestinationRecordRef: RecordRef;SourceOwnerIDFieldNo: Integer;SourceOwnerTypeFieldNo: Integer;AllowedOwnerTypeValue: Option;DestinationSalesPersonCodeFieldNo: Integer): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        IntegrationTableMapping: Record "Integration Table Mapping";
        OutlookSynchTypeConv: Codeunit "Outlook Synch. Type Conv";
        SalesPersonRecordID: RecordID;
        SourceFieldRef: FieldRef;
        DestinationFieldRef: FieldRef;
        CRMSystemUserID: Guid;
        CurrentOptionValue: Integer;
    begin
        IntegrationTableMapping.SetRange("Table ID",Database::"Salesperson/Purchaser");
        IntegrationTableMapping.SetRange("Integration Table ID",Database::"CRM Systemuser");
        if IntegrationTableMapping.IsEmpty then
          exit(false); // There are no mapping for salepeople to SystemUsers

        SourceFieldRef := SourceRecordRef.Field(SourceOwnerTypeFieldNo);
        CurrentOptionValue := OutlookSynchTypeConv.TextToOptionValue(Format(SourceFieldRef.Value),SourceFieldRef.OptionString);
        // Allow 0 as it is the default value for CRM options.
        if (CurrentOptionValue <> 0) and (CurrentOptionValue <> AllowedOwnerTypeValue) then
          Error(CanOnlyUseSystemUserOwnerTypeErr);

        SourceFieldRef := SourceRecordRef.Field(SourceOwnerIDFieldNo);
        CRMSystemUserID := SourceFieldRef.Value;

        if IsNullGuid(CRMSystemUserID) then
          exit(false);

        DestinationFieldRef := DestinationRecordRef.Field(DestinationSalesPersonCodeFieldNo);

        if not CRMIntegrationRecord.FindRecordIDFromID(CRMSystemUserID,Database::"Salesperson/Purchaser",SalesPersonRecordID) then begin
          if not SynchRecordIfMappingExists(Database::"CRM Systemuser",CRMSystemUserID) then
            exit(false);
          if not CRMIntegrationRecord.FindRecordIDFromID(CRMSystemUserID,Database::"Salesperson/Purchaser",SalesPersonRecordID) then
            exit(false);
        end;

        if not SalespersonPurchaser.Get(SalesPersonRecordID) then
          exit(false);

        exit(UpdateFieldRefValueIfChanged(DestinationFieldRef,SalespersonPurchaser.Code));
    end;


    procedure UpdateFieldRefValueIfChanged(var DestinationFieldRef: FieldRef;NewFieldValue: Text): Boolean
    begin
        // Compare and updates the fieldref value, if different
        if Format(DestinationFieldRef.Value) = NewFieldValue then
          exit(false);

        // Return TRUE if the value was changed
        DestinationFieldRef.Value := NewFieldValue;
        exit(true);
    end;


    procedure GetValidCRMUnitOfMeasureRecords(var CRMUom: Record "CRM Uom";var CRMUomschedule: Record "CRM Uomschedule";UnitOfMeasureCode: Code[10])
    var
        CRMUnitGroupName: Text;
    begin
        // This function checks that the CRM Unit of Measure and its parent group exist in CRM, and that the user didn't change their properties from
        // the expected ones

        // Attempt to get the Uomschedule with the expected name = 'NAV ' + UnitOfMeasureCode
        CRMUnitGroupName := GetUnitGroupName(UnitOfMeasureCode);
        CRMUomschedule.SetRange(Name,CRMUnitGroupName);

        // CRM Unit Group - Not found
        if not FindCachedCRMUomschedule(CRMUomschedule) then
          Error(DynamicsCRMUomscheduleNotFoundErr,CRMUnitGroupName);

        // CRM Unit Group  - Multiple found
        if CountCRMUomschedule(CRMUomschedule) > 1 then
          Error(DynamicsCRMUoMFoundMultipleInGroupErr,CRMUnitGroupName);

        // CRM Unit Group - One found - check its child unit of measure, should be just one
        CRMUom.SetRange(UoMScheduleId,CRMUomschedule.UoMScheduleId);

        // CRM Unit of Measure - not found
        if not FindCachedCRMUom(CRMUom) then
          Error(DynamicsCRMUoMNotFoundInGroupErr,CRMUomschedule.Name);

        // CRM Unit of Measure - multiple found
        if CountCRMUom(CRMUom) > 1 then
          Error(DynamicsCRMUoMFoundMultipleInGroupErr,CRMUomschedule.Name);

        // CRM Unit of Measure - one found, does it have the correct name?
        if CRMUom.Name <> UnitOfMeasureCode then
          Error(IncorrectCRMUoMNameErr,CRMUomschedule.Name,UnitOfMeasureCode,CRMUom.Name);

        // CRM Unit of Measure should be the base
        if not CRMUom.IsScheduleBaseUoM then
          Error(IncorrectCRMUoMStatusErr,CRMUom.Name,CRMUomschedule.Name);

        // CRM Unit of Measure should have the conversion rate of 1
        if CRMUom.Quantity <> 1 then
          Error(IncorrectCRMUoMQuantityErr,CRMUom.Name);

        // All checks passed. We're good to go
    end;

    local procedure GetIntegrationMappingForTable(IntegrationTableID: Integer;var IntegrationTableMapping: Record "Integration Table Mapping"): Boolean
    begin
        IntegrationTableMapping.SetRange("Integration Table ID",IntegrationTableID);
        exit(IntegrationTableMapping.FindFirst);
    end;


    procedure GetMappingForTable(TableID: Integer;var IntegrationTableMapping: Record "Integration Table Mapping"): Boolean
    begin
        IntegrationTableMapping.SetRange("Table ID",TableID);
        exit(IntegrationTableMapping.FindFirst);
    end;


    procedure GetNavCurrencyCode(TransactionCurrencyId: Guid): Code[10]
    var
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        Currency: Record Currency;
        NAVLCYCode: Code[10];
        CRMCurrencyCode: Code[10];
    begin
        if IsNullGuid(TransactionCurrencyId) then
          exit('');
        NAVLCYCode := GetNavLCYCode;
        CRMTransactioncurrency.SetRange(TransactionCurrencyId,TransactionCurrencyId);
        if not FindCachedCRMTransactionCurrency(CRMTransactioncurrency) then
          Error(DynamicsCRMTransactionCurrencyRecordNotFoundErr,TransactionCurrencyId);
        CRMCurrencyCode := DelChr(CRMTransactioncurrency.ISOCurrencyCode);
        if CRMCurrencyCode = NAVLCYCode then
          exit('');

        Currency.Get(CRMCurrencyCode);
        exit(Currency.Code);
    end;


    procedure GetCRMTransactioncurrency(CurrencyCode: Text): Guid
    var
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        NAVLCYCode: Code[10];
    begin
        // In NAV, an empty currency means local currency (LCY)
        NAVLCYCode := GetNavLCYCode;
        if DelChr(CurrencyCode) = '' then
          CurrencyCode := NAVLCYCode;

        if CurrencyCode = NAVLCYCode then
          GetOrCreateNAVLCYInCRM(CRMTransactioncurrency)
        else begin
          CRMTransactioncurrency.SetRange(ISOCurrencyCode,CurrencyCode);
          if not FindCachedCRMTransactionCurrency(CRMTransactioncurrency) then
            Error(DynamicsCRMTransactionCurrencyRecordNotFoundErr,CurrencyCode);
        end;
        exit(CRMTransactioncurrency.TransactionCurrencyId)
    end;

    local procedure AddToCacheCRMPriceLevel(CRMPricelevel: Record "CRM Pricelevel")
    begin
        TempCRMPricelevel := CRMPricelevel;
        TempCRMPricelevel.Insert;
    end;

    local procedure CacheCRMPriceLevel(): Boolean
    var
        CRMPricelevel: Record "CRM Pricelevel";
    begin
        TempCRMPricelevel.Reset;
        if TempCRMPricelevel.IsEmpty then
          if CRMPricelevel.FindSet then
            repeat
              AddToCacheCRMPriceLevel(CRMPricelevel)
            until CRMPricelevel.Next = 0;
        exit(not TempCRMPricelevel.IsEmpty);
    end;

    local procedure FindCachedCRMPriceLevel(var CRMPricelevel: Record "CRM Pricelevel"): Boolean
    begin
        if not CacheCRMPriceLevel then
          exit(false);
        TempCRMPricelevel.Copy(CRMPricelevel);
        if TempCRMPricelevel.FindFirst then begin
          CRMPricelevel.Copy(TempCRMPricelevel);
          exit(true);
        end;
    end;

    local procedure AddToCacheCRMTransactionCurrency(CRMTransactioncurrency: Record "CRM Transactioncurrency")
    begin
        TempCRMTransactioncurrency := CRMTransactioncurrency;
        TempCRMTransactioncurrency.Insert;
    end;

    local procedure CacheCRMTransactionCurrency(): Boolean
    var
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
    begin
        TempCRMTransactioncurrency.Reset;
        if TempCRMTransactioncurrency.IsEmpty then
          if CRMTransactioncurrency.FindSet then
            repeat
              AddToCacheCRMTransactionCurrency(CRMTransactioncurrency)
            until CRMTransactioncurrency.Next = 0;
        exit(not TempCRMTransactioncurrency.IsEmpty);
    end;

    local procedure FindCachedCRMTransactionCurrency(var CRMTransactioncurrency: Record "CRM Transactioncurrency"): Boolean
    begin
        if not CacheCRMTransactionCurrency then
          exit(false);
        TempCRMTransactioncurrency.Copy(CRMTransactioncurrency);
        if TempCRMTransactioncurrency.FindFirst then begin
          CRMTransactioncurrency.Copy(TempCRMTransactioncurrency);
          exit(true);
        end;
    end;

    local procedure AddToCacheCRMUom(CRMUom: Record "CRM Uom")
    begin
        TempCRMUom := CRMUom;
        TempCRMUom.Insert;
    end;

    local procedure CacheCRMUom(): Boolean
    var
        CRMUom: Record "CRM Uom";
    begin
        TempCRMUom.Reset;
        if TempCRMUom.IsEmpty then
          if CRMUom.FindSet then
            repeat
              AddToCacheCRMUom(CRMUom)
            until CRMUom.Next = 0;
        exit(not TempCRMUom.IsEmpty);
    end;

    local procedure CountCRMUom(var CRMUom: Record "CRM Uom"): Integer
    begin
        TempCRMUom.Copy(CRMUom);
        exit(TempCRMUom.Count);
    end;

    local procedure FindCachedCRMUom(var CRMUom: Record "CRM Uom"): Boolean
    begin
        if not CacheCRMUom then
          exit(false);
        TempCRMUom.Copy(CRMUom);
        if TempCRMUom.FindFirst then begin
          CRMUom.Copy(TempCRMUom);
          exit(true);
        end;
    end;

    local procedure AddToCacheCRMUomschedule(CRMUomschedule: Record "CRM Uomschedule")
    begin
        TempCRMUomschedule := CRMUomschedule;
        TempCRMUomschedule.Insert;
    end;

    local procedure CacheCRMUomschedule(): Boolean
    var
        CRMUomschedule: Record "CRM Uomschedule";
    begin
        TempCRMUomschedule.Reset;
        if TempCRMUomschedule.IsEmpty then
          if CRMUomschedule.FindSet then
            repeat
              AddToCacheCRMUomschedule(CRMUomschedule)
            until CRMUomschedule.Next = 0;
        exit(not TempCRMUomschedule.IsEmpty);
    end;

    local procedure CountCRMUomschedule(var CRMUomschedule: Record "CRM Uomschedule"): Integer
    begin
        TempCRMUomschedule.Copy(CRMUomschedule);
        exit(TempCRMUomschedule.Count);
    end;

    local procedure FindCachedCRMUomschedule(var CRMUomschedule: Record "CRM Uomschedule"): Boolean
    begin
        if not CacheCRMUomschedule then
          exit(false);
        TempCRMUomschedule.Copy(CRMUomschedule);
        if TempCRMUomschedule.FindFirst then begin
          CRMUomschedule.Copy(TempCRMUomschedule);
          exit(true);
        end;
    end;


    procedure SetSalesInvoiceHeaderCoupledToCRM(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."Coupled to CRM" := true;
        SalesInvoiceHeader.Modify;
    end;
}

