#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10008 "Consolidated Trial Balance (4)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consolidated Trial Balance (4).rdlc';
    Caption = 'Consolidated Trial Balance (4)';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Business Unit";"Business Unit")
        {
            DataItemTableView = sorting(Code) where(Consolidate=const(true));
            RequestFilterFields = "Code";
            column(ReportForNavId_9370; 9370)
            {
            }

            trigger OnAfterGetRecord()
            begin
                NumBusUnits := NumBusUnits + 1;
                if NumBusUnits > ArrayLen(BusUnitColumn) then
                  Error(Text004,ArrayLen(BusUnitColumn),TableCaption);
                BusUnitColumn[NumBusUnits] := "Business Unit";
            end;

            trigger OnPreDataItem()
            begin
                NumBusUnits := 0;
            end;
        }
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Global Dimension 1 Filter","Global Dimension 2 Filter";
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
            column(G_L_Account__No__of_Blank_Lines_;"No. of Blank Lines")
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(GLFilter;GLFilter)
            {
            }
            column(BusUnitFilter;BusUnitFilter)
            {
            }
            column(InThousands;InThousands)
            {
            }
            column(SubTitle;SubTitle)
            {
            }
            column(Business_Unit__TABLECAPTION__________BusUnitFilter;"Business Unit".TableCaption + ': ' + BusUnitFilter)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter;"G/L Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(AmountType;AmountType)
            {
            }
            column(BusUnitColumn_1__Code;BusUnitColumn[1].Code)
            {
            }
            column(BusUnitColumn_2__Code;BusUnitColumn[2].Code)
            {
            }
            column(BusUnitColumn_3__Code;BusUnitColumn[3].Code)
            {
            }
            column(BusUnitColumn_4__Code;BusUnitColumn[4].Code)
            {
            }
            column(AnyAmountsNotZero;AnyAmountsNotZero)
            {
            }
            column(TotalBusUnitAmounts;TotalBusUnitAmounts)
            {
            }
            column(G_L_Account__G_L_Account___Account_Type_;"G/L Account"."Account Type")
            {
            }
            column(G_L_Account_No_;"No.")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
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
            column(TotalBusUnitAmounts__Caption;TotalBusUnitAmounts__CaptionLbl)
            {
            }
            column(EliminationAmountCaption;EliminationAmountCaptionLbl)
            {
            }
            column(TotalBusUnitAmounts___EliminationAmountCaption;TotalBusUnitAmounts___EliminationAmountCaptionLbl)
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
                column(Amount_1_;Amount[1])
                {
                    DecimalPlaces = 0:0;
                }
                column(Amount_2_;Amount[2])
                {
                    DecimalPlaces = 0:0;
                }
                column(Amount_3_;Amount[3])
                {
                    DecimalPlaces = 0:0;
                }
                column(Amount_4_;Amount[4])
                {
                    DecimalPlaces = 0:0;
                }
                column(TotalBusUnitAmounts__;TotalBusUnitAmounts())
                {
                    DecimalPlaces = 0:0;
                }
                column(EliminationAmount;EliminationAmount)
                {
                    DecimalPlaces = 0:0;
                }
                column(TotalBusUnitAmounts___EliminationAmount;TotalBusUnitAmounts() + EliminationAmount)
                {
                    DecimalPlaces = 0:0;
                }
                column(ShowCondition_Integer_Body_1;(AnyAmountsNotZero() and ("G/L Account"."Account Type" = "G/L Account"."account type"::Posting)))
                {
                }
                column(G_L_Account___No___Control30;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control31;PadStr('',"G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(Amount_1__Control32;Amount[1])
                {
                    DecimalPlaces = 0:0;
                }
                column(Amount_2__Control33;Amount[2])
                {
                    DecimalPlaces = 0:0;
                }
                column(Amount_3__Control34;Amount[3])
                {
                    DecimalPlaces = 0:0;
                }
                column(Amount_4__Control35;Amount[4])
                {
                    DecimalPlaces = 0:0;
                }
                column(TotalBusUnitAmounts___Control36;TotalBusUnitAmounts())
                {
                    DecimalPlaces = 0:0;
                }
                column(EliminationAmount_Control37;EliminationAmount)
                {
                    DecimalPlaces = 0:0;
                }
                column(TotalBusUnitAmounts___EliminationAmount_Control38;TotalBusUnitAmounts() + EliminationAmount)
                {
                    DecimalPlaces = 0:0;
                }
                column(ShowCondition_Integer_Body_2;("G/L Account"."Account Type" <> "G/L Account"."account type"::Posting))
                {
                }
                column(Integer_Number;Number)
                {
                }

                trigger OnPostDataItem()
                begin
                    if "G/L Account"."New Page" then
                      PageGroupNo := PageGroupNo + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                for CurBusUnit := NumBusUnits downto 1 do begin
                  SetRange("Business Unit Filter",BusUnitColumn[CurBusUnit].Code);
                  if (BusUnitColumn[CurBusUnit]."Starting Date" <> 0D) or (BusUnitColumn[CurBusUnit]."Ending Date" <> 0D) then
                    SetRange("Date Filter",BusUnitColumn[CurBusUnit]."Starting Date",BusUnitColumn[CurBusUnit]."Ending Date")
                  else
                    SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);

                  if UseAddRptCurr then
                    if AmountType = Amounttype::"Net Change" then begin
                      CalcFields("Additional-Currency Net Change");
                      Amount[CurBusUnit] := "Additional-Currency Net Change";
                    end else begin
                      CalcFields("Add.-Currency Balance at Date");
                      Amount[CurBusUnit] := "Add.-Currency Balance at Date";
                    end
                  else
                    if AmountType = Amounttype::"Net Change" then begin
                      CalcFields("Net Change");
                      Amount[CurBusUnit] := "Net Change";
                    end else begin
                      CalcFields("Balance at Date");
                      Amount[CurBusUnit] := "Balance at Date";
                    end;
                  if InThousands then
                    Amount[CurBusUnit] := Amount[CurBusUnit] / 1000;
                end;
                SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);
                SetRange("Business Unit Filter",'');

                if UseAddRptCurr then
                  if AmountType = Amounttype::"Net Change" then begin
                    CalcFields("Additional-Currency Net Change");
                    EliminationAmount := "Additional-Currency Net Change";
                  end else begin
                    CalcFields("Add.-Currency Balance at Date");
                    EliminationAmount := "Add.-Currency Balance at Date";
                  end
                else
                  if AmountType = Amounttype::"Net Change" then begin
                    CalcFields("Net Change");
                    EliminationAmount := "Net Change";
                  end else begin
                    CalcFields("Balance at Date");
                    EliminationAmount := "Balance at Date";
                  end;
                if InThousands then
                  EliminationAmount := EliminationAmount / 1000;
            end;

            trigger OnPreDataItem()
            begin
                if NumBusUnits = 0 then
                  CurrReport.Break;
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
                    group("Consolidation Period")
                    {
                        Caption = 'Consolidation Period';
                        field(StartingDate;ConsolidStartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';
                        }
                        field(EndingDate;ConsolidEndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';
                        }
                    }
                    field(Show;AmountType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show';
                        OptionCaption = 'Net Change,Balance';
                    }
                    field(AmountsInWhole1000s;InThousands)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amounts in whole 1000s';
                    }
                    field(UseAdditionalReportingCurrency;UseAddRptCurr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Use Additional Reporting Currency';
                        MultiLine = true;
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
        BusUnitFilter := "Business Unit".GetFilters;
        if ConsolidStartDate = 0D then
          Error(Text000);
        if ConsolidEndDate = 0D then
          Error(Text001);
        "G/L Account".SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);
        PeriodText := "G/L Account".GetFilter("Date Filter");
        MainTitle := StrSubstNo(Text002,PeriodText);
        if UseAddRptCurr then begin
          GLSetup.Get;
          Currency.Get(GLSetup."Additional Reporting Currency");
          SubTitle := StrSubstNo(Text003,Currency.Description);
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        BusUnitColumn: array [4] of Record "Business Unit";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        ConsolidStartDate: Date;
        ConsolidEndDate: Date;
        InThousands: Boolean;
        AmountType: Option "Net Change",Balance;
        GLFilter: Text;
        BusUnitFilter: Text;
        MainTitle: Text;
        SubTitle: Text;
        EliminationAmount: Decimal;
        PeriodText: Text;
        Amount: array [4] of Decimal;
        CurBusUnit: Integer;
        NumBusUnits: Integer;
        UseAddRptCurr: Boolean;
        Text000: label 'Please enter the starting date for the consolidation period.';
        Text001: label 'Please enter the ending date for the consolidation period.';
        Text002: label 'Consolidated Trial Balance for %1';
        Text003: label '(amounts are in %1)';
        Text004: label 'A maximum of %1 consolidating companies can be included in this report.  Set a filter on the %2 tab.';
        PageGroupNo: Integer;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Amounts_are_in_whole_1000sCaptionLbl: label 'Amounts are in whole 1000s';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'Name';
        TotalBusUnitAmounts__CaptionLbl: label 'Total';
        EliminationAmountCaptionLbl: label 'Eliminations';
        TotalBusUnitAmounts___EliminationAmountCaptionLbl: label 'Total Incl. Eliminations';


    procedure AnyAmountsNotZero(): Boolean
    var
        i: Integer;
    begin
        if EliminationAmount <> 0 then
          exit(true);
        for i := 1 to NumBusUnits do
          if Amount[i] <> 0 then
            exit(true);
        exit(false);
    end;


    procedure TotalBusUnitAmounts(): Decimal
    var
        i: Integer;
        TotAmt: Decimal;
    begin
        TotAmt := 0;
        for i := 1 to NumBusUnits do
          TotAmt := TotAmt + Amount[i];
        exit(TotAmt);
    end;
}

