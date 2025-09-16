#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 740 "VAT Report Mediator"
{

    trigger OnRun()
    begin
    end;

    var
        VATReportReleaseReopen: Codeunit "VAT Report Release/Reopen";
        Text001: label 'This action will also mark the report as released. Are you sure you want to continue?';


    procedure GetLines(VATReportHeader: Record "VAT Report Header")
    begin
        VATReportHeader.TestField(Status,VATReportHeader.Status::Open);
        if (VATReportHeader."VAT Report Type" = VATReportHeader."vat report type"::Corrective) or
           (VATReportHeader."VAT Report Type" = VATReportHeader."vat report type"::Supplementary)
        then
          VATReportHeader.TestField("Original Report No.");

        VATReportHeader.TestField("VAT Report Config. Code",VATReportHeader."vat report config. code"::Option1);

        VATReportHeader.SetRange("No.",VATReportHeader."No.");
        Report.RunModal(Report::"VAT Report Suggest Lines",false,false,VATReportHeader);
    end;


    procedure Export(VATReportHeader: Record "VAT Report Header")
    var
        VATReportExport: Codeunit "VAT Report Export";
    begin
        VATReportExport.Export(VATReportHeader);
    end;


    procedure Release(VATReportHeader: Record "VAT Report Header")
    begin
        VATReportReleaseReopen.Release(VATReportHeader);
    end;


    procedure Reopen(VATReportHeader: Record "VAT Report Header")
    begin
        VATReportReleaseReopen.Reopen(VATReportHeader);
    end;


    procedure Print(VATReportHeader: Record "VAT Report Header")
    begin
        case VATReportHeader.Status of
          VATReportHeader.Status::Open:
            PrintOpen(VATReportHeader);
          VATReportHeader.Status::Released:
            PrintReleased(VATReportHeader);
          VATReportHeader.Status::Submitted:
            PrintReleased(VATReportHeader);
        end;
    end;

    local procedure PrintOpen(var VATReportHeader: Record "VAT Report Header")
    var
        VATReportReleaseReopen: Codeunit "VAT Report Release/Reopen";
    begin
        VATReportHeader.TestField(Status,VATReportHeader.Status::Open);
        if Confirm(Text001,true) then begin
          VATReportReleaseReopen.Release(VATReportHeader);
          PrintReleased(VATReportHeader);
        end
    end;

    local procedure PrintReleased(var VATReportHeader: Record "VAT Report Header")
    begin
        VATReportHeader.SetRange("No.",VATReportHeader."No.");
        Report.RunModal(Report::"VAT Report Print",false,false,VATReportHeader);
    end;


    procedure Submit(VATReportHeader: Record "VAT Report Header")
    begin
        VATReportReleaseReopen.Submit(VATReportHeader);
    end;
}

