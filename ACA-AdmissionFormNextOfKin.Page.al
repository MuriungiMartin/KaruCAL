#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68497 "ACA-Admission Form Next Of Kin"
{
    PageType = ListPart;
    SourceTable = UnknownTable61373;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Relationship;Relationship)
                {
                    ApplicationArea = Basic;
                }
                field("Full Name";"Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Address 1";"Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Address 3";"Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 2";"Telephone No. 2")
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

