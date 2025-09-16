#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10141 "Deposit-Post (Yes/No)"
{
    TableNo = UnknownTable10140;

    trigger OnRun()
    begin
        DepositHeader.Copy(Rec);
        if not DepositHeader."Direct Sale" then begin
        if not Confirm(Text000,false) then
          exit;
        end;

        DepositPost.Run(DepositHeader);
        Rec := DepositHeader;
    end;

    var
        DepositHeader: Record UnknownRecord10140;
        DepositPost: Codeunit "Deposit-Post";
        Text000: label 'Do you want to post the Deposit?';
}

