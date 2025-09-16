#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9652 "Edit RDLC Report Layout"
{
    TableNo = "Custom Report Layout";

    trigger OnRun()
    begin
        EditReportLayout(Rec);
    end;

    var
        LoadDocQst: label 'The report layout has been opened in SQL Report Builder.\\Edit the report layout in SQL Report Builder and save the changes. Then return to this message and choose Yes to import the changes or No to cancel the changes.\Do you want to import the changes?';
        NoReportBuilderPresentErr: label 'Microsoft Report Builder is not installed on this computer.';

    local procedure EditReportLayout(var CustomReportLayout: Record "Custom Report Layout")
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        [RunOnClient]
        Process: dotnet Process;
        FileName: Text;
        RBFileName: Text;
        LoadModifiedDoc: Boolean;
    begin
        CustomReportLayout.CalcFields(Layout);
        CustomReportLayout.TestField(Layout);

        RBFileName := GetReportBuilderExe;
        if RBFileName = '' then
          Error(NoReportBuilderPresentErr);

        TempBlob.Init;
        TempBlob.Blob := CustomReportLayout.Layout;

        FileName := FileMgt.BLOBExport(TempBlob,'report.rdl',false);

        Process := Process.Start(RBFileName,'"' + FileName + '"');

        LoadModifiedDoc := Confirm(LoadDocQst);

        if LoadModifiedDoc then begin
          FileMgt.BLOBImport(TempBlob,FileName);
          CustomReportLayout.ImportLayoutBlob(TempBlob,'');
        end;

        if not Process.HasExited then
          Process.CloseMainWindow;

        FileMgt.DeleteClientFile(FileName);
    end;

    local procedure GetReportBuilderExe(): Text
    var
        [RunOnClient]
        Registry: dotnet Registry;
        FileName: Text;
        i: Integer;
    begin
        FileName := Registry.GetValue('HKEY_CLASSES_ROOT\MSReportBuilder_ReportFile_32\shell\Open\command','','');
        i := StrPos(UpperCase(FileName),'.EXE');
        if i > 0 then
          FileName := DelChr(PadStr(FileName,i + 3),'>')
        else
          FileName := '';

        exit(FileName);
    end;
}

