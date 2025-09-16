#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99995 "Graduation Overview"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable66630;

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
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
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
                field("Graduation Group";"Graduation Group")
                {
                    ApplicationArea = Basic;
                }
                field("Final Classification";"Final Classification")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Classified Average";"Classified Average")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Required Stage Units";"Required Stage Units")
                {
                    ApplicationArea = Basic;
                }
                field("Attained Stage Units";"Attained Stage Units")
                {
                    ApplicationArea = Basic;
                }
                field(Graduating;Graduating)
                {
                    ApplicationArea = Basic;
                }
                field(Classification;Classification)
                {
                    ApplicationArea = Basic;
                }
                field("Total Courses";"Total Courses")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Total Units";"Total Units")
                {
                    ApplicationArea = Basic;
                }
                field("Total Marks";"Total Marks")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Total Weighted Marks";"Total Weighted Marks")
                {
                    ApplicationArea = Basic;
                }
                field("Normal Average";"Normal Average")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field("Total Electives Done";"Total Electives Done")
                {
                    ApplicationArea = Basic;
                }
                field("Tota Electives Passed";"Tota Electives Passed")
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
            action("Graduation Semester Registration")
            {
                ApplicationArea = Basic;
                Image = CustomerCode;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Graduation Course Reg.";
                RunPageLink = "Student Number"=field("Student Number"),
                              Programme=field(Programme),
                              "Graduation Academic Year"=field("Graduation Academic Year");
            }
            action("Graduation Units")
            {
                ApplicationArea = Basic;
                Image = ApplicationWorksheet;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Graduation Units List";
                RunPageLink = "Student No."=field("Student Number"),
                              Programme=field(Programme),
                              "Graduation Academic Year"=field("Graduation Academic Year");
            }
            action("Not Graduating Reasons")
            {
                ApplicationArea = Basic;
                Image = DocInBrowser;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Graduation Failure Reasons";
                RunPageLink = "Student No."=field("Student Number"),
                              "Graduation Academic Year"=field("Graduation Academic Year");
            }
        }
    }
}

