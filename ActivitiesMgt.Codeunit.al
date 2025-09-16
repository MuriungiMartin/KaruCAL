#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1311 "Activities Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure CalcOverdueSalesInvoiceAmount() Amount: Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]CustLedgEntryRemainAmtQuery: Query "Cust. Ledg. Entry Remain. Amt.";
    begin
        CustLedgEntryRemainAmtQuery.SetRange(Document_Type,CustLedgerEntry."document type"::Invoice);
        CustLedgEntryRemainAmtQuery.SetRange(IsOpen,true);
        CustLedgEntryRemainAmtQuery.SetFilter(Due_Date,'<%1',WorkDate);
        CustLedgEntryRemainAmtQuery.Open;

        if CustLedgEntryRemainAmtQuery.Read then
          Amount := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;


    procedure DrillDownCalcOverdueSalesInvoiceAmount()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Document Type",CustLedgerEntry."document type"::Invoice);
        CustLedgerEntry.SetRange(Open,true);
        CustLedgerEntry.SetFilter("Due Date",'<%1',WorkDate);
        CustLedgerEntry.SetFilter("Remaining Amt. (LCY)",'<>0');
        CustLedgerEntry.SetCurrentkey("Remaining Amt. (LCY)");
        CustLedgerEntry.Ascending := false;

        Page.Run(Page::"Customer Ledger Entries",CustLedgerEntry);
    end;


    procedure CalcOverduePurchaseInvoiceAmount() Amount: Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]VendLedgEntryRemainAmtQuery: Query "Vend. Ledg. Entry Remain. Amt.";
    begin
        VendLedgEntryRemainAmtQuery.SetRange(Document_Type,VendorLedgerEntry."document type"::Invoice);
        VendLedgEntryRemainAmtQuery.SetRange(IsOpen,true);
        VendLedgEntryRemainAmtQuery.SetFilter(Due_Date,'<%1',WorkDate);
        VendLedgEntryRemainAmtQuery.Open;

        if VendLedgEntryRemainAmtQuery.Read then
          Amount := Abs(VendLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY);
    end;


    procedure DrillDownOverduePurchaseInvoiceAmount()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.SetRange("Document Type",VendorLedgerEntry."document type"::Invoice);
        VendorLedgerEntry.SetFilter("Due Date",'<%1',WorkDate);
        VendorLedgerEntry.SetFilter("Remaining Amt. (LCY)",'<>0');
        VendorLedgerEntry.SetCurrentkey("Remaining Amt. (LCY)");
        VendorLedgerEntry.Ascending := true;

        Page.Run(Page::"Vendor Ledger Entries",VendorLedgerEntry);
    end;


    procedure CalcSalesThisMonthAmount() Amount: Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]CustLedgEntrySales: Query "Cust. Ledg. Entry Sales";
    begin
        CustLedgEntrySales.SetRange(Document_Type,CustLedgerEntry."document type"::Invoice);
        CustLedgEntrySales.SetRange(Posting_Date,CalcDate('<-CM>',WorkDate),WorkDate);
        CustLedgEntrySales.Open;

        if CustLedgEntrySales.Read then
          Amount := CustLedgEntrySales.Sum_Sales_LCY;
    end;


    procedure DrillDownSalesThisMonth()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Document Type",CustLedgerEntry."document type"::Invoice);
        CustLedgerEntry.SetRange("Posting Date",CalcDate('<-CM>',WorkDate),WorkDate);
        Page.Run(Page::"Customer Ledger Entries",CustLedgerEntry);
    end;


    procedure CalcSalesYTD() Amount: Decimal
    var
        AccountingPeriod: Record "Accounting Period";
        [SecurityFiltering(Securityfilter::Filtered)]CustLedgEntrySales: Query "Cust. Ledg. Entry Sales";
    begin
        CustLedgEntrySales.SetRange(Posting_Date,AccountingPeriod.GetFiscalYearStartDate(WorkDate),WorkDate);
        CustLedgEntrySales.Open;

        if CustLedgEntrySales.Read then
          Amount := CustLedgEntrySales.Sum_Sales_LCY;
    end;


    procedure CalcTop10CustomerSalesYTD() Amount: Decimal
    var
        AccountingPeriod: Record "Accounting Period";
        Top10CustomerSales: Query "Top 10 Customer Sales";
    begin
        // Total Sales (LCY) by top 10 list of customers year-to-date.
        Top10CustomerSales.SetRange(Posting_Date,AccountingPeriod.GetFiscalYearStartDate(WorkDate),WorkDate);
        Top10CustomerSales.Open;

        while Top10CustomerSales.Read do
          Amount += Top10CustomerSales.Sum_Sales_LCY;
    end;


    procedure CalcTop10CustomerSalesRatioYTD() Amount: Decimal
    var
        TotalSales: Decimal;
    begin
        // Ratio of Sales by top 10 list of customers year-to-date.
        TotalSales := CalcSalesYTD;
        if TotalSales <> 0 then
          Amount := CalcTop10CustomerSalesYTD / TotalSales;
    end;


    procedure CalcAverageCollectionDays() AverageDays: Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SumCollectionDays: Integer;
        CountInvoices: Integer;
    begin
        GetPaidSalesInvoices(CustLedgerEntry);
        if CustLedgerEntry.FindSet then begin
          repeat
            SumCollectionDays += (CustLedgerEntry."Closed at Date" - CustLedgerEntry."Posting Date");
            CountInvoices += 1;
          until CustLedgerEntry.Next = 0;

          AverageDays := SumCollectionDays / CountInvoices;
        end
    end;


    procedure CalcUninvoicedBookings(): Integer
    var
        TempBookingItem: Record "Booking Item" temporary;
        BookingManager: Codeunit "Booking Manager";
    begin
        BookingManager.GetBookingItems(TempBookingItem);
        TempBookingItem.SetRange(Invoiced,false);
        exit(TempBookingItem.Count);
    end;

    local procedure GetPaidSalesInvoices(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry.SetRange("Document Type",CustLedgerEntry."document type"::Invoice);
        CustLedgerEntry.SetRange(Open,false);
        CustLedgerEntry.SetRange("Posting Date",CalcDate('<CM-3M>',WorkDate),WorkDate);
        CustLedgerEntry.SetRange("Closed at Date",CalcDate('<CM-3M>',WorkDate),WorkDate);
    end;
}

