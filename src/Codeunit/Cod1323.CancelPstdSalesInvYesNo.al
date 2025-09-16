#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1323 "Cancel PstdSalesInv (Yes/No)"
{
    Permissions = TableData "Sales Invoice Header"=rm,
                  TableData "Sales Cr.Memo Header"=rm;
    TableNo = "Sales Invoice Header";

    trigger OnRun()
    begin
        CancelInvoice(Rec);
    end;

    var
        CancelPostedInvoiceQst: label 'The posted sales invoice will be canceled, and a sales credit memo will be created and posted, which reverses the posted sales invoice.\ \Do you want to continue?';
        OpenPostedCreditMemoQst: label 'A credit memo was successfully created. Do you want to open the posted credit memo?';
        CancelIfContainingJobQst: label 'The sales invoice contains lines that are related to a job. The job information on these lines will not be transferred to the sales credit memo that is created when you choose Cancel.\\To ensure that job information is available on a sales credit memo, use the Create Sales Credit Memo action on the job planning line.\\';


    procedure CancelInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        CancelledDocument: Record "Cancelled Document";
        CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
    begin
        CorrectPostedSalesInvoice.TestCorrectInvoiceIsAllowed(SalesInvoiceHeader,true);
        if Confirm(CreateConfirmQuestion(SalesInvoiceHeader)) then
          if CorrectPostedSalesInvoice.CancelPostedInvoice(SalesInvoiceHeader) then
            if Confirm(OpenPostedCreditMemoQst) then begin
              CancelledDocument.FindSalesCancelledInvoice(SalesInvoiceHeader."No.");
              SalesCrMemoHeader.Get(CancelledDocument."Cancelled By Doc. No.");
              Page.Run(Page::"Posted Sales Credit Memo",SalesCrMemoHeader);
              exit(true);
            end;

        exit(false);
    end;

    local procedure CreateConfirmQuestion(SalesInvoiceHeader: Record "Sales Invoice Header"): Text
    begin
        if SalesLinesContainsJob(SalesInvoiceHeader) then
          exit(CancelIfContainingJobQst + CancelPostedInvoiceQst);

        exit(CancelPostedInvoiceQst);
    end;

    local procedure SalesLinesContainsJob(SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetRange("Document No.",SalesInvoiceHeader."No.");
        if SalesInvoiceLine.Find('-') then
          repeat
            if SalesInvoiceLine."Job No." <> '' then
              exit(true);
          until SalesInvoiceLine.Next = 0;

        exit(false);
    end;
}

