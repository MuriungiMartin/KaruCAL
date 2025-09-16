#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 443 "Sales-Post Prepayment (Yes/No)"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Do you want to post the prepayments for %1 %2?';
        Text001: label 'Do you want to post a credit memo for the prepayments for %1 %2?';
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";


    procedure PostPrepmtInvoiceYN(var SalesHeader2: Record "Sales Header";Print: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesPostPrepayments: Codeunit "Sales-Post Prepayments";
    begin
        SalesHeader.Copy(SalesHeader2);
        with SalesHeader do begin
          if not Confirm(Text000,false,"Document Type","No.") then
            exit;

          SalesPostPrepayments.Invoice(SalesHeader);

          if Print then
            GetReport(SalesHeader,0);

          Commit;
          SalesHeader2 := SalesHeader;
        end;
    end;


    procedure PostPrepmtCrMemoYN(var SalesHeader2: Record "Sales Header";Print: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesPostPrepayments: Codeunit "Sales-Post Prepayments";
    begin
        SalesHeader.Copy(SalesHeader2);
        with SalesHeader do begin
          if not Confirm(Text001,false,"Document Type","No.") then
            exit;

          SalesPostPrepayments.CreditMemo(SalesHeader);

          if Print then
            GetReport(SalesHeader,1);

          Commit;
          SalesHeader2 := SalesHeader;
        end;
    end;

    local procedure GetReport(var SalesHeader: Record "Sales Header";DocumentType: Option Invoice,"Credit Memo")
    begin
        with SalesHeader do
          case DocumentType of
            Documenttype::Invoice:
              begin
                SalesInvHeader."No." := "Last Prepayment No.";
                SalesInvHeader.SetRecfilter;
                SalesInvHeader.PrintRecords(false);
              end;
            Documenttype::"Credit Memo":
              begin
                SalesCrMemoHeader."No." := "Last Prepmt. Cr. Memo No.";
                SalesCrMemoHeader.SetRecfilter;
                SalesCrMemoHeader.PrintRecords(false);
              end;
          end;
    end;
}

