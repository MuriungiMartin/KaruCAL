#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5067 "Contact Industry Groups"
{
    Caption = 'Contact Industry Groups';
    DataCaptionFields = "Contact No.";
    PageType = List;
    SourceTable = "Contact Industry Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Industry Group Code";"Industry Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the industry group code. This field is not editable.';
                }
                field("Industry Group Description";"Industry Group Description")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the description of the industry group you have assigned to the contact.';
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

