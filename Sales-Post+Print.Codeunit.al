#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 82 "Sales-Post + Print"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SalesHeader.Copy(Rec);
        Code;
        Rec := SalesHeader;
    end;

    var
        Text000: label '&Ship,&Invoice,Ship &and Invoice';
        Text001: label 'Do you want to post and print the %1?';
        PostAndEmailMsg: label 'Do you want to post and email the %1?';
        Text002: label '&Receive,&Invoice,Receive &and Invoice';
        SalesHeader: Record "Sales Header";
        Selection: Integer;
        SendReportAsEmail: Boolean;


    procedure PostAndEmail(var ParmSalesHeader: Record "Sales Header")
    begin
        SendReportAsEmail := true;
        SalesHeader.Copy(ParmSalesHeader);
        Code;
        ParmSalesHeader := SalesHeader;
    end;

    local procedure "Code"()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPostViaJobQueue: Codeunit "Sales Post via Job Queue";
    begin
        with SalesHeader do begin
          case "Document Type" of
            "document type"::Order:
              begin
                Selection := StrMenu(Text000,3);
                if Selection = 0 then
                  exit;
                Ship := Selection in [1,3];
                Invoice := Selection in [2,3];
              end;
            "document type"::"Return Order":
              begin
                Selection := StrMenu(Text002,3);
                if Selection = 0 then
                  exit;
                Receive := Selection in [1,3];
                Invoice := Selection in [2,3];
              end
            else
              if not Confirm(ConfirmationMessage,false,"Document Type") then
                exit;
          end;

          "Print Posted Documents" := true;

          SalesSetup.Get;
          if SalesSetup."Post & Print with Job Queue" and not SendReportAsEmail then
            SalesPostViaJobQueue.EnqueueSalesDoc(SalesHeader)
          else begin
            Codeunit.Run(Codeunit::"Sales-Post",SalesHeader);
            GetReport(SalesHeader);
          end;
          Commit;
        end;
    end;


    procedure GetReport(var SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do
          case "Document Type" of
            "document type"::Order:
              begin
                if Ship then
                  PrintShip(SalesHeader);
                if Invoice then
                  PrintInvoice(SalesHeader);
              end;
            "document type"::Invoice:
              PrintInvoice(SalesHeader);
            "document type"::"Return Order":
              begin
                if Receive then
                  PrintReceive(SalesHeader);
                if Invoice then
                  PrintCrMemo(SalesHeader);
              end;
            "document type"::"Credit Memo":
              PrintCrMemo(SalesHeader);
          end;
    end;

    local procedure ConfirmationMessage(): Text
    begin
        if SendReportAsEmail then
          exit(PostAndEmailMsg);
        exit(Text001);
    end;

    local procedure PrintReceive(SalesHeader: Record "Sales Header")
    var
        ReturnRcptHeader: Record "Return Receipt Header";
    begin
        ReturnRcptHeader."No." := SalesHeader."Last Return Receipt No.";
        if ReturnRcptHeader.Find then;
        ReturnRcptHeader.SetRecfilter;

        if SendReportAsEmail then
          ReturnRcptHeader.EmailRecords(true)
        else
          ReturnRcptHeader.PrintRecords(false);
    end;

    local procedure PrintInvoice(SalesHeader: Record "Sales Header")
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        if SalesHeader."Last Posting No." = '' then
          SalesInvHeader."No." := SalesHeader."No."
        else
          SalesInvHeader."No." := SalesHeader."Last Posting No.";
        SalesInvHeader.Find;
        SalesInvHeader.SetRecfilter;

        if SendReportAsEmail then
          SalesInvHeader.EmailRecords(true)
        else
          SalesInvHeader.PrintRecords(false);
    end;

    local procedure PrintShip(SalesHeader: Record "Sales Header")
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader."No." := SalesHeader."Last Shipping No.";
        if SalesShptHeader.Find then;
        SalesShptHeader.SetRecfilter;

        if SendReportAsEmail then
          SalesShptHeader.EmailRecords(true)
        else
          SalesShptHeader.PrintRecords(false);
    end;

    local procedure PrintCrMemo(SalesHeader: Record "Sales Header")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if SalesHeader."Last Posting No." = '' then
          SalesCrMemoHeader."No." := SalesHeader."No."
        else
          SalesCrMemoHeader."No." := SalesHeader."Last Posting No.";
        SalesCrMemoHeader.Find;
        SalesCrMemoHeader.SetRecfilter;

        if SendReportAsEmail then
          SalesCrMemoHeader.EmailRecords(true)
        else
          SalesCrMemoHeader.PrintRecords(false);
    end;
}

