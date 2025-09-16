#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10121 "Bank Rec.-Post (Yes/No)"
{
    TableNo = UnknownTable10120;

    trigger OnRun()
    begin
        BankRecHeader.Copy(Rec);
        Code;
        Rec := BankRecHeader;
    end;

    var
        Text001: label 'Do you want to post bank rec. statement %1 for bank account %2?';
        BankRecHeader: Record UnknownRecord10120;
        BankRecPost: Codeunit "Bank Rec.-Post";
        PostedSuccessfullyMsg: label 'Statement successfully posted.';

    local procedure "Code"()
    begin
        if Confirm(Text001,false,
             BankRecHeader."Statement No.",
             BankRecHeader."Bank Account No.")
        then begin
          BankRecPost.Run(BankRecHeader);
          Commit;
          Message(PostedSuccessfullyMsg);
        end;
    end;
}

