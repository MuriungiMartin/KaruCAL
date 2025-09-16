#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 16 "G/L Consolidation Eliminations"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/GL Consolidation Eliminations.rdlc';
    Caption = 'G/L Consolidation Eliminations';
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
            column(PeriodTextCaption;StrSubstNo(Text003,PeriodText))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(GLAccountGLFilter;TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter;GLFilter)
            {
            }
            column(GLAccType;Format("Account Type",0,2))
            {
            }
            column(GenJournalLineTableCaption;"Gen. Journal Line".TableCaption + ': ' + GenJnlLineFilter)
            {
            }
            column(GenJnlLineFilter;GenJnlLineFilter)
            {
            }
            column(NoOfBlankLines_GLAccount;"No. of Blank Lines")
            {
            }
            column(AmountType;AmountType)
            {
                OptionCaption = 'Net Change,Balance';
            }
            column(BusUnitCode;BusUnitCode)
            {
            }
            column(GenJournalLineAmount;"Gen. Journal Line".Amount)
            {
            }
            column(No_GLAccount;"No.")
            {
            }
            column(GLConsolidationEliminationsCaption;GLConsolidationEliminationsCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(GLAcc2NoCaption;GLAcc2NoCaptionLbl)
            {
            }
            column(GLAccountNameIndentedCaption;GLAccountNameIndentedCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(EliminationsCaption;EliminationsCaptionLbl)
            {
            }
            column(GenJournalLineDescCaption;"Gen. Journal Line".FieldCaption(Description))
            {
            }
            column(TotalInclEliminationsCaption;TotalInclEliminationsCaptionLbl)
            {
            }
            column(TotalEliminationsCaption;TotalEliminationsCaptionLbl)
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
            dataitem("Gen. Journal Line";"Gen. Journal Line")
            {
                DataItemLink = "Account No."=field("No.");
                DataItemTableView = sorting("Journal Template Name");
                column(ReportForNavId_7024; 7024)
                {
                }
                column(GLAcc2No;GLAcc2."No.")
                {
                }
                column(GLAccountNameIndented;PadStr('',GLAcc2.Indentation * 2) + GLAcc2.Name)
                {
                }
                column(ConsolidAmount;ConsolidAmount)
                {
                    AutoFormatType = 1;
                }
                column(BusUnitAmount;BusUnitAmount)
                {
                    AutoFormatType = 1;
                }
                column(Amount_GenJournalLine;Amount)
                {
                }
                column(Desc_GenJournalLine;Description)
                {
                }
                column(FirstLine;Format(FirstLine,0,2))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    GLAcc2 := "G/L Account";
                    if FirstLine then
                      FirstLine := false
                    else begin
                      GLAcc2."No." := '';
                      GLAcc2.Name := '';
                      ConsolidAmount := 0;
                      BusUnitAmount := 0;
                    end;
                end;

                trigger OnPostDataItem()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    TotalAmountLCY := TotalAmountLCY + Amount;
                    if ("G/L Account"."Account Type" <> "G/L Account"."account type"::Posting) and
                       ("G/L Account".Totaling <> '')
                    then begin
                      GenJnlLine.Reset;
                      GenJnlLine := "Gen. Journal Line";
                      GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
                      GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
                      GenJnlLine.SetFilter("Account No.","G/L Account".Totaling);
                      GenJnlLine.CalcSums(Amount);
                      EliminationAmount := GenJnlLine.Amount;
                    end;
                    TotalAmountLCY := TotalAmountLCY + EliminationAmount;
                end;

                trigger OnPreDataItem()
                begin
                    "G/L Account".SetRange("Business Unit Filter",BusUnit.Code);
                    if (BusUnit."Starting Date" <> 0D) or (BusUnit."Ending Date" <> 0D) then
                      "G/L Account".SetRange("Date Filter",BusUnit."Starting Date",BusUnit."Ending Date")
                    else
                      "G/L Account".SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);

                    if AmountType = Amounttype::"Net Change" then begin
                      "G/L Account".CalcFields("Net Change");
                      BusUnitAmount := "G/L Account"."Net Change";
                    end else begin
                      "G/L Account".CalcFields("Balance at Date");
                      BusUnitAmount := "G/L Account"."Balance at Date";
                    end;

                    "G/L Account".SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);
                    "G/L Account".SetFilter("Business Unit Filter",'<>%1',BusUnit.Code);

                    if AmountType = Amounttype::"Net Change" then begin
                      "G/L Account".CalcFields("Net Change");
                      ConsolidAmount := "G/L Account"."Net Change";
                    end else begin
                      "G/L Account".CalcFields("Balance at Date");
                      ConsolidAmount := "G/L Account"."Balance at Date";
                    end;

                    SetRange("Journal Template Name","Journal Template Name");
                    SetRange("Journal Batch Name","Journal Batch Name");
                    SetFilter(Amount,'<>0');

                    TotalAmountLCY := ConsolidAmount + BusUnitAmount;
                    CurrReport.CreateTotals(Amount);
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(No2__GLAccount;"G/L Account"."No.")
                {
                }
                column(GLAccountNameIndented2;PadStr('',"G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(ConsolidAmount2;ConsolidAmount)
                {
                    AutoFormatType = 1;
                }
                column(BusUnitAmount2;BusUnitAmount)
                {
                    AutoFormatType = 1;
                }
                column(EliminationAmount;EliminationAmount)
                {
                    AutoFormatType = 1;
                }
                column(FirstLine2;Format(FirstLine,0,2))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                FirstLine := true;
                EliminationAmount := 0;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Gen. Journal Line".Amount);
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
                            ClosingDates = true;
                        }
                        field(EndingDate;ConsolidEndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';
                            ClosingDates = true;
                        }
                    }
                    field("BusUnit.Code";BusUnit.Code)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Business Unit Code';
                        TableRelation = "Business Unit";
                    }
                    field(JournalTemplateName;"Gen. Journal Line"."Journal Template Name")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Journal Template Name';
                        NotBlank = true;
                        TableRelation = "Gen. Journal Template";
                    }
                    field(JournalBatch;"Gen. Journal Line"."Journal Batch Name")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Journal Batch';
                        Lookup = true;
                        NotBlank = true;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            "Gen. Journal Line".TestField("Journal Template Name");
                            GenJnlTemplate.Get("Gen. Journal Line"."Journal Template Name");
                            GenJnlBatch.FilterGroup(2);
                            GenJnlBatch.SetRange("Journal Template Name","Gen. Journal Line"."Journal Template Name");
                            GenJnlBatch.FilterGroup(0);
                            GenJnlBatch.Name := "Gen. Journal Line"."Journal Batch Name";
                            if GenJnlBatch.Find('=><') then;
                            if Page.RunModal(0,GenJnlBatch) = Action::LookupOK then begin
                              Text := GenJnlBatch.Name;
                              exit(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            "Gen. Journal Line".TestField("Journal Template Name");
                            GenJnlBatch.Get("Gen. Journal Line"."Journal Template Name","Gen. Journal Line"."Journal Batch Name");
                        end;
                    }
                    field(AmountType;AmountType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show';
                        OptionCaption = 'Net Change,Balance';
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
        GLFilter := "G/L Account".GetFilters;
        if ConsolidStartDate = 0D then
          Error(Text000);
        if ConsolidEndDate = 0D then
          Error(Text001);
        "G/L Account".SetRange("Date Filter",ConsolidStartDate,ConsolidEndDate);
        PeriodText := "G/L Account".GetFilter("Date Filter");

        "Gen. Journal Line".SetRange("Journal Template Name","Gen. Journal Line"."Journal Template Name");
        "Gen. Journal Line".SetRange("Journal Batch Name","Gen. Journal Line"."Journal Batch Name");
        GenJnlLineFilter := "Gen. Journal Line".GetFilters;

        if BusUnit.Code <> '' then begin
          BusUnitCode := BusUnit.Code;
          BusUnit.Get(BusUnit.Code);
        end else
          BusUnitCode := Text002;

        GenJnlBatch.Get("Gen. Journal Line"."Journal Template Name","Gen. Journal Line"."Journal Batch Name");
    end;

    var
        Text000: label 'Enter the starting date for the consolidation period.';
        Text001: label 'Enter the ending date for the consolidation period.';
        Text002: label 'Posted Eliminations';
        Text003: label 'Period: %1';
        BusUnit: Record "Business Unit";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GLAcc2: Record "G/L Account";
        ConsolidStartDate: Date;
        ConsolidEndDate: Date;
        GLFilter: Text;
        GenJnlLineFilter: Text;
        AmountType: Option "Net Change",Balance;
        PeriodText: Text;
        BusUnitCode: Text[20];
        ConsolidAmount: Decimal;
        BusUnitAmount: Decimal;
        TotalAmountLCY: Decimal;
        FirstLine: Boolean;
        EliminationAmount: Decimal;
        GLConsolidationEliminationsCaptionLbl: label 'G/L Consolidation Eliminations';
        PageCaptionLbl: label 'Page';
        GLAcc2NoCaptionLbl: label 'No.';
        GLAccountNameIndentedCaptionLbl: label 'Name';
        TotalCaptionLbl: label 'Total';
        EliminationsCaptionLbl: label 'Eliminations';
        TotalInclEliminationsCaptionLbl: label 'Total Incl. Eliminations';
        TotalEliminationsCaptionLbl: label 'Total Eliminations';
}

