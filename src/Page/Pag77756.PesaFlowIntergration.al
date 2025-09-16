#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77756 "PesaFlow Intergration"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable77756;
    SourceTableView = where(Posted=filter(No));

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
                field(CustomerRefNo;CustomerRefNo)
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name";"Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceNo;InvoiceNo)
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceAmount;InvoiceAmount)
                {
                    ApplicationArea = Basic;
                }
                field(PaidAmount;PaidAmount)
                {
                    ApplicationArea = Basic;
                }
                field(ServiceID;ServiceID)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(PaymentChannel;PaymentChannel)
                {
                    ApplicationArea = Basic;
                }
                field(PaymentDate;PaymentDate)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Date Received";"Date Received")
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

