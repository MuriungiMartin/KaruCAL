#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 84 "Blnkt Sales Ord. to Ord. (Y/N)"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        TestField("Document Type","document type"::"Blanket Order");
        if not Confirm(Text000,false) then
          exit;

        BlanketSalesOrderToOrder.Run(Rec);
        BlanketSalesOrderToOrder.GetSalesOrderHeader(SalesHeader2);

        Message(
          Text001,
          SalesHeader2."No.","No.");
    end;

    var
        Text000: label 'Do you want to create an order from the blanket order?';
        Text001: label 'Order %1 has been created from blanket order %2.';
        SalesHeader2: Record "Sales Header";
        BlanketSalesOrderToOrder: Codeunit "Blanket Sales Order to Order";
}

