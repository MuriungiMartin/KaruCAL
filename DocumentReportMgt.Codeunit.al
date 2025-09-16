#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9651 "Document Report Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        NotImplementedErr: label 'This option is not available.';
        TemplateValidationQst: label 'The Word layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the layout validation:\%1\Do you want to continue?';
        TemplateValidationErr: label 'The Word layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the document validation:\%1\You must update the layout to match the current report design.';
        AbortWithValidationErr: label 'The Word layout action has been canceled because of validation errors.';
        TemplateValidationUpdateQst: label 'The Word layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the layout validation:\%1\Do you want to run an automatic update?';
        TemplateAfterUpdateValidationErr: label 'The automatic update could not resolve all the conflicts in the current Word layout. For example, the layout uses fields that are missing in the report design or the report ID is wrong.\The following errors were detected:\%1\You must manually update the layout to match the current report design.';
        UpgradeMessageMsg: label 'The report upgrade process returned the following log messages:\%1.';
        NoReportLayoutUpgradeRequiredMsg: label 'The layout upgrade process completed without detecting any required changes in the current application.';
        CompanyInformationPicErr: label 'The document contains elements that cannot be converted to PDF. This may be caused by missing image data in the document.';
        FileTypeWordTxt: label 'docx', Locked=true;
        FileTypePdfTxt: label 'pdf', Locked=true;
        FileTypeHtmlTxt: label 'html', Locked=true;
        LayoutCodeTemplateTxt: label '%1-%2', Comment='Template for generating ''code'' ids for layouts in extensions. %1 - Extension name, %2 - layout number';
        AutoLayoutCodeTxt: label 'MS-EXT', Locked=true;


    procedure MergeWordLayout(ReportID: Integer;ReportAction: Option SaveAsPdf,SaveAsWord,SaveAsExcel,Preview,Print,SaveAsHtml;InStrXmlData: InStream;FileName: Text)
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        CustomReportLayout: Record "Custom Report Layout";
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        InStrWordDoc: InStream;
        OutStrWordDoc: OutStream;
        NAVWordXMLMerger: dotnet WordReportManager;
        CustomLayoutCode: Code[20];
        CurrentFileType: Text;
    begin
        // FileName contains printername for ReportAction::Print.
        // Temporarily selected layout for Design-time report execution?
        if ReportLayoutSelection.GetTempLayoutSelected <> '' then
          CustomLayoutCode := ReportLayoutSelection.GetTempLayoutSelected
        else  // Normal selection
          if ReportLayoutSelection.Get(ReportID,COMPANYNAME) and
             (ReportLayoutSelection.Type = ReportLayoutSelection.Type::"Custom Layout")
          then
            CustomLayoutCode := ReportLayoutSelection."Custom Report Layout Code";

        if CustomLayoutCode <> '' then
          if not CustomReportLayout.Get(CustomLayoutCode) then
            CustomLayoutCode := '';

        if CustomLayoutCode = '' then
          Report.WordLayout(ReportID,InStrWordDoc)
        else begin
          ValidateAndUpdateWordLayoutOnRecord(CustomReportLayout);
          CustomReportLayout.CalcFields(Layout);
          CustomReportLayout.Layout.CreateInstream(InStrWordDoc);
          ValidateWordLayoutCheckOnly(ReportID,InStrWordDoc);
        end;
        TempBlob.Blob.CreateOutstream(OutStrWordDoc);

        OutStrWordDoc := NAVWordXMLMerger.MergeWordDocument(InStrWordDoc,InStrXmlData,OutStrWordDoc) ;
        Commit;

        CurrentFileType := '';
        case ReportAction of
          Reportaction::SaveAsWord:
            CurrentFileType := FileTypeWordTxt;
          Reportaction::SaveAsPdf:
            begin
              CurrentFileType := FileTypePdfTxt;
              ConvertToPdf(TempBlob);
            end;
          Reportaction::SaveAsHtml:
            begin
              CurrentFileType := FileTypeHtmlTxt;
              ConvertToHtml(TempBlob);
            end;
          Reportaction::SaveAsExcel:
            Error(NotImplementedErr);
          Reportaction::Print:
            PrintWordDoc(ReportID,TempBlob,FileName,true);
          Reportaction::Preview:
            FileMgt.BLOBExport(TempBlob,UserFileName(ReportID,CurrentFileType),true);
        end;

        // Export the file to the client of the action generates an output object in which case currentFileType is non-empty.
        if CurrentFileType <> '' then
          if FileName = '' then
            FileMgt.BLOBExport(TempBlob,UserFileName(ReportID,CurrentFileType),true)
          else
            // Dont' use FileMgt.BLOBExportToServerFile. It will fail if run through
            // CodeUnit 8800, as the filename will exist in a temp folder.
            TempBlob.Blob.Export(FileName);
    end;


    procedure ValidateWordLayout(ReportID: Integer;DocumentStream: InStream;useConfirm: Boolean;updateContext: Boolean): Boolean
    var
        NAVWordXMLMerger: dotnet WordReportManager;
        ValidationErrors: Text;
        ValidationErrorFormat: Text;
    begin
        ValidationErrors := NAVWordXMLMerger.ValidateWordDocumentTemplate(DocumentStream,Report.WordXmlPart(ReportID,true));
        if ValidationErrors <> '' then begin
          if useConfirm then begin
            if not Confirm(TemplateValidationQst,false,ValidationErrors) then
              Error(AbortWithValidationErr);
          end else begin
            if updateContext then
              ValidationErrorFormat := TemplateAfterUpdateValidationErr
            else
              ValidationErrorFormat := TemplateValidationErr;

            Error(ValidationErrorFormat,ValidationErrors);
          end;

          exit(false);
        end;
        exit(true);
    end;

    local procedure ValidateWordLayoutCheckOnly(ReportID: Integer;DocumentStream: InStream)
    var
        NAVWordXMLMerger: dotnet WordReportManager;
        ValidationErrors: Text;
        ValidationErrorFormat: Text;
    begin
        ValidationErrors := NAVWordXMLMerger.ValidateWordDocumentTemplate(DocumentStream,Report.WordXmlPart(ReportID,true));
        if ValidationErrors <> '' then begin
          ValidationErrorFormat := TemplateAfterUpdateValidationErr;
          Message(ValidationErrorFormat,ValidationErrors);
        end;
    end;

    local procedure ValidateAndUpdateWordLayoutOnRecord(CustomReportLayout: Record "Custom Report Layout"): Boolean
    var
        NAVWordXMLMerger: dotnet WordReportManager;
        DocumentStream: InStream;
        ValidationErrors: Text;
    begin
        CustomReportLayout.TestField(Type,CustomReportLayout.Type::Word);
        CustomReportLayout.CalcFields(Layout);
        CustomReportLayout.Layout.CreateInstream(DocumentStream);
        NAVWordXMLMerger := NAVWordXMLMerger.WordReportManager;

        ValidationErrors :=
          NAVWordXMLMerger.ValidateWordDocumentTemplate(DocumentStream,Report.WordXmlPart(CustomReportLayout."Report ID",true));
        if ValidationErrors <> '' then begin
          if Confirm(TemplateValidationUpdateQst,false,ValidationErrors) then begin
            ValidationErrors := CustomReportLayout.TryUpdateLayout(false);
            Commit;
            exit(true);
          end;
          Error(TemplateValidationErr,ValidationErrors);
        end;
        exit(false);
    end;


    procedure TryUpdateWordLayout(DocumentStream: InStream;var UpdateStream: OutStream;CachedCustomPart: Text;CurrentCustomPart: Text): Text
    var
        NAVWordXMLMerger: dotnet WordReportManager;
    begin
        NAVWordXMLMerger := NAVWordXMLMerger.WordReportManager;
        NAVWordXMLMerger.UpdateWordDocumentLayout(DocumentStream,UpdateStream,CachedCustomPart,CurrentCustomPart,true);
        exit(NAVWordXMLMerger.LastUpdateError);
    end;


    procedure TryUpdateRdlcLayout(reportId: Integer;RdlcStream: InStream;RdlcUpdatedStream: OutStream;CachedCustomPart: Text;CurrentCustomPart: Text;IgnoreDelete: Boolean): Text
    var
        NAVWordXMLMerger: dotnet RdlcReportManager;
    begin
        exit(NAVWordXMLMerger.TryUpdateRdlcLayout(reportId,RdlcStream,RdlcUpdatedStream,
            CachedCustomPart,CurrentCustomPart,IgnoreDelete));
    end;


    procedure NewWordLayout(ReportId: Integer;var DocumentStream: OutStream)
    var
        NAVWordXmlMerger: dotnet WordReportManager;
    begin
        NAVWordXmlMerger.NewWordDocumentLayout(DocumentStream,Report.WordXmlPart(ReportId));
    end;

    local procedure ConvertToPdf(var TempBlob: Record TempBlob)
    var
        TempBlobPdf: Record TempBlob;
        InStreamWordDoc: InStream;
        OutStreamPdfDoc: OutStream;
    begin
        TempBlob.Blob.CreateInstream(InStreamWordDoc);
        TempBlobPdf.Blob.CreateOutstream(OutStreamPdfDoc);

        if TryConvertToPdf(InStreamWordDoc,OutStreamPdfDoc) then
          TempBlob.Blob := TempBlobPdf.Blob
        else
          Error(CompanyInformationPicErr);
    end;

    [TryFunction]
    local procedure TryConvertToPdf(InStreamWordDoc: InStream;OutStreamPdfDoc: OutStream)
    var
        PdfWriter: dotnet WordToPdf;
    begin
        PdfWriter.ConvertToPdf(InStreamWordDoc,OutStreamPdfDoc);
    end;

    local procedure ConvertToHtml(var TempBlob: Record TempBlob)
    var
        TempBlobHtml: Record TempBlob;
        InStreamWordDoc: InStream;
        OutStreamHtmlDoc: OutStream;
        PdfWriter: dotnet WordToPdf;
    begin
        TempBlob.Blob.CreateInstream(InStreamWordDoc);
        TempBlobHtml.Blob.CreateOutstream(OutStreamHtmlDoc);
        PdfWriter.ConvertToHtml(InStreamWordDoc,OutStreamHtmlDoc);
        TempBlob.Blob := TempBlobHtml.Blob;
    end;

    local procedure PrintWordDoc(ReportID: Integer;var TempBlob: Record TempBlob;PrinterName: Text;Collate: Boolean)
    var
        FileMgt: Codeunit "File Management";
    begin
        if FileMgt.IsWindowsClient then
          PrintWordDocInWord(ReportID,TempBlob,PrinterName,Collate,1)
        else
          if FileMgt.IsWebOrDeviceClient then begin
            ConvertToPdf(TempBlob);
            FileMgt.BLOBExport(TempBlob,UserFileName(ReportID,FileTypePdfTxt),true);
          end else
            PrintWordDocOnServer(TempBlob,PrinterName,Collate);
    end;

    local procedure PrintWordDocInWord(ReportID: Integer;TempBlob: Record TempBlob;PrinterName: Text;Collate: Boolean;Copies: Integer)
    var
        FileMgt: Codeunit "File Management";
        [RunOnClient]
        WordApplication: dotnet ApplicationClass0;
        [RunOnClient]
        WordDocument: dotnet Document;
        [RunOnClient]
        WordHelper: dotnet WordHelper;
        FileName: Text;
        T0: DateTime;
    begin
        if GetWordApplication(WordApplication) and not IsNull(WordApplication) then begin
          FileName := StrSubstNo('%1.docx',CreateGuid);
          FileName := FileMgt.BLOBExport(TempBlob,FileName,false);

          WordDocument := WordHelper.CallOpen(WordApplication,FileName,false,false);
          WordHelper.CallPrintOut(WordDocument,PrinterName,Collate,Copies);

          T0 := CurrentDatetime;
          while (WordApplication.BackgroundPrintingStatus > 0) and (CurrentDatetime < T0 + 180000) do
            Sleep(250);
          WordHelper.CallQuit(WordApplication,false);
          if DeleteClientFile(FileName) then;
        end else begin
          if (PrinterName <> '') and IsValidPrinter(PrinterName) then
            PrintWordDocOnServer(TempBlob,PrinterName,Collate) // Don't print on server if the printer has not been setup.
          else
            FileMgt.BLOBExport(TempBlob,UserFileName(ReportID,FileTypeWordTxt),true);
        end;
    end;

    [TryFunction]
    local procedure DeleteClientFile(FileName: Text)
    var
        FileMgt: Codeunit "File Management";
    begin
        FileMgt.DeleteClientFile(FileName);
    end;

    local procedure IsValidPrinter(PrinterName: Text): Boolean
    var
        Printer: Record Printer;
    begin
        Printer.SetFilter(Name,PrinterName);
        Printer.FindFirst;
        exit(not Printer.IsEmpty);
    end;

    [TryFunction]
    local procedure GetWordApplication(var WordApplication: dotnet ApplicationClass0)
    begin
        WordApplication := WordApplication.ApplicationClass;
    end;

    local procedure PrintWordDocOnServer(TempBlob: Record TempBlob;PrinterName: Text;Collate: Boolean)
    var
        PdfWriter: dotnet WordToPdf;
        InStreamWordDoc: InStream;
    begin
        TempBlob.Blob.CreateInstream(InStreamWordDoc);
        PdfWriter.PrintWordDoc(InStreamWordDoc,PrinterName,Collate);
    end;

    local procedure UserFileName(ReportID: Integer;fileExtension: Text): Text
    var
        ReportMetadata: Record "Report Metadata";
        FileManagement: Codeunit "File Management";
    begin
        ReportMetadata.Get(ReportID);
        if fileExtension = '' then
          fileExtension := FileTypeWordTxt;

        exit(FileManagement.GetSafeFileName(ReportMetadata.Caption) + '.' + fileExtension);
    end;


    procedure ApplyUpgradeToReports(var ReportUpgradeCollection: dotnet ReportUpgradeCollection;testOnly: Boolean): Boolean
    var
        CustomReportLayout: Record "Custom Report Layout";
        ReportUpgrade: dotnet ReportUpgradeSet;
        ReportChangeLogCollection: dotnet IReportChangeLogCollection;
    begin
        foreach ReportUpgrade in ReportUpgradeCollection do begin
          CustomReportLayout.SetFilter("Report ID",Format(ReportUpgrade.ReportId));
          if CustomReportLayout.Find('-') then
            repeat
              CustomReportLayout.ApplyUpgrade(ReportUpgrade,ReportChangeLogCollection,testOnly);
            until CustomReportLayout.Next = 0;
        end;

        if IsNull(ReportChangeLogCollection) then begin // Don't break upgrade process with user information
          if (CurrentClientType <> Clienttype::Background) and (CurrentClientType <> Clienttype::Management) then
            Message(NoReportLayoutUpgradeRequiredMsg);

          exit(false);
        end;

        ProcessUpgradeLog(ReportChangeLogCollection);
        exit(ReportChangeLogCollection.Count > 0);
    end;


    procedure CalculateUpgradeChangeSet(var ReportUpgradeCollection: dotnet ReportUpgradeCollection)
    var
        CustomReportLayout: Record "Custom Report Layout";
        ReportUpgradeSet: dotnet IReportUpgradeSet;
    begin
        CustomReportLayout.SetAutocalcFields(CustomReportLayout."Custom XML Part");
        with CustomReportLayout do
          if Find('-') then
            repeat
              ReportUpgradeSet := ReportUpgradeCollection.AddReport("Report ID"); // runtime will load the current XmlPart from metadata
              if not IsNull(ReportUpgradeSet) then
                ReportUpgradeSet.CalculateAutoChangeSet(GetCustomXmlPart);
            until Next <> 1;
    end;

    local procedure ProcessUpgradeLog(var ReportChangeLogCollection: dotnet IReportChangeLogCollection)
    var
        ReportLayoutUpdateLog: Codeunit "Report Layout Update Log";
    begin
        if IsNull(ReportChangeLogCollection) then
          exit;

        if (CurrentClientType <> Clienttype::Background) and (CurrentClientType <> Clienttype::Management) then
          ReportLayoutUpdateLog.ViewLog(ReportChangeLogCollection)
        else
          Message(UpgradeMessageMsg,Format(ReportChangeLogCollection));
    end;


    procedure BulkUpgrade(testMode: Boolean)
    var
        ReportUpgradeCollection: dotnet ReportUpgradeCollection;
    begin
        ReportUpgradeCollection := ReportUpgradeCollection.ReportUpgradeCollection;
        CalculateUpgradeChangeSet(ReportUpgradeCollection);
        ApplyUpgradeToReports(ReportUpgradeCollection,testMode);
    end;


    procedure NewExtensionLayout(ExtensionAppId: Guid;LayoutDataTable: dotnet DataTable)
    var
        Row: dotnet DataRow;
        Version: Text;
    begin
        Row := LayoutDataTable.Rows.Item(0);
        if LayoutDataTable.Columns.Contains('NavApplicationVersion') then
          Version := Row.Item('NavApplicationVersion');

        case Version of
          else
            HandleW10Layout(ExtensionAppId,Row,LayoutDataTable);
        end;
    end;

    local procedure HandleW10Layout(ExtensionAppId: Guid;Row: dotnet DataRow;LayoutDataTable: dotnet DataTable)
    var
        CustomReportLayout: Record "Custom Report Layout";
        IdCounter: Integer;
        LayoutCode: Code[20];
    begin
        IdCounter := 0;
        if not LayoutDataTable.Columns.Contains('Code') then begin
          repeat
            IdCounter := IdCounter + 1;
            CustomReportLayout.SetFilter(Code,StrSubstNo(LayoutCodeTemplateTxt,AutoLayoutCodeTxt,IdCounter));
          until not CustomReportLayout.FindFirst;

          LayoutCode := StrSubstNo(LayoutCodeTemplateTxt,AutoLayoutCodeTxt,IdCounter);
        end else
          LayoutCode := Row.Item('Code');

        CustomReportLayout.Reset;
        CustomReportLayout.Init;
        CustomReportLayout.Code := LayoutCode;
        CustomReportLayout."App ID" := ExtensionAppId;
        CustomReportLayout.Type := Row.Item('Type');
        CustomReportLayout."Custom XML Part" := Row.Item('CustomXMLPart');
        CustomReportLayout.Description := Row.Item('Description');
        CustomReportLayout.Layout := Row.Item('Layout');
        CustomReportLayout."Report ID" := Row.Item('ReportID');
        CustomReportLayout.CalcFields("Report Name");
        CustomReportLayout."Built-In" := true;
        CustomReportLayout.Insert;
    end;
}

