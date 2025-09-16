#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5064 "Contact Mailing Groups"
{
    Caption = 'Contact Mailing Groups';
    DataCaptionFields = "Contact No.";
    PageType = List;
    SourceTable = "Contact Mailing Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Mailing Group Code";"Mailing Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the mailing group code. This field is not editable.';
                }
                field("Mailing Group Description";"Mailing Group Description")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the description of the mailing group you have chosen to assign the contact.';
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

