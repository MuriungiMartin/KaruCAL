#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51008 "Imprest- Balance to Date"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest- Balance to Date.rdlc';
    Caption = 'Customer - Balance to Date';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name",Blocked;
            column(ReportForNavId_6836; 6836)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(TxtCustGeTranmaxDtFilter;StrSubstNo(Text000,Format(GetRangemax("Date Filter"))))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(PrintOnePrPage;PrintOnePrPage)
            {
            }
            column(CustFilter;CustFilter)
            {
            }
            column(PrintAmountInLCY;PrintAmountInLCY)
            {
            }
            column(CustTableCaptCustFilter;TableCaption + ': ' + CustFilter)
            {
            }
            column(No_Customer;"No.")
            {
            }
            column(Name_Customer;Name)
            {
            }
            column(PhoneNo_Customer;"Phone No.")
            {
                IncludeCaption = true;
            }
            column(CustBalancetoDateCaption;CustBalancetoDateCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(AllamtsareinLCYCaption;AllamtsareinLCYCaptionLbl)
            {
            }
            column(CustLedgEntryPostingDtCaption;CustLedgEntryPostingDtCaptionLbl)
            {
            }
            column(OriginalAmtCaption;OriginalAmtCaptionLbl)
            {
            }
            dataitem(CustLedgEntry3;"Cust. Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_5082; 5082)
                {
                }
                column(PostingDt_CustLedgEntry;Format("Posting Date"))
                {
                    IncludeCaption = false;
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
                column(OriginalAmt;OriginalAmt)
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(EntryNo_CustLedgEntry;"Entry No.")
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode;CurrencyCode)
                {
                }
                dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No."=field("Entry No."),"Posting Date"=field("Date Filter");
                    DataItemTableView = sorting("Cust. Ledger Entry No.","Posting Date") where("Entry Type"=filter(<>"Initial Entry"));
                    column(ReportForNavId_6942; 6942)
                    {
                    }
                    column(EntType_DtldCustLedgEnt;"Entry Type")
                    {
                    }
                    column(postDt_DtldCustLedgEntry;Format("Posting Date"))
                    {
                    }
                    column(DocType_DtldCustLedgEntry;"Document Type")
                    {
                    }
                    column(DocNo_DtldCustLedgEntry;"Document No.")
                    {
                    }
                    column(Amt;Amt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CurrencyCodeDtldCustLedgEntry;CurrencyCode)
                    {
                    }
                    column(EntNo_DtldCustLedgEntry;DtldCustLedgEntryNum)
                    {
                    }
                    column(RemainingAmt;RemainingAmt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not PrintUnappliedEntries then
                          if Unapplied then
                            CurrReport.Skip;

                        if PrintAmountInLCY then begin
                          Amt := "Amount (LCY)";
                          CurrencyCode := '';
                        end else begin
                          Amt := Amount;
                          CurrencyCode := "Currency Code";
                        end;
                        if Amt = 0 then
                          CurrReport.Skip;

                        DtldCustLedgEntryNum := DtldCustLedgEntryNum + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        DtldCustLedgEntryNum := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if PrintAmountInLCY then begin
                      CalcFields("Original Amt. (LCY)","Remaining Amt. (LCY)");
                      OriginalAmt := "Original Amt. (LCY)";
                      RemainingAmt := "Remaining Amt. (LCY)";
                      CurrencyCode := '';
                    end else begin
                      CalcFields("Original Amount","Remaining Amount");
                      OriginalAmt := "Original Amount";
                      RemainingAmt := "Remaining Amount";
                      CurrencyCode := "Currency Code";
                    end;

                    CurrencyTotalBuffer.UpdateTotal(
                      CurrencyCode,
                      RemainingAmt,
                      0,
                      Counter1);
                end;

                trigger OnPreDataItem()
                begin
                    Reset;
                    DtldCustLedgEntry.SetCurrentkey("Customer No.","Posting Date","Entry Type");
                    DtldCustLedgEntry.SetRange("Customer No.",Customer."No.");
                    DtldCustLedgEntry.SetRange("Posting Date",CalcDate('<+1D>',MaxDate),99991231D);
                    DtldCustLedgEntry.SetRange("Entry Type",DtldCustLedgEntry."entry type"::Application);
                    if not PrintUnappliedEntries then
                      DtldCustLedgEntry.SetRange(Unapplied,false);

                    if DtldCustLedgEntry.Find('-') then
                      repeat
                        "Entry No." := DtldCustLedgEntry."Cust. Ledger Entry No.";
                        Mark(true);
                      until DtldCustLedgEntry.Next = 0;

                    SetCurrentkey("Customer No.",Open);
                    SetRange("Customer No.",Customer."No.");
                    SetRange(Open,true);
                    SetRange("Posting Date",0D,MaxDate);

                    if Find('-') then
                      repeat
                        Mark(true);
                      until Next = 0;

                    SetCurrentkey("Entry No.");
                    SetRange(Open);
                    MarkedOnly(true);
                    SetRange("Date Filter",0D,MaxDate);
                end;
            }
            dataitem(Integer2;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=filter(1..));
                column(ReportForNavId_4152; 4152)
                {
                }
                column(CustName;Customer.Name)
                {
                }
                column(TtlAmtCurrencyTtlBuff;CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurryCode_CurrencyTtBuff;CurrencyTotalBuffer."Currency Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                      OK := CurrencyTotalBuffer.Find('-')
                    else
                      OK := CurrencyTotalBuffer.Next <> 0;
                    if not OK then
                      CurrReport.Break;

                    CurrencyTotalBuffer2.UpdateTotal(
                      CurrencyTotalBuffer."Currency Code",
                      CurrencyTotalBuffer."Total Amount",
                      0,
                      Counter1);
                end;

                trigger OnPostDataItem()
                begin
                    CurrencyTotalBuffer.DeleteAll;
                end;

                trigger OnPreDataItem()
                begin
                    CurrencyTotalBuffer.SetFilter("Total Amount",'<>0');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if MaxDate = 0D then
                  Error(BlankMaxDateErr);

                SetRange("Date Filter",0D,MaxDate);
                CalcFields("Net Change (LCY)","Net Change");

                if ((PrintAmountInLCY and ("Net Change (LCY)" = 0)) or
                    ((not PrintAmountInLCY) and ("Net Change" = 0)))
                then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnePrPage;
            end;
        }
        dataitem(Integer3;"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=filter(1..));
            column(ReportForNavId_7913; 7913)
            {
            }
            column(CurryCode_CurrencyTtBuff2;CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(TtlAmtCurrencyTtlBuff2;CurrencyTotalBuffer2."Total Amount")
            {
                AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                  OK := CurrencyTotalBuffer2.Find('-')
                else
                  OK := CurrencyTotalBuffer2.Next <> 0;
                if not OK then
                  CurrReport.Break;
            end;

            trigger OnPostDataItem()
            begin
                CurrencyTotalBuffer2.DeleteAll;
            end;

            trigger OnPreDataItem()
            begin
                CurrencyTotalBuffer2.SetFilter("Total Amount",'<>0');
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
                    field("Ending Date";MaxDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                    }
                    field(PrintAmountInLCY;PrintAmountInLCY)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in LCY';
                    }
                    field(PrintOnePrPage;PrintOnePrPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Customer';
                    }
                    field(PrintUnappliedEntries;PrintUnappliedEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Unapplied Entries';
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
        CustFilter := Customer.GetFilters;
        CustDateFilter := Customer.GetFilter("Date Filter");
    end;

    var
        Text000: label 'Balance on %1';
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PrintAmountInLCY: Boolean;
        PrintOnePrPage: Boolean;
        CustFilter: Text;
        CustDateFilter: Text[30];
        MaxDate: Date;
        OriginalAmt: Decimal;
        Amt: Decimal;
        RemainingAmt: Decimal;
        Counter1: Integer;
        DtldCustLedgEntryNum: Integer;
        OK: Boolean;
        CurrencyCode: Code[10];
        PrintUnappliedEntries: Boolean;
        CustBalancetoDateCaptionLbl: label 'Customer - Balance to Date';
        CurrReportPageNoCaptionLbl: label 'Page';
        AllamtsareinLCYCaptionLbl: label 'All amounts are in LCY.';
        CustLedgEntryPostingDtCaptionLbl: label 'Posting Date';
        OriginalAmtCaptionLbl: label 'Amount';
        TotalCaptionLbl: label 'Total';
        BlankMaxDateErr: label 'Ending Date must have a value.';


    procedure InitializeRequest(NewPrintAmountInLCY: Boolean;NewPrintOnePrPage: Boolean;NewPrintUnappliedEntries: Boolean;NewEndingDate: Date)
    begin
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintOnePrPage := NewPrintOnePrPage;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        MaxDate := NewEndingDate;
    end;
}

