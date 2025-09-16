#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1324 "Correct PstdPurchInv (Yes/No)"
{
    Permissions = TableData "Purch. Inv. Header"=rm,
                  TableData "Purch. Cr. Memo Hdr."=rm;
    TableNo = "Purch. Inv. Header";

    trigger OnRun()
    begin
        CorrectInvoice(Rec);
    end;

    var
        CorrectPostedInvoiceQst: label 'The posted purchase invoice will be canceled, and a new version of the purchase invoice will be created so that you can make the correction.\ \Do you want to continue?';


    procedure CorrectInvoice(var PurchInvHeader: Record "Purch. Inv. Header"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        CorrectPostedPurchInvoice: Codeunit "Correct Posted Purch. Invoice";
    begin
        CorrectPostedPurchInvoice.TestCorrectInvoiceIsAllowed(PurchInvHeader,false);
        if Confirm(CorrectPostedInvoiceQst) then begin
          CorrectPostedPurchInvoice.CancelPostedInvoiceStartNewInvoice(PurchInvHeader,PurchaseHeader);
          Page.Run(Page::"Purchase Invoice",PurchaseHeader);
          exit(true);
        end;

        exit(false);
    end;
}

