#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10007 "Consolidated Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consolidated Trial Balance.rdlc';
    Caption = 'Consolidated Trial Balance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Global Dimension 1 Filter","Global Dimension 2 Filter";
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
            column(InThousands;InThousands)
            {
            }
            column(GLFilter;GLFilter)
            {
            }
            column(G_L_Account__No__of_Blank_Lines_;"No. of Blank Lines")
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(G_L_Account_No_;"No.")
            {
            }
            column(Consolidated_Trial_BalanceCaption;Consolidated_Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Amounts_are_in_whole_1000sCaption;Amounts_are_in_whole_1000sCaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(Amount_Incl__EliminationsCaption;Amount_Incl__EliminationsCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption;FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control26Caption;PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control26CaptionLbl)
            {
            }
            column(GLAccNetChange_Control27Caption;GLAccNetChange_Control27CaptionLbl)
            {
            }
            column(GLBalance_Control28Caption;GLBalance_Control28CaptionLbl)
            {
            }
            column(EliminationAmountCaption;EliminationAmountCaptionLbl)
            {
            }
            column(GLAccNetChange_EliminationAmountCaption;GLAccNetChange_EliminationAmountCaptionLbl)
            {
            }
            column(GLBalance_EliminationAmountCaption;GLBalance_EliminationAmountCaptionLbl)
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
                column(Integer_Number;Number)
                {
                }
            }
            dataitem("Business Unit";"Business Unit")
            {
                DataItemTableView = sorting(Code) where(Consolidate=const(true));
                column(ReportForNavId_9370; 9370)
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___2__Code;PadStr('',"G/L Account".Indentation * 2 + 2) + Code)
                {
                }
                column(GLAccNetChange;GLAccNetChange)
                {
                    DecimalPlaces = 0:0;
                }
                column(GLBalance;GLBalance)
                {
                    DecimalPlaces = 0:0;
                }
                column(Business_Unit_Code;Code)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "G/L Account".SetRange("Business Unit Filter",Code);
                    if ("Starting Date" <> 0D) or ("Ending Date" <> 0D) then
                      "G/L Account".SetRange("Date Filter","Starting Date","Ending Date")
                    else
                      "G/L Account".SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);

                    if UseAddRptCurr then begin
                      "G/L Account".CalcFields("Additional-Currency Net Change","Add.-Currency Balance at Date");
                      GLAccNetChange := "G/L Account"."Additional-Currency Net Change";
                      GLBalance := "G/L Account"."Add.-Currency Balance at Date";
                    end else begin
                      "G/L Account".CalcFields("Net Change","Balance at Date");
                      GLAccNetChange := "G/L Account"."Net Change";
                      GLBalance := "G/L Account"."Balance at Date";
                    end;

                    if (GLAccNetChange = 0) and (GLBalance = 0) then
                      CurrReport.Skip;

                    if InThousands then begin
                      GLAccNetChange := GLAccNetChange / 1000;
                      GLBalance := GLBalance / 1000;
                    end;
                    GLAccNetChangeSum += GLAccNetChange;
                    GLBalanceSum += GLBalance;
                end;

                trigger OnPreDataItem()
                begin
                    if ("G/L Account"."Account Type" <> "G/L Account"."account type"::Posting) and
                       ("G/L Account".Totaling = '')
                    then
                      CurrReport.Break;
                    GLAccNetChangeSum := 0;
                    GLBalanceSum := 0;
                end;
            }
            dataitem(ConsolidCounter;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_1867; 1867)
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control26;PadStr('',"G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(GLAccNetChange_Control27;GLAccNetChangeSum)
                {
                    DecimalPlaces = 0:0;
                }
                column(GLBalance_Control28;GLBalanceSum)
                {
                    DecimalPlaces = 0:0;
                }
                column(EliminationAmount;EliminationAmount)
                {
                    DecimalPlaces = 0:0;
                }
                column(GLAccNetChange_EliminationAmount;GLAccNetChangeSum + EliminationAmount)
                {
                    DecimalPlaces = 0:0;
                }
                column(GLBalance_EliminationAmount;GLBalanceSum + EliminationAmount)
                {
                    DecimalPlaces = 0:0;
                }
                column(ConsolidCounter_Number;Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "G/L Account".SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);
                    "G/L Account".SetRange("Business Unit Filter",'');
                    if UseAddRptCurr then begin
                      "G/L Account".CalcFields("Additional-Currency Net Change");
                      EliminationAmount := "G/L Account"."Additional-Currency Net Change";
                    end else begin
                      "G/L Account".CalcFields("Net Change");
                      EliminationAmount := "G/L Account"."Net Change";
                    end;

                    if (GLAccNetChange = 0) and (GLBalance = 0) and (EliminationAmount = 0) then
                      CurrReport.Skip;
                    if InThousands then
                      EliminationAmount := EliminationAmount / 1000;
                end;

                trigger OnPreDataItem()
                begin
                    if ("G/L Account"."Account Type" <> "G/L Account"."account type"::Posting) and
                       ("G/L Account".Totaling = '')
                    then
                      CurrReport.Break;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PageGroupNo := NextPageGroupNo;
                if "New Page" then
                  NextPageGroupNo := PageGroupNo + 1;
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
        if ConsolidStartDate = 0D then
          Error(Text000);
        if ConsolidEndDate = 0D then
          Error(Text001);
        GLFilter := "G/L Account".GetFilters;
        "G/L Account".SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);
        PeriodText := "G/L Account".GetFilter("Date Filter");
        SubTitle := StrSubstNo(Text002,PeriodText);
        if UseAddRptCurr then begin
          GLSetup.Get;
          Currency.Get(GLSetup."Additional Reporting Currency");
          SubTitle := SubTitle + '  ' + StrSubstNo(Text003,Currency.Description);
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        SubTitle: Text;
        InThousands: Boolean;
        UseAddRptCurr: Boolean;
        ConsolidStartDate: Date;
        ConsolidEndDate: Date;
        GLFilter: Text;
        GLAccNetChange: Decimal;
        GLAccNetChangeSum: Decimal;
        GLBalance: Decimal;
        GLBalanceSum: Decimal;
        EliminationAmount: Decimal;
        PeriodText: Text;
        Text000: label 'Please enter the starting date for the consolidation period.';
        Text001: label 'Please enter the ending date for the consolidation period.';
        Text002: label 'Period: %1';
        Text003: label '(using %1)';
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        Consolidated_Trial_BalanceCaptionLbl: label 'Consolidated Trial Balance';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Amounts_are_in_whole_1000sCaptionLbl: label 'Amounts are in whole 1000s';
        AmountCaptionLbl: label 'Amount';
        Amount_Incl__EliminationsCaptionLbl: label 'Amount Incl. Eliminations';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control26CaptionLbl: label 'Name';
        GLAccNetChange_Control27CaptionLbl: label 'Net Change';
        GLBalance_Control28CaptionLbl: label 'Balance';
        EliminationAmountCaptionLbl: label 'Eliminations';
        GLAccNetChange_EliminationAmountCaptionLbl: label 'Net Change';
        GLBalance_EliminationAmountCaptionLbl: label 'Balance';
}

