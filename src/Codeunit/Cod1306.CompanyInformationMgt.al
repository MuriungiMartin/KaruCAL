#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1306 "Company Information Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        CompanyBankAccountTxt: label 'CHECKING';
        XPAYMENTTxt: label 'PAYMENT', Comment='Payment';
        XPmtRegTxt: label 'PMT REG', Comment='Payment Registration';
        CompanyBankAccountPostGroupTxt: label 'CHECKING', Comment='Checking';

    local procedure UpdateGeneralJournalBatch(BankAccount: Record "Bank Account";JournalTemplateName: Code[10];JournalBatchName: Code[10])
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        with GenJournalBatch do
          if Get(JournalTemplateName,JournalBatchName) then
            if ("Bal. Account Type" = "bal. account type"::"Bank Account") and ("Bal. Account No." = '') then begin
              Validate("Bal. Account No.",BankAccount."No.");
              Modify;
            end;
    end;


    procedure UpdateCompanyBankAccount(var CompanyInformation: Record "Company Information";BankAccountPostingGroup: Code[10];var BankAccount: Record "Bank Account")
    begin
        // create or update existing company bank account with the information entered by the user
        // update general journal payment batches to point to the company bank account (unless a bank account is already specified in them)
        with CompanyInformation do begin
          if (("Bank Branch No." = '') and ("Bank Account No." = '')) and (("SWIFT Code" = '') and (Iban = '')) then
            exit;
          UpdateBankAccount(BankAccount,CompanyInformation,BankAccountPostingGroup);
          UpdateGeneralJournalBatch(BankAccount,XPAYMENTTxt,XPmtRegTxt);
          UpdatePaymentRegistrationSetup(BankAccount,XPAYMENTTxt,XPmtRegTxt);
        end;
    end;

    local procedure UpdatePaymentRegistrationSetup(BankAccount: Record "Bank Account";JournalTemplateName: Code[10];JournalBatchName: Code[10])
    var
        PaymentRegistrationSetup: Record "Payment Registration Setup";
    begin
        if not PaymentRegistrationSetup.Get(UserId) then begin
          PaymentRegistrationSetup."User ID" := UserId;
          PaymentRegistrationSetup.Insert;
        end;
        PaymentRegistrationSetup."Journal Template Name" := JournalTemplateName;
        PaymentRegistrationSetup."Journal Batch Name" := JournalBatchName;
        PaymentRegistrationSetup."Bal. Account Type" := PaymentRegistrationSetup."bal. account type"::"Bank Account";
        PaymentRegistrationSetup."Bal. Account No." := BankAccount."No.";
        PaymentRegistrationSetup."Use this Account as Def." := true;
        PaymentRegistrationSetup."Auto Fill Date Received" := true;
        PaymentRegistrationSetup.Modify;
    end;

    local procedure UpdateBankAccount(var BankAccount: Record "Bank Account";CompanyInformation: Record "Company Information";BankAccountPostingGroup: Code[10])
    var
        BankAccPostingGroup: Record "Bank Account Posting Group";
    begin
        if BankAccount."No." = '' then
          BankAccount."No." := CompanyBankAccountTxt;

        with CompanyInformation do begin
          if not BankAccount.Get(BankAccount."No.") then begin
            BankAccount.Init;
            BankAccount."No." := CompanyBankAccountTxt;
            BankAccount.Insert;
          end;
          BankAccount.Validate(Name,"Bank Name");
          BankAccount.Validate("Bank Branch No.","Bank Branch No.");
          BankAccount.Validate("Bank Account No.","Bank Account No.");
          BankAccount.Validate("SWIFT Code","SWIFT Code");
          BankAccount.Validate(Iban,Iban);
          if (BankAccountPostingGroup = '') and (BankAccount."No." = CompanyBankAccountTxt) then
            BankAccountPostingGroup := CompanyBankAccountPostGroupTxt;
          if BankAccPostingGroup.Get(BankAccountPostingGroup) then
            BankAccount.Validate("Bank Acc. Posting Group",BankAccPostingGroup.Code);
          BankAccount.Modify;
        end;
    end;


    procedure GetCompanyBankAccount(): Code[20]
    begin
        exit(CompanyBankAccountTxt);
    end;


    procedure GetCompanyBankAccountPostingGroup(): Code[10]
    var
        BankAccount: Record "Bank Account";
    begin
        if BankAccount.Get(CompanyBankAccountTxt) then
          exit(BankAccount."Bank Acc. Posting Group");
        exit('');
    end;


    procedure IsDemoCompany(): Boolean
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get;
        exit(CompanyInformation."Demo Company");
    end;
}

