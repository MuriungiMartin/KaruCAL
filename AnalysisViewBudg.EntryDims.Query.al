#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 253 "Analysis View Budg. Entry Dims"
{
    Caption = 'Analysis View Budg. Entry Dims';

    elements
    {
        dataitem(Analysis_View_Budget_Entry;"Analysis View Budget Entry")
        {
            SqlJoinType = CrossJoin;
            filter(Analysis_View_Code;"Analysis View Code")
            {
            }
            filter(Budget_Name;"Budget Name")
            {
            }
            filter(Business_Unit_Code;"Business Unit Code")
            {
            }
            filter(Posting_Date;"Posting Date")
            {
            }
            filter(G_L_Account_No;"G/L Account No.")
            {
            }
            column(Dimension_1_Value_Code;"Dimension 1 Value Code")
            {
            }
            column(Dimension_2_Value_Code;"Dimension 2 Value Code")
            {
            }
            column(Dimension_3_Value_Code;"Dimension 3 Value Code")
            {
            }
            column(Dimension_4_Value_Code;"Dimension 4 Value Code")
            {
            }
            column(Sum_Amount;Amount)
            {
                Method = Sum;
            }
        }
    }
}

