#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10250 "Bulk Vendor Remit Reporting"
{

    trigger OnRun()
    begin
    end;

    var
        CustomLayoutReporting: Codeunit "Custom Layout Reporting";
        PreviewModeNoExportMsg: label 'Preview mode is enabled for one or more reports. File export will not run for any data.';


    procedure RunWithRecord(var GenJournalLine: Record "Gen. Journal Line")
    var
        ReportSelections: Record "Report Selections";
        Vendor: Record Vendor;
        Customer: Record Customer;
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLineRecRef: RecordRef;
        GenJournalLineFieldName: Text;
        JoinDatabaseNumber: Integer;
        JoinDatabaseFieldName: Text;
    begin
        GenJournalLineRecRef.GetTable(GenJournalLine);
        GenJournalLineRecRef.SetView(GenJournalLine.GetView);

        GenJournalLine.Find('-');
        GenJournalBatch.Get(GenJournalLine."Journal Template Name",GenJournalLine."Journal Batch Name");
        GenJournalBatch.OnCheckGenJournalLineExportRestrictions;

        // Based on the types of the accounts, set up the report layout joins appropriate.
        case GenJournalLine."Bal. Account Type" of
          GenJournalLine."bal. account type"::Vendor:
            begin
              GenJournalLineFieldName := GenJournalLine.FieldName("Bal. Account No.");
              JoinDatabaseNumber := Database::Vendor;
              JoinDatabaseFieldName := Vendor.FieldName("No.");
            end;
          GenJournalLine."bal. account type"::Customer:
            begin
              GenJournalLineFieldName := GenJournalLine.FieldName("Bal. Account No.");
              JoinDatabaseNumber := Database::Customer;
              JoinDatabaseFieldName := Customer.FieldName("No.");
            end;
          GenJournalLine."bal. account type"::"Bank Account":
            case GenJournalLine."Account Type" of
              GenJournalLine."account type"::Customer:
                begin
                  GenJournalLineFieldName := GenJournalLine.FieldName("Account No.");
                  JoinDatabaseNumber := Database::Customer;
                  JoinDatabaseFieldName := Customer.FieldName("No.");
                end;
              GenJournalLine."account type"::Vendor:
                begin
                  GenJournalLineFieldName := GenJournalLine.FieldName("Account No.");
                  JoinDatabaseNumber := Database::Vendor;
                  JoinDatabaseFieldName := Vendor.FieldName("No.");
                end;
            end;
          else
            GenJournalLine.FieldError("Bal. Account No.");
        end;
        // Set up data, request pages, etc.
        CustomLayoutReporting.InitializeData(
          ReportSelections.Usage::"V.Remittance",GenJournalLineRecRef,GenJournalLineFieldName,JoinDatabaseNumber,
          JoinDatabaseFieldName,false);

        // Export to file if we don't have anything in preview mode
        if not PreviewModeSelected then
          SetExportReportOptionsAndExport(GenJournalLine);

        // Run reports
        CustomLayoutReporting.SetOutputFileBaseName('Remittance Advice');
        CustomLayoutReporting.ProcessReport;
    end;

    local procedure PreviewModeSelected(): Boolean
    var
        ReportSelections: Record "Report Selections";
        ReportOutputType: Integer;
        PreviewMode: Boolean;
        FirstLoop: Boolean;
    begin
        // Check to see if any of the associated reports are in 'preview' mode:
        ReportSelections.SetRange(Usage,ReportSelections.Usage::"V.Remittance");

        FirstLoop := true;
        if ReportSelections.Find('-') then
          repeat
            ReportOutputType := CustomLayoutReporting.GetOutputOption(ReportSelections."Report ID");
            // We don't need to test for mixed preview and non-preview in the first loop
            if FirstLoop then begin
              FirstLoop := false;
              PreviewMode := (ReportOutputType = CustomLayoutReporting.GetPreviewOption)
            end else
              // If we have mixed preview and non-preview, then display a message that we're not going to export to file
              if (PreviewMode and (ReportOutputType <> CustomLayoutReporting.GetPreviewOption)) or
                 (not PreviewMode and (ReportOutputType = CustomLayoutReporting.GetPreviewOption))
              then begin
                Message(PreviewModeNoExportMsg);
                PreviewMode := true;
              end;
          until ReportSelections.Next = 0;

        exit(PreviewMode);
    end;

    local procedure SetExportReportOptionsAndExport(var GenJournalLine: Record "Gen. Journal Line")
    var
        ReportSelections: Record "Report Selections";
        ExportElectronicPaymentFile: Report "Export Electronic Payment File";
        BankAccountNo: Code[20];
        SettleDate: Date;
        PostingOption: Integer;
        OptionText: Text;
        OptionCode: Code[20];
    begin
        ReportSelections.SetRange(Usage,ReportSelections.Usage::"V.Remittance");
        if ReportSelections.Find('-') then
          repeat
            // Ensure that the report has valid request parameters before trying to access them and run the export
            if CustomLayoutReporting.HasRequestParameterData(ReportSelections."Report ID") then begin
              // Get the same options from the user-selected options for this export report run
              // Items in the request page XML use the 'Source' as their name
              OptionText :=
                CustomLayoutReporting.GetOptionValueFromRequestPageForReport(ReportSelections."Report ID",'BankAccount."No."');
              OptionCode := CopyStr(OptionText,1,20);
              Evaluate(BankAccountNo,OptionCode);
              OptionText :=
                CustomLayoutReporting.GetOptionValueFromRequestPageForReport(ReportSelections."Report ID",'SettleDate');
              Evaluate(SettleDate,OptionText,9);
              OptionText :=
                CustomLayoutReporting.GetOptionValueFromRequestPageForReport(ReportSelections."Report ID",'PostingDateOption');
              Evaluate(PostingOption,OptionText);
              ExportElectronicPaymentFile.SetOptions(BankAccountNo,SettleDate,PostingOption);

              // Run the report - ignore the direct report output, the report run will export payment files as needed internally
              ExportElectronicPaymentFile.SetTableview(GenJournalLine);
              ExportElectronicPaymentFile.Run;
            end;
          until ReportSelections.Next = 0;
    end;
}

