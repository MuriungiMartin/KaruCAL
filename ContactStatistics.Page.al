#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5053 "Contact Statistics"
{
    Caption = 'Contact Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No. of Interactions";"No. of Interactions")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of interactions created for this contact. The field is not editable.';
                }
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
        }
    }

    actions
    {
    }
}

