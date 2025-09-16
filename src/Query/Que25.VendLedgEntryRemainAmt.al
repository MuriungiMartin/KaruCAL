#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 25 "Vend. Ledg. Entry Remain. Amt."
{
    Caption = 'Vend. Ledg. Entry Remain. Amt.';

    elements
    {
        dataitem(Vendor_Ledger_Entry;"Vendor Ledger Entry")
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
            filter(Vendor_No;"Vendor No.")
            {
            }
            filter(Vendor_Posting_Group;"Vendor Posting Group")
            {
            }
            column(Sum_Remaining_Amt_LCY;"Remaining Amt. (LCY)")
            {
                Method = Sum;
            }
        }
    }
}

