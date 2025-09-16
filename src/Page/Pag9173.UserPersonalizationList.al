#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9173 "User Personalization List"
{
    ApplicationArea = Basic;
    Caption = 'User Personalization List';
    CardPageID = "User Personalization Card";
    Editable = false;
    PageType = List;
    SourceTable = "User Personalization";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'User ID';
                    DrillDown = false;
                    ToolTip = 'Specifies the user ID of a user who is using Database Server Authentication to log on to Dynamics NAV.';
                }
                field("Profile ID";"Profile ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Profile ID';
                    Lookup = false;
                    ToolTip = 'Specifies the ID of the profile that is associated with the current user.';
                }
                field("Language ID";"Language ID")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Language ID';
                    ToolTip = 'Specifies the ID of the language that Microsoft Windows is set up to run for the selected user.';
                }
                field("Locale ID";"Locale ID")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Locale ID';
                    ToolTip = 'Specifies the ID of the locale that Microsoft Windows is set up to run for the selected user.';
                    Visible = false;
                }
                field("Time Zone";"Time Zone")
                {
                    ApplicationArea = Basic;
                    Caption = 'Time Zone';
                    ToolTip = 'Specifies the time zone that Microsoft Windows is set up to run for the selected user.';
                    Visible = false;
                }
                field(Company;Company)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Company';
                    Lookup = false;
                    ToolTip = 'Specifies the company that is associated with the user.';
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
            group("User &Personalization")
            {
                Caption = 'User &Personalization';
                Image = Grid;
                action(List)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';
                    ToolTip = 'View or edit a list of all users who have personalized their user interface by customizing one or more pages.';

                    trigger OnAction()
                    var
                        UserPersList: Page "User Personalization List";
                    begin
                        UserPersList.LookupMode := true;
                        UserPersList.SetRecord(Rec);
                        if UserPersList.RunModal = Action::LookupOK then
                          UserPersList.GetRecord(Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("C&lear Personalized Pages")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'C&lear Personalized Pages';
                    Image = Cancel;
                    ToolTip = 'Delete all personalizations made by the selected user.';

                    trigger OnAction()
                    begin
                        ConfPersMgt.ClearUserPersonalization(Rec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        HideExternalUsers;
    end;

    var
        ConfPersMgt: Codeunit "Conf./Personalization Mgt.";
        Text000: label '%1 %2 already exists.', Comment='User Personalization User1 already exists.';

    local procedure HideExternalUsers()
    var
        PermissionManager: Codeunit "Permission Manager";
        OriginalFilterGroup: Integer;
    begin
        if not PermissionManager.SoftwareAsAService then
          exit;

        OriginalFilterGroup := FilterGroup;
        FilterGroup := 2;
        CalcFields("License Type");
        SetFilter("License Type",'<>%1',"license type"::"External User");
        FilterGroup := OriginalFilterGroup;
    end;
}

