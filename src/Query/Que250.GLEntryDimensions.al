#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 250 "G/L Entry Dimensions"
{
    Caption = 'G/L Entry Dimensions';

    elements
    {
        dataitem(G_L_Entry;"G/L Entry")
        {
            filter(G_L_Account_No;"G/L Account No.")
            {
            }
            filter(Posting_Date;"Posting Date")
            {
            }
            filter(Business_Unit_Code;"Business Unit Code")
            {
            }
            filter(Global_Dimension_1_Code;"Global Dimension 1 Code")
            {
            }
            filter(Global_Dimension_2_Code;"Global Dimension 2 Code")
            {
            }
            column(Dimension_Set_ID;"Dimension Set ID")
            {
            }
            column(Sum_Amount;Amount)
            {
                Method = Sum;
            }
            column(Sum_Debit_Amount;"Debit Amount")
            {
                Method = Sum;
            }
            column(Sum_Credit_Amount;"Credit Amount")
            {
                Method = Sum;
            }
        }
    }
}

