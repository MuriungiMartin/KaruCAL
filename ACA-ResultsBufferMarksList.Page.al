#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78055 "ACA-Results Buffer Marks List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable78055;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field(Lecturer;Lecturer)
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Type";"Exam Type")
                {
                    ApplicationArea = Basic;
                }
                field("Score (String)";"Score (String)")
                {
                    ApplicationArea = Basic;
                }
                field("Date Submitted";"Date Submitted")
                {
                    ApplicationArea = Basic;
                }
                field("Time Submitted";"Time Submitted")
                {
                    ApplicationArea = Basic;
                }
                field("Submitted By";"Submitted By")
                {
                    ApplicationArea = Basic;
                }
                field(Logs;Logs)
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

