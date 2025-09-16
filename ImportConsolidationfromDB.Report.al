#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 90 "Import Consolidation from DB"
{
    Caption = 'Import Consolidation from DB';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Business Unit";"Business Unit")
        {
            DataItemTableView = sorting(Code) where(Consolidate=const(true));
            RequestFilterFields = "Code";
            column(ReportForNavId_9370; 9370)
            {
            }
            dataitem("G/L Account";"G/L Account")
            {
                DataItemTableView = sorting("No.") where("Account Type"=const(Posting));
                column(ReportForNavId_6710; 6710)
                {
                }
                dataitem("G/L Entry";"G/L Entry")
                {
                    DataItemLink = "G/L Account No."=field("No.");
                    DataItemTableView = sorting("G/L Account No.","Posting Date");
                    column(ReportForNavId_7069; 7069)
                    {
                    }
                    dataitem("Dimension Set Entry";"Dimension Set Entry")
                    {
                        DataItemLink = "Dimension Set ID"=field("Dimension Set ID");
                        DataItemTableView = sorting("Dimension Set ID","Dimension Code");
                        column(ReportForNavId_4925; 4925)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            TempDimBuf: Record "Dimension Buffer" temporary;
                        begin
                            TempDimBuf.Init;
                            TempDimBuf."Table ID" := Database::"G/L Entry";
                            TempDimBuf."Entry No." := GLEntryNo;
                            if TempDim.Get("Dimension Code") and
                               (TempDim."Consolidation Code" <> '')
                            then
                              TempDimBuf."Dimension Code" := TempDim."Consolidation Code"
                            else
                              TempDimBuf."Dimension Code" := "Dimension Code";
                            if TempDimVal.Get("Dimension Code","Dimension Value Code") and
                               (TempDimVal."Consolidation Code" <> '')
                            then
                              TempDimBuf."Dimension Value Code" := TempDimVal."Consolidation Code"
                            else
                              TempDimBuf."Dimension Value Code" := "Dimension Value Code";
                            BusUnitConsolidate.InsertEntryDim(TempDimBuf,TempDimBuf."Entry No.");
                        end;

                        trigger OnPreDataItem()
                        var
                            BusUnitDim: Record Dimension;
                            DimMgt: Codeunit DimensionManagement;
                            ColumnDimFilter: Text;
                        begin
                            if ColumnDim <> '' then begin
                              ColumnDimFilter := ConvertStr(ColumnDim,';','|');
                              BusUnitDim.ChangeCompany("Business Unit"."Company Name");
                              SetFilter("Dimension Code",DimMgt.GetConsolidatedDimFilterByDimFilter(BusUnitDim,ColumnDimFilter));
                            end;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GLEntryNo := BusUnitConsolidate.InsertGLEntry("G/L Entry");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Posting Date",ConsolidStartDate,ConsolidEndDate);

                        if GetRangeMin("Posting Date") = NormalDate(GetRangeMin("Posting Date")) then
                          CheckClosingPostings("G/L Account"."No.",GetRangeMin("Posting Date"),GetRangemax("Posting Date"));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,"No.");
                    Window.Update(3,'');

                    BusUnitConsolidate.InsertGLAccount("G/L Account");
                end;
            }
            dataitem("Currency Exchange Rate";"Currency Exchange Rate")
            {
                DataItemTableView = sorting("Currency Code","Starting Date");
                column(ReportForNavId_8685; 8685)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    BusUnitConsolidate.InsertExchRate("Currency Exchange Rate");
                end;

                trigger OnPreDataItem()
                var
                    SubsidGLSetup: Record "General Ledger Setup";
                begin
                    if "Business Unit"."Currency Code" = '' then
                      CurrReport.Break;

                    SubsidGLSetup.ChangeCompany("Business Unit"."Company Name");
                    SubsidGLSetup.Get;
                    AdditionalCurrencyCode := SubsidGLSetup."Additional Reporting Currency";
                    if SubsidGLSetup."LCY Code" <> '' then
                      SubsidCurrencyCode := SubsidGLSetup."LCY Code"
                    else
                      SubsidCurrencyCode := "Business Unit"."Currency Code";

                    if (ParentCurrencyCode = '') and (AdditionalCurrencyCode = '') then
                      CurrReport.Break;

                    SetFilter("Currency Code",'%1|%2',ParentCurrencyCode,AdditionalCurrencyCode);
                    SetRange("Starting Date",0D,ConsolidEndDate);
                end;
            }
            dataitem(DoTheConsolidation;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_4528; 4528)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    BusUnitConsolidate.SetGlobals(
                      '','',"Business Unit"."Company Name",
                      SubsidCurrencyCode,AdditionalCurrencyCode,ParentCurrencyCode,
                      0,ConsolidStartDate,ConsolidEndDate);
                    BusUnitConsolidate.UpdateGLEntryDimSetID;
                    BusUnitConsolidate.Run("Business Unit");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,Code);
                Window.Update(2,'');

                Clear(BusUnitConsolidate);
                BusUnitConsolidate.SetDocNo(GLDocNo);

                TestField("Company Name");
                "G/L Entry".ChangeCompany("Company Name");
                "Dimension Set Entry".ChangeCompany("Company Name");
                "G/L Account".ChangeCompany("Company Name");
                "Currency Exchange Rate".ChangeCompany("Company Name");
                Dim.ChangeCompany("Company Name");
                DimVal.ChangeCompany("Company Name");

                SelectedDim.SetRange("User ID",UserId);
                SelectedDim.SetRange("Object Type",3);
                SelectedDim.SetRange("Object ID",Report::"Import Consolidation from DB");
                BusUnitConsolidate.SetSelectedDim(SelectedDim);

                TempDim.Reset;
                TempDim.DeleteAll;
                if Dim.Find('-') then begin
                  repeat
                    TempDim.Init;
                    TempDim := Dim;
                    TempDim.Insert;
                  until Dim.Next = 0;
                end;
                TempDim.Reset;
                TempDimVal.Reset;
                TempDimVal.DeleteAll;
                if DimVal.Find('-') then begin
                  repeat
                    TempDimVal.Init;
                    TempDimVal := DimVal;
                    TempDimVal.Insert;
                  until DimVal.Next = 0;
                end;

                AdditionalCurrencyCode := '';
                SubsidCurrencyCode := '';
            end;

            trigger OnPreDataItem()
            begin
                CheckConsolidDates(ConsolidStartDate,ConsolidEndDate);

                if GLDocNo = '' then
                  Error(Text000);

                Window.Open(
                  Text001 +
                  Text002 +
                  Text003 +
                  Text004);
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
                    group("Copy Field Contents")
                    {
                        Caption = 'Copy Field Contents';
                        field(ColumnDim;ColumnDim)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Copy Dimensions';
                            Editable = false;

                            trigger OnAssistEdit()
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3,Report::"Import Consolidation from DB",ColumnDim);
                            end;
                        }
                    }
                    field(DocumentNo;GLDocNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';
                    }
                    field(ParentCurrencyCode;ParentCurrencyCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Parent Currency Code';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if ParentCurrencyCode = '' then begin
              GLSetup.Get;
              ParentCurrencyCode := GLSetup."LCY Code";
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        DimSelectionBuf.CompareDimText(
          3,Report::"Import Consolidation from DB",'',ColumnDim,Text020);
    end;

    var
        Text000: label 'Enter a document number.';
        Text001: label 'Importing Subsidiary Data...\\';
        Text002: label 'Business Unit Code   #1##########\';
        Text003: label 'G/L Account No.      #2##########\';
        Text004: label 'Date                 #3######';
        Text006: label 'Enter the starting date for the consolidation period.';
        Text007: label 'Enter the ending date for the consolidation period.';
        Text020: label 'Copy Dimensions';
        Text022: label 'A %1 with %2 on a closing date (%3) was found while consolidating nonclosing entries (%4 %5).';
        Text023: label 'Do you want to consolidate in the period from %1 to %2?';
        Text024: label 'There is no %1 to consolidate.';
        Text025: label 'The consolidation period %1 .. %2 is not within the fiscal year of one or more of the subsidiaries.\';
        Text026: label 'Do you want to proceed with the consolidation?';
        Text028: label 'You must create a new fiscal year in the consolidated company.';
        Text029: label 'The consolidation period %1 .. %2 is not within the fiscal year %3 .. %4 of the consolidated company %5.\';
        Text030: label 'When using closing dates, the starting and ending dates must be the same.';
        Text031: label 'The %1 %2 of %3 %4, is not the %1 of the fiscal year of company %5.';
        SelectedDim: Record "Selected Dimension";
        Dim: Record Dimension;
        DimVal: Record "Dimension Value";
        TempDim: Record Dimension temporary;
        TempDimVal: Record "Dimension Value" temporary;
        GLSetup: Record "General Ledger Setup";
        DimSelectionBuf: Record "Dimension Selection Buffer";
        BusUnitConsolidate: Codeunit Consolidate;
        Window: Dialog;
        ConsolidStartDate: Date;
        ConsolidEndDate: Date;
        GLDocNo: Code[20];
        ColumnDim: Text[250];
        ParentCurrencyCode: Code[10];
        SubsidCurrencyCode: Code[10];
        AdditionalCurrencyCode: Code[10];
        Text032: label 'The %1 is later than the %2 in company %3.';
        GLEntryNo: Integer;

    local procedure CheckClosingPostings(GLAccNo: Code[20];StartDate: Date;EndDate: Date)
    var
        GLEntry: Record "G/L Entry";
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.ChangeCompany("Business Unit"."Company Name");
        AccountingPeriod.SetCurrentkey("New Fiscal Year","Date Locked");
        AccountingPeriod.SetRange("New Fiscal Year",true);
        AccountingPeriod.SetRange("Date Locked",true);
        AccountingPeriod.SetRange("Starting Date",StartDate + 1,EndDate);
        if AccountingPeriod.Find('-') then begin
          GLEntry.ChangeCompany("Business Unit"."Company Name");
          GLEntry.SetRange("G/L Account No.",GLAccNo);
          repeat
            GLEntry.SetRange("Posting Date",ClosingDate(AccountingPeriod."Starting Date" - 1));
            if not GLEntry.IsEmpty then
              Error(
                Text022,
                GLEntry.TableCaption,
                GLEntry.FieldCaption("Posting Date"),
                GLEntry.GetFilter("Posting Date"),
                GLEntry.FieldCaption("G/L Account No."),
                GLAccNo);
          until AccountingPeriod.Next = 0;
        end;
    end;

    local procedure CheckConsolidDates(StartDate: Date;EndDate: Date)
    var
        BusUnit: Record "Business Unit";
        ConsolPeriodInclInFiscalYears: Boolean;
    begin
        if StartDate = 0D then
          Error(Text006);
        if EndDate = 0D then
          Error(Text007);

        if not
           Confirm(
             Text023,
             false,StartDate,EndDate)
        then
          CurrReport.Break;

        CheckClosingDates(StartDate,EndDate);

        BusUnit.CopyFilters("Business Unit");
        BusUnit.SetRange(Consolidate,true);
        if not BusUnit.Find('-') then
          Error(Text024,BusUnit.TableCaption);

        ConsolPeriodInclInFiscalYears := true;
        repeat
          if (StartDate = NormalDate(StartDate)) or (EndDate = NormalDate(EndDate)) then
            if (BusUnit."Starting Date" <> 0D) or (BusUnit."Ending Date" <> 0D) then begin
              CheckBusUnitsDatesToFiscalYear(BusUnit);
              ConsolPeriodInclInFiscalYears :=
                ConsolPeriodInclInFiscalYears and CheckDatesToBusUnitDates(StartDate,EndDate,BusUnit);
            end;
        until BusUnit.Next = 0;

        if not ConsolPeriodInclInFiscalYears then
          if not Confirm(
               Text025 +
               Text026,
               false,StartDate,EndDate)
          then
            CurrReport.Break;

        CheckDatesToFiscalYear(StartDate,EndDate);
    end;

    local procedure CheckDatesToFiscalYear(StartDate: Date;EndDate: Date)
    var
        AccountingPeriod: Record "Accounting Period";
        FiscalYearStartDate: Date;
        FiscalYearEndDate: Date;
        ConsolPeriodInclInFiscalYear: Boolean;
    begin
        ConsolPeriodInclInFiscalYear := true;

        AccountingPeriod.Reset;
        AccountingPeriod.SetRange(Closed,false);
        AccountingPeriod.SetRange("New Fiscal Year",true);
        AccountingPeriod.Find('-');

        FiscalYearStartDate := AccountingPeriod."Starting Date";
        if AccountingPeriod.Find('>') then
          FiscalYearEndDate := CalcDate('<-1D>',AccountingPeriod."Starting Date")
        else
          Error(Text028);

        ConsolPeriodInclInFiscalYear := (StartDate >= FiscalYearStartDate) and (EndDate <= FiscalYearEndDate);

        if not ConsolPeriodInclInFiscalYear then
          if not Confirm(
               Text029 +
               Text026,
               false,StartDate,EndDate,FiscalYearStartDate,FiscalYearEndDate,COMPANYNAME)
          then
            CurrReport.Break;
    end;

    local procedure CheckDatesToBusUnitDates(StartDate: Date;EndDate: Date;BusUnit: Record "Business Unit"): Boolean
    var
        ConsolPeriodInclInFiscalYear: Boolean;
    begin
        ConsolPeriodInclInFiscalYear := (StartDate >= BusUnit."Starting Date") and (EndDate <= BusUnit."Ending Date");
        exit(ConsolPeriodInclInFiscalYear);
    end;

    local procedure CheckClosingDates(StartDate: Date;EndDate: Date)
    begin
        if (StartDate = ClosingDate(StartDate)) or
           (EndDate = ClosingDate(EndDate))
        then begin
          if StartDate <> EndDate then
            Error(Text030);
        end;
    end;

    local procedure CheckBusUnitsDatesToFiscalYear(var BusUnit: Record "Business Unit")
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        with BusUnit do
          if ("Starting Date" <> 0D) or ("Ending Date" <> 0D) then begin
            TestField("Starting Date");
            TestField("Ending Date");
            if "Starting Date" > "Ending Date" then
              Error(
                Text032,FieldCaption("Starting Date"),
                FieldCaption("Ending Date"),"Company Name");

            AccountingPeriod.Reset;
            AccountingPeriod.ChangeCompany("Company Name");
            if not AccountingPeriod.Get("Starting Date") then
              Error(
                Text031,
                FieldCaption("Starting Date"),"Starting Date",TableCaption,Code,"Company Name");

            if not AccountingPeriod."New Fiscal Year" then
              Error(
                Text031,
                FieldCaption("Starting Date"),"Starting Date",TableCaption,Code,"Company Name")
              ;

            if not AccountingPeriod.Get("Ending Date" + 1) then
              Error(
                Text031,
                FieldCaption("Ending Date"),"Ending Date",TableCaption,Code,"Company Name");

            if not AccountingPeriod."New Fiscal Year" then
              Error(
                Text031,
                FieldCaption("Ending Date"),"Ending Date",TableCaption,Code,"Company Name")
              ;
          end;
    end;
}

