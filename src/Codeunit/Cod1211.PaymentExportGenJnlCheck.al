#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1211 "Payment Export Gen. Jnl Check"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        DeletePaymentFileErrors;
        GenJnlBatch.Get("Journal Template Name","Journal Batch Name");

        if not TempGenJournalBatch.Get("Journal Template Name","Journal Batch Name") then
          CheckGenJournalBatch(Rec,GenJnlBatch);

        if not ("Account Type" in ["account type"::Customer,"account type"::Vendor]) then
          InsertPaymentFileError(MustBeVendorOrCustomerErr);

        if (("Account Type" = "account type"::Vendor) and ("Document Type" <> "document type"::Payment)) or
           (("Account Type" = "account type"::Customer) and ("Document Type" <> "document type"::Refund))
        then
          InsertPaymentFileError(MustBeVendPmtOrCustRefundErr);

        if "Payment Method Code" = '' then
          AddFieldEmptyError(Rec,TableCaption,FieldCaption("Payment Method Code"),'');

        if ("Recipient Bank Account" <> '') and ("Creditor No." <> '') then
          InsertPaymentFileError(StrSubstNo(SimultaneousPaymentDetailsErr,
              FieldCaption("Recipient Bank Account"),FieldCaption("Creditor No.")));

        if ("Recipient Bank Account" = '') and ("Creditor No." = '') then
          InsertPaymentFileError(StrSubstNo(EmptyPaymentDetailsErr,
              FieldCaption("Recipient Bank Account"),FieldCaption("Creditor No.")));

        if "Bal. Account Type" <> "bal. account type"::"Bank Account" then
          InsertPaymentFileError(StrSubstNo(WrongBalAccountErr,FieldCaption("Bal. Account Type"),
              TableCaption,"bal. account type"::"Bank Account",GenJnlBatch.TableCaption,GenJnlBatch.Name));

        if "Bal. Account No." <> GenJnlBatch."Bal. Account No." then
          InsertPaymentFileError(StrSubstNo(WrongBalAccountErr,FieldCaption("Bal. Account No."),
              TableCaption,GenJnlBatch."Bal. Account No.",GenJnlBatch.TableCaption,GenJnlBatch.Name));

        if Amount <= 0 then
          InsertPaymentFileError(MustBePositiveErr);
    end;

    var
        EmptyPaymentDetailsErr: label '%1 or %2 must be used for payments.', Comment='%1=Field;%2=Field';
        SimultaneousPaymentDetailsErr: label '%1 and %2 cannot be used simultaneously for payments.', Comment='%1=Field;%2=Field';
        WrongBalAccountErr: label '%1 for the %2 is different from %3 on %4: %5.', Comment='%1=Field;%1=Table;%3=Value;%4=Table;%5=Value';
        MustBeVendorOrCustomerErr: label 'The account must be a vendor or customer account.';
        MustBeVendPmtOrCustRefundErr: label 'Only vendor payments and customer refunds are allowed.';
        MustBePositiveErr: label 'The amount must be positive.';
        FieldBlankErr: label '%1 must have a value in %2.', Comment='%1=table name, %2=field name. Example: Customer must have a value in Name.';
        FieldKeyBlankErr: label '%1 %2 must have a value in %3.', Comment='%1=table name, %2=key field value, %3=field name. Example: Customer 10000 must have a value in Name.';
        TempGenJournalBatch: Record "Gen. Journal Batch" temporary;

    local procedure AddFieldEmptyError(var GenJnlLine: Record "Gen. Journal Line";TableCaption: Text;FieldCaption: Text;KeyValue: Text)
    var
        ErrorText: Text;
    begin
        if KeyValue = '' then
          ErrorText := StrSubstNo(FieldBlankErr,TableCaption,FieldCaption)
        else
          ErrorText := StrSubstNo(FieldKeyBlankErr,TableCaption,KeyValue,FieldCaption);
        GenJnlLine.InsertPaymentFileError(ErrorText);
    end;

    local procedure AddBatchEmptyError(var GenJnlLine: Record "Gen. Journal Line";FieldCaption: Text;KeyValue: Variant)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        AddFieldEmptyError(GenJnlLine,GenJnlBatch.TableCaption,FieldCaption,Format(KeyValue));
    end;

    local procedure CheckGenJournalBatch(GenJournalLine: Record "Gen. Journal Line";GenJournalBatch: Record "Gen. Journal Batch")
    var
        BankAccount: Record "Bank Account";
    begin
        TempGenJournalBatch := GenJournalBatch;
        TempGenJournalBatch.Insert;

        GenJournalBatch.OnCheckGenJournalLineExportRestrictions;

        if not GenJournalBatch."Allow Payment Export" then
          AddBatchEmptyError(GenJournalLine,GenJournalBatch.FieldCaption("Allow Payment Export"),'');

        if GenJournalBatch."Bal. Account Type" <> GenJournalBatch."bal. account type"::"Bank Account" then
          AddBatchEmptyError(GenJournalLine,GenJournalBatch.FieldCaption("Bal. Account Type"),GenJournalBatch."Bal. Account Type");

        if GenJournalBatch."Bal. Account No." = '' then
          AddBatchEmptyError(GenJournalLine,GenJournalBatch.FieldCaption("Bal. Account No."),GenJournalBatch."Bal. Account No.");

        if BankAccount.Get(GenJournalBatch."Bal. Account No.") then
          if BankAccount."Payment Export Format" = '' then
            GenJournalLine.InsertPaymentFileError(
              StrSubstNo(FieldBlankErr,BankAccount.FieldCaption("Payment Export Format"),BankAccount.TableCaption));
    end;
}

