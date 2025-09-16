#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7 "Trial Balance/Previous Year"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Trial BalancePrevious Year.rdlc';
    Caption = 'Trial Balance/Previous Year';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Account Type","Date Filter","Global Dimension 1 Filter","Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(GLAccTableCaptionGLFilter;TableCaption + ': ' + GLFilter)
            {
            }
            column(LongText;LongText1[1] + LongText1[2] + LongText1[3] + LongText1[4])
            {
            }
            column(EmptyString;'')
            {
            }
            column(TrialBalancePreviousYearCaption;TrialBalancePreviousYearCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(NetChangeCaption;NetChangeCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(DebitCaption;DebitCaptionLbl)
            {
            }
            column(CreditCaption;CreditCaptionLbl)
            {
            }
            column(PercentCaption;PercentCaptionLbl)
            {
            }
            column(LastYearCaption;LastYearCaptionLbl)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(No_GLAccount;"G/L Account"."No.")
                {
                    IncludeCaption = true;
                }
                column(GLAccIndentationGLAccName;PadStr('',"G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(FiscalYearNetChange;FiscalYearNetChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(NegFiscalYearNetChange;-FiscalYearNetChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(NetChangeIncreasePct;NetChangeIncreasePct)
                {
                    DecimalPlaces = 1:1;
                }
                column(LastYearNetChange;LastYearNetChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(FiscalYearBalance;FiscalYearBalance)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(NegFiscalYearBalance;-FiscalYearBalance)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(BalanceIncreasePct;BalanceIncreasePct)
                {
                    DecimalPlaces = 1:1;
                }
                column(LastYearBalance;LastYearBalance)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(PageGroupNo;PageGroupNo)
                {
                }
                column(GLAccountType;GLAccountType)
                {
                }
                dataitem(BlankLineRepeater;"Integer")
                {
                    column(ReportForNavId_5; 5)
                    {
                    }
                    column(BlankLineNo;BlankLineNo)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if BlankLineNo = 0 then
                          CurrReport.Break;

                        BlankLineNo -= 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ReqFormDateFilter := GetFilter("Date Filter");

                SetRange("Date Filter",FiscalYearStartDate,FiscalYearEndDate);
                CalcFields("Net Change","Balance at Date");
                FiscalYearBalance := "Balance at Date";
                FiscalYearNetChange := "Net Change";
                SetRange("Date Filter",LastYearStartDate,LastYearEndDate);
                CalcFields("Net Change","Balance at Date");
                LastYearBalance := "Balance at Date";
                LastYearNetChange := "Net Change";
                if LastYearNetChange <> 0 then
                  NetChangeIncreasePct := ROUND(FiscalYearNetChange / LastYearNetChange * 100,0.1)
                else
                  NetChangeIncreasePct := 0;

                if LastYearBalance <> 0 then
                  BalanceIncreasePct := ROUND(FiscalYearBalance / LastYearBalance * 100,0.1)
                else
                  BalanceIncreasePct := 0;

                SetFilter("Date Filter",ReqFormDateFilter);

                LongText1[1] :=
                  StrSubstNo(
                    Text001,
                    FiscalYearStartDate,FiscalYearEndDate,LastYearStartDate,LastYearEndDate);
                LongText1[2] := '';
                LongText1[3] := '';
                LongText1[4] := '';

                GLAccountType := "Account Type";

                if IsNewPage then begin
                  PageGroupNo := PageGroupNo + 1;
                  IsNewPage := false;
                end;
                if "New Page" then
                  IsNewPage := true;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
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
        GLFilter := "G/L Account".GetFilters;
        FiscalYearStartDate := "G/L Account".GetRangeMin("Date Filter");
        FiscalYearEndDate := "G/L Account".GetRangemax("Date Filter");
        LastYearStartDate := CalcDate('<-1Y>',NormalDate(FiscalYearStartDate) + 1) - 1;
        LastYearEndDate := CalcDate('<-1Y>',NormalDate(FiscalYearEndDate) + 1) - 1;
        if FiscalYearStartDate <> NormalDate(FiscalYearStartDate) then
          LastYearStartDate := ClosingDate(LastYearStartDate);
        if FiscalYearEndDate <> NormalDate(FiscalYearEndDate) then
          LastYearEndDate := ClosingDate(LastYearEndDate);
    end;

    var
        Text001: label 'Period: %1..%2 versus %3..%4';
        GLFilter: Text;
        NetChangeIncreasePct: Decimal;
        BalanceIncreasePct: Decimal;
        LastYearNetChange: Decimal;
        LastYearBalance: Decimal;
        LastYearStartDate: Date;
        LastYearEndDate: Date;
        FiscalYearNetChange: Decimal;
        FiscalYearBalance: Decimal;
        FiscalYearStartDate: Date;
        FiscalYearEndDate: Date;
        LongText1: array [4] of Text[132];
        ReqFormDateFilter: Text[250];
        PageGroupNo: Integer;
        GLAccountType: Integer;
        IsNewPage: Boolean;
        TrialBalancePreviousYearCaptionLbl: label 'Trial Balance/Previous Year';
        PageNoCaptionLbl: label 'Page';
        NetChangeCaptionLbl: label 'Net Change';
        BalanceCaptionLbl: label 'Balance';
        NameCaptionLbl: label 'Name';
        DebitCaptionLbl: label 'Debit';
        CreditCaptionLbl: label 'Credit';
        PercentCaptionLbl: label '% of';
        LastYearCaptionLbl: label 'Last Year';
        BlankLineNo: Integer;
}

