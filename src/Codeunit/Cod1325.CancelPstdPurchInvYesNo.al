#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1325 "Cancel PstdPurchInv (Yes/No)"
{
    Permissions = TableData "Purch. Inv. Header"=rm,
                  TableData "Purch. Cr. Memo Hdr."=rm;
    TableNo = "Purch. Inv. Header";

    trigger OnRun()
    begin
        CancelInvoice(Rec);
    end;

    var
        CancelPostedInvoiceQst: label 'The posted purchase invoice will be canceled, and a purchase credit memo will be created and posted, which reverses the posted purchase invoice.\ \Do you want to continue?';
        OpenPostedCreditMemoQst: label 'A credit memo was successfully created. Do you want to open the posted credit memo?';


    procedure CancelInvoice(var PurchInvHeader: Record "Purch. Inv. Header"): Boolean
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        CancelledDocument: Record "Cancelled Document";
        CorrectPostedPurchInvoice: Codeunit "Correct Posted Purch. Invoice";
    begin
        CorrectPostedPurchInvoice.TestCorrectInvoiceIsAllowed(PurchInvHeader,true);
        if Confirm(CancelPostedInvoiceQst) then
          if CorrectPostedPurchInvoice.CancelPostedInvoice(PurchInvHeader) then
            if Confirm(OpenPostedCreditMemoQst) then begin
              CancelledDocument.FindPurchCancelledInvoice(PurchInvHeader."No.");
              PurchCrMemoHdr.Get(CancelledDocument."Cancelled By Doc. No.");
              Page.Run(Page::"Posted Purchase Credit Memo",PurchCrMemoHdr);
              exit(true);
            end;

        exit(false);
    end;
}

