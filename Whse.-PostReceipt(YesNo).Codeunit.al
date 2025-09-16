#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5761 "Whse.-Post Receipt (Yes/No)"
{
    TableNo = "Warehouse Receipt Line";

    trigger OnRun()
    begin
        WhseReceiptLine.Copy(Rec);
        Code;
    end;

    var
        Text000: label 'Do you want to post the receipt?';
        WhseReceiptLine: Record "Warehouse Receipt Line";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";

    local procedure "Code"()
    begin
        with WhseReceiptLine do begin
          if Find then
            if not Confirm(Text000,false) then
              exit;
          WhsePostReceipt.Run(WhseReceiptLine);
          WhsePostReceipt.GetResultMessage;
          Clear(WhsePostReceipt);
        end;
    end;
}

