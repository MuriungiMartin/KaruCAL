#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1223 "SEPA CT-Check Line"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        DeletePaymentFileErrors;
        CheckGenJnlLine(Rec);
        CheckBank(Rec);
        CheckCustVend(Rec);
    end;

    var
        MustBeBankAccErr: label 'The balancing account must be a bank account.';
        MustBeVendorOrCustomerErr: label 'The account must be a vendor or customer account.';
        MustBeVendPmtOrCustRefundErr: label 'Only vendor payments and customer refunds are allowed.';
        MustBePositiveErr: label 'The amount must be positive.';
        TransferDateErr: label 'The earliest possible transfer date is today.';
        EuroCurrErr: label 'Only transactions in euro (EUR) are allowed, because the %1 bank account is set up to use the %2 export format.', Comment='%1= bank account No, %2 export format; Example: Only transactions in euro (EUR) are allowed, because the GIRO bank account is set up to use the SEPACT export format.';
        FieldBlankErr: label 'The %1 field must be filled.', Comment='%1= field name. Example: The Name field must be filled.';
        FieldKeyBlankErr: label '%1 %2 must have a value in %3.', Comment='%1=table name, %2=key field value, %3=field name. Example: Customer 10000 must have a value in Name.';

    local procedure CheckGenJnlLine(var GenJnlLine: Record "Gen. Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
        BankAccount: Record "Bank Account";
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        GLSetup.Get;
        if GenJournalBatch.Get(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name") then
          GenJournalBatch.OnCheckGenJournalLineExportRestrictions;
        with GenJnlLine do begin
          if "Bal. Account Type" <> "bal. account type"::"Bank Account" then
            InsertPaymentFileError(MustBeBankAccErr);

          if "Bal. Account No." = '' then
            AddFieldEmptyError(GenJnlLine,TableCaption,FieldCaption("Bal. Account No."),'');

          if "Recipient Bank Account" = '' then
            AddFieldEmptyError(GenJnlLine,TableCaption,FieldCaption("Recipient Bank Account"),'');

          if not ("Account Type" in ["account type"::Vendor,"account type"::Customer]) then
            InsertPaymentFileError(MustBeVendorOrCustomerErr);

          if (("Account Type" = "account type"::Vendor) and ("Document Type" <> "document type"::Payment)) or
             (("Account Type" = "account type"::Customer) and ("Document Type" <> "document type"::Refund))
          then
            InsertPaymentFileError(StrSubstNo(MustBeVendPmtOrCustRefundErr));

          if Amount <= 0 then
            InsertPaymentFileError(MustBePositiveErr);

          if "Currency Code" <> GLSetup.GetCurrencyCode('EUR') then begin
            BankAccount.Get("Bal. Account No.");
            InsertPaymentFileError(StrSubstNo(EuroCurrErr,"Bal. Account No.",BankAccount."Payment Export Format"));
          end;

          if "Posting Date" < Today then
            InsertPaymentFileError(TransferDateErr);
        end;
    end;

    local procedure CheckBank(var GenJnlLine: Record "Gen. Journal Line")
    var
        BankAccount: Record "Bank Account";
    begin
        with GenJnlLine do
          if BankAccount.Get("Bal. Account No.") then begin
            if BankAccount.Iban = '' then
              AddFieldEmptyError(GenJnlLine,BankAccount.TableCaption,BankAccount.FieldCaption(Iban),"Bal. Account No.");
          end;
    end;

    local procedure CheckCustVend(var GenJnlLine: Record "Gen. Journal Line")
    var
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        with GenJnlLine do begin
          if "Account No." = '' then begin
            InsertPaymentFileError(MustBeVendorOrCustomerErr);
            exit;
          end;
          case "Account Type" of
            "account type"::Customer:
              begin
                Customer.Get("Account No.");
                if Customer.Name = '' then
                  AddFieldEmptyError(GenJnlLine,Customer.TableCaption,Customer.FieldCaption(Name),"Account No.");
                if "Recipient Bank Account" <> '' then begin
                  CustomerBankAccount.Get(Customer."No.","Recipient Bank Account");
                  if CustomerBankAccount.Iban = '' then
                    AddFieldEmptyError(
                      GenJnlLine,CustomerBankAccount.TableCaption,CustomerBankAccount.FieldCaption(Iban),"Recipient Bank Account");
                end;
              end;
            "account type"::Vendor:
              begin
                Vendor.Get("Account No.");
                if Vendor.Name = '' then
                  AddFieldEmptyError(GenJnlLine,Vendor.TableCaption,Vendor.FieldCaption(Name),"Account No.");
                if "Recipient Bank Account" <> '' then begin
                  VendorBankAccount.Get(Vendor."No.","Recipient Bank Account");
                  if VendorBankAccount.Iban = '' then
                    AddFieldEmptyError(
                      GenJnlLine,VendorBankAccount.TableCaption,VendorBankAccount.FieldCaption(Iban),"Recipient Bank Account");
                end;
              end;
          end;
        end;
    end;

    local procedure AddFieldEmptyError(var GenJnlLine: Record "Gen. Journal Line";TableCaption: Text;FieldCaption: Text;KeyValue: Text)
    var
        ErrorText: Text;
    begin
        if KeyValue = '' then
          ErrorText := StrSubstNo(FieldBlankErr,FieldCaption)
        else
          ErrorText := StrSubstNo(FieldKeyBlankErr,TableCaption,KeyValue,FieldCaption);
        GenJnlLine.InsertPaymentFileError(ErrorText);
    end;
}

