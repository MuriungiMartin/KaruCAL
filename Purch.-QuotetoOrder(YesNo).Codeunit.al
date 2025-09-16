#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 93 "Purch.-Quote to Order (Yes/No)"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    begin
        TestField("Document Type","document type"::Quote);
        if not Confirm(Text000,false) then
          exit;

        PurchQuoteToOrder.Run(Rec);
        PurchQuoteToOrder.GetPurchOrderHeader(PurchOrderHeader);

        Message(
          Text001,
          "No.",PurchOrderHeader."No.");
    end;

    var
        Text000: label 'Do you want to convert the quote to an order?';
        Text001: label 'Quote number %1 has been converted to order number %2.';
        PurchOrderHeader: Record "Purchase Header";
        PurchQuoteToOrder: Codeunit "Purch.-Quote to Order";
}

