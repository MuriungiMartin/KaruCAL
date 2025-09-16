#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 321 "Vendor - Balance to Date"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor - Balance to Date.rdlc';
    Caption = 'Vendor - Balance to Date';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name",Blocked,"Date Filter";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(StrNoVenGetMaxDtFilter;StrSubstNo(Text000,Format(GetRangemax("Date Filter"))))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(VendFilter;VendFilter)
            {
            }
            column(PrintAmountInLCY;PrintAmountInLCY)
            {
            }
            column(PrintOnePrPage;PrintOnePrPage)
            {
            }
            column(VendorCaption;TableCaption + ': ' + VendFilter)
            {
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
            column(VendorBalancetoDateCptn;VendorBalancetoDateCptnLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(AllamountsareinLCYCaption;AllamountsareinLCYCaptionLbl)
            {
            }
            column(PostingDateCption;PostingDateCptionLbl)
            {
            }
            column(OriginalAmtCaption;OriginalAmtCaptionLbl)
            {
            }
            dataitem(VendLedgEntry3;"Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_6920; 6920)
                {
                }
                column(PostDt_VendLedgEntry3;Format("Posting Date"))
                {
                }
                column(DocType_VendLedgEntry3;"Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocNo_VendLedgEntry3;"Document No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_VendLedgEntry3;Description)
                {
                    IncludeCaption = true;
                }
                column(OriginalAmt;OriginalAmt)
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(EntryNo_VendLedgEntry3;"Entry No.")
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode;CurrencyCode)
                {
                }
                dataitem("Detailed Vendor Ledg. Entry";"Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No."=field("Entry No."),"Posting Date"=field("Date Filter");
                    DataItemTableView = sorting("Vendor Ledger Entry No.","Posting Date") where("Entry Type"=filter(<>"Initial Entry"));
                    column(ReportForNavId_2149; 2149)
                    {
                    }
                    column(EntryTp_DtldVendLedgEntry;"Entry Type")
                    {
                    }
                    column(PostDate_DtldVendLedEnt;Format("Posting Date"))
                    {
                    }
                    column(DocType_DtldVendLedEnt;"Document Type")
                    {
                    }
                    column(DocNo_DtldVendLedgEntry;"Document No.")
                    {
                    }
                    column(Amt;Amt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CurrencyCode1;CurrencyCode)
                    {
                    }
                    column(DtldVendtLedgEntryNum;DtldVendtLedgEntryNum)
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

                        DtldVendtLedgEntryNum := DtldVendtLedgEntryNum + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        DtldVendtLedgEntryNum := 0;
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
                end;

                trigger OnPreDataItem()
                begin
                    Reset;
                    FilterDetailedVendLedgerEntry(DtldVendLedgEntry,StrSubstNo('%1..%2',MaxDate,99991231D));
                    if DtldVendLedgEntry.Find('-') then
                      repeat
                        "Entry No." := DtldVendLedgEntry."Vendor Ledger Entry No.";
                        Mark(true);
                      until DtldVendLedgEntry.Next = 0;

                    FilterVendorLedgerEntry(VendLedgEntry3);
                    if Find('-') then
                      repeat
                        Mark(true);
                      until Next = 0;

                    SetCurrentkey("Entry No.");
                    SetRange(Open);
                    MarkedOnly(true);
                    SetRange("Date Filter",0D,MaxDate);

                    AddVendorDimensionFilter(VendLedgEntry3);

                    CalcTotalVendorAmount;
                end;
            }
            dataitem(Integer2;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=filter(1..));
                column(ReportForNavId_4152; 4152)
                {
                }
                column(Name1_Vendor;Vendor.Name)
                {
                }
                column(CurrTotalBufferTotalAmt;CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrTotalBufferCurrCode;CurrencyTotalBuffer."Currency Code")
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
                MaxDate := GetRangemax("Date Filter");
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
            column(CurrTotalBuffer2CurrCode;CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(CurrTotalBuffer2TotalAmt;CurrencyTotalBuffer2."Total Amount")
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
                    field(ShowAmountsInLCY;PrintAmountInLCY)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in $';
                    }
                    field(PrintOnePrPage;PrintOnePrPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Vendor';
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
    var
        CaptionManagement: Codeunit "Caption Class";
    begin
        VendFilter := CaptionManagement.GetRecordFiltersWithCaptions(Vendor);
    end;

    var
        Text000: label 'Balance on %1';
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        PrintAmountInLCY: Boolean;
        PrintOnePrPage: Boolean;
        VendFilter: Text;
        MaxDate: Date;
        OriginalAmt: Decimal;
        Amt: Decimal;
        RemainingAmt: Decimal;
        Counter1: Integer;
        DtldVendtLedgEntryNum: Integer;
        OK: Boolean;
        CurrencyCode: Code[10];
        PrintUnappliedEntries: Boolean;
        VendorBalancetoDateCptnLbl: label 'Vendor - Balance to Date';
        PageNoCaptionLbl: label 'Page';
        AllamountsareinLCYCaptionLbl: label 'All amounts are in $.';
        PostingDateCptionLbl: label 'Posting Date';
        OriginalAmtCaptionLbl: label 'Amount';
        TotalCaptionLbl: label 'Total';


    procedure InitializeRequest(NewPrintAmountInLCY: Boolean;NewPrintOnePrPage: Boolean;NewPrintUnappliedEntries: Boolean)
    begin
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintOnePrPage := NewPrintOnePrPage;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
    end;

    local procedure FilterDetailedVendLedgerEntry(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";DateFilter: Text)
    begin
        with DetailedVendorLedgEntry do begin
          SetCurrentkey("Vendor No.","Posting Date","Entry Type");
          SetRange("Vendor No.",Vendor."No.");
          SetFilter("Posting Date",DateFilter);
          SetRange("Entry Type",DtldVendLedgEntry."entry type"::Application);
          if not PrintUnappliedEntries then
            SetRange(Unapplied,false);
        end;
    end;

    local procedure FilterVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        with VendorLedgerEntry do begin
          SetCurrentkey("Vendor No.",Open);
          SetRange("Vendor No.",Vendor."No.");
          SetRange(Open,true);
          SetRange("Posting Date",0D,MaxDate);
        end;
    end;

    local procedure AddVendorDimensionFilter(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        with VendorLedgerEntry do begin
          if Vendor.GetFilter("Global Dimension 1 Filter") <> '' then
            SetRange("Global Dimension 1 Code",Vendor.GetFilter("Global Dimension 1 Filter"));
          if Vendor.GetFilter("Global Dimension 2 Filter") <> '' then
            SetRange("Global Dimension 2 Code",Vendor.GetFilter("Global Dimension 2 Filter"));
          if Vendor.GetFilter("Currency Filter") <> '' then
            SetRange("Currency Code",Vendor.GetFilter("Currency Filter"));
        end;
    end;

    local procedure CalcTotalVendorAmount()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        with TempVendorLedgerEntry do begin
          FilterDetailedVendLedgerEntry(DetailedVendorLedgEntry,'');
          if DetailedVendorLedgEntry.FindSet then
            repeat
              VendorLedgerEntry.Get(DetailedVendorLedgEntry."Vendor Ledger Entry No.");
              if not Get(VendorLedgerEntry."Entry No.") then begin
                TempVendorLedgerEntry := VendorLedgerEntry;
                Insert;
              end;
            until DetailedVendorLedgEntry.Next = 0;

          FilterVendorLedgerEntry(VendorLedgerEntry);
          if VendorLedgerEntry.FindSet then
            repeat
              if not Get(VendorLedgerEntry."Entry No.") then begin
                TempVendorLedgerEntry := VendorLedgerEntry;
                Insert;
              end;
            until VendorLedgerEntry.Next = 0;

          SetCurrentkey("Entry No.");
          SetRange("Date Filter",0D,MaxDate);
          AddVendorDimensionFilter(TempVendorLedgerEntry);
          if FindSet then
            repeat
              if PrintAmountInLCY then begin
                CalcFields("Remaining Amt. (LCY)");
                RemainingAmt := "Remaining Amt. (LCY)";
                CurrencyCode := '';
              end else begin
                CalcFields("Remaining Amount");
                RemainingAmt := "Remaining Amount";
                CurrencyCode := "Currency Code";
              end;

              if RemainingAmt <> 0 then
                CurrencyTotalBuffer.UpdateTotal(
                  CurrencyCode,
                  RemainingAmt,
                  0,
                  Counter1);
            until Next = 0;
        end;
    end;
}

