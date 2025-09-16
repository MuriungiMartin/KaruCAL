#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9836 "User Group Memberships FactBox"
{
    Caption = 'User Group Memberships FactBox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "User Group Member";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Group Code";"User Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a user group.';
                }
                field("User Group Name";"User Group Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company.';
                }
            }
        }
    }

    actions
    {
    }
}

