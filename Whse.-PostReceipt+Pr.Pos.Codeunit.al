#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5766 "Whse.-Post Receipt + Pr. Pos."
{
    TableNo = "Warehouse Receipt Line";

    trigger OnRun()
    begin
        WhseReceiptLine.Copy(Rec);
        Code;
    end;

    var
        PostedWhseRcptHeader: Record "Posted Whse. Receipt Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        Text001: label 'Number of posted whse. receipts printed: 1.';

    local procedure "Code"()
    var
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
    begin
        with WhseReceiptLine do begin
          WhsePostReceipt.Run(WhseReceiptLine);
          WhsePostReceipt.GetResultMessage;

          PostedWhseRcptHeader.SetRange("Whse. Receipt No.","No.");
          PostedWhseRcptHeader.SetRange("Location Code","Location Code");
          PostedWhseRcptHeader.FindLast;
          PostedWhseRcptHeader.SetRange("No.",PostedWhseRcptHeader."No.");
          Report.Run(Report::"Whse. - Posted Receipt",false,false,PostedWhseRcptHeader);
          Message(Text001);

          Clear(WhsePostReceipt);
        end;
    end;
}

