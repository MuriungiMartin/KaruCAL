#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1709 "Exp. External Data Pos. Pay"
{
    Permissions = TableData "Data Exch."=rimd;
    TableNo = "Data Exch.";

    trigger OnRun()
    begin
    end;

    var
        ExternalContentErr: label '%1 is empty.';
        DownloadFromStreamErr: label 'The file has not been saved.';


    procedure CreateExportFile(DataExch: Record "Data Exch.";ShowDialog: Boolean)
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        ExportFileName: Text;
    begin
        DataExch.CalcFields("File Content");
        if not DataExch."File Content".Hasvalue then
          Error(ExternalContentErr,DataExch.FieldCaption("File Content"));

        TempBlob.Blob := DataExch."File Content";
        ExportFileName := DataExch."Data Exch. Def Code" + Format(Today,0,'<Month,2><Day,2><Year4>') + '.txt';
        if FileMgt.BLOBExport(TempBlob,ExportFileName,ShowDialog) = '' then
          Error(DownloadFromStreamErr);
    end;
}

