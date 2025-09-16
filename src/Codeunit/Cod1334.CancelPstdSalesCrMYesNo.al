#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1334 "Cancel PstdSalesCrM (Yes/No)"
{
    Permissions = TableData "Sales Invoice Header"=rm,
                  TableData "Sales Cr.Memo Header"=rm;
    TableNo = "Sales Cr.Memo Header";

    trigger OnRun()
    begin
        CancelCrMemo(Rec);
    end;

    var
        CancelPostedCrMemoQst: label 'The posted sales credit memo will be canceled, and a sales invoice will be created and posted, which reverses the posted sales credit memo. Do you want to continue?';
        OpenPostedInvQst: label 'The invoice was successfully created. Do you want to open the posted invoice?';

    local procedure CancelCrMemo(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Boolean
    var
        SalesInvHeader: Record "Sales Invoice Header";
        CancelledDocument: Record "Cancelled Document";
        CancelPostedSalesCrMemo: Codeunit "Cancel Posted Sales Cr. Memo";
    begin
        CancelPostedSalesCrMemo.TestCorrectCrMemoIsAllowed(SalesCrMemoHeader);
        if Confirm(CancelPostedCrMemoQst) then
          if CancelPostedSalesCrMemo.CancelPostedCrMemo(SalesCrMemoHeader) then
            if Confirm(OpenPostedInvQst) then begin
              CancelledDocument.FindSalesCancelledCrMemo(SalesCrMemoHeader."No.");
              SalesInvHeader.Get(CancelledDocument."Cancelled By Doc. No.");
              Page.Run(Page::"Posted Sales Invoice",SalesInvHeader);
              exit(true);
            end;

        exit(false);
    end;
}

