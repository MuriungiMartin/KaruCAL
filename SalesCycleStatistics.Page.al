#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5120 "Sales Cycle Statistics"
{
    Caption = 'Sales Cycle Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Sales Cycle";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No. of Opportunities";"No. of Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of opportunities that you have created using the sales cycle. This field is not editable.';
                }
                field("Estimated Value (LCY)";"Estimated Value (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the estimated value of all the open opportunities that you have assigned to the sales cycle. This field is not editable.';
                }
                field("Calcd. Current Value (LCY)";"Calcd. Current Value (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the calculated current value of all the open opportunities that you have assigned to the sales cycle. This field is not editable.';
                }
            }
        }
    }

    actions
    {
    }
}

