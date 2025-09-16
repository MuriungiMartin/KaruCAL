#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 2000 "Time Series Management"
{

    trigger OnRun()
    begin
    end;

    var
        TempTimeSeriesBuffer: Record "Time Series Buffer" temporary;
        TempTimeSeriesForecast: Record "Time Series Forecast" temporary;
        AzureMLConnector: Codeunit "Azure ML Connector";
        ApiUri: Text;
        ApiKey: Text;
        NotInitializedErr: label 'The connection has not been initialized. Initialize the connection before using the time series functionality.';
        TimeOutSec: Integer;
        TimeSeriesPeriodType: Option;
        TimeSeriesForecastingStartDate: Date;
        TimeSeriesObservationPeriods: Integer;
        TimeSeriesFrequency: Integer;
        TimeSeriesCalculationState: Option Uninitialized,Initialized,"Data Prepared",Done;
        DataNotPreparedErr: label 'The data was not prepared for forecasting. Prepare data before using the forecasting functionality.';
        DataNotProcessedErr: label 'The data for forecasting has not been processed yet. Results cannot be retrieved.';
        ForecastingPeriodsErr: label 'The number of forecasting periods must be greater than 0.';
        MinimumHistoricalPeriods: Integer;
        NotADateErr: label 'PeriodFieldNo must point to a Date field.';
        NotARecordErr: label 'SourceRecord must point to Record or a RecordRef object.';
        NegativeNumberOfPeriodsErr: label 'NumberOfPeriods Must be strictly positive.';
        MaximumHistoricalPeriods: Integer;


    procedure Initialize(Uri: Text;"Key": Text;TimeOutSeconds: Integer)
    begin
        ApiUri := Uri;
        ApiKey := Key;
        TimeOutSec := TimeOutSeconds;

        AzureMLConnector.Initialize(ApiKey,ApiUri,TimeOutSec);
        MinimumHistoricalPeriods := 5;
        MaximumHistoricalPeriods := 24;
        TimeSeriesCalculationState := Timeseriescalculationstate::Initialized;
    end;


    procedure SetMessageHandler(MessageHandler: dotnet HttpMessageHandler)
    begin
        AzureMLConnector.SetMessageHandler(MessageHandler);
    end;


    procedure PrepareData(RecordVariant: Variant;GroupIDFieldNo: Integer;DateFieldNo: Integer;ValueFieldNo: Integer;PeriodType: Option;ForecastingStartDate: Date;ObservationPeriods: Integer)
    begin
        if TimeSeriesCalculationState < Timeseriescalculationstate::Initialized then
          Error(NotInitializedErr);

        TempTimeSeriesBuffer.Reset;
        TempTimeSeriesBuffer.DeleteAll;

        TimeSeriesPeriodType := PeriodType;
        TimeSeriesForecastingStartDate := ForecastingStartDate;
        TimeSeriesObservationPeriods := ObservationPeriods;
        TimeSeriesFrequency := GetFrequency(PeriodType);

        FillTimeSeriesBuffer(RecordVariant,GroupIDFieldNo,ValueFieldNo,DateFieldNo);

        TimeSeriesCalculationState := Timeseriescalculationstate::"Data Prepared";
    end;


    procedure SetPreparedData(var TempTimeSeriesBufferIn: Record "Time Series Buffer" temporary;PeriodType: Option;ForecastingStartDate: Date;ObservationPeriods: Integer)
    begin
        if TimeSeriesCalculationState < Timeseriescalculationstate::Initialized then
          Error(NotInitializedErr);

        TempTimeSeriesBuffer.Copy(TempTimeSeriesBufferIn,true);

        TimeSeriesPeriodType := PeriodType;
        TimeSeriesForecastingStartDate := ForecastingStartDate;
        TimeSeriesObservationPeriods := ObservationPeriods;
        TimeSeriesFrequency := GetFrequency(PeriodType);

        TimeSeriesCalculationState := Timeseriescalculationstate::"Data Prepared";
    end;


    procedure GetPreparedData(var TempTimeSeriesBufferOut: Record "Time Series Buffer" temporary)
    begin
        if TimeSeriesCalculationState < Timeseriescalculationstate::"Data Prepared" then
          Error(DataNotPreparedErr);

        TempTimeSeriesBufferOut.Copy(TempTimeSeriesBuffer,true);
    end;


    procedure Forecast(ForecastingPeriods: Integer)
    begin
        if ForecastingPeriods < 1 then
          Error(ForecastingPeriodsErr);

        if TimeSeriesCalculationState < Timeseriescalculationstate::"Data Prepared" then
          Error(DataNotPreparedErr);

        TempTimeSeriesForecast.Reset;
        TempTimeSeriesForecast.DeleteAll;

        if TempTimeSeriesBuffer.IsEmpty then begin
          TimeSeriesCalculationState := Timeseriescalculationstate::Done;
          exit;
        end;

        CreateTimeSeriesInput;
        CreateTimeSeriesParameters(ForecastingPeriods);

        if not AzureMLConnector.SendToAzureML then
          Error(GetLastErrorText);

        LoadTimeSeriesForecast;
        TimeSeriesCalculationState := Timeseriescalculationstate::Done;
    end;


    procedure GetForecast(var TempTimeSeriesForecastOut: Record "Time Series Forecast" temporary)
    begin
        if TimeSeriesCalculationState < Timeseriescalculationstate::Done then
          Error(DataNotProcessedErr);

        TempTimeSeriesForecastOut.Copy(TempTimeSeriesForecast,true);
    end;


    procedure GetState(var State: Option Uninitialized,Initialized,"Data Prepared",Done)
    begin
        State := TimeSeriesCalculationState;
    end;

    local procedure GetFrequency(PeriodType: Option): Integer
    var
        Date: Record Date;
    begin
        case PeriodType of
          Date."period type"::Date:
            exit(365);
          Date."period type"::Week:
            exit(52);
          Date."period type"::Month:
            exit(12);
          Date."period type"::Quarter:
            exit(4);
          Date."period type"::Year:
            exit(1);
        end;
    end;


    procedure GetOutput(LineNo: Integer;ColumnNo: Integer): Text
    var
        OutputValue: Text;
    begin
        AzureMLConnector.GetOutput(LineNo,ColumnNo,OutputValue);
        exit(OutputValue);
    end;


    procedure GetOutputLength(): Integer
    var
        Length: Integer;
    begin
        AzureMLConnector.GetOutputLength(Length);
        exit(Length);
    end;


    procedure GetInput(LineNo: Integer;ColumnNo: Integer): Text
    var
        InputValue: Text;
    begin
        AzureMLConnector.GetInput(LineNo,ColumnNo,InputValue);
        exit(InputValue);
    end;


    procedure GetInputLength(): Integer
    var
        Length: Integer;
    begin
        AzureMLConnector.GetInputLength(Length);
        exit(Length);
    end;


    procedure GetParameter(Name: Text): Text
    var
        ParameterValue: Text;
    begin
        AzureMLConnector.GetParameter(Name,ParameterValue);
        exit(ParameterValue);
    end;

    local procedure FillTimeSeriesBuffer(RecordVariant: Variant;GroupIDFieldNo: Integer;ValueFieldNo: Integer;DateFieldNo: Integer)
    var
        TempTimeSeriesBufferDistinct: Record "Time Series Buffer" temporary;
        DataTypeManagement: Codeunit "Data Type Management";
        PeriodFormManagement: Codeunit PeriodFormManagement;
        RecRef: RecordRef;
        GroupIDFieldRef: FieldRef;
        ValueFieldRef: FieldRef;
        DateFieldRef: FieldRef;
        CurrentPeriod: Integer;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        Value: Decimal;
    begin
        DataTypeManagement.GetRecordRef(RecordVariant,RecRef);

        if RecRef.IsEmpty then
          exit;

        GroupIDFieldRef := RecRef.Field(GroupIDFieldNo);
        DateFieldRef := RecRef.Field(DateFieldNo);
        ValueFieldRef := RecRef.Field(ValueFieldNo);

        GetDistinctRecords(RecRef,GroupIDFieldNo,TempTimeSeriesBufferDistinct);

        if TempTimeSeriesBufferDistinct.FindSet then
          repeat
            GroupIDFieldRef.SetRange(TempTimeSeriesBufferDistinct."Group ID");
            for CurrentPeriod := -TimeSeriesObservationPeriods to -1 do begin
              PeriodStartDate :=
                PeriodFormManagement.MoveDateByPeriod(TimeSeriesForecastingStartDate,TimeSeriesPeriodType,CurrentPeriod);
              PeriodEndDate :=
                PeriodFormManagement.MoveDateByPeriodToEndOfPeriod(TimeSeriesForecastingStartDate,TimeSeriesPeriodType,CurrentPeriod);
              DateFieldRef.SetRange(PeriodStartDate,PeriodEndDate);
              if Format(ValueFieldRef.CLASS) = 'Normal' then
                Value := CalculateValueNormal(ValueFieldRef)
              else
                Value := CalculateValueFlowField(RecRef,ValueFieldRef);
              TempTimeSeriesBuffer.Init;
              TempTimeSeriesBuffer."Group ID" := GroupIDFieldRef.GetFilter;
              TempTimeSeriesBuffer."Period No." := TimeSeriesObservationPeriods + CurrentPeriod + 1;
              TempTimeSeriesBuffer."Period Start Date" := PeriodStartDate;
              TempTimeSeriesBuffer.Value := Value;
              TempTimeSeriesBuffer.Insert;
            end;
          until TempTimeSeriesBufferDistinct.Next = 0;
    end;

    local procedure CalculateValueNormal(var ValueFieldRef: FieldRef) Value: Decimal
    begin
        if Format(ValueFieldRef.CLASS) <> 'Normal' then
          exit(0);

        ValueFieldRef.CalcSum;
        Value := ValueFieldRef.Value;
    end;

    local procedure CalculateValueFlowField(var RecRef: RecordRef;var ValueFieldRef: FieldRef) Value: Decimal
    var
        CurrentValue: Decimal;
    begin
        if Format(ValueFieldRef.CLASS) <> 'FlowField' then
          exit(0);

        if RecRef.FindSet then
          repeat
            ValueFieldRef.CalcField;
            CurrentValue := ValueFieldRef.Value;
            Value += CurrentValue;
          until RecRef.Next = 0;
    end;

    local procedure CreateTimeSeriesInput()
    begin
        AzureMLConnector.AddInputColumnName('GranularityAttribute');
        AzureMLConnector.AddInputColumnName('DateKey');
        AzureMLConnector.AddInputColumnName('TransactionQty');

        if TempTimeSeriesBuffer.FindSet then
          repeat
            AzureMLConnector.AddInputRow;
            AzureMLConnector.AddInputValue(Format(TempTimeSeriesBuffer."Group ID"));
            AzureMLConnector.AddInputValue(Format(TempTimeSeriesBuffer."Period No."));
            AzureMLConnector.AddInputValue(Format(TempTimeSeriesBuffer.Value,0,9));
          until TempTimeSeriesBuffer.Next = 0;
    end;

    local procedure CreateTimeSeriesParameters(ForecastingPeriods: Integer)
    var
        TimeSeriesModel: Text;
        ConfidenceLevel: Integer;
    begin
        TimeSeriesModel := 'ARIMA';
        ConfidenceLevel := 80;

        AzureMLConnector.AddParameter('horizon',Format(ForecastingPeriods));
        AzureMLConnector.AddParameter('seasonality',Format(TimeSeriesFrequency));
        AzureMLConnector.AddParameter('forecast_start_datekey',Format(TimeSeriesObservationPeriods + 1));
        AzureMLConnector.AddParameter('time_series_model',TimeSeriesModel);
        AzureMLConnector.AddParameter('confidence_level',Format(ConfidenceLevel));
    end;

    local procedure LoadTimeSeriesForecast()
    var
        TypeHelper: Codeunit "Type Helper";
        PeriodFormManagement: Codeunit PeriodFormManagement;
        Value: Variant;
        LineNo: Integer;
        GroupID: Code[50];
        PeriodNo: Integer;
    begin
        for LineNo := 1 to GetOutputLength do begin
          TempTimeSeriesForecast.Init;

          Evaluate(GroupID,GetOutput(LineNo,1));
          TempTimeSeriesForecast."Group ID" := GroupID;

          Evaluate(PeriodNo,GetOutput(LineNo,2));
          TempTimeSeriesForecast."Period No." := PeriodNo;
          TempTimeSeriesForecast."Period Start Date" :=
            PeriodFormManagement.MoveDateByPeriod(
              TimeSeriesForecastingStartDate,TimeSeriesPeriodType,PeriodNo - TimeSeriesObservationPeriods - 1);
          Value := TempTimeSeriesForecast.Value;
          TypeHelper.Evaluate(Value,GetOutput(LineNo,3),'','');
          TempTimeSeriesForecast.Value := Value;

          Value := TempTimeSeriesForecast.Delta;
          TypeHelper.Evaluate(Value,GetOutput(LineNo,4),'','');
          TempTimeSeriesForecast.Delta := Value;
          if TempTimeSeriesForecast.Value <> 0 then
            TempTimeSeriesForecast."Delta %" := Abs(TempTimeSeriesForecast.Delta / TempTimeSeriesForecast.Value) * 100;

          TempTimeSeriesForecast.Insert;
        end;
    end;

    local procedure GetDistinctRecords(RecRef: RecordRef;FieldNo: Integer;var TempTimeSeriesBufferDistinct: Record "Time Series Buffer" temporary)
    var
        FieldRef: FieldRef;
        OptionValue: Integer;
    begin
        FieldRef := RecRef.Field(FieldNo);

        if RecRef.FindSet then
          repeat
            TempTimeSeriesBufferDistinct.Init;
            if Format(FieldRef.Type) = 'Option' then begin
              OptionValue := FieldRef.Value;
              TempTimeSeriesBufferDistinct."Group ID" := Format(OptionValue);
            end else
              TempTimeSeriesBufferDistinct."Group ID" := FieldRef.Value;
            if not TempTimeSeriesBufferDistinct.Insert then;
          until RecRef.Next = 0;
    end;


    procedure SetMinimumHistoricalPeriods(NumberOfPeriods: Integer)
    begin
        if not (NumberOfPeriods > 0) then
          Error(NegativeNumberOfPeriodsErr);
        MinimumHistoricalPeriods := NumberOfPeriods;
    end;


    procedure SetMaximumHistoricalPeriods(NumberOfPeriods: Integer)
    begin
        if not (NumberOfPeriods > 0) then
          Error(NegativeNumberOfPeriodsErr);
        MaximumHistoricalPeriods := NumberOfPeriods;
    end;


    procedure HasMinimumHistoricalData(var NumberOfPeriodsWithHistory: Integer;SourceRecord: Variant;PeriodFieldNo: Integer;PeriodType: Option Day,Week,Month,Quarter,Year;ForecastStartDate: Date): Boolean
    var
        DataTypeManagement: Codeunit "Data Type Management";
        PeriodFieldRef: FieldRef;
        HistoryStartDate: Variant;
        SourceRecordRef: RecordRef;
        HistoryEndDate: Date;
    begin
        // SourceRecord Should already contain all the necessary filters
        // and should be sorted by the desired date field
        if SourceRecord.IsRecord then
          DataTypeManagement.GetRecordRef(SourceRecord,SourceRecordRef)
        else
          if SourceRecord.IsRecordRef then
            SourceRecordRef := SourceRecord
          else
            Error(NotARecordErr);

        if not SourceRecordRef.FindFirst then
          exit(false);

        // last date of transaction history that will be used for forecast
        HistoryEndDate := CalcDate('<-1D>',ForecastStartDate);

        PeriodFieldRef := SourceRecordRef.Field(PeriodFieldNo);
        PeriodFieldRef.SetFilter('%1..',CalculateMaxStartDate(HistoryEndDate,PeriodType));
        if SourceRecordRef.FindSet then;
        PeriodFieldRef := SourceRecordRef.Field(PeriodFieldNo);
        HistoryStartDate := PeriodFieldRef.Value;
        if not HistoryStartDate.IsDate then
          Error(NotADateErr);
        NumberOfPeriodsWithHistory :=
          CalculatePeriodsWithHistory(HistoryStartDate,HistoryEndDate,PeriodType);
        if NumberOfPeriodsWithHistory < MinimumHistoricalPeriods then
          exit(false);
        exit(true);
    end;

    local procedure CalculatePeriodsWithHistory(HistoryStartDate: Date;HistoryEndDate: Date;PeriodType: Option) NumberOfPeriodsWithHistory: Integer
    var
        PeriodFormManagement: Codeunit PeriodFormManagement;
    begin
        while HistoryStartDate <= HistoryEndDate do begin
          NumberOfPeriodsWithHistory += 1;
          HistoryStartDate := PeriodFormManagement.MoveDateByPeriod(HistoryStartDate,PeriodType,1);
        end;
    end;

    local procedure CalculateMaxStartDate(HistoryEndDate: Date;PeriodType: Option Day,Week,Month,Quarter,Year): Date
    begin
        case PeriodType of
          Periodtype::Day:
            exit(CalcDate(StrSubstNo('<-%1D>',Format(MaximumHistoricalPeriods - 1)),HistoryEndDate));
          Periodtype::Week:
            exit(CalcDate(StrSubstNo('<-%1W+1D>',Format(MaximumHistoricalPeriods)),HistoryEndDate));
          Periodtype::Month:
            exit(CalcDate(StrSubstNo('<-%1M+1D>',Format(MaximumHistoricalPeriods)),HistoryEndDate));
          Periodtype::Quarter:
            exit(CalcDate(StrSubstNo('<-%1Q+1D>',Format(MaximumHistoricalPeriods)),HistoryEndDate));
          Periodtype::Year:
            exit(CalcDate(StrSubstNo('<-%1Y+1D>',Format(MaximumHistoricalPeriods)),HistoryEndDate));
        end;
    end;
}

