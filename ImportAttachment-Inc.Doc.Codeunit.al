#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 134 "Import Attachment - Inc. Doc."
{
    TableNo = "Incoming Document Attachment";

    trigger OnRun()
    var
        FileName: Text;
    begin
        UploadFile(Rec,FileName);
        ImportAttachment(Rec,FileName);
    end;

    var
        ReplaceContentQst: label 'Do you want to replace the file content?';
        ImportTxt: label 'Insert File';
        FileDialogTxt: label 'Attachments (%1)|%1', Comment='%1=file types, such as *.txt or *.docx';
        FilterTxt: label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked=true;
        NotSupportedDocTableErr: label 'Table no. %1 is not supported.', Comment='%1 is a number (integer).';


    procedure UploadFile(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var FileName: Text)
    var
        TempBlob: Record TempBlob;
        FileManagement: Codeunit "File Management";
    begin
        IncomingDocumentAttachment.CalcFields(Content);
        if IncomingDocumentAttachment.Content.Hasvalue then
          if not Confirm(ReplaceContentQst,false) then
            Error('');

        FileName := FileManagement.BLOBImportWithFilter(TempBlob,ImportTxt,FileName,StrSubstNo(FileDialogTxt,FilterTxt),FilterTxt);
        IncomingDocumentAttachment.Content := TempBlob.Blob;
    end;


    procedure ImportAttachment(var IncomingDocumentAttachment: Record "Incoming Document Attachment";FileName: Text): Boolean
    var
        IncomingDocument: Record "Incoming Document";
        TempBlob: Record TempBlob;
        FileManagement: Codeunit "File Management";
    begin
        if FileName = '' then
          Error('');

        with IncomingDocumentAttachment do begin
          FindOrCreateIncomingDocument(IncomingDocumentAttachment,IncomingDocument);
          if IncomingDocument.Status in [IncomingDocument.Status::"Pending Approval",IncomingDocument.Status::Failed] then
            IncomingDocument.TestField(Status,IncomingDocument.Status::New);
          "Incoming Document Entry No." := IncomingDocument."Entry No.";
          "Line No." := GetIncomingDocumentNextLineNo(IncomingDocument);

          if not Content.Hasvalue then begin
            if FileManagement.ServerFileExists(FileName) then
              FileManagement.BLOBImportFromServerFile(TempBlob,FileName)
            else
              FileManagement.BLOBImportFromServerFile(TempBlob,FileManagement.UploadFileSilent(FileName));
            Content := TempBlob.Blob;
          end;

          Validate("File Extension",Lowercase(CopyStr(FileManagement.GetExtension(FileName),1,MaxStrLen("File Extension"))));
          if Name = '' then
            Name := CopyStr(FileManagement.GetFileNameWithoutExtension(FileName),1,MaxStrLen(Name));

          "Document No." := IncomingDocument."Document No.";
          "Posting Date" := IncomingDocument."Posting Date";
          if IncomingDocument.Description = '' then begin
            IncomingDocument.Description := Name;
            IncomingDocument.Modify;
          end;

          Insert(true);

          if Type in [Type::Image,Type::Pdf] then
            OnAttachBinaryFile;
        end;
        exit(true);
    end;

    local procedure FindOrCreateIncomingDocument(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document")
    var
        DocNo: Code[20];
        PostingDate: Date;
    begin
        if FindUsingIncomingDocNoFilter(IncomingDocumentAttachment,IncomingDocument) then
          exit;
        if FindUsingDocNoFilter(IncomingDocumentAttachment,IncomingDocument,PostingDate,DocNo) then
          exit;
        CreateIncomingDocument(IncomingDocumentAttachment,IncomingDocument,PostingDate,DocNo);
    end;

    local procedure FindInIncomingDocAttachmentUsingIncomingDocNoFilter(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document"): Boolean
    var
        IncomingDocNo: Integer;
    begin
        if IncomingDocumentAttachment.GetFilter("Incoming Document Entry No.") <> '' then begin
          IncomingDocNo := IncomingDocumentAttachment.GetRangeMin("Incoming Document Entry No.");
          if IncomingDocNo <> 0 then
            exit(IncomingDocument.Get(IncomingDocNo));
        end;
        exit(false);
    end;

    local procedure FindInGenJournalLineUsingIncomingDocNoFilter(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document"): Boolean
    var
        IncomingDocNo: Integer;
    begin
        if IncomingDocumentAttachment.GetFilter("Journal Batch Name Filter") <> '' then begin
          IncomingDocNo := CreateNewJournalLineIncomingDoc(IncomingDocumentAttachment);
          if IncomingDocNo <> 0 then
            exit(IncomingDocument.Get(IncomingDocNo));
        end;
        exit(false);
    end;

    local procedure FindInSalesPurchUsingIncomingDocNoFilter(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document"): Boolean
    var
        IncomingDocNo: Integer;
    begin
        if IncomingDocumentAttachment.GetFilter("Document Table No. Filter") <> '' then begin
          IncomingDocNo := CreateNewSalesPurchIncomingDoc(IncomingDocumentAttachment);
          if IncomingDocNo <> 0 then
            exit(IncomingDocument.Get(IncomingDocNo));
        end;
        exit(false);
    end;

    local procedure FindUsingIncomingDocNoFilter(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document"): Boolean
    var
        FilterGroupID: Integer;
        Found: Boolean;
    begin
        for FilterGroupID := 0 to 2 do begin
          IncomingDocumentAttachment.FilterGroup(FilterGroupID * 2);
          case true of
            FindInIncomingDocAttachmentUsingIncomingDocNoFilter(IncomingDocumentAttachment,IncomingDocument):
              Found := true;
            FindInGenJournalLineUsingIncomingDocNoFilter(IncomingDocumentAttachment,IncomingDocument):
              Found := true;
            FindInSalesPurchUsingIncomingDocNoFilter(IncomingDocumentAttachment,IncomingDocument):
              Found := true;
          end;
          if Found then
            break;
        end;
        IncomingDocumentAttachment.FilterGroup(0);
        exit(Found);
    end;

    local procedure FindUsingDocNoFilter(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document";var PostingDate: Date;var DocNo: Code[20]): Boolean
    var
        FilterGroupID: Integer;
    begin
        for FilterGroupID := 0 to 2 do begin
          IncomingDocumentAttachment.FilterGroup(FilterGroupID * 2);
          if (IncomingDocumentAttachment.GetFilter("Document No.") <> '') and
             (IncomingDocumentAttachment.GetFilter("Posting Date") <> '')
          then begin
            DocNo := IncomingDocumentAttachment.GetRangeMin("Document No.");
            PostingDate := IncomingDocumentAttachment.GetRangeMin("Posting Date");
            if DocNo <> '' then
              break;
          end;
        end;
        IncomingDocumentAttachment.FilterGroup(0);

        if (DocNo = '') or (PostingDate = 0D) then
          exit(false);

        IncomingDocument.SetRange("Document No.",DocNo);
        IncomingDocument.SetRange("Posting Date",PostingDate);
        exit(IncomingDocument.FindFirst);
    end;

    local procedure CreateNewSalesPurchIncomingDoc(var IncomingDocumentAttachment: Record "Incoming Document Attachment"): Integer
    var
        IncomingDocument: Record "Incoming Document";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        DocTableNo: Integer;
        DocType: Option;
        DocNo: Code[20];
    begin
        with IncomingDocumentAttachment do begin
          if GetFilter("Document Table No. Filter") <> '' then
            DocTableNo := GetRangeMin("Document Table No. Filter");
          if GetFilter("Document Type Filter") <> '' then
            DocType := GetRangeMin("Document Type Filter");
          if GetFilter("Document No. Filter") <> '' then
            DocNo := GetRangeMin("Document No. Filter");

          case DocTableNo of
            Database::"Sales Header":
              begin
                SalesHeader.Get(DocType,DocNo);
                CreateIncomingDocumentExtended(IncomingDocumentAttachment,IncomingDocument,0D,'',SalesHeader.RecordId);
                SalesHeader."Incoming Document Entry No." := IncomingDocument."Entry No.";
                SalesHeader.Modify;
              end;
            Database::"Purchase Header":
              begin
                PurchaseHeader.Get(DocType,DocNo);
                CreateIncomingDocumentExtended(IncomingDocumentAttachment,IncomingDocument,0D,'',PurchaseHeader.RecordId);
                PurchaseHeader."Incoming Document Entry No." := IncomingDocument."Entry No.";
                PurchaseHeader.Modify;
              end;
            else
              Error(NotSupportedDocTableErr,DocTableNo);
          end;

          exit(IncomingDocument."Entry No.");
        end;
    end;

    local procedure CreateNewJournalLineIncomingDoc(var IncomingDocumentAttachment: Record "Incoming Document Attachment"): Integer
    var
        IncomingDocument: Record "Incoming Document";
        GenJournalLine: Record "Gen. Journal Line";
        JnlTemplateName: Code[20];
        JnlBatchName: Code[20];
        JnlLineNo: Integer;
    begin
        with IncomingDocumentAttachment do begin
          if GetFilter("Journal Template Name Filter") <> '' then
            JnlTemplateName := GetRangeMin("Journal Template Name Filter");
          if GetFilter("Journal Batch Name Filter") <> '' then
            JnlBatchName := GetRangeMin("Journal Batch Name Filter");
          if GetFilter("Journal Line No. Filter") <> '' then
            JnlLineNo := GetRangeMin("Journal Line No. Filter");

          GenJournalLine.Get(JnlTemplateName,JnlBatchName,JnlLineNo);
          CreateIncomingDocumentExtended(IncomingDocumentAttachment,IncomingDocument,0D,'',GenJournalLine.RecordId);
          GenJournalLine."Incoming Document Entry No." := IncomingDocument."Entry No.";
          GenJournalLine.Modify;

          exit(IncomingDocument."Entry No.");
        end;
    end;

    local procedure CreateIncomingDocument(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document";PostingDate: Date;DocNo: Code[20])
    var
        DummyRecordID: RecordID;
    begin
        CreateIncomingDocumentExtended(IncomingDocumentAttachment,IncomingDocument,PostingDate,DocNo,DummyRecordID);
    end;

    local procedure CreateIncomingDocumentExtended(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document";PostingDate: Date;DocNo: Code[20];RelatedRecordID: RecordID)
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RelatedRecordRef: RecordRef;
        RelatedRecord: Variant;
    begin
        IncomingDocument.CreateIncomingDocument('','');
        IncomingDocument."Document Type" :=
          GetDocType(IncomingDocumentAttachment,IncomingDocument,PostingDate,DocNo,IncomingDocument.Posted);
        if RelatedRecordID.TableNo = 0 then
          if IncomingDocument.GetNAVRecord(RelatedRecord) then
            if DataTypeManagement.GetRecordRef(RelatedRecord,RelatedRecordRef) then
              RelatedRecordID := RelatedRecordRef.RecordId;
        IncomingDocument."Related Record ID" := RelatedRecordID;
        if IncomingDocument."Document Type" <> IncomingDocument."document type"::" " then begin
          if IncomingDocument.Posted then
            IncomingDocument.Status := IncomingDocument.Status::Posted
          else
            IncomingDocument.Status := IncomingDocument.Status::Created;
          IncomingDocument.Released := true;
          IncomingDocument."Released Date-Time" := CurrentDatetime;
          IncomingDocument."Released By User ID" := UserSecurityId;
        end;
        IncomingDocument.Modify;
    end;

    local procedure GetDocType(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document";PostingDate: Date;DocNo: Code[20];var Posted: Boolean): Integer
    begin
        if (PostingDate <> 0D) and (DocNo <> '') then begin
          IncomingDocument.SetPostedDocFields(PostingDate,DocNo);
          exit(IncomingDocument.GetPostedDocType(PostingDate,DocNo,Posted));
        end;
        Posted := false;
        exit(GetUnpostedDocType(IncomingDocumentAttachment,IncomingDocument));
    end;

    local procedure GetUnpostedDocType(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document"): Integer
    begin
        if IsJournalRelated(IncomingDocumentAttachment) then
          exit(IncomingDocument."document type"::Journal);

        if IsSalesPurhaseRelated(IncomingDocumentAttachment) then
          exit(GetUnpostedSalesPurchaseDocType(IncomingDocumentAttachment,IncomingDocument));

        exit(IncomingDocument."document type"::" ");
    end;

    local procedure GetUnpostedSalesPurchaseDocType(var IncomingDocumentAttachment: Record "Incoming Document Attachment";var IncomingDocument: Record "Incoming Document"): Integer
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        case IncomingDocumentAttachment.GetRangeMin("Document Table No. Filter") of
          Database::"Sales Header":
            begin
              if IncomingDocumentAttachment.GetRangeMin("Document Type Filter") = SalesHeader."document type"::"Credit Memo" then
                exit(IncomingDocument."document type"::"Sales Credit Memo");
              exit(IncomingDocument."document type"::"Sales Invoice");
            end;
          Database::"Purchase Header":
            begin
              if IncomingDocumentAttachment.GetRangeMin("Document Type Filter") = PurchaseHeader."document type"::"Credit Memo" then
                exit(IncomingDocument."document type"::"Purchase Credit Memo");
              exit(IncomingDocument."document type"::"Purchase Invoice");
            end;
        end;
    end;

    local procedure IsJournalRelated(var IncomingDocumentAttachment: Record "Incoming Document Attachment"): Boolean
    var
        Result: Boolean;
    begin
        Result :=
          (IncomingDocumentAttachment.GetFilter("Journal Template Name Filter") <> '') and
          (IncomingDocumentAttachment.GetFilter("Journal Batch Name Filter") <> '') and
          (IncomingDocumentAttachment.GetFilter("Journal Line No. Filter") <> '');
        exit(Result);
    end;

    local procedure IsSalesPurhaseRelated(var IncomingDocumentAttachment: Record "Incoming Document Attachment"): Boolean
    var
        Result: Boolean;
    begin
        Result :=
          (IncomingDocumentAttachment.GetFilter("Document Table No. Filter") <> '') and
          (IncomingDocumentAttachment.GetFilter("Document Type Filter") <> '');
        exit(Result);
    end;

    local procedure GetIncomingDocumentNextLineNo(IncomingDocument: Record "Incoming Document"): Integer
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
    begin
        with IncomingDocumentAttachment do begin
          SetRange("Incoming Document Entry No.",IncomingDocument."Entry No.");
          if FindLast then;
          exit("Line No." + LineIncrement);
        end;
    end;

    local procedure LineIncrement(): Integer
    begin
        exit(10000);
    end;
}

