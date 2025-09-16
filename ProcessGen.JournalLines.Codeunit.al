#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1247 "Process Gen. Journal  Lines"
{
    Permissions = TableData "Data Exch."=rimd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        ProcessDataExch: Codeunit "Process Data Exch.";
        RecRef: RecordRef;
    begin
        DataExch.Get("Data Exch. Entry No.");
        RecRef.GetTable(Rec);
        ProcessDataExch.ProcessAllLinesColumnMapping(DataExch,RecRef);
    end;

    var
        ProgressWindowMsg: label 'Please wait while the operation is being completed.';


    procedure ImportBankStatement(GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        BankAcc: Record "Bank Account";
        BankExportImportSetup: Record "Bank Export/Import Setup";
        DataExchDef: Record "Data Exch. Def";
        DataExchMapping: Record "Data Exch. Mapping";
        DataExchLineDef: Record "Data Exch. Line Def";
        DataExch: Record "Data Exch.";
        GenJnlLineTemplate: Record "Gen. Journal Line";
        ProgressWindow: Dialog;
    begin
        GenJnlBatch.Get(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");

        case GenJnlBatch."Bal. Account Type" of
          GenJnlBatch."bal. account type"::"Bank Account":
            begin
              GenJnlBatch.TestField("Bal. Account No.");
              BankAcc.Get(GenJnlBatch."Bal. Account No.");
              BankAcc.GetDataExchDef(DataExchDef);
            end;
          GenJnlBatch."bal. account type"::"G/L Account":
            begin
              GenJnlBatch.TestField("Bank Statement Import Format");
              BankExportImportSetup.Get(GenJnlBatch."Bank Statement Import Format");
              BankExportImportSetup.TestField("Data Exch. Def. Code");
              DataExchDef.Get(BankExportImportSetup."Data Exch. Def. Code");
              DataExchDef.TestField(Type,DataExchDef.Type::"Bank Statement Import");
            end;
          else
            GenJnlBatch.FieldError("Bal. Account Type");
        end;
        CreateGeneralJournalLineTemplate(GenJnlLineTemplate,GenJnlLine);

        if not DataExch.ImportToDataExch(DataExchDef)then
          exit;

        GenJnlLineTemplate."Data Exch. Entry No." := DataExch."Entry No.";

        ProgressWindow.Open(ProgressWindowMsg);

        DataExchLineDef.SetRange("Data Exch. Def Code",DataExchDef.Code);
        DataExchLineDef.FindFirst;

        DataExchMapping.Get(DataExchDef.Code,DataExchLineDef.Code,Database::"Gen. Journal Line");
        DataExchMapping.TestField("Mapping Codeunit");
        Codeunit.Run(DataExchMapping."Mapping Codeunit",GenJnlLineTemplate);

        UpdateGenJournalLines(GenJnlLineTemplate);

        ProgressWindow.Close;
    end;

    local procedure CreateGeneralJournalLineTemplate(var GenJournalLineTemplate: Record "Gen. Journal Line";GenJournalLine: Record "Gen. Journal Line")
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

    local procedure UpdateGenJournalLines(var GenJournalLineTemplate: Record "Gen. Journal Line")
    var
        GenJournalLine: Record "Gen. Journal Line";
        DocNo: Code[20];
    begin
        GenJournalLine.SetRange("Journal Template Name",GenJournalLineTemplate."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name",GenJournalLineTemplate."Journal Batch Name");
        GenJournalLine.SetFilter("Line No.",'>%1',GenJournalLineTemplate."Line No.");
        if GenJournalLine.FindSet then begin
          DocNo := GenJournalLineTemplate."Document No.";
          repeat
            GenJournalLine.Validate("Document No.",DocNo);
            GenJournalLine.Modify(true);
            DocNo := IncStr(DocNo);
          until GenJournalLine.Next = 0;
        end;
    end;
}

