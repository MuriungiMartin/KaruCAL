#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1212 "Pmt. Export Vend. Ledger Check"
{
    TableNo = "Vendor Ledger Entry";

    trigger OnRun()
    begin
        CheckDocumentType(Rec);
        CheckPaymentMethod(Rec);
        CheckSimultaneousPmtInfoCreditorNo(Rec);
        CheckEmptyPmtInfo(Rec);
        CheckBalAccountType(Rec);
        CheckBankAccount(Rec);
        CheckBalAccountNo(Rec);
    end;

    var
        EmptyPaymentDetailsErr: label '%1 or %2 must be used for payments.', Comment='%1=Field;%2=Field';
        SimultaneousPaymentDetailsErr: label '%1 and %2 cannot be used simultaneously for payments.', Comment='%1=Field;%2=Field';
        WrongFieldValueErr: label '%1 for one or more %2 is different from %3.', Comment='%1=Field;%2=Table;%3=Value';
        MissingPmtMethodErr: label '%1 must be used for payments.';

    local procedure CheckDocumentType(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        VendLedgEntry2: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry2.Copy(VendLedgEntry);
        VendLedgEntry2.SetFilter("Document Type",'<>%1',VendLedgEntry2."document type"::Payment);

        if not VendLedgEntry2.IsEmpty then
          Error(WrongFieldValueErr,
            VendLedgEntry2.FieldCaption("Document Type"),VendLedgEntry2.TableCaption,VendLedgEntry2."document type"::Payment);
    end;

    local procedure CheckPaymentMethod(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        VendLedgEntry2: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry2.Copy(VendLedgEntry);
        VendLedgEntry2.SetRange("Payment Method Code",'');

        if not VendLedgEntry2.IsEmpty then
          Error(MissingPmtMethodErr,VendLedgEntry2.FieldCaption("Payment Method Code"));
    end;

    local procedure CheckSimultaneousPmtInfoCreditorNo(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        VendLedgEntry2: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry2.Copy(VendLedgEntry);
        VendLedgEntry2.SetFilter("Recipient Bank Account",'<>%1','');
        VendLedgEntry2.SetFilter("Creditor No.",'<>%1','');

        if not VendLedgEntry2.IsEmpty then
          Error(SimultaneousPaymentDetailsErr,
            VendLedgEntry2.FieldCaption("Recipient Bank Account"),VendLedgEntry2.FieldCaption("Creditor No."));
    end;

    local procedure CheckEmptyPmtInfo(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        VendLedgEntry2: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry2.Copy(VendLedgEntry);
        VendLedgEntry2.SetRange("Recipient Bank Account",'');
        VendLedgEntry2.SetRange("Creditor No.",'');

        if not VendLedgEntry2.IsEmpty then
          Error(EmptyPaymentDetailsErr,
            VendLedgEntry2.FieldCaption("Recipient Bank Account"),VendLedgEntry2.FieldCaption("Creditor No."));
    end;

    local procedure CheckBalAccountType(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        VendLedgEntry2: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry2.Copy(VendLedgEntry);
        VendLedgEntry2.SetFilter("Bal. Account Type",'<>%1',VendLedgEntry2."bal. account type"::"Bank Account");

        if not VendLedgEntry2.IsEmpty then
          Error(WrongFieldValueErr,VendLedgEntry2.FieldCaption("Bal. Account Type"),
            VendLedgEntry2.TableCaption,VendLedgEntry2."bal. account type"::"Bank Account");
    end;

    local procedure CheckBalAccountNo(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        VendLedgEntry2: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry2.Copy(VendLedgEntry);
        VendLedgEntry2.SetRange("Bal. Account Type",VendLedgEntry2."bal. account type"::"Bank Account");
        VendLedgEntry2.SetFilter("Bal. Account No.",'<>%1',VendLedgEntry."Bal. Account No.");

        if not VendLedgEntry2.IsEmpty then
          Error(WrongFieldValueErr,VendLedgEntry2.FieldCaption("Bal. Account No."),
            VendLedgEntry2.TableCaption,VendLedgEntry."Bal. Account No.");
    end;

    local procedure CheckBankAccount(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.Get(VendLedgEntry."Bal. Account No.");
        BankAccount.TestField("Payment Export Format");
    end;
}

