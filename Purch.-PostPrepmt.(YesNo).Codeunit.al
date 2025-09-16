#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 445 "Purch.-Post Prepmt.  (Yes/No)"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Do you want to post the prepayments for %1 %2?';
        Text001: label 'Do you want to post a credit memo for the prepayments for %1 %2?';
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";


    procedure PostPrepmtInvoiceYN(var PurchHeader2: Record "Purchase Header";Print: Boolean)
    var
        PurchHeader: Record "Purchase Header";
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
    begin
        PurchHeader.Copy(PurchHeader2);
        with PurchHeader do begin
          if not Confirm(Text000,false,"Document Type","No.") then
            exit;

          PurchPostPrepmt.Invoice(PurchHeader);

          if Print then
            GetReport(PurchHeader,0);

          Commit;
          PurchHeader2 := PurchHeader;
        end;
    end;


    procedure PostPrepmtCrMemoYN(var PurchHeader2: Record "Purchase Header";Print: Boolean)
    var
        PurchHeader: Record "Purchase Header";
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
    begin
        PurchHeader.Copy(PurchHeader2);
        with PurchHeader do begin
          if not Confirm(Text001,false,"Document Type","No.") then
            exit;

          PurchPostPrepmt.CreditMemo(PurchHeader);

          if Print then
            GetReport(PurchHeader,1);

          Commit;
          PurchHeader2 := PurchHeader;
        end;
    end;

    local procedure GetReport(var PurchHeader: Record "Purchase Header";DocumentType: Option Invoice,"Credit Memo")
    begin
        with PurchHeader do
          case DocumentType of
            Documenttype::Invoice:
              begin
                PurchInvHeader."No." := "Last Prepayment No.";
                PurchInvHeader.SetRecfilter;
                PurchInvHeader.PrintRecords(false);
              end;
            Documenttype::"Credit Memo":
              begin
                PurchCrMemoHeader."No." := "Last Prepmt. Cr. Memo No.";
                PurchCrMemoHeader.SetRecfilter;
                PurchCrMemoHeader.PrintRecords(false);
              end;
          end;
    end;
}

