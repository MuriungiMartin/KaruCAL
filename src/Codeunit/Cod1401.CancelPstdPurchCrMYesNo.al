#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1401 "Cancel PstdPurchCrM (Yes/No)"
{
    Permissions = TableData "Sales Invoice Header"=rm,
                  TableData "Sales Cr.Memo Header"=rm;
    TableNo = "Purch. Cr. Memo Hdr.";

    trigger OnRun()
    begin
        CancelCrMemo(Rec);
    end;

    var
        CancelPostedCrMemoQst: label 'The posted purchase credit memo will be canceled, and a purchase invoice will be created and posted, which reverses the posted purchase credit memo. Do you want to continue?';
        OpenPostedInvQst: label 'The invoice was successfully created. Do you want to open the posted invoice?';

    local procedure CancelCrMemo(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."): Boolean
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        CancelledDocument: Record "Cancelled Document";
        CancelPostedPurchCrMemo: Codeunit "Cancel Posted Purch. Cr. Memo";
    begin
        CancelPostedPurchCrMemo.TestCorrectCrMemoIsAllowed(PurchCrMemoHdr);
        if Confirm(CancelPostedCrMemoQst) then
          if CancelPostedPurchCrMemo.CancelPostedCrMemo(PurchCrMemoHdr) then
            if Confirm(OpenPostedInvQst) then begin
              CancelledDocument.FindPurchCancelledCrMemo(PurchCrMemoHdr."No.");
              PurchInvHeader.Get(CancelledDocument."Cancelled By Doc. No.");
              Page.Run(Page::"Posted Purchase Invoice",PurchInvHeader);
              exit(true);
            end;

        exit(false);
    end;
}

