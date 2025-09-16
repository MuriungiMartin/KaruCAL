#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1633 "Office Host Provider"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        TempOfficeAddinContextInternal: Record "Office Add-in Context" temporary;
        TempExchangeObjectInternal: Record "Exchange Object" temporary;
        [RunOnClient]
        OfficeHost: dotnet OfficeHost;
        IsHostInitialized: Boolean;

    local procedure CanHandle(): Boolean
    var
        OfficeAddinSetup: Record "Office Add-in Setup";
    begin
        if OfficeAddinSetup.Get then
          exit(OfficeAddinSetup."Office Host Codeunit ID" = Codeunit::"Office Host Provider");

        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnInitializeHost', '', false, false)]
    local procedure OnInitializeHost(NewOfficeHost: dotnet OfficeHost;NewHostType: Text)
    begin
        if not CanHandle then
          exit;

        OfficeHost := NewOfficeHost;
        IsHostInitialized := not IsNull(OfficeHost);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnInitializeContext', '', false, false)]
    local procedure OnInitializeContext(TempNewOfficeAddinContext: Record "Office Add-in Context" temporary)
    begin
        if not CanHandle then
          exit;

        TempOfficeAddinContextInternal := TempNewOfficeAddinContext;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnInitializeExchangeObject', '', false, false)]
    local procedure OnInitializeExchangeObject()
    begin
        if not CanHandle then
          exit;

        TempExchangeObjectInternal.DeleteAll;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnGetHostType', '', false, false)]
    local procedure OnGetHostType(var HostType: Text)
    begin
        if not CanHandle then
          exit;
        if not IsHostInitialized then
          exit;

        HostType := OfficeHost.HostType;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnCloseCurrentPage', '', false, false)]
    local procedure OnCloseCurrentPage()
    begin
        if not CanHandle then
          exit;

        Error('');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnInvokeExtension', '', false, false)]
    local procedure OnInvokeExtension(FunctionName: Text;Parameter1: Variant;Parameter2: Variant;Parameter3: Variant)
    begin
        if not CanHandle then
          exit;

        OfficeHost := OfficeHost.Create;
        OfficeHost.InvokeExtensionAsync(FunctionName,Parameter1,Parameter2,Parameter3);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnIsHostInitialized', '', false, false)]
    local procedure OnIsHostInitialized(var Result: Boolean)
    begin
        if not CanHandle then
          exit;

        Result := IsHostInitialized;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnIsAvailable', '', false, false)]
    local procedure OnIsAvailable(var Result: Boolean)
    begin
        if not CanHandle then
          exit;

        OnIsHostInitialized(Result);
        if Result then
          Result := OfficeHost.IsAvailable;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnGetTempOfficeAddinContext', '', false, false)]
    local procedure OnGetTempOfficeAddinContext(var TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    begin
        if not CanHandle then
          exit;

        Clear(TempOfficeAddinContext);
        TempOfficeAddinContext.Copy(TempOfficeAddinContextInternal);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnSendToOCR', '', false, false)]
    local procedure OnSendToOCR(IncomingDocument: Record "Incoming Document")
    begin
        if not CanHandle then
          exit;

        IncomingDocument.SendToOCR(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnEmailHasAttachments', '', false, false)]
    local procedure OnEmailHasAttachments(var Result: Boolean)
    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
    begin
        if not CanHandle then
          exit;

        if OfficeHost.CallbackToken <> '' then
          with ExchangeWebServicesServer do begin
            InitializeWithOAuthToken(OfficeHost.CallbackToken,GetEndpoint);
            Result := EmailHasAttachments(TempOfficeAddinContextInternal."Item ID");
          end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnGetEmailAndAttachments', '', false, false)]
    local procedure OnGetEmailAndAttachments(var TempExchangeObject: Record "Exchange Object" temporary;"Action": Option InitiateSendToOCR,InitiateSendToIncomingDocuments,InitiateSendToWorkFlow;VendorNumber: Code[20])
    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
    begin
        if not CanHandle then
          exit;

        if not TempExchangeObjectInternal.IsEmpty then begin
          Clear(TempExchangeObject);
          TempExchangeObjectInternal.ModifyAll(InitiatedAction,Action);
          TempExchangeObjectInternal.ModifyAll(VendorNo,VendorNumber);
          TempExchangeObject.Copy(TempExchangeObjectInternal,true)
        end else
          if OfficeHost.CallbackToken <> '' then
            with ExchangeWebServicesServer do begin
              InitializeWithOAuthToken(OfficeHost.CallbackToken,GetEndpoint);
              GetEmailAndAttachments(TempOfficeAddinContextInternal."Item ID",TempExchangeObject,Action,VendorNumber);
              TempExchangeObjectInternal.Copy(TempExchangeObject,true);
            end;
    end;
}

