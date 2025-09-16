#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1123 "Cost Acctg. Stmt. per Period"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Acctg. Stmt. per Period.rdlc';
    Caption = 'Cost Acctg. Stmt. per Period';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Cost Type";"Cost Type")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.",Type,"Date Filter","Cost Center Filter","Cost Object Filter";
            column(ReportForNavId_2867; 2867)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(FilterTxt;FilterTxt)
            {
            }
            column(ComparePeriodTxt;ComparePeriodTxt)
            {
            }
            column(ActPeriodTxt;ActPeriodTxt)
            {
            }
            column(ShowAddCurr;ShowAddCurr)
            {
            }
            column(LcyCode_GLSetup;GLSetup."LCY Code")
            {
            }
            column(AllAmountare;AllAmountareLbl)
            {
            }
            column(AddRepCurr_GLSetup;GLSetup."Additional Reporting Currency")
            {
            }
            column(ActAmt;-ActAmt)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(ActAmtControl9;ActAmt)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(Pct;Pct)
            {
                DecimalPlaces = 1:1;
            }
            column(DiffAmount;DiffAmount)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(CompareAmt;-CompareAmt)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(CompareAmtControl12;CompareAmt)
            {
                AutoFormatType = 1;
                DecimalPlaces = 0:0;
            }
            column(PadstrIndentation2Name;PadStr('',Indentation * 2) + Name)
            {
            }
            column(No_CostType;"No.")
            {
            }
            column(LineTypeInt;LineTypeInt)
            {
            }
            column(CostAcctgStmtperPeriodCaption;CostAcctgStmtperPeriodCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(DebitCaption;DebitCaptionLbl)
            {
            }
            column(CreditCaption;CreditCaptionLbl)
            {
            }
            column(IncreaseDecreaseCaption;IncreaseDecreaseCaptionLbl)
            {
            }
            column(PercentOfCaption;PercentOfCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(NumberCaption;NumberCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ActAmt := CalcAmount("Cost Type",StartDate,EndDate,AmtType);
                CompareAmt := CalcAmount("Cost Type",FromCompareDate,ToCompareDate,AmtType);
                DiffAmount := ActAmt - CompareAmt;

                if CompareAmt <> 0 then
                  Pct := ROUND(ActAmt / CompareAmt * 100,0.1)
                else
                  Pct := 0;

                if (Type = Type::"Cost Type") and
                   OnlyAccWithEntries and
                   (ActAmt = 0) and
                   (CompareAmt = 0)
                then
                  CurrReport.Skip;

                if NewPage then begin
                  PageGroupNo := PageGroupNo + 1;
                  NewPage := false;
                end;
                NewPage := "New Page";

                LineTypeInt := Type;
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
                if (StartDate = 0D) or (EndDate = 0D) or (FromCompareDate = 0D) or (ToCompareDate = 0D) then
                  Error(Text000);

                if (EndDate < StartDate) or (ToCompareDate < FromCompareDate) then
                  Error(Text001);

                if GetFilters <> '' then
                  FilterTxt := Text002 + ' ' + GetFilters;

                // Col header for balance or movement
                if AmtType = Amttype::Balance then begin
                  ActPeriodTxt := StrSubstNo(Text003,EndDate);
                  ComparePeriodTxt := StrSubstNo(Text003,ToCompareDate);
                end else begin
                  ActPeriodTxt := StrSubstNo(Text004,StartDate,EndDate);
                  ComparePeriodTxt := StrSubstNo(Text004,FromCompareDate,ToCompareDate);
                end;

                PageGroupNo := 1;
                NewPage := false;
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
                    field(ComparisonType;ComparisonType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Comparison Type';
                        OptionCaption = 'Last Year,Last Half Year,Last Quarter,Last Month,Same Period Last Year,Free comparison';

                        trigger OnValidate()
                        begin
                            ComparisonTypeOnAfterValidate;
                        end;
                    }
                    group("Current Period")
                    {
                        Caption = 'Current Period';
                        field(StartDate;StartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';

                            trigger OnValidate()
                            begin
                                StartDateOnAfterValidate;
                            end;
                        }
                        field(EndingDate;EndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';

                            trigger OnValidate()
                            begin
                                EndDateOnAfterValidate;
                            end;
                        }
                    }
                    group("Comparison Period")
                    {
                        Caption = 'Comparison Period';
                        field(FromCompareDate;FromCompareDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';

                            trigger OnValidate()
                            begin
                                FromCompareDateOnAfterValidate;
                            end;
                        }
                        field(ToCompareDate;ToCompareDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';

                            trigger OnValidate()
                            begin
                                ToCompareDateOnAfterValidate;
                            end;
                        }
                    }
                    field(AmtType;AmtType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amounts in';
                        OptionCaption = 'Balance,Net Change';
                    }
                    field(OnlyAccWithEntries;OnlyAccWithEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Only Accounts with Balance or Movement';
                    }
                    field(ShowAddCurrency;ShowAddCurr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in Additional Currency';
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

    var
        Text000: label 'Starting date and ending date for the current period and comparison period must be defined.';
        Text001: label 'Ending date must not be before starting date.';
        Text002: label 'Filter:';
        Text003: label 'Balance at %1';
        Text004: label 'Movement  %1 - %2', Comment='%1 = Start Date, %2 = End Date';
        FreeCompTypeErr: label 'You cannot change the date because the Comparison Type is not set to Free Comparison.';
        GLSetup: Record "General Ledger Setup";
        StartDate: Date;
        EndDate: Date;
        FromCompareDate: Date;
        ToCompareDate: Date;
        ComparisonType: Option "Last Year","Last Half Year","Last Quarter","Last Month","Same Period Last Year","Free Comparison";
        AmtType: Option Balance,Movement;
        FilterTxt: Text;
        ActPeriodTxt: Text[30];
        ComparePeriodTxt: Text[30];
        OnlyAccWithEntries: Boolean;
        [InDataSet]
        ShowAddCurr: Boolean;
        ActAmt: Decimal;
        CompareAmt: Decimal;
        DiffAmount: Decimal;
        Pct: Decimal;
        PageGroupNo: Integer;
        NewPage: Boolean;
        LineTypeInt: Integer;
        FreeCompSamePeriodTypeErr: label 'You cannot change the date because the Comparison Type is not set to Free Comparison or Same Period Last Year.';
        AllAmountareLbl: label 'All amounts are in';
        CostAcctgStmtperPeriodCaptionLbl: label 'Cost Acctg. Stmt. per Period';
        PageNoCaptionLbl: label 'Page';
        DebitCaptionLbl: label 'Debit';
        CreditCaptionLbl: label 'Credit';
        IncreaseDecreaseCaptionLbl: label 'Increase/Decrease';
        PercentOfCaptionLbl: label '% of';
        NameCaptionLbl: label 'Name';
        NumberCaptionLbl: label 'Number';

    local procedure CalcPeriod()
    begin
        if StartDate = 0D then
          exit;

        case ComparisonType of
          Comparisontype::"Last Year":
            begin
              StartDate := CalcDate('<-CY>',StartDate);
              EndDate := CalcDate('<CY>',StartDate);
              FromCompareDate := CalcDate('<-1Y>',StartDate);
              ToCompareDate := CalcDate('<-1Y>',EndDate);
            end;
          Comparisontype::"Last Half Year":
            begin
              StartDate := CalcDate('<-CM>',StartDate);
              EndDate := CalcDate('<6M-1D>',StartDate);
              FromCompareDate := CalcDate('<-6M>',StartDate);
              ToCompareDate := CalcDate('<-1D>',StartDate);
            end;
          Comparisontype::"Last Quarter":
            begin
              StartDate := CalcDate('<-CM>',StartDate);
              EndDate := CalcDate('<3M-1D>',StartDate);
              FromCompareDate := CalcDate('<-3M>',StartDate);
              ToCompareDate := CalcDate('<-1D>',StartDate);
            end;
          Comparisontype::"Last Month":
            begin
              StartDate := CalcDate('<-CM>',StartDate);
              EndDate := CalcDate('<1M-1D>',StartDate);
              FromCompareDate := CalcDate('<-1M>',StartDate);
              ToCompareDate := CalcDate('<-1D>',StartDate);
            end;
          Comparisontype::"Same Period Last Year":
            begin
              FromCompareDate := CalcDate('<-1Y>',StartDate);
              if EndDate <> 0D then
                ToCompareDate := CalcDate('<-1Y>',EndDate);
            end;
        end;
    end;

    local procedure FromCompareDateOnAfterValidate()
    begin
        if ComparisonType <> Comparisontype::"Free Comparison" then
          Error(FreeCompTypeErr);
    end;

    local procedure ToCompareDateOnAfterValidate()
    begin
        if ComparisonType <> Comparisontype::"Free Comparison" then
          Error(FreeCompTypeErr);
    end;

    local procedure EndDateOnAfterValidate()
    begin
        if not (ComparisonType in [Comparisontype::"Same Period Last Year",Comparisontype::"Free Comparison"]) then
          Error(FreeCompSamePeriodTypeErr);

        if ComparisonType = Comparisontype::"Same Period Last Year" then
          if EndDate <> 0D then
            ToCompareDate := CalcDate('<-1Y>',EndDate)
          else
            ToCompareDate := 0D;
    end;

    local procedure StartDateOnAfterValidate()
    begin
        CalcPeriod;
    end;

    local procedure ComparisonTypeOnAfterValidate()
    begin
        CalcPeriod;
    end;

    local procedure CalcAmount(CostType: Record "Cost Type";FromDate: Date;ToDate: Date;AmountType: Option): Decimal
    begin
        with CostType do begin
          SetRange("Date Filter",FromDate,ToDate);
          if AmountType = Amttype::Movement then begin
            if ShowAddCurr then begin
              CalcFields("Add. Currency Net Change");
              exit("Add. Currency Net Change");
            end;
            CalcFields("Net Change");
            exit("Net Change");
          end;
          if ShowAddCurr then begin
            CalcFields("Add. Currency Balance at Date");
            exit("Add. Currency Balance at Date");
          end;
          CalcFields("Balance at Date");
          exit("Balance at Date");
        end;
    end;
}

