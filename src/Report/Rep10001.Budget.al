#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10001 Budget
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Budget.rdlc';
    Caption = 'Budget';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Account Type","Budget Filter","Global Dimension 1 Filter","Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(MainTitle;MainTitle)
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
            column(STRSUBSTNO_Text004_TimeDivision_;StrSubstNo(Text004,TimeDivision))
            {
            }
            column(TimeDivision;TimeDivision)
            {
            }
            column(STRSUBSTNO_Text005_PeriodCalcToPrint_;StrSubstNo(Text005,PeriodCalcToPrint))
            {
            }
            column(PeriodCalculation;PeriodCalculation)
            {
            }
            column(InThousandsText;InThousandsText)
            {
            }
            column(InThousandsText_Control1400002;InThousandsText)
            {
            }
            column(Text006;Text006Lbl)
            {
            }
            column(PrintAllBalance;PrintAllBalance)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter;"G/L Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter;GLFilter)
            {
            }
            column(PeriodStartingDate_1_;Format(PeriodStartingDate[1]))
            {
            }
            column(PeriodStartingDate_2_;Format(PeriodStartingDate[2]))
            {
            }
            column(PeriodStartingDate_3_;Format(PeriodStartingDate[3]))
            {
            }
            column(PeriodStartingDate_4_;Format(PeriodStartingDate[4]))
            {
            }
            column(PeriodStartingDate_5_;Format(PeriodStartingDate[5]))
            {
            }
            column(PeriodStartingDate_6_;Format(PeriodStartingDate[6]))
            {
            }
            column(PeriodStartingDate_2__1;Format(PeriodStartingDate[2] - 1))
            {
            }
            column(PeriodStartingDate_3__1;Format(PeriodStartingDate[3] - 1))
            {
            }
            column(PeriodStartingDate_4__1;Format(PeriodStartingDate[4] - 1))
            {
            }
            column(PeriodStartingDate_5__1;Format(PeriodStartingDate[5] - 1))
            {
            }
            column(PeriodStartingDate_6__1;Format(PeriodStartingDate[6] - 1))
            {
            }
            column(PeriodStartingDate_7__1;Format(PeriodStartingDate[7] - 1))
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(G_L_Account_No_;"No.")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption;FieldCaption("No."))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            dataitem(BlankLineCounter;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_8412; 8412)
                {
                }
                column(BlankLineCounter_Number;Number)
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
                column(PADSTR_____G_L_Account__Indentation___G_L_Account__Name;PadStr('',"G/L Account".Indentation) + "G/L Account".Name)
                {
                }
                column(BudgetToPrint_1_;BudgetToPrint[1])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_2_;BudgetToPrint[2])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_3_;BudgetToPrint[3])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_4_;BudgetToPrint[4])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_5_;BudgetToPrint[5])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_6_;BudgetToPrint[6])
                {
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___No___Control41;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___G_L_Account__Name_Control42;PadStr('',"G/L Account".Indentation) + "G/L Account".Name)
                {
                }
                column(BudgetToPrint_1__Control43;BudgetToPrint[1])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_2__Control44;BudgetToPrint[2])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_3__Control45;BudgetToPrint[3])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_4__Control46;BudgetToPrint[4])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_5__Control47;BudgetToPrint[5])
                {
                    DecimalPlaces = 0:0;
                }
                column(BudgetToPrint_6__Control48;BudgetToPrint[6])
                {
                    DecimalPlaces = 0:0;
                }
                column(AccountTypeNo;AccountTypeNo)
                {
                }
                column(G_L_Account__Totaling;"G/L Account".Totaling)
                {
                }
                column(G_L_Account___No___Control51;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___G_L_Account__Name_Control52;PadStr('',"G/L Account".Indentation) + "G/L Account".Name)
                {
                }
                column(Integer_Number;Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                AccountTypeNo := "Account Type";
                PageGroupNo := NextPageGroupNo;
                if "New Page" then
                  NextPageGroupNo := PageGroupNo + 1;

                NoDataFound := true; // used to indicate if any budget values are found
                for i := 1 to 6 do begin
                  SetRange("Date Filter",PeriodStartingDate[i],PeriodStartingDate[i + 1] - 1);
                  CalcFields("Budgeted Amount");
                  if InThousands then
                    "Budgeted Amount" := "Budgeted Amount" / 1000;
                  BudgetToPrint[i] := ROUND("Budgeted Amount",1);
                  if NoDataFound then
                    NoDataFound := ("Budgeted Amount" = 0); // will set NoDataFound flag to no if budget found
                end;

                // if PrintAllBalance is true then skip printing posting accounts
                // that do not have any budget amounts.
                if NoDataFound and PrintAllBalance and ("Account Type" = 0) then
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
                    field(StartingPeriodDate;PeriodCalculation)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Starting Period Date';
                        ToolTip = 'Specifies the starting accounting period from which to generate the budget. For example, enter P to start at the current accounting period, enter P-1 to start with the prior accounting period, or enter P+2 to start with the accounting period after the next one. If you enter a value in this field, each column will cover one accounting period.';
                    }
                    field(TimeDivision;TimeDivision)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Time Division ';
                        DateFormula = true;
                        MultiLine = false;
                        ToolTip = 'Specifies that you want to print by your accounting periods. You can also print by a different division of time. For example, you could enter 10D, which will create divisions of ten days. The range of dates will expand if needed to cover complete periods of time.';
                    }
                    field(FromDate;FromDate)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(AmountsIn1000s;InThousands)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Amounts in 1000s';
                        ToolTip = 'Specifies that budget values are divided by USD 1,000 and rounded to improve readability.';
                    }
                    field(PrintAllBalance;PrintAllBalance)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Acc. with Budgets Only';
                        ToolTip = 'Specifies that you want to include all accounts that have a balance other than zero, even if there has been no activity in the period. This option cannot be used if you are also entering Customer Ledger Entry Filters such as the Open filter.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodCalculation = '' then begin
              if FromDate = 0D then
                FromDate := WorkDate;
              if Format(TimeDivision) = '' then
                Evaluate(TimeDivision,'<1M>');
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        CompanyInformation.Get;
        if PeriodCalculation <> '' then begin
          Evaluate(TimeDivision,'');
          FromDate := 0D;
          if PeriodCalculation = Text008 then begin
            PeriodCalcToPrint := Text000;
            AccountingPeriod.SetRange("Starting Date",0D,WorkDate);
            AccountingPeriod.Find('+');
            PeriodCalculation := Format(AccountingPeriod."Starting Date");
          end else
            PeriodCalcToPrint := PeriodCalculation + '.';
          "G/L Account".SetFilter("Date Filter",PeriodCalculation);
          PeriodStartingDate[1] := "G/L Account".GetRangeMin("Date Filter");
          AccountingPeriod.SetRange("Starting Date",PeriodStartingDate[1]);
          AccountingPeriod.Find('-');
          for i := 2 to 7 do begin
            AccountingPeriod.Reset;
            AccountingPeriod.Next;
            PeriodStartingDate[i] := AccountingPeriod."Starting Date";
          end;
        end else begin
          PeriodStartingDate[1] := FromDate;
          for i := 2 to 7 do
            PeriodStartingDate[i] := CalcDate(TimeDivision,PeriodStartingDate[i - 1]);
        end;
        if InThousands then
          InThousandsText := Text001;
        MainTitle := StrSubstNo(Text002,PeriodStartingDate[1],PeriodStartingDate[7] - 1);
        SubTitle := "G/L Account".GetFilter("Budget Filter");
        if SubTitle = '' then
          SubTitle := "G/L Account".FieldCaption("Budget Filter") + ': ' + Text003
        else
          SubTitle := "G/L Account".FieldCaption("Budget Filter") + ': ' + SubTitle;
    end;

    var
        CompanyInformation: Record "Company Information";
        AccountingPeriod: Record "Accounting Period";
        GLFilter: Text;
        MainTitle: Text[132];
        SubTitle: Text;
        PrintAllBalance: Boolean;
        FromDate: Date;
        PeriodCalculation: Code[10];
        TimeDivision: DateFormula;
        BudgetToPrint: array [6] of Decimal;
        PeriodStartingDate: array [7] of Date;
        InThousands: Boolean;
        i: Integer;
        InThousandsText: Text[40];
        PeriodCalcToPrint: Text[15];
        NoDataFound: Boolean;
        Text000: label 'Current Period.';
        Text001: label 'Amounts are in 1000s.';
        Text002: label 'Budget for %1 to %2';
        Text003: label 'All Budgets';
        Text004: label 'Time divisions of %1.';
        Text005: label 'By period starting with %1';
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        AccountTypeNo: Integer;
        Text008: label 'P', Comment='''P'' = Period';
        Text006Lbl: label 'Accounts without budgets are not included.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
}

