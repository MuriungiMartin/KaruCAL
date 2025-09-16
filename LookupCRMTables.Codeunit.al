#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5332 "Lookup CRM Tables"
{

    trigger OnRun()
    begin
    end;


    procedure Lookup(CRMTableID: Integer;SavedCRMId: Guid;var CRMId: Guid): Boolean
    begin
        case CRMTableID of
          Database::"CRM Account":
            exit(LookupCRMAccount(SavedCRMId,CRMId));
          Database::"CRM Contact":
            exit(LookupCRMContact(SavedCRMId,CRMId));
          Database::"CRM Systemuser":
            exit(LookupCRMSystemuser(SavedCRMId,CRMId));
          Database::"CRM Transactioncurrency":
            exit(LookupCRMCurrency(SavedCRMId,CRMId));
          Database::"CRM Pricelevel":
            exit(LookupCRMPriceList(SavedCRMId,CRMId));
          Database::"CRM Product":
            exit(LookupCRMProduct(SavedCRMId,CRMId));
          Database::"CRM Uomschedule":
            exit(LookupCRMUomschedule(SavedCRMId,CRMId));
        end;
        exit(false);
    end;

    local procedure LookupCRMAccount(SavedCRMId: Guid;var CRMId: Guid): Boolean
    var
        CRMAccount: Record "CRM Account";
        OriginalCRMAccount: Record "CRM Account";
        CRMAccountList: Page "CRM Account List";
    begin
        if not IsNullGuid(CRMId) then begin
          CRMAccount.Get(CRMId);
          CRMAccountList.SetRecord(CRMAccount);
          if not IsNullGuid(SavedCRMId) then
            OriginalCRMAccount.Get(SavedCRMId);
          CRMAccountList.SetCurrentlyCoupledCRMAccount(OriginalCRMAccount);
        end;
        CRMAccountList.LookupMode(true);
        if CRMAccountList.RunModal = Action::LookupOK then begin
          CRMAccountList.GetRecord(CRMAccount);
          CRMId := CRMAccount.AccountId;
          exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMContact(SavedCRMId: Guid;var CRMId: Guid): Boolean
    var
        CRMContact: Record "CRM Contact";
        OriginalCRMContact: Record "CRM Contact";
        CRMContactList: Page "CRM Contact List";
    begin
        if not IsNullGuid(CRMId) then begin
          CRMContact.Get(CRMId);
          CRMContactList.SetRecord(CRMContact);
          if not IsNullGuid(SavedCRMId) then
            OriginalCRMContact.Get(SavedCRMId);
          CRMContactList.SetCurrentlyCoupledCRMContact(OriginalCRMContact);
        end;
        CRMContactList.LookupMode(true);
        if CRMContactList.RunModal = Action::LookupOK then begin
          CRMContactList.GetRecord(CRMContact);
          CRMId := CRMContact.ContactId;
          exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMSystemuser(SavedCRMId: Guid;var CRMId: Guid): Boolean
    var
        CRMSystemuser: Record "CRM Systemuser";
        OriginalCRMSystemuser: Record "CRM Systemuser";
        CRMSystemuserList: Page "CRM Systemuser List";
    begin
        if not IsNullGuid(CRMId) then begin
          CRMSystemuser.Get(CRMId);
          CRMSystemuserList.SetRecord(CRMSystemuser);
          if not IsNullGuid(SavedCRMId) then
            OriginalCRMSystemuser.Get(SavedCRMId);
          CRMSystemuserList.SetCurrentlyCoupledCRMSystemuser(OriginalCRMSystemuser);
        end;
        CRMSystemuserList.LookupMode(true);
        if CRMSystemuserList.RunModal = Action::LookupOK then begin
          CRMSystemuserList.GetRecord(CRMSystemuser);
          CRMId := CRMSystemuser.SystemUserId;
          exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMCurrency(SavedCRMId: Guid;var CRMId: Guid): Boolean
    var
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        OriginalCRMTransactioncurrency: Record "CRM Transactioncurrency";
        CRMTransactionCurrencyList: Page "CRM TransactionCurrency List";
    begin
        if not IsNullGuid(CRMId) then begin
          CRMTransactioncurrency.Get(CRMId);
          CRMTransactionCurrencyList.SetRecord(CRMTransactioncurrency);
          if not IsNullGuid(SavedCRMId) then
            OriginalCRMTransactioncurrency.Get(SavedCRMId);
          CRMTransactionCurrencyList.SetCurrentlyCoupledCRMTransactioncurrency(OriginalCRMTransactioncurrency);
        end;
        CRMTransactionCurrencyList.LookupMode(true);
        if CRMTransactionCurrencyList.RunModal = Action::LookupOK then begin
          CRMTransactionCurrencyList.GetRecord(CRMTransactioncurrency);
          CRMId := CRMTransactioncurrency.TransactionCurrencyId;
          exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMPriceList(SavedCRMId: Guid;var CRMId: Guid): Boolean
    var
        CRMPricelevel: Record "CRM Pricelevel";
        OriginalCRMPricelevel: Record "CRM Pricelevel";
        CRMPricelevelList: Page "CRM Pricelevel List";
    begin
        if not IsNullGuid(CRMId) then begin
          CRMPricelevel.Get(CRMId);
          CRMPricelevelList.SetRecord(CRMPricelevel);
          if not IsNullGuid(SavedCRMId) then
            OriginalCRMPricelevel.Get(SavedCRMId);
          CRMPricelevelList.SetCurrentlyCoupledCRMPricelevel(OriginalCRMPricelevel);
        end;
        CRMPricelevelList.LookupMode(true);
        if CRMPricelevelList.RunModal = Action::LookupOK then begin
          CRMPricelevelList.GetRecord(CRMPricelevel);
          CRMId := CRMPricelevel.PriceLevelId;
          exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMProduct(SavedCRMId: Guid;var CRMId: Guid): Boolean
    var
        CRMProduct: Record "CRM Product";
        OriginalCRMProduct: Record "CRM Product";
        CRMProductList: Page "CRM Product List";
    begin
        if not IsNullGuid(CRMId) then begin
          CRMProduct.Get(CRMId);
          CRMProductList.SetRecord(CRMProduct);
          if not IsNullGuid(SavedCRMId) then
            OriginalCRMProduct.Get(SavedCRMId);
          CRMProductList.SetCurrentlyCoupledCRMProduct(OriginalCRMProduct);
        end;
        CRMProductList.LookupMode(true);
        if CRMProductList.RunModal = Action::LookupOK then begin
          CRMProductList.GetRecord(CRMProduct);
          CRMId := CRMProduct.ProductId;
          exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMUomschedule(SavedCRMId: Guid;var CRMId: Guid): Boolean
    var
        CRMUomschedule: Record "CRM Uomschedule";
        OriginalCRMUomschedule: Record "CRM Uomschedule";
        CRMUnitGroupList: Page "CRM UnitGroup List";
    begin
        if not IsNullGuid(CRMId) then begin
          CRMUomschedule.Get(CRMId);
          CRMUnitGroupList.SetRecord(CRMUomschedule);
          if not IsNullGuid(SavedCRMId) then
            OriginalCRMUomschedule.Get(SavedCRMId);
          CRMUnitGroupList.SetCurrentlyCoupledCRMUomschedule(OriginalCRMUomschedule);
        end;
        CRMUnitGroupList.LookupMode(true);
        if CRMUnitGroupList.RunModal = Action::LookupOK then begin
          CRMUnitGroupList.GetRecord(CRMUomschedule);
          CRMId := CRMUomschedule.UoMScheduleId;
          exit(true);
        end;
        exit(false);
    end;
}

