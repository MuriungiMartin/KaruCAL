#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1604 "Export Serv. Inv. - PEPPOL 2.1"
{
    TableNo = "Record Export Buffer";

    trigger OnRun()
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
        RecordRef: RecordRef;
    begin
        RecordRef.Get(RecordID);
        RecordRef.SetTable(ServiceInvoiceHeader);

        ServerFilePath := GenerateXMLFile(ServiceInvoiceHeader);

        Modify;
    end;

    var
        ExportPathGreaterThan250Err: label 'The export path is longer than 250 characters.';


    procedure GenerateXMLFile(ServiceInvoiceHeader: Record "Service Invoice Header"): Text[250]
    var
        FileManagement: Codeunit "File Management";
        SalesInvoicePEPPOL: XmlPort "Sales Invoice - PEPPOL 2.1";
        OutFile: File;
        OutStream: OutStream;
        XmlServerPath: Text;
    begin
        XmlServerPath := FileManagement.ServerTempFileName('xml');

        if StrLen(XmlServerPath) > 250 then
          Error(ExportPathGreaterThan250Err);

        if not Exists(XmlServerPath) then
          OutFile.Create(XmlServerPath)
        else
          OutFile.Open(XmlServerPath);

        // Generate XML
        OutFile.CreateOutstream(OutStream);
        SalesInvoicePEPPOL.Initialize(ServiceInvoiceHeader);
        SalesInvoicePEPPOL.SetDestination(OutStream);
        SalesInvoicePEPPOL.Export;
        OutFile.Close;

        exit(CopyStr(XmlServerPath,1,250));
    end;
}

