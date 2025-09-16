#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1322 "Correct PstdSalesInv (Yes/No)"
{
    Permissions = TableData "Sales Invoice Header"=rm,
                  TableData "Sales Cr.Memo Header"=rm;
    TableNo = "Sales Invoice Header";

    trigger OnRun()
    begin
        CorrectInvoice(Rec);
    end;

    var
        CorrectPostedInvoiceQst: label 'The posted sales invoice will be canceled, and a new version of the sales invoice will be created so that you can make the correction.\ \Do you want to continue?';
        CorrectIfContainingJobQst: label 'The sales invoice contains lines that are related to a job. The job information on these lines will not be transferred to the new sales invoice that is created when you choose Correct.\\To ensure that job information is available on a corrected sales invoice, you must first use the Create Sales Credit Memo action on the job planning line, and then use the Create Job Sales Invoice action with updated job planning lines to create a new corrected sales invoice.\\';


    procedure CorrectInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        SalesHeader: Record "Sales Header";
        CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
    begin
        CorrectPostedSalesInvoice.TestCorrectInvoiceIsAllowed(SalesInvoiceHeader,false);
        if Confirm(CreateConfirmQuestion(SalesInvoiceHeader)) then begin
          CorrectPostedSalesInvoice.CancelPostedInvoiceStartNewInvoice(SalesInvoiceHeader,SalesHeader);
          Page.Run(Page::"Sales Invoice",SalesHeader);
          exit(true);
        end;

        exit(false);
    end;

    local procedure CreateConfirmQuestion(SalesInvoiceHeader: Record "Sales Invoice Header"): Text
    begin
        if SalesLinesContainsJob(SalesInvoiceHeader) then
          exit(CorrectIfContainingJobQst + CorrectPostedInvoiceQst);

        exit(CorrectPostedInvoiceQst);
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

