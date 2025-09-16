#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1202 "Import Payroll Transaction"
{
    Permissions = TableData "Data Exch."=rimd;

    trigger OnRun()
    begin
    end;

    var
        FileMgt: Codeunit "File Management";
        ImportPayrollTransCap: label 'Select Payroll Transaction';
        FileFilterTxt: label 'Text Files(*.txt;*.csv)|*.txt;*.csv';
        FileFilterExtensionTxt: label 'txt,csv', Locked=true;
        ProcessingSetupErr: label 'You must specify either a reading/writing XMLport or a reading/writing codeunit.';


    procedure SelectAndImportPayrollDataToGL(var GenJournalLine: Record "Gen. Journal Line";DataExchDefCode: Code[20])
    var
        TempBlob: Record TempBlob;
        FileName: Text;
    begin
        FileName := FileMgt.BLOBImportWithFilter(TempBlob,ImportPayrollTransCap,'',FileFilterTxt,FileFilterExtensionTxt);
        if FileName <> '' then
          ImportPayrollDataToGL(GenJournalLine,FileName,TempBlob,DataExchDefCode);
    end;


    procedure ImportPayrollDataToGL(GenJournalLine: Record "Gen. Journal Line";FileName: Text;TempBlob: Record TempBlob;DataExchDefCode: Code[20])
    var
        GenJournalLineTemplate: Record "Gen. Journal Line";
        DataExch: Record "Data Exch.";
        DataExchDef: Record "Data Exch. Def";
    begin
        DataExchDef.Get(DataExchDefCode);
        if (DataExchDef."Reading/Writing XMLport" <> 0) = (DataExchDef."Reading/Writing Codeunit" <> 0) then
          Error(ProcessingSetupErr);

        PrepareGenJournalLine(GenJournalLineTemplate,GenJournalLine);
        CreateDataExch(DataExch,FileName,TempBlob,DataExchDefCode);
        ImportPayrollFile(DataExch);
        MapDataToGenJournalLine(DataExch,GenJournalLineTemplate);
    end;

    local procedure CreateDataExch(var DataExch: Record "Data Exch.";FileName: Text;TempBlob: Record TempBlob;DataExchDefCode: Code[20])
    var
        Source: InStream;
    begin
        TempBlob.Blob.CreateInstream(Source);
        DataExch.InsertRec(CopyStr(FileName,1,MaxStrLen(DataExch."File Name")),Source,DataExchDefCode);
    end;

    local procedure ImportPayrollFile(DataExch: Record "Data Exch.")
    var
        DataExchDef: Record "Data Exch. Def";
        Source: InStream;
    begin
        DataExch."File Content".CreateInstream(Source);
        DataExch.SetRange("Entry No.",DataExch."Entry No.");
        DataExchDef.Get(DataExch."Data Exch. Def Code");
        if DataExchDef."Reading/Writing XMLport" <> 0 then
          Xmlport.Import(DataExchDef."Reading/Writing XMLport",Source,DataExch)
        else
          if DataExchDef."Reading/Writing Codeunit" <> 0 then
            Codeunit.Run(DataExchDef."Reading/Writing Codeunit",DataExch);
    end;

    local procedure MapDataToGenJournalLine(DataExch: Record "Data Exch.";GenJournalLineTemplate: Record "Gen. Journal Line")
    var
        ProcessDataExch: Codeunit "Process Data Exch.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(GenJournalLineTemplate);
        ProcessDataExch.ProcessAllLinesColumnMapping(DataExch,RecRef);
    end;

    local procedure PrepareGenJournalLine(var GenJournalLineTemplate: Record "Gen. Journal Line";GenJournalLine: Record "Gen. Journal Line")
    begin
        with GenJournalLineTemplate do begin
          "Journal Template Name" := GenJournalLine."Journal Template Name";
          "Journal Batch Name" := GenJournalLine."Journal Batch Name";
          SetUpNewLine(GenJournalLine,GenJournalLine."Balance (LCY)",true);
          "Account Type" := "account type"::"G/L Account";

          GenJournalLine.SetRange("Journal Template Name",GenJournalLine."Journal Template Name");
          GenJournalLine.SetRange("Journal Batch Name",GenJournalLine."Journal Batch Name");
          if GenJournalLine.FindLast then begin
            "Line No." := GenJournalLine."Line No.";
            "Document No." := IncStr(GenJournalLine."Document No.");
          end else
            "Document No." := GenJournalLine."Document No.";
        end;
    end;
}

