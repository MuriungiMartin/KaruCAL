#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 28 "Dimensions - Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Dimensions - Detail.rdlc';
    Caption = 'Dimensions - Detail';
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
            column(Analysis_View_Name;Name)
            {
            }
            column(Analysis_View_Code;Code)
            {
            }
            column(DateFilter;DateFilter)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(DimFilterText;DimFilterText)
            {
            }
            column(DateFilterCaption;DateFilterCaptionLbl)
            {
            }
            column(Analysis_View_CodeCaption;Analysis_View_CodeCaptionLbl)
            {
            }
            column(ViewLastUpdatedTextCaption;ViewLastUpdatedTextCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Dimensions___DetailCaption;Dimensions___DetailCaptionLbl)
            {
            }
            column(FiltersCaption;FiltersCaptionLbl)
            {
            }
            column(Credit_AmountCaption;Credit_AmountCaptionLbl)
            {
            }
            column(Debit_AmountCaption;Debit_AmountCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(Document_No_Caption;Document_No_CaptionLbl)
            {
            }
            column(Posting_DateCaption;Posting_DateCaptionLbl)
            {
            }
            column(G_L_Account_No_Caption;G_L_Account_No_CaptionLbl)
            {
            }
            column(Entry_No_Caption;Entry_No_CaptionLbl)
            {
            }
            dataitem(Level1;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_1982; 1982)
                {
                }
                column(DimValCode_1_;DimValCode[1])
                {
                }
                column(DimCode_1_;DimCode[1])
                {
                }
                column(DimValName_1_;DimValName[1])
                {
                }
                column(UseAmtsInAddCurr;UseAmtsInAddCurr)
                {
                }
                column(Text015;Text015Lbl)
                {
                }
                column(AddRepCurrency;AddRepCurrency)
                {
                }
                column(LCYCODE;LCYCODE)
                {
                }
                dataitem(Level2;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_6891; 6891)
                    {
                    }
                    column(DimValCode_2_;DimValCode[2])
                    {
                    }
                    column(DimCode_2_;DimCode[2])
                    {
                    }
                    column(DimValName_2_;DimValName[2])
                    {
                    }
                    column(TempGLEntry__G_L_Account_No__;TempGLEntry."G/L Account No.")
                    {
                    }
                    column(TempGLEntry__Posting_Date_;Format(TempGLEntry."Posting Date"))
                    {
                    }
                    column(TempGLEntry__Document_No__;TempGLEntry."Document No.")
                    {
                    }
                    column(TempGLEntry_Description;TempGLEntry.Description)
                    {
                    }
                    column(TempGLEntry__Debit_Amount_;TempGLEntry."Debit Amount")
                    {
                    }
                    column(TempGLEntry__Credit_Amount_;TempGLEntry."Credit Amount")
                    {
                    }
                    column(TempGLEntry__Entry_No__;TempGLEntry."Entry No.")
                    {
                    }
                    dataitem(Level3;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_2908; 2908)
                        {
                        }
                        column(DimValCode_3_;DimValCode[3])
                        {
                        }
                        column(DimCode_3_;DimCode[3])
                        {
                        }
                        column(DimValName_3_;DimValName[3])
                        {
                        }
                        column(TempGLEntry__Debit_Amount__Control25;TempGLEntry."Debit Amount")
                        {
                        }
                        column(TempGLEntry__Credit_Amount__Control26;TempGLEntry."Credit Amount")
                        {
                        }
                        column(TempGLEntry__Entry_No___Control86;TempGLEntry."Entry No.")
                        {
                        }
                        dataitem(Level4;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_1956; 1956)
                            {
                            }
                            column(DimValCode_4_;DimValCode[4])
                            {
                            }
                            column(DimCode_4_;DimCode[4])
                            {
                            }
                            column(DimValName_4_;DimValName[4])
                            {
                            }
                            column(TempGLEntry__Debit_Amount__Control36;TempGLEntry."Debit Amount")
                            {
                            }
                            column(TempGLEntry__Credit_Amount__Control37;TempGLEntry."Credit Amount")
                            {
                            }
                            column(TempGLEntry__Entry_No___Control87;TempGLEntry."Entry No.")
                            {
                            }
                            dataitem(Level5;"Integer")
                            {
                                DataItemTableView = sorting(Number);
                                column(ReportForNavId_5717; 5717)
                                {
                                }
                                column(TempGLEntry__Credit_Amount__Control52;TempGLEntry."Credit Amount")
                                {
                                }
                                column(TempGLEntry__Debit_Amount__Control53;TempGLEntry."Debit Amount")
                                {
                                }
                                column(TempGLEntry__Entry_No___Control88;TempGLEntry."Entry No.")
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
                                    FindFirstGLEntry[5] := true;
                                end;
                            }
                            dataitem(Level4e;"Integer")
                            {
                                DataItemTableView = sorting(Number) where(Number=const(1));
                                column(ReportForNavId_1256; 1256)
                                {
                                }
                                column(DebitTotal_4_;DebitTotal[4])
                                {
                                    AutoFormatType = 1;
                                }
                                column(CreditTotal_4_;CreditTotal[4])
                                {
                                    AutoFormatType = 1;
                                }

                                trigger OnPostDataItem()
                                begin
                                    DebitTotal[4] := 0;
                                    CreditTotal[4] := 0;
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
                                FindFirstGLEntry[4] := true;
                            end;
                        }
                        dataitem(Level3e;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=const(1));
                            column(ReportForNavId_1681; 1681)
                            {
                            }
                            column(DebitTotal_3_;DebitTotal[3])
                            {
                                AutoFormatType = 1;
                            }
                            column(CreditTotal_3_;CreditTotal[3])
                            {
                                AutoFormatType = 1;
                            }

                            trigger OnPostDataItem()
                            begin
                                DebitTotal[3] := 0;
                                CreditTotal[3] := 0;
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
                            FindFirstGLEntry[3] := true;
                        end;
                    }
                    dataitem(Level2e;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3989; 3989)
                        {
                        }
                        column(DebitTotal_2_;DebitTotal[2])
                        {
                            AutoFormatType = 1;
                        }
                        column(CreditTotal_2_;CreditTotal[2])
                        {
                            AutoFormatType = 1;
                        }

                        trigger OnPostDataItem()
                        begin
                            DebitTotal[2] := 0;
                            CreditTotal[2] := 0;
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
                        FindFirstGLEntry[2] := true;
                    end;
                }
                dataitem(Level1e;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_3266; 3266)
                    {
                    }
                    column(CreditTotal_1_;CreditTotal[1])
                    {
                        AutoFormatType = 1;
                    }
                    column(DebitTotal_1_;DebitTotal[1])
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnPostDataItem()
                    begin
                        DebitTotal[1] := 0;
                        CreditTotal[1] := 0;
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
                    FindFirstGLEntry[1] := true;
                end;
            }

            trigger OnAfterGetRecord()
            var
                AccountingPeriod: Record "Accounting Period";
                i: Integer;
                StartDate: Date;
                EndDate: Date;
                ThisFilter: Text[250];
            begin
                if "Last Date Updated" <> 0D then
                  ViewLastUpdatedText :=
                    StrSubstNo('%1',"Last Date Updated")
                else
                  ViewLastUpdatedText := Text004;

                AnalysisViewEntry.Reset;
                AnalysisViewEntry.SetRange("Analysis View Code",Code);
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
                    ThisFilter := '';
                    if DimFilterText <> '' then
                      ThisFilter := ', ';
                    ThisFilter :=
                      ThisFilter + TempSelectedDim."Dimension Code" + ': ' + TempSelectedDim."Dimension Value Filter";
                    if StrLen(DimFilterText) + StrLen(ThisFilter) <= 250 then
                      DimFilterText := DimFilterText + ThisFilter;
                    SetAnaViewEntryFilter(
                      TempSelectedDim."Dimension Code",TempSelectedDim."Dimension Value Filter");
                  until TempSelectedDim.Next = 0;
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
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Code,AnalysisViewCode);
                GLSetup.Get;
                LCYCODE := GLSetup."LCY Code";
                AddRepCurrency := GLSetup."Additional Reporting Currency";
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
                    field(AnalysisViewCode;AnalysisViewCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Analysis View Code';
                        Lookup = true;
                        TableRelation = "Analysis View".Code;

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
                    field(IncludeDimensions;ColumnDim)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Dimensions';
                        Editable = false;

                        trigger OnAssistEdit()
                        begin
                            DimSelectionBuf.SetDimSelectionLevelGLAcc(3,Report::"Dimensions - Detail",AnalysisViewCode,ColumnDim);
                        end;
                    }
                    field(DtFilter;DateFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date Filter';

                        trigger OnValidate()
                        var
                            ApplicationManagement: Codeunit ApplicationManagement;
                        begin
                            if ApplicationManagement.MakeDateFilter(DateFilter) = 0 then;
                            TempGLAcc.SetFilter("Date Filter",DateFilter);
                            DateFilter := TempGLAcc.GetFilter("Date Filter");
                        end;
                    }
                    field(PrintEmptyLines;PrintEmptyLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Empty Lines';
                        MultiLine = true;
                    }
                    field(ShowAmountsInAddRepCurrency;UseAmtsInAddCurr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
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
            if GLSetup."Additional Reporting Currency" = '' then
              UseAmtsInAddCurr := false;
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
          3,Report::"Dimensions - Detail",AnalysisViewCode,ColumnDim,Text002);

        TempSelectedDim.Reset;
        TempSelectedDim.SetFilter("Dimension Value Filter",'<>%1','');
        TempSelectedDim.SetFilter("Dimension Code",TempGLAcc.TableCaption);
        if TempSelectedDim.Find('-') then
          GLAcc.SetFilter("No.",TempSelectedDim."Dimension Value Filter");
        GLAcc.SetRange("Account Type",GLAcc."account type"::Posting);
        if GLAcc.Find('-') then
          repeat
            TempGLAcc.Init;
            TempGLAcc := GLAcc;
            TempGLAcc.Insert;
          until GLAcc.Next = 0;

        TempBusUnit.Init;
        TempBusUnit.Insert;
        TempSelectedDim.SetFilter("Dimension Code",BusUnit.TableCaption);
        if TempSelectedDim.Find('-') then
          BusUnit.SetFilter(Code,TempSelectedDim."Dimension Value Filter");
        if BusUnit.Find('-') then
          repeat
            TempBusUnit.Init;
            TempBusUnit := BusUnit;
            TempBusUnit.Insert;
          until BusUnit.Next = 0;

        SelectedDim.GetSelectedDim(UserId,3,Report::"Dimensions - Detail",AnalysisViewCode,TempSelectedDim);
        TempSelectedDim.Reset;
        TempSelectedDim.SetCurrentkey("User ID","Object Type","Object ID","Analysis View Code",Level);
        TempSelectedDim.SetFilter(Level,'<>%1',TempSelectedDim.Level::" ");
        DimVal.SetFilter(
          "Dimension Value Type",'%1|%2',DimVal."dimension value type"::Standard,DimVal."dimension value type"::"Begin-Total");
        if TempSelectedDim.Find('-') then
          repeat
            TempDimVal.Init;
            TempDimVal.Code := '';
            TempDimVal."Dimension Code" := TempSelectedDim."Dimension Code";
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
        Text014: label '(no business unit)';
        AnalysisViewEntry: Record "Analysis View Entry";
        TempSelectedDim: Record "Selected Dimension" temporary;
        GLAcc: Record "G/L Account";
        BusUnit: Record "Business Unit";
        DimVal: Record "Dimension Value";
        TempGLEntry: Record "G/L Entry" temporary;
        TempGLAcc: Record "G/L Account" temporary;
        TempBusUnit: Record "Business Unit" temporary;
        TempDimVal: Record "Dimension Value" temporary;
        DimSelectionBuf: Record "Dimension Selection Buffer";
        GLSetup: Record "General Ledger Setup";
        PrintEmptyLines: Boolean;
        UseAmtsInAddCurr: Boolean;
        ViewLastUpdatedText: Text[30];
        ColumnDim: Text[250];
        AnalysisViewCode: Code[10];
        DateFilter: Text[250];
        FindFirstDim: array [4] of Boolean;
        FindFirstGLEntry: array [5] of Boolean;
        DimCode: array [4] of Text[30];
        DimValCode: array [4] of Code[20];
        DimValName: array [4] of Text[50];
        LevelFilter: array [4] of Text[250];
        AddRepCurrency: Text[50];
        LCYCODE: Text[50];
        DebitTotal: array [4] of Decimal;
        CreditTotal: array [4] of Decimal;
        DimFilterText: Text[250];
        DateFilterCaptionLbl: label 'Period';
        Analysis_View_CodeCaptionLbl: label 'Analysis View';
        ViewLastUpdatedTextCaptionLbl: label 'Last Date Updated';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Dimensions___DetailCaptionLbl: label 'Dimensions - Detail';
        FiltersCaptionLbl: label 'Filters';
        Credit_AmountCaptionLbl: label 'Credit Amount';
        Debit_AmountCaptionLbl: label 'Debit Amount';
        DescriptionCaptionLbl: label 'Description';
        Document_No_CaptionLbl: label 'Document No.';
        Posting_DateCaptionLbl: label 'Posting Date';
        G_L_Account_No_CaptionLbl: label 'G/L Account No.';
        Entry_No_CaptionLbl: label 'Entry No.';
        Text015Lbl: label 'All amounts are in ';

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
        if FindFirstGLEntry[Level] then begin
          FindFirstGLEntry[Level] := false;
          TempGLEntry.Reset;
          TempGLEntry.DeleteAll;
          if AnalysisViewEntry.Find('-') then begin
            repeat
              AnalysisViewEntryToGLEntries.GetGLEntries(AnalysisViewEntry,TempGLEntry);
            until AnalysisViewEntry.Next = 0;
          end;
          TempGLEntry.SetCurrentkey("G/L Account No.","Posting Date");
          TempGLEntry.SetFilter("Posting Date",DateFilter);
          if not TempGLEntry.Find('-') then
            exit(false);
        end else
          if TempGLEntry.Next = 0 then
            exit(false);
        if Level > 1 then
          CalcTotalAmounts(Level - 1);
        exit(true);
    end;

    local procedure CalcTotalAmounts(Level: Integer)
    var
        i: Integer;
    begin
        for i := 1 to Level do begin
          if UseAmtsInAddCurr then begin
            TempGLEntry."Debit Amount" := TempGLEntry."Add.-Currency Debit Amount";
            TempGLEntry."Credit Amount" := TempGLEntry."Add.-Currency Credit Amount";
          end;
          DebitTotal[i] := DebitTotal[i] + TempGLEntry."Debit Amount";
          CreditTotal[i] := CreditTotal[i] + TempGLEntry."Credit Amount";
        end;
    end;

    local procedure UpdateColumnDim()
    var
        SelectedDim: Record "Selected Dimension";
        TempDimSelectionBuf: Record "Dimension Selection Buffer" temporary;
        AnalysisView: Record "Analysis View";
    begin
        AnalysisView.CopyAnalysisViewFilters(3,Report::"Dimensions - Detail",AnalysisViewCode);
        ColumnDim := '';
        SelectedDim.SetRange("User ID",UserId);
        SelectedDim.SetRange("Object Type",3);
        SelectedDim.SetRange("Object ID",Report::"Dimensions - Detail");
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
            3,Report::"Dimensions - Detail",AnalysisViewCode,ColumnDim,TempDimSelectionBuf);
        end;
    end;

    local procedure Iteration(var FindFirst: Boolean;IterationDimCode: Text[30];var IterationDimValCode: Code[20];var IterationDimValName: Text[50];IterationFilter: Text[250]): Boolean
    var
        SearchResult: Boolean;
    begin
        case IterationDimCode of
          TempGLAcc.TableCaption:
            begin
              TempGLAcc.Reset;
              TempGLAcc.SetFilter("No.",IterationFilter);
              if FindFirst then
                SearchResult := TempGLAcc.Find('-')
              else
                if TempGLAcc.Get(IterationDimValCode) then
                  SearchResult := (TempGLAcc.Next <> 0);
              if SearchResult then begin
                IterationDimValCode := TempGLAcc."No.";
                IterationDimValName := TempGLAcc.Name;
              end;
            end;
          TempBusUnit.TableCaption:
            begin
              TempBusUnit.Reset;
              TempBusUnit.SetFilter(Code,IterationFilter);
              if FindFirst then
                SearchResult := TempBusUnit.Find('-')
              else
                if TempBusUnit.Get(IterationDimValCode) then
                  SearchResult := (TempBusUnit.Next <> 0);
              if SearchResult then begin
                IterationDimValCode := TempBusUnit.Code;
                if TempBusUnit.Code <> '' then
                  IterationDimValName := TempBusUnit.Name
                else
                  IterationDimValName := Text014;
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
          TempGLAcc.TableCaption:
            if AnalysisViewFilter = '*' then
              AnalysisViewEntry.SetRange("Account No.")
            else
              AnalysisViewEntry.SetFilter("Account No.",AnalysisViewFilter);
          TempBusUnit.TableCaption:
            if AnalysisViewFilter = '*' then
              AnalysisViewEntry.SetRange("Business Unit Code")
            else
              AnalysisViewEntry.SetFilter("Business Unit Code",AnalysisViewFilter);
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
}

