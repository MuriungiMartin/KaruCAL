#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 79 "Sales-Post and Send"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SalesHeader.Copy(Rec);
        Code;
        Rec := SalesHeader;
    end;

    var
        SalesHeader: Record "Sales Header";
        NotSupportedDocumentTypeErr: label 'Document type %1 is not supported.', Comment='%1=Document Type';

    local procedure "Code"()
    var
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
        SalesPost: Codeunit "Sales-Post";
    begin
        with SalesHeader do
          case "Document Type" of
            "document type"::Invoice,
            "document type"::"Credit Memo",
            "document type"::Order:
              if not ConfirmPostAndSend(SalesHeader,TempDocumentSendingProfile) then
                exit;
            else
              Error(StrSubstNo(NotSupportedDocumentTypeErr,"Document Type"));
          end;

        ValidateElectronicFormats(TempDocumentSendingProfile);

        if SalesHeader."Document Type" = SalesHeader."document type"::Order then begin
          Codeunit.Run(Codeunit::"Sales-Post (Yes/No)",SalesHeader);
          if not (SalesHeader.Ship or SalesHeader.Invoice) then
            exit;
        end else
          Codeunit.Run(Codeunit::"Sales-Post",SalesHeader);

        Commit;

        SalesPost.SendPostedDocumentRecord(SalesHeader,TempDocumentSendingProfile);
    end;

    local procedure ConfirmPostAndSend(SalesHeader: Record "Sales Header";var TempDocumentSendingProfile: Record "Document Sending Profile" temporary): Boolean
    var
        Customer: Record Customer;
        DocumentSendingProfile: Record "Document Sending Profile";
        OfficeMgt: Codeunit "Office Management";
    begin
        Customer.Get(SalesHeader."Bill-to Customer No.");
        if OfficeMgt.IsAvailable then
          DocumentSendingProfile.GetOfficeAddinDefault(TempDocumentSendingProfile,OfficeMgt.AttachAvailable)
        else begin
          if not DocumentSendingProfile.Get(Customer."Document Sending Profile") then
            DocumentSendingProfile.GetDefault(DocumentSendingProfile);

          Commit;
          TempDocumentSendingProfile.Copy(DocumentSendingProfile);
          TempDocumentSendingProfile.SetDocumentUsage(SalesHeader);
          TempDocumentSendingProfile.Insert;
          if Page.RunModal(Page::"Post and Send Confirmation",TempDocumentSendingProfile) <> Action::Yes then
            exit(false);
        end;

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
          ElectronicDocumentFormat.ValidateElectronicSalesDocument(SalesHeader,DocumentSendingProfile."E-Mail Format");
        end;

        if (DocumentSendingProfile.Disk <> DocumentSendingProfile.Disk::No) and
           (DocumentSendingProfile.Disk <> DocumentSendingProfile.Disk::Pdf)
        then begin
          ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."Disk Format");
          ElectronicDocumentFormat.ValidateElectronicSalesDocument(SalesHeader,DocumentSendingProfile."Disk Format");
        end;

        if DocumentSendingProfile."Electronic Document" <> DocumentSendingProfile."electronic document"::No then begin
          DocExchServiceMgt.CheckServiceEnabled;
          ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."Electronic Format");
          ElectronicDocumentFormat.ValidateElectronicSalesDocument(SalesHeader,DocumentSendingProfile."Electronic Format");
        end;
    end;
}

