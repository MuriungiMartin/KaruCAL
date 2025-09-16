#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 12 "VAT Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VAT Statement.rdlc';
    Caption = 'VAT Statement';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("VAT Statement Name";"VAT Statement Name")
        {
            DataItemTableView = sorting("Statement Template Name",Name);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Statement Template Name",Name;
            column(ReportForNavId_8917; 8917)
            {
            }
            column(StmtName1_VatStmtName;"Statement Template Name")
            {
            }
            column(Name1_VatStmtName;Name)
            {
            }
            dataitem("VAT Statement Line";"VAT Statement Line")
            {
                DataItemLink = "Statement Template Name"=field("Statement Template Name"),"Statement Name"=field(Name);
                DataItemTableView = sorting("Statement Template Name","Statement Name") where(Print=const(true));
                RequestFilterFields = "Row No.";
                column(ReportForNavId_6068; 6068)
                {
                }
                column(Heading;Heading)
                {
                }
                column(CompanyName;COMPANYNAME)
                {
                }
                column(StmtName_VatStmtName;"VAT Statement Name"."Statement Template Name")
                {
                }
                column(Name_VatStmtName;"VAT Statement Name".Name)
                {
                }
                column(Heading2;Heading2)
                {
                }
                column(HeaderText;HeaderText)
                {
                }
                column(GlSetupLCYCode;GLSetup."LCY Code")
                {
                }
                column(Allamountsarein;AllamountsareinLbl)
                {
                }
                column(TxtGLSetupAddnalReportCur;StrSubstNo(Text003,GLSetup."Additional Reporting Currency"))
                {
                }
                column(GLSetupAddRepCurrency;GLSetup."Additional Reporting Currency")
                {
                }
                column(VatStmLineTableCaptFilter;TableCaption + ': ' + VATStmtLineFilter)
                {
                }
                column(VatStmtLineFilter;VATStmtLineFilter)
                {
                }
                column(VatStmtLineRowNo;"Row No.")
                {
                    IncludeCaption = true;
                }
                column(Description_VatStmtLine;Description)
                {
                    IncludeCaption = true;
                }
                column(TotalAmount;TotalAmount)
                {
                    AutoFormatExpression = GetCurrency;
                    AutoFormatType = 1;
                }
                column(UseAmtsInAddCurr;UseAmtsInAddCurr)
                {
                }
                column(Selection;Selection)
                {
                }
                column(PeriodSelection;PeriodSelection)
                {
                }
                column(PrintInIntegers;PrintInIntegers)
                {
                }
                column(PageGroupNo;PageGroupNo)
                {
                }
                column(VATStmtCaption;VATStmtCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
                {
                }
                column(VATStmtTemplateCaption;VATStmtTemplateCaptionLbl)
                {
                }
                column(VATStmtNameCaption;VATStmtNameCaptionLbl)
                {
                }
                column(AmtsareinwholeLCYsCaption;AmtsareinwholeLCYsCaptionLbl)
                {
                }
                column(ReportinclallVATentriesCaption;ReportinclallVATentriesCaptionLbl)
                {
                }
                column(RepinclonlyclosedVATentCaption;RepinclonlyclosedVATentCaptionLbl)
                {
                }
                column(TotalAmountCaption;TotalAmountCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcLineTotal("VAT Statement Line",TotalAmount,0);
                    if PrintInIntegers then
                      TotalAmount := ROUND(TotalAmount,1,'<');
                    if "Print with" = "print with"::"Opposite Sign" then
                      TotalAmount := -TotalAmount;
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

            trigger OnAfterGetRecord()
            begin
                CurrReport.PageNo := 1;
            end;

            trigger OnPreDataItem()
            begin
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
                    group("Statement Period")
                    {
                        Caption = 'Statement Period';
                        field(StartingDate;StartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';
                        }
                        field(EndingDate;EndDateReq)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';
                        }
                    }
                    field(Selection;Selection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Tax Entries';
                        OptionCaption = 'Open,Closed,Open and Closed';
                    }
                    field(PeriodSelection;PeriodSelection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Tax Entries';
                        OptionCaption = 'Before and Within Period,Within Period';
                    }
                    field(RoundToWholeNumbers;PrintInIntegers)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Round to Whole Numbers';
                    }
                    field(ShowAmtInAddCurrency;UseAmtsInAddCurr)
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
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if EndDateReq = 0D then
          EndDate := Dmy2date(31,12,9999)
        else
          EndDate := EndDateReq;
        VATStmtLine.SetRange("Date Filter",StartDate,EndDateReq);
        if PeriodSelection = Periodselection::"Before and Within Period" then
          Heading := Text000
        else
          Heading := Text004;
        Heading2 := StrSubstNo(Text005,StartDate,EndDateReq);
        VATStmtLineFilter := VATStmtLine.GetFilters;
    end;

    var
        Text000: label 'Tax entries before and within the period';
        Text003: label 'Amounts are in %1, rounded without decimals.';
        Text004: label 'Tax entries within the period';
        Text005: label 'Period: %1..%2';
        GLAcc: Record "G/L Account";
        VATEntry: Record "VAT Entry";
        GLSetup: Record "General Ledger Setup";
        VATStmtLine: Record "VAT Statement Line";
        Selection: Option Open,Closed,"Open and Closed";
        PeriodSelection: Option "Before and Within Period","Within Period";
        PrintInIntegers: Boolean;
        VATStmtLineFilter: Text;
        Heading: Text[50];
        Amount: Decimal;
        TotalAmount: Decimal;
        RowNo: array [6] of Code[10];
        ErrorText: Text[80];
        i: Integer;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        UseAmtsInAddCurr: Boolean;
        HeaderText: Text[50];
        EndDate: Date;
        StartDate: Date;
        EndDateReq: Date;
        Heading2: Text[50];
        AllamountsareinLbl: label 'All amounts are in';
        VATStmtCaptionLbl: label 'VAT Statement';
        CurrReportPageNoCaptionLbl: label 'Page';
        VATStmtTemplateCaptionLbl: label 'VAT Statement Template';
        VATStmtNameCaptionLbl: label 'VAT Statement Name';
        AmtsareinwholeLCYsCaptionLbl: label 'Amounts are in whole LCYs.';
        ReportinclallVATentriesCaptionLbl: label 'The report includes all tax entries.';
        RepinclonlyclosedVATentCaptionLbl: label 'The report includes only closed tax entries.';
        TotalAmountCaptionLbl: label 'Amount';


    procedure CalcLineTotal(VATStmtLine2: Record "VAT Statement Line";var TotalAmount: Decimal;Level: Integer): Boolean
    begin
        if Level = 0 then
          TotalAmount := 0;
        case VATStmtLine2.Type of
          VATStmtLine2.Type::"Account Totaling":
            begin
              GLAcc.SetFilter("No.",VATStmtLine2."Account Totaling");
              if EndDateReq = 0D then
                EndDate := Dmy2date(31,12,9999)
              else
                EndDate := EndDateReq;
              GLAcc.SetRange("Date Filter",StartDate,EndDate);
              Amount := 0;
              if GLAcc.Find('-') and (VATStmtLine2."Account Totaling" <> '') then
                repeat
                  GLAcc.CalcFields("Net Change","Additional-Currency Net Change");
                  Amount := ConditionalAdd(Amount,GLAcc."Net Change",GLAcc."Additional-Currency Net Change");
                until GLAcc.Next = 0;
              CalcTotalAmount(VATStmtLine2,TotalAmount);
            end;
          VATStmtLine2.Type::"VAT Entry Totaling":
            begin
              VATEntry.Reset;
              if VATEntry.SetCurrentkey(
                   Type,Closed,"VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date")
              then begin
                VATEntry.SetRange("VAT Bus. Posting Group",VATStmtLine2."VAT Bus. Posting Group");
                VATEntry.SetRange("VAT Prod. Posting Group",VATStmtLine2."VAT Prod. Posting Group");
              end else begin
                VATEntry.SetCurrentkey(
                  Type,Closed,"Tax Jurisdiction Code","Use Tax","Posting Date");
                VATEntry.SetRange("Tax Jurisdiction Code",VATStmtLine2."Tax Jurisdiction Code");
                VATEntry.SetRange("Use Tax",VATStmtLine2."Use Tax");
              end;
              VATEntry.SetRange(Type,VATStmtLine2."Gen. Posting Type");
              if (EndDateReq <> 0D) or (StartDate <> 0D) then
                if PeriodSelection = Periodselection::"Before and Within Period" then
                  VATEntry.SetRange("Posting Date",0D,EndDate)
                else
                  VATEntry.SetRange("Posting Date",StartDate,EndDate);
              case Selection of
                Selection::Open:
                  VATEntry.SetRange(Closed,false);
                Selection::Closed:
                  VATEntry.SetRange(Closed,true);
                else
                  VATEntry.SetRange(Closed);
              end;
              case VATStmtLine2."Amount Type" of
                VATStmtLine2."amount type"::Amount:
                  begin
                    VATEntry.CalcSums(Amount,"Additional-Currency Amount");
                    Amount := ConditionalAdd(0,VATEntry.Amount,VATEntry."Additional-Currency Amount");
                  end;
                VATStmtLine2."amount type"::Base:
                  begin
                    VATEntry.CalcSums(Base,"Additional-Currency Base");
                    Amount := ConditionalAdd(0,VATEntry.Base,VATEntry."Additional-Currency Base");
                  end;
                VATStmtLine2."amount type"::"Unrealized Amount":
                  begin
                    VATEntry.CalcSums("Remaining Unrealized Amount","Add.-Curr. Rem. Unreal. Amount");
                    Amount := ConditionalAdd(0,VATEntry."Remaining Unrealized Amount",VATEntry."Add.-Curr. Rem. Unreal. Amount");
                  end;
                VATStmtLine2."amount type"::"Unrealized Base":
                  begin
                    VATEntry.CalcSums("Remaining Unrealized Base","Add.-Curr. Rem. Unreal. Base");
                    Amount := ConditionalAdd(0,VATEntry."Remaining Unrealized Base",VATEntry."Add.-Curr. Rem. Unreal. Base");
                  end;
              end;
              CalcTotalAmount(VATStmtLine2,TotalAmount);
            end;
          VATStmtLine2.Type::"Row Totaling":
            begin
              if Level >= ArrayLen(RowNo) then
                exit(false);
              Level := Level + 1;
              RowNo[Level] := VATStmtLine2."Row No.";

              if VATStmtLine2."Row Totaling" = '' then
                exit(true);
              VATStmtLine2.SetRange("Statement Template Name",VATStmtLine2."Statement Template Name");
              VATStmtLine2.SetRange("Statement Name",VATStmtLine2."Statement Name");
              VATStmtLine2.SetFilter("Row No.",VATStmtLine2."Row Totaling");
              if VATStmtLine2.Find('-') then
                repeat
                  if not CalcLineTotal(VATStmtLine2,TotalAmount,Level) then begin
                    if Level > 1 then
                      exit(false);
                    for i := 1 to ArrayLen(RowNo) do
                      ErrorText := ErrorText + RowNo[i] + ' => ';
                    ErrorText := ErrorText + '...';
                    VATStmtLine2.FieldError("Row No.",ErrorText);
                  end;
                until VATStmtLine2.Next = 0;
            end;
          VATStmtLine2.Type::Description:
            ;
        end;

        exit(true);
    end;

    local procedure CalcTotalAmount(VATStmtLine2: Record "VAT Statement Line";var TotalAmount: Decimal)
    begin
        if VATStmtLine2."Calculate with" = 1 then
          Amount := -Amount;
        if PrintInIntegers and VATStmtLine2.Print then
          Amount := ROUND(Amount,1,'<');
        TotalAmount := TotalAmount + Amount;
    end;


    procedure InitializeRequest(var NewVATStmtName: Record "VAT Statement Name";var NewVATStatementLine: Record "VAT Statement Line";NewSelection: Option Open,Closed,"Open and Closed";NewPeriodSelection: Option "Before and Within Period","Within Period";NewPrintInIntegers: Boolean;NewUseAmtsInAddCurr: Boolean)
    begin
        "VAT Statement Name".Copy(NewVATStmtName);
        "VAT Statement Line".Copy(NewVATStatementLine);
        Selection := NewSelection;
        PeriodSelection := NewPeriodSelection;
        PrintInIntegers := NewPrintInIntegers;
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
        if NewVATStatementLine.GetFilter("Date Filter") <> '' then begin
          StartDate := NewVATStatementLine.GetRangeMin("Date Filter");
          EndDateReq := NewVATStatementLine.GetRangemax("Date Filter");
          EndDate := EndDateReq;
        end else begin
          StartDate := 0D;
          EndDateReq := 0D;
          EndDate := Dmy2date(31,12,9999);
        end;
    end;

    local procedure ConditionalAdd(Amount: Decimal;AmountToAdd: Decimal;AddCurrAmountToAdd: Decimal): Decimal
    begin
        if UseAmtsInAddCurr then
          exit(Amount + AddCurrAmountToAdd);

        exit(Amount + AmountToAdd);
    end;

    local procedure GetCurrency(): Code[10]
    begin
        if UseAmtsInAddCurr then
          exit(GLSetup."Additional Reporting Currency");

        exit('');
    end;
}

