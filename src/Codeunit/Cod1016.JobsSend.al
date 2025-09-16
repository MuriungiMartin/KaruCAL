#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1016 "Jobs-Send"
{
    TableNo = Job;

    trigger OnRun()
    begin
        Job.Copy(Rec);
        Code;
        Rec := Job;
    end;

    var
        Job: Record Job;

    local procedure "Code"()
    var
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
    begin
        if not ConfirmSend(Job,TempDocumentSendingProfile) then
          exit;

        ValidateElectronicFormats(TempDocumentSendingProfile);

        with Job do begin
          Get("No.");
          SetRecfilter;
          SendProfile(TempDocumentSendingProfile);
        end;
    end;

    local procedure ConfirmSend(Job: Record Job;var TempDocumentSendingProfile: Record "Document Sending Profile" temporary): Boolean
    var
        Customer: Record Customer;
        DocumentSendingProfile: Record "Document Sending Profile";
        OfficeMgt: Codeunit "Office Management";
    begin
        Customer.Get(Job."Bill-to Customer No.");
        if OfficeMgt.IsAvailable then
          DocumentSendingProfile.GetOfficeAddinDefault(TempDocumentSendingProfile,OfficeMgt.AttachAvailable)
        else begin
          if not DocumentSendingProfile.Get(Customer."Document Sending Profile") then
            DocumentSendingProfile.GetDefault(DocumentSendingProfile);

          Commit;
          with TempDocumentSendingProfile do begin
            Copy(DocumentSendingProfile);
            SetDocumentUsage(Job);
            Insert;
          end;
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
          ElectronicDocumentFormat.ValidateElectronicJobsDocument(Job,DocumentSendingProfile."E-Mail Format");
        end;

        if (DocumentSendingProfile.Disk <> DocumentSendingProfile.Disk::No) and
           (DocumentSendingProfile.Disk <> DocumentSendingProfile.Disk::Pdf)
        then begin
          ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."Disk Format");
          ElectronicDocumentFormat.ValidateElectronicJobsDocument(Job,DocumentSendingProfile."Disk Format");
        end;

        if DocumentSendingProfile."Electronic Document" <> DocumentSendingProfile."electronic document"::No then begin
          DocExchServiceMgt.CheckServiceEnabled;
          ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."Electronic Format");
          ElectronicDocumentFormat.ValidateElectronicJobsDocument(Job,DocumentSendingProfile."Electronic Format");
        end;
    end;
}

