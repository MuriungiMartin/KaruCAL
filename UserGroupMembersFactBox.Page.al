#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9832 "User Group Members FactBox"
{
    Caption = 'Members';
    Editable = false;
    PageType = ListPart;
    SourceTable = "User Group Member";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the user.';
                }
                field("User Full Name";"User Full Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Full Name';
                    ToolTip = 'Specifies the full name of the user.';
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

