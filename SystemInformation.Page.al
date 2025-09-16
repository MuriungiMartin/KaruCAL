#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9180 "System Information"
{
    ApplicationArea = Basic;
    Caption = 'System Information';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    ShowFilter = false;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            field(Version;GetVersion)
            {
                ApplicationArea = All;
                Caption = 'Version';
            }
            field(CreatedDateTime;GetCreatedDateTime)
            {
                ApplicationArea = All;
                Caption = 'Created';
            }
        }
    }

    actions
    {
    }

    var
        ApplicationMgt: Codeunit ApplicationManagement;

    local procedure GetVersion(): Text
    begin
        exit(StrSubstNo('%1 (%2)',ApplicationMgt.ApplicationVersion,ApplicationMgt.ApplicationBuild));
    end;

    local procedure GetCreatedDateTime(): DateTime
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get;

        exit(CompanyInformation."Created DateTime");
    end;
}

