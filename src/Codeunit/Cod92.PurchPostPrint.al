#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 92 "Purch.-Post + Print"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    begin
        PurchHeader.Copy(Rec);
        Code;
        Rec := PurchHeader;
    end;

    var
        Text000: label '&Receive,&Invoice,Receive &and Invoice';
        Text001: label 'Do you want to post and print the %1?';
        Text002: label '&Ship,&Invoice,Ship &and Invoice';
        PurchHeader: Record "Purchase Header";
        Selection: Integer;

    local procedure "Code"()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchasePostViaJobQueue: Codeunit "Purchase Post via Job Queue";
    begin
        with PurchHeader do begin
          case "Document Type" of
            "document type"::Order:
              begin
                Selection := StrMenu(Text000,3);
                if Selection = 0 then
                  exit;
                Receive := Selection in [1,3];
                Invoice := Selection in [2,3];
              end;
            "document type"::"Return Order":
              begin
                Selection := StrMenu(Text002,3);
                if Selection = 0 then
                  exit;
                Ship := Selection in [1,3];
                Invoice := Selection in [2,3];
              end
            else
              if not
                 Confirm(
                   Text001,false,
                   "Document Type")
              then
                exit;
          end;
          "Print Posted Documents" := true;

          PurchSetup.Get;
          if PurchSetup."Post & Print with Job Queue" then
            PurchasePostViaJobQueue.EnqueuePurchDoc(PurchHeader)
          else begin
            Codeunit.Run(Codeunit::"Purch.-Post",PurchHeader);
            GetReport(PurchHeader);
          end;
        end;
    end;


    procedure GetReport(var PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do
          case "Document Type" of
            "document type"::Order:
              begin
                if Receive then
                  PrintReceive(PurchHeader);
                if Invoice then
                  PrintInvoice(PurchHeader);
              end;
            "document type"::Invoice:
              PrintInvoice(PurchHeader);
            "document type"::"Return Order":
              begin
                if Ship then
                  PrintShip(PurchHeader);
                if Invoice then
                  PrintInvoice(PurchHeader);
              end;
            "document type"::"Credit Memo":
              PrintCrMemo(PurchHeader);
          end;
    end;

    local procedure PrintReceive(PurchHeader: Record "Purchase Header")
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        PurchRcptHeader."No." := PurchHeader."Last Receiving No.";
        PurchRcptHeader.SetRecfilter;
        PurchRcptHeader.PrintRecords(false);
    end;

    local procedure PrintInvoice(PurchHeader: Record "Purchase Header")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if PurchHeader."Last Posting No." = '' then
          PurchInvHeader."No." := PurchHeader."No."
        else
          PurchInvHeader."No." := PurchHeader."Last Posting No.";
        PurchInvHeader.Find;
        PurchInvHeader.SetRecfilter;
        PurchInvHeader.PrintRecords(false);
    end;

    local procedure PrintShip(PurchHeader: Record "Purchase Header")
    var
        ReturnShptHeader: Record "Return Shipment Header";
    begin
        ReturnShptHeader."No." := PurchHeader."Last Return Shipment No.";
        ReturnShptHeader.SetRecfilter;
        ReturnShptHeader.PrintRecords(false);
    end;

    local procedure PrintCrMemo(PurchHeader: Record "Purchase Header")
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        if PurchHeader."Last Posting No." = '' then
          PurchCrMemoHdr."No." := PurchHeader."No."
        else
          PurchCrMemoHdr."No." := PurchHeader."Last Posting No.";
        PurchCrMemoHdr.Find;
        PurchCrMemoHdr.SetRecfilter;
        PurchCrMemoHdr.PrintRecords(false);
    end;
}

