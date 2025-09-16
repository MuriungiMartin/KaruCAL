#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78017 "Supp/Special Exam Results View"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable78003;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                }
                field(Exam;Exam)
                {
                    ApplicationArea = Basic;
                }
                field("Reg. Transaction ID";"Reg. Transaction ID")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                }
                field(Percentage;Percentage)
                {
                    ApplicationArea = Basic;
                }
                field(Contribution;Contribution)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Category";"Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field(ExamType;ExamType)
                {
                    ApplicationArea = Basic;
                }
                field("Admission No";"Admission No")
                {
                    ApplicationArea = Basic;
                }
                field(Reported;Reported)
                {
                    ApplicationArea = Basic;
                }
                field("Lecturer Names";"Lecturer Names")
                {
                    ApplicationArea = Basic;
                }
                field(UserID;UserID)
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Session";"Exam Session")
                {
                    ApplicationArea = Basic;
                }
                field(Catogory;Catogory)
                {
                    ApplicationArea = Basic;
                }
                field("Current Academic Year";"Current Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Capture Date";"Capture Date")
                {
                    ApplicationArea = Basic;
                }
                field("Modified Date";"Modified Date")
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

