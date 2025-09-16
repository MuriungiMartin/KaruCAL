#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5982 "Maintenance Performance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Maintenance Performance.rdlc';
    Caption = 'Maintenance Performance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            DataItemTableView = sorting("Responsibility Center","Service Zone Code",Status,"Contract Group Code") where(Status=const(Signed),"Contract Type"=const(Contract));
            RequestFilterFields = "Responsibility Center";
            column(ReportForNavId_9952; 9952)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CurrReportPageNo;CurrReport.PageNo)
            {
            }
            column(SrvcContractHdrFltr;TableCaption + ': ' + ServContractFilter)
            {
            }
            column(ServContractFilter;ServContractFilter)
            {
            }
            column(CurrentDateFormatted;Text001 + Format(CalcDate('<-CY>',CurrentDate)) + ' .. ' + Format(CurrentDate))
            {
            }
            column(ActualAmount;ActualAmount)
            {
                DecimalPlaces = 0:0;
            }
            column(ExpectedAmount;ExpectedAmount)
            {
                DecimalPlaces = 0:0;
            }
            column(AnnualAmount;AnnualAmount)
            {
                DecimalPlaces = 0:0;
            }
            column(ResponsCntr_ServiceContractHdr;"Responsibility Center")
            {
                IncludeCaption = true;
            }
            column(RespCenterName;RespCenter.Name)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(MaintenancePerformanceCaption;MaintenancePerformanceCaptionLbl)
            {
            }
            column(RealizedCaption;RealizedCaptionLbl)
            {
            }
            column(RealizedAmountCaption;RealizedAmountCaptionLbl)
            {
            }
            column(ExpectedAmountCaption;ExpectedAmountCaptionLbl)
            {
            }
            column(AnnualAmountCaption;AnnualAmountCaptionLbl)
            {
            }
            column(RespCenterNameCaption;RespCenterNameCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ServContractLine.SetRange("Contract Type","Contract Type");
                ServContractLine.SetRange("Contract No.","Contract No.");
                ServContractLine.SetFilter("Next Planned Service Date",'<>%1',0D);
                if not ServContractLine.FindFirst then
                  CurrReport.Skip;

                AnnualAmount := 0;
                ExpectedAmount := 0;
                ActualAmount := 0;

                AnnualServices := CalcNoOfVisits("Service Period","Starting Date",0D,true);
                ExpectedServices := CalcNoOfVisits("Service Period",
                    "Starting Date",ServContractLine."Next Planned Service Date",false);

                Clear(ServShptHeader);
                ServShptHeader.SetCurrentkey("Contract No.","Posting Date");
                ServShptHeader.SetRange("Contract No.","Contract No.");
                ServShptHeader.SetRange("Posting Date",StartingDate,WorkDate);
                ActualServices := 0;
                if ServShptHeader.Find('-') then
                  repeat
                    if (ServShptHeader."Posting Date" >= StartingDate) and (ServShptHeader."Posting Date" <= EndingDate) then
                      ActualServices := ActualServices + 1
                  until ServShptHeader.Next = 0;

                if AnnualServices > 0 then begin
                  RoundedAmount := ROUND("Annual Amount",1);
                  AnnualAmount := AnnualAmount + RoundedAmount;
                  ExpectedAmount := ExpectedAmount + ROUND((RoundedAmount / AnnualServices) * ExpectedServices,1);
                  ActualAmount := ActualAmount + ROUND((RoundedAmount / AnnualServices) * ActualServices,1);
                end;

                if AnnualAmount = 0 then
                  CurrReport.Skip;

                if not RespCenter.Get("Responsibility Center") then
                  Clear(RespCenter);
            end;

            trigger OnPreDataItem()
            begin
                if CurrentDate = 0D then
                  Error(Text000);

                CurrReport.CreateTotals(AnnualAmount,ExpectedAmount,ActualAmount);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CurrentDate;CurrentDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Current Date';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CurrentDate := WorkDate;
    end;

    trigger OnPreReport()
    begin
        ServContractFilter := "Service Contract Header".GetFilters;
    end;

    var
        Text000: label 'You must enter the current date.';
        Text001: label 'Service Period: ';
        ServContractLine: Record "Service Contract Line";
        ServShptHeader: Record "Service Shipment Header";
        RespCenter: Record "Responsibility Center";
        AnnualServices: Decimal;
        ExpectedServices: Decimal;
        ActualServices: Decimal;
        RoundedAmount: Decimal;
        AnnualAmount: Decimal;
        ExpectedAmount: Decimal;
        ActualAmount: Decimal;
        ServContractFilter: Text;
        StartingDate: Date;
        EndingDate: Date;
        CurrentDate: Date;
        PageCaptionLbl: label 'Page';
        MaintenancePerformanceCaptionLbl: label 'Maintenance Performance';
        RealizedCaptionLbl: label 'Realized %';
        RealizedAmountCaptionLbl: label 'Realized Amount';
        ExpectedAmountCaptionLbl: label 'Expected Amount';
        AnnualAmountCaptionLbl: label 'Annual Amount';
        RespCenterNameCaptionLbl: label 'Responsibility Center Name';
        TotalCaptionLbl: label 'Total';

    local procedure CalcNoOfVisits(ServPeriod: DateFormula;FirstDate: Date;NextServiceDate: Date;AllYear: Boolean): Integer
    var
        TempDate: Date;
        i: Integer;
    begin
        if Format(ServPeriod) <> '' then begin
          i := 0;
          StartingDate := CalcDate('<-CY>',CurrentDate);
          if FirstDate > StartingDate then
            StartingDate := FirstDate;
          if AllYear then
            EndingDate := CalcDate('<+CY>',CurrentDate)
          else
            EndingDate := CurrentDate;
          TempDate := StartingDate;
          repeat
            if AllYear then begin
              if TempDate <= EndingDate then
                i := i + 1;
            end else begin
              if (TempDate <= EndingDate) and (CalcDate(ServPeriod,TempDate) <= NextServiceDate) then
                i := i + 1;
            end;
            TempDate := CalcDate(ServPeriod,TempDate);
          until TempDate >= EndingDate;
          exit(i);
        end;
        exit(0);
    end;


    procedure InitializeRequest(CurrentDateFrom: Date)
    begin
        CurrentDate := CurrentDateFrom;
    end;
}

