#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 1310 "Cust. Ledg. Entry Sales"
{
    Caption = 'Cust. Ledg. Entry Sales';

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
            filter(Customer_No;"Customer No.")
            {
            }
            filter(Posting_Date;"Posting Date")
            {
            }
            column(Sum_Sales_LCY;"Sales (LCY)")
            {
                Method = Sum;
            }
        }
    }
}

