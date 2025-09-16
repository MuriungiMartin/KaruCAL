#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 760 "Trailing Sales Order Qry"
{
    Caption = 'Trailing Sales Order Qry';

    elements
    {
        dataitem(Sales_Header;"Sales Header")
        {
            DataItemTableFilter = "Document Type"=const(Order);
            filter(ShipmentDate;"Shipment Date")
            {
            }
            filter(Status;Status)
            {
            }
            filter(DocumentDate;"Document Date")
            {
            }
            column(CurrencyCode;"Currency Code")
            {
            }
            dataitem(Sales_Line;"Sales Line")
            {
                DataItemLink = "Document Type"=Sales_Header."Document Type","Document No."=Sales_Header."No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = Amount=filter(<>0);
                column(Amount;Amount)
                {
                    Method = Sum;
                }
            }
        }
    }
}

