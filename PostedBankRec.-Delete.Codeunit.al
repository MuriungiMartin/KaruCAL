#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10125 "Posted Bank Rec.-Delete"
{
    Permissions = TableData UnknownTableData10122=rd,
                  TableData UnknownTableData10123=rd,
                  TableData UnknownTableData10124=rd,
                  TableData UnknownTableData10125=rd;
    TableNo = UnknownTable10123;

    trigger OnRun()
    begin
        PostedBankRecLines.SetRange("Bank Account No.","Bank Account No.");
        PostedBankRecLines.SetRange("Statement No.","Statement No.");
        PostedBankRecLines.DeleteAll;

        BankRecCommentLines.SetRange("Table Name",BankRecCommentLines."table name"::"Posted Bank Rec.");
        BankRecCommentLines.SetRange("Bank Account No.","Bank Account No.");
        BankRecCommentLines.SetRange("No.","Statement No.");
        BankRecCommentLines.DeleteAll;

        Delete;
    end;

    var
        PostedBankRecLines: Record UnknownRecord10124;
        BankRecCommentLines: Record UnknownRecord10122;
}

