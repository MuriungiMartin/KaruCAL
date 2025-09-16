#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99433 "PesaFlow Intergration2"
{
    PageType = List;
    SourceTable = UnknownTable77756;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PaymentRefID;PaymentRefID)
                {
                    ApplicationArea = Basic;
                }
                field("Phone Number";"Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Date Received";"Date Received")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name";"Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceAmount;InvoiceAmount)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

