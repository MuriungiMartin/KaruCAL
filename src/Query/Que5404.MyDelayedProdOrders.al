#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 5404 "My Delayed Prod. Orders"
{
    Caption = 'My Delayed Prod. Orders';

    elements
    {
        dataitem(My_Item;"My Item")
        {
            filter(User_ID;"User ID")
            {
            }
            dataitem(Prod_Order_Line;"Prod. Order Line")
            {
                DataItemLink = "Item No."=My_Item."Item No.";
                DataItemTableFilter = Status=filter(Planned|"Firm Planned"|Released);
                column(Item_No;"Item No.")
                {
                }
                column(Status;Status)
                {
                }
                filter(Due_Date;"Due Date")
                {
                }
                column(Sum_Remaining_Quantity;"Remaining Quantity")
                {
                    Method = Sum;
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetFilter(Due_Date,'<%1',Today);
        SetRange(User_ID,UserId);
    end;
}

