#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1630 "Office Management"
{

    trigger OnRun()
    begin
    end;

    var
        AddinDeploymentHelper: Codeunit "Add-in Deployment Helper";
        OfficeHostType: dotnet OfficeHostType;
        UploadSuccessMsg: label 'Sent %1 document(s) to the OCR service successfully.', Comment='%1=number of documents';
        CodeUnitNotFoundErr: label 'Cannot find the object that handles integration with Office.';


    procedure InitializeHost(NewOfficeHost: dotnet OfficeHost;NewHostType: Text)
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.InitializeHost(NewOfficeHost,NewHostType);
    end;


    procedure InitializeContext(TempNewOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.InitializeContext(TempNewOfficeAddinContext);
        OfficeHostManagement.InitializeExchangeObject;
        if AddinDeploymentHelper.CheckVersion(GetHostType,TempNewOfficeAddinContext.Version) then
          HandleRedirection(TempNewOfficeAddinContext);
    end;

    local procedure HandleRedirection(TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        HandlerCodeunitID: Integer;
    begin
        HandlerCodeunitID := GetHandlerCodeunit(TempOfficeAddinContext);
        Codeunit.Run(HandlerCodeunitID,TempOfficeAddinContext);
    end;


    procedure AddRecipient(Name: Text[50];Email: Text[80])
    begin
        InvokeExtension('addRecipient',Name,Email,'');
    end;


    procedure AttachAvailable(): Boolean
    var
        OfficeAddinContext: Record "Office Add-in Context";
    begin
        GetContext(OfficeAddinContext);
        if IsAvailable and not OfficeAddinContext.IsAppointment then
          exit(GetHostType in [OfficeHostType.OutlookItemRead,
                               OfficeHostType.OutlookItemEdit,
                               OfficeHostType.OutlookHyperlink,
                               OfficeHostType.OutlookTaskPane]);
    end;


    procedure AttachDocument(ServerFilePath: Text;FileName: Text;BodyText: Text)
    var
        OfficeAttachmentManager: Codeunit "Office Attachment Manager";
        FileUrl: Text;
    begin
        FileUrl := GetAuthenticatedUrl(ServerFilePath);
        with OfficeAttachmentManager do begin
          Add(FileUrl,FileName,BodyText);
          if Ready then begin
            Commit;
            InvokeExtension('sendAttachment',GetUrl,GetName,GetBody);
            Done;
          end;
        end;
    end;


    procedure CurrPageCloseWorkaround()
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.CloseCurrentPage;
    end;


    procedure GetContact(var Contact: Record Contact;LinkToNo: Code[20]): Boolean
    var
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        if IsAvailable then begin
          GetContext(TempOfficeAddinContext);
          Contact.SetCurrentkey("E-Mail");
          Contact.SetRange("E-Mail",TempOfficeAddinContext.Email);
          if (Contact.Count > 1) and (LinkToNo <> '') then begin
            ContactBusinessRelation.SetRange("No.",LinkToNo);
            if ContactBusinessRelation.FindSet then
              repeat
                Contact.SetRange("Company No.",ContactBusinessRelation."Contact No.");
              until (ContactBusinessRelation.Next = 0) or Contact.FindFirst;
          end;
          exit(Contact.FindFirst);
        end;
    end;


    procedure GetContext(var TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.GetTempOfficeAddinContext(TempOfficeAddinContext);
    end;


    procedure InitiateSendToOCR(VendorNumber: Code[20])
    var
        TempExchangeObject: Record "Exchange Object" temporary;
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.GetEmailAndAttachments(TempExchangeObject,
          TempExchangeObject.Initiatedaction::InitiateSendToOCR,VendorNumber);
        TempExchangeObject.SetRange(Type,TempExchangeObject.Type::Attachment);
        TempExchangeObject.SetFilter("Content Type",'application/pdf|image/*');
        TempExchangeObject.SetRange(IsInline,false);
        if not TempExchangeObject.IsEmpty then
          Page.Run(Page::"Office OCR Incoming Documents",TempExchangeObject);
    end;


    procedure InitiateSendToIncomingDocumentsWithPurchaseHeaderLink(PurchaseHeader: Record "Purchase Header";VendorNumber: Code[20])
    var
        TempExchangeObject: Record "Exchange Object" temporary;
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        OfficeHostManagement: Codeunit "Office Host Management";
        OfficeOCRIncomingDocuments: Page "Office OCR Incoming Documents";
    begin
        OfficeHostManagement.GetEmailAndAttachments(TempExchangeObject,
          TempExchangeObject.Initiatedaction::InitiateSendToIncomingDocuments,VendorNumber);
        TempExchangeObject.SetRange(Type,TempExchangeObject.Type::Attachment);
        TempExchangeObject.SetFilter("Content Type",'application/pdf|image/*');
        TempExchangeObject.SetRange(IsInline,false);
        if not TempExchangeObject.IsEmpty then begin
          IncomingDocumentAttachment.Init;
          IncomingDocumentAttachment."Incoming Document Entry No." := PurchaseHeader."Incoming Document Entry No.";
          IncomingDocumentAttachment."Document Table No. Filter" := Database::"Purchase Header";
          IncomingDocumentAttachment."Document Type Filter" := PurchaseHeader."Document Type";
          IncomingDocumentAttachment."Document No. Filter" := PurchaseHeader."No.";
          OfficeOCRIncomingDocuments.InitializeIncomingDocumentAttachment(IncomingDocumentAttachment);
          OfficeOCRIncomingDocuments.InitializeExchangeObject(TempExchangeObject);
          OfficeOCRIncomingDocuments.Run;
        end;
    end;


    procedure InitiateSendToIncomingDocuments(VendorNumber: Code[20])
    var
        TempExchangeObject: Record "Exchange Object" temporary;
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.GetEmailAndAttachments(TempExchangeObject,
          TempExchangeObject.Initiatedaction::InitiateSendToIncomingDocuments,VendorNumber);
        TempExchangeObject.SetRange(Type,TempExchangeObject.Type::Attachment);
        TempExchangeObject.SetFilter("Content Type",'application/pdf|image/*');
        TempExchangeObject.SetRange(IsInline,false);
        if not TempExchangeObject.IsEmpty then
          Page.Run(Page::"Office OCR Incoming Documents",TempExchangeObject);
    end;


    procedure InitiateSendApprovalRequest(VendorNumber: Code[20])
    var
        TempExchangeObject: Record "Exchange Object" temporary;
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.GetEmailAndAttachments(TempExchangeObject,
          TempExchangeObject.Initiatedaction::InitiateSendToWorkFlow,VendorNumber);
        TempExchangeObject.SetRange(Type,TempExchangeObject.Type::Attachment);
        TempExchangeObject.SetFilter("Content Type",'application/pdf|image/*');
        TempExchangeObject.SetRange(IsInline,false);
        if not TempExchangeObject.IsEmpty then
          Page.Run(Page::"Office OCR Incoming Documents",TempExchangeObject);
    end;


    procedure IsAvailable(): Boolean
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        exit(OfficeHostManagement.IsAvailable);
    end;

    local procedure GetAuthenticatedUrl(ServerFilePath: Text) FileUrl: Text
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        DocStream: InStream;
        MediaId: Guid;
    begin
        FileMgt.BLOBImportFromServerFile(TempBlob,ServerFilePath);
        TempBlob.Blob.CreateInstream(DocStream);
        MediaId := IMPORTSTREAMWITHURLACCESS(DocStream,FileMgt.GetFileName(ServerFilePath));
        FileUrl := GetDocumentUrl(MediaId);
    end;

    local procedure GetHandlerCodeunit(OfficeAddinContext: Record "Office Add-in Context"): Integer
    var
        OfficeJobsHandler: Codeunit "Office Jobs Handler";
    begin
        if OfficeJobsHandler.IsJobsHostType(OfficeAddinContext) then
          exit(Codeunit::"Office Jobs Handler");

        case GetHostType of
          OfficeHostType.OutlookItemRead,OfficeHostType.OutlookItemEdit,OfficeHostType.OutlookTaskPane,OfficeHostType.OutlookMobileApp:
            exit(Codeunit::"Office Contact Handler");
          OfficeHostType.OutlookHyperlink:
            exit(Codeunit::"Office Document Handler");
        end;

        Error(CodeUnitNotFoundErr);
    end;

    local procedure GetHostType(): Text
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        exit(OfficeHostManagement.GetHostType);
    end;

    local procedure InvokeExtension(FunctionName: Text;Parameter1: Variant;Parameter2: Variant;Parameter3: Variant)
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.InvokeExtension(FunctionName,Parameter1,Parameter2,Parameter3);
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnDeleteContact(var Rec: Record Contact;RunTrigger: Boolean)
    var
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;
    begin
        // User has deleted the contact that was just created. Prevent user seeing a blank screen.
        if IsAvailable then begin
          GetContext(TempOfficeAddinContext);
          if (Rec."E-Mail" = TempOfficeAddinContext.Email) and (Rec.Type = Rec.Type::Person) and (not Rec.Find) then
            Page.Run(Page::"Office New Contact Dlg")
        end;
    end;


    procedure SendToOCR(var IncomingDocument: Record "Incoming Document")
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        OfficeHostManagement.SendToOCR(IncomingDocument);
    end;


    procedure SendApprovalRequest(var IncomingDocument: Record "Incoming Document")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        IncomingDocument.TestReadyForApproval;
        if ApprovalsMgmt.CheckIncomingDocApprovalsWorkflowEnabled(IncomingDocument) then
          ApprovalsMgmt.OnSendIncomingDocForApproval(IncomingDocument);
    end;


    procedure SendToIncomingDocument(var TempExchangeObject: Record "Exchange Object" temporary;var IncomingDocument: Record "Incoming Document";var IncomingDocAttachment: Record "Incoming Document Attachment"): Boolean
    var
        Vendor: Record Vendor;
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        PurchaseHeader: Record "Purchase Header";
        ImportAttachmentIncDoc: Codeunit "Import Attachment - Inc. Doc.";
        InStream: InStream;
        OutStream: OutStream;
    begin
        if TempExchangeObject.Type = TempExchangeObject.Type::Attachment then begin
          TempExchangeObject.CalcFields(Content);
          TempExchangeObject.Content.CreateInstream(InStream);

          IncomingDocumentAttachment.Init;
          IncomingDocumentAttachment.Content.CreateOutstream(OutStream);
          CopyStream(OutStream,InStream);
          ImportAttachmentIncDoc.ImportAttachment(IncomingDocumentAttachment,TempExchangeObject.Name);
          IncomingDocumentAttachment.Validate("Document Table No. Filter",IncomingDocAttachment."Document Table No. Filter");
          IncomingDocumentAttachment.Validate("Document Type Filter",IncomingDocAttachment."Document Type Filter");
          IncomingDocumentAttachment.Validate("Document No. Filter",IncomingDocAttachment."Document No. Filter");
          IncomingDocumentAttachment.Modify;

          if PurchaseHeader.Get(PurchaseHeader."document type"::Invoice,IncomingDocumentAttachment."Document No. Filter") then begin
            PurchaseHeader.Validate("Incoming Document Entry No.",IncomingDocumentAttachment."Incoming Document Entry No.");
            PurchaseHeader.Modify;
          end;

          IncomingDocument.SetRange("Entry No.",IncomingDocumentAttachment."Incoming Document Entry No.");
          if IncomingDocument.FindFirst then begin
            Vendor.SetRange("No.",TempExchangeObject.VendorNo);
            if Vendor.FindFirst then begin
              IncomingDocument.Validate("Vendor Name",Vendor.Name);
              IncomingDocument.Modify;
              exit(true);
            end;
          end;
          exit(false);
        end;
    end;


    procedure EmailHasAttachments(): Boolean
    var
        OfficeHostManagement: Codeunit "Office Host Management";
    begin
        if OCRAvailable then
          exit(OfficeHostManagement.EmailHasAttachments);
    end;


    procedure CheckForExistingInvoice(CustNo: Code[20]): Boolean
    var
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;
        OfficeInvoice: Record "Office Invoice";
    begin
        if IsAvailable then begin
          GetContext(TempOfficeAddinContext);
          OfficeInvoice.SetRange("Item ID",TempOfficeAddinContext."Item ID");
          if not OfficeInvoice.IsEmpty then begin
            OfficeInvoice.SetCustomer(CustNo);
            Page.Run(Page::"Office Invoice Selection",OfficeInvoice);
            exit(true);
          end;
        end;
    end;


    procedure DisplayOCRUploadSuccessMessage(UploadedDocumentCount: Integer)
    begin
        Message(StrSubstNo(UploadSuccessMsg,UploadedDocumentCount));
    end;


    procedure OCRAvailable(): Boolean
    begin
        if IsAvailable then
          exit(not (GetHostType in [OfficeHostType.OutlookPopOut,
                                    OfficeHostType.OutlookMobileApp]));
    end;


    procedure IsOutlookMobileApp(): Boolean
    begin
        if IsAvailable then
          exit(GetHostType = OfficeHostType.OutlookMobileApp);
    end;
}

