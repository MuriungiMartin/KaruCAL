#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5068 "Industry Group Contacts"
{
    Caption = 'Industry Group Contacts';
    DataCaptionFields = "Industry Group Code";
    PageType = List;
    SourceTable = "Contact Industry Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact company you are assigning industry groups.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the contact company you are assigning an industry group.';
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

