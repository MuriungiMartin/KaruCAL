#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1302 "Customer Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        FiscalYearTotals: Boolean;


    procedure AvgDaysToPay(CustNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        AvgDaysToPay: Decimal;
        TotalDaysToPay: Decimal;
        TotalNoOfInv: Integer;
    begin
        with CustLedgEntry do begin
          AvgDaysToPay := 0;
          SetCurrentkey("Customer No.","Posting Date");
          SetFilterForPostedDocs(CustLedgEntry,CustNo,"document type"::Invoice);
          SetRange(Open,false);

          if FindSet then
            repeat
              case true of
                "Closed at Date" > "Posting Date":
                  UpdateDaysToPay("Closed at Date" - "Posting Date",TotalDaysToPay,TotalNoOfInv);
                "Closed by Entry No." <> 0:
                  begin
                    if CustLedgEntry2.Get("Closed by Entry No.") then
                      UpdateDaysToPay(CustLedgEntry2."Posting Date" - "Posting Date",TotalDaysToPay,TotalNoOfInv);
                  end;
                else begin
                  CustLedgEntry2.SetCurrentkey("Closed by Entry No.");
                  CustLedgEntry2.SetRange("Closed by Entry No.","Entry No.");
                  if CustLedgEntry2.FindFirst then
                    UpdateDaysToPay(CustLedgEntry2."Posting Date" - "Posting Date",TotalDaysToPay,TotalNoOfInv);
                end;
              end;
            until Next = 0;
        end;

        if TotalNoOfInv <> 0 then
          AvgDaysToPay := TotalDaysToPay / TotalNoOfInv;

        exit(AvgDaysToPay);
    end;

    local procedure UpdateDaysToPay(NoOfDays: Integer;var TotalDaysToPay: Decimal;var TotalNoOfInv: Integer)
    begin
        TotalDaysToPay += NoOfDays;
        TotalNoOfInv += 1;
    end;


    procedure CalculateStatistic(Customer: Record Customer;var AdjmtCostLCY: Decimal;var AdjCustProfit: Decimal;var AdjProfitPct: Decimal;var CustInvDiscAmountLCY: Decimal;var CustPaymentsLCY: Decimal;var CustSalesLCY: Decimal;var CustProfit: Decimal)
    var
        CostCalcuMgt: Codeunit "Cost Calculation Management";
    begin
        with Customer do begin
          SetFilter("Date Filter",GetCurrentYearFilter);

          CalcFields("Sales (LCY)","Profit (LCY)","Inv. Discounts (LCY)","Payments (LCY)");

          // Costs (LCY):
          CustSalesLCY := "Sales (LCY)";
          CustProfit := "Profit (LCY)" + CostCalcuMgt.NonInvtblCostAmt(Customer);
          AdjmtCostLCY := CustSalesLCY - CustProfit + CostCalcuMgt.CalcCustActualCostLCY(Customer);
          AdjCustProfit := CustProfit + AdjmtCostLCY;

          // Profit %
          if "Sales (LCY)" <> 0 then
            AdjProfitPct := ROUND(100 * AdjCustProfit / "Sales (LCY)",0.1)
          else
            AdjProfitPct := 0;

          CustInvDiscAmountLCY := "Inv. Discounts (LCY)";

          CustPaymentsLCY := "Payments (LCY)";
        end;
    end;


    procedure CalcAmountsOnPostedInvoices(CustNo: Code[20];var RecCount: Integer): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        exit(CalcAmountsOnPostedDocs(CustNo,RecCount,CustLedgEntry."document type"::Invoice));
    end;


    procedure CalcAmountsOnPostedCrMemos(CustNo: Code[20];var RecCount: Integer): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        exit(CalcAmountsOnPostedDocs(CustNo,RecCount,CustLedgEntry."document type"::"Credit Memo"));
    end;


    procedure CalcAmountsOnOrders(CustNo: Code[20];var RecCount: Integer): Decimal
    var
        SalesHeader: Record "Sales Header";
    begin
        exit(CalculateAmountsOnUnpostedDocs(CustNo,RecCount,SalesHeader."document type"::Order));
    end;


    procedure CalcAmountsOnQuotes(CustNo: Code[20];var RecCount: Integer): Decimal
    var
        SalesHeader: Record "Sales Header";
    begin
        exit(CalculateAmountsOnUnpostedDocs(CustNo,RecCount,SalesHeader."document type"::Quote));
    end;

    local procedure CalcAmountsOnPostedDocs(CustNo: Code[20];var RecCount: Integer;DocType: Integer): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        with CustLedgEntry do begin
          SetFilterForPostedDocs(CustLedgEntry,CustNo,DocType);

          RecCount := Count;

          CalcSums("Sales (LCY)");
          exit("Sales (LCY)");
        end;
    end;


    procedure CalculateAmountsWithVATOnUnpostedDocuments(CustNo: Code[20]): Decimal
    var
        SalesLine: Record "Sales Line";
        Result: Decimal;
        DocumentType: Integer;
    begin
        DocumentType := -1; // All supported Documents Type
        SetFilterForUnpostedLines(SalesLine,CustNo,DocumentType,true);
        with SalesLine do begin
          if FindSet then
            repeat
              case "Document Type" of
                "document type"::Invoice:
                  Result += "Outstanding Amount (LCY)";
                "document type"::"Credit Memo":
                  Result -= "Outstanding Amount (LCY)";
              end;
            until Next = 0;
        end;

        exit(Result);
    end;


    procedure CalculateAmountsOnUnpostedInvoices(CustNo: Code[20];var RecCount: Integer): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        exit(CalculateAmountsOnUnpostedDocs(CustNo,RecCount,SalesLine."document type"::Invoice));
    end;


    procedure CalculateAmountsOnUnpostedCrMemos(CustNo: Code[20];var RecCount: Integer): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        exit(CalculateAmountsOnUnpostedDocs(CustNo,RecCount,SalesLine."document type"::"Credit Memo"));
    end;

    local procedure CalculateAmountsOnUnpostedDocs(CustNo: Code[20];var RecCount: Integer;DocumentType: Integer): Decimal
    var
        SalesLine: Record "Sales Line";
        Result: Decimal;
        VAT: Decimal;
        OutstandingAmount: Decimal;
        OldDocumentNo: Code[20];
    begin
        RecCount := 0;
        Result := 0;

        SetFilterForUnpostedLines(SalesLine,CustNo,DocumentType,false);
        with SalesLine do begin
          if FindSet then
            repeat
              case "Document Type" of
                "document type"::Invoice,
                "document type"::Order,
                "document type"::Quote:
                  OutstandingAmount := "Outstanding Amount (LCY)";
                "document type"::"Credit Memo":
                  OutstandingAmount := -"Outstanding Amount (LCY)";
              end;
              VAT := 100 + "VAT %";
              Result += OutstandingAmount * 100 / VAT;

              if OldDocumentNo <> "Document No." then begin
                OldDocumentNo := "Document No.";
                RecCount += 1;
              end;
            until Next = 0;
        end;

        exit(ROUND(Result));
    end;


    procedure DrillDownOnPostedInvoices(CustNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        with SalesInvoiceHeader do begin
          SetRange("Bill-to Customer No.",CustNo);
          SetFilter("Posting Date",GetCurrentYearFilter);

          Page.Run(Page::"Posted Sales Invoices",SalesInvoiceHeader);
        end;
    end;


    procedure DrillDownOnPostedCrMemo(CustNo: Code[20])
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        with SalesCrMemoHeader do begin
          SetRange("Bill-to Customer No.",CustNo);
          SetFilter("Posting Date",GetCurrentYearFilter);

          Page.Run(Page::"Posted Sales Credit Memos",SalesCrMemoHeader);
        end;
    end;


    procedure DrillDownOnOrders(CustNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        with SalesHeader do begin
          SetRange("Bill-to Customer No.",CustNo);
          SetRange("Document Type","document type"::Order);

          Page.Run(Page::"Sales Order List",SalesHeader);
        end;
    end;


    procedure DrillDownOnQuotes(CustNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        with SalesHeader do begin
          SetRange("Bill-to Customer No.",CustNo);
          SetRange("Document Type","document type"::Quote);

          Page.Run(Page::"Sales Quotes",SalesHeader);
        end;
    end;


    procedure DrillDownMoneyOwedExpected(CustNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        SetFilterForUnpostedDocs(SalesHeader,CustNo,-1);
        Page.Run(Page::"Sales Credit Memos",SalesHeader)
    end;


    procedure DrillDownOnUnpostedInvoices(CustNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        SetFilterForUnpostedDocs(SalesHeader,CustNo,SalesHeader."document type"::Invoice);
        Page.Run(Page::"Sales Invoice List",SalesHeader)
    end;


    procedure DrillDownOnUnpostedCrMemos(CustNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        SetFilterForUnpostedDocs(SalesHeader,CustNo,SalesHeader."document type"::"Credit Memo");
        Page.Run(Page::"Sales Credit Memos",SalesHeader)
    end;

    local procedure SetFilterForUnpostedDocs(var SalesHeader: Record "Sales Header";CustNo: Code[20];DocumentType: Integer)
    begin
        with SalesHeader do begin
          SetRange("Bill-to Customer No.",CustNo);
          SetFilter("Posting Date",GetCurrentYearFilter);

          if DocumentType = -1 then
            SetFilter("Document Type",'%1|%2',"document type"::Invoice,"document type"::"Credit Memo")
          else
            SetRange("Document Type",DocumentType);
        end;
    end;

    local procedure SetFilterForUnpostedLines(var SalesLine: Record "Sales Line";CustNo: Code[20];DocumentType: Integer;Posted: Boolean)
    begin
        with SalesLine do begin
          SetRange("Bill-to Customer No.",CustNo);
          if Posted then
            SetFilter("Posting Date",GetCurrentYearFilter);

          if DocumentType = -1 then
            SetFilter("Document Type",'%1|%2',"document type"::Invoice,"document type"::"Credit Memo")
          else
            SetRange("Document Type",DocumentType);
        end;
    end;

    local procedure SetFilterForPostedDocs(var CustLedgEntry: Record "Cust. Ledger Entry";CustNo: Code[20];DocumentType: Integer)
    begin
        with CustLedgEntry do begin
          SetRange("Customer No.",CustNo);
          SetFilter("Posting Date",GetCurrentYearFilter);
          SetRange("Document Type",DocumentType);
        end;
    end;


    procedure GetCurrentYearFilter(): Text[30]
    var
        DateFilterCalc: Codeunit "DateFilter-Calc";
        CustDateFilter: Text[30];
        CustDateName: Text[30];
    begin
        if FiscalYearTotals then
          DateFilterCalc.CreateAccountingPeriodFilter(CustDateFilter,CustDateName,WorkDate,0)
        else
          DateFilterCalc.CreateFiscalYearFilter(CustDateFilter,CustDateName,WorkDate,0);

        exit(CustDateFilter);
    end;


    procedure GetTotalSales(CustNo: Code[20]): Decimal
    var
        Totals: Decimal;
        AmountOnPostedInvoices: Decimal;
        AmountOnPostedCrMemos: Decimal;
        AmountOnOutstandingInvoices: Decimal;
        AmountOnOutstandingCrMemos: Decimal;
        NoPostedInvoices: Integer;
        NoPostedCrMemos: Integer;
        NoOutstandingInvoices: Integer;
        NoOutstandingCrMemos: Integer;
    begin
        AmountOnPostedInvoices := CalcAmountsOnPostedInvoices(CustNo,NoPostedInvoices);
        AmountOnPostedCrMemos := CalcAmountsOnPostedCrMemos(CustNo,NoPostedCrMemos);

        AmountOnOutstandingInvoices := CalculateAmountsOnUnpostedInvoices(CustNo,NoOutstandingInvoices);
        AmountOnOutstandingCrMemos := CalculateAmountsOnUnpostedCrMemos(CustNo,NoOutstandingCrMemos);

        Totals := AmountOnPostedInvoices + AmountOnPostedCrMemos + AmountOnOutstandingInvoices + AmountOnOutstandingCrMemos;
        exit(Totals)
    end;


    procedure GetYTDSales(CustNo: Code[20]): Decimal
    var
        Totals: Decimal;
    begin
        FiscalYearTotals := true;
        Totals := GetTotalSales(CustNo);
        FiscalYearTotals := false;
        exit(Totals);
    end;
}

