#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 5400 "Delayed Prod. Orders - by Cost"
{
    Caption = 'Delayed Prod. Orders - by Cost';
    OrderBy = descending(Cost_of_Open_Production_Orders);

    elements
    {
        dataitem(Prod_Order_Line;"Prod. Order Line")
        {
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
            dataitem(Item;Item)
            {
                DataItemLink = "No."=Prod_Order_Line."Item No.";
                column(Cost_of_Open_Production_Orders;"Cost of Open Production Orders")
                {
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetFilter(Due_Date,'<%1',Today);
    end;
}

