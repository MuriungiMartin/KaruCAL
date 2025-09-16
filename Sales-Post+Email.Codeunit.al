#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 89 "Sales-Post + Email"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SalesHeader.Copy(Rec);
        Code;
        Rec := SalesHeader;
    end;

    var
        PostAndSendInvoiceQst: label 'Do you want to post and send the %1?';
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        FileManagement: Codeunit "File Management";
        HideMailDialog: Boolean;
        PostAndSaveInvoiceQst: label 'Do you want to post and save the %1?';
        NotSupportedDocumentTypeSendingErr: label 'The %1 is not posted because sending document of type %1 is not supported.';
        NotSupportedDocumentTypeSavingErr: label 'The %1 is not posted because saving document of type %1 is not supported.';

    local procedure "Code"()
    begin
        with SalesHeader do begin
          case "Document Type" of
            "document type"::Invoice,
            "document type"::"Credit Memo":
              if not ConfirmPostAndDistribute(SalesHeader) then
                exit;
            else
              ErrorPostAndDistribute(SalesHeader);
          end;

          Codeunit.Run(Codeunit::"Sales-Post",SalesHeader);
          Commit;
          SendDocumentReport(SalesHeader);
        end;
    end;

    local procedure SendDocumentReport(var SalesHeader: Record "Sales Header")
    var
        ShowDialog: Boolean;
    begin
        with SalesHeader do
          case "Document Type" of
            "document type"::Invoice:
              begin
                if "Last Posting No." = '' then
                  SalesInvHeader."No." := "No."
                else
                  SalesInvHeader."No." := "Last Posting No.";
                SalesInvHeader.Find;
                SalesInvHeader.SetRecfilter;
                ShowDialog := (CurrentClientType <> Clienttype::Phone) and not HideMailDialog;
                SalesInvHeader.EmailRecords(ShowDialog);
              end;
            "document type"::"Credit Memo":
              begin
                if "Last Posting No." = '' then
                  SalesCrMemoHeader."No." := "No."
                else
                  SalesCrMemoHeader."No." := "Last Posting No.";
                SalesCrMemoHeader.Find;
                SalesCrMemoHeader.SetRecfilter;
                SalesCrMemoHeader.EmailRecords(not HideMailDialog);
              end
          end
    end;


    procedure InitializeFrom(NewHideMailDialog: Boolean)
    begin
        HideMailDialog := NewHideMailDialog;
    end;

    local procedure ConfirmPostAndDistribute(var SalesHeader: Record "Sales Header"): Boolean
    var
        PostAndDistributeQuestion: Text;
        ConfirmOK: Boolean;
    begin
        if CurrentClientType = Clienttype::Phone then
          exit(true);

        if FileManagement.IsWebClient then
          PostAndDistributeQuestion := PostAndSaveInvoiceQst
        else
          PostAndDistributeQuestion := PostAndSendInvoiceQst;

        ConfirmOK := Confirm(PostAndDistributeQuestion,false,SalesHeader."Document Type");

        exit(ConfirmOK);
    end;

    local procedure ErrorPostAndDistribute(var SalesHeader: Record "Sales Header")
    var
        NotSupportedDocumentType: Text;
    begin
        if FileManagement.IsWebClient then
          NotSupportedDocumentType := NotSupportedDocumentTypeSavingErr
        else
          NotSupportedDocumentType := NotSupportedDocumentTypeSendingErr;

        Error(NotSupportedDocumentType,SalesHeader."Document Type");
    end;
}

