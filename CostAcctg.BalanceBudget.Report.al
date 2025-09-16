#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1138 "Cost Acctg. Balance/Budget"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Acctg. BalanceBudget.rdlc';
    Caption = 'Cost Acctg. Balance/Budget';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Cost Type";"Cost Type")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.",Type,"Budget Filter","Cost Center Filter","Cost Object Filter";
            column(ReportForNavId_2867; 2867)
            {
            }
            column(YearHeading;YearHeading)
            {
            }
            column(YtdHeading;YtdHeading)
            {
            }
            column(FilterTxt;FilterTxt)
            {
            }
            column(ActPeriodHeading;ActPeriodHeading)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ActPct;ActPct)
            {
                DecimalPlaces = 1:1;
            }
            column(ActDiff;ActDiff)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(ActBud;ActBud)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(ActAmt;ActAmt)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(NameIndented;PadStr('',Indentation * 2) + Name)
            {
            }
            column(No_CostType;"No.")
            {
            }
            column(YtdPct;YtdPct)
            {
                DecimalPlaces = 1:1;
            }
            column(YtdDiff;YtdDiff)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(YtdBud;YtdBud)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(YtdAmt;YtdAmt)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(YearBugdet;YearBugdet)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(ShareYearActPct;ShareYearActPct)
            {
                AutoFormatType = 1;
                DecimalPlaces = 1:1;
            }
            column(ShareYearBudPct;ShareYearBudPct)
            {
                AutoFormatType = 1;
                DecimalPlaces = 1:1;
            }
            column(LineType_CostType;CostTypeLineType)
            {
            }
            column(BlankLine_CostType;"Blank Line")
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(CurrReportPAGENOCaption;CurrReportPAGENOCaptionLbl)
            {
            }
            column(CostCenterReportCaption;CostCenterReportCaptionLbl)
            {
            }
            column(ActDiffCaption;ActDiffCaptionLbl)
            {
            }
            column(ActPctCaption;ActPctCaptionLbl)
            {
            }
            column(ActBudCaption;ActBudCaptionLbl)
            {
            }
            column(ActAmtCaption;ActAmtCaptionLbl)
            {
            }
            column(PADSTRIndentation2NameCaption;PADSTRIndentation2NameCaptionLbl)
            {
            }
            column(CostTypeNoCaption;CostTypeNoCaptionLbl)
            {
            }
            column(ShareYearBudPctCaption;ShareYearBudPctCaptionLbl)
            {
            }
            column(ShareYearActPctCaption;ShareYearActPctCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // Period
                SetRange("Date Filter",StartDate,EndDate);
                CalcFields("Net Change","Budget Amount");
                ActAmt := "Net Change";
                ActBud := "Budget Amount";
                if ActBud < 0 then
                  ActDiff := ActBud - ActAmt
                else
                  ActDiff := ActAmt - ActBud;

                ActPct := 0;
                if ActBud <> 0 then
                  ActPct := ROUND(ActAmt * 100 / ActBud,0.1);

                // YDT
                SetRange("Date Filter",YearStartDate,EndDate);
                CalcFields("Net Change","Budget Amount");
                YtdAmt := "Net Change";
                YtdBud := "Budget Amount";

                if YtdAmt < 0 then
                  YtdDiff := YtdBud - YtdAmt
                else
                  YtdDiff := YtdAmt - YtdBud;

                YtdPct := 0;
                if YtdBud <> 0 then
                  YtdPct := ROUND(YtdAmt * 100 / YtdBud,0.1);

                // Year
                SetRange("Date Filter",YearStartDate,YearEndDate);
                CalcFields("Budget Amount");
                YearBugdet := "Budget Amount";

                ShareYearActPct := 0;
                ShareYearBudPct := 0;
                if YearBugdet <> 0 then begin
                  ShareYearActPct := ROUND(YtdAmt * 100 / YearBugdet,0.1);
                  ShareYearBudPct := ROUND(YtdBud * 100 / YearBugdet,0.1);
                end;

                if (Type = Type::"Cost Type") and OnlyAccWithEntries and
                   (ActAmt = 0) and (ActBud = 0) and
                   (YtdAmt = 0) and (YtdBud = 0) and (YearBugdet = 0)
                then
                  CurrReport.Skip;

                PageGroupNo := NextPageGroupNo;
                if "New Page" then
                  NextPageGroupNo := PageGroupNo + 1;
                CostTypeLineType := Type;
            end;

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) or (EndDate = 0D) or (YearStartDate = 0D) or (YearEndDate = 0D) then
                  Error(Text000);

                if (EndDate < StartDate) or (YearEndDate < YearStartDate) then
                  Error(Text001);

                if GetFilters <> '' then
                  FilterTxt := Text002 + GetFilters;

                if (GetFilter("Cost Center Filter") = '') and (GetFilter("Cost Object Filter") = '') then
                  if not Confirm(Text003) then
                    Error('');

                if GetFilter("Budget Filter") = '' then
                  if not Confirm(Text004) then
                    Error('');

                ActPeriodHeading := StrSubstNo(Text005,StartDate,EndDate);
                YtdHeading := StrSubstNo(Text006,YearStartDate,EndDate);
                YearHeading := StrSubstNo(Text007,YearStartDate,YearEndDate);

                PageGroupNo := 1;
                NextPageGroupNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Actual period")
                    {
                        Caption = 'Actual period';
                        field(StartDate;StartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';

                            trigger OnValidate()
                            begin
                                CalcPeriod;
                            end;
                        }
                        field(EndDate;EndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';
                        }
                    }
                    group("Fiscal Year")
                    {
                        Caption = 'Fiscal Year';
                        field(YearStartDate;YearStartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Year Starting Date';
                        }
                        field(YearEndDate;YearEndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Year Ending Date';
                        }
                    }
                    field(OnlyShowAccWithEntries;OnlyAccWithEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Only Cost Centers with Balance or Cost Entries';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if StartDate = 0D then
              StartDate := CalcDate('<-CM>',Today);

            CalcPeriod;
        end;
    }

    labels
    {
    }

    var
        StartDate: Date;
        EndDate: Date;
        YearStartDate: Date;
        YearEndDate: Date;
        FilterTxt: Text;
        OnlyAccWithEntries: Boolean;
        ActPeriodHeading: Text[80];
        YtdHeading: Text[80];
        YearHeading: Text[80];
        ActAmt: Decimal;
        ActBud: Decimal;
        ActDiff: Decimal;
        ActPct: Decimal;
        YtdAmt: Decimal;
        YtdBud: Decimal;
        YtdDiff: Decimal;
        YtdPct: Decimal;
        YearBugdet: Decimal;
        ShareYearActPct: Decimal;
        ShareYearBudPct: Decimal;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        CostTypeLineType: Integer;
        Text000: label 'Starting date and ending date in the actual period must be defined.';
        Text001: label 'Ending date must not be before starting date.';
        Text002: label 'Filter: ';
        Text003: label 'You have not defined a filter on cost center or cost object.\Do you want to start the report anyway?';
        Text004: label 'You have not defined a budget filter. Do you want to start the report anyway?';
        Text005: label 'Actual period %1 - %2', Comment='%1=date,%2=date';
        Text006: label 'Cumulated %1 - %2', Comment='%1=date,%2=date';
        Text007: label 'Year %1 - %2', Comment='%1=date,%2=date';
        CurrReportPAGENOCaptionLbl: label 'Page';
        CostCenterReportCaptionLbl: label 'Cost Acctg. Balance/Budget';
        ActDiffCaptionLbl: label 'Difference';
        ActPctCaptionLbl: label 'Act %';
        ActBudCaptionLbl: label 'Budget';
        ActAmtCaptionLbl: label 'Act.';
        PADSTRIndentation2NameCaptionLbl: label 'Name';
        CostTypeNoCaptionLbl: label 'Number';
        ShareYearBudPctCaptionLbl: label 'Accum. Budget %';
        ShareYearActPctCaptionLbl: label 'Accum. Actual %';

    local procedure CalcPeriod()
    begin
        if StartDate = 0D then
          StartDate := CalcDate('<-CM>',Today);

        EndDate := CalcDate('<CM>',StartDate);
        YearStartDate := CalcDate('<-CY>',StartDate);
        YearEndDate := CalcDate('<CY>',StartDate);
    end;
}

