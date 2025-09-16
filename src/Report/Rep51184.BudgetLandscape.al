#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51184 "Budget Landscape"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Budget Landscape.rdlc';
    Caption = 'Budget';

    dataset
    {
        dataitem("Dimension Value";"Dimension Value")
        {
            DataItemTableView = sorting(Code,"Global Dimension No.") order(ascending) where("Global Dimension No."=const(2));
            column(ReportForNavId_6363; 6363)
            {
            }
            column(Dimension_Value_Dimension_Code;"Dimension Code")
            {
            }
            column(Dimension_Value_Code;Code)
            {
            }
            dataitem("G/L Account";"G/L Account")
            {
                DataItemTableView = sorting("No.");
                RequestFilterFields = "No.","Account Type","Budget Filter","Global Dimension 1 Filter","Global Dimension 2 Filter";
                column(ReportForNavId_6710; 6710)
                {
                }
                column(FORMAT_TODAY_0_4_;Format(Today,0,4))
                {
                }
                column(COMPANYNAME;COMPANYNAME)
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(USERID;UserId)
                {
                }
                column(GLBudgetFilter;GLBudgetFilter)
                {
                }
                column(Budget_For_The_Fiscal_Year_Begining____FORMAT_PeriodStartDate_1__;'Budget For The Fiscal Year Begining ' +Format(PeriodStartDate[1]))
                {
                }
                column(Dimension_Value__Name;"Dimension Value".Name)
                {
                }
                column(G_L_Account__TABLECAPTION__________GLFilter;"G/L Account".TableCaption + ': ' + GLFilter)
                {
                }
                column(MonthName_1_;MonthName[1])
                {
                }
                column(MonthName_2_;MonthName[2])
                {
                }
                column(MonthName_3_;MonthName[3])
                {
                }
                column(MonthName_4_;MonthName[4])
                {
                }
                column(MonthName_5_;MonthName[5])
                {
                }
                column(MonthName_6_;MonthName[6])
                {
                }
                column(MonthName_7_;MonthName[7])
                {
                }
                column(MonthName_8_;MonthName[8])
                {
                }
                column(MonthName_9_;MonthName[9])
                {
                }
                column(MonthName_10_;MonthName[10])
                {
                }
                column(MonthName_11_;MonthName[11])
                {
                }
                column(MonthName_12_;MonthName[12])
                {
                }
                column(TOTAL_;'TOTAL')
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(GLBudgetFilterCaption;GLBudgetFilterCaptionLbl)
                {
                }
                column(Budget_CenterCaption;Budget_CenterCaptionLbl)
                {
                }
                column(Amounts_are_in_whole_1000sCaption;Amounts_are_in_whole_1000sCaptionLbl)
                {
                }
                column(G_L_Account___No__Caption;FieldCaption("No."))
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption;PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
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
                    column(GLBudgetedAmount_1_;GLBudgetedAmount[1])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_2_;GLBudgetedAmount[2])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_3_;GLBudgetedAmount[3])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_4_;GLBudgetedAmount[4])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_5_;GLBudgetedAmount[5])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_6_;GLBudgetedAmount[6])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_7_;GLBudgetedAmount[7])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_12_;GLBudgetedAmount[12])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_11_;GLBudgetedAmount[11])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_10_;GLBudgetedAmount[10])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_9_;GLBudgetedAmount[9])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_8_;GLBudgetedAmount[8])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLTotals;GLTotals)
                    {
                    }
                    column(G_L_Account___No___Control33;"G/L Account"."No.")
                    {
                    }
                    column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control34;PadStr('',"G/L Account".Indentation * 2)+"G/L Account".Name)
                    {
                    }
                    column(GLBudgetedAmount_1__Control35;GLBudgetedAmount[1])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_2__Control36;GLBudgetedAmount[2])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_3__Control37;GLBudgetedAmount[3])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_4__Control38;GLBudgetedAmount[4])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_5__Control39;GLBudgetedAmount[5])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_6__Control40;GLBudgetedAmount[6])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_12__Control1102758018;GLBudgetedAmount[12])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_11__Control1102758019;GLBudgetedAmount[11])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_10__Control1102758020;GLBudgetedAmount[10])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_9__Control1102758021;GLBudgetedAmount[9])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_8__Control1102758022;GLBudgetedAmount[8])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLBudgetedAmount_7__Control1102758023;GLBudgetedAmount[7])
                    {
                        DecimalPlaces = 0:0;
                    }
                    column(GLTotals_Control1102755025;GLTotals)
                    {
                    }
                    column(Integer_Number;Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        /*
                        rTotal[1]:=rTotal[1];
                        rTotal[2]:=rTotal[2];
                        rTotal[3]:=rTotal[3];
                        rTotal[4]:=rTotal[4];
                        rTotal[5]:=rTotal[5];
                        rTotal[6]:=rTotal[6];
                        rTotal[7]:=rTotal[7];
                        rTotal[8]:=rTotal[8];
                        rTotal[9]:=rTotal[9];
                        rTotal[10]:=rTotal[10];
                        rTotal[11]:=rTotal[11];
                        rTotal[12]:=rTotal[12];
                        */
                        
                        if GLTotals=0 then
                          CurrReport.Skip;

                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    GLTotals:=0;FooterTotals:=0;
                    for i := 1 to 12 do begin
                      SetRange("Date Filter",PeriodStartDate[i],PeriodStartDate[i+1]-1);
                      CalcFields("Budgeted Amount");
                      if InThousands then
                        "Budgeted Amount" := "Budgeted Amount" / 1000;
                      GLBudgetedAmount[i] := ROUND("Budgeted Amount",1);
                      rTotal[i]:=rTotal[i] + GLBudgetedAmount[i];
                      GLTotals:=GLTotals+GLBudgetedAmount[i];
                      FooterTotals:=FooterTotals+GLBudgetedAmount[i];
                    end;
                    SetRange("Date Filter",PeriodStartDate[1],PeriodStartDate[13]-1);

                    if GLTotals=0 then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin

                    "G/L Account".SetFilter("G/L Account"."Global Dimension 2 Filter","Dimension Value".Code);
                end;
            }
            dataitem(Footer;"Integer")
            {
                DataItemTableView = where(Number=const(1));
                column(ReportForNavId_3435; 3435)
                {
                }
                column(rTotal_1_;rTotal[1])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_2_;rTotal[2])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_3_;rTotal[3])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_4_;rTotal[4])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_5_;rTotal[5])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_6_;rTotal[6])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_7_;rTotal[7])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_8_;rTotal[8])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_9_;rTotal[9])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_10_;rTotal[10])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_11_;rTotal[11])
                {
                    DecimalPlaces = 0:0;
                }
                column(rTotal_12_;rTotal[12])
                {
                    DecimalPlaces = 0:0;
                }
                column(TOTAL__Control1102755016;'TOTAL')
                {
                }
                column(DataItem1102755018;rTotal[1] + rTotal[2] + rTotal[3] + rTotal[4] + rTotal[5] + rTotal[6] + rTotal[7] + rTotal[8] + rTotal[9] + rTotal[10] + rTotal[11] + rTotal[12])
                {
                    DecimalPlaces = 0:0;
                }
                column(Footer_Number;Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                      if FooterTotals=0 then
                         CurrReport.Skip
                end;
            }
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
        rTotal[1]:=0;
        rTotal[2]:=0;
        rTotal[3]:=0;
        rTotal[4]:=0;
        rTotal[5]:=0;
        rTotal[6]:=0;
        rTotal[7]:=0;
        rTotal[8]:=0;
        rTotal[9]:=0;
        rTotal[10]:=0;
        rTotal[11]:=0;
        rTotal[12]:=0;
        
        /*Get the accounting period start date from the database*/
        AccPeriod.Reset;
        AccPeriod.SetRange(AccPeriod."New Fiscal Year",true);
        AccPeriod.SetRange(AccPeriod."Starting Date",PeriodStartDate[1]);
        if AccPeriod.Count<1 then
          begin
            Error('Starting Date must be Starting Date of Fiscal Year');
          end;
        
        GLFilter := "G/L Account".GetFilters;
        GLBudgetFilter := "G/L Account".GetFilter("Budget Filter");
        /*Check if the budget has been selected*/
        if GLBudgetFilter='' then
          begin
            Error('Budget must be Specified');
          end;
        MonthName[1]:=GetMonthName(PeriodStartDate[1]);
        for i := 2 to 13 do
          begin
            PeriodStartDate[i] := CalcDate(PeriodLength,PeriodStartDate[i-1]);
            MonthName[i]:=GetMonthName(PeriodStartDate[i]);
          end;

    end;

    var
        InThousands: Boolean;
        GLFilter: Text[250];
        GLBudgetFilter: Text[250];
        PeriodLength: DateFormula;
        GLBudgetedAmount: array [12] of Decimal;
        PeriodStartDate: array [13] of Date;
        i: Integer;
        AccPeriod: Record "Accounting Period";
        MonthName: array [13] of Text[30];
        rTotal: array [15] of Decimal;
        GLTotals: Decimal;
        FooterTotals: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        GLBudgetFilterCaptionLbl: label 'Budget Filter';
        Budget_CenterCaptionLbl: label 'Budget Center';
        Amounts_are_in_whole_1000sCaptionLbl: label 'Amounts are in whole 1000s';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'Name';


    procedure GetMonthName(var NewDate: Date) Month: Text[30]
    var
        IntMonth: Integer;
    begin
        IntMonth:=Date2dmy(NewDate,2);

        if IntMonth=1 then
          begin
            Month:='January';
          end
        else if IntMonth=2 then
          begin
              Month:='February';
          end
        else if IntMonth=3 then
          begin
              Month:='March';
          end
        else if IntMonth=4 then
          begin
              Month:='April';
          end
        else if IntMonth=5 then
          begin
              Month:='May';
          end
        else if IntMonth=6 then
          begin
              Month:='June';
          end
        else if IntMonth=7 then
          begin
              Month:='July';
          end
        else if IntMonth=8 then
          begin
              Month:='August';
          end
        else if IntMonth=9 then
          begin
              Month:='September';
          end
        else if IntMonth=10 then
          begin
              Month:='October';
          end
        else if IntMonth=11 then
          begin
              Month:='November';
          end
        else if IntMonth=12 then
          begin
              Month:='December';
          end
    end;
}

