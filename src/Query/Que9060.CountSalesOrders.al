#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 9060 "Count Sales Orders"
{
    Caption = 'Count Sales Orders';

    elements
    {
        dataitem(Sales_Header;"Sales Header")
        {
            DataItemTableFilter = "Document Type"=const(Order);
            filter(Status;Status)
            {
            }
            filter(Shipped;Shipped)
            {
            }
            filter(Completely_Shipped;"Completely Shipped")
            {
            }
            filter(Responsibility_Center;"Responsibility Center")
            {
            }
            filter(Ship;Ship)
            {
            }
            filter(Invoice;Invoice)
            {
            }
            filter(Date_Filter;"Date Filter")
            {
            }
            filter(Late_Order_Shipping;"Late Order Shipping")
            {
            }
            filter(Shipment_Date;"Shipment Date")
            {
            }
            column(Count_Orders)
            {
                Method = Count;
            }
        }
    }
}

