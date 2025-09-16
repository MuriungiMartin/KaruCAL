#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 120 "Aged Accounts Receivable2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Aged Accounts Receivable2.rdlc';
    Caption = 'Aged Accounts Receivable';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "No.","Customer Posting Group";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Picture;CompanyInformation.Picture)
            {
            }
            column(Tel;CompanyInformation."Phone No.")
            {
            }
            column(Company_Email;CompanyInformation."E-Mail")
            {
            }
            column(Website;CompanyInformation."Home Page")
            {
            }
            column(floor;CompanyInformation."Ship-to Address 2")
            {
            }
            column(Locations;CompanyInformation.City)
            {
            }
            column(addess2;CompanyInformation."Address 2")
            {
            }
            column(Adress;CompanyInformation.Address)
            {
            }
            column(County;CompanyInformation.County)
            {
            }
            column(Name;CompanyInformation.Name)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(FormatEndingDate;StrSubstNo(Text006,Format(EndingDate,0,4)))
            {
            }
            column(PostingDate;StrSubstNo(Text007,SelectStr(AgingBy + 1,Text009)))
            {
            }
            column(PrintAmountInLCY;PrintAmountInLCY)
            {
            }
            column(TableCaptnCustFilter;TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter;CustFilter)
            {
            }
            column(AgingByDueDate;AgingBy = Agingby::"Due Date")
            {
            }
            column(AgedbyDocumnetDate;StrSubstNo(Text004,SelectStr(AgingBy + 1,Text009)))
            {
            }
            column(HeaderText5;HeaderText[5])
            {
            }
            column(HeaderText4;HeaderText[4])
            {
            }
            column(HeaderText3;HeaderText[3])
            {
            }
            column(HeaderText2;HeaderText[2])
            {
            }
            column(HeaderText1;HeaderText[1])
            {
            }
            column(PrintDetails;PrintDetails)
            {
            }
            column(GrandTotalCLE5RemAmt;GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE4RemAmt;GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE3RemAmt;GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE2RemAmt;GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE1RemAmt;GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLEAmtLCY;GrandTotalCustLedgEntry[1]."Amount (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE1CustRemAmtLCY;Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE2CustRemAmtLCY;Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE3CustRemAmtLCY;Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE4CustRemAmtLCY;Pct(GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE5CustRemAmtLCY;Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(AgedAccReceivableCptn;AgedAccReceivableCptnLbl)
            {
            }
            column(CurrReportPageNoCptn;CurrReportPageNoCptnLbl)
            {
            }
            column(AllAmtinLCYCptn;AllAmtinLCYCptnLbl)
            {
            }
            column(AgedOverdueAmtCptn;AgedOverdueAmtCptnLbl)
            {
            }
            column(CLEEndDateAmtLCYCptn;CLEEndDateAmtLCYCptnLbl)
            {
            }
            column(CLEEndDateDueDateCptn;CLEEndDateDueDateCptnLbl)
            {
            }
            column(CLEEndDateDocNoCptn;CLEEndDateDocNoCptnLbl)
            {
            }
            column(CLEEndDatsePstngDateCptn;CLEEndDatePstngDateCptnLbl)
            {
            }
            column(CLEEndDateDocTypeCptn;CLEEndDateDocTypeCptnLbl)
            {
            }
            column(OriginalAmtCptn;OriginalAmtCptnLbl)
            {
            }
            column(TotalLCYCptn;TotalLCYCptnLbl)
            {
            }
            column(NewPagePercustomer;NewPagePercustomer)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(sett;"Settlement Type")
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Customer No."=field("No.");
                DataItemTableView = sorting("Customer No.","Posting Date","Currency Code");
                column(ReportForNavId_8503; 8503)
                {
                }

                trigger OnAfterGetRecord()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    // CustLedgEntry.SETCURRENTKEY("Closed by Entry No.");
                    // CustLedgEntry.SETRANGE("Closed by Entry No.","Entry No.");
                    CustLedgEntry.SetRange("Posting Date",0D,EndingDate);
                    if CustLedgEntry.FindSet(false,false) then
                      repeat
                        InsertTemp(CustLedgEntry);
                      until CustLedgEntry.Next = 0;

                    //IF "Closed by Entry No." <> 0 THEN BEGIN
                      //CustLedgEntry.SETRANGE("Closed by Entry No.","Closed by Entry No.");
                      if CustLedgEntry.FindSet(false,false) then
                        repeat
                          InsertTemp(CustLedgEntry);
                        until CustLedgEntry.Next = 0;
                    //END;
                    Customer.CalcFields("Settlement Type");

                    CustLedgEntry.Reset;
                    //CustLedgEntry.SETRANGE("Entry No.","Closed by Entry No.");
                    CustLedgEntry.SetRange("Posting Date",0D,EndingDate);
                    if CustLedgEntry.FindSet(false,false) then
                      repeat
                        InsertTemp(CustLedgEntry);
                      until CustLedgEntry.Next = 0;
                    CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date",EndingDate + 1,99991231D);
                end;
            }
            dataitem(OpenCustLedgEntry;"Cust. Ledger Entry")
            {
                DataItemLink = "Customer No."=field("No.");
                DataItemTableView = sorting("Customer No.",Positive,"Due Date","Currency Code");
                column(ReportForNavId_1473; 1473)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if AgingBy = Agingby::"Posting Date" then begin
                      CalcFields("Remaining Amt. (LCY)","Original Amount");
                      if "Remaining Amt. (LCY)" = 0 then
                        CurrReport.Skip;
                    end;

                    InsertTemp(OpenCustLedgEntry);
                    CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if AgingBy = Agingby::"Posting Date" then begin
                      SetRange("Posting Date",0D,EndingDate);
                      SetRange("Date Filter",0D,EndingDate);
                    end;
                end;
            }
            dataitem(CurrencyLoop;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=filter(1..));
                PrintOnlyIfDetail = true;
                column(ReportForNavId_6523; 6523)
                {
                }
                dataitem(TempCustLedgEntryLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=filter(1..));
                    column(ReportForNavId_7725; 7725)
                    {
                    }
                    column(Name1_Cust;Customer.Name)
                    {
                        IncludeCaption = true;
                    }
                    column(No_Cust;Customer."No.")
                    {
                        IncludeCaption = true;
                    }
                    column(st;Customer."Settlement Type")
                    {
                    }
                    column(CLEEndDateRemAmtLCY;CustLedgEntryEndingDate."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE1RemAmtLCY;AgedCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE2RemAmtLCY;AgedCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE3RemAmtLCY;AgedCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE4RemAmtLCY;AgedCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE5RemAmtLCY;AgedCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CLEEndDateAmtLCY;CustLedgEntryEndingDate."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CLEEndDueDate;Format(CustLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(CLEEndDateDocNo;CustLedgEntryEndingDate."Document No.")
                    {
                    }
                    column(CLEDocType;Format(CustLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(CLEPostingDate;Format(CustLedgEntryEndingDate."Posting Date"))
                    {
                    }
                    column(AgedCLE5TempRemAmt;AgedCustLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCLE4TempRemAmt;AgedCustLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCLE3TempRemAmt;AgedCustLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCLE2TempRemAmt;AgedCustLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCLE1TempRemAmt;AgedCustLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(RemAmt_CLEEndDate;CustLedgEntryEndingDate."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CLEEndDate;CustLedgEntryEndingDate.Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(Name_Cust;StrSubstNo(Text005,Customer.Name))
                    {
                    }
                    column(TotalCLE1AmtLCY;TotalCustLedgEntry[1]."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE1RemAmtLCY;TotalCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE2RemAmtLCY;TotalCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE3RemAmtLCY;TotalCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE4RemAmtLCY;TotalCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE5RemAmtLCY;TotalCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CurrrencyCode;CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalCLE5RemAmt;TotalCustLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE4RemAmt;TotalCustLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE3RemAmt;TotalCustLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE2RemAmt;TotalCustLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE1RemAmt;TotalCustLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE1Amt;TotalCustLedgEntry[1].Amount)
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCheck;CustFilterCheck)
                    {
                    }
                    column(GrandTotalCLE1AmtLCY;GrandTotalCustLedgEntry[1]."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE5PctRemAmtLCY;Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
                    {
                    }
                    column(GrandTotalCLE3PctRemAmtLCY;Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
                    {
                    }
                    column(GrandTotalCLE2PctRemAmtLCY;Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
                    {
                    }
                    column(GrandTotalCLE1PctRemAmtLCY;Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)"))
                    {
                    }
                    column(GrandTotalCLE5RemAmtLCY;GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE4RemAmtLCY;GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE3RemAmtLCY;GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE2RemAmtLCY;GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE1RemAmtLCY;GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PeriodIndex: Integer;
                    begin
                        if Number = 1 then begin
                          if not TempCustLedgEntry.FindSet(false,false) then
                            CurrReport.Break;
                        end else
                          if TempCustLedgEntry.Next = 0 then
                            CurrReport.Break;

                        CustLedgEntryEndingDate := TempCustLedgEntry;
                        DetailedCustomerLedgerEntry.SetRange("Cust. Ledger Entry No.",CustLedgEntryEndingDate."Entry No.");
                        if DetailedCustomerLedgerEntry.FindSet(false,false) then
                          repeat
                            if (DetailedCustomerLedgerEntry."Entry Type" =
                                DetailedCustomerLedgerEntry."entry type"::"Initial Entry") and
                               (CustLedgEntryEndingDate."Posting Date" > EndingDate) and
                               (AgingBy <> Agingby::"Posting Date")
                            then begin
                              if CustLedgEntryEndingDate."Document Date" <= EndingDate then
                                DetailedCustomerLedgerEntry."Posting Date" :=
                                  CustLedgEntryEndingDate."Document Date"
                              else
                                if (CustLedgEntryEndingDate."Due Date" <= EndingDate) and
                                   (AgingBy = Agingby::"Due Date")
                                then
                                  DetailedCustomerLedgerEntry."Posting Date" :=
                                    CustLedgEntryEndingDate."Due Date"
                            end;

                            if (DetailedCustomerLedgerEntry."Posting Date" <= EndingDate) or
                               ((AgingBy = Agingby::"Due Date") and//TempCustLedgEntry.Open AND
                                (CustLedgEntryEndingDate."Due Date" > EndingDate) and
                                (CustLedgEntryEndingDate."Posting Date" <= EndingDate)) then begin
                              if DetailedCustomerLedgerEntry."Entry Type" in
                                 [DetailedCustomerLedgerEntry."entry type"::"Initial Entry",
                                  DetailedCustomerLedgerEntry."entry type"::"Unrealized Loss",
                                  DetailedCustomerLedgerEntry."entry type"::"Unrealized Gain",
                                  DetailedCustomerLedgerEntry."entry type"::"Realized Loss",
                                  DetailedCustomerLedgerEntry."entry type"::"Realized Gain",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Discount",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Discount (VAT Excl.)",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Discount (VAT Adjustment)",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Tolerance",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Discount Tolerance",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Tolerance (VAT Excl.)",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Tolerance (VAT Adjustment)",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Discount Tolerance (VAT Excl.)",
                                  DetailedCustomerLedgerEntry."entry type"::"Payment Discount Tolerance (VAT Adjustment)"]
                              then begin
                                CustLedgEntryEndingDate.Amount := CustLedgEntryEndingDate.Amount + DetailedCustomerLedgerEntry.Amount;
                                CustLedgEntryEndingDate."Amount (LCY)" :=
                                  CustLedgEntryEndingDate."Amount (LCY)" + DetailedCustomerLedgerEntry."Amount (LCY)";
                              end;
                              if DetailedCustomerLedgerEntry."Posting Date" <= EndingDate then begin
                                CustLedgEntryEndingDate."Remaining Amount" :=
                                  CustLedgEntryEndingDate."Remaining Amount" + DetailedCustomerLedgerEntry.Amount;
                                CustLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                  CustLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedCustomerLedgerEntry."Amount (LCY)";
                              end;
                            end;
                          until DetailedCustomerLedgerEntry.Next = 0;

                        // IF CustLedgEntryEndingDate."Remaining Amount" = 0 THEN
                        //  CurrReport.SKIP;

                        case AgingBy of
                          Agingby::"Due Date":
                            PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Due Date");
                          Agingby::"Posting Date":
                            PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Posting Date");
                          Agingby::"Document Date":
                            begin
                              if CustLedgEntryEndingDate."Document Date" > EndingDate then begin
                                CustLedgEntryEndingDate."Remaining Amount" := 0;
                                CustLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                CustLedgEntryEndingDate."Document Date" := CustLedgEntryEndingDate."Posting Date";
                              end;
                              PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Document Date");
                            end;
                        end;
                        Clear(AgedCustLedgEntry);
                        //IF CustLedgEntryEndingDate."Original Amount"> 0 THEN
                        //ERROR('%1',CustLedgEntryEndingDate."Original Amount");
                        // AgedCustLedgEntry[PeriodIndex]."Remaining Amount" := CustLedgEntryEndingDate."Remaining Amount";
                        // AgedCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        // TotalCustLedgEntry[PeriodIndex]."Remaining Amount" += CustLedgEntryEndingDate."Remaining Amount";
                        // TotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        // GrandTotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        // TotalCustLedgEntry[1].Amount += CustLedgEntryEndingDate."Remaining Amount";
                        // TotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        // GrandTotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";

                          AgedCustLedgEntry[PeriodIndex]."Remaining Amount" := CustLedgEntryEndingDate.Amount;
                          AgedCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := CustLedgEntryEndingDate.Amount;
                          TotalCustLedgEntry[PeriodIndex]."Remaining Amount" += CustLedgEntryEndingDate.Amount;
                          TotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate.Amount;
                          GrandTotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate.Amount;
                          TotalCustLedgEntry[1].Amount += CustLedgEntryEndingDate.Amount;
                          TotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate.Amount;
                          GrandTotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate.Amount;

                        if PrintToExcel then
                          MakeExcelDataBody;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if not PrintAmountInLCY then
                          UpdateCurrencyTotals;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not PrintAmountInLCY then begin
                          if (TempCurrency.Code = '') or (TempCurrency.Code = GLSetup."LCY Code") then
                            TempCustLedgEntry.SetFilter("Currency Code",'%1|%2',GLSetup."LCY Code",'')
                          else
                            TempCustLedgEntry.SetRange("Currency Code",TempCurrency.Code);
                        end;

                        PageGroupNo := NextPageGroupNo;
                        if NewPagePercustomer and (NumberOfCurrencies > 0) then
                          NextPageGroupNo := PageGroupNo + 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(TotalCustLedgEntry);

                    if Number = 1 then begin
                      if not TempCurrency.FindSet(false,false) then
                        CurrReport.Break;
                    end else
                      if TempCurrency.Next = 0 then
                        CurrReport.Break;

                    if TempCurrency.Code <> '' then
                      CurrencyCode := TempCurrency.Code
                    else
                      CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPreDataItem()
                begin
                    NumberOfCurrencies := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if NewPagePercustomer then
                  PageGroupNo += 1;
                TempCurrency.Reset;
                TempCurrency.DeleteAll;
                TempCustLedgEntry.Reset;
                TempCustLedgEntry.DeleteAll;
                Customer.CalcFields("Settlement Type");
            end;

            trigger OnPreDataItem()
            begin
                Customer.CalcFields("Settlement Type");
            end;
        }
        dataitem(CurrencyTotals;"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=filter(1..));
            column(ReportForNavId_8052; 8052)
            {
            }
            column(CurrNo;Number = 1)
            {
            }
            column(TempCurrCode;TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE6RemAmt;AgedCustLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE1RemAmt;AgedCustLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE2RemAmt;AgedCustLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE3RemAmt;AgedCustLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE4RemAmt;AgedCustLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE5RemAmt;AgedCustLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(CurrSpecificationCptn;CurrSpecificationCptnLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                  if not TempCurrency2.FindSet(false,false) then
                    CurrReport.Break;
                end else
                  if TempCurrency2.Next = 0 then
                    CurrReport.Break;

                Clear(AgedCustLedgEntry);
                TempCurrencyAmount.SetRange("Currency Code",TempCurrency2.Code);
                if TempCurrencyAmount.FindSet(false,false) then
                  repeat
                    if TempCurrencyAmount.Date <> 99991231D then
                      AgedCustLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                        TempCurrencyAmount.Amount
                    else
                      AgedCustLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                  until TempCurrencyAmount.Next = 0;
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
                    field(AgedAsOf;EndingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Aged As Of';
                    }
                    field(Agingby;AgingBy)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Aging by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                    }
                    field(PeriodLength;PeriodLength)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Length';
                    }
                    field(AmountsinLCY;PrintAmountInLCY)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Amounts in LCY';
                    }
                    field(PrintDetails;PrintDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Details';
                    }
                    field(HeadingType;HeadingType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days';
                    }
                    field(perCustomer;NewPagePercustomer)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Customer';
                    }
                    field(PrintToExcel;PrintToExcel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print to Excel';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if EndingDate = 0D then
              EndingDate := WorkDate;
            PrintToExcel := false;
        end;
    }

    labels
    {
        BalanceCaption = 'Balance';
    }

    trigger OnPostReport()
    begin
        if PrintToExcel then
          CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
         // CompanyInformation.CALCFIELDS(CompanyInformation.Picture);



        CustFilter := Customer.GetFilters;

        GLSetup.Get;

        CalcDates;
        CreateHeadings;

        if PrintToExcel then
          MakeExcelInfo;

        PageGroupNo := 1;
        NextPageGroupNo := 1;
        CustFilterCheck := (CustFilter <> 'No.');
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustLedgEntryEndingDate: Record "Cust. Ledger Entry";
        TotalCustLedgEntry: array [5] of Record "Cust. Ledger Entry";
        GrandTotalCustLedgEntry: array [5] of Record "Cust. Ledger Entry";
        AgedCustLedgEntry: array [6] of Record "Cust. Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        ExcelBuf: Record "Excel Buffer" temporary;
        DetailedCustomerLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        CustFilter: Text;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodLength: DateFormula;
        PrintDetails: Boolean;
        HeadingType: Option "Date Interval","Number of Days";
        NewPagePercustomer: Boolean;
        PeriodStartDate: array [5] of Date;
        PeriodEndDate: array [5] of Date;
        HeaderText: array [5] of Text[30];
        Text000: label 'Not Due';
        Text001: label 'Before';
        CurrencyCode: Code[10];
        Text002: label 'days';
        Text003: label 'More than';
        Text004: label 'Aged by %1';
        Text005: label 'Total for %1';
        Text006: label 'Aged as of %1';
        Text007: label 'Aged by %1';
        Text008: label 'All Amounts in LCY';
        NumberOfCurrencies: Integer;
        Text009: label 'Due Date,Posting Date,Document Date';
        Text010: label 'The Date Formula %1 cannot be used. Try to restate it. E.g. 1M+CM instead of CM+1M.';
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        PrintToExcel: Boolean;
        Text011: label 'Data';
        Text012: label 'Aged Accounts Receivable';
        Text013: label 'Company Name';
        Text014: label 'Report No.';
        Text015: label 'Report Name';
        Text016: label 'User ID';
        Text017: label 'Date';
        Text018: label 'Customer Filters';
        Text019: label 'Cust. Ledger Entry Filters';
        CustFilterCheck: Boolean;
        Text032: label '-%1', Comment='Negating the period length: %1 is the period length';
        AgedAccReceivableCptnLbl: label 'Aged Accounts Receivable';
        CurrReportPageNoCptnLbl: label 'Page';
        AllAmtinLCYCptnLbl: label 'All Amounts in LCY';
        AgedOverdueAmtCptnLbl: label 'Aged Overdue Amounts';
        CLEEndDateAmtLCYCptnLbl: label 'Original Amount ';
        CLEEndDateDueDateCptnLbl: label 'Due Date';
        CLEEndDateDocNoCptnLbl: label 'Document No.';
        CLEEndDatePstngDateCptnLbl: label 'Posting Date';
        CLEEndDateDocTypeCptnLbl: label 'Document Type';
        OriginalAmtCptnLbl: label 'Currency Code';
        TotalLCYCptnLbl: label 'Total (LCY)';
        CurrSpecificationCptnLbl: label 'Currency Specification';
        CompanyInformation: Record "Company Information";

    local procedure CalcDates()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        Evaluate(PeriodLength2,StrSubstNo(Text032,PeriodLength));
        if AgingBy = Agingby::"Due Date" then begin
          PeriodEndDate[1] := 99991231D;
          PeriodStartDate[1] := EndingDate + 1;
        end else begin
          PeriodEndDate[1] := EndingDate;
          PeriodStartDate[1] := CalcDate(PeriodLength2,EndingDate + 1);
        end;
        for i := 2 to ArrayLen(PeriodEndDate) do begin
          PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
          PeriodStartDate[i] := CalcDate(PeriodLength2,PeriodEndDate[i] + 1);
        end;
        PeriodStartDate[i] := 0D;

        for i := 1 to ArrayLen(PeriodEndDate) do
          if PeriodEndDate[i] < PeriodStartDate[i] then
            Error(Text010,PeriodLength);
    end;

    local procedure CreateHeadings()
    var
        i: Integer;
    begin
        if AgingBy = Agingby::"Due Date" then begin
          HeaderText[1] := Text000;
          i := 2;
        end else
          i := 1;
        while i < ArrayLen(PeriodEndDate) do begin
          if HeadingType = Headingtype::"Date Interval" then
            HeaderText[i] := StrSubstNo('%1\..%2',PeriodStartDate[i],PeriodEndDate[i])
          else
            HeaderText[i] :=
              StrSubstNo('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] + 1,Text002);
          i := i + 1;
        end;
        if HeadingType = Headingtype::"Date Interval" then
          HeaderText[i] := StrSubstNo('%1 %2',Text001,PeriodStartDate[i - 1])
        else
          HeaderText[i] := StrSubstNo('%1 \%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 1,Text002);
    end;

    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        Currency: Record Currency;
    begin
        with TempCustLedgEntry do begin
          if Get(CustLedgEntry."Entry No.") then
            exit;
          TempCustLedgEntry := CustLedgEntry;
          Insert;
          if PrintAmountInLCY then begin
            Clear(TempCurrency);
            TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            if TempCurrency.Insert then;
            exit;
          end;
          if TempCurrency.Get("Currency Code") then
            exit;
          if TempCurrency.Get('') and ("Currency Code" = GLSetup."LCY Code") then
            exit;
          if TempCurrency.Get(GLSetup."LCY Code") and ("Currency Code" = '') then
            exit;
          if "Currency Code" <> '' then
            Currency.Get("Currency Code")
          else begin
            Clear(Currency);
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
          end;
          TempCurrency := Currency;
          TempCurrency.Insert;
        end;
    end;

    local procedure GetPeriodIndex(Date: Date): Integer
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(PeriodEndDate) do
          if Date in [PeriodStartDate[i]..PeriodEndDate[i]] then
            exit(i);
    end;

    local procedure Pct(a: Decimal;b: Decimal): Text[30]
    begin
        if b <> 0 then
          exit(Format(ROUND(100 * a / b,0.1),0,'<Sign><Integer><Decimals,2>') + '%');
    end;

    local procedure UpdateCurrencyTotals()
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.Insert then;
        with TempCurrencyAmount do begin
          for i := 1 to ArrayLen(TotalCustLedgEntry) do begin
            "Currency Code" := CurrencyCode;
            Date := PeriodStartDate[i];
            if Find then begin
              Amount := Amount + TotalCustLedgEntry[i].Amount;
              Modify;
            end else begin
              "Currency Code" := CurrencyCode;
              Date := PeriodStartDate[i];
              Amount := TotalCustLedgEntry[i].Amount;
              Insert;
            end;
          end;
          "Currency Code" := CurrencyCode;
          Date := 99991231D;
          if Find then begin
            Amount := Amount + TotalCustLedgEntry[1].Amount;
            Modify;
          end else begin
            "Currency Code" := CurrencyCode;
            Date := 99991231D;
            Amount := TotalCustLedgEntry[1].Amount;
            Insert;
          end;
        end;
    end;


    procedure MakeExcelInfo()
    begin
        /*ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(FORMAT(Text013),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text015),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text012),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text014),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Aged Accounts Receivable",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text016),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text017),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text018),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Customer.GETFILTERS,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text019),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("Cust. Ledger Entry".GETFILTERS,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        IF PrintAmountInLCY THEN BEGIN
          ExcelBuf.NewRow;
          ExcelBuf.AddInfoColumn(FORMAT(Text008),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
          ExcelBuf.AddInfoColumn(PrintAmountInLCY,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        END;
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(COPYSTR(Text004,1,7)),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(SELECTSTR(AgingBy + 1,Text009)),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
        */

    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Customer.FieldCaption("No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Customer.FieldCaption(Name),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Posting Date"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Document Type"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Document No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Due Date"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        if not PrintAmountInLCY then begin
          ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Currency Code"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Original Amount"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Remaining Amount"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        end else begin
          ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Original Amt. (LCY)"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn(TempCustLedgEntry.FieldCaption("Remaining Amt. (LCY)"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        end;
    end;


    procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Customer."No.",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Customer.Name,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TempCustLedgEntry."Posting Date",false,'',false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.AddColumn(Format(TempCustLedgEntry."Document Type"),false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TempCustLedgEntry."Document No.",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TempCustLedgEntry."Due Date",false,'',false,false,false,'',ExcelBuf."cell type"::Date);
        if PrintAmountInLCY then begin
          ExcelBuf.AddColumn(CustLedgEntryEndingDate."Amount (LCY)",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
          ExcelBuf.AddColumn(CustLedgEntryEndingDate."Remaining Amt. (LCY)",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        end else begin
          ExcelBuf.AddColumn(CurrencyCode,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn(CustLedgEntryEndingDate.Amount,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
          ExcelBuf.AddColumn(CustLedgEntryEndingDate."Remaining Amount",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        end;
    end;


    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel(Text011,Text012,COMPANYNAME,USERID);
        //ERROR('');
    end;


    procedure InitializeRequest(NewEndingDate: Date;NewAgingBy: Option;NewPeriodLength: DateFormula;NewPrintAmountInLCY: Boolean;NewPrintDetails: Boolean;NewHeadingType: Option;NewPagePercust: Boolean;NewPrintToExcel: Boolean)
    begin
        EndingDate := NewEndingDate;
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePercustomer := NewPagePercust;
        PrintToExcel := NewPrintToExcel;
    end;
}

