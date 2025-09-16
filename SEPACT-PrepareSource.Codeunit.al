#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1222 "SEPA CT-Prepare Source"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.CopyFilters(Rec);
        CopyJnlLines(GenJnlLine,Rec);
    end;

    local procedure CopyJnlLines(var FromGenJnlLine: Record "Gen. Journal Line";var TempGenJnlLine: Record "Gen. Journal Line" temporary)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if FromGenJnlLine.FindSet then begin
          GenJnlBatch.Get(FromGenJnlLine."Journal Template Name",FromGenJnlLine."Journal Batch Name");

          repeat
            TempGenJnlLine := FromGenJnlLine;
            TempGenJnlLine.Insert;
          until FromGenJnlLine.Next = 0
        end else
          CreateTempJnlLines(FromGenJnlLine,TempGenJnlLine);
    end;

    local procedure CreateTempJnlLines(var FromGenJnlLine: Record "Gen. Journal Line";var TempGenJnlLine: Record "Gen. Journal Line" temporary)
    begin
        // To fill TempGenJnlLine from the source identified by filters set on FromGenJnlLine
        TempGenJnlLine := FromGenJnlLine;
    end;
}

