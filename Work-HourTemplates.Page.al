#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6017 "Work-Hour Templates"
{
    ApplicationArea = Basic;
    Caption = 'Work-Hour Templates';
    PageType = List;
    SourceTable = "Work-Hour Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the work-hour template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the work-hour template.';
                }
                field(Monday;Monday)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of work-hours on Monday.';
                }
                field(Tuesday;Tuesday)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of work-hours on Tuesday.';
                }
                field(Wednesday;Wednesday)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of work-hours on Wednesday.';
                }
                field(Thursday;Thursday)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of work-hours on Thursday.';
                }
                field(Friday;Friday)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of work-hours on Friday.';
                }
                field(Saturday;Saturday)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of work-hours on Saturday.';
                }
                field(Sunday;Sunday)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of work-hours on Sunday.';
                }
                field("Total per Week";"Total per Week")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total number of work-hours per week for the work-hour template.';
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
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

