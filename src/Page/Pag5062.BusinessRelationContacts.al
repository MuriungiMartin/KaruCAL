#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5062 "Business Relation Contacts"
{
    Caption = 'Business Relation Contacts';
    DataCaptionFields = "Business Relation Code";
    PageType = List;
    SourceTable = "Contact Business Relation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact number of the company you are assigning a business relation.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the contact company to which you assign a business relation. This field is not editable.';
                }
                field("Link to Table";"Link to Table")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the name of the table to which the contact is linked. There are four possible options: &lt;blank&gt;, Vendor, Customer, and Bank Account.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number assigned to the contact in the Customer, Vendor, or Bank Account table. This field is only valid for contacts recorded as customer, vendor or bank accounts.';
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

