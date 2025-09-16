#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5207 "Qualified Employees"
{
    Caption = 'Qualified Employees';
    DataCaptionFields = "Qualification Code";
    Editable = false;
    PageType = List;
    SourceTable = "Employee Qualification";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a number for the employee.';
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the employee started working on obtaining this qualification.';
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the employee is considered to have obtained this qualification.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a type for the qualification, which specifies where the qualification was obtained.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the qualification.';
                }
                field("Institution/Company";"Institution/Company")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the institution from which the employee obtained the qualification.';
                }
                field(Cost;Cost)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost of the qualification.';
                    Visible = false;
                }
                field("Course Grade";"Course Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the grade that the employee received for the course, specified by the qualification on this line.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether a comment was entered for this entry.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Q&ualification")
            {
                Caption = 'Q&ualification';
                Image = Certificate;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=const("Employee Qualification"),
                                  "No."=field("Employee No."),
                                  "Table Line No."=field("Line No.");
                }
                separator(Action27)
                {
                }
                action("Q&ualification Overview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Q&ualification Overview';
                    Image = QualificationOverview;
                    RunObject = Page "Qualification Overview";
                }
            }
        }
    }
}

