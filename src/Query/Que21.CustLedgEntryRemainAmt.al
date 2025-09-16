#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 21 "Cust. Ledg. Entry Remain. Amt."
{
    Caption = 'Cust. Ledg. Entry Remain. Amt.';

    elements
    {
        dataitem(Cust_Ledger_Entry;"Cust. Ledger Entry")
        {
            filter(Document_Type;"Document Type")
            {
            }
            filter(IsOpen;Open)
            {
            }
            filter(Due_Date;"Due Date")
            {
            }
            filter(Customer_No;"Customer No.")
            {
            }
            filter(Customer_Posting_Group;"Customer Posting Group")
            {
            }
            column(Sum_Remaining_Amt_LCY;"Remaining Amt. (LCY)")
            {
                Method = Sum;
            }
        }
    }
}

