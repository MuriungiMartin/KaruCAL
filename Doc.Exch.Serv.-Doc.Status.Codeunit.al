#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1420 "Doc. Exch. Serv.- Doc. Status"
{

    trigger OnRun()
    begin
        CheckPostedInvoices;
        CheckPostedCrMemos;
        CheckPostedServiceInvoices;
        CheckPostedServiceCrMemos;
    end;

    var
        DocExchLinks: Codeunit "Doc. Exch. Links";

    local procedure CheckPostedInvoices()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        with SalesInvoiceHeader do begin
          SetFilter("Document Exchange Status",StrSubstNo('%1|%2',
              "document exchange status"::"Sent to Document Exchange Service",
              "document exchange status"::"Pending Connection to Recipient"));
          if FindSet then
            repeat
              DocExchLinks.CheckAndUpdateDocExchInvoiceStatus(SalesInvoiceHeader);
              Commit;
            until Next = 0;
        end;
    end;

    local procedure CheckPostedCrMemos()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        with SalesCrMemoHeader do begin
          SetFilter("Document Exchange Status",StrSubstNo('%1|%2',
              "document exchange status"::"Sent to Document Exchange Service",
              "document exchange status"::"Pending Connection to Recipient"));
          if FindSet then
            repeat
              DocExchLinks.CheckAndUpdateDocExchCrMemoStatus(SalesCrMemoHeader);
              Commit;
            until Next = 0;
        end;
    end;

    local procedure CheckPostedServiceInvoices()
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
    begin
        with ServiceInvoiceHeader do begin
          SetFilter("Document Exchange Status",StrSubstNo('%1|%2',
              "document exchange status"::"Sent to Document Exchange Service",
              "document exchange status"::"Pending Connection to Recipient"));
          if FindSet then
            repeat
              DocExchLinks.CheckAndUpdateDocExchServiceInvoiceStatus(ServiceInvoiceHeader);
              Commit;
            until Next = 0;
        end;
    end;

    local procedure CheckPostedServiceCrMemos()
    var
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        with ServiceCrMemoHeader do begin
          SetFilter("Document Exchange Status",StrSubstNo('%1|%2',
              "document exchange status"::"Sent to Document Exchange Service",
              "document exchange status"::"Pending Connection to Recipient"));
          if FindSet then
            repeat
              DocExchLinks.CheckAndUpdateDocExchServiceCrMemoStatus(ServiceCrMemoHeader);
              Commit;
            until Next = 0;
        end;
    end;
}

