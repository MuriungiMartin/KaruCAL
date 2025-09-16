#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9818 "User Security Status List"
{
    ApplicationArea = Basic;
    Caption = 'User Security Status List';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "User Security Status";
    SourceTableView = where("User Security ID"=filter(<>}")");
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name";"User Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = NOT Reviewed;
                    ToolTip = 'Specifies the user''s name. If the user is required to present credentials when starting the client, this is the name that the user must present.';
                }
                field("Full Name";"Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the full name of the user.';
                }
                field(Reviewed;Reviewed)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if an administrator has reviewed this new user. When a new user is created, this field is empty to indicate that the user must be set up.';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Belongs To Subscription Plan";"Belongs To Subscription Plan")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = NOT "Belongs To Subscription Plan";
                    ToolTip = 'Specifies that the user is covered by a subscription plan.';
                    Visible = SoftwareAsAService ;
                }
                field("Belongs to User Group";"Belongs to User Group")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = NOT "Belongs to User Group";
                    ToolTip = 'Specifies that the user is assigned to a user group.';
                }
            }
        }
        area(factboxes)
        {
            part(Control3;"User Plan Members FactBox")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Plans';
                SubPageLink = "User Security ID"=FIELD("User Security ID");
                Visible = SoftwareAsAService ;
            }
            part(Control15;"User Groups User SubPage")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Groups';
                Editable = false;
                ShowFilter = false;
                SubPageLink = "User Security ID"=FIELD("User Security ID");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Users from Office 365")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Get Users from Office 365';
                Image = Users;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Gets updated information about users from the Office portal.';
                Visible = SoftwareAsAService;

                trigger OnAction()
                var
                    AzureADUserManagement: Codeunit "Azure AD User Management"Page "User Group Members";
                RunPageMode = View;
                ToolTip = 'View or edit the members of the user group.';
Codeunit "Permission Manager"Codeunit "Azure AD User Management"Codeunit ""
