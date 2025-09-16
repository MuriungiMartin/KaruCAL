#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5078 "Interaction Group Statistics"
{
    Caption = 'Interaction Group Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Interaction Group";

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
                    ToolTip = 'Specifies the number of interactions that have been created using this interaction group. This field is not editable.';
                }
                field("Cost (LCY)";"Cost (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the total cost of the interactions created using this interaction group. This field is not editable.';
                }
                field("Duration (Min.)";"Duration (Min.)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the total duration of the interactions created using this interaction group. The field is not editable.';
                }
            }
        }
    }

    actions
    {
    }
}

