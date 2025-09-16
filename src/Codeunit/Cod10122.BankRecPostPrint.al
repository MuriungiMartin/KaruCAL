#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10122 "Bank Rec.-Post + Print"
{
    TableNo = UnknownTable10120;

    trigger OnRun()
    begin
        BankRecHeader.Copy(Rec);

        if not Confirm(Text000,false) then
          exit;

        BankRecPost.Run(BankRecHeader);
        Rec := BankRecHeader;
        Commit;

        if PostedBankRecHeader.Get("Bank Account No.","Statement No.") then
          DocPrint.PrintBankRecStmt(PostedBankRecHeader);
    end;

    var
        BankRecHeader: Record UnknownRecord10120;
        PostedBankRecHeader: Record UnknownRecord10123;
        BankRecPost: Codeunit "Bank Rec.-Post";
        Text000: label 'Do you want to post and print the Bank Reconcilation?';
        DocPrint: Codeunit "Document-Print";
}

