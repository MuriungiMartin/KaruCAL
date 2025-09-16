#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5062 "Sales Cycle - Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Cycle - Analysis.rdlc';
    Caption = 'Sales Cycle - Analysis';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Sales Cycle";"Sales Cycle")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code",Blocked;
            column(ReportForNavId_3079; 3079)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(TblCptnSalesCycleFilter;TableCaption + ': ' + SalesCycleFilter)
            {
            }
            column(Code_SalesCycle;Code)
            {
            }
            column(Description_SalesCycle;Description)
            {
            }
            column(SalesFilter;SalesCycleFilter)
            {
            }
            column(NoOfOpportunities;NoOfOpportunities)
            {
                DecimalPlaces = 0:0;
            }
            column(EstdValueLCY_SalesCycle;"Estimated Value (LCY)")
            {
            }
            column(CalcCurrValLCY_SalesCycle;"Calcd. Current Value (LCY)")
            {
            }
            column(AverageNoOfDays;AverageNoOfDays)
            {
                DecimalPlaces = 0:2;
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(SalesCycleAnalysisCaption;SalesCycleAnalysisCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Sales Cycle Stage";"Sales Cycle Stage")
            {
                DataItemLink = "Sales Cycle Code"=field(Code);
                DataItemTableView = sorting("Sales Cycle Code",Stage);
                column(ReportForNavId_8511; 8511)
                {
                }
                column(Stage_SalesCycleStage;Stage)
                {
                    IncludeCaption = true;
                }
                column(Descriptn_SalesCycleStage;Description)
                {
                    IncludeCaption = true;
                }
                column(ActyCode_SalesCycleStage;"Activity Code")
                {
                    IncludeCaption = true;
                }
                column(NoOfOppt_SalesCycleStage;"No. of Opportunities")
                {
                    IncludeCaption = true;
                }
                column(EstValLCY_SalesCycleStage;"Estimated Value (LCY)")
                {
                    IncludeCaption = true;
                }
                column(CurValLCY_SalesCycleStage;"Calcd. Current Value (LCY)")
                {
                    IncludeCaption = true;
                }
                column(AvgNoOfDay_SalesCycleStage;"Average No. of Days")
                {
                    IncludeCaption = true;
                }
                column(NoOfOpportunities2;NoOfOpportunities)
                {
                    DecimalPlaces = 0:0;
                }
                column(SalCyclCd_SalesCycleStage;"Sales Cycle Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    NoOfOpportunities := "No. of Opportunities";
                    AverageNoOfDays := "Average No. of Days";
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(NoOfOpportunities,AverageNoOfDays);
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(NoOfOpportunities,AverageNoOfDays);
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
        SalesCycleFilter := "Sales Cycle".GetFilters;
    end;

    var
        SalesCycleFilter: Text;
        NoOfOpportunities: Decimal;
        AverageNoOfDays: Decimal;
        CurrReportPageNoCaptionLbl: label 'Page';
        SalesCycleAnalysisCaptionLbl: label 'Sales Cycle - Analysis';
        TotalCaptionLbl: label 'Total';
}

