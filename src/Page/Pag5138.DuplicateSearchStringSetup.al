#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5138 "Duplicate Search String Setup"
{
    Caption = 'Duplicate Search String Setup';
    PageType = List;
    SourceTable = "Duplicate Search String Setup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Field";Field)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the name of the field on which the search string is based. There are eight options: Name, Name 2, Address, Address 2, ZIP code, City, Phone No., and Tax Registration No.';
                }
                field("Part of Field";"Part of Field")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the part of the field to use to generate the search string. There are two options: First and Last.';
                }
                field(Length;Length)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies how many characters the search string will contain. You can enter a number from 2 to 10. The program automatically enters 5 as a default value.';
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

