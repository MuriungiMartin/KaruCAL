#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9025 "Small Business Report Catalog"
{

    trigger OnRun()
    begin
    end;

    var
        ToFileNameTxt: label 'DetailTrialBalance.xlsx';


    procedure RunCustomerStatementReport(UseRequestPage: Boolean)
    var
        CustomerStatementReport: Report Statement;
        AccSchedManagement: Codeunit AccSchedManagement;
        NewPrintEntriesDue: Boolean;
        NewPrintAllHavingEntry: Boolean;
        NewPrintAllHavingBal: Boolean;
        NewPrintReversedEntries: Boolean;
        NewPrintUnappliedEntries: Boolean;
        NewIncludeAgingBand: Boolean;
        NewPeriodLength: Text[30];
        NewDateChoice: Option;
        NewLogInteraction: Boolean;
        NewStartDate: Date;
        NewEndDate: Date;
        DateChoice: Option "Due Date","Posting Date";
    begin
        // Use default parameters when you launch the request page, with Start/End Date being the YTD of current financial year
        NewPrintEntriesDue := false;
        NewPrintAllHavingEntry := false;
        NewPrintAllHavingBal := true;
        NewPrintReversedEntries := false;
        NewPrintUnappliedEntries := false;
        NewIncludeAgingBand := false;
        NewPeriodLength := '<1M+CM>';
        NewDateChoice := Datechoice::"Due Date";
        NewLogInteraction := true;

        NewStartDate := AccSchedManagement.FindFiscalYear(WorkDate);
        NewEndDate := WorkDate;

        CustomerStatementReport.InitializeRequest(
          NewPrintEntriesDue,NewPrintAllHavingEntry,NewPrintAllHavingBal,NewPrintReversedEntries,
          NewPrintUnappliedEntries,NewIncludeAgingBand,NewPeriodLength,NewDateChoice,
          NewLogInteraction,NewStartDate,NewEndDate);
        CustomerStatementReport.UseRequestPage(UseRequestPage);
        CustomerStatementReport.Run;
    end;


    procedure RunDetailTrialBalanceReport(UseRequestPage: Boolean)
    var
        DetailTrialBalance: Report "Detail Trial Balance";
        FileMgt: Codeunit "File Management";
        FileName: Text;
        ToFile: Text;
    begin
        DetailTrialBalance.UseRequestPage(UseRequestPage);

        FileName := FileMgt.ServerTempFileName('xlsx');
        // Render report on the server
        DetailTrialBalance.SaveAsExcel(FileName);

        ToFile := ToFileNameTxt;
        Download(FileName,'',FileMgt.Magicpath,'',ToFile);
        Erase(FileName);
    end;
}

