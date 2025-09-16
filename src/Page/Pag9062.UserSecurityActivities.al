#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9062 "User Security Activities"
{
    Caption = 'User Security Activities';
    Editable = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "User Security Status";

    layout
    {
        area(content)
        {
            cuegroup("User Security")
            {
                Caption = 'User Security';
                field("Users - To review";"Users - To review")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Users - To review';
                    DrillDownPageID = "User Security Status List";
                    Editable = false;
                    ToolTip = 'Specifies new users who have not yet been reviewed by an administrator.';
                }
                field("Users - Without Subscriptions";"Users - Without Subscriptions")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Users - Without Subscription Plans';
                    DrillDownPageID = "User Security Status List";
                    Editable = false;
                    ToolTip = 'Specifies users without subscription to use Dynamics 365 for Financials.';
                    Visible = SoftwareAsAService;
                }
                field("Users - Not Group Members";"Users - Not Group Members")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Users - Not Group Members';
                    DrillDownPageID = "User Security Status List";
                    Editable = false;
                    ToolTip = 'Specifies users who have not yet been reviewed by an administrator.';
                    Visible = SoftwareAsAService;
                }
                field(NumberOfPlans;NumberOfPlans)
                {
                    ApplicationArea = Basic;
                    Caption = 'Number of plans';
                    Visible = SoftwareAsAService;

                    trigger OnDrillDown()
                    var
                        Plan: Record Plan;
                        AzureADUserManagement: Codeunit "Azure AD User Management";
                    begin
                        if not SoftwareAsAService then
                          exit;
                        AzureADUserManagement.GetPlans(Plan,false);
                        Page.Run(Page::Plans,Plan)
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        UserSecurityStatus: Record "User Security Status";
        PermissionManager: Codeunit "Permission Manager";
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        SoftwareAsAService := PermissionManager.SoftwareAsAService;
        if SoftwareAsAService then
          NumberOfPlans := GetNumberOfPlansFromAzure;
        UserSecurityStatus.LoadUsers;
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        RoleCenterNotificationMgt.ShowNotifications;
    end;

    var
        SoftwareAsAService: Boolean;
        NumberOfPlans: Integer;

    local procedure GetNumberOfPlansFromAzure(): Integer
    var
        Plan: Record Plan;
        AzureADUserManagement: Codeunit "Azure AD User Management";
    begin
        if not SoftwareAsAService then
          exit(0);
        AzureADUserManagement.GetPlans(Plan,false);
        exit(Plan.Count);
    end;
}

