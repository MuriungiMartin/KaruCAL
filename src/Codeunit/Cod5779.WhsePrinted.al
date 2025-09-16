#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5779 "Whse.-Printed"
{
    TableNo = "Warehouse Activity Header";

    trigger OnRun()
    begin
        LockTable;
        Find;
        "No. Printed" := "No. Printed" + 1;
        "Date of Last Printing" := Today;
        "Time of Last Printing" := Time;
        Modify;
        Commit;
    end;
}

