#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5101 Activity
{
    Caption = 'Activity';
    PageType = ListPlus;
    SourceTable = Activity;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the activity.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the activity.';
                }
            }
            part(Control9;"Activity Step Subform")
            {
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "Activity Code"=field(Code);
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

