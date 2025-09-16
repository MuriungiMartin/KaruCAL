#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 741 "VAT Report Release/Reopen"
{

    trigger OnRun()
    begin
    end;


    procedure Release(var VATReportHeader: Record "VAT Report Header")
    begin
        VATReportHeader.CheckIfCanBeReleased(VATReportHeader);
        Codeunit.Run(Codeunit::"VAT Report Validate",VATReportHeader);

        VATReportHeader.Status := VATReportHeader.Status::Released;
        VATReportHeader.Modify;
    end;


    procedure Reopen(var VATReportHeader: Record "VAT Report Header")
    begin
        VATReportHeader.CheckIfCanBeReopened(VATReportHeader);

        VATReportHeader.Status := VATReportHeader.Status::Open;
        VATReportHeader.Modify;
    end;


    procedure Submit(var VATReportHeader: Record "VAT Report Header")
    begin
        VATReportHeader.CheckIfCanBeSubmitted;

        VATReportHeader.Status := VATReportHeader.Status::Submitted;
        VATReportHeader.Modify;
    end;
}

