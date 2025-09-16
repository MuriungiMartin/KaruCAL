#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9843 "User Lookup"
{
    Caption = 'Users';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = User;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the user''s name. If the user is required to present credentials when starting the client, this is the name that the user must present.';
                }
                field("User Security ID";"User Security ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an ID that uniquely identifies the user. This value is generated automatically and should not be changed.';
                    Visible = false;
                }
                field("Windows Security ID";"Windows Security ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Windows Security ID of the user. This is only relevant for Windows authentication.';
                    Visible = false;
                }
                field("Authentication Email";"Authentication Email")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Microsoft account that this user signs into Office 365 or SharePoint Online with.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        HideExternalUsers;
    end;


    procedure GetSelectionFilter(var User: Record User)
    begin
        CurrPage.SetSelectionFilter(User);
    end;

    local procedure HideExternalUsers()
    var
        PermissionManager: Codeunit "Permission Manager";
        OriginalFilterGroup: Integer;
    begin
        if not PermissionManager.SoftwareAsAService then
          exit;

        OriginalFilterGroup := FilterGroup;
        FilterGroup := 2;
        SetFilter("License Type",'<>%1',"license type"::"External User");
        FilterGroup := OriginalFilterGroup;
    end;
}

