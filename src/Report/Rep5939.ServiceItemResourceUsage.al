#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5939 "Service Item - Resource Usage"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Item - Resource Usage.rdlc';
    Caption = 'Service Item - Resource Usage';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Item";"Service Item")
        {
            DataItemTableView = sorting("Item No.","Serial No.") where("Type Filter"=const(Resource));
            RequestFilterFields = "No.";
            column(ReportForNavId_5875; 5875)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(ServiceItemCaption;TableCaption + ': ' + ServItemFilters)
            {
            }
            column(ServItemFilters;ServItemFilters)
            {
            }
            column(ShowDetail;ShowDetail)
            {
            }
            column(ItemNo_ServiceItem;"Item No.")
            {
                IncludeCaption = true;
            }
            column(ItemDesc_ServiceItem;"Item Description")
            {
            }
            column(No_ServiceItem;"No.")
            {
            }
            column(ServItemGrCode_ServiceItem;"Service Item Group Code")
            {
                IncludeCaption = true;
            }
            column(Desc_ServiceItem;Description)
            {
                IncludeCaption = true;
            }
            column(OrderProfit;OrderProfit)
            {
                AutoFormatType = 1;
            }
            column(OrderProfitPct;OrderProfitPct)
            {
                DecimalPlaces = 1:1;
            }
            column(TotalQty_ServiceItem;"Total Quantity")
            {
            }
            column(UsageCost_ServiceItem;"Usage (Cost)")
            {
            }
            column(UsageAmt_ServiceItem;"Usage (Amount)")
            {
            }
            column(TotForItemNo_ServiceItem;Text0002 + ' ' + FieldCaption("Item No."))
            {
            }
            column(TotalForReport;TotalForReportLbl)
            {
            }
            column(ServItemResourceUsageCaption;ServItemResourceUsageCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ProfitCaption;ProfitCaptionLbl)
            {
            }
            column(ProfitAmtCaption;ProfitAmtCaptionLbl)
            {
            }
            column(UsageAmtCaption;UsageAmtCaptionLbl)
            {
            }
            column(UsageCostCaption;UsageCostCaptionLbl)
            {
            }
            column(TotalQtyCaption;TotalQtyCaptionLbl)
            {
            }
            column(ServItemNoCaption;ServItemNoCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Usage (Cost)","Usage (Amount)","Total Quantity");

                OrderProfit := "Usage (Amount)" - "Usage (Cost)";
                if "Usage (Amount)" <> 0 then
                  OrderProfitPct := ROUND(100 * OrderProfit / "Usage (Amount)",0.1)
                else
                  OrderProfitPct := 0;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Usage (Cost)","Usage (Amount)","Total Quantity",OrderProfit);
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
                    field("Show Detail";ShowDetail)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show detail';
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

    trigger OnPreReport()
    begin
        ServItemFilters := "Service Item".GetFilters;
    end;

    var
        OrderProfit: Decimal;
        OrderProfitPct: Decimal;
        ShowDetail: Boolean;
        ServItemFilters: Text;
        Text0002: label 'Total for';
        TotalForReportLbl: label 'Total for report';
        ServItemResourceUsageCaptionLbl: label 'Service Item - Resource Usage';
        CurrReportPageNoCaptionLbl: label 'Page';
        ProfitCaptionLbl: label 'Profit %';
        ProfitAmtCaptionLbl: label 'Profit Amount';
        UsageAmtCaptionLbl: label 'Usage (Amount)';
        UsageCostCaptionLbl: label 'Usage (Cost)';
        TotalQtyCaptionLbl: label 'Total Quantity';
        ServItemNoCaptionLbl: label 'Service Item No.';


    procedure InitializeRequest(ShowDetailFrom: Boolean)
    begin
        ShowDetail := ShowDetailFrom;
    end;
}

