#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 256 "CF Forecast Entry Dimensions"
{
    Caption = 'CF Forecast Entry Dimensions';

    elements
    {
        dataitem(Cash_Flow_Forecast_Entry;"Cash Flow Forecast Entry")
        {
            filter(Cash_Flow_Forecast_No;"Cash Flow Forecast No.")
            {
            }
            filter(Cash_Flow_Date;"Cash Flow Date")
            {
            }
            filter(Cash_Flow_Account_No;"Cash Flow Account No.")
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
            column(Sum_Amount_LCY;"Amount (LCY)")
            {
                Method = Sum;
            }
        }
    }
}

