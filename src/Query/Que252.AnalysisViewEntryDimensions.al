#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 252 "Analysis View Entry Dimensions"
{
    Caption = 'Analysis View Entry Dimensions';

    elements
    {
        dataitem(Analysis_View_Entry;"Analysis View Entry")
        {
            SqlJoinType = CrossJoin;
            filter(Analysis_View_Code;"Analysis View Code")
            {
            }
            filter(Business_Unit_Code;"Business Unit Code")
            {
            }
            filter(Account_No;"Account No.")
            {
            }
            filter(Posting_Date;"Posting Date")
            {
            }
            filter(Account_Source;"Account Source")
            {
            }
            filter(Cash_Flow_Forecast_No;"Cash Flow Forecast No.")
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

