#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9551 "Document Service Config"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft SharePoint Connection Setup';
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Document Service";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Service ID";"Service ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service ID';
                    ToolTip = 'Specifies a unique code for the service that you use for document storage and usage.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description for the document service.';
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location';
                    ToolTip = 'Specifies the URI for where your documents are stored, such as your site on SharePoint Online.';
                }
                field(Folder;Folder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Folder';
                    ToolTip = 'Specifies the folder in the document repository for this document service that you want documents to be stored in.';
                }
            }
            group("Shared documents")
            {
                Caption = 'Shared Documents';
                field("Document Repository";"Document Repository")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Repository';
                    ToolTip = 'Specifies the location where your document service provider stores your documents, if you want to store documents in a shared document repository.';
                }
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'User Name';
                    ToolTip = 'Specifies the account that Microsoft Dynamics NAV Server must use to log on to the document service, if you want to use a shared document repository.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Test Connection")
            {
                ApplicationArea = Basic;
                Caption = 'Test Connection';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Test the configuration settings against the online document storage service.';

                trigger OnAction()
                var
                    DocumentServiceManagement: Codeunit "Document Service Management";
                begin
                    // Save record to make sure the credentials are reset.
                    Modify;
                    DocumentServiceManagement.TestConnection;
                    Message(ValidateSuccessMsg);
                end;
            }
            action("Set Password")
            {
                ApplicationArea = Basic;
                Caption = 'Set Password';
                Enabled = DynamicEditable;
                Image = EncryptionKeys;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Set the password for the current User Name';

                trigger OnAction()
                var
                    DocumentServiceAccPwd: Page "Document Service Acc. Pwd.";
                begin
                    if DocumentServiceAccPwd.RunModal = Action::OK then begin
                      if Confirm(ChangePwdQst) then
                        Password := DocumentServiceAccPwd.GetData;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DynamicEditable := CurrPage.Editable;
    end;

    trigger OnInit()
    begin
        DynamicEditable := false;
    end;

    trigger OnOpenPage()
    begin
        if not FindFirst then begin
          Init;
          "Service ID" := 'Service 1';
          Insert(false);
        end;
    end;

    var
        ChangePwdQst: label 'Are you sure that you want to change your password?';
        DynamicEditable: Boolean;
        ValidateSuccessMsg: label 'The connection settings validated correctly, and the current configuration can connect to the document storage service.';
}

