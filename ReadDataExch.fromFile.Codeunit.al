#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1240 "Read Data Exch. from File"
{
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
    begin
        "File Name" := CopyStr(FileMgt.BLOBImportWithFilter(TempBlob,ImportBankStmtTxt,'',FileFilterTxt,FileFilterExtensionTxt),1,250);
        if "File Name" <> '' then
          "File Content" := TempBlob.Blob;
    end;

    var
        ImportBankStmtTxt: label 'Select a file to import';
        FileFilterTxt: label 'All Files(*.*)|*.*|XML Files(*.xml)|*.xml|Text Files(*.txt;*.csv;*.asc)|*.txt;*.csv;*.asc,*.nda';
        FileFilterExtensionTxt: label 'txt,csv,asc,xml,nda', Locked=true;
}

