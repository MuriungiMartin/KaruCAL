#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9991 "Code Coverage Setup"
{
    Caption = 'Code Coverage Setup';
    SaveValues = true;

    layout
    {
        area(content)
        {
            field("<TimeInterval>";TimeInterval)
            {
                ApplicationArea = Basic;
                Caption = 'Time Interval (minutes)';

                trigger OnValidate()
                var
                    DefaultTimeIntervalInt: Integer;
                begin
                    Evaluate(DefaultTimeIntervalInt,DefaultTimeIntervalInMinutesTxt);
                    if TimeInterval < DefaultTimeIntervalInt then
                      Error(TimeIntervalErr);

                    CodeCoverageMgt.UpdateAutomaticBackupSettings(TimeInterval,BackupPath,SummaryPath);
                    Message(AppliedSettingsSuccesfullyMsg);
                end;
            }
            field("<BackupPath>";BackupPath)
            {
                ApplicationArea = Basic;
                Caption = 'Backup Path';

                trigger OnAssistEdit()
                begin
                    BackupPath := GetFolder;
                    if BackupPath = '' then
                      Error(BackupPathErr);

                    CodeCoverageMgt.UpdateAutomaticBackupSettings(TimeInterval,BackupPath,SummaryPath);
                    Message(AppliedSettingsSuccesfullyMsg);
                end;

                trigger OnValidate()
                begin
                    if BackupPath = '' then
                      Error(BackupPathErr);

                    CodeCoverageMgt.UpdateAutomaticBackupSettings(TimeInterval,BackupPath,SummaryPath);
                    Message(AppliedSettingsSuccesfullyMsg);
                end;
            }
            field("<SummaryPath>";SummaryPath)
            {
                ApplicationArea = Basic;
                Caption = 'Summary Path';

                trigger OnAssistEdit()
                begin
                    SummaryPath := GetFolder;
                    if SummaryPath = '' then
                      Error(SummaryPathErr);

                    CodeCoverageMgt.UpdateAutomaticBackupSettings(TimeInterval,BackupPath,SummaryPath);
                    Message(AppliedSettingsSuccesfullyMsg);
                end;

                trigger OnValidate()
                begin
                    if SummaryPath = '' then
                      Error(SummaryPathErr);

                    CodeCoverageMgt.UpdateAutomaticBackupSettings(TimeInterval,BackupPath,SummaryPath);
                    Message(AppliedSettingsSuccesfullyMsg);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetDefaultValues;
        CodeCoverageMgt.StartAutomaticBackup(TimeInterval,BackupPath,SummaryPath);
    end;

    var
        CodeCoverageMgt: Codeunit "Code Coverage Mgt.";
        TimeInterval: Integer;
        BackupPath: Text[1024];
        SummaryPath: Text[1024];
        AppliedSettingsSuccesfullyMsg: label 'Automatic Backup settings applied successfully.';
        BackupPathErr: label 'Backup Path must have a value.';
        DefaultTimeIntervalInMinutesTxt: label '10';
        SummaryPathErr: label 'Summary Path must have a value.';
        TimeIntervalErr: label 'The time interval must be greater than or equal to 10.';


    procedure GetFolder(): Text[1024]
    var
        [RunOnClient]
        FolderBrowserDialog: dotnet FolderBrowserDialog;
    begin
        FolderBrowserDialog := FolderBrowserDialog.FolderBrowserDialog;
        FolderBrowserDialog.ShowNewFolderButton(true);
        FolderBrowserDialog.Description('Select Folder');
        FolderBrowserDialog.ShowDialog;
        if FolderBrowserDialog.SelectedPath <> '' then
          exit(FolderBrowserDialog.SelectedPath + '\')
    end;


    procedure SetDefaultValues()
    begin
        // Set default values for automatic backups settings, in case they don't exist
        if TimeInterval < 10 then
          Evaluate(TimeInterval,DefaultTimeIntervalInMinutesTxt);
        if BackupPath = '' then
          BackupPath := ApplicationPath;
        if SummaryPath = '' then
          SummaryPath := ApplicationPath;
    end;
}

