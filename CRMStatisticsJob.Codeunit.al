#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5350 "CRM Statistics Job"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Errors: Text;
    begin
        Errors := CreateOrUpdateCRMAccountStatisticsForCoupledCustomers;
        if Errors <> '' then
          SetErrorMessage(StrSubstNo(OneOrMoreFailuresErr,Errors));
    end;

    var
        OneOrMoreFailuresErr: label 'One or more failures occurred while updating customer statistics in Dynamics CRM. \%1.', Comment='%1 = Error messages';
        RecordFoundTxt: label '%1 %2 was not found.', Comment='%1 is a table name, e.g. Customer, %2 is a number, e.g. Customer 12344 was not found.';

    local procedure CreateOrUpdateCRMAccountStatisticsForCoupledCustomers(): Text
    var
        IntegrationRecord: Record "Integration Record";
        CRMIntegrationRecord: Record "CRM Integration Record";
        CustomerRecordID: RecordID;
        CRMID: Guid;
        Errors: Text;
        Error: Text;
    begin
        IntegrationRecord.SetRange("Table ID",Database::Customer);
        IntegrationRecord.SetRange("Deleted On",0DT);
        if not IntegrationRecord.FindSet then
          exit('');
        repeat
          CustomerRecordID := IntegrationRecord."Record ID";
          if CRMIntegrationRecord.FindIDFromRecordID(CustomerRecordID,CRMID) then begin
            Error := CreateOrUpdateCRMAccountStatisticsForCoupledCustomer(CustomerRecordID,CRMID);
            if Error <> '' then
              Errors += '\' + Error;
          end;
        until IntegrationRecord.Next = 0;
        exit(Errors);
    end;

    local procedure CreateOrUpdateCRMAccountStatisticsForCoupledCustomer(CustomerRecordID: RecordID;CRMAccountID: Guid): Text
    var
        Customer: Record Customer;
        CRMAccount: Record "CRM Account";
    begin
        if not Customer.Get(CustomerRecordID) then
          exit(StrSubstNo(RecordFoundTxt,Customer.TableCaption,CustomerRecordID));
        if not CRMAccount.Get(CRMAccountID) then
          exit(StrSubstNo(RecordFoundTxt,CRMAccount.TableCaption,CRMAccountID));
        CreateOrUpdateCRMAccountStatistics(Customer,CRMAccount);
        exit('');
    end;


    procedure CreateOrUpdateCRMAccountStatistics(Customer: Record Customer;var CRMAccount: Record "CRM Account")
    var
        CRMAccountStatistics: Record "CRM Account Statistics";
        CRMIntegrationRecord: Record "CRM Integration Record";
        LcyCRMTransactioncurrency: Record "CRM Transactioncurrency";
        CRMSynchHelper: Codeunit "CRM Synch. Helper";
    begin
        CRMSynchHelper.GetOrCreateNAVLCYInCRM(LcyCRMTransactioncurrency);

        if IsNullGuid(CRMAccount.AccountStatiticsId) then begin
          with CRMAccountStatistics do begin
            Init;
            AccountStatisticsId := CreateGuid;
            Name := CRMAccount.Name;

            // Set all Money type fields to 1 temporarily, because if they have always been zero they show as '--' in CRM
            "Balance (LCY)" := 1;
            "Outstanding Orders (LCY)" := 1;
            "Shipped Not Invoiced (LCY)" := 1;
            "Outstanding Invoices (LCY)" := 1;
            "Outstanding Serv Orders (LCY)" := 1;
            "Serv Shipped Not Invd (LCY)" := 1;
            "Outstd Serv Invoices (LCY)" := 1;
            "Total (LCY)" := 1;
            "Credit Limit (LCY)" := 1;
            "Overdue Amounts (LCY)" := 1;
            "Total Sales (LCY)" := 1;
            "Invd Prepayment Amount (LCY)" := 1;

            Insert;
          end;

          // Relate the Account to the Account Statistics, without changing whether is it perceived as modified since last synch
          CRMAccount.AccountStatiticsId := CRMAccountStatistics.AccountStatisticsId;
          if not CRMIntegrationRecord.IsModifiedAfterLastSynchonizedCRMRecord(
               CRMAccount.AccountId,Database::Customer,CRMAccount.ModifiedOn)
          then begin
            CRMAccount.Modify;
            CRMIntegrationRecord.SetLastSynchCRMModifiedOn(CRMAccount.AccountId,Database::Customer,CRMAccount.ModifiedOn);
          end else
            CRMAccount.Modify;
        end else begin
          CRMAccountStatistics.SetRange(AccountStatisticsId,CRMAccount.AccountStatiticsId);
          CRMAccountStatistics.FindFirst;
        end;

        // Update customer statistics
        Customer.CalcFields("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)",
          "Outstanding Invoices (LCY)","Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)",
          "Outstanding Serv.Invoices(LCY)");
        with CRMAccountStatistics do begin
          "Customer No" := Customer."No.";
          "Balance (LCY)" := Customer."Balance (LCY)";
          "Outstanding Orders (LCY)" := Customer."Outstanding Orders (LCY)";
          "Shipped Not Invoiced (LCY)" := Customer."Shipped Not Invoiced (LCY)";
          "Outstanding Invoices (LCY)" := Customer."Outstanding Invoices (LCY)";
          "Outstanding Serv Orders (LCY)" := Customer."Outstanding Serv. Orders (LCY)";
          "Serv Shipped Not Invd (LCY)" := Customer."Serv Shipped Not Invoiced(LCY)";
          "Outstd Serv Invoices (LCY)" := Customer."Outstanding Serv.Invoices(LCY)";
          "Total (LCY)" := Customer.GetTotalAmountLCY;
          "Credit Limit (LCY)" := Customer."Credit Limit (LCY)";
          "Overdue Amounts (LCY)" := Customer.CalcOverdueBalance;
          "Overdue Amounts As Of Date" := WorkDate;
          "Total Sales (LCY)" := Customer.GetSalesLCY;
          "Invd Prepayment Amount (LCY)" := Customer.GetInvoicedPrepmtAmountLCY;
          TransactionCurrencyId := LcyCRMTransactioncurrency.TransactionCurrencyId;
          Modify;
        end;
    end;
}

