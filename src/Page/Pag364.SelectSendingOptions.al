#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 364 "Select Sending Options"
{
    Caption = 'Send Document to';
    DataCaptionExpression = '';
    PageType = StandardDialog;
    SourceTable = "Document Sending Profile";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Details)
            {
                Caption = 'Details';
                group(Control10)
                {
                    field(Printer;Printer)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if and how the document is printed when you choose the Post and Send button. If you choose the Yes (Prompt for Settings) option, the document is printed according to settings that you must make on the printer setup dialog.';
                        Visible = SendToPrinterVisible;

                        trigger OnValidate()
                        begin
                            SetSendMethodToCustom;
                        end;
                    }
                    field("E-Mail";"E-Mail")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if and how the document is attached as a PDF file to an email to the involved customer when you choose the Post and Send button. If you choose the Yes (Prompt for Settings) option, the document is attached to an email according to settings that you must make in the Send Email window.';

                        trigger OnValidate()
                        begin
                            SetSendMethodToCustom;
                        end;
                    }
                    group(Control12)
                    {
                        Visible = "E-Mail" <> "E-Mail"::No;
                        field("E-Mail Attachment";"E-Mail Attachment")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies if the document is attached to an email when you choose the Post and Send button.';

                            trigger OnValidate()
                            begin
                                VerifySelectedOptionsValid;
                                "E-Mail Format" := GetFormat;
                            end;
                        }
                        group(Control14)
                        {
                            Visible = "E-Mail Attachment" <> "E-Mail Attachment"::PDF;
                            field("E-Mail Format";"E-Mail Format")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Format';
                                ToolTip = 'Specifies the format of the file that is saved to disk.';

                                trigger OnLookup(var Text: Text): Boolean
                                begin
                                    "E-Mail Format" := LookupFormat;
                                end;

                                trigger OnValidate()
                                begin
                                    SetSendMethodToCustom;
                                    LastFormat := "E-Mail Format";
                                end;
                            }
                        }
                    }
                    field(Disk;Disk)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if the document is saved as a PDF file when you choose the Post and Send button.';

                        trigger OnValidate()
                        begin
                            VerifySelectedOptionsValid;
                            SetSendMethodToCustom;
                            "Disk Format" := GetFormat;
                        end;
                    }
                    group(Control16)
                    {
                        Visible = (Disk <> Disk::No) and (Disk <> Disk::PDF);
                        field("Disk Format";"Disk Format")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Format';
                            ToolTip = 'Specifies the format of the electronic document.';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                "Disk Format" := LookupFormat;
                            end;

                            trigger OnValidate()
                            begin
                                SetSendMethodToCustom;
                                LastFormat := "Disk Format";
                            end;
                        }
                    }
                }
                group(Control2)
                {
                    Visible = SendElectronicallyVisible;
                    field("Electronic Document";"Electronic Document")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies if the document is sent as an electronic document that the customer can import into their system when you choose the Post and Send button. To use this option, you must also fill the Electronic Format field. Alternatively, the file can be saved to disk.';

                        trigger OnValidate()
                        begin
                            VerifySelectedOptionsValid;
                            SetSendMethodToCustom;
                            "Electronic Format" := GetFormat;
                        end;
                    }
                    group(Control18)
                    {
                        Visible = "Electronic Document" <> "Electronic Document"::No;
                        field("Electronic Format";"Electronic Format")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Format';
                            ToolTip = 'Specifies which format to use for electronic document sending. You must fill this field if you selected the Silent option in the Electronic Document field.';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                "Electronic Format" := LookupFormat;
                            end;

                            trigger OnValidate()
                            begin
                                SetSendMethodToCustom;
                                LastFormat := "Electronic Format";
                            end;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        DocumentSendingProfile: Record "Document Sending Profile";
    begin
        SendElectronicallyVisible := not ElectronicDocumentFormat.IsEmpty and "One Related Party Selected";
        if DefaultCode = '' then
          DefaultCode := Code;

        if DocumentSendingProfile.Get(DefaultCode) then
          Copy(DocumentSendingProfile);
    end;

    trigger OnInit()
    begin
        SendToPrinterVisible := CurrentClientType = Clienttype::Windows;
    end;

    trigger OnOpenPage()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        [InDataSet]
        SendElectronicallyVisible: Boolean;
        CustomTxt: label 'Custom';
        SendToPrinterVisible: Boolean;
        DefaultCode: Code[20];
        LastFormat: Code[20];

    local procedure SetSendMethodToCustom()
    begin
        Code := CustomTxt;
    end;

    local procedure LookupFormat(): Code[20]
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        ElectronicDocumentFormats: Page "Electronic Document Formats";
    begin
        ElectronicDocumentFormat.SetRange(Usage,Usage);
        ElectronicDocumentFormats.SetTableview(ElectronicDocumentFormat);
        ElectronicDocumentFormats.LookupMode := true;

        if ElectronicDocumentFormats.RunModal = Action::LookupOK then begin
          ElectronicDocumentFormats.GetRecord(ElectronicDocumentFormat);
          LastFormat := ElectronicDocumentFormat.Code;
          exit(ElectronicDocumentFormat.Code);
        end;

        exit(GetFormat);
    end;

    local procedure GetFormat(): Code[20]
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        FindNewFormat: Boolean;
    begin
        FindNewFormat := false;

        if LastFormat = '' then
          FindNewFormat := true
        else begin
          ElectronicDocumentFormat.SetRange(Code,LastFormat);
          ElectronicDocumentFormat.SetRange(Usage,Usage);
          if not ElectronicDocumentFormat.FindFirst then
            FindNewFormat := true;
        end;

        if FindNewFormat then begin
          ElectronicDocumentFormat.SetRange(Code);
          ElectronicDocumentFormat.SetRange(Usage,Usage);
          if not ElectronicDocumentFormat.FindFirst then
            LastFormat := ''
          else
            LastFormat := ElectronicDocumentFormat.Code;
        end;

        exit(LastFormat);
    end;
}

