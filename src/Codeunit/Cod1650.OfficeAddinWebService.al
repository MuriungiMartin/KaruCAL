#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1650 "Office Add-in Web Service"
{

    trigger OnRun()
    begin
    end;


    procedure DeployManifests(Username: Text[80];Password: Text[30]): Boolean
    var
        AddinDeploymentHelper: Codeunit "Add-in Deployment Helper";
    begin
        SetCredentialsAndDeploy(AddinDeploymentHelper,Username,Password);
        exit(true);
    end;


    procedure DeployManifestsWithExchangeEndpoint(Username: Text[80];Password: Text[30];Endpoint: Text[250]): Boolean
    var
        AddinDeploymentHelper: Codeunit "Add-in Deployment Helper";
    begin
        AddinDeploymentHelper.SetManifestDeploymentCustomEndpoint(Endpoint);
        SetCredentialsAndDeploy(AddinDeploymentHelper,Username,Password);
        exit(true);
    end;

    local procedure SetCredentialsAndDeploy(AddinDeploymentHelper: Codeunit "Add-in Deployment Helper";Username: Text[80];Password: Text[30])
    var
        OfficeAddIn: Record "Office Add-in";
    begin
        AddinDeploymentHelper.SetManifestDeploymentCredentials(Username,Password);
        if OfficeAddIn.Find('-') then
          repeat
            AddinDeploymentHelper.DeployManifest(OfficeAddIn);
          until OfficeAddIn.Next = 0;
    end;
}

