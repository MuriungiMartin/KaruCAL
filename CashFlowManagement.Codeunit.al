#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 841 "Cash Flow Management"
{

    trigger OnRun()
    begin
    end;

    var
        SourceDataDoesNotExistErr: label 'Source data does not exist for %1: %2.', Comment='Source data doesn''t exist for G/L Account: 8210.';
        SourceDataDoesNotExistInfoErr: label 'Source data does not exist in %1 for %2: %3.', Comment='Source data doesn''t exist in Vendor Ledger Entry for Document No.: PO000123.';
        SourceTypeNotSupportedErr: label 'Source type is not supported.';
        DefaultTxt: label 'Default';
        DummyDate: Date;
        CashFlowTxt: label 'CashFlow';
        CashFlowForecastTxt: label 'Cash Flow Forecast';
        CashFlowAbbreviationTxt: label 'CF', Comment='Abbreviation of Cash Flow';
        UpdatingMsg: label 'Updating Cash Flow Forecast...';


    procedure ShowSourceDocument(CFVariant: Variant)
    var
        CFRecordRef: RecordRef;
    begin
        CFRecordRef.GetTable(CFVariant);
        case CFRecordRef.Number of
          Database::"Cash Flow Worksheet Line":
            ShowSourceLocalCFWorkSheetLine(true,CFVariant);
          Database::"Cash Flow Forecast Entry":
            ShowSourceLocalCFEntry(true,CFVariant);
        end;
    end;


    procedure ShowSource(CFVariant: Variant)
    var
        CFRecordRef: RecordRef;
    begin
        CFRecordRef.GetTable(CFVariant);
        case CFRecordRef.Number of
          Database::"Cash Flow Worksheet Line":
            ShowSourceLocalCFWorkSheetLine(false,CFVariant);
          Database::"Cash Flow Forecast Entry":
            ShowSourceLocalCFEntry(false,CFVariant);
        end;
    end;

    local procedure ShowSourceLocalCFWorkSheetLine(ShowDocument: Boolean;CFVariant: Variant)
    var
        CashFlowWorksheetLine: Record "Cash Flow Worksheet Line";
    begin
        CashFlowWorksheetLine := CFVariant;
        CashFlowWorksheetLine.TestField("Source Type");
        if CashFlowWorksheetLine."Source Type" <> CashFlowWorksheetLine."source type"::Tax then
          CashFlowWorksheetLine.TestField("Source No.");
        if CashFlowWorksheetLine."Source Type" = CashFlowWorksheetLine."source type"::"G/L Budget" then
          CashFlowWorksheetLine.TestField("G/L Budget Name");

        ShowSourceLocal(ShowDocument,
          CashFlowWorksheetLine."Source Type",
          CashFlowWorksheetLine."Source No.",
          CashFlowWorksheetLine."G/L Budget Name",
          CashFlowWorksheetLine."Document Date",
          CashFlowWorksheetLine."Document No.");
    end;

    local procedure ShowSourceLocalCFEntry(ShowDocument: Boolean;CFVariant: Variant)
    var
        CashFlowForecastEntry: Record "Cash Flow Forecast Entry";
    begin
        CashFlowForecastEntry := CFVariant;
        CashFlowForecastEntry.TestField("Source Type");
        if CashFlowForecastEntry."Source Type" <> CashFlowForecastEntry."source type"::Tax then
          CashFlowForecastEntry.TestField("Source No.");
        if CashFlowForecastEntry."Source Type" = CashFlowForecastEntry."source type"::"G/L Budget" then
          CashFlowForecastEntry.TestField("G/L Budget Name");

        ShowSourceLocal(ShowDocument,
          CashFlowForecastEntry."Source Type",
          CashFlowForecastEntry."Source No.",
          CashFlowForecastEntry."G/L Budget Name",
          CashFlowForecastEntry."Cash Flow Date",
          CashFlowForecastEntry."Document No.");
    end;

    local procedure ShowSourceLocal(ShowDocument: Boolean;SourceType: Integer;SourceNo: Code[20];BudgetName: Code[10];DocumentDate: Date;DocumentNo: Code[20])
    var
        CFWorksheetLine: Record "Cash Flow Worksheet Line";
    begin
        case SourceType of
          CFWorksheetLine."source type"::"Liquid Funds":
            ShowLiquidFunds(SourceNo,ShowDocument);
          CFWorksheetLine."source type"::Receivables:
            ShowCustomer(SourceNo,ShowDocument);
          CFWorksheetLine."source type"::Payables:
            ShowVendor(SourceNo,ShowDocument);
          CFWorksheetLine."source type"::"Sales Orders":
            ShowSO(SourceNo);
          CFWorksheetLine."source type"::"Purchase Orders":
            ShowPO(SourceNo);
          CFWorksheetLine."source type"::"Service Orders":
            ShowServO(SourceNo);
          CFWorksheetLine."source type"::"Cash Flow Manual Revenue":
            ShowManualRevenue(SourceNo);
          CFWorksheetLine."source type"::"Cash Flow Manual Expense":
            ShowManualExpense(SourceNo);
          CFWorksheetLine."source type"::"Fixed Assets Budget",
          CFWorksheetLine."source type"::"Fixed Assets Disposal":
            ShowFA(SourceNo);
          CFWorksheetLine."source type"::"G/L Budget":
            ShowGLBudget(BudgetName,SourceNo);
          CFWorksheetLine."source type"::Job:
            ShowJob(SourceNo,DocumentDate,DocumentNo);
          CFWorksheetLine."source type"::Tax:
            ShowTax(SourceNo,DocumentDate);
          CFWorksheetLine."source type"::"Cortana Intelligence":
            ShowCortanaIntelligenceForecast;
          else
            Error(SourceTypeNotSupportedErr);
        end;
    end;

    local procedure ShowLiquidFunds(SourceNo: Code[20];ShowDocument: Boolean)
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.SetRange("No.",SourceNo);
        if not GLAccount.FindFirst then
          Error(SourceDataDoesNotExistErr,GLAccount.TableCaption,SourceNo);
        if ShowDocument then
          Page.Run(Page::"G/L Account Card",GLAccount)
        else
          Page.Run(Page::"Chart of Accounts",GLAccount);
    end;

    local procedure ShowCustomer(SourceNo: Code[20];ShowDocument: Boolean)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetRange("Document No.",SourceNo);
        if not CustLedgEntry.FindFirst then
          Error(SourceDataDoesNotExistInfoErr,CustLedgEntry.TableCaption,CustLedgEntry.FieldCaption("Document No."),SourceNo);
        if ShowDocument then
          CustLedgEntry.ShowDoc
        else
          Page.Run(0,CustLedgEntry);
    end;

    local procedure ShowVendor(SourceNo: Code[20];ShowDocument: Boolean)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.SetRange("Document No.",SourceNo);
        if not VendLedgEntry.FindFirst then
          Error(SourceDataDoesNotExistInfoErr,VendLedgEntry.TableCaption,VendLedgEntry.FieldCaption("Document No."),SourceNo);
        if ShowDocument then
          VendLedgEntry.ShowDoc
        else
          Page.Run(0,VendLedgEntry);
    end;

    local procedure ShowSO(SourceNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
        SalesHeader.SetRange("Document Type",SalesHeader."document type"::Order);
        SalesHeader.SetRange("No.",SourceNo);
        if not SalesHeader.FindFirst then
          Error(SourceDataDoesNotExistErr,SalesOrder.Caption,SourceNo);
        SalesOrder.SetTableview(SalesHeader);
        SalesOrder.Run;
    end;

    local procedure ShowPO(SourceNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseOrder: Page "Purchase Order";
    begin
        PurchaseHeader.SetRange("Document Type",PurchaseHeader."document type"::Order);
        PurchaseHeader.SetRange("No.",SourceNo);
        if not PurchaseHeader.FindFirst then
          Error(SourceDataDoesNotExistErr,PurchaseOrder.Caption,SourceNo);
        PurchaseOrder.SetTableview(PurchaseHeader);
        PurchaseOrder.Run;
    end;

    local procedure ShowServO(SourceNo: Code[20])
    var
        ServiceHeader: Record "Service Header";
        ServiceOrder: Page "Service Order";
    begin
        ServiceHeader.SetRange("Document Type",ServiceHeader."document type"::Order);
        ServiceHeader.SetRange("No.",SourceNo);
        if not ServiceHeader.FindFirst then
          Error(SourceDataDoesNotExistErr,ServiceOrder.Caption,SourceNo);
        ServiceOrder.SetTableview(ServiceHeader);
        ServiceOrder.Run;
    end;

    local procedure ShowManualRevenue(SourceNo: Code[20])
    var
        CFManualRevenue: Record "Cash Flow Manual Revenue";
        CFManualRevenues: Page "Cash Flow Manual Revenues";
    begin
        CFManualRevenue.SetRange(Code,SourceNo);
        if not CFManualRevenue.FindFirst then
          Error(SourceDataDoesNotExistErr,CFManualRevenues.Caption,SourceNo);
        CFManualRevenues.SetTableview(CFManualRevenue);
        CFManualRevenues.Run;
    end;

    local procedure ShowManualExpense(SourceNo: Code[20])
    var
        CFManualExpense: Record "Cash Flow Manual Expense";
        CFManualExpenses: Page "Cash Flow Manual Expenses";
    begin
        CFManualExpense.SetRange(Code,SourceNo);
        if not CFManualExpense.FindFirst then
          Error(SourceDataDoesNotExistErr,CFManualExpenses.Caption,SourceNo);
        CFManualExpenses.SetTableview(CFManualExpense);
        CFManualExpenses.Run;
    end;

    local procedure ShowFA(SourceNo: Code[20])
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.SetRange("No.",SourceNo);
        if not FixedAsset.FindFirst then
          Error(SourceDataDoesNotExistInfoErr,FixedAsset.TableCaption,FixedAsset.FieldCaption("No."),SourceNo);
        Page.Run(Page::"Fixed Asset Card",FixedAsset);
    end;

    local procedure ShowGLBudget(BudgetName: Code[10];SourceNo: Code[20])
    var
        GLBudgetName: Record "G/L Budget Name";
        GLAccount: Record "G/L Account";
        Budget: Page Budget;
    begin
        if not GLAccount.Get(SourceNo) then
          Error(SourceDataDoesNotExistErr,GLAccount.TableCaption,SourceNo);
        if not GLBudgetName.Get(BudgetName) then
          Error(SourceDataDoesNotExistErr,GLBudgetName.TableCaption,BudgetName);
        Budget.SetBudgetName(BudgetName);
        Budget.SetGLAccountFilter(SourceNo);
        Budget.Run;
    end;

    local procedure ShowCortanaIntelligenceForecast()
    begin
    end;


    procedure CashFlowName(CashFlowNo: Code[20]): Text[50]
    var
        CashFlowForecast: Record "Cash Flow Forecast";
    begin
        if CashFlowForecast.Get(CashFlowNo) then
          exit(CashFlowForecast.Description);
        exit('')
    end;


    procedure CashFlowAccountName(CashFlowAccountNo: Code[20]): Text[50]
    var
        CashFlowAccount: Record "Cash Flow Account";
    begin
        if CashFlowAccount.Get(CashFlowAccountNo) then
          exit(CashFlowAccount.Name);
        exit('')
    end;

    local procedure ShowJob(SourceNo: Code[20];DocumentDate: Date;DocumentNo: Code[20])
    var
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLines: Page "Job Planning Lines";
    begin
        JobPlanningLine.SetRange("Job No.",SourceNo);
        JobPlanningLine.SetRange("Document Date",DocumentDate);
        JobPlanningLine.SetRange("Document No.",DocumentNo);
        JobPlanningLine.SetFilter("Line Type",
          StrSubstNo('%1|%2',
            JobPlanningLine."line type"::Billable,
            JobPlanningLine."line type"::"Both Budget and Billable"));
        if not JobPlanningLine.FindFirst then
          Error(SourceDataDoesNotExistErr,JobPlanningLines.Caption,SourceNo);
        JobPlanningLines.SetTableview(JobPlanningLine);
        JobPlanningLines.Run;
    end;

    local procedure ShowTax(SourceNo: Code[20];TaxPayableDate: Date)
    var
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        VATEntry: Record "VAT Entry";
        SalesOrderList: Page "Sales Order List";
        PurchaseOrderList: Page "Purchase Order List";
        SourceNum: Integer;
    begin
        Evaluate(SourceNum,SourceNo);
        case SourceNum of
          Database::"Purchase Header":
            begin
              SetViewOnPurchaseHeaderForTaxCalc(PurchaseHeader,TaxPayableDate);
              PurchaseOrderList.SkipShowingLinesWithoutVAT;
              PurchaseOrderList.SetTableview(PurchaseHeader);
              PurchaseOrderList.Run;
            end;
          Database::"Sales Header":
            begin
              SetViewOnSalesHeaderForTaxCalc(SalesHeader,TaxPayableDate);
              SalesOrderList.SkipShowingLinesWithoutVAT;
              SalesOrderList.SetTableview(SalesHeader);
              SalesOrderList.Run;
            end;
          Database::"VAT Entry":
            begin
              SetViewOnVATEntryForTaxCalc(VATEntry,TaxPayableDate);
              Page.Run(Page::"VAT Entries",VATEntry);
            end;
        end;
    end;


    procedure RecurrenceToRecurringFrequency(Recurrence: Option " ",Daily,Weekly,Monthly,Quarterly,Yearly) RecurringFrequency: Text
    begin
        case Recurrence of
          Recurrence::Daily:
            RecurringFrequency := '1D';
          Recurrence::Weekly:
            RecurringFrequency := '1W';
          Recurrence::Monthly:
            RecurringFrequency := '1M';
          Recurrence::Quarterly:
            RecurringFrequency := '1Q';
          Recurrence::Yearly:
            RecurringFrequency := '1Y';
          else
            RecurringFrequency := '';
        end;
    end;


    procedure RecurringFrequencyToRecurrence(RecurringFrequency: DateFormula;var RecurrenceOut: Option " ",Daily,Weekly,Monthly,Quarterly,Yearly)
    begin
        case Format(RecurringFrequency) of
          '1D':
            RecurrenceOut := Recurrenceout::Daily;
          '1W':
            RecurrenceOut := Recurrenceout::Weekly;
          '1M':
            RecurrenceOut := Recurrenceout::Monthly;
          '1Q':
            RecurrenceOut := Recurrenceout::Quarterly;
          '1Y':
            RecurrenceOut := Recurrenceout::Yearly;
          else
            RecurrenceOut := Recurrenceout::" ";
        end;
    end;


    procedure CreateAndStartJobQueueEntry(UpdateFrequency: Option Never,Daily,Weekly)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with JobQueueEntry do begin
          SetRange("Object Type to Run","object type to run"::Codeunit);
          SetRange("Object ID to Run",Codeunit::"Cash Flow Forecast Update");
          if not IsEmpty then
            exit;

          Init;
          Validate("Object Type to Run","object type to run"::Codeunit);
          Validate("Object ID to Run",Codeunit::"Cash Flow Forecast Update");
          "Earliest Start Date/Time" := CurrentDatetime;
          if UpdateFrequency <> Updatefrequency::Never then begin
            Validate("Run on Mondays",true);
            Validate("Run on Tuesdays",true);
            Validate("Run on Wednesdays",true);
            Validate("Run on Thursdays",true);
            Validate("Run on Fridays",true);
            Validate("Run on Saturdays",true);
            Validate("Run on Sundays",true);
            case UpdateFrequency of
              Updatefrequency::Daily:
                "No. of Minutes between Runs" := 24 * 60;
              Updatefrequency::Weekly:
                "No. of Minutes between Runs" := 24 * 60 * 7;
            end;
          end;
          "Maximum No. of Attempts to Run" := 3;
          Priority := 1000;
          "Notify On Success" := true;
          Status := Status::"On Hold";
          Insert(true);
        end;
        Codeunit.Run(Codeunit::"Job Queue - Enqueue",JobQueueEntry);
    end;


    procedure DeleteJobQueueEntries()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with JobQueueEntry do begin
          SetRange("Object Type to Run","object type to run"::Codeunit);
          SetRange("Object ID to Run",Codeunit::"Cash Flow Forecast Update");
          if FindSet then
            repeat
              if Status = Status::"In Process" then begin
                // Non-recurring jobs will be deleted after execution has completed.
                "Recurring Job" := false;
                Modify;
              end else
                Delete;
            until Next = 0;
        end;
    end;


    procedure GetCashAccountFilter() CashAccountFilter: Text
    var
        GLAccountCategory: Record "G/L Account Category";
    begin
        GLAccountCategory.SetRange("Additional Report Definition",GLAccountCategory."additional report definition"::"Cash Accounts");
        if not GLAccountCategory.FindSet then
          exit;

        CashAccountFilter := GLAccountCategory.GetTotaling;

        while GLAccountCategory.Next <> 0 do
          CashAccountFilter += '|' + GLAccountCategory.GetTotaling;
    end;


    procedure SetupCashFlow(LiquidFundsGLAccountFilter: Code[250])
    var
        CashFlowNoSeriesCode: Code[10];
    begin
        DeleteExistingSetup;
        CreateCashFlowAccounts(LiquidFundsGLAccountFilter);
        CashFlowNoSeriesCode := CreateCashFlowNoSeries;
        CreateCashFlowSetup(CashFlowNoSeriesCode);
        CreateCashFlowForecast;
        CreateCashFlowChartSetup;
        CreateCashFlowReportSelection;
    end;

    local procedure DeleteExistingSetup()
    var
        CashFlowForecast: Record "Cash Flow Forecast";
        CashFlowAccount: Record "Cash Flow Account";
        CashFlowAccountComment: Record "Cash Flow Account Comment";
        CashFlowSetup: Record "Cash Flow Setup";
        CashFlowWorksheetLine: Record "Cash Flow Worksheet Line";
        CashFlowForecastEntry: Record "Cash Flow Forecast Entry";
        CashFlowManualRevenue: Record "Cash Flow Manual Revenue";
        CashFlowManualExpense: Record "Cash Flow Manual Expense";
        CashFlowReportSelection: Record "Cash Flow Report Selection";
        CashFlowChartSetup: Record "Cash Flow Chart Setup";
    begin
        CashFlowForecast.DeleteAll;
        CashFlowAccount.DeleteAll;
        CashFlowAccountComment.DeleteAll;
        CashFlowSetup.DeleteAll;
        CashFlowWorksheetLine.DeleteAll;
        CashFlowForecastEntry.DeleteAll;
        CashFlowManualRevenue.DeleteAll;
        CashFlowManualExpense.DeleteAll;
        CashFlowReportSelection.DeleteAll;
        CashFlowChartSetup.DeleteAll;
        DeleteJobQueueEntries;
    end;

    local procedure CreateCashFlowAccounts(LiquidFundsGLAccountFilter: Code[250])
    var
        CashFlowAccount: Record "Cash Flow Account";
    begin
        CreateCashFlowAccount(CashFlowAccount."source type"::Receivables,'');
        CreateCashFlowAccount(CashFlowAccount."source type"::Payables,'');
        CreateCashFlowAccount(CashFlowAccount."source type"::"Sales Orders",'');
        CreateCashFlowAccount(CashFlowAccount."source type"::"Service Orders",'');
        CreateCashFlowAccount(CashFlowAccount."source type"::"Purchase Orders",'');
        CreateCashFlowAccount(CashFlowAccount."source type"::"Fixed Assets Budget",'');
        CreateCashFlowAccount(CashFlowAccount."source type"::"Fixed Assets Disposal",'');
        CreateCashFlowAccount(CashFlowAccount."source type"::"Liquid Funds",LiquidFundsGLAccountFilter);
        CreateCashFlowAccount(CashFlowAccount."source type"::Job,'');
        CreateCashFlowAccount(CashFlowAccount."source type"::"Cash Flow Manual Expense",'');
        CreateCashFlowAccount(CashFlowAccount."source type"::"Cash Flow Manual Revenue",'');
        CreateCashFlowAccount(CashFlowAccount."source type"::Tax,'');
    end;

    local procedure CreateCashFlowAccount(SourceType: Option;LiquidFundsGLAccountFilter: Code[250])
    var
        CashFlowAccount: Record "Cash Flow Account";
        DummyCashFlowAccount: Record "Cash Flow Account";
    begin
        DummyCashFlowAccount."Source Type" := SourceType;

        CashFlowAccount.Init;
        CashFlowAccount.Validate("No.",Format(DummyCashFlowAccount."Source Type",20));
        CashFlowAccount.Validate(Name,Format(DummyCashFlowAccount."Source Type"));
        CashFlowAccount.Validate("Source Type",DummyCashFlowAccount."Source Type");
        if SourceType = DummyCashFlowAccount."source type"::"Liquid Funds" then begin
          CashFlowAccount."G/L Integration" := CashFlowAccount."g/l integration"::Balance;
          CashFlowAccount."G/L Account Filter" := LiquidFundsGLAccountFilter;
        end;
        CashFlowAccount.Insert;
    end;

    local procedure CreateCashFlowForecast()
    var
        CashFlowForecast: Record "Cash Flow Forecast";
    begin
        CashFlowForecast.Init;
        CashFlowForecast.Validate("No.",DefaultTxt);
        CashFlowForecast.Validate(Description,DefaultTxt);
        CashFlowForecast.ValidateShowInChart(true);
        CashFlowForecast."Overdue CF Dates to Work Date" := true;
        CashFlowForecast.Insert;
    end;

    local procedure CreateCashFlowNoSeries(): Code[10]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if NoSeries.Get(CashFlowTxt) then
          exit(NoSeries.Code);

        NoSeries.Init;
        NoSeries.Code := CashFlowTxt;
        NoSeries.Description := CashFlowForecastTxt;
        NoSeries."Default Nos." := true;
        NoSeries."Manual Nos." := true;
        NoSeries.Insert;

        NoSeriesLine.Init;
        NoSeriesLine."Series Code" := NoSeries.Code;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine.Validate("Starting No.",CashFlowAbbreviationTxt + '000001');
        NoSeriesLine.Insert(true);

        exit(NoSeries.Code);
    end;

    local procedure CreateCashFlowSetup(CashFlowNoSeriesCode: Code[10])
    var
        CashFlowSetup: Record "Cash Flow Setup";
        CashFlowAccount: Record "Cash Flow Account";
    begin
        CashFlowSetup.Init;
        CashFlowSetup.Validate("Cash Flow Forecast No. Series",CashFlowNoSeriesCode);
        CashFlowSetup.Validate("Receivables CF Account No.",Format(CashFlowAccount."source type"::Receivables,20));
        CashFlowSetup.Validate("Payables CF Account No.",Format(CashFlowAccount."source type"::Payables,20));
        CashFlowSetup.Validate("Sales Order CF Account No.",Format(CashFlowAccount."source type"::"Sales Orders",20));
        CashFlowSetup.Validate("Service CF Account No.",Format(CashFlowAccount."source type"::"Service Orders",20));
        CashFlowSetup.Validate("Purch. Order CF Account No.",Format(CashFlowAccount."source type"::"Purchase Orders",20));
        CashFlowSetup.Validate("FA Budget CF Account No.",Format(CashFlowAccount."source type"::"Fixed Assets Budget",20));
        CashFlowSetup.Validate("FA Disposal CF Account No.",Format(CashFlowAccount."source type"::"Fixed Assets Disposal",20));
        CashFlowSetup.Validate("Job CF Account No.",Format(CashFlowAccount."source type"::Job,20));
        CashFlowSetup.Validate("Tax CF Account No.",Format(CashFlowAccount."source type"::Tax,20));
        CashFlowSetup.Insert;
    end;

    local procedure CreateCashFlowChartSetup()
    var
        User: Record User;
    begin
        if not User.FindSet then
          CreateCashFlowChartSetupForUser(UserId)
        else
          repeat
            CreateCashFlowChartSetupForUser(User."User Name");
          until User.Next = 0;
    end;

    local procedure CreateCashFlowChartSetupForUser(UserName: Code[50])
    var
        CashFlowChartSetup: Record "Cash Flow Chart Setup";
    begin
        CashFlowChartSetup.Init;
        CashFlowChartSetup."User ID" := UserName;
        CashFlowChartSetup.Show := CashFlowChartSetup.Show::Combined;
        CashFlowChartSetup."Start Date" := CashFlowChartSetup."start date"::"Working Date";
        CashFlowChartSetup."Period Length" := CashFlowChartSetup."period length"::Month;
        CashFlowChartSetup."Group By" := CashFlowChartSetup."group by"::"Source Type";
        CashFlowChartSetup.Insert;
    end;

    local procedure CreateCashFlowReportSelection()
    var
        CashFlowReportSelection: Record "Cash Flow Report Selection";
    begin
        CashFlowReportSelection.NewRecord;
        CashFlowReportSelection.Validate("Report ID",846);
        CashFlowReportSelection.Insert;
    end;


    procedure UpdateCashFlowForecast(CortanaIntelligenceEnabled: Boolean)
    var
        CashFlowForecast: Record "Cash Flow Forecast";
        CashFlowSetup: Record "Cash Flow Setup";
        SuggestWorksheetLines: Report "Suggest Worksheet Lines";
        Window: Dialog;
        Sources: array [16] of Boolean;
        Index: Integer;
        SourceType: Option ,Receivables,Payables,"Liquid Funds","Cash Flow Manual Expense","Cash Flow Manual Revenue","Sales Order","Purchase Order","Budgeted Fixed Asset","Sale of Fixed Asset","Service Orders","G/L Budget",,,Job,Tax,"Cortana Intelligence";
    begin
        Window.Open(UpdatingMsg);

        if not CashFlowSetup.Get then
          exit;

        if not CashFlowForecast.Get(CashFlowSetup."CF No. on Chart in Role Center") then
          exit;

        UpdateCashFlowForecastManualPaymentHorizon(CashFlowForecast);

        for Index := 1 to ArrayLen(Sources) do
          Sources[Index] := true;

        Sources[Sourcetype::"Cortana Intelligence"] := CortanaIntelligenceEnabled;
        SuggestWorksheetLines.InitializeRequest(Sources,CashFlowSetup."CF No. on Chart in Role Center",'',true);
        SuggestWorksheetLines.UseRequestPage := false;
        SuggestWorksheetLines.Run;
        Codeunit.Run(Codeunit::"Cash Flow Wksh.-Register Batch");

        Window.Close;
    end;

    local procedure UpdateCashFlowForecastManualPaymentHorizon(var CashFlowForecast: Record "Cash Flow Forecast")
    begin
        CashFlowForecast.Validate("Manual Payments From",WorkDate);
        CashFlowForecast.Validate("Manual Payments To",CalcDate('<+1Y>',WorkDate));
        CashFlowForecast.Modify;
    end;


    procedure SetViewOnPurchaseHeaderForTaxCalc(var PurchaseHeader: Record "Purchase Header";TaxPaymentDueDate: Date)
    var
        CashFlowSetup: Record "Cash Flow Setup";
        StartDate: Date;
        EndDate: Date;
    begin
        PurchaseHeader.SetRange("Document Type",PurchaseHeader."document type"::Order);
        PurchaseHeader.SetFilter("Document Date",'<>%1',DummyDate);
        if TaxPaymentDueDate <> DummyDate then begin
          CashFlowSetup.GetTaxPeriodStartEndDates(TaxPaymentDueDate,StartDate,EndDate);
          PurchaseHeader.SetFilter("Document Date",StrSubstNo('%1..%2',StartDate,EndDate));
        end;
        PurchaseHeader.SetCurrentkey("Document Date");
        PurchaseHeader.SetAscending("Document Date",true);
    end;


    procedure SetViewOnSalesHeaderForTaxCalc(var SalesHeader: Record "Sales Header";TaxPaymentDueDate: Date)
    var
        CashFlowSetup: Record "Cash Flow Setup";
        StartDate: Date;
        EndDate: Date;
    begin
        SalesHeader.SetRange("Document Type",SalesHeader."document type"::Order);
        SalesHeader.SetFilter("Document Date",'<>%1',DummyDate);
        if TaxPaymentDueDate <> DummyDate then begin
          CashFlowSetup.GetTaxPeriodStartEndDates(TaxPaymentDueDate,StartDate,EndDate);
          SalesHeader.SetFilter("Document Date",StrSubstNo('%1..%2',StartDate,EndDate));
        end;
        SalesHeader.SetCurrentkey("Document Date");
        SalesHeader.SetAscending("Document Date",true);
    end;


    procedure SetViewOnVATEntryForTaxCalc(var VATEntry: Record "VAT Entry";TaxPaymentDueDate: Date)
    var
        CashFlowSetup: Record "Cash Flow Setup";
        StartDate: Date;
        EndDate: Date;
    begin
        VATEntry.SetFilter(Type,StrSubstNo('%1|%2',VATEntry.Type::Purchase,VATEntry.Type::Sale));
        VATEntry.SetRange(Closed,false);
        VATEntry.SetFilter(Amount,'<>%1',0);
        VATEntry.SetFilter("Document Date",'<>%1',DummyDate);
        if TaxPaymentDueDate <> DummyDate then begin
          CashFlowSetup.GetTaxPeriodStartEndDates(TaxPaymentDueDate,StartDate,EndDate);
          VATEntry.SetFilter("Document Date",StrSubstNo('%1..%2',StartDate,EndDate));
        end;
        VATEntry.SetCurrentkey("Document Date");
        VATEntry.SetAscending("Document Date",true);
    end;


    procedure GetTaxAmountFromSalesOrder(SalesHeader: Record "Sales Header"): Decimal
    var
        NewSalesLine: Record "Sales Line";
        NewSalesLineLCY: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        TempSalesTaxAmountLine: Record UnknownRecord10011 temporary;
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        SalesPost: Codeunit "Sales-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        QtyType: Option General,Invoicing,Shipping;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
    begin
        if SalesHeader."Tax Area Code" = '' then begin
          SalesPost.SumSalesLinesTemp(SalesHeader,TempSalesLine,Qtytype::Invoicing,NewSalesLine,NewSalesLineLCY,
            VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
          exit(-1 * VATAmount);
        end;

        SalesPost.GetSalesLines(SalesHeader,TempSalesLine,Qtytype::Invoicing);
        Clear(SalesPost);
        SalesTaxCalculate.StartSalesTaxCalculation;
        TempSalesLine.SetFilter(Type,'>0');
        TempSalesLine.SetFilter(Quantity,'<>0');
        if TempSalesLine.Find('-') then
          repeat
            SalesTaxCalculate.AddSalesLine(TempSalesLine);
          until TempSalesLine.Next = 0;
        TempSalesLine.Reset;

        SalesTaxCalculate.EndSalesTaxCalculation(SalesHeader."Posting Date");
        SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxAmountLine);

        SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);

        with TempSalesTaxAmtLine do begin
          Reset;
          SetCurrentkey("Print Order","Tax Area Code for Key","Tax Jurisdiction Code");
          if Find('-') then
            repeat
              VATAmount := VATAmount + "Tax Amount";
            until Next = 0;
        end;
        exit(-1 * VATAmount);
    end;


    procedure GetTaxAmountFromPurchaseOrder(PurchaseHeader: Record "Purchase Header"): Decimal
    var
        NewPurchLine: Record "Purchase Line";
        NewPurchLineLCY: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
        TempSalesTaxAmountLine: Record UnknownRecord10011 temporary;
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        PurchPost: Codeunit "Purch.-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        QtyType: Option General,Invoicing,Shipping;
        VATAmount: Decimal;
        VATAmountText: Text[30];
    begin
        if PurchaseHeader."Tax Area Code" = '' then begin
          PurchPost.SumPurchLinesTemp(PurchaseHeader,TempPurchLine,Qtytype::Invoicing,NewPurchLine,NewPurchLineLCY,
            VATAmount,VATAmountText);
          exit(VATAmount);
        end;

        PurchPost.GetPurchLines(PurchaseHeader,TempPurchLine,Qtytype::Invoicing);
        Clear(PurchPost);
        SalesTaxCalculate.StartSalesTaxCalculation;
        TempPurchLine.SetFilter(Type,'>0');
        TempPurchLine.SetFilter(Quantity,'<>0');
        if TempPurchLine.Find('-') then
          repeat
            SalesTaxCalculate.AddPurchLine(TempPurchLine);
          until TempPurchLine.Next = 0;
        TempPurchLine.Reset;

        SalesTaxCalculate.EndSalesTaxCalculation(PurchaseHeader."Posting Date");
        SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxAmountLine);

        SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);

        with TempSalesTaxAmtLine do begin
          Reset;
          SetCurrentkey("Print Order","Tax Area Code for Key","Tax Jurisdiction Code");
          if Find('-') then
            repeat
              VATAmount := VATAmount + "Tax Amount";
            until Next = 0;
        end;
        exit(VATAmount);
    end;


    procedure GetTotalAmountFromSalesOrder(SalesHeader: Record "Sales Header"): Decimal
    begin
        SalesHeader.CalcFields("Amount Including VAT");
        exit(SalesHeader."Amount Including VAT");
    end;


    procedure GetTotalAmountFromPurchaseOrder(PurchaseHeader: Record "Purchase Header"): Decimal
    begin
        PurchaseHeader.CalcFields("Amount Including VAT");
        exit(PurchaseHeader."Amount Including VAT");
    end;
}

