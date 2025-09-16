#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9650 "Edit MS Word Report Layout"
{
    TableNo = "Custom Report Layout";

    trigger OnRun()
    begin
        EditReportLayout(Rec);
    end;

    var
        LoadDocQst: label 'The report layout document has been edited in Word.\\Do you want to import the changes?';
        WordNotFoundErr: label 'You cannot edit the report layout because Microsoft Word is not available on your computer. To edit the report layout, you must install a supported version of Word.';
        WaitMsg: label 'Please wait while the report layout opens in Word.\After the report layout opens in Word, make changes to the layout,\and then close the Word document to continue.';
        Window: Dialog;

    local procedure EditReportLayout(var CustomReportLayout: Record "Custom Report Layout")
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        [RunOnClient]
        WordApplication: dotnet ApplicationClass0;
        [RunOnClient]
        WordDocument: dotnet Document;
        [RunOnClient]
        WdWindowState: dotnet WdWindowState;
        [RunOnClient]
        WordHelper: dotnet WordHelper;
        [RunOnClient]
        WordHandler: dotnet WordHandler;
        FileName: Text;
        NewFileName: Text;
        ErrorMessage: Text;
        LoadModifiedDoc: Boolean;
    begin
        CustomReportLayout.CalcFields(Layout);
        CustomReportLayout.TestField(Layout);

        if not CanLoadType(WordApplication) then
          Error(WordNotFoundErr);

        Window.Open(WaitMsg);

        TempBlob.Init;
        TempBlob.Blob := CustomReportLayout.Layout;
        FileName := FileMgt.BLOBExport(TempBlob,FileName,false);

        WordApplication := WordHelper.GetApplication(ErrorMessage);
        if IsNull(WordApplication) then
          Error(WordNotFoundErr);

        // Open word and wait for the document to be closed
        WordHandler := WordHandler.WordHandler;
        WordDocument := WordHelper.CallOpen(WordApplication,FileName,false,false);
        WordDocument.ActiveWindow.Caption := CustomReportLayout."Report Name" + ' ' + CustomReportLayout.Description;
        WordDocument.Application.Visible := true; // Visible before WindowState KB176866 - http://support.microsoft.com/kb/176866
        WordDocument.ActiveWindow.WindowState := WdWindowState.wdWindowStateNormal;

        // Push the word app to foreground
        WordApplication.WindowState := WdWindowState.wdWindowStateMinimize;
        WordApplication.Visible := true;
        WordApplication.Activate;
        WordApplication.WindowState := WdWindowState.wdWindowStateNormal;

        WordDocument.Saved := true;
        WordDocument.Application.Activate;

        NewFileName := WordHandler.WaitForDocument(WordDocument);
        Window.Close;
        Clear(WordApplication);

        LoadModifiedDoc := Confirm(LoadDocQst);

        if LoadModifiedDoc then begin
          FileMgt.BLOBImport(TempBlob,NewFileName);
          CustomReportLayout.ImportLayoutBlob(TempBlob,'');
        end;

        FileMgt.DeleteClientFile(FileName);
        if FileName <> NewFileName then
          FileMgt.DeleteClientFile(NewFileName);
    end;
}

