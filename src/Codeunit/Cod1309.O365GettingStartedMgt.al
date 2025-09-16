#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1309 "O365 Getting Started Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure LaunchWizard(UserInitiated: Boolean;TourCompleted: Boolean)
    var
        O365GettingStarted: Record "O365 Getting Started";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        PermissionManager: Codeunit "Permission Manager";
        WizardHasBeenShownToUser: Boolean;
        PageToStart: Integer;
    begin
        if not CompanyInformationMgt.IsDemoCompany then
          exit;

        WizardHasBeenShownToUser := O365GettingStarted.Get(UserId,CurrentClientType);

        if CurrentClientType in [Clienttype::Phone,Clienttype::Tablet] then begin
          if not PermissionManager.SoftwareAsAService then
            exit;
          PageToStart := Page::"O365 Getting Started Device"
        end else begin
          if IsDeveloperUser then
            PageToStart := Page::"O365 Developer Getting Started"
          else
            PageToStart := Page::"O365 Getting Started";
        end;

        if not WizardHasBeenShownToUser then begin
          EnsurePayPalDemoAccountExists;
          Page.RunModal(PageToStart);
          exit;
        end;

        if (not O365GettingStarted."Tour in Progress") and (not UserInitiated) then
          exit;

        if UserInitiated then begin
          Page.RunModal(PageToStart);
          exit;
        end;

        if O365GettingStarted."Tour in Progress" then begin
          if CurrentClientType in [Clienttype::Phone,Clienttype::Tablet] then
            exit;

          if TourCompleted and not IsDeveloperUser then
            Page.RunModal(Page::"O365 Tour Complete")
          else
            Page.RunModal(PageToStart);
        end;
    end;


    procedure UpdateGettingStartedVisible(var TileGettingStartedVisible: Boolean;var TileRestartGettingStartedVisible: Boolean)
    var
        O365GettingStarted: Record "O365 Getting Started";
    begin
        TileGettingStartedVisible := false;
        TileRestartGettingStartedVisible := false;

        if not IsGettingStartedSupported then
          exit;

        TileRestartGettingStartedVisible := true;

        if not O365GettingStarted.Get(UserId,CurrentClientType) then
          exit;

        TileGettingStartedVisible := O365GettingStarted."Tour in Progress";
        TileRestartGettingStartedVisible := not TileGettingStartedVisible;
    end;


    procedure IsGettingStartedSupported(): Boolean
    var
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
    begin
        exit(CompanyInformationMgt.IsDemoCompany and (CurrentClientType = Clienttype::Web));
    end;


    procedure GetGettingStartedTourID(): Integer
    begin
        exit(173706);
    end;


    procedure GetInvoicingTourID(): Integer
    begin
        exit(174204);
    end;


    procedure GetReportingTourID(): Integer
    begin
        exit(174207);
    end;


    procedure GetChangeCompanyTourID(): Integer
    begin
        exit(174206);
    end;


    procedure GetWizardDoneTourID(): Integer
    begin
        exit(176849);
    end;


    procedure GetReturnToGettingStartedTourID(): Integer
    begin
        exit(176291);
    end;


    procedure GetDevJourneyTourID(): Integer
    begin
        // TODO: Update with actual tour ID, placeholder for now
        exit(176849);
    end;

    local procedure EnsurePayPalDemoAccountExists()
    var
        AllObj: Record AllObj;
    begin
        AllObj.SetRange("Object Type",AllObj."object type"::Codeunit);
        AllObj.SetRange("Object ID",1072);
        if not AllObj.FindFirst then
          exit;

        if Codeunit.Run(AllObj."Object ID") then
          Commit;
    end;

    local procedure IsDeveloperUser(): Boolean
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get;
        exit(CompanyInformation."Custom System Indicator Text" = CompanyInformation.GetDevBetaModeTxt);
    end;


    procedure GetAddItemTourID(): Integer
    begin
        exit(237373);
    end;


    procedure GetAddCustomerTourID(): Integer
    begin
        exit(239510);
    end;


    procedure GetCreateSalesOrderTourID(): Integer
    begin
        exit(240566);
    end;


    procedure GetCreateSalesInvoiceTourID(): Integer
    begin
        exit(240561);
    end;
}

