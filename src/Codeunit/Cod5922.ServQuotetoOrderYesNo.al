#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5922 "Serv-Quote to Order (Yes/No)"
{
    TableNo = "Service Header";

    trigger OnRun()
    begin
        TestField("Document Type","document type"::Quote);
        TestField("Customer No.");
        TestField("Bill-to Customer No.");
        if not Confirm(Text000,false) then
          exit;

        ServQuoteToOrder.Run(Rec);

        Message(Text001,"No.",ServQuoteToOrder.ReturnOrderNo);
    end;

    var
        Text000: label 'Do you want to convert the quote to an order?';
        Text001: label 'Service quote %1 has been converted to service order no. %2.';
        ServQuoteToOrder: Codeunit "Service-Quote to Order";
}

