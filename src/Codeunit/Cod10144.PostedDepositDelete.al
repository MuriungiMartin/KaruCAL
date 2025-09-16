#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10144 "Posted Deposit-Delete"
{
    Permissions = TableData UnknownTableData10143=rd,
                  TableData UnknownTableData10144=rd,
                  TableData UnknownTableData10145=rd;
    TableNo = UnknownTable10143;

    trigger OnRun()
    begin
        PostedDepositLine.SetRange("Deposit No.","No.");
        PostedDepositLine.DeleteAll;

        Delete;
    end;

    var
        PostedDepositLine: Record UnknownRecord10144;
}

