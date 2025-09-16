#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70712 "Sms-Batch Custom Lines"
{
    PageType = ListPart;
    SourceTable = UnknownTable70708;

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                field("Recepient Type";"Recepient Type")
                {
                    ApplicationArea = Basic;
                }
                field("Phone Number";"Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Reception No";"Reception No")
                {
                    ApplicationArea = Basic;
                }
                field("Recepient Name";"Recepient Name")
                {
                    ApplicationArea = Basic;
                }
                field("Message 1";"Message 1")
                {
                    ApplicationArea = Basic;
                }
                field("message 2";"message 2")
                {
                    ApplicationArea = Basic;
                }
                field("message 3";"message 3")
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

