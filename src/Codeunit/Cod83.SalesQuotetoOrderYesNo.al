#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 83 "Sales-Quote to Order (Yes/No)"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        TestField("Document Type","document type"::Quote);
        if GuiAllowed then
          if not Confirm(ConfirmConvertToOrderQst,false) then
            exit;

        if CheckCustomerCreated(true) then
          Get("document type"::Quote,"No.")
        else
          exit;

        SalesQuoteToOrder.Run(Rec);
        SalesQuoteToOrder.GetSalesOrderHeader(SalesHeader2);
        Commit;

        if GuiAllowed then
          if OfficeMgt.AttachAvailable then
            Page.Run(Page::"Sales Order",SalesHeader2)
          else
            if Confirm(StrSubstNo(OpenNewInvoiceQst,SalesHeader2."No."),true) then
              Page.Run(Page::"Sales Order",SalesHeader2);
    end;

    var
        ConfirmConvertToOrderQst: label 'Do you want to convert the quote to an order?';
        OpenNewInvoiceQst: label 'The quote has been converted to order %1. Do you want to open the new order?', Comment='%1 = No. of the new sales order document.';
        SalesHeader2: Record "Sales Header";
        SalesQuoteToOrder: Codeunit "Sales-Quote to Order";
}

