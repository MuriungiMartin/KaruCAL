#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9822 "User Plan Members"
{
    Caption = 'User Plan Members';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "User Plan";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name";"User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the short name for the user.';
                }
                field("User Full Name";"User Full Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full name of the user.';
                }
                field("Plan Name";"Plan Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the subscription plan.';
                }
            }
        }
    }

    actions
    {
    }
}

