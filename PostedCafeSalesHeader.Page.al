#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65024 "Posted Cafe Sales Header"
{
    PageType = Card;
    SourceTable = "Sales Shipment Header";
    SourceTableView = where("Cash Sale Order"=filter(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Amount Paid";"Amount Paid")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Sales Location Category";"Sales Location Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                part(Control1000000007;"Posted Cafe Receipt Lines")
                {
                    SubPageLink = "Document No."=field("No.");
                }
            }
        }
    }

    actions
    {
    }
}

