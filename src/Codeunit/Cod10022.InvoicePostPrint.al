#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10022 "Invoice-Post + Print"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SalesHeader.Copy(Rec);
        Code;
        Rec := SalesHeader;
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        ReportSelection: Record "Report Selections";
        SalesPost: Codeunit "Sales-Post";
        Text1020001: label 'Do you want to invoice and print the %1?';

    local procedure "Code"()
    begin
        with SalesHeader do
          if "Document Type" = "document type"::Order then begin
            if not Confirm(Text1020001,false,"Document Type") then
              exit;
            Ship := false;
            Invoice := true;
            SalesPost.Run(SalesHeader);

            SalesInvHeader."No." := "Last Posting No.";
            SalesInvHeader.SetRecfilter;
            PrintReport(ReportSelection.Usage::"S.Invoice");
          end;
    end;

    local procedure PrintReport(ReportUsage: Integer)
    begin
        ReportSelection.Reset;
        ReportSelection.SetRange(Usage,ReportUsage);
        ReportSelection.Find('-');
        repeat
          ReportSelection.TestField("Report ID");
          case ReportUsage of
            ReportSelection.Usage::"S.Invoice":
              Report.Run(ReportSelection."Report ID",false,false,SalesInvHeader);
            ReportSelection.Usage::"S.Cr.Memo":
              Report.Run(ReportSelection."Report ID",false,false,SalesCrMemoHeader);
            ReportSelection.Usage::"S.Shipment":
              Report.Run(ReportSelection."Report ID",false,false,SalesShptHeader);
            ReportSelection.Usage::"S.Ret.Rcpt.":
              Report.Run(ReportSelection."Report ID",false,false,ReturnRcptHeader);
          end;
        until ReportSelection.Next = 0;
    end;
}

