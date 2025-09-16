#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2502 "Extension Marketplace"
{
    Caption = 'Extension Marketplace';
    Editable = false;

    layout
    {
        area(content)
        {
            usercontrol(Marketplace;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = Basic,Suite;

                trigger ControlAddInReady(callbackUrl: Text)
                var
                    MarketplaceUrl: Text;
                begin
                    MarketplaceUrl := ExtensionMarketplaceMgmt.GetMarketplaceEmbeddedUrl;
                    CurrPage.Marketplace.SubscribeToEvent('message',MarketplaceUrl);
                    CurrPage.Marketplace.Navigate(MarketplaceUrl);
                end;

                trigger DocumentReady()
                var
                    PostMessage: Text;
                begin
                    PostMessage := ExtensionMarketplaceMgmt.GetLoadMarketplaceMessage;
                    CurrPage.Marketplace.PostMessage(PostMessage,'*',true);
                end;

                trigger Callback(data: Text)
                begin
                    if TryGetMsgType(data) then
                      PerformAction(MessageType);
                end;

                trigger Refresh(callbackUrl: Text)
                var
                    MarketplaceUrl: Text;
                begin
                    MarketplaceUrl := ExtensionMarketplaceMgmt.GetMarketplaceEmbeddedUrl;
                    CurrPage.Marketplace.SubscribeToEvent('message',MarketplaceUrl);
                    CurrPage.Marketplace.Navigate(MarketplaceUrl);
                end;
            }
        }
    }

    actions
    {
    }

    var
        ExtensionMarketplaceMgmt: Codeunit "Extension Marketplace";
        JObject: dotnet JObject;
        MessageType: Text;
        TelemetryUrl: Text;
        ExtensionInstallationFailureErr: label 'The extension %1 failed to install.', Comment='%1=name of extension';
        ExtensionNotFoundErr: label 'Selected extension could not be installed because it is not published.', Comment='Error message for trying to install an extension that is not published';
        OperationResult: Option UserNotAuthorized,DeploymentFailedDueToPackage,DeploymentFailed,Successful,UserCancel,UserTimeOut;

    local procedure PerformAction(ActionName: Text)
    var
        applicationId: Text;
        ActionOption: Option acquireApp;
    begin
        if Evaluate(ActionOption,ActionName) then
          case ActionOption of
            Actionoption::acquireApp:
              begin
                TelemetryUrl := ExtensionMarketplaceMgmt.GetTelementryUrlFromData(JObject);
                applicationId := ExtensionMarketplaceMgmt.GetApplicationIdFromData(JObject);
                if not InstallExtension(applicationId) then
                  Message(GetLastErrorText);
              end;
          end;
    end;

    [TryFunction]
    local procedure InstallExtension(ApplicationID: Text)
    var
        NavAppTable: Record "NAV App";
        NavExtensionInstallationMgmt: Codeunit "Extension Installation Impl";
        ExtensionInstallation: Page "Extension Installation";
        ID: Guid;
        ExtensionNotFound: Boolean;
    begin
        ID := ExtensionMarketplaceMgmt.MapMarketplaceIdToPackageId(ApplicationID);
        NavAppTable.SetFilter("Package ID",'%1',ID);
        ExtensionNotFound := not NavAppTable.FindFirst;
        if ExtensionNotFound then begin
          ID := ExtensionMarketplaceMgmt.MapMarketplaceIdToAppId(ApplicationID);
          NavAppTable.SetFilter("Package ID",'%1',NavExtensionInstallationMgmt.GetLatestVersionPackageId(ID));
          ExtensionNotFound := not NavAppTable.FindFirst;
        end;

        if not ExtensionNotFound then begin
          NavAppTable.responseUrl := TelemetryUrl;
          ExtensionInstallation.SetRecord(NavAppTable);
          if ExtensionInstallation.RunModal = Action::OK then
            exit;
          NavAppTable.Reset;
          ExtensionInstallation.GetRecord(NavAppTable);
          if not NavExtensionInstallationMgmt.IsInstalled(NavAppTable."Package ID") then
            Error(ExtensionInstallationFailureErr);
        end else begin
          MakeTelemetryCallback(Operationresult::DeploymentFailedDueToPackage,NavAppTable."Package ID");
          Error(ExtensionNotFoundErr);
        end;
    end;

    [TryFunction]
    local procedure TryGetMsgType(data: Text)
    begin
        JObject := JObject.Parse(data);
        MessageType := ExtensionMarketplaceMgmt.GetMessageType(JObject);
    end;

    local procedure MakeTelemetryCallback(Result: Option UserNotAuthorized,DeploymentFailedDueToPackage,DeploymentFailed,Successful,UserCancel,UserTimeOut;PackageId: Text)
    begin
        if TelemetryUrl <> '' then
          ExtensionMarketplaceMgmt.MakeMarketplaceTelemetryCallback(TelemetryUrl,Result,PackageId);
    end;

    trigger Jobject::PropertyChanged(sender: Variant;e: dotnet PropertyChangedEventArgs)
    begin
    end;

    trigger Jobject::PropertyChanging(sender: Variant;e: dotnet PropertyChangingEventArgs)
    begin
    end;

    trigger Jobject::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    begin
    end;

    trigger Jobject::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    begin
    end;

    trigger Jobject::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    begin
    end;
}

