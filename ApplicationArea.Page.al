#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9179 "Application Area"
{
    ApplicationArea = Basic;
    Caption = 'Application Area';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Application Area Buffer";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application Area";"Application Area")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the scope of the application functionality for which fields and actions are shown. Fields and action for non-selected application areas are hidden to simplify the user interface.';
                }
                field(Selected;Selected)
                {
                    ApplicationArea = All;
                    Caption = 'Show in User Interface';
                    ToolTip = 'Specifies that fields and actions for the application area are shown in the user interface.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnModifyRecord(): Boolean
    begin
        Modified := true;
    end;

    trigger OnOpenPage()
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        CurrPage.Editable := not PermissionManager.SoftwareAsAService;
        ApplicationAreaSetup.GetApplicationAreaBuffer(Rec);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if Modified then
          if TrySave then
            Message(ReSignInMsg);
    end;

    var
        ApplicationAreaSetup: Record "Application Area Setup";
        ReSignInMsg: label 'You must sign out and then sign in again to have the changes take effect.', Comment='"sign out" and "sign in" are the same terms as shown in the Dynamics NAV client.';
        Modified: Boolean;

    local procedure TrySave(): Boolean
    begin
        exit(ApplicationAreaSetup.TrySaveApplicationAreaCurrentCompany(Rec));
    end;
}

