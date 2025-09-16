#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 850 "Cash Flow Forecast Handler"
{
    Permissions = TableData "Cortana Intelligence"=rimd;

    trigger OnRun()
    begin
    end;

    var
        CashFlowSetup: Record "Cash Flow Setup";
        ErrorMessage: Record "Error Message";
        TempErrorMessage: Record "Error Message" temporary;
        CashFlowManagement: Codeunit "Cash Flow Management";
        TimeSeriesManagement: Codeunit "Time Series Management";
        NumberOfPeriodsWithHistory: Integer;
        PeriodType: Integer;
        ForecastStartDate: Date;
        XPAYABLESTxt: label 'PAYABLES', Comment='{locked}';
        XRECEIVABLESTxt: label 'RECEIVABLES', Comment='{locked}';
        XPAYABLESCORRECTIONTxt: label 'Payables Correction';
        XRECEIVABLESCORRECTIONTxt: label 'Receivables Correction';
        XSALESORDERSTxt: label 'Sales Orders';
        XPURCHORDERSTxt: label 'Purchase Orders';
        CortanaIntelligenceMustBeEnabledErr: label '%1 in %2 must be set to true.', Comment='%1 =Cortana Intelligence Enabled field, %2-Cash Flow Setup';
        CortanaIntelligenceAPIURLEmptyErr: label 'You must specify an %1 and an %2 for the %3.', Comment='%1 =API URL field,%2 =API Key field, %3-Cash Flow Setup';
        AzureMachineLearningLimitReachedErr: label 'The Microsoft Azure Machine Learning limit has been reached. Please contact your system administrator.';
        TimeSeriesManagementInitFailedErr: label 'Cannot initialize Microsoft Azure Machine Learning. Try again later. If the problem continues, contact your system administrator.';
        MinimumHistoricalDataErr: label 'There is not enough historical data for Cortana Intelligence to create a forecast.';
        PredictionHasHighVarianceErr: label 'The calculated forecast for %1 for the period from %2 shows a degree of variance that is higher than the setup allows.', Comment='%1 =PAYABLES or RECEIVABLES,%2 =Date';
        SetupScheduledForecastingMsg: label 'Do you want to include Cortana Intelligence capabilities in the cash flow forecast?';
        ButtonYesPleaseTxt: label 'Yes, please';
        ButtonNoThanksTxt: label 'No, thanks';
        ScheduledForecastingEnabledMsg: label 'The Cortana Intelligence forecast has been enabled.', Comment='%1 = weekday (e.g. Monday)';


    procedure CalculateForecast(): Boolean
    var
        TempTimeSeriesForecast: Record "Time Series Forecast" temporary;
        TempTimeSeriesBuffer: Record "Time Series Buffer" temporary;
    begin
        TempErrorMessage.ClearLog;

        if not Initialize then begin
          ErrorMessage.CopyFromTemp(TempErrorMessage);
          Commit;
          exit(false);
        end;
        // Get forecast using time series
        if not PrepareForecast(TempTimeSeriesBuffer) then begin
          ErrorMessage.CopyFromTemp(TempErrorMessage);
          Commit;
          exit(false);
        end;
        TimeSeriesManagement.Forecast(CashFlowSetup.Horizon);
        TimeSeriesManagement.GetForecast(TempTimeSeriesForecast);

        // Insert forecasted data
        CortanaIntelligenceClear;
        CortanaIntelligenceFill(TempTimeSeriesBuffer,TempTimeSeriesForecast);
        ErrorMessage.CopyFromTemp(TempErrorMessage);
        Commit;
        exit(true);
    end;

    local procedure CalculatePostedSalesDocsSumAmountInPeriod(StartingDate: Date;PeriodType: Option): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Total: Decimal;
    begin
        Total := 0;

        with CustLedgerEntry do begin
          Reset;
          SetCurrentkey("Due Date");
          SetRange("Due Date",StartingDate,GetPeriodEndingDate(StartingDate,PeriodType));

          if FindSet then
            repeat
              CalcFields("Amount (LCY)" );
              Total := Total + "Amount (LCY)";
            until Next = 0;
          exit(ROUND(Total,0.01));
        end
    end;

    local procedure CalculatePostedPurchDocsSumAmountInPeriod(StartingDate: Date;PeriodType: Option): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Total: Decimal;
    begin
        Total := 0;

        with VendorLedgerEntry do begin
          Reset;
          SetCurrentkey("Due Date");
          SetRange("Due Date",StartingDate,GetPeriodEndingDate(StartingDate,PeriodType));

          if FindSet then
            repeat
              CalcFields("Amount (LCY)" );
              Total := Total + "Amount (LCY)";
            until Next = 0;
          exit(ROUND(Total,0.01));
        end
    end;

    local procedure CalculateNotPostedSalesOrderSumAmountInPeriod(StartingDate: Date;PeriodType: Option): Decimal
    var
        SalesHeader: Record "Sales Header";
        Total: Decimal;
        AmountValue: Decimal;
    begin
        Total := 0;
        with SalesHeader do begin
          Reset;
          SetCurrentkey("Due Date");
          SetRange("Due Date",StartingDate,GetPeriodEndingDate(StartingDate,PeriodType));
          SetRange("Document Type","document type"::Order);

          if FindSet then
            repeat
              AmountValue := -CashFlowManagement.GetTotalAmountFromSalesOrder(SalesHeader);
              Total := Total + AmountValue;
            until Next = 0;
          exit(ROUND(Total,0.01));
        end
    end;

    local procedure CalculateNotPostedPurchOrderSumAmountInPeriod(StartingDate: Date;PeriodType: Option): Decimal
    var
        PurchaseHeader: Record "Purchase Header";
        Total: Decimal;
        AmountValue: Decimal;
    begin
        Total := 0;
        with PurchaseHeader do begin
          Reset;
          SetCurrentkey("Due Date");
          SetRange("Due Date",StartingDate,GetPeriodEndingDate(StartingDate,PeriodType));
          SetRange("Document Type","document type"::Order);

          if FindSet then
            repeat
              AmountValue := CashFlowManagement.GetTotalAmountFromPurchaseOrder(PurchaseHeader);
              Total := Total + AmountValue;
            until Next = 0;
          exit(ROUND(Total,0.01));
        end
    end;


    procedure PrepareForecast(var TimeSeriesBuffer: Record "Time Series Buffer"): Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        TempCustTimeSeriesBuffer: Record "Time Series Buffer" temporary;
        TempVendTimeSeriesBuffer: Record "Time Series Buffer" temporary;
    begin
        SetFiltersOnRecords(CustLedgerEntry,VendorLedgerEntry);

        // check if there is a minimum history needed for forecast
        if not TimeSeriesManagement.HasMinimumHistoricalData(
             NumberOfPeriodsWithHistory,
             CustLedgerEntry,
             CustLedgerEntry.FieldNo("Due Date"),
             CashFlowSetup."Period Type",
             ForecastStartDate)
        then begin
          TempErrorMessage.LogSimpleMessage(ErrorMessage."message type"::Error,MinimumHistoricalDataErr);
          exit(false);
        end;

        // Prepare Sales History
        PrepareData(
          TempCustTimeSeriesBuffer,
          CustLedgerEntry,
          CustLedgerEntry.FieldNo("Document Type"),
          CustLedgerEntry.FieldNo("Due Date"),
          CustLedgerEntry.FieldNo("Amount (LCY)"),
          Format(CustLedgerEntry."document type"::Invoice),
          Format(CustLedgerEntry."document type"::"Credit Memo")
          );

        AppendRecords(TimeSeriesBuffer,TempCustTimeSeriesBuffer,'Receivables');

        // Prepare Purchase History
        PrepareData(
          TempVendTimeSeriesBuffer,
          VendorLedgerEntry,
          VendorLedgerEntry.FieldNo("Document Type"),
          VendorLedgerEntry.FieldNo("Due Date"),
          VendorLedgerEntry.FieldNo("Amount (LCY)"),
          Format(VendorLedgerEntry."document type"::Invoice),
          Format(VendorLedgerEntry."document type"::"Credit Memo")
          );

        AppendRecords(TimeSeriesBuffer,TempVendTimeSeriesBuffer,'Payables');
        TimeSeriesManagement.SetPreparedData(TimeSeriesBuffer,PeriodType,ForecastStartDate,NumberOfPeriodsWithHistory);
        exit(true);
    end;


    procedure CortanaIntelligenceFill(var TimeSeriesBuffer: Record "Time Series Buffer";var TimeSeriesForecast: Record "Time Series Forecast")
    var
        CortanaIntelligence: Record "Cortana Intelligence";
        ForecastedRemainingAmount: Decimal;
    begin
        // History Records
        if TimeSeriesBuffer.FindSet then
          repeat
            NewCortanaIntelligenceRecord(TimeSeriesBuffer."Group ID",
              TimeSeriesBuffer.Value,
              1,
              0,
              CortanaIntelligence.Type::History,
              TimeSeriesBuffer."Period Start Date",
              PeriodType,
              TimeSeriesBuffer."Period No."
              );
          until TimeSeriesBuffer.Next = 0;

        // Forecast
        if TimeSeriesForecast.FindSet then
          repeat
            // if Variance % is big, do not insert it
            if TimeSeriesForecast."Delta %" >= CashFlowSetup."Variance %" then
              TempErrorMessage.LogSimpleMessage(ErrorMessage."message type"::Warning,
                StrSubstNo(PredictionHasHighVarianceErr,TimeSeriesForecast."Group ID",TimeSeriesForecast."Period Start Date"))
            else
              if IsAmountValid(TimeSeriesForecast) then begin
                // Cortana Intelligence Forecast
                ForecastedRemainingAmount := Abs(TimeSeriesForecast.Value);
                NewCortanaIntelligenceRecord(TimeSeriesForecast."Group ID",
                  TimeSeriesForecast.Value,
                  TimeSeriesForecast."Delta %",
                  TimeSeriesForecast.Delta,
                  CortanaIntelligence.Type::Forecast,
                  TimeSeriesForecast."Period Start Date",
                  PeriodType,
                  TimeSeriesForecast."Period No."
                  );

                // Corrections: Payables Corrections, Receivables Corrections, Sales Orders, Purchase Orders
                if TimeSeriesForecast."Group ID" = XPAYABLESTxt then begin
                  NewCorrectionRecord(ForecastedRemainingAmount,TimeSeriesForecast,XPAYABLESCORRECTIONTxt,PeriodType);
                  NewCorrectionRecord(ForecastedRemainingAmount,TimeSeriesForecast,XPURCHORDERSTxt,PeriodType);
                end else begin
                  NewCorrectionRecord(ForecastedRemainingAmount,TimeSeriesForecast,XRECEIVABLESCORRECTIONTxt,PeriodType);
                  NewCorrectionRecord(ForecastedRemainingAmount,TimeSeriesForecast,XSALESORDERSTxt,PeriodType);
                end;
              end;
          until TimeSeriesForecast.Next = 0;
    end;

    local procedure CortanaIntelligenceClear()
    var
        CortanaIntelligence: Record "Cortana Intelligence";
    begin
        CortanaIntelligence.Reset;
        CortanaIntelligence.DeleteAll;
    end;

    local procedure SetFiltersOnRecords(var CustLedgerEntry: Record "Cust. Ledger Entry";var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        CustLedgerEntry.SetCurrentkey("Due Date");
        CustLedgerEntry.SetFilter("Document Type",
          '%1|%2',
          CustLedgerEntry."document type"::Invoice,
          CustLedgerEntry."document type"::"Credit Memo");

        VendorLedgerEntry.SetCurrentkey("Due Date");
        VendorLedgerEntry.SetFilter("Document Type",
          '%1|%2',
          VendorLedgerEntry."document type"::Invoice,
          VendorLedgerEntry."document type"::"Credit Memo");
    end;

    local procedure PrepareData(var TempTimeSeriesBuffer: Record "Time Series Buffer" temporary;RecordVariant: Variant;GroupIdFieldNo: Integer;DateFieldNo: Integer;ValueFieldNo: Integer;InvoiceOption: Text;CreditMemoOption: Text)
    var
        TempCreditMemoTimeSeriesBuffer: Record "Time Series Buffer" temporary;
    begin
        TimeSeriesManagement.PrepareData(
          RecordVariant,
          GroupIdFieldNo,
          DateFieldNo,
          ValueFieldNo,
          PeriodType,
          ForecastStartDate,
          NumberOfPeriodsWithHistory);

        TimeSeriesManagement.GetPreparedData(TempTimeSeriesBuffer);
        TempCreditMemoTimeSeriesBuffer.Copy(TempTimeSeriesBuffer,true);
        TempCreditMemoTimeSeriesBuffer.SetRange("Group ID",Format(CreditMemoOption));

        TempTimeSeriesBuffer.SetRange("Group ID",Format(InvoiceOption));

        if TempTimeSeriesBuffer.FindSet and TempCreditMemoTimeSeriesBuffer.FindSet then
          repeat
            TempTimeSeriesBuffer.Value := TempTimeSeriesBuffer.Value + TempCreditMemoTimeSeriesBuffer.Value;
            TempTimeSeriesBuffer.Modify;
          until (TempTimeSeriesBuffer.Next = 0) and (TempCreditMemoTimeSeriesBuffer.Next = 0);
    end;

    local procedure AppendRecords(var TargetTimeSeriesBuffer: Record "Time Series Buffer";var SourceTimeSeriesBuffer: Record "Time Series Buffer";Label: Text[50])
    begin
        if SourceTimeSeriesBuffer.FindSet then
          repeat
            TargetTimeSeriesBuffer.Validate(Value,SourceTimeSeriesBuffer.Value);
            TargetTimeSeriesBuffer.Validate("Period Start Date",SourceTimeSeriesBuffer."Period Start Date");
            TargetTimeSeriesBuffer.Validate("Period No.",SourceTimeSeriesBuffer."Period No.");
            TargetTimeSeriesBuffer.Validate("Group ID",Label);
            TargetTimeSeriesBuffer.Insert;
          until SourceTimeSeriesBuffer.Next = 0;
    end;


    procedure Initialize(): Boolean
    var
        AzureMachineLearningUsage: Record "Azure Machine Learning Usage";
        APIURL: Text[250];
        APIKey: Text[200];
        LimitValue: Decimal;
        IsInitialized: Boolean;
        TimeSeriesLibState: Option Uninitialized,Initialized,"Data Prepared",Done;
    begin
        if not CashFlowSetup.Get then
          exit(false);

        IsInitialized := true;

        // check if Cortana is enabled
        TempErrorMessage.SetContext(CashFlowSetup);
        if not CashFlowSetup."Cortana Intelligence Enabled" then begin
          TempErrorMessage.LogMessage(
            CashFlowSetup,CashFlowSetup.FieldNo("Cortana Intelligence Enabled"),ErrorMessage."message type"::Error,
            StrSubstNo(CortanaIntelligenceMustBeEnabledErr,CashFlowSetup.FieldCaption("Cortana Intelligence Enabled"),
              CashFlowSetup.TableCaption));
          IsInitialized := false;
        end;

        // check Azure ML settings
        if not CashFlowSetup.GetMLCredentials(APIURL,APIKey,LimitValue) then begin
          TempErrorMessage.LogMessage(
            CashFlowSetup,CashFlowSetup.FieldNo("API URL"),ErrorMessage."message type"::Error,
            StrSubstNo(CortanaIntelligenceAPIURLEmptyErr,CashFlowSetup.FieldCaption("API URL"),
              CashFlowSetup.FieldCaption("API Key"),CashFlowSetup.TableCaption));
          IsInitialized := false;
        end;
        if IsInitialized = false then
          exit(false);

        // check - it will be fixed with Time Series Lib
        if not CashFlowSetup.IsAPIUserDefined then
          if AzureMachineLearningUsage.IsAzureMLLimitReached(LimitValue) then begin
            TempErrorMessage.LogSimpleMessage(ErrorMessage."message type"::Error,AzureMachineLearningLimitReachedErr);
            exit(false);
          end;

        // Time series Lib
        TimeSeriesManagement.Initialize(APIURL,APIKey,CashFlowSetup.TimeOut);
        TimeSeriesManagement.SetMaximumHistoricalPeriods(CashFlowSetup."Historical Periods");
        TimeSeriesManagement.GetState(TimeSeriesLibState);
        if not (TimeSeriesLibState = Timeserieslibstate::Initialized) then begin
          TempErrorMessage.LogSimpleMessage(ErrorMessage."message type"::Error,TimeSeriesManagementInitFailedErr);
          exit(false);
        end;
        // set defaults
        PeriodType := CashFlowSetup."Period Type";
        ForecastStartDate := GetForecastStartDate(PeriodType);
        exit(true);
    end;

    local procedure GetPeriodEndingDate(StartingDate: Date;PeriodType: Option Day,Week,Month,Quarter,Year): Date
    begin
        case PeriodType of
          Periodtype::Day:
            exit(StartingDate);
          Periodtype::Week:
            exit(CalcDate('<+1W-1D>',StartingDate));
          Periodtype::Month:
            exit(CalcDate('<+1M-1D>',StartingDate));
          Periodtype::Quarter:
            exit(CalcDate('<+1Q-1D>',StartingDate));
          Periodtype::Year:
            exit(CalcDate('<+1Y-1D>',StartingDate));
        end;
    end;

    local procedure NewCortanaIntelligenceRecord(GroupIdValue: Text[50];AmountValue: Decimal;DeltaPercentValue: Decimal;DeltaValue: Decimal;TypeValue: Option;PeriodStartValue: Date;PeriodTypeValue: Option;PeriodNoValue: Integer)
    var
        CortanaIntelligence: Record "Cortana Intelligence";
    begin
        with CortanaIntelligence do begin
          Init;
          Validate("Group Id",GroupIdValue);
          Validate(Amount,AmountValue);
          Validate("Delta %",DeltaPercentValue);
          Validate(Delta,DeltaValue);
          Validate(Type,TypeValue);
          Validate("Period Start",PeriodStartValue);
          Validate("Period Type",PeriodTypeValue);
          Validate("Period No.",PeriodNoValue);
          Insert;
        end;
    end;

    local procedure NewCorrectionRecord(var ForecastedRemainingAmount: Decimal;TimeSeriesForecast: Record "Time Series Forecast";GroupIDValue: Text[100];PeriodTypeValue: Option)
    var
        CortanaIntelligence: Record "Cortana Intelligence";
        CorrectionAmount: Decimal;
    begin
        if ForecastedRemainingAmount = 0 then
          exit;
        // correction must not be bigger than forecasted amount
        CorrectionAmount := GetCorrectionAmount(TimeSeriesForecast,GroupIDValue,PeriodTypeValue);

        // if correction amount smaller than forecasted, keep correction and reduce forecasted remaining amount
        if Abs(ForecastedRemainingAmount) < Abs(CorrectionAmount) then begin
          CorrectionAmount := ForecastedRemainingAmount;
          ForecastedRemainingAmount := 0;
          if TimeSeriesForecast."Group ID" = XRECEIVABLESTxt then
            CorrectionAmount := -CorrectionAmount;
        end else
          ForecastedRemainingAmount -= Abs(CorrectionAmount);

        // insert correction
        with CortanaIntelligence do begin
          Init;
          Validate("Group Id",GroupIDValue);
          Validate(Amount,CorrectionAmount);
          Validate(Type,Type::Correction);
          Validate("Period Start",TimeSeriesForecast."Period Start Date");
          Validate("Period Type",PeriodTypeValue);
          Validate("Period No.",TimeSeriesForecast."Period No.");
          Insert;
        end;
    end;

    local procedure GetCorrectionAmount(TimeSeriesForecast: Record "Time Series Forecast";GroupIDValue: Text[100];PeriodType: Option): Decimal
    begin
        case GroupIDValue of
          XPAYABLESCORRECTIONTxt:
            exit(-CalculatePostedPurchDocsSumAmountInPeriod(TimeSeriesForecast."Period Start Date",PeriodType));
          XPURCHORDERSTxt:
            exit(CalculateNotPostedPurchOrderSumAmountInPeriod(TimeSeriesForecast."Period Start Date",PeriodType));
          XRECEIVABLESCORRECTIONTxt:
            exit(-CalculatePostedSalesDocsSumAmountInPeriod(TimeSeriesForecast."Period Start Date",PeriodType));
          XSALESORDERSTxt:
            exit(CalculateNotPostedSalesOrderSumAmountInPeriod(TimeSeriesForecast."Period Start Date",PeriodType));
        end;
    end;

    local procedure IsAmountValid(TimeSeriesForecast: Record "Time Series Forecast"): Boolean
    begin
        with TimeSeriesForecast do begin
          if ("Group ID" = XPAYABLESTxt) and (Value < 0) then
            exit(true);
          if ("Group ID" = XRECEIVABLESTxt) and (Value > 0) then
            exit(true);
          exit(false);
        end
    end;

    local procedure GetForecastStartDate(PeriodType: Option Day,Week,Month,Quarter,Year): Date
    begin
        case PeriodType of
          Periodtype::Day:
            exit(WorkDate);
          Periodtype::Week:
            exit(CalcDate('<CW+1D-1W>',WorkDate));
          Periodtype::Month:
            exit(CalcDate('<CM+1D-1M>',WorkDate));
          Periodtype::Quarter:
            exit(CalcDate('<CQ+1D-1Q>',WorkDate));
          Periodtype::Year:
            exit(CalcDate('<CY+1D-1Y>',WorkDate));
        end;
    end;

    local procedure CreateSetupNotification()
    var
        SetupNotification: Notification;
    begin
        if not ShowNotification then
          exit;

        SetupNotification.Message := SetupScheduledForecastingMsg;
        SetupNotification.Scope := Notificationscope::LocalScope;
        SetupNotification.AddAction(ButtonYesPleaseTxt,Codeunit::"Cash Flow Forecast Handler",'SetupCortanaIntelligence');
        SetupNotification.AddAction(ButtonNoThanksTxt,Codeunit::"Cash Flow Forecast Handler",'DeactivateNotification');
        SetupNotification.Send;
    end;

    local procedure ShowNotification(): Boolean
    var
        CashFlowSetup: Record "Cash Flow Setup";
        O365GettingStarted: Record "O365 Getting Started";
    begin
        if O365GettingStarted.Get(UserId,CurrentClientType) then
          if O365GettingStarted."Tour in Progress" then
            exit(false);

        if not CashFlowSetup.Get then
          exit(false);

        if CashFlowSetup."Cortana Intelligence Enabled" then
          exit(false);

        if not CashFlowSetup."Show Cortana Notification" then
          exit(false);

        exit(true);
    end;


    procedure DeactivateNotification(SetupNotification: Notification)
    var
        CashFlowSetup: Record "Cash Flow Setup";
    begin
        if not CashFlowSetup.Get then
          exit;
        CashFlowSetup."Show Cortana Notification" := false;
        CashFlowSetup.Modify(true);
    end;


    procedure SetupCortanaIntelligence(SetupNotification: Notification)
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        if CashFlowSetup.Get then
          Page.RunModal(Page::"Cash Flow Setup",CashFlowSetup);
        if CashFlowSetup.Get then begin
          if PermissionManager.SoftwareAsAService and CashFlowSetup."Cortana Intelligence Enabled" then
            Message(ScheduledForecastingEnabledMsg);
          CashFlowSetup."Show Cortana Notification" := false;
          CashFlowSetup.Modify(true);
        end;
    end;

    [EventSubscriber(Objecttype::Page, 869, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenCashFlowForecastChart(var Rec: Record "Business Chart Buffer")
    begin
        CreateSetupNotification;
    end;
}

