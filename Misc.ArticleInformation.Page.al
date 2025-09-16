#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5219 "Misc. Article Information"
{
    Caption = 'Misc. Article Information';
    DataCaptionFields = "Employee No.";
    PageType = List;
    SourceTable = "Misc. Article Information";

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
                    Visible = false;
                }
                field("Misc. Article Code";"Misc. Article Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code to define the type of miscellaneous article.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the miscellaneous article.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the miscellaneous article.';
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the employee first received the miscellaneous article.';
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the employee no longer possesses the miscellaneous article.';
                }
                field("In Use";"In Use")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the miscellaneous article is in use.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a comment is associated with this entry.';
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
            group("Mi&sc. Article")
            {
                Caption = 'Mi&sc. Article';
                Image = FiledOverview;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=const("Misc. Article Information"),
                                  "No."=field("Employee No."),
                                  "Alternative Address Code"=field("Misc. Article Code"),
                                  "Table Line No."=field("Line No.");
                }
            }
        }
    }
}

