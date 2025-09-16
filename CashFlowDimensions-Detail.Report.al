#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 852 "Cash Flow Dimensions - Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cash Flow Dimensions - Detail.rdlc';
    Caption = 'Cash Flow Dimensions - Detail';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Analysis View";"Analysis View")
        {
            DataItemTableView = sorting(Code);
            column(ReportForNavId_3400; 3400)
            {
            }
            column(ViewLastUpdatedText;ViewLastUpdatedText)
            {
            }
            column(CashFlowAnalysisViewName;Name)
            {
            }
            column(CashFlowAnalysisViewCode;Code)
            {
            }
            column(DateFilter;DateFilter)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(HeaderText;HeaderText)
            {
            }
            column(DimFilterText;DimFilterText)
            {
            }
            column(PeriodCaption;PeriodCaptionLbl)
            {
            }
            column(AnalysisViewCaption;AnalysisViewCaptionLbl)
            {
            }
            column(LastUpdatedCaption;LastUpdatedCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(CashFlowDimensionsDetailCaption;CashFlowDimensionsDetailCaptionLbl)
            {
            }
            column(FiltersCaption;FiltersCaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(DocumentNoCaption;DocumentNoCaptionLbl)
            {
            }
            column(CashFlowDateCaption;CashFlowDateCaptionLbl)
            {
            }
            column(CashFlowAccountNoCaption;CashFlowAccountNoCaptionLbl)
            {
            }
            column(EntryNoCaption;EntryNoCaptionLbl)
            {
            }
            dataitem(Level1;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_1982; 1982)
                {
                }
                column(DimValCode1;DimValCode[1])
                {
                }
                column(DimCode1;DimCode[1])
                {
                }
                column(DimValName1;DimValName[1])
                {
                }
                dataitem(Level2;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_6891; 6891)
                    {
                    }
                    column(DimValCode2;DimValCode[2])
                    {
                    }
                    column(DimCode2;DimCode[2])
                    {
                    }
                    column(DimValName2;DimValName[2])
                    {
                    }
                    column(TempCFLedgEntryCashFlowAccNo;TempCFForecastEntry."Cash Flow Account No.")
                    {
                    }
                    column(TempCFLedgEntryCashFlowDate;TempCFForecastEntry."Cash Flow Date")
                    {
                    }
                    column(TempCFLedgEntryDocNo;TempCFForecastEntry."Document No.")
                    {
                    }
                    column(TempCFLedgEntryDesc;TempCFForecastEntry.Description)
                    {
                    }
                    column(TempCFLedgEntryAmt;TempCFForecastEntry."Amount (LCY)")
                    {
                    }
                    column(TempCFLedgEntryEntryNo;TempCFForecastEntry."Entry No.")
                    {
                    }
                    dataitem(Level3;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_2908; 2908)
                        {
                        }
                        column(DimValCode3;DimValCode[3])
                        {
                        }
                        column(DimCode3;DimCode[3])
                        {
                        }
                        column(DimValName3;DimValName[3])
                        {
                        }
                        column(TempCFLedgEntryCashFlowDt_Level3;TempCFForecastEntry."Cash Flow Date")
                        {
                        }
                        column(TempCFLedgEntryDocNo_Level3;TempCFForecastEntry."Document No.")
                        {
                        }
                        column(TempCFLedgEntryDesc_Level3;TempCFForecastEntry.Description)
                        {
                        }
                        column(TempCFLedgEntryAmt_Level3;TempCFForecastEntry."Amount (LCY)")
                        {
                        }
                        column(TempCFLedgEntryEntryNo_Level3;TempCFForecastEntry."Entry No.")
                        {
                        }
                        dataitem(Level4;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_1956; 1956)
                            {
                            }
                            column(DimValCode4;DimValCode[4])
                            {
                            }
                            column(DimCode4;DimCode[4])
                            {
                            }
                            column(DimValName4;DimValName[4])
                            {
                            }
                            column(TempCFLedgEntryCashFlowDt_Level4;TempCFForecastEntry."Cash Flow Date")
                            {
                            }
                            column(TempCFLedgEntryDocNo_Level4;TempCFForecastEntry."Document No.")
                            {
                            }
                            column(TempCFLedgEntryDesc_Level4;TempCFForecastEntry.Description)
                            {
                            }
                            column(TempCFLedgEntryAmt_Level4;TempCFForecastEntry."Amount (LCY)")
                            {
                            }
                            column(TempCFLedgEntryEntryNo_Level4;TempCFForecastEntry."Entry No.")
                            {
                            }
                            dataitem(Level5;"Integer")
                            {
                                DataItemTableView = sorting(Number);
                                column(ReportForNavId_5717; 5717)
                                {
                                }
                                column(TempCFLedgEntryEntryNo_Level5;TempCFForecastEntry."Entry No.")
                                {
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    if not PrintDetail(5) then
                                      CurrReport.Break;
                                end;

                                trigger OnPreDataItem()
                                begin
                                    if DimCode[4] = '' then
                                      CurrReport.Break;
                                    FindFirstCFLedgEntry[5] := true;
                                end;
                            }
                            dataitem(Level4e;"Integer")
                            {
                                DataItemTableView = sorting(Number) where(Number=const(1));
                                column(ReportForNavId_1256; 1256)
                                {
                                }
                                column(Total4;Total[4])
                                {
                                    AutoFormatType = 1;
                                }

                                trigger OnPostDataItem()
                                begin
                                    Total[4] := 0;
                                end;
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if DimCode[4] <> '' then begin
                                  if not CalcLine(4) and not PrintEmptyLines then
                                    CurrReport.Skip;
                                end else
                                  if not PrintDetail(4) then
                                    CurrReport.Break;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if DimCode[3] = '' then
                                  CurrReport.Break;
                                FindFirstDim[4] := true;
                                FindFirstCFLedgEntry[4] := true;
                            end;
                        }
                        dataitem(Level3e;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=const(1));
                            column(ReportForNavId_1681; 1681)
                            {
                            }
                            column(Total3;Total[3])
                            {
                                AutoFormatType = 1;
                            }

                            trigger OnPostDataItem()
                            begin
                                Total[3] := 0;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if DimCode[3] <> '' then begin
                              if not CalcLine(3) and not PrintEmptyLines then
                                CurrReport.Skip;
                            end else
                              if not PrintDetail(3) then
                                CurrReport.Break;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if DimCode[2] = '' then
                              CurrReport.Break;
                            FindFirstDim[3] := true;
                            FindFirstCFLedgEntry[3] := true;
                        end;
                    }
                    dataitem(Level2e;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3989; 3989)
                        {
                        }
                        column(Total2;Total[2])
                        {
                            AutoFormatType = 1;
                        }

                        trigger OnPostDataItem()
                        begin
                            Total[2] := 0;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if DimCode[2] <> '' then begin
                          if not CalcLine(2) and not PrintEmptyLines then
                            CurrReport.Skip;
                        end else
                          if not PrintDetail(2) then
                            CurrReport.Break;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if DimCode[1] = '' then
                          CurrReport.Break;
                        FindFirstDim[2] := true;
                        FindFirstCFLedgEntry[2] := true;
                    end;
                }
                dataitem(Level1e;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_3266; 3266)
                    {
                    }
                    column(Total1;Total[1])
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnPostDataItem()
                    begin
                        Total[1] := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if not CalcLine(1) and not PrintEmptyLines then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if DimCode[1] = '' then
                      CurrReport.Break;
                    FindFirstDim[1] := true;
                    FindFirstCFLedgEntry[1] := true;
                end;
            }

            trigger OnAfterGetRecord()
            var
                AccountingPeriod: Record "Accounting Period";
                i: Integer;
                StartDate: Date;
                EndDate: Date;
            begin
                if "Last Date Updated" <> 0D then
                  ViewLastUpdatedText :=
                    StrSubstNo('%1',"Last Date Updated")
                else
                  ViewLastUpdatedText := Text004;

                AnalysisViewEntry.Reset;
                AnalysisViewEntry.SetRange("Analysis View Code",Code);
                AnalysisViewEntry.SetFilter("Cash Flow Forecast No.",CFFilter);
                AnalysisViewEntry.SetFilter("Posting Date",DateFilter);
                StartDate := AnalysisViewEntry.GetRangeMin("Posting Date");
                EndDate := AnalysisViewEntry.GetRangemax("Posting Date");
                case "Date Compression" of
                  "date compression"::Week:
                    begin
                      StartDate := CalcDate('<CW+1D-1W>',StartDate);
                      EndDate := ClosingDate(CalcDate('<CW>',EndDate));
                    end;
                  "date compression"::Month:
                    begin
                      StartDate := CalcDate('<CM+1D-1M>',StartDate);
                      EndDate := ClosingDate(CalcDate('<CM>',EndDate));
                    end;
                  "date compression"::Quarter:
                    begin
                      StartDate := CalcDate('<CQ+1D-1Q>',StartDate);
                      EndDate := ClosingDate(CalcDate('<CQ>',EndDate));
                    end;
                  "date compression"::Year:
                    begin
                      StartDate := CalcDate('<CY+1D-1Y>',StartDate);
                      EndDate := ClosingDate(CalcDate('<CY>',EndDate));
                    end;
                  "date compression"::Period:
                    begin
                      AccountingPeriod.SetRange("Starting Date",0D,StartDate);
                      if AccountingPeriod.Find('+') then
                        StartDate := AccountingPeriod."Starting Date";
                      AccountingPeriod.SetRange("Starting Date",EndDate,Dmy2date(31,12,9999));
                      if AccountingPeriod.Find('-') then
                        if AccountingPeriod.Next <> 0 then
                          EndDate := ClosingDate(AccountingPeriod."Starting Date" - 1);
                    end;
                end;
                AnalysisViewEntry.SetRange("Posting Date",StartDate,EndDate);

                AnalysisViewEntry.FilterGroup(2);
                TempSelectedDim.Reset;
                TempSelectedDim.SetCurrentkey("User ID","Object Type","Object ID","Analysis View Code",Level);
                TempSelectedDim.SetFilter("Dimension Value Filter",'<>%1','');
                DimFilterText := '';
                if TempSelectedDim.Find('-') then
                  repeat
                    CompileFilterCaptionString(TempSelectedDim."Dimension Code",TempSelectedDim."Dimension Value Filter");
                    SetAnaViewEntryFilter(
                      TempSelectedDim."Dimension Code",TempSelectedDim."Dimension Value Filter");
                  until TempSelectedDim.Next = 0;

                if CFFilter <> '' then
                  CompileFilterCaptionString(Text007,CFFilter);

                AnalysisViewEntry.FilterGroup(0);

                TempSelectedDim.Reset;
                TempSelectedDim.SetCurrentkey("User ID","Object Type","Object ID","Analysis View Code",Level);
                TempSelectedDim.SetFilter(Level,'<>%1',TempSelectedDim.Level::" ");
                i := 1;
                if TempSelectedDim.Find('-') then
                  repeat
                    DimCode[i] := TempSelectedDim."Dimension Code";
                    LevelFilter[i] := TempSelectedDim."Dimension Value Filter";
                    i := i + 1;
                  until (TempSelectedDim.Next = 0) or (i > 4);

                if GLSetup."LCY Code" <> '' then
                  HeaderText := StrSubstNo(Text005,GLSetup."LCY Code")
                else
                  HeaderText := '';
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Code,AnalysisViewCode);
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
                    field(AnalysisViewCodes;AnalysisViewCode)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Analysis View Code';
                        Lookup = true;
                        TableRelation = "Analysis View".Code;
                        ToolTip = 'Specifies the code for the cash flow analysis view you want the report to be based on.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AnalysisView: Record "Analysis View";
                        begin
                            if Page.RunModal(Page::"Analysis View List",AnalysisView) = Action::LookupOK then begin
                              AnalysisViewCode := AnalysisView.Code;
                              UpdateColumnDim;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            UpdateColumnDim;
                        end;
                    }
                    field(ColumnDim;ColumnDim)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Include Dimensions';
                        Editable = false;
                        ToolTip = 'Specifies the dimensions that you want to include in the report. You can only select dimensions that are included in the cash flow analysis view that you select in the Analysis View Code field.';

                        trigger OnAssistEdit()
                        begin
                            DimSelectionBuf.SetDimSelectionLevelCFAcc(3,Report::"Cash Flow Dimensions - Detail",AnalysisViewCode,ColumnDim);
                        end;
                    }
                    field(ForecastFilter;CFFilter)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Cash Flow Forecast Filter';
                        ToolTip = 'Specifies the cash flow forecast(s) that are included.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            CashFlowForecastList: Page "Cash Flow Forecast List";
                        begin
                            CashFlowForecastList.LookupMode(true);
                            if CashFlowForecastList.RunModal = Action::LookupOK then begin
                              Text := CashFlowForecastList.GetSelectionFilter;
                              exit(true);
                            end;

                            exit(false)
                        end;
                    }
                    field(DateFilters;DateFilter)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Date Filter';
                        ToolTip = 'Specifies a date filter to filter entries by date. You can enter a particular date or a time interval.';

                        trigger OnValidate()
                        var
                            ApplicationManagement: Codeunit ApplicationManagement;
                        begin
                            if ApplicationManagement.MakeDateFilter(DateFilter) = 0 then;
                            TempCFAccount.SetFilter("Date Filter",DateFilter);
                            DateFilter := TempCFAccount.GetFilter("Date Filter");
                        end;
                    }
                    field(PrintEmptyLine;PrintEmptyLines)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Empty Lines';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want the report to include dimensions and dimension values that have a balance of zero. Choose the Print button to print the report or choose the Preview button to view it on the screen.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            GLSetup.Get;
            UpdateColumnDim;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        SelectedDim: Record "Selected Dimension";
    begin
        if AnalysisViewCode = '' then
          Error(Text000);

        if DateFilter = '' then
          Error(Text001);

        DimSelectionBuf.CompareDimText(
          3,Report::"Cash Flow Dimensions - Detail",AnalysisViewCode,ColumnDim,Text002);

        TempSelectedDim.Reset;
        TempSelectedDim.SetFilter("Dimension Value Filter",'<>%1','');
        TempSelectedDim.SetFilter("Dimension Code",TempCFAccount.TableCaption);
        if TempSelectedDim.Find('-') then
          CFAccount.SetFilter("No.",TempSelectedDim."Dimension Value Filter");
        CFAccount.SetRange("Account Type",CFAccount."account type"::Entry);
        if CFAccount.Find('-') then
          repeat
            TempCFAccount.Init;
            TempCFAccount := CFAccount;
            TempCFAccount.Insert;
          until CFAccount.Next = 0;

        TempCashFlowForecast.Init;
        TempCashFlowForecast.Insert;
        TempSelectedDim.SetFilter("Dimension Code",CashFlowForecast.TableCaption);
        if TempSelectedDim.Find('-') then
          CashFlowForecast.SetFilter("No.",TempSelectedDim."Dimension Value Filter");
        if CashFlowForecast.Find('-') then
          repeat
            TempCashFlowForecast.Init;
            TempCashFlowForecast := CashFlowForecast;
            TempCashFlowForecast.Insert;
          until CashFlowForecast.Next = 0;

        SelectedDim.GetSelectedDim(UserId,3,Report::"Cash Flow Dimensions - Detail",AnalysisViewCode,TempSelectedDim);
        TempSelectedDim.Reset;
        TempSelectedDim.SetCurrentkey("User ID","Object Type","Object ID","Analysis View Code",Level);
        TempSelectedDim.SetFilter(Level,'<>%1',TempSelectedDim.Level::" ");
        DimVal.SetRange("Dimension Value Type",DimVal."dimension value type"::Standard);
        if TempSelectedDim.Find('-') then
          repeat
            TempDimVal.Init;
            TempDimVal.Code := '';
            TempDimVal."Dimension Code" := CopyStr(TempSelectedDim."Dimension Code",1,20);
            TempDimVal.Name := Text003;
            TempDimVal.Insert;
            DimVal.SetRange("Dimension Code",TempSelectedDim."Dimension Code");
            if TempSelectedDim."Dimension Value Filter" <> '' then
              DimVal.SetFilter(Code,TempSelectedDim."Dimension Value Filter")
            else
              DimVal.SetRange(Code);
            if DimVal.Find('-') then
              repeat
                TempDimVal.Init;
                TempDimVal := DimVal;
                TempDimVal.Insert;
              until DimVal.Next = 0;
          until TempSelectedDim.Next = 0;
    end;

    var
        Text000: label 'Enter an analysis view code.';
        Text001: label 'Enter a date filter.';
        Text002: label 'Include Dimensions';
        Text003: label '(no dimension value)';
        Text004: label 'Not updated';
        Text005: label 'All amounts are in %1.';
        Text006: label '(no business unit)';
        Text007: label 'Cash Flow Forecast Filter';
        AnalysisViewEntry: Record "Analysis View Entry";
        TempSelectedDim: Record "Selected Dimension" temporary;
        CFAccount: Record "Cash Flow Account";
        CashFlowForecast: Record "Cash Flow Forecast";
        DimVal: Record "Dimension Value";
        TempCFForecastEntry: Record "Cash Flow Forecast Entry" temporary;
        TempCFAccount: Record "Cash Flow Account" temporary;
        TempCashFlowForecast: Record "Cash Flow Forecast" temporary;
        TempDimVal: Record "Dimension Value" temporary;
        DimSelectionBuf: Record "Dimension Selection Buffer";
        GLSetup: Record "General Ledger Setup";
        PrintEmptyLines: Boolean;
        ViewLastUpdatedText: Text[30];
        ColumnDim: Text[250];
        AnalysisViewCode: Code[10];
        DateFilter: Text[250];
        FindFirstDim: array [4] of Boolean;
        FindFirstCFLedgEntry: array [5] of Boolean;
        DimCode: array [4] of Text[30];
        DimValCode: array [4] of Code[20];
        DimValName: array [4] of Text[50];
        LevelFilter: array [4] of Text[250];
        HeaderText: Text[100];
        Total: array [4] of Decimal;
        DimFilterText: Text[250];
        CFFilter: Text[250];
        PeriodCaptionLbl: label 'Period';
        AnalysisViewCaptionLbl: label 'Analysis View';
        LastUpdatedCaptionLbl: label 'Last Date Updated';
        PageCaptionLbl: label 'Page';
        CashFlowDimensionsDetailCaptionLbl: label 'Cash Flow Dimensions - Detail';
        FiltersCaptionLbl: label 'Filters';
        AmountCaptionLbl: label 'Amount';
        DescriptionCaptionLbl: label 'Description';
        DocumentNoCaptionLbl: label 'Document No.';
        CashFlowDateCaptionLbl: label 'Cash Flow Date';
        CashFlowAccountNoCaptionLbl: label 'Cash Flow Account No.';
        EntryNoCaptionLbl: label 'Entry No.';

    local procedure CalcLine(Level: Integer): Boolean
    var
        HasEntries: Boolean;
        i: Integer;
    begin
        if Level < 4 then
          for i := Level + 1 to 4 do
            SetAnaViewEntryFilter(DimCode[i],'*');
        if Iteration(
             FindFirstDim[Level],DimCode[Level],DimValCode[Level],DimValName[Level],LevelFilter[Level])
        then begin
          SetAnaViewEntryFilter(DimCode[Level],DimValCode[Level]);
          HasEntries := AnalysisViewEntry.Find('-');
        end else
          CurrReport.Break;
        exit(HasEntries);
    end;

    local procedure PrintDetail(Level: Integer): Boolean
    var
        AnalysisViewEntryToGLEntries: Codeunit AnalysisViewEntryToGLEntries;
    begin
        if FindFirstCFLedgEntry[Level] then begin
          FindFirstCFLedgEntry[Level] := false;
          TempCFForecastEntry.Reset;
          TempCFForecastEntry.DeleteAll;
          if AnalysisViewEntry.Find('-') then begin
            repeat
              AnalysisViewEntryToGLEntries.GetCFLedgEntries(AnalysisViewEntry,TempCFForecastEntry);
            until AnalysisViewEntry.Next = 0;
          end;
          TempCFForecastEntry.SetCurrentkey("Cash Flow Forecast No.","Cash Flow Account No.","Source Type","Cash Flow Date");
          TempCFForecastEntry.SetFilter("Cash Flow Date",DateFilter);
          if not TempCFForecastEntry.Find('-') then
            exit(false);
        end else
          if TempCFForecastEntry.Next = 0 then
            exit(false);
        if Level > 1 then
          CalcTotalAmounts(Level - 1);
        exit(true);
    end;

    local procedure CalcTotalAmounts(Level: Integer)
    var
        i: Integer;
    begin
        for i := 1 to Level do
          Total[i] := Total[i] + TempCFForecastEntry."Amount (LCY)";
    end;

    local procedure UpdateColumnDim()
    var
        SelectedDim: Record "Selected Dimension";
        TempDimSelectionBuf: Record "Dimension Selection Buffer" temporary;
        AnalysisView: Record "Analysis View";
    begin
        AnalysisView.CopyAnalysisViewFilters(3,Report::"Cash Flow Dimensions - Detail",AnalysisViewCode);
        ColumnDim := '';
        SelectedDim.SetRange("User ID",UserId);
        SelectedDim.SetRange("Object Type",3);
        SelectedDim.SetRange("Object ID",Report::"Cash Flow Dimensions - Detail");
        SelectedDim.SetRange("Analysis View Code",AnalysisViewCode);
        if SelectedDim.Find('-') then begin
          repeat
            TempDimSelectionBuf.Init;
            TempDimSelectionBuf.Code := SelectedDim."Dimension Code";
            TempDimSelectionBuf.Selected := true;
            TempDimSelectionBuf."Dimension Value Filter" := SelectedDim."Dimension Value Filter";
            TempDimSelectionBuf.Level := SelectedDim.Level;
            TempDimSelectionBuf.Insert;
          until SelectedDim.Next = 0;
          TempDimSelectionBuf.SetDimSelection(
            3,Report::"Cash Flow Dimensions - Detail",AnalysisViewCode,ColumnDim,TempDimSelectionBuf);
        end;
    end;

    local procedure Iteration(var FindFirst: Boolean;IterationDimCode: Text[30];var IterationDimValCode: Code[20];var IterationDimValName: Text[50];IterationFilter: Text[250]): Boolean
    var
        SearchResult: Boolean;
    begin
        case IterationDimCode of
          TempCFAccount.TableCaption:
            begin
              TempCFAccount.Reset;
              TempCFAccount.SetFilter("No.",IterationFilter);
              if FindFirst then
                SearchResult := TempCFAccount.Find('-')
              else
                if TempCFAccount.Get(IterationDimValCode) then
                  SearchResult := (TempCFAccount.Next <> 0);
              if SearchResult then begin
                IterationDimValCode := TempCFAccount."No.";
                IterationDimValName := TempCFAccount.Name;
              end;
            end;
          TempCashFlowForecast.TableCaption:
            begin
              TempCashFlowForecast.Reset;
              TempCashFlowForecast.SetFilter("No.",IterationFilter);
              if FindFirst then
                SearchResult := TempCashFlowForecast.Find('-')
              else
                if TempCashFlowForecast.Get(IterationDimValCode) then
                  SearchResult := (TempCashFlowForecast.Next <> 0);
              if SearchResult then begin
                IterationDimValCode := TempCashFlowForecast."No.";
                if TempCashFlowForecast."No." <> '' then
                  IterationDimValName := TempCashFlowForecast.Description
                else
                  IterationDimValName := Text006;
              end;
            end;
          else begin
            TempDimVal.Reset;
            TempDimVal.SetRange("Dimension Code",IterationDimCode);
            TempDimVal.SetFilter(Code,IterationFilter);
            if FindFirst then
              SearchResult := TempDimVal.Find('-')
            else
              if TempDimVal.Get(IterationDimCode,IterationDimValCode) then
                SearchResult := (TempDimVal.Next <> 0);
            if SearchResult then begin
              IterationDimValCode := TempDimVal.Code;
              IterationDimValName := TempDimVal.Name;
            end;
          end;
        end;
        if not SearchResult then begin
          IterationDimValCode := '';
          IterationDimValName := '';
        end;
        FindFirst := false;
        exit(SearchResult);
    end;

    local procedure SetAnaViewEntryFilter(AnalysisViewDimCode: Text[30];AnalysisViewFilter: Text[250])
    begin
        if AnalysisViewFilter = '' then
          AnalysisViewFilter := '''''';
        case  AnalysisViewDimCode of
          TempCFAccount.TableCaption:
            if AnalysisViewFilter = '*' then
              AnalysisViewEntry.SetRange("Account No.")
            else begin
              AnalysisViewEntry.SetFilter("Account No.",AnalysisViewFilter);
              AnalysisViewEntry.SetRange("Account Source",AnalysisViewEntry."account source"::"Cash Flow Account");
            end;
          TempCashFlowForecast.TableCaption:
            if AnalysisViewFilter = '*' then
              AnalysisViewEntry.SetRange("Cash Flow Forecast No.")
            else
              AnalysisViewEntry.SetFilter("Cash Flow Forecast No.",AnalysisViewFilter);
          "Analysis View"."Dimension 1 Code":
            if AnalysisViewFilter = '*' then
              AnalysisViewEntry.SetRange("Dimension 1 Value Code")
            else
              AnalysisViewEntry.SetFilter("Dimension 1 Value Code",AnalysisViewFilter);
          "Analysis View"."Dimension 2 Code":
            if AnalysisViewFilter = '*' then
              AnalysisViewEntry.SetRange("Dimension 2 Value Code")
            else
              AnalysisViewEntry.SetFilter("Dimension 2 Value Code",AnalysisViewFilter);
          "Analysis View"."Dimension 3 Code":
            if AnalysisViewFilter = '*' then
              AnalysisViewEntry.SetRange("Dimension 3 Value Code")
            else
              AnalysisViewEntry.SetFilter("Dimension 3 Value Code",AnalysisViewFilter);
          "Analysis View"."Dimension 4 Code":
            if AnalysisViewFilter = '*' then
              AnalysisViewEntry.SetRange("Dimension 4 Value Code")
            else
              AnalysisViewEntry.SetFilter("Dimension 4 Value Code",AnalysisViewFilter);
        end;
    end;

    local procedure CompileFilterCaptionString(NewFilterCode: Text[250];NewFilterValue: Text[250])
    var
        Prefix: Text[2];
    begin
        if DimFilterText <> '' then
          Prefix := ', ';

        DimFilterText := CopyStr(DimFilterText + Prefix + NewFilterCode + ': ' + NewFilterValue,1,MaxStrLen(DimFilterText));
    end;


    procedure InitializeRequest(NewAnalysisViewCode: Code[10];NewCashFlowFilter: Text[100];NewDateFilter: Text[100];NewPrintEmptyLines: Boolean)
    begin
        AnalysisViewCode := NewAnalysisViewCode;
        CFFilter := NewCashFlowFilter;
        UpdateColumnDim;
        DateFilter := NewDateFilter;
        PrintEmptyLines := NewPrintEmptyLines;
    end;
}

