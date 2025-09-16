#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 9150 "My Customers"
{
    Caption = 'My Customers';

    elements
    {
        dataitem(My_Customer;"My Customer")
        {
            filter(User_ID;"User ID")
            {
            }
            column(Customer_No;"Customer No.")
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemLink = "No."=My_Customer."Customer No.";
                filter(Date_Filter;"Date Filter")
                {
                }
                column(Sum_Sales_LCY;"Sales (LCY)")
                {
                    Method = Sum;
                }
                column(Sum_Profit_LCY;"Profit (LCY)")
                {
                    Method = Sum;
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetRange(User_ID,UserId);
    end;
}

