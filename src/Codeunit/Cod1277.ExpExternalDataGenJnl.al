#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1277 "Exp. External Data Gen. Jnl."
{
    Permissions = TableData "Data Exch."=rimd;
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
    begin
        CalcFields("File Content");
        if not "File Content".Hasvalue then
          Error(ExternalContentErr,FieldCaption("File Content"));

        TempBlob.Blob := "File Content";
        if FileMgt.BLOBExport(TempBlob,"Data Exch. Def Code" + ' ' + "Data Exch. Line Def Code" + TxtExtTok,true) = '' then
          Error(DownloadFromStreamErr);
    end;

    var
        ExternalContentErr: label '%1 is empty.';
        DownloadFromStreamErr: label 'The file has not been saved.';
        TxtExtTok: label '.txt', Locked=true;
}

