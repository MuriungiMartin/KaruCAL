#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10085 "Aged Accounts Payable"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Aged Accounts Payable.rdlc';
    Caption = 'Aged Accounts Payable';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Vendor Posting Group","Payment Terms Code","Purchaser Code";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(Aged_Accounts_Payable_;'Aged Accounts Payable')
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
            column(DateTitle;DateTitle)
            {
            }
            column(Document_Number_is______Vendor_Ledger_Entry__FIELDCAPTION__External_Document_No___;'Document Number is ' + "Vendor Ledger Entry".FieldCaption("External Document No."))
            {
            }
            column(Vendor_TABLECAPTION__________FilterString;Vendor.TableCaption + ': ' + FilterString)
            {
            }
            column(ColumnHeadHead;ColumnHeadHead)
            {
            }
            column(ColumnHead_1_;ColumnHead[1])
            {
            }
            column(ColumnHead_2_;ColumnHead[2])
            {
            }
            column(ColumnHead_3_;ColumnHead[3])
            {
            }
            column(ColumnHead_4_;ColumnHead[4])
            {
            }
            column(PrintToExcel;PrintToExcel)
            {
            }
            column(PrintDetail;PrintDetail)
            {
            }
            column(PrintAmountsInLocal;PrintAmountsInLocal)
            {
            }
            column(ShowAllForOverdue;ShowAllForOverdue)
            {
            }
            column(UseExternalDocNo;UseExternalDocNo)
            {
            }
            column(FilterString;FilterString)
            {
            }
            column(ColumnHeadHead_Control21;ColumnHeadHead)
            {
            }
            column(ShortDateTitle;ShortDateTitle)
            {
            }
            column(ColumnHead_1__Control26;ColumnHead[1])
            {
            }
            column(ColumnHead_2__Control27;ColumnHead[2])
            {
            }
            column(ColumnHead_3__Control28;ColumnHead[3])
            {
            }
            column(ColumnHead_4__Control29;ColumnHead[4])
            {
            }
            column(Vendor__No__;"No.")
            {
            }
            column(Vendor_Name;Name)
            {
            }
            column(Vendor__Phone_No__;"Phone No.")
            {
            }
            column(Vendor_Contact;Contact)
            {
            }
            column(BlockedDescription;BlockedDescription)
            {
            }
            column(TotalBalanceDue__;-"TotalBalanceDue$")
            {
            }
            column(BalanceDue___1_;-"BalanceDue$"[1])
            {
            }
            column(BalanceDue___2_;-"BalanceDue$"[2])
            {
            }
            column(BalanceDue___3_;-"BalanceDue$"[3])
            {
            }
            column(BalanceDue___4_;-"BalanceDue$"[4])
            {
            }
            column(PercentString_1_;PercentString[1])
            {
            }
            column(PercentString_2_;PercentString[2])
            {
            }
            column(PercentString_3_;PercentString[3])
            {
            }
            column(PercentString_4_;PercentString[4])
            {
            }
            column(TotalBalanceDue___Control91;-"TotalBalanceDue$")
            {
            }
            column(BalanceDue___1__Control92;-"BalanceDue$"[1])
            {
            }
            column(BalanceDue___2__Control93;-"BalanceDue$"[2])
            {
            }
            column(BalanceDue___3__Control94;-"BalanceDue$"[3])
            {
            }
            column(PercentString_1__Control95;PercentString[1])
            {
            }
            column(PercentString_2__Control96;PercentString[2])
            {
            }
            column(PercentString_3__Control97;PercentString[3])
            {
            }
            column(BalanceDue___4__Control98;-"BalanceDue$"[4])
            {
            }
            column(PercentString_4__Control99;PercentString[4])
            {
            }
            column(Vendor_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Vendor_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Aged_byCaption;Aged_byCaptionLbl)
            {
            }
            column(Control11Caption;CaptionClassTranslate('101,1,' + Text021))
            {
            }
            column(Vendor__No__Caption;FieldCaption("No."))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(AmountDueToPrint_Control74Caption;AmountDueToPrint_Control74CaptionLbl)
            {
            }
            column(Vendor__No__Caption_Control22;FieldCaption("No."))
            {
            }
            column(Vendor_NameCaption;FieldCaption(Name))
            {
            }
            column(DocNoCaption;DocNoCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(AmountDueToPrint_Control63Caption;AmountDueToPrint_Control63CaptionLbl)
            {
            }
            column(DocumentCaption;DocumentCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry___Currency_Code_Caption;Vendor_Ledger_Entry___Currency_Code_CaptionLbl)
            {
            }
            column(Phone_Caption;Phone_CaptionLbl)
            {
            }
            column(Contact_Caption;Contact_CaptionLbl)
            {
            }
            column(Control1020000Caption;CaptionClassTranslate(GetCurrencyCaptionCode("Currency Code")))
            {
            }
            column(Control47Caption;CaptionClassTranslate('101,0,' + Text022))
            {
            }
            column(Control48Caption;CaptionClassTranslate('101,0,' + Text022))
            {
            }
            column(GrandTotalBalanceDue_;-GrandTotalBalanceDue)
            {
            }
            column(GrandBalanceDue_1_;-GrandBalanceDue[1])
            {
            }
            column(GrandBalanceDue_2_;-GrandBalanceDue[2])
            {
            }
            column(GrandBalanceDue_3_;-GrandBalanceDue[3])
            {
            }
            column(GrandBalanceDue_4_;-GrandBalanceDue[4])
            {
            }
            dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No."=field("No."),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Vendor No.",Positive,"Due Date");
                column(ReportForNavId_4114; 4114)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SetRange("Date Filter",0D,PeriodEndingDate[1]);
                    CalcFields("Remaining Amount", Amount);
                    if Amount <> 0 then
                      InsertTemp("Vendor Ledger Entry");
                    CurrReport.Skip;    // this fools the system into thinking that no details "printed"...yet
                end;

                trigger OnPreDataItem()
                begin
                    // Find ledger entries which are posted before the date of the aging.
                    SetRange("Posting Date",0D,PeriodEndingDate[1]);

                    if (Format(ShowOnlyOverDueBy) <> '') and not ShowAllForOverdue then
                      SetRange("Due Date",0D,CalculatedDate);
                end;
            }
            dataitem(Totals;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_9725; 9725)
                {
                }
                column(AmountDueToPrint;-AmountDueToPrint)
                {
                }
                column(AmountDueToPrint1;-AmountDue[1])
                {
                }
                column(AmountDue_1_;-AmountDue[1])
                {
                }
                column(AmountDue_2_;-AmountDue[2])
                {
                }
                column(AmountDue_3_;-AmountDue[3])
                {
                }
                column(AmountDue_4_;-AmountDue[4])
                {
                }
                column(AgingDate;AgingDate)
                {
                }
                column(Vendor_Ledger_Entry__Description;"Vendor Ledger Entry".Description)
                {
                }
                column(Vendor_Ledger_Entry___Document_Type_;"Vendor Ledger Entry"."Document Type")
                {
                }
                column(DocNo;DocNo)
                {
                }
                column(AmountDueToPrint_Control63;-AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control64;-AmountDue[1])
                {
                }
                column(AmountDue_2__Control65;-AmountDue[2])
                {
                }
                column(AmountDue_3__Control66;-AmountDue[3])
                {
                }
                column(AmountDue_4__Control67;-AmountDue[4])
                {
                }
                column(Vendor_Ledger_Entry___Currency_Code_;"Vendor Ledger Entry"."Currency Code")
                {
                }
                column(AmountDueToPrint_Control68;-AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control69;-AmountDue[1])
                {
                }
                column(AmountDue_2__Control70;-AmountDue[2])
                {
                }
                column(AmountDue_3__Control71;-AmountDue[3])
                {
                }
                column(AmountDue_4__Control72;-AmountDue[4])
                {
                }
                column(AmountDueToPrint_Control74;-AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control75;-AmountDue[1])
                {
                }
                column(AmountDue_2__Control76;-AmountDue[2])
                {
                }
                column(AmountDue_3__Control77;-AmountDue[3])
                {
                }
                column(AmountDue_4__Control78;-AmountDue[4])
                {
                }
                column(PercentString_1__Control5;PercentString[1])
                {
                }
                column(PercentString_2__Control6;PercentString[2])
                {
                }
                column(PercentString_3__Control7;PercentString[3])
                {
                }
                column(PercentString_4__Control8;PercentString[4])
                {
                }
                column(Vendor__No___Control80;Vendor."No.")
                {
                }
                column(AmountDueToPrint_Control81;-AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control82;-AmountDue[1])
                {
                }
                column(AmountDue_2__Control83;-AmountDue[2])
                {
                }
                column(AmountDue_3__Control84;-AmountDue[3])
                {
                }
                column(AmountDue_4__Control85;-AmountDue[4])
                {
                }
                column(PercentString_1__Control87;PercentString[1])
                {
                }
                column(PercentString_2__Control88;PercentString[2])
                {
                }
                column(PercentString_3__Control89;PercentString[3])
                {
                }
                column(PercentString_4__Control90;PercentString[4])
                {
                }
                column(Totals_Number;Number)
                {
                }
                column(Balance_ForwardCaption;Balance_ForwardCaptionLbl)
                {
                }
                column(Balance_to_Carry_ForwardCaption;Balance_to_Carry_ForwardCaptionLbl)
                {
                }
                column(Total_Amount_DueCaption;Total_Amount_DueCaptionLbl)
                {
                }
                column(Total_Amount_DueCaption_Control86;Total_Amount_DueCaption_Control86Lbl)
                {
                }
                column(Control1020001Caption;CaptionClassTranslate(GetCurrencyCaptionCode(Vendor."Currency Code")))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcPercents(AmountDueToPrint,AmountDue);

                    if Number = 1 then
                      TempVendLedgEntry.Find('-')
                    else
                      TempVendLedgEntry.Next;
                    TempVendLedgEntry.SetRange("Date Filter",0D,PeriodEndingDate[1]);
                    TempVendLedgEntry.CalcFields("Remaining Amount","Remaining Amt. (LCY)", Amount);
                     if TempVendLedgEntry.Amount = 0 then
                      CurrReport.Skip;
                    // IF TempVendLedgEntry.Amount = 0 THEN
                    //  CurrReport.SKIP;
                    if TempVendLedgEntry."Currency Code" <> '' then
                      TempVendLedgEntry."Remaining Amt. (LCY)" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            PeriodEndingDate[1],
                            TempVendLedgEntry."Currency Code",
                            '',
                            TempVendLedgEntry."Remaining Amount"));
                    if PrintAmountsInLocal then begin
                      //changed fro remaining Amount
                      TempVendLedgEntry.Amount :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            PeriodEndingDate[1],
                            TempVendLedgEntry."Currency Code",
                            Vendor."Currency Code",
                            TempVendLedgEntry.Amount),
                          Currency."Amount Rounding Precision");
                      //AmountDueToPrint := TempVendLedgEntry."Remaining Amount";
                      AmountDueToPrint := TempVendLedgEntry.Amount;
                    end else
                     //AmountDueToPrint := TempVendLedgEntry."Remaining Amt. (LCY)";
                      AmountDueToPrint := TempVendLedgEntry.Amount;
                    //  IF AmountDueToPrint>0 THEN
                    //    MESSAGE('%1', AmountDueToPrint);

                    case AgingMethod of
                      Agingmethod::"Due Date":
                        AgingDate := TempVendLedgEntry."Due Date";
                      Agingmethod::"Trans Date":
                        AgingDate := TempVendLedgEntry."Posting Date";
                      Agingmethod::"Document Date":
                        AgingDate := TempVendLedgEntry."Document Date";
                    end;
                    j := 0;
                    while AgingDate < PeriodEndingDate[j + 1] do
                      j := j + 1;
                    if j = 0 then
                      j := 1;

                    AmountDue[j] := AmountDueToPrint;
                    //"BalanceDue$"[j] := "BalanceDue$"[j] + TempVendLedgEntry."Remaining Amt. (LCY)";
                    "BalanceDue$"[j] := "BalanceDue$"[j] + TempVendLedgEntry.Amount;

                    "TotalBalanceDue$" := 0;
                    VendTotAmountDue[j] := VendTotAmountDue[j] + AmountDueToPrint;
                    VendTotAmountDueToPrint := VendTotAmountDueToPrint + AmountDueToPrint;

                    for j := 1 to 4 do
                      "TotalBalanceDue$" := "TotalBalanceDue$" + "BalanceDue$"[j];
                    CalcPercents("TotalBalanceDue$","BalanceDue$");

                    "Vendor Ledger Entry" := TempVendLedgEntry;
                    if UseExternalDocNo then
                      DocNo := "Vendor Ledger Entry"."External Document No."
                    else
                      DocNo := "Vendor Ledger Entry"."Document No.";

                    TotalNumberOfEntries -= 1;
                    if TotalNumberOfEntries = 0 then begin
                      for j := 1 to 4 do
                        GrandBalanceDue[j] += "BalanceDue$"[j];
                      GrandTotalBalanceDue += "TotalBalanceDue$";
                    end;

                    // Do NOT use the following fields in the sections:
                    // "Applied-To Doc. Type"
                    // "Applied-To Doc. No."
                    // Open
                    // "Paym. Disc. Taken"
                    // "Closed by Entry No."
                    // "Closed at Date"
                    // "Closed by Amount"

                    if PrintDetail and PrintToExcel then
                      MakeExcelDataBody;
                end;

                trigger OnPostDataItem()
                begin
                    if TempVendLedgEntry.Count > 0 then begin
                      for j := 1 to 4 do
                        AmountDue[j] := VendTotAmountDue[j];
                      AmountDueToPrint := VendTotAmountDueToPrint;
                      if not PrintDetail and PrintToExcel then
                        MakeExcelDataBody;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(AmountDueToPrint,AmountDue);
                    SetRange(Number,1,TempVendLedgEntry.Count);
                    TempVendLedgEntry.SetCurrentkey("Vendor No.","Posting Date");
                    Clear(VendTotAmountDue);
                    VendTotAmountDueToPrint := 0;
                    TotalNumberOfEntries := TempVendLedgEntry.Count;
                end;
            }

            trigger OnAfterGetRecord()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
            begin
                Clear("BalanceDue$");
                if PrintAmountsInLocal then begin
                  GetCurrencyRecord(Currency,"Currency Code");
                  CurrencyFactor := CurrExchRate.ExchangeRate(PeriodEndingDate[1],"Currency Code");
                end;

                if Blocked <> Blocked::" " then
                  BlockedDescription := StrSubstNo(Text003,Blocked)
                else
                  BlockedDescription := '';

                TempVendLedgEntry.DeleteAll;

                if Format(ShowOnlyOverDueBy) <> '' then
                  CalculatedDate := CalcDate(ShowOnlyOverDueBy,PeriodEndingDate[1]);

                if ShowAllForOverdue and (Format(ShowOnlyOverDueBy) <> '') then begin
                  VendLedgEntry.SetRange("Vendor No.","No.");
                  //VendLedgEntry.SETRANGE(Open,TRUE);
                  VendLedgEntry.SetRange("Due Date",0D,CalculatedDate);
                  if not VendLedgEntry.FindFirst then
                    CurrReport.Skip;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Clear("BalanceDue$");
                if PeriodEndingDate[1] = 0D then
                  PeriodEndingDate[1] := WorkDate;

                if PrintDetail then begin
                  SubTitle := Text004;
                end else
                  SubTitle := Text005;

                SubTitle := SubTitle + Text006 + ' ' + Format(PeriodEndingDate[1],0,4) + ')';

                if AgingMethod = Agingmethod::"Due Date" then begin
                  DateTitle := Text007;
                  ShortDateTitle := Text008;
                  ColumnHead[2] := Text009 + ' '
                    + Format(PeriodEndingDate[1] - PeriodEndingDate[3])
                    + ' ' + Text010;
                  ColumnHeadHead := ' ' + Text011 + ' ';
                end else
                  if AgingMethod = Agingmethod::"Trans Date" then begin
                    DateTitle := Text012;
                    ShortDateTitle := Text013;
                    ColumnHead[2] := Format(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                      + ' - '
                      + Format(PeriodEndingDate[1] - PeriodEndingDate[3])
                      + ' ' + Text010;
                    ColumnHeadHead := ' ' + Text014 + ' ';
                  end else begin
                    DateTitle := Text015;
                    ShortDateTitle := Text016;
                    ColumnHead[2] := Format(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                      + ' - '
                      + Format(PeriodEndingDate[1] - PeriodEndingDate[3])
                      + ' ' + Text010;
                    ColumnHeadHead := ' ' + Text017 + ' ';
                  end;

                ColumnHead[1] := Text018;
                ColumnHead[3] := Format(PeriodEndingDate[1] - PeriodEndingDate[3] + 1)
                  + ' - '
                  + Format(PeriodEndingDate[1] - PeriodEndingDate[4])
                  + ' ' + Text010;
                ColumnHead[4] := 'Over '
                  + Format(PeriodEndingDate[1] - PeriodEndingDate[4])
                  + ' ' + Text010;

                if PrintToExcel then
                  MakeExcelInfo;
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
                    field(AgedAsOf;PeriodEndingDate[1])
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Aged as of';
                        ToolTip = 'Specifies, in the MMDDYY format, the date that aging is based on. Transactions posted after this date will not be included in the report. The default is today''s date.';

                        trigger OnValidate()
                        begin
                            if PeriodEndingDate[1] = 0D then
                              PeriodEndingDate[1] := WorkDate;
                        end;
                    }
                    field(AgingMethod;AgingMethod)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Aging Method';
                        OptionCaption = 'Due Date,Trans Date,Document Date';
                        ToolTip = 'Specifies how aging is calculated. Due Date: Aging is calculated by the number of days that the transaction is overdue. Trans Date: Aging is calculated by the number of days since the transaction posting date. Document Date: Aging is calculated by the number of days since the document date.';
                    }
                    field(LengthOfAgingPeriods;PeriodCalculation)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Length of Aging Periods';
                        ToolTip = 'Specifies the length of each of the aging periods. For example, enter 30D to base aging on 30-day intervals.';

                        trigger OnValidate()
                        begin
                            if Format(PeriodCalculation) = '' then
                              Error(Text121);
                        end;
                    }
                    field(ShowOnlyOverDueBy;ShowOnlyOverDueBy)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show If Overdue By';
                        DateFormula = true;
                        ToolTip = 'Specifies the length of the period that you would like to use for the overdue balance.';

                        trigger OnValidate()
                        begin
                            if AgingMethod <> Agingmethod::"Due Date" then
                              Error(Text120);
                            if Format(ShowOnlyOverDueBy) = '' then
                              ShowAllForOverdue := false;
                        end;
                    }
                    field(ShowAllForOverdue;ShowAllForOverdue)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show All for Overdue By Vendor';
                        ToolTip = 'Specifies if you want to include the open vendor ledger entries that are overdue. These entries will be calculated based on the period in the Show if Overdue By field. If the Show All for Overdue by Vendor field is selected, then you must enter a date in the Aged by field and a date in the Show if Overdue By field to show overdue vendor ledger entries.';

                        trigger OnValidate()
                        begin
                            if AgingMethod <> Agingmethod::"Due Date" then
                              Error(Text120);
                            if ShowAllForOverdue and (Format(ShowOnlyOverDueBy) = '') then
                              Error(Text119);
                        end;
                    }
                    field(PrintAmountsInVendorsCurrency;PrintAmountsInLocal)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Amounts in Vendor''s Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if amounts are printed in the vendor''s currency. Clear the check box to print all amounts in US dollars.';

                        trigger OnValidate()
                        begin
                            if ShowAllForOverdue and (Format(ShowOnlyOverDueBy) = '') then
                              Error(Text119);
                        end;
                    }
                    field(PrintDetail;PrintDetail)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print Detail';
                        ToolTip = 'Specifies if individual transactions are included in the report. Clear the check box to include only totals.';
                    }
                    field(UseExternalDocNo;UseExternalDocNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Use External Doc. No.';
                        ToolTip = 'Specifies if you want to print the vendor''s document numbers, such as the invoice number, on all transactions. Clear this check box to print only internal document numbers.';
                    }
                    field(PrintToExcel;PrintToExcel)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print to Excel';
                        ToolTip = 'Specifies if you want to export the data to an Excel spreadsheet for additional analysis or formatting before printing.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodEndingDate[1] = 0D then begin
              PeriodEndingDate[1] := WorkDate;
              Evaluate(PeriodCalculation,'<30D>');
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if PrintToExcel then
          CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        if Format(PeriodCalculation) <> '' then
          Evaluate(PeriodCalculation,'-' + Format(PeriodCalculation));
        if Format(ShowOnlyOverDueBy) <> '' then
          Evaluate(ShowOnlyOverDueBy,'-' + Format(ShowOnlyOverDueBy));
        if AgingMethod = Agingmethod::"Due Date" then begin
          PeriodEndingDate[2] := PeriodEndingDate[1];
          for j := 3 to 4 do
            PeriodEndingDate[j] := CalcDate(PeriodCalculation,PeriodEndingDate[j - 1]);
        end else
          for j := 2 to 4 do
            PeriodEndingDate[j] := CalcDate(PeriodCalculation,PeriodEndingDate[j - 1]);

        PeriodEndingDate[5] := 0D;
        CompanyInformation.Get;
        GLSetup.Get;
        FilterString := Vendor.GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        TempVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        ExcelBuf: Record "Excel Buffer" temporary;
        PeriodCalculation: DateFormula;
        ShowOnlyOverDueBy: DateFormula;
        AgingMethod: Option "Due Date","Trans Date","Document Date";
        PrintAmountsInLocal: Boolean;
        PrintDetail: Boolean;
        PrintToExcel: Boolean;
        AmountDue: array [4] of Decimal;
        "BalanceDue$": array [4] of Decimal;
        ColumnHead: array [4] of Text[20];
        ColumnHeadHead: Text[59];
        PercentString: array [4] of Text[10];
        Percent: Decimal;
        "TotalBalanceDue$": Decimal;
        AmountDueToPrint: Decimal;
        BlockedDescription: Text[80];
        j: Integer;
        CurrencyFactor: Decimal;
        FilterString: Text;
        SubTitle: Text[88];
        DateTitle: Text[20];
        ShortDateTitle: Text[20];
        PeriodEndingDate: array [5] of Date;
        AgingDate: Date;
        UseExternalDocNo: Boolean;
        DocNo: Code[35];
        Text001: label 'Amounts are in %1';
        Text003: label '*** This vendor is blocked for %1 processing ***';
        Text004: label '(Detail';
        Text005: label '(Summary';
        Text006: label ', aged as of';
        Text007: label 'due date.';
        Text008: label 'Due Date';
        Text009: label 'Up To';
        Text010: label 'Days';
        Text011: label 'Aged Overdue Amounts';
        Text012: label 'transaction date.';
        Text013: label 'Trx Date';
        Text014: label 'Aged Vendor Balances';
        Text015: label 'document date.';
        Text016: label 'Doc Date';
        Text017: label 'Aged Vendor Balances';
        Text018: label 'Current';
        Text021: label 'Amounts are in the vendor''s local currency (report totals are in %1).';
        Text022: label 'Report Total Amount Due (%1)';
        Text101: label 'Data';
        Text102: label 'Aged Accounts Payable';
        Text103: label 'Company Name';
        Text104: label 'Report No.';
        Text105: label 'Report Name';
        Text106: label 'User ID';
        Text107: label 'Date / Time';
        Text108: label 'Vendor Filters';
        Text109: label 'Aged by';
        Text110: label 'Amounts are';
        Text111: label 'In our Functional Currency';
        Text112: label 'As indicated in Data';
        Text113: label 'Aged as of';
        Text114: label 'Aging Date (%1)';
        Text115: label 'Balance Due';
        Text116: label 'Document Currency';
        Text117: label 'Vendor Currency';
        ShowAllForOverdue: Boolean;
        Text119: label 'Show Only Overdue By Needs a Valid Date Formula';
        CalculatedDate: Date;
        Text120: label 'This option is only allowed for method Due Date';
        VendTotAmountDue: array [4] of Decimal;
        VendTotAmountDueToPrint: Decimal;
        Text121: label 'You must enter a period calculation in the Length of Aging Periods field.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Aged_byCaptionLbl: label 'Aged by';
        NameCaptionLbl: label 'Name';
        AmountDueToPrint_Control74CaptionLbl: label 'Balance Due';
        DocNoCaptionLbl: label 'Number';
        DescriptionCaptionLbl: label 'Description';
        TypeCaptionLbl: label 'Type';
        AmountDueToPrint_Control63CaptionLbl: label 'Balance Due';
        DocumentCaptionLbl: label 'Document';
        Vendor_Ledger_Entry___Currency_Code_CaptionLbl: label 'Doc. Curr.';
        Phone_CaptionLbl: label 'Phone:';
        Contact_CaptionLbl: label 'Contact:';
        Balance_ForwardCaptionLbl: label 'Balance Forward';
        Balance_to_Carry_ForwardCaptionLbl: label 'Balance to Carry Forward';
        Total_Amount_DueCaptionLbl: label 'Total Amount Due';
        Total_Amount_DueCaption_Control86Lbl: label 'Total Amount Due';
        GrandBalanceDue: array [4] of Decimal;
        GrandTotalBalanceDue: Decimal;
        TotalNumberOfEntries: Integer;

    local procedure InsertTemp(var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        with TempVendLedgEntry do begin
          if Get(VendLedgEntry."Entry No.") then
            exit;
          TempVendLedgEntry := VendLedgEntry;
          case AgingMethod of
            Agingmethod::"Due Date":
              "Posting Date" := "Due Date";
            Agingmethod::"Document Date":
              "Posting Date" := "Document Date";
          end;
          Insert;
        end;
    end;


    procedure CalcPercents(Total: Decimal;Amounts: array [4] of Decimal)
    var
        i: Integer;
        j: Integer;
    begin
        Clear(PercentString);
        if Total <> 0 then
          for i := 1 to 4 do begin
            Percent := Amounts[i] / Total * 100.0;
            if StrLen(Format(ROUND(Percent))) + 4 > MaxStrLen(PercentString[1]) then
              PercentString[i] := PadStr(PercentString[i],MaxStrLen(PercentString[i]),'*')
            else begin
              PercentString[i] := Format(ROUND(Percent));
              j := StrPos(PercentString[i],'.');
              if j = 0 then
                PercentString[i] := PercentString[i] + '.00'
              else
                if j = StrLen(PercentString[i]) - 1 then
                  PercentString[i] := PercentString[i] + '0';
              PercentString[i] := PercentString[i] + '%';
            end;
          end;
    end;

    local procedure GetCurrencyRecord(var Currency: Record Currency;CurrencyCode: Code[10])
    begin
        if CurrencyCode = '' then begin
          Clear(Currency);
          Currency.Description := GLSetup."LCY Code";
          Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        end else
          if Currency.Code <> CurrencyCode then
            Currency.Get(CurrencyCode);
    end;

    local procedure GetCurrencyCaptionCode(CurrencyCode: Code[10]): Text[80]
    begin
        if PrintAmountsInLocal then begin
          if CurrencyCode = '' then
            exit('101,1,' + Text001);

          GetCurrencyRecord(Currency,CurrencyCode);
          exit('101,4,' + StrSubstNo(Text001,Currency.Description));
        end;
        exit('');
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(Text103),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text105),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Format(Text102),false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text104),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Report::"Aged Accounts Payable",false,false,false,false,'',ExcelBuf."cell type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text106),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(UserId,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text107),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Today,false,false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.AddInfoColumn(Time,false,false,false,false,'',ExcelBuf."cell type"::Time);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text108),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(FilterString,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text109),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(DateTitle,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text113),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(PeriodEndingDate[1],false,false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text110),false,true,false,false,'',ExcelBuf."cell type"::Text);
        if PrintAmountsInLocal then
          ExcelBuf.AddInfoColumn(Format(Text112),false,false,false,false,'',ExcelBuf."cell type"::Text)
        else
          ExcelBuf.AddInfoColumn(Format(Text111),false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Vendor Ledger Entry".FieldCaption("Vendor No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Vendor.FieldCaption(Name),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        if PrintDetail then begin
          ExcelBuf.AddColumn(StrSubstNo(Text114,ShortDateTitle),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn("Vendor Ledger Entry".FieldCaption(Description),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn("Vendor Ledger Entry".FieldCaption("Document Type"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn("Vendor Ledger Entry".FieldCaption("Document No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        end;
        ExcelBuf.AddColumn(Format(Text115),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(ColumnHead[1],false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(ColumnHead[2],false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(ColumnHead[3],false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(ColumnHead[4],false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        if PrintAmountsInLocal then begin
          if PrintDetail then
            ExcelBuf.AddColumn(Format(Text116),false,'',true,false,true,'',ExcelBuf."cell type"::Text)
          else
            ExcelBuf.AddColumn(Format(Text117),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        end;
    end;

    local procedure MakeExcelDataBody()
    var
        CurrencyCodeToPrint: Code[20];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Vendor."No.",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Vendor.Name,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        if PrintDetail then begin
          ExcelBuf.AddColumn(AgingDate,false,'',false,false,false,'',ExcelBuf."cell type"::Date);
          ExcelBuf.AddColumn("Vendor Ledger Entry".Description,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn(Format("Vendor Ledger Entry"."Document Type"),false,'',false,false,false,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn(DocNo,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        end;
        //ExcelBuf.AddColumn(-AmountDue[0],FALSE,'',FALSE,FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-AmountDueToPrint,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(-AmountDue[1],false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(-AmountDue[2],false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(-AmountDue[3],false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(-AmountDue[4],false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        if PrintAmountsInLocal then begin
          if PrintDetail then
            CurrencyCodeToPrint := "Vendor Ledger Entry"."Currency Code"
          else
            CurrencyCodeToPrint := Vendor."Currency Code";
          if CurrencyCodeToPrint = '' then
            CurrencyCodeToPrint := GLSetup."LCY Code";
          ExcelBuf.AddColumn(CurrencyCodeToPrint,false,'',false,false,false,'',ExcelBuf."cell type"::Text)
        end;
    end;

    local procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('',Text101,Text102,COMPANYNAME,UserId);
    end;
}

