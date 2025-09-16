#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 1252 "Bank Rec. Match Candidates"
{
    Caption = 'Bank Rec. Match Candidates';

    elements
    {
        dataitem(Bank_Acc_Reconciliation_Line;"Bank Acc. Reconciliation Line")
        {
            DataItemTableFilter = Difference=filter(<>0),Type=filter(="Bank Account Ledger Entry");
            column(Rec_Line_Bank_Account_No;"Bank Account No.")
            {
            }
            column(Rec_Line_Statement_No;"Statement No.")
            {
            }
            column(Rec_Line_Statement_Line_No;"Statement Line No.")
            {
            }
            column(Rec_Line_Transaction_Date;"Transaction Date")
            {
            }
            column(Rec_Line_Description;Description)
            {
            }
            column(Rec_Line_RltdPty_Name;"Related-Party Name")
            {
            }
            column(Rec_Line_Transaction_Info;"Additional Transaction Info")
            {
            }
            column(Rec_Line_Statement_Amount;"Statement Amount")
            {
            }
            column(Rec_Line_Applied_Amount;"Applied Amount")
            {
            }
            column(Rec_Line_Difference;Difference)
            {
            }
            column(Rec_Line_Type;Type)
            {
            }
            column(Rec_Line_Applied_Entries;"Applied Entries")
            {
            }
            dataitem(Bank_Account_Ledger_Entry;"Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No."=Bank_Acc_Reconciliation_Line."Bank Account No.";
                DataItemTableFilter = "Remaining Amount"=filter(<>0),Open=const(true),"Statement Status"=filter(Open);
                column(Entry_No;"Entry No.")
                {
                }
                column(Bank_Account_No;"Bank Account No.")
                {
                }
                column(Posting_Date;"Posting Date")
                {
                }
                column(Document_No;"Document No.")
                {
                }
                column(Description;Description)
                {
                }
                column(Remaining_Amount;"Remaining Amount")
                {
                }
                column(Bank_Ledger_Entry_Open;Open)
                {
                }
                column(Statement_Status;"Statement Status")
                {
                }
                column(External_Document_No;"External Document No.")
                {
                }
            }
        }
    }
}

