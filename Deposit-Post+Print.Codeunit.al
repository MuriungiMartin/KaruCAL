#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10142 "Deposit-Post + Print"
{
    TableNo = UnknownTable10140;

    trigger OnRun()
    begin
        DepositHeader.Copy(Rec);

        if not Confirm(Text000,false) then
          exit;

        DepositPost.Run(DepositHeader);
        Rec := DepositHeader;
        Commit;

        if PostedDepositHeader.Get("No.") then begin
          PostedDepositHeader.SetRecfilter;
          Report.Run(Report::Deposit,false,false,PostedDepositHeader);
        end;
    end;

    var
        DepositHeader: Record UnknownRecord10140;
        PostedDepositHeader: Record UnknownRecord10143;
        DepositPost: Codeunit "Deposit-Post";
        Text000: label 'Do you want to post and print the Deposit?';
}

