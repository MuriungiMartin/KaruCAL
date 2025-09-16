#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5080 "Job Responsibilities"
{
    ApplicationArea = Basic;
    Caption = 'Job Responsibilities';
    PageType = List;
    SourceTable = "Job Responsibility";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the job responsibility.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the job responsibility.';
                }
                field("No. of Contacts";"No. of Contacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Job Responsibility Contacts";
                    ToolTip = 'Specifies the number of contacts that have been assigned the job responsibility.';
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
        area(navigation)
        {
            group("&Job Responsibility")
            {
                Caption = '&Job Responsibility';
                Image = Job;
                action("C&ontacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'C&ontacts';
                    Image = CustomerContact;
                    RunObject = Page "Job Responsibility Contacts";
                    RunPageLink = "Job Responsibility Code"=field(Code);
                    ToolTip = 'View a list of contacts that are associated with the specific job responsibility.';
                }
            }
        }
    }
}

