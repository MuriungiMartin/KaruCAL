#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10147 "E-Invoice Object Factory"
{

    trigger OnRun()
    begin
    end;


    procedure GetSignatureProvider(var ISignatureProvider: dotnet ISignatureProvider)
    var
        CFDISignatureProvider: dotnet CFDISignatureProvider;
    begin
        if IsNull(ISignatureProvider) then
          ISignatureProvider := CFDISignatureProvider.CFDISignatureProvider;
    end;


    procedure GetWebServiceInvoker(var IWebServiceInvoker: dotnet IWebServiceInvoker)
    var
        SOAPWebServiceInvoker: dotnet SOAPWebServiceInvoker;
    begin
        if IsNull(IWebServiceInvoker) then
          IWebServiceInvoker := SOAPWebServiceInvoker.SOAPWebServiceInvoker;
    end;


    procedure GetBarCodeProvider(var IBarCodeProvider: dotnet IBarcodeProvider)
    var
        QRCodeProvider: dotnet QRCodeProvider;
    begin
        if IsNull(IBarCodeProvider) then
          IBarCodeProvider := QRCodeProvider.QRCodeProvider;
    end;
}

