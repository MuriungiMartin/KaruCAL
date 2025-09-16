#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99990 "Graduation Course Reg."
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable66631;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Year of Study";"Year of Study")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Attained Stage Units";"Attained Stage Units")
                {
                    ApplicationArea = Basic;
                }
                field("Required Stage Units";"Required Stage Units")
                {
                    ApplicationArea = Basic;
                }
                field("Final Classification";"Final Classification")
                {
                    ApplicationArea = Basic;
                }
                field("Total Units";"Total Units")
                {
                    ApplicationArea = Basic;
                }
                field("Total Marks";"Total Marks")
                {
                    ApplicationArea = Basic;
                }
                field("Total Weighted Marks";"Total Weighted Marks")
                {
                    ApplicationArea = Basic;
                }
                field("Failed Courses";"Failed Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Failed Cores";"Failed Cores")
                {
                    ApplicationArea = Basic;
                }
                field("Failed Required";"Failed Required")
                {
                    ApplicationArea = Basic;
                }
                field("Total Courses";"Total Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Failed Electives";"Failed Electives")
                {
                    ApplicationArea = Basic;
                }
                field("Total Cores Done";"Total Cores Done")
                {
                    ApplicationArea = Basic;
                }
                field("Total Cores Passed";"Total Cores Passed")
                {
                    ApplicationArea = Basic;
                }
                field("Total Required Done";"Total Required Done")
                {
                    ApplicationArea = Basic;
                }
                field("Total Electives Done";"Total Electives Done")
                {
                    ApplicationArea = Basic;
                }
                field("Tota Electives Passed";"Tota Electives Passed")
                {
                    ApplicationArea = Basic;
                }
                field("CATS Missing";"CATS Missing")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Missing";"Exam Missing")
                {
                    ApplicationArea = Basic;
                }
                field("Is Pass";"Is Pass")
                {
                    ApplicationArea = Basic;
                }
                field("Exists Alternative Rubric";"Exists Alternative Rubric")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Academic Year";"Graduation Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Graduating;Graduating)
                {
                    ApplicationArea = Basic;
                }
                field("Programme Option";"Programme Option")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Graduation Units")
            {
                ApplicationArea = Basic;
                Image = ApplicationWorksheet;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Graduation Units List";
                RunPageLink = "Student No."=field("Student Number"),
                              "Graduation Academic Year"=field("Graduation Academic Year"),
                              "Year of Study"=field("Year of Study");
            }
        }
    }
}

