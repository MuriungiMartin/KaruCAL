#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74521 "TT-Rooms List"
{
    PageType = List;
    SourceTable = UnknownTable74501;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Block Code";"Block Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Room Code";"Room Code")
                {
                    ApplicationArea = Basic;
                }
                field("Room Type";"Room Type")
                {
                    ApplicationArea = Basic;
                }
                field("Class Capacity (Min)";"Class Capacity (Min)")
                {
                    ApplicationArea = Basic;
                }
                field("Class Capacity (Max)";"Class Capacity (Max)")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Capacity (Min)";"Exam Capacity (Min)")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Capacity (Max)";"Exam Capacity (Max)")
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

