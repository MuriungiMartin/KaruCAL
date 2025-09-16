#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5060 "Business Relations"
{
    ApplicationArea = Basic;
    Caption = 'Business Relations';
    PageType = List;
    SourceTable = "Business Relation";
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
                    ToolTip = 'Specifies the code for the business relation.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the business relation.';
                }
                field("No. of Contacts";"No. of Contacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Business Relation Contacts";
                    ToolTip = 'Specifies the number of contacts that have been assigned the business relation. The field is not editable.';
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
            group("&Business Relation")
            {
                Caption = '&Business Relation';
                Image = BusinessRelation;
                action("C&ontacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'C&ontacts';
                    Image = CustomerContact;
                    RunObject = Page "Business Relation Contacts";
                    RunPageLink = "Business Relation Code"=field(Code);
                    ToolTip = 'View a list of the contact companies you have assigned the business relation to.';
                }
            }
        }
    }
}

