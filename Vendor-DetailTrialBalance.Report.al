#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 304 "Vendor - Detail Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor - Detail Trial Balance.rdlc';
    Caption = 'Vendor - Detail Trial Balance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name","Vendor Posting Group","Date Filter","Is PartTime Claim";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(VendDatetFilterPeriod;StrSubstNo(Text000,VendDateFilter))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(VendorTblCapVendFltr;TableCaption + ': ' + VendFilter)
            {
            }
            column(VendFilter;VendFilter)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(PrintAmountsInLCY;PrintAmountsInLCY)
            {
            }
            column(ExcludeBalanceOnly;ExcludeBalanceOnly)
            {
            }
            column(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
            {
            }
            column(AmountCaption;AmountCaption)
            {
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
            }
            column(RemainingAmtCaption;RemainingAmtCaption)
            {
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
            }
            column(No_Vendor;"No.")
            {
            }
            column(Name_Vendor;Name)
            {
            }
            column(PhoneNo_Vendor;"Phone No.")
            {
                IncludeCaption = true;
            }
            column(StartBalanceLCY;StartBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(StartBalAdjLCY;StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(VendBalanceLCY;VendBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(StrtBalLCYStartBalAdjLCY;StartBalanceLCY + StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(VendDetailTrialBalCap;VendDetailTrialBalCapLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(AllamountsareinLCYCaption;AllamountsareinLCYCaptionLbl)
            {
            }
            column(ReportIncludesvendorshavebalanceCaption;ReportIncludesvendorshavebalanceCaptionLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            column(BalanceLCYCaption;BalanceLCYCaptionLbl)
            {
            }
            column(DueDateCaption;DueDateCaptionLbl)
            {
            }
            column(AdjofOpeningBalanceCaption;AdjofOpeningBalanceCaptionLbl)
            {
            }
            column(TotalLCYCaption;TotalLCYCaptionLbl)
            {
            }
            column(TotalAdjofOpenBalCaption;TotalAdjofOpenBalCaptionLbl)
            {
            }
            column(TotalLCYBeforePeriodCaption;TotalLCYBeforePeriodCaptionLbl)
            {
            }
            dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No."=field("No."),"Posting Date"=field("Date Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter"),"Date Filter"=field("Date Filter");
                DataItemTableView = sorting("Vendor No.","Posting Date");
                RequestFilterFields = "Is a Medical Claim";
                column(ReportForNavId_4114; 4114)
                {
                }
                column(PostingDate_VendLedgEntry;Format("Posting Date"))
                {
                }
                column(DocType_VendLedgEntry;"Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocNo_VendLedgerEntry;"Document No.")
                {
                    IncludeCaption = true;
                }
                column(ExternalDocNo;"External Document No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_VendLedgerEntry;Description)
                {
                    IncludeCaption = true;
                }
                column(VendAmount;VendAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendBalLCY2;VendBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(VendRemainAmount;VendRemainAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendEntryDueDate;Format(VendEntryDueDate))
                {
                }
                column(EntryNo_VendorLedgerEntry;"Entry No.")
                {
                    IncludeCaption = true;
                }
                column(VendCurrencyCode;VendCurrencyCode)
                {
                }
                column(PaymentRef;"Vendor Ledger Entry"."Payment Ref")
                {
                }
                dataitem("Detailed Vendor Ledg. Entry";"Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No."=field("Entry No.");
                    DataItemTableView = sorting("Vendor Ledger Entry No.","Entry Type","Posting Date") where("Entry Type"=const("Correction of Remaining Amount"));
                    column(ReportForNavId_2149; 2149)
                    {
                    }
                    column(EntryTyp_DetVendLedgEntry;"Entry Type")
                    {
                    }
                    column(Correction;Correction)
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Detailed Vendor Ledg. Entry2".CalcFields("Medical Claim");
                        Correction := Correction + "Amount (LCY)";
                        VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    end;

                    trigger OnPostDataItem()
                    begin
                        SumCorrections := SumCorrections + Correction;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date", VendDateFilter);
                        //added
                        SetFilter("Medical Claim", isMedicalfilter);
                    end;
                }
                dataitem("Detailed Vendor Ledg. Entry2";"Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No."=field("Entry No.");
                    DataItemTableView = sorting("Vendor Ledger Entry No.","Entry Type","Posting Date") where("Entry Type"=const("Appln. Rounding"));
                    column(ReportForNavId_4103; 4103)
                    {
                    }
                    column(Entry_DetVendLedgEntry2;"Entry Type")
                    {
                    }
                    column(VendBalanceLCY3;VendBalanceLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(ApplicationRounding;ApplicationRounding)
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Detailed Vendor Ledg. Entry2".CalcFields("Medical Claim");
                        ApplicationRounding := ApplicationRounding + "Amount (LCY)";
                        VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date",VendDateFilter);
                        //added
                        SetFilter("Medical Claim", isMedicalfilter);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields(Amount,"Remaining Amount","Amount (LCY)","Remaining Amt. (LCY)","Medical Claim");
                    "Vendor Ledger Entry".CalcFields("Medical Claim");
                    VendLedgEntryExists := true;
                    if PrintAmountsInLCY then begin
                      VendAmount := "Amount (LCY)";
                      VendRemainAmount := "Remaining Amt. (LCY)";
                      VendCurrencyCode := '';
                    end else begin
                      VendAmount := Amount;
                      VendRemainAmount := "Remaining Amount";
                      VendCurrencyCode := "Currency Code";
                    end;
                    VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    if ("Document Type" = "document type"::Payment) or ("Document Type" = "document type"::Refund) then
                      VendEntryDueDate := 0D
                    else
                      VendEntryDueDate := "Due Date";
                end;

                trigger OnPreDataItem()
                begin
                    VendLedgEntryExists := false;
                    CurrReport.CreateTotals(VendAmount,"Amount (LCY)");
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(VendBalanceLCY4;VendBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(StartBalAdjLCY1;StartBalAdjLCY)
                {
                }
                column(StartBalanceLCY1;StartBalanceLCY)
                {
                }
                column(VendBalStrtBalStrtBalAdj;VendBalanceLCY - StartBalanceLCY - StartBalAdjLCY)
                {
                    AutoFormatType = 1;
                }

                trigger OnAfterGetRecord()
                begin
                    if not VendLedgEntryExists and ((StartBalanceLCY = 0) or ExcludeBalanceOnly) then begin
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
                if VendDateFilter <> '' then begin
                  if GetRangeMin("Date Filter") <> 0D then begin
                    SetRange("Date Filter",0D,GetRangeMin("Date Filter") - 1);
                    CalcFields("Net Change (LCY)");
                    StartBalanceLCY := -"Net Change (LCY)";
                  end;
                  SetFilter("Date Filter",VendDateFilter);
                  //added
                  SetFilter("Is PartTime Claim" ,isParttimeFilter);

                  CalcFields("Net Change (LCY)");
                  StartBalAdjLCY := -"Net Change (LCY)";
                  VendorLedgerEntry.SetCurrentkey("Vendor No.","Posting Date");
                  VendorLedgerEntry.SetRange("Vendor No.","No.");
                  VendorLedgerEntry.SetFilter("Posting Date",VendDateFilter);
                  VendorLedgerEntry.SetFilter("PartTime Claim",isParttimeFilter);
                  if VendorLedgerEntry.Find('-') then
                    repeat
                      //Medical Report
                      VendorLedgerEntry.SetFilter("Date Filter",VendDateFilter);
                      VendorLedgerEntry.SetFilter("Is a Medical Claim",isMedicalfilter);
                      VendorLedgerEntry.CalcFields("Amount (LCY)");
                      StartBalAdjLCY := StartBalAdjLCY - VendorLedgerEntry."Amount (LCY)";
                      "Detailed Vendor Ledg. Entry".SetCurrentkey("Vendor Ledger Entry No.","Entry Type","Posting Date");
                      "Detailed Vendor Ledg. Entry".SetRange("Vendor Ledger Entry No.",VendorLedgerEntry."Entry No.");
                      "Detailed Vendor Ledg. Entry".SetFilter("Entry Type",'%1|%2',
                        "Detailed Vendor Ledg. Entry"."entry type"::"Correction of Remaining Amount",
                        "Detailed Vendor Ledg. Entry"."entry type"::"Appln. Rounding");
                      "Detailed Vendor Ledg. Entry".SetFilter("Posting Date",VendDateFilter);
                      //Added
                      "Detailed Vendor Ledg. Entry".SetFilter("PartTime Claim" ,isParttimeFilter);

                      if "Detailed Vendor Ledg. Entry".Find('-') then
                        repeat
                          StartBalAdjLCY := StartBalAdjLCY - "Detailed Vendor Ledg. Entry"."Amount (LCY)";
                        until "Detailed Vendor Ledg. Entry".Next = 0;
                      "Detailed Vendor Ledg. Entry".Reset;
                    until VendorLedgerEntry.Next = 0;
                end;
                CurrReport.PrintonlyIfDetail := ExcludeBalanceOnly or (StartBalanceLCY = 0);
                VendBalanceLCY := StartBalanceLCY + StartBalAdjLCY;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                SumCorrections := 0;

                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals("Vendor Ledger Entry"."Amount (LCY)",StartBalanceLCY,StartBalAdjLCY,Correction,ApplicationRounding);
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
                    field(PrintAmountsInLCY;PrintAmountsInLCY)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in LCY';
                    }
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Vendor';
                    }
                    field(ExcludeBalanceOnly;ExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exclude Vendors That Have A Balance Only';
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
        VendFilter := Vendor.GetFilters;
        isMedicalfilter:= Vendor.GetFilter("Is a Medical Claim");
        VendDateFilter := Vendor.GetFilter("Date Filter");

        with "Vendor Ledger Entry" do
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
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendFilter: Text[250];
        VendDateFilter: Text[30];
        VendAmount: Decimal;
        VendRemainAmount: Decimal;
        VendBalanceLCY: Decimal;
        VendEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        StartBalAdjLCY: Decimal;
        Correction: Decimal;
        ApplicationRounding: Decimal;
        ExcludeBalanceOnly: Boolean;
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        VendLedgEntryExists: Boolean;
        AmountCaption: Text[30];
        RemainingAmtCaption: Text[30];
        VendCurrencyCode: Code[10];
        PageGroupNo: Integer;
        SumCorrections: Decimal;
        VendDetailTrialBalCapLbl: label 'Vendor - Detail Trial Balance';
        PageCaptionLbl: label 'Page';
        AllamountsareinLCYCaptionLbl: label 'All amounts are in LCY';
        ReportIncludesvendorshavebalanceCaptionLbl: label 'This report also includes vendors that only have balances.';
        PostingDateCaptionLbl: label 'Posting Date';
        BalanceLCYCaptionLbl: label 'Balance (LCY)';
        DueDateCaptionLbl: label 'Due Date';
        AdjofOpeningBalanceCaptionLbl: label 'Adj. of Opening Balance';
        TotalLCYCaptionLbl: label 'Total (LCY)';
        TotalAdjofOpenBalCaptionLbl: label 'Total Adj. of Opening Balance';
        TotalLCYBeforePeriodCaptionLbl: label 'Total (LCY) Before Period';
        UnitsName: Text;
        Vend: Integer;
        isMedicalfilter: Text;
        isParttimeFilter: Text;


    procedure InitializeRequest(NewPrintAmountsInLCY: Boolean;NewPrintOnlyOnePerPage: Boolean;NewExcludeBalanceOnly: Boolean)
    begin
        PrintAmountsInLCY := NewPrintAmountsInLCY;
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        ExcludeBalanceOnly := NewExcludeBalanceOnly;
    end;
}

