#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 763 "Aged Acc. Receivable"
{

    trigger OnRun()
    begin
    end;

    var
        OverdueTxt: label 'Overdue';
        AmountTxt: label 'Amount';
        NotDueTxt: label 'Not Overdue';
        OlderTxt: label 'Older';
        GeneralLedgerSetup: Record "General Ledger Setup";
        GLSetupLoaded: Boolean;
        StatusNonPeriodicTxt: label 'All receivables, not overdue and overdue';
        StatusPeriodLengthTxt: label 'Period Length: ';
        Status2WeekOverdueTxt: label '2 weeks overdue';
        Status3MonthsOverdueTxt: label '3 months overdue';
        Status1YearOverdueTxt: label '1 year overdue';
        Status3YearsOverdueTxt: label '3 years overdue';
        Status5YearsOverdueTxt: label '5 years overdue';
        ChartDescriptionMsg: label 'Shows customers'' pending payment amounts summed for a period that you select.\\The first column shows the amount on pending payments that are not past the due date. The following column or columns show overdue amounts within the selected period from the payment due date. The chart shows overdue payment amounts going back up to five years from today''s date depending on the period that you select.';
        ChartPerCustomerDescriptionMsg: label 'Shows the customer''s pending payment amount summed for a period that you select.\\The first column shows the amount on pending payments that are not past the due date. The following column or columns show overdue amounts within the selected period from the payment due date. The chart shows overdue payment amounts going back up to five years from today''s date depending on the period that you select.';
        Status1MonthOverdueTxt: label '1 month overdue';
        Status1QuarterOverdueTxt: label '1 quarter overdue';


    procedure UpdateDataPerCustomer(var BusChartBuf: Record "Business Chart Buffer";CustomerNo: Code[20];var TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary)
    var
        PeriodIndex: Integer;
        PeriodLength: Text[1];
        NoOfPeriods: Integer;
    begin
        with BusChartBuf do begin
          Initialize;
          SetXAxis(OverDueText,"data type"::String);
          AddMeasure(AmountText,1,"data type"::Decimal,"chart type"::Column);

          InitParameters(BusChartBuf,PeriodLength,NoOfPeriods,TempEntryNoAmountBuf);
          CalculateAgedAccReceivable(
            CustomerNo,'',"Period Filter Start Date",PeriodLength,NoOfPeriods,
            TempEntryNoAmountBuf);

          if TempEntryNoAmountBuf.FindSet then
            repeat
              PeriodIndex := TempEntryNoAmountBuf."Entry No.";
              AddColumn(FormatColumnName(PeriodIndex,PeriodLength,NoOfPeriods,"Period Length"));
              SetValueByIndex(0,PeriodIndex,RoundAmount(TempEntryNoAmountBuf.Amount));
            until TempEntryNoAmountBuf.Next = 0
        end;
    end;


    procedure UpdateDataPerGroup(var BusChartBuf: Record "Business Chart Buffer";var TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary)
    var
        CustPostingGroup: Record "Customer Posting Group";
        PeriodIndex: Integer;
        GroupIndex: Integer;
        PeriodLength: Text[1];
        NoOfPeriods: Integer;
    begin
        with BusChartBuf do begin
          Initialize;
          SetXAxis(OverdueTxt,"data type"::String);

          InitParameters(BusChartBuf,PeriodLength,NoOfPeriods,TempEntryNoAmountBuf);
          CalculateAgedAccReceivablePerGroup(
            "Period Filter Start Date",PeriodLength,NoOfPeriods,
            TempEntryNoAmountBuf);

          if CustPostingGroup.FindSet then
            repeat
              AddMeasure(CustPostingGroup.Code,GroupIndex,"data type"::Decimal,"chart type"::StackedColumn);

              TempEntryNoAmountBuf.Reset;
              TempEntryNoAmountBuf.SetRange("Business Unit Code",CustPostingGroup.Code);
              if TempEntryNoAmountBuf.FindSet then
                repeat
                  PeriodIndex := TempEntryNoAmountBuf."Entry No.";
                  if GroupIndex = 0 then
                    AddColumn(FormatColumnName(PeriodIndex,PeriodLength,NoOfPeriods,"Period Length"));
                  SetValueByIndex(GroupIndex,PeriodIndex,RoundAmount(TempEntryNoAmountBuf.Amount));
                until TempEntryNoAmountBuf.Next = 0;
              GroupIndex += 1;
            until CustPostingGroup.Next = 0;
          TempEntryNoAmountBuf.Reset;
        end;
    end;

    local procedure CalculateAgedAccReceivable(CustomerNo: Code[20];CustomerGroupCode: Code[10];StartDate: Date;PeriodLength: Text[1];NoOfPeriods: Integer;var TempEntryNoAmountBuffer: Record "Entry No. Amount Buffer" temporary)
    var
        CustLedgEntryRemainAmt: Query "Cust. Ledg. Entry Remain. Amt.";
        RemainingAmountLCY: Decimal;
        EndDate: Date;
        Index: Integer;
    begin
        if CustomerNo <> '' then
          CustLedgEntryRemainAmt.SetRange(Customer_No,CustomerNo);
        if CustomerGroupCode <> '' then
          CustLedgEntryRemainAmt.SetRange(Customer_Posting_Group,CustomerGroupCode);
        CustLedgEntryRemainAmt.SetRange(IsOpen,true);

        for Index := 0 to NoOfPeriods - 1 do begin
          RemainingAmountLCY := 0;
          CustLedgEntryRemainAmt.SetFilter(
            Due_Date,
            DateFilterByAge(Index,StartDate,PeriodLength,NoOfPeriods,EndDate));
          CustLedgEntryRemainAmt.Open;
          if CustLedgEntryRemainAmt.Read then
            RemainingAmountLCY := CustLedgEntryRemainAmt.Sum_Remaining_Amt_LCY;

          InsertAmountBuffer(Index,CustomerGroupCode,RemainingAmountLCY,StartDate,EndDate,TempEntryNoAmountBuffer)
        end;
    end;

    local procedure CalculateAgedAccReceivablePerGroup(StartDate: Date;PeriodLength: Text[1];NoOfPeriods: Integer;var TempEntryNoAmountBuffer: Record "Entry No. Amount Buffer" temporary)
    var
        CustPostingGroup: Record "Customer Posting Group";
    begin
        if CustPostingGroup.FindSet then
          repeat
            CalculateAgedAccReceivable(
              '',CustPostingGroup.Code,StartDate,PeriodLength,NoOfPeriods,
              TempEntryNoAmountBuffer);
          until CustPostingGroup.Next = 0;
    end;


    procedure DateFilterByAge(Index: Integer;var StartDate: Date;PeriodLength: Text[1];NoOfPeriods: Integer;var EndDate: Date): Text
    begin
        if Index = 0 then // First period - Not due remaining amounts
          exit(StrSubstNo('>=%1',StartDate));

        EndDate := CalcDate('<-1D>',StartDate);
        if Index = NoOfPeriods - 1 then // Last period - Older remaining amounts
          StartDate := 0D
        else
          StartDate := CalcDate(StrSubstNo('<-1%1>',PeriodLength),StartDate);

        exit(StrSubstNo('%1..%2',StartDate,EndDate));
    end;


    procedure InsertAmountBuffer(Index: Integer;BussUnitCode: Code[10];AmountLCY: Decimal;StartDate: Date;EndDate: Date;var TempEntryNoAmountBuffer: Record "Entry No. Amount Buffer" temporary)
    begin
        with TempEntryNoAmountBuffer do begin
          Init;
          "Entry No." := Index;
          "Business Unit Code" := BussUnitCode;
          Amount := AmountLCY;
          "Start Date" := StartDate;
          "End Date" := EndDate;
          Insert;
        end;
    end;


    procedure InitParameters(BusChartBuf: Record "Business Chart Buffer";var PeriodLength: Text[1];var NoOfPeriods: Integer;var TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary)
    begin
        TempEntryNoAmountBuf.DeleteAll;
        PeriodLength := GetPeriod(BusChartBuf);
        NoOfPeriods := GetNoOfPeriods(BusChartBuf);
    end;

    local procedure GetPeriod(BusChartBuf: Record "Business Chart Buffer"): Text[1]
    begin
        if BusChartBuf."Period Length" = BusChartBuf."period length"::None then
          exit('W');
        exit(BusChartBuf.GetPeriodLength);
    end;

    local procedure GetNoOfPeriods(BusChartBuf: Record "Business Chart Buffer"): Integer
    var
        OfficeMgt: Codeunit "Office Management";
        NoOfPeriods: Integer;
    begin
        NoOfPeriods := 14;
        case BusChartBuf."Period Length" of
          BusChartBuf."period length"::Day:
            NoOfPeriods := 16;
          BusChartBuf."period length"::Week,
          BusChartBuf."period length"::Quarter:
            if OfficeMgt.IsAvailable then
              NoOfPeriods := 6
            else
              NoOfPeriods := 14;
          BusChartBuf."period length"::Month:
            if OfficeMgt.IsAvailable then
              NoOfPeriods := 5
            else
              NoOfPeriods := 14;
          BusChartBuf."period length"::Year:
            if OfficeMgt.IsAvailable then
              NoOfPeriods := 5
            else
              NoOfPeriods := 7;
          BusChartBuf."period length"::None:
            NoOfPeriods := 2;
        end;
        exit(NoOfPeriods);
    end;


    procedure FormatColumnName(Index: Integer;PeriodLength: Text[1];NoOfColumns: Integer;Period: Option): Text
    var
        BusChartBuf: Record "Business Chart Buffer";
        PeriodDateFormula: DateFormula;
    begin
        if Index = 0 then
          exit(NotDueTxt);

        if Index = NoOfColumns - 1 then begin
          if Period = BusChartBuf."period length"::None then
            exit(OverdueTxt);
          exit(OlderTxt);
        end;

        // Period length text localized by date formula
        Evaluate(PeriodDateFormula,StrSubstNo('<1%1>',PeriodLength));
        exit(StrSubstNo('%1%2',Index,DelChr(Format(PeriodDateFormula),'=','1')));
    end;


    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer";CustomerNo: Code[20];var TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary)
    var
        MeasureName: Text;
        CustomerGroupCode: Code[10];
    begin
        with TempEntryNoAmountBuf do begin
          if CustomerNo <> '' then
            CustomerGroupCode := ''
          else begin
            MeasureName := BusChartBuf.GetMeasureName(BusChartBuf."Drill-Down Measure Index");
            CustomerGroupCode := CopyStr(MeasureName,1,MaxStrLen(CustomerGroupCode));
          end;
          if Get(CustomerGroupCode,BusChartBuf."Drill-Down X Index") then
            DrillDownCustLedgEntries(CustomerNo,CustomerGroupCode,"Start Date","End Date");
        end;
    end;


    procedure DrillDownByGroup(var BusChartBuf: Record "Business Chart Buffer";var TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary)
    begin
        DrillDown(BusChartBuf,'',TempEntryNoAmountBuf);
    end;


    procedure DrillDownCustLedgEntries(CustomerNo: Code[20];CustomerGroupCode: Code[10];StartDate: Date;EndDate: Date)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetCurrentkey("Customer No.",Open,Positive,"Due Date");
        if CustomerNo <> '' then
          CustLedgEntry.SetRange("Customer No.",CustomerNo);
        if EndDate = 0D then
          CustLedgEntry.SetFilter("Due Date",'>=%1',StartDate)
        else
          CustLedgEntry.SetRange("Due Date",StartDate,EndDate);
        CustLedgEntry.SetRange(Open,true);
        if CustomerGroupCode <> '' then
          CustLedgEntry.SetRange("Customer Posting Group",CustomerGroupCode);
        if CustLedgEntry.IsEmpty then
          exit;
        Page.Run(Page::"Customer Ledger Entries",CustLedgEntry);
    end;


    procedure Description(PerCustomer: Boolean): Text
    begin
        if PerCustomer then
          exit(ChartPerCustomerDescriptionMsg);
        exit(ChartDescriptionMsg);
    end;


    procedure UpdateStatusText(BusChartBuf: Record "Business Chart Buffer"): Text
    var
        OfficeMgt: Codeunit "Office Management";
        StatusText: Text;
    begin
        StatusText := StatusPeriodLengthTxt + Format(BusChartBuf."Period Length");

        case BusChartBuf."Period Length" of
          BusChartBuf."period length"::Day:
            StatusText := StatusText + ' | ' + Status2WeekOverdueTxt;
          BusChartBuf."period length"::Week:
            if OfficeMgt.IsAvailable then
              StatusText := StatusText + ' | ' + Status1MonthOverdueTxt
            else
              StatusText := StatusText + ' | ' + Status3MonthsOverdueTxt;
          BusChartBuf."period length"::Month:
            if OfficeMgt.IsAvailable then
              StatusText := StatusText + ' | ' + Status1QuarterOverdueTxt
            else
              StatusText := StatusText + ' | ' + Status1YearOverdueTxt;
          BusChartBuf."period length"::Quarter:
            if OfficeMgt.IsAvailable then
              StatusText := StatusText + ' | ' + Status1YearOverdueTxt
            else
              StatusText := StatusText + ' | ' + Status3YearsOverdueTxt;
          BusChartBuf."period length"::Year:
            if OfficeMgt.IsAvailable then
              StatusText := StatusText + ' | ' + Status3YearsOverdueTxt
            else
              StatusText := StatusText + ' | ' + Status5YearsOverdueTxt;
          BusChartBuf."period length"::None:
            StatusText := StatusNonPeriodicTxt;
        end;

        exit(StatusText);
    end;


    procedure SaveSettings(BusChartBuf: Record "Business Chart Buffer")
    var
        BusChartUserSetup: Record "Business Chart User Setup";
    begin
        BusChartUserSetup."Period Length" := BusChartBuf."Period Length";
        BusChartUserSetup.SaveSetupCU(BusChartUserSetup,Codeunit::"Aged Acc. Receivable");
    end;


    procedure InvoicePaymentDaysAverage(CustomerNo: Code[20]): Decimal
    begin
        exit(ROUND(CalcInvPmtDaysAverage(CustomerNo),1));
    end;

    local procedure CalcInvPmtDaysAverage(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PaymentDays: Integer;
        InvoiceCount: Integer;
    begin
        CustLedgEntry.SetCurrentkey("Document Type","Customer No.");
        if CustomerNo <> '' then
          CustLedgEntry.SetRange("Customer No.",CustomerNo);
        CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::Invoice);
        CustLedgEntry.SetRange(Open,false);
        if not CustLedgEntry.FindSet then
          exit(0);

        repeat
          DetailedCustLedgEntry.SetCurrentkey("Cust. Ledger Entry No.");
          DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
          DetailedCustLedgEntry.SetRange("Document Type",DetailedCustLedgEntry."document type"::Payment);
          if DetailedCustLedgEntry.FindLast then begin
            PaymentDays += DetailedCustLedgEntry."Posting Date" - CustLedgEntry."Due Date";
            InvoiceCount += 1;
          end;
        until CustLedgEntry.Next = 0;

        if InvoiceCount = 0 then
          exit(0);

        exit(PaymentDays / InvoiceCount);
    end;


    procedure RoundAmount(Amount: Decimal): Decimal
    begin
        if not GLSetupLoaded then begin
          GeneralLedgerSetup.Get;
          GLSetupLoaded := true;
        end;

        exit(ROUND(Amount,GeneralLedgerSetup."Amount Rounding Precision"));
    end;


    procedure OverDueText(): Text
    begin
        exit(OverdueTxt);
    end;


    procedure AmountText(): Text
    begin
        exit(AmountTxt);
    end;
}

