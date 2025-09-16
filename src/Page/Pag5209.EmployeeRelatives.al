#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5209 "Employee Relatives"
{
    AutoSplitKey = true;
    Caption = 'Employee Relatives';
    DataCaptionFields = "Employee No.";
    PageType = List;
    SourceTable = "Employee Relative";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Relative Code";"Relative Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a relative code for the employee.';
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the first name of the employee''s relative.';
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the middle name of the employee''s relative.';
                    Visible = false;
                }
                field("Birth Date";"Birth Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the relative''s date of birth.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the relative''s telephone number.';
                }
                field("Relative's Employee No.";"Relative's Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the relative''s employee number, if the relative also works at the company.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a comment was entered for this entry.';
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
            group("Relati&ve")
            {
                Caption = 'Relati&ve';
                Image = Relatives;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=const("Employee Relative"),
                                  "No."=field("Employee No."),
                                  "Table Line No."=field("Line No.");
                }
            }
        }
    }
}

