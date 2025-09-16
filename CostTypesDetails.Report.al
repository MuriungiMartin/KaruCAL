#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1125 "Cost Types Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Types Details.rdlc';
    Caption = 'Cost Types Details';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Cost Type";"Cost Type")
        {
            CalcFields = "Debit Amount","Credit Amount";
            DataItemTableView = where(Type=const("Cost Type"));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Combine Entries","Date Filter","Cost Center Filter","Cost Object Filter";
            column(ReportForNavId_2867; 2867)
            {
            }
            column(DtFltrCostTypeDateFilter;Text000 + ' ' + CostTypeDateFilter)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(PrintAllWithBalance;PrintAllWithBalance)
            {
            }
            column(PrintClosingEntries;PrintClosingEntries)
            {
            }
            column(CostTypeFilter;CostTypeFilter)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(GLSetupAddiReporCurr;GLSetup."Additional Reporting Currency")
            {
            }
            column(GLSetupLCYCode;GLSetup."LCY Code")
            {
            }
            column(AllAmountAreIn;AllAmountAreInLbl)
            {
            }
            column(TableCaptCostTypeFilter;TableCaption + ': ' + CostTypeFilter)
            {
            }
            column(No_CostType;"No.")
            {
            }
            column(DateFilter_CostType;"Date Filter")
            {
            }
            column(CostCenterFltr_CostType;"Cost Center Filter")
            {
            }
            column(CostObjectFltr_CostType;"Cost Object Filter")
            {
            }
            column(CostAccountDetailsCaption;CostAccountDetailsCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(IncGLaccHavBalCaption;IncGLaccHavBalCaptionLbl)
            {
            }
            column(ClosingentrieswithinperiodCaption;ClosingentrieswithinperiodCaptionLbl)
            {
            }
            column(PostDateCaption;PostDateCaptionLbl)
            {
            }
            column(CostEntryDebitAmtCaption;CostEntryDebitAmtCaptionLbl)
            {
            }
            column(CostEntryCreditAmTCaption;CostEntryCreditAmTCaptionLbl)
            {
            }
            column(CostTypeBalanceCaption;CostTypeBalanceCaptionLbl)
            {
            }
            column(CCCaption;CCCaptionLbl)
            {
            }
            column(COCaption;COCaptionLbl)
            {
            }
            dataitem(PageCounter;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_8098; 8098)
                {
                }
                column(Name_CostType;"Cost Type".Name)
                {
                }
                column(StartBalance;StartBalance)
                {
                }
                column(StartBalanceAddCurr;StartBalanceAddCurrency)
                {
                }
                dataitem("Cost Entry";"Cost Entry")
                {
                    DataItemLink = "Cost Type No."=field("No."),"Posting Date"=field("Date Filter"),"Cost Center Code"=field("Cost Center Filter"),"Cost Object Code"=field("Cost Object Filter");
                    DataItemLinkReference = "Cost Type";
                    DataItemTableView = sorting("Cost Type No.","Posting Date");
                    column(ReportForNavId_5276; 5276)
                    {
                    }
                    column(DebitAmount_CostEntry;"Debit Amount")
                    {
                    }
                    column(CreditAmount_CostEntry;"Credit Amount")
                    {
                    }
                    column(FmtPostingDate_CostEntry;Format("Posting Date"))
                    {
                    }
                    column(DocumentNo_CostEntry;"Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Text_CostEntry;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(CostTypeBalance;CostTypeBalance)
                    {
                    }
                    column(EntryNo_CostEntry;"Entry No.")
                    {
                        IncludeCaption = true;
                    }
                    column(CostObjectCode_CostEntry;"Cost Object Code")
                    {
                    }
                    column(CostCenterCode_CostEntry;"Cost Center Code")
                    {
                    }
                    column(AddCurrCrdtAmt_CostEntry;"Add.-Currency Credit Amount")
                    {
                    }
                    column(AddCurrDbtAmt_CostEntry;"Add.-Currency Debit Amount")
                    {
                    }
                    column(ShowAddCurr;ShowAddCurr)
                    {
                    }
                    column(CostTypeAddCurrBalance;CostTypeAddCurrBalance)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ("Posting Date" = ClosingDate("Posting Date")) and not PrintClosingEntries then begin
                          "Debit Amount" := 0;
                          "Credit Amount" := 0;
                        end;
                        CostTypeBalance := CostTypeBalance + Amount;
                        CostEntryLineNo := CostEntryLineNo + 1;
                        CumulatedDebitAmount := CumulatedDebitAmount + "Debit Amount";
                        CumulatedCreditAmount := CumulatedCreditAmount + "Credit Amount";
                        CostTypeAddCurrBalance := CostTypeAddCurrBalance + "Additional-Currency Amount";
                        CumulatedAddCurrDebit := CumulatedAddCurrDebit + "Add.-Currency Debit Amount";
                        CumulatedAddCurrCredit := CumulatedAddCurrCredit + "Add.-Currency Credit Amount";
                    end;

                    trigger OnPreDataItem()
                    begin
                        CostTypeBalance := StartBalance;
                        CostTypeAddCurrBalance := StartBalanceAddCurrency;
                        CostEntryLineNo := 0;
                        CumulatedDebitAmount := 0;
                        CumulatedCreditAmount := 0;
                        CumulatedAddCurrDebit := 0;
                        CumulatedAddCurrCredit := 0;
                    end;
                }
                dataitem(AccTotal;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_3069; 3069)
                    {
                    }
                    column(TotalCostTypeName;Text002 + "Cost Type".Name)
                    {
                    }
                    column(CumulatedDebitAmount;CumulatedDebitAmount)
                    {
                    }
                    column(CumulatedCreditAmt;CumulatedCreditAmount)
                    {
                    }
                    column(CostEntryLineNo;CostEntryLineNo)
                    {
                    }
                    column(CumulatedAddCurrDbt_AccTotal;CumulatedAddCurrDebit)
                    {
                    }
                    column(ShowAddCurr_AccTotal;ShowAddCurr)
                    {
                    }
                    column(CumulatedAddCurrCdt_AccTotal;CumulatedAddCurrCredit)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if CostEntryLineNo = 0 then
                          CurrReport.Skip;

                        if (CumulatedDebitAmount = 0) and
                           (CumulatedCreditAmount = 0) and
                           ((StartBalance = 0) or
                            not PrintAllWithBalance)
                        then
                          CurrReport.Skip;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PrintonlyIfDetail := not (PrintAllWithBalance and (StartBalance <> 0));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StartBalance := 0;
                StartBalanceAddCurrency := 0;
                if CostTypeDateFilter <> '' then
                  if GetRangeMin("Date Filter") <> 0D then begin
                    SetRange("Date Filter",0D,ClosingDate(GetRangeMin("Date Filter") - 1));
                    CalcFields("Net Change");
                    StartBalance := "Net Change";
                    CalcFields("Add. Currency Net Change");
                    StartBalanceAddCurrency := "Add. Currency Net Change";
                    SetFilter("Date Filter",CostTypeDateFilter);
                  end;

                if PrintOnlyOnePerPage then begin
                  PageGroupNo := NextPageGroupNo;
                  NextPageGroupNo := PageGroupNo + 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                GLSetup.Get;
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
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Cost Type';
                    }
                    field(PrintAllWithBalance;PrintAllWithBalance)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Process Cost Types with Balance at Date Within the Period';
                        MultiLine = true;
                    }
                    field(PrintClosingEntries;PrintClosingEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Closing Entries within the Period';
                        MultiLine = true;
                    }
                    field(ShowAmountsInAddRepCurrency;ShowAddCurr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in Add. Reporting Currency';
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
        CostTypeFilter := "Cost Type".GetFilters;
        CostTypeDateFilter := "Cost Type".GetFilter("Date Filter");

        PageGroupNo := 1;
        NextPageGroupNo := 1;
    end;

    var
        Text000: label 'Date filter:';
        Text002: label 'Total';
        GLSetup: Record "General Ledger Setup";
        CostTypeDateFilter: Text;
        CostTypeFilter: Text;
        CostTypeBalance: Decimal;
        StartBalance: Decimal;
        StartBalanceAddCurrency: Decimal;
        PrintOnlyOnePerPage: Boolean;
        PrintAllWithBalance: Boolean;
        PrintClosingEntries: Boolean;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        CostEntryLineNo: Integer;
        CumulatedDebitAmount: Decimal;
        CumulatedCreditAmount: Decimal;
        CostTypeAddCurrBalance: Decimal;
        CumulatedAddCurrDebit: Decimal;
        CumulatedAddCurrCredit: Decimal;
        [InDataSet]
        ShowAddCurr: Boolean;
        AllAmountAreInLbl: label 'All amounts are in';
        CostAccountDetailsCaptionLbl: label 'Cost Types Details';
        PageNoCaptionLbl: label 'Page';
        IncGLaccHavBalCaptionLbl: label 'This report includes general ledger accounts that only have a balance.';
        ClosingentrieswithinperiodCaptionLbl: label 'This report contains closing entries within the period.';
        PostDateCaptionLbl: label 'Post. Date';
        CostEntryDebitAmtCaptionLbl: label 'Debit';
        CostEntryCreditAmTCaptionLbl: label 'Credit';
        CostTypeBalanceCaptionLbl: label 'Balance';
        CCCaptionLbl: label 'CC';
        COCaptionLbl: label 'CO';
}

