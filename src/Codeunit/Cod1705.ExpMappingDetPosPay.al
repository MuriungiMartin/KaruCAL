#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1705 "Exp. Mapping Det Pos. Pay"
{
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        PositivePayDetail: Record "Positive Pay Detail";
        DataExch: Record "Data Exch.";
        PositivePayExportMgt: Codeunit "Positive Pay Export Mgt";
        RecordRef: RecordRef;
        Window: Dialog;
        LineNo: Integer;
    begin
        if NoDataExchLineDef("Data Exch. Def Code") then
          exit;

        Window.Open(ProgressMsg);

        // Range through the line types, Look at details...
        LineNo := 1;

        PositivePayDetail.SetRange("Data Exch. Entry No.","Entry No.");
        if PositivePayDetail.FindSet then
          repeat
            Window.Update(1,LineNo);
            if HandlePositivePayDetails(PositivePayDetail) then begin
              DataExch.SetRange("Entry No.","Entry No.");
              if DataExch.FindFirst then begin
                RecordRef.GetTable(PositivePayDetail);
                PositivePayExportMgt.InsertDataExchLineForFlatFile(
                  DataExch,
                  LineNo,
                  RecordRef);
                LineNo := LineNo + 1;
              end;
            end;
          until  PositivePayDetail.Next = 0;
        Window.Close;
    end;

    var
        ProgressMsg: label 'Processing line no. #1######.';

    local procedure HandlePositivePayDetails(PositivePayDetail: Record "Positive Pay Detail"): Boolean
    var
        CheckLedgEntry: Record "Check Ledger Entry";
    begin
        if PositivePayDetail.Payee = '' then begin
          CheckLedgEntry.SetRange("Positive Pay Exported",false);
          CheckLedgEntry.SetRange("Data Exch. Voided Entry No.",PositivePayDetail."Data Exch. Entry No.");
          CheckLedgEntry.SetRange("Check No.",PositivePayDetail."Check Number");
          if CheckLedgEntry.FindLast then
            exit(CheckLedgEntry."Entry Status" <> CheckLedgEntry."entry status"::"Test Print");
        end;

        exit(true);
    end;

    local procedure NoDataExchLineDef(DataExchDefCode: Code[20]): Boolean
    var
        DataExchLineDef: Record "Data Exch. Line Def";
    begin
        with DataExchLineDef do begin
          Init;
          SetRange("Data Exch. Def Code",DataExchDefCode);
          SetRange("Line Type","line type"::Detail);
          exit(IsEmpty);
        end;
    end;
}

