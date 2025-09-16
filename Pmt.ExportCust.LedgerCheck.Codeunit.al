#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1213 "Pmt. Export Cust. Ledger Check"
{
    TableNo = "Cust. Ledger Entry";

    trigger OnRun()
    begin
        CheckDocumentType(Rec);
        CheckRefundInfo(Rec);
        CheckPaymentMethod(Rec);
        CheckBalAccountType(Rec);
        CheckBankAccount(Rec);
        CheckBalAccountNo(Rec);
    end;

    var
        RecipientBankAccMissingErr: label '%1 for one or more %2 is not specified.', Comment='%1=Field;%2=Table';
        WrongFieldValueErr: label '%1 for one or more %2 is different from %3.', Comment='%1=Field;%2=Table;%3=Value';
        MissingPmtMethodErr: label '%1 must be used for payments.';

    local procedure CheckDocumentType(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        CustLedgEntry2: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry2.Copy(CustLedgEntry);
        CustLedgEntry2.SetFilter("Document Type",'<>%1',CustLedgEntry2."document type"::Refund);

        if not CustLedgEntry2.IsEmpty then
          Error(WrongFieldValueErr,
            CustLedgEntry2.FieldCaption("Document Type"),CustLedgEntry2.TableCaption,CustLedgEntry2."document type"::Refund);
    end;

    local procedure CheckRefundInfo(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        CustLedgEntry2: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry2.Copy(CustLedgEntry);
        CustLedgEntry2.SetRange("Recipient Bank Account",'');

        if not CustLedgEntry2.IsEmpty then
          Error(RecipientBankAccMissingErr,CustLedgEntry2.FieldCaption("Recipient Bank Account"),CustLedgEntry2.TableCaption);
    end;

    local procedure CheckPaymentMethod(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        CustLedgEntry2: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry2.Copy(CustLedgEntry);
        CustLedgEntry2.SetRange("Payment Method Code",'');

        if not CustLedgEntry2.IsEmpty then
          Error(MissingPmtMethodErr,CustLedgEntry2.FieldCaption("Payment Method Code"));
    end;

    local procedure CheckBalAccountType(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        CustLedgEntry2: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry2.Copy(CustLedgEntry);
        CustLedgEntry2.SetFilter("Bal. Account Type",'<>%1',CustLedgEntry2."bal. account type"::"Bank Account");

        if not CustLedgEntry2.IsEmpty then
          Error(WrongFieldValueErr,CustLedgEntry2.FieldCaption("Bal. Account Type"),
            CustLedgEntry2.TableCaption,CustLedgEntry2."bal. account type"::"Bank Account");
    end;

    local procedure CheckBalAccountNo(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        CustLedgEntry2: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry2.Copy(CustLedgEntry);
        CustLedgEntry2.SetRange("Bal. Account Type",CustLedgEntry2."bal. account type"::"Bank Account");
        CustLedgEntry2.SetFilter("Bal. Account No.",'<>%1',CustLedgEntry."Bal. Account No.");

        if not CustLedgEntry2.IsEmpty then
          Error(WrongFieldValueErr,CustLedgEntry2.FieldCaption("Bal. Account No."),
            CustLedgEntry2.TableCaption,CustLedgEntry."Bal. Account No.");
    end;

    local procedure CheckBankAccount(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.Get(CustLedgEntry."Bal. Account No.");
        BankAccount.TestField("Payment Export Format");
    end;
}

