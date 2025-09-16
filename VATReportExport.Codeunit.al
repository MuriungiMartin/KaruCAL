#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 743 "VAT Report Export"
{

    trigger OnRun()
    begin
    end;

    var
        VATReportReleaseReopen: Codeunit "VAT Report Release/Reopen";
        Text001: label 'This action will also mark the report as released. Are you sure you want to continue?';


    procedure Export(VATReportHeader: Record "VAT Report Header")
    begin
        case VATReportHeader.Status of
          VATReportHeader.Status::Open:
            ExportOpen(VATReportHeader);
          VATReportHeader.Status::Released:
            ExportReleased;
          VATReportHeader.Status::Submitted:
            ExportReleased;
        end;
    end;

    local procedure ExportOpen(var VATReportHeader: Record "VAT Report Header")
    begin
        VATReportHeader.TestField(Status,VATReportHeader.Status::Open);

        if Confirm(Text001,true) then begin
          VATReportReleaseReopen.Release(VATReportHeader);
          ExportReleased;
        end;
    end;

    local procedure ExportReleased()
    begin
        ExportReport;
    end;

    local procedure ExportReport()
    begin
    end;
}

