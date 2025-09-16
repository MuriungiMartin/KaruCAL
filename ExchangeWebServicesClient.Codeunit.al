#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5320 "Exchange Web Services Client"
{

    trigger OnRun()
    begin
    end;

    var
        TempExchangeFolder: Record "Exchange Folder" temporary;
        [RunOnClient]
        ServiceOnClient: dotnet ExchangeServiceWrapper;
        Text001: label 'Connection to the Exchange server failed.';
        Text002: label 'Folders with a path that exceeds 250 characters have been omitted.';
        ServiceOnServer: dotnet ExchangeServiceWrapper;
        LongPathsDetected: Boolean;


    procedure GetPublicFolders(var ExchangeFolder: Record "Exchange Folder"): Boolean
    begin
        if not IsServiceValid then
          Error(Text001);

        if IsNull(ServiceOnServer) then
          exit(GetPublicFoldersOnClient(ExchangeFolder));
        exit(GetPublicFoldersOnServer(ExchangeFolder));
    end;

    local procedure GetPublicFoldersOnClient(var ExchangeFolder: Record "Exchange Folder") FoundAny: Boolean
    var
        [RunOnClient]
        ParentInfo: dotnet FolderInfo;
        [RunOnClient]
        SubFolders: dotnet FolderInfoEnumerator;
    begin
        if ExchangeFolder.Cached then
          exit;

        if ExchangeFolder."Unique ID".Hasvalue then begin
          ParentInfo := ParentInfo.FolderInfo(ExchangeFolder.GetUniqueID,ExchangeFolder.FullPath);
          ExchangeFolder.Cached := true;
          ExchangeFolder.Modify;
        end;

        FoundAny := false;
        LongPathsDetected := false;

        SubFolders := ServiceOnClient.GetPublicFolders(ParentInfo,1000);

        if not IsNull(SubFolders) then begin
          while SubFolders.MoveNextPage do
            while SubFolders.MoveNext do
              if StrLen(SubFolders.Current.FullPath) > 250 then
                LongPathsDetected := true
              else
                if not TempExchangeFolder.Get(SubFolders.Current.FullPath) then
                  if IsAllowedFolderType(SubFolders.Current.FolderClass) then begin
                    FoundAny := true;
                    with TempExchangeFolder do begin
                      Init;
                      FullPath := SubFolders.Current.FullPath;
                      Depth := SubFolders.Current.Depth;
                      SetUniqueID(SubFolders.Current.UniqueId);
                      Name := SubFolders.Current.Name;
                      Cached := false;
                      Insert;
                    end;
                  end;
          if LongPathsDetected then
            Message(Text002);
          ReadBuffer(ExchangeFolder);
        end;

        if IsNull(ServiceOnServer) then begin
          if ServiceOnServer.LastError <> '' then
            Message(ServiceOnServer.LastError);
        end else
          if ServiceOnServer.LastError <> '' then
            Message(ServiceOnServer.LastError);

        exit(FoundAny);
    end;

    local procedure GetPublicFoldersOnServer(var ExchangeFolder: Record "Exchange Folder") FoundAny: Boolean
    var
        ParentInfo: dotnet FolderInfo;
        SubFolders: dotnet FolderInfoEnumerator;
    begin
        if ExchangeFolder.Cached then
          exit;

        if ExchangeFolder."Unique ID".Hasvalue then begin
          ParentInfo := ParentInfo.FolderInfo(ExchangeFolder.GetUniqueID,ExchangeFolder.FullPath);
          ExchangeFolder.Cached := true;
          ExchangeFolder.Modify;
        end;

        FoundAny := false;
        LongPathsDetected := false;

        SubFolders := ServiceOnServer.GetPublicFolders(ParentInfo,1000);

        if not IsNull(SubFolders) then begin
          while SubFolders.MoveNextPage do
            while SubFolders.MoveNext do
              if StrLen(SubFolders.Current.FullPath) > 250 then
                LongPathsDetected := true
              else
                if not TempExchangeFolder.Get(SubFolders.Current.FullPath) then
                  if IsAllowedFolderType(SubFolders.Current.FolderClass) then begin
                    FoundAny := true;
                    with TempExchangeFolder do begin
                      Init;
                      FullPath := SubFolders.Current.FullPath;
                      Depth := SubFolders.Current.Depth;
                      SetUniqueID(SubFolders.Current.UniqueId);
                      Name := SubFolders.Current.Name;
                      Cached := false;
                      Insert;
                    end;
                  end;
          if LongPathsDetected then
            Message(Text002);
          ReadBuffer(ExchangeFolder);
        end;

        if IsNull(ServiceOnServer) then begin
          if ServiceOnServer.LastError <> '' then
            Message(ServiceOnServer.LastError);
        end else
          if ServiceOnServer.LastError <> '' then
            Message(ServiceOnServer.LastError);

        exit(FoundAny);
    end;


    procedure InitializeOnClient(AutodiscoveryEmail: Text[250];ServiceUri: Text): Boolean
    var
        [RunOnClient]
        ServiceFactoryOnClient: dotnet ServiceWrapperFactory;
    begin
        if IsNull(ServiceOnClient) then begin
          InvalidateService;
          ServiceOnClient := ServiceFactoryOnClient.CreateServiceWrapper;
        end;

        if ServiceUri <> '' then
          ServiceOnClient.ExchangeServiceUrl := ServiceUri;

        if ServiceOnClient.ExchangeServiceUrl = '' then
          exit(ServiceOnClient.AutodiscoverServiceUrl(AutodiscoveryEmail));
        exit(true);
    end;


    procedure InitializeOnServer(AutodiscoveryEmail: Text[250];ServiceUri: Text;Credentials: dotnet NetworkCredential): Boolean
    var
        ServiceFactoryOnServer: dotnet ServiceWrapperFactory;
    begin
        if IsNull(ServiceOnServer) then begin
          InvalidateService;
          ServiceOnServer := ServiceFactoryOnServer.CreateServiceWrapperWithCredentials(Credentials);
        end;

        if ServiceUri <> '' then
          ServiceOnServer.ExchangeServiceUrl := ServiceUri;

        if ServiceOnServer.ExchangeServiceUrl = '' then
          exit(ServiceOnServer.AutodiscoverServiceUrl(AutodiscoveryEmail));
        exit(true);
    end;


    procedure FolderExists(UniqueID: Text): Boolean
    begin
        if not IsServiceValid then
          Error(Text001);
        if IsNull(ServiceOnServer) then
          exit(ServiceOnClient.FolderExists(UniqueID));
        exit(ServiceOnServer.FolderExists(UniqueID));
    end;


    procedure ReadBuffer(var DestExchangeFolder: Record "Exchange Folder"): Boolean
    begin
        if TempExchangeFolder.FindSet then
          repeat
            if not DestExchangeFolder.Get(TempExchangeFolder.FullPath) then begin
              TempExchangeFolder.CalcFields("Unique ID");
              DestExchangeFolder.Init;
              DestExchangeFolder.TransferFields(TempExchangeFolder);
              DestExchangeFolder.Insert;
            end;
          until TempExchangeFolder.Next = 0
        else
          exit(false);
        exit(true);
    end;

    local procedure IsAllowedFolderType(FolderClass: Text): Boolean
    begin
        if FolderClass = '' then
          exit(true);

        if FolderClass = 'IPF.Note' then
          exit(true);

        exit(false);
    end;

    local procedure IsServiceValid(): Boolean
    begin
        if IsNull(ServiceOnServer) and IsNull(ServiceOnClient) then
          exit(false);

        if IsNull(ServiceOnServer) then
          exit(ServiceOnClient.ExchangeServiceUrl <> '');
        exit(ServiceOnServer.ExchangeServiceUrl <> '');
    end;


    procedure InvalidateService()
    begin
        Clear(ServiceOnClient);
        Clear(ServiceOnServer);
    end;


    procedure ValidateCredentialsOnServer(): Boolean
    begin
        exit(ServiceOnServer.ValidateCredentials);
    end;


    procedure ValidateCredentialsOnClient(): Boolean
    begin
        exit(ServiceOnClient.ValidateCredentials);
    end;
}

