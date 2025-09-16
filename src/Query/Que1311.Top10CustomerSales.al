#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 1311 "Top 10 Customer Sales"
{
    Caption = 'Top 10 Customer Sales';
    OrderBy = descending(Sum_Sales_LCY);
    TopNumberOfRows = 10;

    elements
    {
        dataitem(Cust_Ledger_Entry;"Cust. Ledger Entry")
        {
            filter(Posting_Date;"Posting Date")
            {
            }
            column(Customer_No;"Customer No.")
            {
            }
            column(Sum_Sales_LCY;"Sales (LCY)")
            {
                Method = Sum;
            }
        }
    }
}

