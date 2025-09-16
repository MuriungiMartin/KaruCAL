#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8638 "Configuration Completion"
{
    Caption = 'Configuration Completion';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Setup';
    ShowFilter = false;
    SourceTable = "Config. Setup";

    layout
    {
        area(content)
        {
            group("Complete Setup")
            {
                Caption = 'Complete Setup';
                group(Control6)
                {
                    label(Control5)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'If you have finished setting up the company, select the profile that you want to use as your default, and then choose the OK button to close the page. Then restart the Microsoft Dynamics NAV client to apply the changes.';
                    }
                    field("Your Profile Code";"Your Profile Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the profile code for your configuration solution and package.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Setup)
            {
                Caption = 'Setup';
            }
            action(Users)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Users';
                Image = User;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page Users;
                ToolTip = 'View or edit users that will be configured in the database.';
            }
            action("Users Personalization")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Users Personalization';
                Image = UserSetup;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "User Personalization List";
                ToolTip = 'View or edit UI changes that will be configured in the database.';
            }
        }
    }

    trigger OnClosePage()
    begin
        SelectDefaultRoleCenter("Your Profile Code");
    end;
}

