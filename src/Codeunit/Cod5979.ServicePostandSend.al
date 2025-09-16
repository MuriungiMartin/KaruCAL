#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5979 "Service-Post and Send"
{
    TableNo = "Service Header";

    trigger OnRun()
    begin
        ServiceHeader.Copy(Rec);
        Code;
        Rec := ServiceHeader;
    end;

    var
        ServiceHeader: Record "Service Header";
        NotSupportedDocumentTypeErr: label 'Document type %1 is not supported.', Comment='%1=Document Type e.g. Invoice';

    local procedure "Code"()
    var
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
        ServicePost: Codeunit "Service-Post";
    begin
        with ServiceHeader do
          case "Document Type" of
            "document type"::Invoice,
            "document type"::"Credit Memo":
              if not ConfirmPostAndSend(ServiceHeader,TempDocumentSendingProfile) then
                exit;
            else
              Error(StrSubstNo(NotSupportedDocumentTypeErr,"Document Type"));
          end;

        ValidateElectronicFormats(TempDocumentSendingProfile);

        Codeunit.Run(Codeunit::"Service-Post",ServiceHeader);
        Commit;

        ServicePost.SendPostedDocumentRecord(ServiceHeader,TempDocumentSendingProfile);
    end;

    local procedure ConfirmPostAndSend(ServiceHeader: Record "Service Header";var TempDocumentSendingProfile: Record "Document Sending Profile" temporary): Boolean
    var
        Customer: Record Customer;
        DocumentSendingProfile: Record "Document Sending Profile";
    begin
        Customer.Get(ServiceHeader."Bill-to Customer No.");
        if not DocumentSendingProfile.Get(Customer."Document Sending Profile") then
          DocumentSendingProfile.GetDefault(DocumentSendingProfile);

        Commit;
        TempDocumentSendingProfile.Copy(DocumentSendingProfile);
        TempDocumentSendingProfile.SetDocumentUsage(ServiceHeader);
        TempDocumentSendingProfile.Insert;
        if Page.RunModal(Page::"Post and Send Confirmation",TempDocumentSendingProfile) <> Action::Yes then
          exit(false);

        exit(true);
    end;

    local procedure ValidateElectronicFormats(DocumentSendingProfile: Record "Document Sending Profile")
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        DocExchServiceMgt: Codeunit "Doc. Exch. Service Mgt.";
    begin
        if (DocumentSendingProfile."E-Mail" <> DocumentSendingProfile."e-mail"::No) and
           (DocumentSendingProfile."E-Mail Attachment" <> DocumentSendingProfile."e-mail attachment"::Pdf)
        then begin
          ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."E-Mail Format");
          ElectronicDocumentFormat.ValidateElectronicServiceDocument(ServiceHeader,DocumentSendingProfile."E-Mail Format");
        end;

        if (DocumentSendingProfile.Disk <> DocumentSendingProfile.Disk::No) and
           (DocumentSendingProfile.Disk <> DocumentSendingProfile.Disk::Pdf)
        then begin
          ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."Disk Format");
          ElectronicDocumentFormat.ValidateElectronicServiceDocument(ServiceHeader,DocumentSendingProfile."Disk Format");
        end;

        if DocumentSendingProfile."Electronic Document" <> DocumentSendingProfile."electronic document"::No then begin
          DocExchServiceMgt.CheckServiceEnabled;
          ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."Electronic Format");
          ElectronicDocumentFormat.ValidateElectronicServiceDocument(ServiceHeader,DocumentSendingProfile."Electronic Format");
        end;
    end;
}

