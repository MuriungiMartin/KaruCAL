#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1631 "Office Host Management"
{

    trigger OnRun()
    begin
    end;

    var
        OfficeHostNotInitializedErr: label 'The Office host has not been initialized.';


    procedure InitializeHost(NewOfficeHost: dotnet OfficeHost;NewHostType: Text)
    begin
        OnInitializeHost(NewOfficeHost,NewHostType);
    end;


    procedure InitializeContext(TempNewOfficeAddinContext: Record "Office Add-in Context" temporary)
    begin
        CheckHost;
        OnInitializeContext(TempNewOfficeAddinContext);
    end;


    procedure InitializeExchangeObject()
    begin
        CheckHost;
        OnInitializeExchangeObject;
    end;


    procedure GetHostType(): Text
    var
        HostType: Text;
    begin
        CheckHost;
        OnGetHostType(HostType);
        exit(HostType);
    end;


    procedure CloseCurrentPage()
    begin
        OnCloseCurrentPage;
    end;


    procedure InvokeExtension(FunctionName: Text;Parameter1: Variant;Parameter2: Variant;Parameter3: Variant)
    begin
        CheckHost;
        OnInvokeExtension(FunctionName,Parameter1,Parameter2,Parameter3);
    end;


    procedure IsAvailable(): Boolean
    var
        Result: Boolean;
    begin
        OnIsAvailable(Result);
        exit(Result);
    end;


    procedure GetTempOfficeAddinContext(var TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    begin
        OnGetTempOfficeAddinContext(TempOfficeAddinContext);
    end;


    procedure SendToOCR(IncomingDocument: Record "Incoming Document")
    begin
        OnSendToOCR(IncomingDocument);
    end;


    procedure EmailHasAttachments(): Boolean
    var
        Result: Boolean;
    begin
        OnEmailHasAttachments(Result);
        exit(Result);
    end;


    procedure GetEmailAndAttachments(var TempExchangeObject: Record "Exchange Object" temporary;"Action": Option InitiateSendToOCR,InitiateSendToIncomingDocuments,InitiateSendToWorkFlow;VendorNumber: Code[20])
    begin
        OnGetEmailAndAttachments(TempExchangeObject,Action,VendorNumber);
    end;


    procedure CheckHost()
    var
        Result: Boolean;
    begin
        OnIsHostInitialized(Result);
        if not Result then
          Error(OfficeHostNotInitializedErr);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInitializeHost(NewOfficeHost: dotnet OfficeHost;NewHostType: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInitializeContext(TempNewOfficeAddinContext: Record "Office Add-in Context" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInitializeExchangeObject()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetHostType(var HostType: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCloseCurrentPage()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInvokeExtension(FunctionName: Text;Parameter1: Variant;Parameter2: Variant;Parameter3: Variant)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnIsHostInitialized(var Result: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnIsAvailable(var Result: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetTempOfficeAddinContext(var TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSendToOCR(IncomingDocument: Record "Incoming Document")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnEmailHasAttachments(var Result: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetEmailAndAttachments(var TempExchangeObject: Record "Exchange Object" temporary;"Action": Option InitiateSendToOCR,InitiateSendToIncomingDocuments,InitiateSendToWorkFlow;VendorNumber: Code[20])
    begin
    end;
}

