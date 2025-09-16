#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70042 "JobRecruitment Inv/Regret Mail"
{
    CardPageID = "Recruitment Inv/Regret Mail Cd";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60239;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Message Type";"Message Type")
                {
                    ApplicationArea = Basic;
                }
                field(Salutation;Salutation)
                {
                    ApplicationArea = Basic;
                }
                field("Include Initials";"Include Initials")
                {
                    ApplicationArea = Basic;
                }
                field(Subject;Subject)
                {
                    ApplicationArea = Basic;
                }
                field("Paragraph 1";"Paragraph 1")
                {
                    ApplicationArea = Basic;
                }
                field("Paragraph 2";"Paragraph 2")
                {
                    ApplicationArea = Basic;
                }
                field("Disclaimer 1";"Disclaimer 1")
                {
                    ApplicationArea = Basic;
                }
                field("Disclaimer 2";"Disclaimer 2")
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

