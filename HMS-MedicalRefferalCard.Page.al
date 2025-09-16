#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90032 "HMS-Medical Refferal Card"
{
    PageType = Card;
    SourceTable = UnknownTable90024;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Consultation No.";"Consultation No.")
                {
                    ApplicationArea = Basic;
                }
                field("Referal Id";"Referal Id")
                {
                    ApplicationArea = Basic;
                }
                field("Staff No.";"Staff No.")
                {
                    ApplicationArea = Basic;
                }
                field("Referal Details";"Referal Details")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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

