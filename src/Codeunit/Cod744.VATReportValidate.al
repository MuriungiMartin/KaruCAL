#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 744 "VAT Report Validate"
{
    TableNo = "VAT Report Header";

    trigger OnRun()
    begin
        ClearErrorLog;

        ValidateVATReportLinesExists(Rec);
        ValidateVATReportHeader;
        ValidateVATReportLines;

        ShowErrorLog;
    end;

    var
        Text000: label 'You cannot release the Tax report because no lines exist.';
        TempVATReportErrorLog: Record "VAT Report Error Log" temporary;
        VATReportLine: Record "VAT Report Line";
        ErrorID: Integer;

    local procedure ClearErrorLog()
    begin
        TempVATReportErrorLog.Reset;
        TempVATReportErrorLog.DeleteAll;
    end;

    local procedure InsertErrorLog(ErrorMessage: Text[250])
    begin
        if TempVATReportErrorLog.FindLast then
          ErrorID := TempVATReportErrorLog."Entry No." + 1
        else
          ErrorID := 1;

        TempVATReportErrorLog.Init;
        TempVATReportErrorLog."Entry No." := ErrorID;
        TempVATReportErrorLog."Error Message" := ErrorMessage;
        TempVATReportErrorLog.Insert;
    end;

    local procedure ShowErrorLog()
    begin
        if not TempVATReportErrorLog.IsEmpty then begin
          Page.Run(Page::"VAT Report Error Log",TempVATReportErrorLog);
          Error('');
        end;
    end;

    local procedure ValidateVATReportLinesExists(VATReportHeader: Record "VAT Report Header")
    begin
        VATReportLine.SetRange("VAT Report No.",VATReportHeader."No.");
        if VATReportLine.IsEmpty then begin
          InsertErrorLog(Text000);
          ShowErrorLog;
        end;
    end;

    local procedure ValidateVATReportHeader()
    begin
    end;

    local procedure ValidateVATReportLines()
    begin
    end;
}

