#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10003 "Closing Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Closing Trial Balance.rdlc';
    Caption = 'Closing Trial Balance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Account Type","Global Dimension 1 Filter","Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(SubTitle;SubTitle)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter;"G/L Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter;GLFilter)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(G_L_Account_No_;"No.")
            {
            }
            column(Closing_Trial_BalanceCaption;Closing_Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Current_YearCaption;Current_YearCaptionLbl)
            {
            }
            column(Prior_YearCaption;Prior_YearCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption;FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption;PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(FiscalYearBalanceCaption;FiscalYearBalanceCaptionLbl)
            {
            }
            column(FiscalYearBalance_Control22Caption;FiscalYearBalance_Control22CaptionLbl)
            {
            }
            column(LastYearBalanceCaption;LastYearBalanceCaptionLbl)
            {
            }
            column(LastYearBalance_Control24Caption;LastYearBalance_Control24CaptionLbl)
            {
            }
            dataitem(BlankLineCounter;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_8412; 8412)
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange(Number,1,"G/L Account"."No. of Blank Lines");
                end;
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
                column(FiscalYearBalance;FiscalYearBalance)
                {
                }
                column(FiscalYearBalance_Control22;-FiscalYearBalance)
                {
                }
                column(LastYearBalance;LastYearBalance)
                {
                }
                column(LastYearBalance_Control24;-LastYearBalance)
                {
                }
                column(Account_Type__Posting;"G/L Account"."Account Type" = "G/L Account"."account type"::Posting)
                {
                }
                column(No__of_Blank_Lines_;"G/L Account"."No. of Blank Lines")
                {
                }
                column(G_L_Account___No___Control25;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control26;PadStr('',"G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(FiscalYearBalance_Control27;FiscalYearBalance)
                {
                }
                column(FiscalYearBalance_Control28;-FiscalYearBalance)
                {
                }
                column(LastYearBalance_Control29;LastYearBalance)
                {
                }
                column(LastYearBalance_Control30;-LastYearBalance)
                {
                }
                column(Account_Type__Posting_Control1400004;"G/L Account"."Account Type" = "G/L Account"."account type"::Posting)
                {
                }
                column(No__of_Blank_Lines__Control1400006;"G/L Account"."No. of Blank Lines")
                {
                }
                column(Integer_Number;Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                PageGroupNo := NextPageGroupNo;
                if "New Page" then
                  NextPageGroupNo := PageGroupNo + 1;

                if "Income/Balance" = "income/balance"::"Income Statement" then
                  SetRange("Date Filter",FiscalYearStartDate,FiscalYearEndDate)
                else
                  SetRange("Date Filter",0D,ClosingDate(FiscalYearEndDate));
                if UseAddRptCurr then begin
                  CalcFields("Additional-Currency Net Change");
                  FiscalYearBalance := "Additional-Currency Net Change";
                end else begin
                  CalcFields("Net Change");
                  FiscalYearBalance := "Net Change";
                end;

                if "Income/Balance" = "income/balance"::"Income Statement" then
                  SetRange("Date Filter",0D,FiscalYearStartDate - 1)
                else
                  SetRange("Date Filter",0D,ClosingDate(FiscalYearStartDate - 1));
                if UseAddRptCurr then begin
                  CalcFields("Additional-Currency Net Change");
                  LastYearBalance := "Additional-Currency Net Change";
                end else begin
                  CalcFields("Net Change");
                  LastYearBalance := "Net Change";
                end;

                if SkipZeroAccounts and
                   ("G/L Account"."Account Type" = "G/L Account"."account type"::Posting) and
                   (FiscalYearBalance = 0) and
                   (LastYearBalance = 0)
                then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
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
                    field(FiscalYearStartingDate;FiscalYearStartDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Fiscal Year Starting Date';
                        ToolTip = 'Specifies the date that the fiscal year began. The ending date is determined automatically based on the accounting period.';
                    }
                    field(SkipZeroAccounts;SkipZeroAccounts)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Skip Accounts with all zero Amounts';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want the report to be generated with all of the accounts, including those with zero amounts. Otherwise, those accounts will be excluded.';
                    }
                    field(UseAdditionalReportingCurrency;UseAddRptCurr)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Use Additional Reporting Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want all amounts to be printed by using the additional reporting currency. If you do not select the check box, then all amounts will be printed in US dollars.';
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
        CompanyInformation.Get;
        GLFilter := "G/L Account".GetFilters;

        if FiscalYearStartDate = 0D then
          Error(Text000);
        AccountingPeriod.SetRange("New Fiscal Year",true);
        AccountingPeriod."Starting Date" := FiscalYearStartDate;
        AccountingPeriod.Find;
        AccountingPeriod.Next(1);
        FiscalYearEndDate := AccountingPeriod."Starting Date" - 1;

        "G/L Account".SetRange("Date Filter",FiscalYearStartDate,FiscalYearEndDate);
        PeriodText := "G/L Account".GetFilter("Date Filter");
        SubTitle := StrSubstNo(Text001,PeriodText);
        if UseAddRptCurr then begin
          GLSetup.Get;
          Currency.Get(GLSetup."Additional Reporting Currency");
          SubTitle := SubTitle + '  ' + StrSubstNo(Text002,Currency.Description);
        end;
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        FiscalYearStartDate: Date;
        FiscalYearEndDate: Date;
        SubTitle: Text;
        PeriodText: Text;
        GLFilter: Text;
        FiscalYearBalance: Decimal;
        LastYearBalance: Decimal;
        SkipZeroAccounts: Boolean;
        UseAddRptCurr: Boolean;
        Text000: label 'Enter the starting date for the fiscal year.';
        Text001: label 'For the Fiscal Year: %1';
        Text002: label '(using %1)';
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        Closing_Trial_BalanceCaptionLbl: label 'Closing Trial Balance';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Current_YearCaptionLbl: label 'Current Year';
        Prior_YearCaptionLbl: label 'Prior Year';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'Name';
        FiscalYearBalanceCaptionLbl: label 'Debit';
        FiscalYearBalance_Control22CaptionLbl: label 'Credit';
        LastYearBalanceCaptionLbl: label 'Debit';
        LastYearBalance_Control24CaptionLbl: label 'Credit';
}

