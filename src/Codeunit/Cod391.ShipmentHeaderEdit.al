#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 391 "Shipment Header - Edit"
{
    Permissions = TableData "Sales Shipment Header"=m;
    TableNo = "Sales Shipment Header";

    trigger OnRun()
    begin
        SalesShptHeader := Rec;
        SalesShptHeader.LockTable;
        SalesShptHeader.Find;
        SalesShptHeader."Shipping Agent Code" := "Shipping Agent Code";
        SalesShptHeader."Shipping Agent Service Code" := "Shipping Agent Service Code";
        SalesShptHeader."Package Tracking No." := "Package Tracking No.";
        SalesShptHeader.Modify;
        Rec := SalesShptHeader;
    end;

    var
        SalesShptHeader: Record "Sales Shipment Header";
}

