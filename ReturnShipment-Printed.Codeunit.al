#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6651 "Return Shipment - Printed"
{
    Permissions = TableData "Return Shipment Header"=rimd;
    TableNo = "Return Shipment Header";

    trigger OnRun()
    begin
        Find;
        "No. Printed" := "No. Printed" + 1;
        Modify;
        Commit;
    end;
}

