#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1707 "Exp. Mapping Foot Pos. Pay"
{
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        PositivePayFooter: Record "Positive Pay Footer";
        DataExch: Record "Data Exch.";
        DataExchLineDef: Record "Data Exch. Line Def";
        PositivePayExportMgt: Codeunit "Positive Pay Export Mgt";
        RecordRef: RecordRef;
        Window: Dialog;
        LineNo: Integer;
    begin
        Window.Open(ProgressMsg);

        // Range through the Footer record
        LineNo := 1;
        DataExchLineDef.Init;
        DataExchLineDef.SetRange("Data Exch. Def Code","Data Exch. Def Code");
        DataExchLineDef.SetRange("Line Type",DataExchLineDef."line type"::Footer);
        if DataExchLineDef.FindFirst then begin
          DataExch.SetRange("Entry No.","Entry No.");
          if DataExch.FindFirst then begin
            PositivePayFooter.Init;
            PositivePayFooter.SetRange("Data Exch. Entry No.","Entry No.");
            if PositivePayFooter.FindFirst then begin
              Window.Update(1,LineNo);
              RecordRef.GetTable(PositivePayFooter);
              PositivePayExportMgt.InsertDataExchLineForFlatFile(
                DataExch,
                LineNo,
                RecordRef);
            end;
          end;
        end;
        Window.Close;
    end;

    var
        ProgressMsg: label 'Processing line no. #1######.';
}

