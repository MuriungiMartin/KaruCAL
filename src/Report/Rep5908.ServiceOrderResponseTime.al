#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5908 "Service Order - Response Time"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Order - Response Time.rdlc';
    Caption = 'Service Order - Response Time';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Shipment Header";"Service Shipment Header")
        {
            DataItemTableView = sorting("Responsibility Center","Posting Date");
            RequestFilterFields = "Responsibility Center","Posting Date";
            column(ReportForNavId_2735; 2735)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ServShipHeadFilter1;TableCaption + ': ' + ServShipmentHeaderFilter)
            {
            }
            column(ServShipHeadFilter2;ServShipmentHeaderFilter)
            {
            }
            column(OrderNo_ServShptHdr;"Order No.")
            {
                IncludeCaption = true;
            }
            column(CustNo_ServShptHdr;"Customer No.")
            {
                IncludeCaption = true;
            }
            column(OrderDate_ServShptHdr;Format("Order Date"))
            {
            }
            column(OrderTime_ServShptHdr;Format("Order Time"))
            {
            }
            column(Name_ServShptHdr;Name)
            {
                IncludeCaption = true;
            }
            column(ActualResTimHrs_ServShptHdr;"Actual Response Time (Hours)")
            {
                IncludeCaption = true;
            }
            column(StartingDate_ServShptHdr;Format("Starting Date"))
            {
            }
            column(StartingTime_ServShptHdr;Format("Starting Time"))
            {
            }
            column(TotalTime;TotalTime)
            {
            }
            column(TotalCalls;TotalCalls)
            {
            }
            column(TotalTimeFooter;TotalTimeFooter)
            {
            }
            column(TotalCallsFooter;TotalCallsFooter)
            {
            }
            column(AvgResTimeRespCenter;Text000 + FieldCaption("Responsibility Center") + ' ' + "Responsibility Center")
            {
            }
            column(RoundTotalTimeTotalCalls;ActRespTime)
            {
                DecimalPlaces = 0:5;
            }
            column(AvgResponseTime;AvgResponseTimeLbl)
            {
            }
            column(RespCenter_ServShptHdr;"Responsibility Center")
            {
            }
            column(ServOrderRespTimeCaption;ServOrderRespTimeCaptionLbl)
            {
            }
            column(CurrReportPageNOCaption;CurrReportPageNOCaptionLbl)
            {
            }
            column(ServShptHdrOrderDtCaption;ServShptHdrOrderDtCaptionLbl)
            {
            }
            column(ServShptHdrOrdTimeCaption;ServShptHdrOrdTimeCaptionLbl)
            {
            }
            column(ServShptHdrStartDtCaption;ServShptHdrStartDtCaptionLbl)
            {
            }
            column(ServShptHdrStrtTimCaption;ServShptHdrStrtTimCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if LastRespCenterCode <> "Responsibility Center" then begin
                  TotalCalls := 0;
                  TotalTime := 0;
                end;

                if ("Order No." <> '') and (LastOrderNo <> "Order No.") then begin
                  TotalCalls := TotalCalls + 1;
                  TotalTime := TotalTime + "Actual Response Time (Hours)";
                  TotalCallsFooter += 1;
                  TotalTimeFooter += "Actual Response Time (Hours)";
                  LastOrderNo := "Order No.";
                end else
                  CurrReport.Skip;

                LastRespCenterCode := "Responsibility Center";
            end;

            trigger OnPreDataItem()
            begin
                TotalTime := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ServShipmentHeaderFilter := "Service Shipment Header".GetFilters;
    end;

    var
        Text000: label 'Average Response Time Per ';
        ServShipmentHeaderFilter: Text;
        TotalTime: Decimal;
        TotalCalls: Integer;
        LastOrderNo: Code[20];
        ActRespTime: Decimal;
        TotalCallsFooter: Integer;
        TotalTimeFooter: Decimal;
        LastRespCenterCode: Code[10];
        AvgResponseTimeLbl: label 'Average Response Time';
        ServOrderRespTimeCaptionLbl: label 'Service Order - Response Time';
        CurrReportPageNOCaptionLbl: label 'Page';
        ServShptHdrOrderDtCaptionLbl: label 'Order Date';
        ServShptHdrOrdTimeCaptionLbl: label 'Order Time';
        ServShptHdrStartDtCaptionLbl: label 'Starting Date';
        ServShptHdrStrtTimCaptionLbl: label 'Starting Time';
}

