#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 2200 "Azure Key Vault Management"
{

    trigger OnRun()
    begin
    end;

    var
        NavAzureKeyVaultClient: dotnet MachineLearningCredentialsHelper;
        AzureKeyVaultSecretProvider: dotnet IAzureKeyVaultSecretProvider;
        ApplicationSecretsTxt: label 'ml-forecast,qbo-consumerkey,qbo-consumersecret,amcname,amcpassword,YodleeCobrandName,YodleeCobrandPassword,YodleeServiceUri', Locked=true;
        SecretNotFoundErr: label '%1 is not an application secret. Choose one of the following secrets: %2', Comment='%1 = Secret Name. %2 = Available secrets.';

    [TryFunction]

    procedure GetMachineLearningCredentials(var ApiUri: Text[250];var ApiKey: Text[200];var Limit: Decimal)
    var
        ResultArray: dotnet Array;
    begin
        NavAzureKeyVaultClient := NavAzureKeyVaultClient.MachineLearningCredentialsHelper;
        NavAzureKeyVaultClient.SetAzureKeyVaultProvider(AzureKeyVaultSecretProvider);
        ResultArray := NavAzureKeyVaultClient.GetMLCredentials;
        ApiKey := Format(ResultArray.GetValue(0));
        ApiUri := Format(ResultArray.GetValue(1));
        if not IsNull(ResultArray.GetValue(2)) then
          Evaluate(Limit,Format(ResultArray.GetValue(2)));
    end;

    [TryFunction]

    procedure GetAzureKeyVaultSecret(var Secret: Text;SecretName: Text)
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        if TypeHelper.GetOptionNo(SecretName,ApplicationSecretsTxt) = -1 then
          Error(StrSubstNo(SecretNotFoundErr,SecretName,ApplicationSecretsTxt));
        NavAzureKeyVaultClient := NavAzureKeyVaultClient.MachineLearningCredentialsHelper;
        NavAzureKeyVaultClient.SetAzureKeyVaultProvider(AzureKeyVaultSecretProvider);
        Secret := NavAzureKeyVaultClient.GetAzureKeyVaultSecret(SecretName);
    end;


    procedure SetAzureKeyVaultSecretProvider(NewAzureKeyVaultSecretProvider: dotnet IAzureKeyVaultSecretProvider)
    begin
        AzureKeyVaultSecretProvider := NewAzureKeyVaultSecretProvider;
    end;


    procedure IsEnable(): Boolean
    begin
        NavAzureKeyVaultClient := NavAzureKeyVaultClient.MachineLearningCredentialsHelper;
        exit(NavAzureKeyVaultClient.Enable);
    end;
}

