#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1304 "Sales-Quote to Invoice Yes/No"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        InvoiceSalesHeader: Record "Sales Header";
        SalesQuoteToInvoice: Codeunit "Sales-Quote to Invoice";
        OfficeMgt: Codeunit "Office Management";
    begin
        TestField("Document Type","document type"::Quote);
        if GuiAllowed then
          if not Confirm(ConfirmConvertToInvoiceQst,false) then
            exit;

        SalesQuoteToInvoice.Run(Rec);
        SalesQuoteToInvoice.GetSalesInvoiceHeader(InvoiceSalesHeader);

        Commit;

        if GuiAllowed then
          if OfficeMgt.AttachAvailable then
            Page.Run(Page::"Sales Invoice",InvoiceSalesHeader)
          else
            if Confirm(StrSubstNo(OpenNewInvoiceQst,InvoiceSalesHeader."No."),true) then
              Page.Run(Page::"Sales Invoice",InvoiceSalesHeader);
    end;

    var
        ConfirmConvertToInvoiceQst: label 'Do you want to convert the quote to an invoice?';
        OpenNewInvoiceQst: label 'The quote has been converted to invoice %1. Do you want to open the new invoice?';
}

