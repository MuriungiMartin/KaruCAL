#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 104 "Customer - Detail Trial Bal."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer - Detail Trial Bal..rdlc';
    Caption = 'Customer - Detail Trial Bal.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name","Customer Posting Group","Date Filter";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(TodayFormatted;Format(Today))
            {
            }
            column(PeriodCustDatetFilter;StrSubstNo(Text000,CustDateFilter))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(PrintAmountsInLCY;PrintAmountsInLCY)
            {
            }
            column(ExcludeBalanceOnly;ExcludeBalanceOnly)
            {
            }
            column(CustFilterCaption;TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter;CustFilter)
            {
            }
            column(AmountCaption;AmountCaption)
            {
            }
            column(RemainingAmtCaption;RemainingAmtCaption)
            {
            }
            column(No_Cust;"No.")
            {
            }
            column(Name_Cust;Name)
            {
            }
            column(PhoneNo_Cust;"Phone No.")
            {
                IncludeCaption = true;
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(StartBalanceLCY;StartBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(StartBalAdjLCY;StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceLCY;CustBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(CustLedgerEntryAmtLCY;"Cust. Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding)
            {
                AutoFormatType = 1;
            }
            column(StartBalanceLCYAdjLCY;StartBalanceLCY + StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(StrtBalLCYCustLedgEntryAmt;StartBalanceLCY + "Cust. Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding)
            {
                AutoFormatType = 1;
            }
            column(CustDetailTrialBalCaption;CustDetailTrialBalCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(AllAmtsLCYCaption;AllAmtsLCYCaptionLbl)
            {
            }
            column(RepInclCustsBalCptn;RepInclCustsBalCptnLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            column(DueDateCaption;DueDateCaptionLbl)
            {
            }
            column(BalanceLCYCaption;BalanceLCYCaptionLbl)
            {
            }
            column(AdjOpeningBalCaption;AdjOpeningBalCaptionLbl)
            {
            }
            column(BeforePeriodCaption;BeforePeriodCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(OpeningBalCaption;OpeningBalCaptionLbl)
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Customer No."=field("No."),"Posting Date"=field("Date Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Date Filter"=field("Date Filter");
                DataItemTableView = sorting("Customer No.","Posting Date");
                column(ReportForNavId_8503; 8503)
                {
                }
                column(PostDate_CustLedgEntry;Format("Posting Date"))
                {
                }
                column(DocType_CustLedgEntry;"Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocNo_CustLedgEntry;"Document No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_CustLedgEntry;Description)
                {
                    IncludeCaption = true;
                }
                column(CustAmount;CustAmount)
                {
                    AutoFormatExpression = CustCurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustRemainAmount;CustRemainAmount)
                {
                    AutoFormatExpression = CustCurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustEntryDueDate;Format(CustEntryDueDate))
                {
                }
                column(EntryNo_CustLedgEntry;"Entry No.")
                {
                    IncludeCaption = true;
                }
                column(CustCurrencyCode;CustCurrencyCode)
                {
                }
                column(CustBalanceLCY1;CustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No."=field("Entry No.");
                    DataItemTableView = sorting("Cust. Ledger Entry No.","Entry Type","Posting Date") where("Entry Type"=filter("Appln. Rounding"|"Correction of Remaining Amount"));
                    column(ReportForNavId_6942; 6942)
                    {
                    }
                    column(EntryType_DtldCustLedgEntry;Format("Entry Type"))
                    {
                    }
                    column(Correction;Correction)
                    {
                        AutoFormatType = 1;
                    }
                    column(CustBalanceLCY2;CustBalanceLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(ApplicationRounding;ApplicationRounding)
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        case "Entry Type" of
                          "entry type"::"Appln. Rounding":
                            ApplicationRounding := ApplicationRounding + "Amount (LCY)";
                          "entry type"::"Correction of Remaining Amount":
                            Correction := Correction + "Amount (LCY)";
                        end;
                        CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date",CustDateFilter);
                        Correction := 0;
                        ApplicationRounding := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields(Amount,"Remaining Amount","Amount (LCY)","Remaining Amt. (LCY)");

                    CustLedgEntryExists := true;
                    if PrintAmountsInLCY then begin
                      CustAmount := "Amount (LCY)";
                      CustRemainAmount := "Remaining Amt. (LCY)";
                      CustCurrencyCode := '';
                    end else begin
                      CustAmount := Amount;
                      CustRemainAmount := "Remaining Amount";
                      CustCurrencyCode := "Currency Code";
                    end;
                    CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    if ("Document Type" = "document type"::Payment) or ("Document Type" = "document type"::Refund) then
                      CustEntryDueDate := 0D
                    else
                      CustEntryDueDate := "Due Date";
                end;

                trigger OnPreDataItem()
                begin
                    CustLedgEntryExists := false;
                    CurrReport.CreateTotals(CustAmount,"Amount (LCY)");
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(Name1_Cust;Customer.Name)
                {
                }
                column(CustBalanceLCY4;CustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(StartBalanceLCY2;StartBalanceLCY)
                {
                }
                column(StartBalAdjLCY2;StartBalAdjLCY)
                {
                }
                column(CustBalStBalStBalAdjLCY;CustBalanceLCY - StartBalanceLCY - StartBalAdjLCY)
                {
                    AutoFormatType = 1;
                }

                trigger OnAfterGetRecord()
                begin
                    if not CustLedgEntryExists and ((StartBalanceLCY = 0) or ExcludeBalanceOnly) then begin
                      StartBalanceLCY := 0;
                      CurrReport.Skip;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PrintOnlyOnePerPage then
                  PageGroupNo := PageGroupNo + 1;

                StartBalanceLCY := 0;
                StartBalAdjLCY := 0;
                if CustDateFilter <> '' then begin
                  if GetRangeMin("Date Filter") <> 0D then begin
                    SetRange("Date Filter",0D,GetRangeMin("Date Filter") - 1);
                    CalcFields("Net Change (LCY)");
                    StartBalanceLCY := "Net Change (LCY)";
                  end;
                  SetFilter("Date Filter",CustDateFilter);
                  CalcFields("Net Change (LCY)");
                  StartBalAdjLCY := "Net Change (LCY)";
                  CustLedgEntry.SetCurrentkey("Customer No.","Posting Date");
                  CustLedgEntry.SetRange("Customer No.","No.");
                  CustLedgEntry.SetFilter("Posting Date",CustDateFilter);
                  if CustLedgEntry.Find('-') then
                    repeat
                      CustLedgEntry.SetFilter("Date Filter",CustDateFilter);
                      CustLedgEntry.CalcFields("Amount (LCY)");
                      StartBalAdjLCY := StartBalAdjLCY - CustLedgEntry."Amount (LCY)";
                      "Detailed Cust. Ledg. Entry".SetCurrentkey("Cust. Ledger Entry No.","Entry Type","Posting Date");
                      "Detailed Cust. Ledg. Entry".SetRange("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
                      "Detailed Cust. Ledg. Entry".SetFilter("Entry Type",'%1|%2',
                        "Detailed Cust. Ledg. Entry"."entry type"::"Correction of Remaining Amount",
                        "Detailed Cust. Ledg. Entry"."entry type"::"Appln. Rounding");
                      "Detailed Cust. Ledg. Entry".SetFilter("Posting Date",CustDateFilter);
                      if "Detailed Cust. Ledg. Entry".Find('-') then
                        repeat
                          StartBalAdjLCY := StartBalAdjLCY - "Detailed Cust. Ledg. Entry"."Amount (LCY)";
                        until "Detailed Cust. Ledg. Entry".Next = 0;
                      "Detailed Cust. Ledg. Entry".Reset;
                    until CustLedgEntry.Next = 0;
                end;
                CurrReport.PrintonlyIfDetail := ExcludeBalanceOnly or (StartBalanceLCY = 0);
                CustBalanceLCY := StartBalanceLCY + StartBalAdjLCY
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals("Cust. Ledger Entry"."Amount (LCY)",StartBalanceLCY,StartBalAdjLCY,Correction,ApplicationRounding);
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
                    field(ShowAmountsInLCY;PrintAmountsInLCY)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Amounts in $';
                        ToolTip = 'Specifies if the reported amounts are shown in the local currency.';
                    }
                    field(NewPageperCustomer;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Page per Customer';
                        ToolTip = 'Specifies if each customer''s information is printed on a new page if you have chosen two or more customers to be included in the report.';
                    }
                    field(ExcludeCustHaveaBalanceOnly;ExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Exclude Customers That Have a Balance Only';
                        MultiLine = true;
                        ToolTip = 'Specifies if you do not want the report to include entries for customers that have a balance but do not have a net change during the selected time period.';
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
    var
        CaptionManagement: Codeunit "Caption Class";
    begin
        CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);
        CustDateFilter := Customer.GetFilter("Date Filter");
        with "Cust. Ledger Entry" do
          if PrintAmountsInLCY then begin
            AmountCaption := FieldCaption("Amount (LCY)");
            RemainingAmtCaption := FieldCaption("Remaining Amt. (LCY)");
          end else begin
            AmountCaption := FieldCaption(Amount);
            RemainingAmtCaption := FieldCaption("Remaining Amount");
          end;
    end;

    var
        Text000: label 'Period: %1';
        CustLedgEntry: Record "Cust. Ledger Entry";
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        CustFilter: Text;
        CustDateFilter: Text;
        AmountCaption: Text[80];
        RemainingAmtCaption: Text[30];
        CustAmount: Decimal;
        CustRemainAmount: Decimal;
        CustBalanceLCY: Decimal;
        CustCurrencyCode: Code[10];
        CustEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        StartBalAdjLCY: Decimal;
        Correction: Decimal;
        ApplicationRounding: Decimal;
        CustLedgEntryExists: Boolean;
        PageGroupNo: Integer;
        CustDetailTrialBalCaptionLbl: label 'Customer - Detail Trial Bal.';
        PageNoCaptionLbl: label 'Page';
        AllAmtsLCYCaptionLbl: label 'All amounts are in $';
        RepInclCustsBalCptnLbl: label 'This report also includes customers that only have balances.';
        PostingDateCaptionLbl: label 'Posting Date';
        DueDateCaptionLbl: label 'Due Date';
        BalanceLCYCaptionLbl: label 'Balance ($)';
        AdjOpeningBalCaptionLbl: label 'Adj. of Opening Balance';
        BeforePeriodCaptionLbl: label 'Total ($) Before Period';
        TotalCaptionLbl: label 'Total ($)';
        OpeningBalCaptionLbl: label 'Total Adj. of Opening Balance';


    procedure InitializeRequest(ShowAmountInLCY: Boolean;SetPrintOnlyOnePerPage: Boolean;SetExcludeBalanceOnly: Boolean)
    begin
        PrintOnlyOnePerPage := SetPrintOnlyOnePerPage;
        PrintAmountsInLCY := ShowAmountInLCY;
        ExcludeBalanceOnly := SetExcludeBalanceOnly;
    end;
}

