#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9130 "Contact Statistics FactBox"
{
    Caption = 'Contact Statistics FactBox';
    PageType = CardPart;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Cost (LCY)";"Cost (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the total cost of all the interactions involving the contact. The field is not editable.';
                }
                field("Duration (Min.)";"Duration (Min.)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the total duration of all the interactions involving the contact. The field is not editable.';
                }
            }
            group(Opportunities)
            {
                Caption = 'Opportunities';
                field("No. of Opportunities";"No. of Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of open opportunities involving the contact. The field is not editable.';
                }
                field("Estimated Value (LCY)";"Estimated Value (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the total estimated value of all the opportunities involving the contact. The field is not editable.';
                }
                field("Calcd. Current Value (LCY)";"Calcd. Current Value (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the total calculated current value of all the opportunities involving the contact. The field is not editable.';
                }
            }
            group(Segmentation)
            {
                Caption = 'Segmentation';
                field("No. of Job Responsibilities";"No. of Job Responsibilities")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of job responsibilities for this contact. This field is valid for persons only and is not editable.';
                }
                field("No. of Industry Groups";"No. of Industry Groups")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of industry groups to which the contact belongs. When the contact is a person, this field contains the number of industry groups for the contact''s company. This field is not editable.';
                }
                field("No. of Business Relations";"No. of Business Relations")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of business relations (for example, customer, vendor, consultant, competitor, and so on) your company has with this contact. When the contact is a person, this field contains the number of business relations for the contact''s company. This field is not editable.';
                }
                field("No. of Mailing Groups";"No. of Mailing Groups")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of mailing groups for this contact.';
                }
            }
        }
    }

    actions
    {
    }
}

