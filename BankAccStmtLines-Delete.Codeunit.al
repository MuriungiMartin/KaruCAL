#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 382 "BankAccStmtLines-Delete"
{
    Permissions = TableData "Bank Account Statement Line"=d;
    TableNo = "Bank Account Statement";

    trigger OnRun()
    begin
        BankAccStmtLine.SetRange("Bank Account No.","Bank Account No.");
        BankAccStmtLine.SetRange("Statement No.","Statement No.");
        BankAccStmtLine.DeleteAll;
    end;

    var
        BankAccStmtLine: Record "Bank Account Statement Line";
}

