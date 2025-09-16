#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 66661 "ACA-Final Grade Setup"
{
    PageType = List;
    SourceTable = UnknownTable66661;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minimum Score";"Minimum Score")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Score";"Maximum Score")
                {
                    ApplicationArea = Basic;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                }
                field(Pass;Pass)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Missing CAT";"Missing CAT")
                {
                    ApplicationArea = Basic;
                }
                field("Missing Exam";"Missing Exam")
                {
                    ApplicationArea = Basic;
                }
                field("Missed Both CAT & Exam";"Missed Both CAT & Exam")
                {
                    ApplicationArea = Basic;
                }
                field("Less Courses";"Less Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Override Transcript Comments";"Override Transcript Comments")
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

