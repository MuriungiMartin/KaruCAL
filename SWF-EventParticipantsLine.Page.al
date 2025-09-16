#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68688 "SWF-Event Participants Line"
{
    PageType = List;
    SourceTable = UnknownTable61454;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Partcipant Name";"Partcipant Name")
                {
                    ApplicationArea = Basic;
                }
                field(Confirmed;Confirmed)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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

