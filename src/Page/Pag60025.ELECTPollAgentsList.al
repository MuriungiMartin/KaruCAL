#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60025 "ELECTPoll Agents List"
{
    PageType = List;
    SourceTable = UnknownTable60014;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("National ID";"National ID")
                {
                    ApplicationArea = Basic;
                }
                field(Names;Names)
                {
                    ApplicationArea = Basic;
                }
                field("Candidate No.";"Candidate No.")
                {
                    ApplicationArea = Basic;
                }
                field("Candidate Name";"Candidate Name")
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

