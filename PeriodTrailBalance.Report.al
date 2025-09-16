#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51191 "Period Trail Balance "
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Period Trail Balance .rdlc';
    Caption = 'Period Trail Balance ';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Account Type","Date Filter","Global Dimension 1 Filter","Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(LongText_1____LongText_2__;LongText[1] + LongText[2] )
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
            column(GLAcc__LCY_Code_;GLAcc."LCY Code")
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter;"G/L Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(LastYearBalance;LastYearBalance)
            {
            }
            column(EndBalAtDate;EndBalAtDate)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(FiscalYearcredittChange;FiscalYearcredittChange)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(FiscalYeardebitChange;FiscalYeardebitChange)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(FiscalYearNetChange;FiscalYearNetChange)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(Period_Trail_Balance_Caption;Period_Trail_Balance_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ALL_AMOUNTS_INCaption;ALL_AMOUNTS_INCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption;FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption;PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(DebitCaption;DebitCaptionLbl)
            {
            }
            column(Opening_BalanceCaption;Opening_BalanceCaptionLbl)
            {
            }
            column(MovementCaption;MovementCaptionLbl)
            {
            }
            column(Closing_BalanceCaption;Closing_BalanceCaptionLbl)
            {
            }
            column(CreditCaption;CreditCaptionLbl)
            {
            }
            column(G_L_Account_No_;"No.")
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
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name;PadStr('',"G/L Account".Indentation * 2)+"G/L Account".Name)
                {
                }
                column(EndBalAtDate_Control29;EndBalAtDate)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(FiscalYearcredittChange_Control1000000000;FiscalYearcredittChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(FiscalYeardebitChange_Control1000000002;FiscalYeardebitChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(LastYearBalance_Control1102760006;LastYearBalance)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(FiscalYearNetChange_Control1102760007;FiscalYearNetChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(G_L_Account___No___Control33;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control34;PadStr('',"G/L Account".Indentation * 2)+"G/L Account".Name)
                {
                }
                column(EndBalAtDate_Control39;EndBalAtDate)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(FiscalYearcredittChange_Control1000000001;FiscalYearcredittChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(FiscalYeardebitChange_Control1000000003;FiscalYeardebitChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(LastYearBalance_Control1102760005;LastYearBalance)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(FiscalYearNetChange_Control1102760008;FiscalYearNetChange)
                {
                    AutoFormatType = 1;
                    DecimalPlaces = 0:0;
                }
                column(Integer_Number;Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                SetRange("Date Filter",FiscalYearStartDate,FiscalYearEndDate);
                CalcFields("Net Change","Balance at Date");
                FiscalYearBalance := "Balance at Date";
                FiscalYearNetChange := "Net Change";

                //dENNIS
                CurrReport.CreateTotals(LastYearBalance,FiscalYearNetChange);

                SetRange("Date Filter",FiscalYearStartDate,FiscalYearEndDate);
                CalcFields("Debit Amount","Credit Amount");
                FiscalYeardebitChange:="Debit Amount";
                FiscalYearcredittChange:="Credit Amount";
                //dENNIS
                CurrReport.CreateTotals(FiscalYearcredittChange);
                CurrReport.CreateTotals(FiscalYeardebitChange);

                SetRange("Date Filter",0D,LastPeriodEndDate);
                CalcFields("Net Change","Balance at Date");
                LastYearBalance := "Balance at Date";

                SetRange("Date Filter",0D,FiscalYearEndDate);
                CalcFields("Balance at Date");
                EndBalAtDate := "Balance at Date";

                //Dennis
                CurrReport.CreateTotals(EndBalAtDate);

                if not GLAcc.Get(GLAcc."LCY Code") then
                  GLAcc.Init;

                if Lcycode.Get( Lcycode."LCY Code")then
                 Lcycode.Init;
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
        LastPeriodEndDate:=CalcDate('<-1D>',NormalDate(FiscalYearStartDate) + 1) - 1;
        if FiscalYearStartDate <> NormalDate(FiscalYearStartDate) then
          LastYearStartDate := ClosingDate(LastYearStartDate);
        if FiscalYearEndDate <> NormalDate(FiscalYearEndDate) then
          LastYearEndDate := ClosingDate(LastYearEndDate);
    end;

    var
        Text001: label 'Period: %1..%2 versus %3..%4';
        GLFilter: Text[250];
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
        LongText: array [4] of Text[132];
        FiscalYeardebitChange: Decimal;
        FiscalYearcredittChange: Decimal;
        debitbal: Decimal;
        creditbal: Decimal;
        ReportEndDate: Date;
        ReportEnddebitChange: Decimal;
        ReportEndcredittChange: Decimal;
        Text000: label 'Please Enter the Report end date on the Option Tab.';
        GLAcc: Record "General Ledger Setup";
        Lcycode: Record "General Ledger Setup";
        Movement: Decimal;
        EndBal: Decimal;
        LastPeriodEndDate: Date;
        EndBalAtDate: Decimal;
        Period_Trail_Balance_CaptionLbl: label 'Period Trail Balance ';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ALL_AMOUNTS_INCaptionLbl: label 'ALL AMOUNTS IN';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'Name';
        DebitCaptionLbl: label 'Debit';
        Opening_BalanceCaptionLbl: label 'Opening Balance';
        MovementCaptionLbl: label 'Movement';
        Closing_BalanceCaptionLbl: label 'Closing Balance';
        CreditCaptionLbl: label 'Credit';
}

