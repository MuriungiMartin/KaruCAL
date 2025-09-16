#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 452 "Report Distribution Management"
{

    trigger OnRun()
    begin
    end;

    var
        HideDialog: Boolean;


    procedure VANDocumentReport(HeaderDoc: Variant;TempDocumentSendingProfile: Record "Document Sending Profile" temporary)
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        DocExchServiceMgt: Codeunit "Doc. Exch. Service Mgt.";
        RecordRef: RecordRef;
        SpecificRecordRef: RecordRef;
        XMLPath: Text[250];
        ClientFileName: Text[250];
    begin
        RecordRef.GetTable(HeaderDoc);
        if RecordRef.FindSet then
          repeat
            SpecificRecordRef.Get(RecordRef.RecordId);
            SpecificRecordRef.SetRecfilter;
            ElectronicDocumentFormat.SendElectronically(
              XMLPath,ClientFileName,SpecificRecordRef,TempDocumentSendingProfile."Electronic Format");
            DocExchServiceMgt.SendDocument(SpecificRecordRef,XMLPath);
          until RecordRef.Next = 0;
    end;


    procedure DownloadPdfOnClient(ServerPdfFilePath: Text): Text
    var
        FileManagement: Codeunit "File Management";
        ClientPdfFilePath: Text;
    begin
        ClientPdfFilePath := FileManagement.DownloadTempFile(ServerPdfFilePath);
        Erase(ServerPdfFilePath);
        exit(ClientPdfFilePath);
    end;


    procedure InitializeFrom(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure GetDocumentType(DocumentVariant: Variant): Text[50]
    var
        DummySalesHeader: Record "Sales Header";
        DummyServiceHeader: Record "Service Header";
        DummyPurchaseHeader: Record "Purchase Header";
        DocumentRecordRef: RecordRef;
    begin
        DocumentRecordRef.GetTable(DocumentVariant);
        case DocumentRecordRef.Number of
          Database::"Sales Invoice Header":
            exit(Format(DummySalesHeader."document type"::Invoice));
          Database::"Sales Cr.Memo Header":
            exit(Format(DummySalesHeader."document type"::"Credit Memo"));
          Database::"Service Invoice Header":
            exit(Format(DummyServiceHeader."document type"::Invoice));
          Database::"Service Cr.Memo Header":
            exit(Format(DummyServiceHeader."document type"::"Credit Memo"));
          Database::"Purchase Header":
            exit(Format(DummyPurchaseHeader."document type"::Order));
          Database::"Service Header":
            begin
              DummyServiceHeader := DocumentVariant;
              if DummyServiceHeader."Document Type" = DummyServiceHeader."document type"::Quote then
                exit(Format(DummyServiceHeader."document type"::Quote));
            end;
          Database::"Sales Header":
            begin
              DummySalesHeader := DocumentVariant;
              if DummySalesHeader."Document Type" = DummySalesHeader."document type"::Quote then
                exit(Format(DummySalesHeader."document type"::Quote));
            end;
        end;
    end;

    local procedure GetBillToCustomer(var Customer: Record Customer;DocumentVariant: Variant)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesHeader: Record "Sales Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        ServiceHeader: Record "Service Header";
        Job: Record Job;
        DocumentRecordRef: RecordRef;
    begin
        DocumentRecordRef.GetTable(DocumentVariant);
        case DocumentRecordRef.Number of
          Database::"Sales Invoice Header":
            begin
              SalesInvoiceHeader := DocumentVariant;
              Customer.Get(SalesInvoiceHeader."Bill-to Customer No.");
            end;
          Database::"Sales Cr.Memo Header":
            begin
              SalesCrMemoHeader := DocumentVariant;
              Customer.Get(SalesCrMemoHeader."Bill-to Customer No.");
            end;
          Database::"Service Invoice Header":
            begin
              ServiceInvoiceHeader := DocumentVariant;
              Customer.Get(ServiceInvoiceHeader."Bill-to Customer No.");
            end;
          Database::"Service Cr.Memo Header":
            begin
              ServiceCrMemoHeader := DocumentVariant;
              Customer.Get(ServiceCrMemoHeader."Bill-to Customer No.");
            end;
          Database::"Service Header":
            begin
              ServiceHeader := DocumentVariant;
              Customer.Get(ServiceHeader."Bill-to Customer No.");
            end;
          Database::"Sales Header":
            begin
              SalesHeader := DocumentVariant;
              Customer.Get(SalesHeader."Bill-to Customer No.");
            end;
          Database::Job:
            begin
              Job := DocumentVariant;
              Customer.Get(Job."Bill-to Customer No.");
            end;
        end;
    end;

    local procedure GetBuyFromVendor(var Vendor: Record Vendor;DocumentVariant: Variant)
    var
        PurchaseHeader: Record "Purchase Header";
        DocumentRecordRef: RecordRef;
    begin
        DocumentRecordRef.GetTable(DocumentVariant);
        case DocumentRecordRef.Number of
          Database::"Purchase Header":
            begin
              PurchaseHeader := DocumentVariant;
              Vendor.Get(PurchaseHeader."Buy-from Vendor No.");
            end;
        end;
    end;


    procedure SaveFileOnClient(ServerFilePath: Text;ClientFileName: Text)
    var
        FileManagement: Codeunit "File Management";
    begin
        FileManagement.DownloadHandler(
          ServerFilePath,
          '',
          '',
          FileManagement.GetToFilterText('',ClientFileName),
          ClientFileName);
    end;

    local procedure SendAttachment(PostedDocumentNo: Code[20];SendEmailAddress: Text[250];AttachmentFilePath: Text[250];AttachmentFileName: Text[250];DocumentType: Text[50];SendTo: Option;ServerEmailBodyFilePath: Text[250];ReportUsage: Integer)
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DocumentMailing: Codeunit "Document-Mailing";
    begin
        if SendTo = DocumentSendingProfile."send to"::Disk then begin
          SaveFileOnClient(AttachmentFilePath,AttachmentFileName);
          exit;
        end;

        DocumentMailing.EmailFile(
          AttachmentFilePath,AttachmentFileName,ServerEmailBodyFilePath,PostedDocumentNo,
          SendEmailAddress,DocumentType,HideDialog,ReportUsage);
    end;


    procedure SendXmlEmailAttachment(DocumentVariant: Variant;DocumentFormat: Code[20];ServerEmailBodyFilePath: Text[250];SendToEmailAddress: Text[250])
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        Customer: Record Customer;
        DocumentSendingProfile: Record "Document Sending Profile";
        ReportSelections: Record "Report Selections";
        DocumentMailing: Codeunit "Document-Mailing";
        XMLPath: Text[250];
        ClientFileName: Text[250];
        ReportUsage: Integer;
    begin
        GetBillToCustomer(Customer,DocumentVariant);

        if SendToEmailAddress = '' then
          SendToEmailAddress := DocumentMailing.GetToAddressFromCustomer(Customer."No.");

        DocumentSendingProfile.Get(Customer."Document Sending Profile");
        if DocumentSendingProfile.Usage = DocumentSendingProfile.Usage::"Job Quote" then
          ReportUsage := ReportSelections.Usage::JQ;

        ElectronicDocumentFormat.SendElectronically(XMLPath,ClientFileName,DocumentVariant,DocumentFormat);
        Commit;
        SendAttachment(
          ElectronicDocumentFormat.GetDocumentNo(DocumentVariant),
          SendToEmailAddress,
          XMLPath,
          ClientFileName,
          GetDocumentType(DocumentVariant),
          DocumentSendingProfile."send to"::"Electronic Document",
          ServerEmailBodyFilePath,ReportUsage);
    end;


    procedure SendXmlEmailAttachmentVendor(DocumentVariant: Variant;DocumentFormat: Code[20];ServerEmailBodyFilePath: Text[250];SendToEmailAddress: Text[250])
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        Vendor: Record Vendor;
        DocumentSendingProfile: Record "Document Sending Profile";
        ReportSelections: Record "Report Selections";
        DocumentMailing: Codeunit "Document-Mailing";
        XMLPath: Text[250];
        ClientFileName: Text[250];
        ReportUsage: Integer;
    begin
        GetBuyFromVendor(Vendor,DocumentVariant);

        if SendToEmailAddress = '' then
          SendToEmailAddress := DocumentMailing.GetToAddressFromVendor(Vendor."No.");

        DocumentSendingProfile.Get(Vendor."Document Sending Profile");

        if DocumentSendingProfile.Usage = DocumentSendingProfile.Usage::"Job Quote" then
          ReportUsage := ReportSelections.Usage::JQ;

        ElectronicDocumentFormat.SendElectronically(XMLPath,ClientFileName,DocumentVariant,DocumentFormat);
        Commit;
        SendAttachment(
          ElectronicDocumentFormat.GetDocumentNo(DocumentVariant),
          SendToEmailAddress,
          XMLPath,
          ClientFileName,
          GetDocumentType(DocumentVariant),
          DocumentSendingProfile."send to"::"Electronic Document",
          ServerEmailBodyFilePath,ReportUsage);
    end;


    procedure CreateOrAppendZipFile(var FileManagement: Codeunit "File Management";ServerFilePath: Text[250];ClientFileName: Text[250];var ZipPath: Text[250];var ClientZipFileName: Text[250])
    begin
        if FileManagement.IsGZip(ServerFilePath) then begin
          ZipPath := ServerFilePath;
          FileManagement.OpenZipFile(ZipPath);
          ClientZipFileName := ClientFileName;
        end else begin
          ZipPath := CopyStr(FileManagement.CreateZipArchiveObject,1,250);
          FileManagement.AddFileToZipArchive(ServerFilePath,ClientFileName);
          ClientZipFileName := CopyStr(FileManagement.GetFileNameWithoutExtension(ClientFileName) + '.zip',1,250);
        end;
    end;
}

