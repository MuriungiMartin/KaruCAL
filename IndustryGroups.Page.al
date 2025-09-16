#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5066 "Industry Groups"
{
    ApplicationArea = Basic;
    Caption = 'Industry Groups';
    PageType = List;
    SourceTable = "Industry Group";
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
                    ToolTip = 'Specifies the code for the industry group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the industry group.';
                }
                field("No. of Contacts";"No. of Contacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Industry Group Contacts";
                    ToolTip = 'Specifies the number of contacts that have been assigned the industry group. This field is not editable.';
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
            group("&Industry Group")
            {
                Caption = '&Industry Group';
                Image = IndustryGroups;
                action("C&ontacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'C&ontacts';
                    Image = CustomerContact;
                    RunObject = Page "Industry Group Contacts";
                    RunPageLink = "Industry Group Code"=field(Code);
                    ToolTip = 'View a list of the contact companies you have assigned the industry group to.';
                }
            }
        }
    }
}

