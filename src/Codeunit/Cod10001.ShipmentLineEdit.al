#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10001 "Shipment Line - Edit"
{
    Permissions = TableData "Sales Shipment Line"=imd;
    TableNo = "Sales Shipment Line";

    trigger OnRun()
    begin
        SalesShipmentLine := Rec;
        SalesShipmentLine.LockTable;
        SalesShipmentLine.Find;
        SalesShipmentLine."Package Tracking No." := "Package Tracking No.";
        SalesShipmentLine.Modify;
        Rec := SalesShipmentLine;
    end;

    var
        SalesShipmentLine: Record "Sales Shipment Line";
}

