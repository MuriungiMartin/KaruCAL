#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 66650 "ACA-Exam. Senate Review"
{
    Caption = 'Senate Report Preview';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable66651;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student Number";"Student Number")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field(Classification;Classification)
                {
                    ApplicationArea = Basic;
                }
                field("Year of Study";"Year of Study")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Skip Supplementary Generation";"Skip Supplementary Generation")
                {
                    ApplicationArea = Basic;
                }
                field("Programme Option";"Programme Option")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Academic Year";"Graduation Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Total Courses";"Total Courses")
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
                field("Normal Average";"Normal Average")
                {
                    ApplicationArea = Basic;
                }
                field("Weighted Average";"Weighted Average")
                {
                    ApplicationArea = Basic;
                }
                field("Total Failed Courses";"Total Failed Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Total Failed Units";"Total Failed Units")
                {
                    ApplicationArea = Basic;
                }
                field("Failed Courses";"Failed Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Failed Units";"Failed Units")
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
                field("Total Required Passed";"Total Required Passed")
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
                field("Required Stage Units";"Required Stage Units")
                {
                    ApplicationArea = Basic;
                }
                field("Attained Stage Units";"Attained Stage Units")
                {
                    ApplicationArea = Basic;
                }
                field("Units Deficit";"Units Deficit")
                {
                    ApplicationArea = Basic;
                }
                field("Cummulative Fails";"Cummulative Fails")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm. Required Stage Units";"Cumm. Required Stage Units")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm Attained Units";"Cumm Attained Units")
                {
                    ApplicationArea = Basic;
                }
                field("Deficit Core Courses";"Deficit Core Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Deficit Core Units";"Deficit Core Units")
                {
                    ApplicationArea = Basic;
                }
                field("Deficit Required Courses";"Deficit Required Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Deficit Required Units";"Deficit Required Units")
                {
                    ApplicationArea = Basic;
                }
                field("Deficit Electives Courses";"Deficit Electives Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Deficit Electives Units";"Deficit Electives Units")
                {
                    ApplicationArea = Basic;
                }
                field("Multiple Programe Reg. Exists";"Multiple Programe Reg. Exists")
                {
                    ApplicationArea = Basic;
                }
                field("% Total Failed Courses";"% Total Failed Courses")
                {
                    ApplicationArea = Basic;
                }
                field("% Total Failed Units";"% Total Failed Units")
                {
                    ApplicationArea = Basic;
                }
                field("% Failed Courses";"% Failed Courses")
                {
                    ApplicationArea = Basic;
                }
                field("% Failed Units";"% Failed Units")
                {
                    ApplicationArea = Basic;
                }
                field("% Failed Cores";"% Failed Cores")
                {
                    ApplicationArea = Basic;
                }
                field("% Failed Required";"% Failed Required")
                {
                    ApplicationArea = Basic;
                }
                field("% Failed Electives";"% Failed Electives")
                {
                    ApplicationArea = Basic;
                }
                field("Supp. Registration Exists";"Supp. Registration Exists")
                {
                    ApplicationArea = Basic;
                }
                field("Yearly Rubric Occurances";"Yearly Rubric Occurances")
                {
                    ApplicationArea = Basic;
                }
                field("Total Rubric Occurances";"Total Rubric Occurances")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Allowable Occurances";"Maximum Allowable Occurances")
                {
                    ApplicationArea = Basic;
                }
                field("Alternate Rubric";"Alternate Rubric")
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
            action("Student Units")
            {
                ApplicationArea = Basic;
                Caption = 'Student Units';
                Image = ApplicationWorksheet;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ACA-Exam-Senate Units View";
                RunPageLink = "Student No."=field("Student Number"),
                              Programme=field(Programme),
                              "Year of Study"=field("Year of Study"),
                              "Academic Year"=field("Academic Year");
            }
        }
    }
}

