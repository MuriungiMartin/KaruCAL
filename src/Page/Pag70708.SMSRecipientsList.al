#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70708 "SMS Recipients List"
{
    PageType = ListPart;
    SourceTable = UnknownTable70702;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Recepient Type";"Recepient Type")
                {
                    ApplicationArea = Basic;
                }
                field("Recipient No.";"Recipient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Recipient Name";"Recipient Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                }
                field("Message 1";"Message 1")
                {
                    ApplicationArea = Basic;
                }
                field("Message 2";"Message 2")
                {
                    ApplicationArea = Basic;
                }
                field("Message 3";"Message 3")
                {
                    ApplicationArea = Basic;
                }
                field(Delivered;Delivered)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("User Code";"User Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

