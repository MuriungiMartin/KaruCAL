#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1296 "BankPaymentApplLines-Delete"
{
    Permissions = TableData "Posted Payment Recon. Line"=d;
    TableNo = "Posted Payment Recon. Hdr";

    trigger OnRun()
    begin
        PostedPaymentReconLine.SetRange("Bank Account No.","Bank Account No.");
        PostedPaymentReconLine.SetRange("Statement No.","Statement No.");
        PostedPaymentReconLine.DeleteAll;
    end;

    var
        PostedPaymentReconLine: Record "Posted Payment Recon. Line";
}

