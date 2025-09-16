#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1274 "Exp. Mapping Gen. Jnl."
{
    Permissions = TableData "Data Exch."=rimd;
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        PaymentExportData: Record "Payment Export Data";
        DataExch: Record "Data Exch.";
        PaymentExportMgt: Codeunit "Payment Export Mgt";
        Window: Dialog;
        PaymentExportDataRecRef: RecordRef;
        LineNo: Integer;
    begin
        PaymentExportData.SetRange("Data Exch Entry No.","Entry No.");
        PaymentExportData.FindSet;

        Window.Open(ProgressMsg);

        repeat
          LineNo += 1;
          Window.Update(1,LineNo);

          DataExch.Get(PaymentExportData."Data Exch Entry No.");
          DataExch.Validate("Data Exch. Line Def Code",PaymentExportData."Data Exch. Line Def Code");
          DataExch.Modify(true);

          PaymentExportDataRecRef.GetTable(PaymentExportData);
          PaymentExportMgt.ProcessColumnMapping(DataExch,PaymentExportDataRecRef,
            PaymentExportData."Line No.",PaymentExportData."Data Exch. Line Def Code",PaymentExportDataRecRef.Number);
        until PaymentExportData.Next = 0;

        Window.Close;
    end;

    var
        ProgressMsg: label 'Processing line no. #1######.';
}

