#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1320 "Notification Email"
{
    WordLayout = './Layouts/Notification Email.docx';
    Caption = 'Notification Email';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(1));
            column(ReportForNavId_5444; 5444)
            {
            }
            column(Line1;Line1)
            {
            }
            column(Line2;Line2)
            {
            }
            column(Line3;Line3Lbl)
            {
            }
            column(Line4;Line4Lbl)
            {
            }
            column(Settings_UrlText;SettingsLbl)
            {
            }
            column(Settings_Url;SettingsURL)
            {
            }
            column(SettingsWin_UrlText;SettingsWinLbl)
            {
            }
            column(SettingsWin_Url;SettingsWinURL)
            {
            }
            dataitem("Notification Entry";"Notification Entry")
            {
                column(ReportForNavId_1; 1)
                {
                }
                column(UserName;ReceipientUser."Full Name")
                {
                }
                column(DocumentType;DocumentType)
                {
                }
                column(DocumentNo;DocumentNo)
                {
                }
                column(Document_UrlText;DocumentName)
                {
                }
                column(Document_Url;DocumentURL)
                {
                }
                column(CustomLink_UrlText;CustomLinkLbl)
                {
                }
                column(CustomLink_Url;"Custom Link")
                {
                }
                column(ActionText;ActionText)
                {
                }
                column(Field1Label;Field1Label)
                {
                }
                column(Field1Value;Field1Value)
                {
                }
                column(Field2Label;Field2Label)
                {
                }
                column(Field2Value;Field2Value)
                {
                }
                column(Field3Label;Field3Label)
                {
                }
                column(Field3Value;Field3Value)
                {
                }
                column(DetailsLabel;DetailsLabel)
                {
                }
                column(DetailsValue;DetailsValue)
                {
                }

                trigger OnAfterGetRecord()
                var
                    RecRef: RecordRef;
                begin
                    FindReceipientUser;
                    CreateSettingsLink;
                    NotificationSetup.GetNotificationSetup(Type);
                    DataTypeManagement.GetRecordRef("Triggered By Record",RecRef);
                    SetDocumentTypeAndNumber(RecRef);
                    SetActionText;
                    SetReportFieldPlaceholders(RecRef);
                    SetReportLinePlaceholders;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
    end;

    var
        NotificationSetup: Record "Notification Setup";
        CompanyInformation: Record "Company Information";
        ReceipientUser: Record User;
        PageManagement: Codeunit "Page Management";
        DataTypeManagement: Codeunit "Data Type Management";
        NotificationManagement: Codeunit "Notification Management";
        SettingsURL: Text;
        SettingsWinURL: Text;
        DocumentType: Text;
        DocumentNo: Text;
        DocumentName: Text;
        DocumentURL: Text;
        ActionText: Text;
        Field1Label: Text;
        Field1Value: Text;
        Field2Label: Text;
        Field2Value: Text;
        Field3Label: Text;
        Field3Value: Text;
        SettingsLbl: label 'Notification Settings';
        SettingsWinLbl: label '(Windows Client)';
        CustomLinkLbl: label '(Custom Link)';
        Line1Lbl: label 'Hello %1,', Comment='%1 = User Name';
        Line2Lbl: label 'You are registered to receive notifications related to %1.', Comment='%1 = Company Name';
        Line3Lbl: label 'This is a message to notify you that:';
        Line4Lbl: label 'Notification messages are sent automatically and cannot be replied to. But you can change when and how you receive notifications:';
        DetailsLabel: Text;
        DetailsValue: Text;
        Line1: Text;
        Line2: Text;
        DetailsLbl: label 'Details';

    local procedure FindReceipientUser()
    begin
        ReceipientUser.SetRange("User Name","Notification Entry"."Recipient User ID");
        if not ReceipientUser.FindFirst then
          ReceipientUser.Init;
    end;

    local procedure CreateSettingsLink()
    var
        PermissionManager: Codeunit "Permission Manager";
        RecRef: RecordRef;
        PageID: Integer;
    begin
        if SettingsURL <> '' then
          exit;

        NotificationSetup.SetRange("User ID",ReceipientUser."User Name");
        DataTypeManagement.GetRecordRef(NotificationSetup,RecRef);
        PageID := PageManagement.GetPageID(RecRef);
        SettingsURL := PageManagement.GetWebUrl(RecRef,PageID);
        if not PermissionManager.SoftwareAsAService then
          SettingsWinURL := PageManagement.GetRTCUrl(RecRef,PageID);
    end;

    local procedure SetDocumentTypeAndNumber(SourceRecRef: RecordRef)
    var
        RecRef: RecordRef;
    begin
        GetTargetRecRef(SourceRecRef,RecRef);
        NotificationManagement.GetDocumentTypeAndNumber(RecRef,DocumentType,DocumentNo);
        DocumentName := DocumentType + ' ' + DocumentNo;
    end;

    local procedure SetActionText()
    begin
        ActionText := NotificationManagement.GetActionTextFor("Notification Entry");
    end;

    local procedure SetReportFieldPlaceholders(SourceRecRef: RecordRef)
    var
        User: Record User;
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        IncomingDocument: Record "Incoming Document";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        RecordDetails: Text;
        HasApprovalEntryAmount: Boolean;
    begin
        Clear(Field1Label);
        Clear(Field1Value);
        Clear(Field2Label);
        Clear(Field2Value);
        Clear(Field3Label);
        Clear(Field3Value);
        Clear(DetailsLabel);
        Clear(DetailsValue);

        DetailsLabel := DetailsLbl;
        DetailsValue := "Notification Entry".FieldCaption("Created By") + ' ';

        User.SetRange("User Name","Notification Entry"."Created By");
        if User.FindFirst and (User."Full Name" <> '') then
          DetailsValue += User."Full Name"
        else
          DetailsValue += "Notification Entry"."Created By";

        if SourceRecRef.Number = Database::"Approval Entry" then begin
          HasApprovalEntryAmount := true;
          SourceRecRef.SetTable(ApprovalEntry);
        end;

        GetTargetRecRef(SourceRecRef,RecRef);

        case RecRef.Number of
          Database::"Incoming Document":
            begin
              Field1Label := IncomingDocument.FieldCaption("Entry No.");
              FieldRef := RecRef.Field(IncomingDocument.FieldNo("Entry No."));
              Field1Value := Format(FieldRef.Value);
              Field2Label := IncomingDocument.FieldCaption(Description);
              FieldRef := RecRef.Field(IncomingDocument.FieldNo(Description));
              Field2Value := Format(FieldRef.Value);
            end;
          Database::"Sales Header",
          Database::"Sales Invoice Header",
          Database::"Sales Cr.Memo Header":
            begin
              RecRef.SetTable(SalesHeader);
              Field1Label := SalesHeader.FieldCaption(Amount);
              if SalesHeader."Currency Code" <> '' then
                Field1Value := SalesHeader."Currency Code" + ' ';
              if HasApprovalEntryAmount then
                Field1Value += Format(ApprovalEntry.Amount,0,'<Precision,2><Standard Format,0>')
              else begin
                SalesHeader.CalcFields(Amount);
                Field1Value += Format(SalesHeader.Amount,0,'<Precision,2><Standard Format,0>')
              end;
              Field2Label := Customer.TableCaption;
              FieldRef := RecRef.Field(SalesHeader.FieldNo("Sell-to Customer No."));
              if Customer.Get(FieldRef.Value) then
                Field2Value := Customer.Name + ' (#' + Format(FieldRef.Value) + ')';
            end;
          Database::"Purchase Header",
          Database::"Purch. Inv. Header",
          Database::"Purch. Cr. Memo Hdr.":
            begin
              RecRef.SetTable(PurchaseHeader);
              Field1Label := PurchaseHeader.FieldCaption(Amount);
              if PurchaseHeader."Currency Code" <> '' then
                Field1Value := PurchaseHeader."Currency Code" + ' ';
              if HasApprovalEntryAmount then
                Field1Value += Format(ApprovalEntry.Amount,0,'<Precision,2><Standard Format,0>')
              else begin
                PurchaseHeader.CalcFields(Amount);
                Field1Value += Format(PurchaseHeader.Amount,0,'<Precision,2><Standard Format,0>')
              end;
              Field2Label := Vendor.TableCaption;
              FieldRef := RecRef.Field(PurchaseHeader.FieldNo("Buy-from Vendor No."));
              if Vendor.Get(FieldRef.Value) then
                Field2Value := Vendor.Name + ' (#' + Format(FieldRef.Value) + ')';
            end;
          Database::"Gen. Journal Line":
            begin
              RecRef.SetTable(GenJournalLine);
              Field1Label := GenJournalLine.FieldCaption("Document No.");
              Field1Value := Format(GenJournalLine."Document No.");
              Field2Label := GenJournalLine.FieldCaption(Amount);
              if GenJournalLine."Currency Code" <> '' then
                Field2Value := GenJournalLine."Currency Code" + ' ';
              if HasApprovalEntryAmount then
                Field2Value += Format(ApprovalEntry.Amount,0,'<Precision,2><Standard Format,0>')
              else
                Field2Value += Format(GenJournalLine.Amount,0,'<Precision,2><Standard Format,0>')
            end;
          Database::"Gen. Journal Batch":
            begin
              Field1Label := GenJournalBatch.FieldCaption(Description);
              FieldRef := RecRef.Field(GenJournalBatch.FieldNo(Description));
              Field1Value := Format(FieldRef.Value);
              Field2Label := GenJournalBatch.FieldCaption("Template Type");
              FieldRef := RecRef.Field(GenJournalBatch.FieldNo("Template Type"));
              Field2Value := Format(FieldRef.Value);
            end;
          Database::Customer:
            begin
              Field1Label := Customer.FieldCaption("No.");
              FieldRef := RecRef.Field(Customer.FieldNo("No."));
              Field1Value := Format(FieldRef.Value);
              Field2Label := Customer.FieldCaption(Name);
              FieldRef := RecRef.Field(Customer.FieldNo(Name));
              Field2Value := Format(FieldRef.Value);
            end;
          Database::Vendor:
            begin
              Field1Label := Vendor.FieldCaption("No.");
              FieldRef := RecRef.Field(Vendor.FieldNo("No."));
              Field1Value := Format(FieldRef.Value);
              Field2Label := Vendor.FieldCaption(Name);
              FieldRef := RecRef.Field(Vendor.FieldNo(Name));
              Field2Value := Format(FieldRef.Value);
            end;
          Database::Item:
            begin
              Field1Label := Item.FieldCaption("No.");
              FieldRef := RecRef.Field(Item.FieldNo("No."));
              Field1Value := Format(FieldRef.Value);
              Field2Label := Item.FieldCaption(Description);
              FieldRef := RecRef.Field(Item.FieldNo(Description));
              Field2Value := Format(FieldRef.Value);
            end;
        end;

        case "Notification Entry".Type of
          "Notification Entry".Type::Approval:
            begin
              SourceRecRef.SetTable(ApprovalEntry);
              Field3Label := ApprovalEntry.FieldCaption("Due Date");
              Field3Value := Format(ApprovalEntry."Due Date");
              //RecordDetails := ApprovalEntry.GetChangeRecordDetails;
              if RecordDetails <> '' then
                DetailsValue += RecordDetails;
            end;
          "Notification Entry".Type::Overdue:
            begin
              Field3Label := OverdueApprovalEntry.FieldCaption("Due Date");
              FieldRef := SourceRecRef.Field(OverdueApprovalEntry.FieldNo("Due Date"));
              Field3Value := Format(FieldRef.Value);
            end;
        end;

        if NotificationSetup."Display Target" = NotificationSetup."display target"::Windows then
          DocumentURL := PageManagement.GetRTCUrl(RecRef,"Notification Entry"."Link Target Page")
        else
          DocumentURL := PageManagement.GetWebUrl(RecRef,"Notification Entry"."Link Target Page");
    end;

    local procedure SetReportLinePlaceholders()
    begin
        Line1 := StrSubstNo(Line1Lbl,ReceipientUser."Full Name");
        Line2 := StrSubstNo(Line2Lbl,CompanyInformation.Name);
    end;

    local procedure GetTargetRecRef(RecRef: RecordRef;var TargetRecRefOut: RecordRef)
    var
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
    begin
        case "Notification Entry".Type of
          "Notification Entry".Type::"New Record":
            TargetRecRefOut := RecRef;
          "Notification Entry".Type::Approval:
            begin
              RecRef.SetTable(ApprovalEntry);
             // TargetRecRefOut.GET(ApprovalEntry."Record ID to Approve");
            end;
          "Notification Entry".Type::Overdue:
            begin
              RecRef.SetTable(OverdueApprovalEntry);
              TargetRecRefOut.Get(OverdueApprovalEntry."Record ID to Approve");
            end;
        end;
    end;
}

