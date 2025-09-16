#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5762 "Whse.-Post Receipt + Print"
{
    TableNo = "Warehouse Receipt Line";

    trigger OnRun()
    begin
        WhseReceiptLine.Copy(Rec);
        Code;
    end;

    var
        Text001: label 'Number of put-away activities printed: %1.';
        WhseActivHeader: Record "Warehouse Activity Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        PrintedDocuments: Integer;

    local procedure "Code"()
    var
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
    begin
        with WhseReceiptLine do begin
          WhsePostReceipt.Run(WhseReceiptLine);
          WhsePostReceipt.GetResultMessage;

          PrintedDocuments := 0;
          if WhsePostReceipt.GetFirstPutAwayDocument(WhseActivHeader) then begin
            repeat
              WhseActivHeader.SetRecfilter;
              Report.Run(Report::"Put-away List",false,false,WhseActivHeader);
              PrintedDocuments := PrintedDocuments + 1;
            until not WhsePostReceipt.GetNextPutAwayDocument(WhseActivHeader);
            Message(Text001,PrintedDocuments);
          end;
          Clear(WhsePostReceipt);
        end;
    end;
}

