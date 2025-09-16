#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 9 "Trial Balance/Budget"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Trial BalanceBudget.rdlc';
    Caption = 'Trial Balance/Budget';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Account Type","Date Filter","Budget Filter","Global Dimension 1 Filter","Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(STRSUBSTNO_Text000_PeriodText_;StrSubstNo(Text000,PeriodText))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(USERID;UserId)
            {
            }
            column(GLBudgetFilter;GLBudgetFilter)
            {
            }
            column(NoOfBlankLines;"No. of Blank Lines")
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter;TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter;GLFilter)
            {
            }
            column(GLAccType;"Account Type")
            {
            }
            column(AccountTypePosting;GLAccountTypePosting)
            {
            }
            column(EmptyString;'')
            {
            }
            column(EmptyString_Control14;'')
            {
            }
            column(G_L_Account_No_;"No.")
            {
            }
            column(Trial_Balance_BudgetCaption;Trial_Balance_BudgetCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(GLBudgetFilterCaption;GLBudgetFilterCaptionLbl)
            {
            }
            column(Net_ChangeCaption;Net_ChangeCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption;FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption;PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption;G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control28Caption;G_L_Account___Net_Change__Control28CaptionLbl)
            {
            }
            column(DiffPctCaption;DiffPctCaptionLbl)
            {
            }
            column(G_L_Account___Budgeted_Amount_Caption;G_L_Account___Budgeted_Amount_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date_Caption;G_L_Account___Balance_at_Date_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date__Control32Caption;G_L_Account___Balance_at_Date__Control32CaptionLbl)
            {
            }
            column(DiffAtDatePctCaption;DiffAtDatePctCaptionLbl)
            {
            }
            column(GLAcc2__Budget_at_Date_Caption;GLAcc2__Budget_at_Date_CaptionLbl)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(G_L_Account___No__;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name;PadStr('',"G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change_;+"G/L Account"."Net Change")
                {
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___Net_Change__Control28;-"G/L Account"."Net Change")
                {
                    DecimalPlaces = 0:0;
                }
                column(DiffPct;DiffPct)
                {
                    DecimalPlaces = 1:1;
                }
                column(G_L_Account___Budgeted_Amount_;+"G/L Account"."Budgeted Amount")
                {
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___Balance_at_Date_;+"G/L Account"."Balance at Date")
                {
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___Balance_at_Date__Control32;-"G/L Account"."Balance at Date")
                {
                    DecimalPlaces = 0:0;
                }
                column(DiffAtDatePct;DiffAtDatePct)
                {
                    DecimalPlaces = 1:1;
                }
                column(GLAcc2__Budget_at_Date_;+GLAcc2."Budget at Date")
                {
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___No___Control35;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control36;PadStr('',"G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change__Control37;+"G/L Account"."Net Change")
                {
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___Net_Change__Control38;-"G/L Account"."Net Change")
                {
                    DecimalPlaces = 0:0;
                }
                column(DiffPct_Control39;DiffPct)
                {
                    DecimalPlaces = 1:1;
                }
                column(G_L_Account___Budgeted_Amount__Control40;+"G/L Account"."Budgeted Amount")
                {
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___Balance_at_Date__Control41;+"G/L Account"."Balance at Date")
                {
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___Balance_at_Date__Control42;-"G/L Account"."Balance at Date")
                {
                    DecimalPlaces = 0:0;
                }
                column(DiffAtDatePct_Control43;DiffAtDatePct)
                {
                    DecimalPlaces = 1:1;
                }
                column(GLAcc2__Budget_at_Date__Control44;+GLAcc2."Budget at Date")
                {
                    DecimalPlaces = 0:0;
                }
                column(Integer_Number;Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change","Budgeted Amount","Balance at Date");
                GLAcc2 := "G/L Account";
                GLAcc2.CalcFields("Budget at Date");
                if "Budgeted Amount" = 0 then
                  DiffPct := 0
                else
                  DiffPct := "Net Change" / "Budgeted Amount" * 100;
                if GLAcc2."Budget at Date" = 0 then
                  DiffAtDatePct := 0
                else
                  DiffAtDatePct := "Balance at Date" / GLAcc2."Budget at Date" * 100;

                GLAccountTypePosting := "Account Type" = "account type"::Posting;
            end;

            trigger OnPreDataItem()
            begin
                GLAcc2.CopyFilters("G/L Account");
                AccountingPeriod.Reset;
                AccountingPeriod.SetRange("New Fiscal Year",true);
                EndDate := GetRangemax("Date Filter");
                AccountingPeriod."Starting Date" := GetRangeMin("Date Filter");
                AccountingPeriod.Find('=<');
                GLAcc2.SetRange("Date Filter",AccountingPeriod."Starting Date",EndDate);
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
        PeriodText := "G/L Account".GetFilter("Date Filter");
        GLBudgetFilter := "G/L Account".GetFilter("Budget Filter");
    end;

    var
        Text000: label 'Period: %1';
        GLAcc2: Record "G/L Account";
        AccountingPeriod: Record "Accounting Period";
        GLFilter: Text;
        GLBudgetFilter: Text[30];
        PeriodText: Text[30];
        EndDate: Date;
        DiffPct: Decimal;
        DiffAtDatePct: Decimal;
        Trial_Balance_BudgetCaptionLbl: label 'Trial Balance/Budget';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        GLBudgetFilterCaptionLbl: label 'Budget Filter';
        Net_ChangeCaptionLbl: label 'Net Change';
        BalanceCaptionLbl: label 'Balance';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'Name';
        G_L_Account___Net_Change_CaptionLbl: label 'Debit';
        G_L_Account___Net_Change__Control28CaptionLbl: label 'Credit';
        DiffPctCaptionLbl: label '% of';
        G_L_Account___Budgeted_Amount_CaptionLbl: label 'Budget';
        G_L_Account___Balance_at_Date_CaptionLbl: label 'Debit';
        G_L_Account___Balance_at_Date__Control32CaptionLbl: label 'Credit';
        DiffAtDatePctCaptionLbl: label '% of';
        GLAcc2__Budget_at_Date_CaptionLbl: label 'Budget';
        GLAccountTypePosting: Boolean;
}

