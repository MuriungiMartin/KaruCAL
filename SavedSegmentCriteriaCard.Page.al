#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5140 "Saved Segment Criteria Card"
{
    Caption = 'Saved Segment Criteria Card';
    InsertAllowed = false;
    PageType = ListPlus;
    SourceTable = "Saved Segment Criteria";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the saved segment criteria.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the saved segment criteria.';
                }
            }
            part(Control11;"Saved Segment Criteria Subform")
            {
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "Segment Criteria Code"=field(Code);
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

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Close;
    end;
}

