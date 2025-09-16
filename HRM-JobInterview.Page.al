#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68916 "HRM-Job Interview"
{
    PageType = List;
    SourceTable = UnknownTable61255;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interview Code";"Interview Code")
                {
                    ApplicationArea = Basic;
                }
                field("Interview Description";"Interview Description")
                {
                    ApplicationArea = Basic;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                }
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
                }
                field(comments;comments)
                {
                    ApplicationArea = Basic;
                }
                field(Interviewer;Interviewer)
                {
                    ApplicationArea = Basic;
                }
                field("Interviewer Name";"Interviewer Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Applicants)
            {
                Caption = 'Applicants';
                action("Hiring Criteria")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hiring Criteria';
                    Image = Agreement;
                    Promoted = true;
                    RunObject = Page "HRM-Hiring Criteria";
                    RunPageLink = "Application Code"=field("Applicant No");
                }
            }
        }
    }
}

