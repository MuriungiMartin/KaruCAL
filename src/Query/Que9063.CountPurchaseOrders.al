#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 9063 "Count Purchase Orders"
{
    Caption = 'Count Purchase Orders';

    elements
    {
        dataitem(Purchase_Header;"Purchase Header")
        {
            DataItemTableFilter = "Document Type"=const(Order);
            filter(Completely_Received;"Completely Received")
            {
            }
            filter(Responsibility_Center;"Responsibility Center")
            {
            }
            filter(Status;Status)
            {
            }
            filter(Invoice;Invoice)
            {
            }
            column(Count_Orders)
            {
                Method = Count;
            }
        }
    }
}

