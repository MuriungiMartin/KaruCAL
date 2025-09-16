#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1312 "Vendor Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure CalcAmountsOnPostedInvoices(VendNo: Code[20];var RecCount: Integer): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        exit(CalcAmountsOnPostedDocs(VendNo,RecCount,VendorLedgerEntry."document type"::Invoice));
    end;


    procedure CalcAmountsOnPostedCrMemos(VendNo: Code[20];var RecCount: Integer): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        exit(CalcAmountsOnPostedDocs(VendNo,RecCount,VendorLedgerEntry."document type"::"Credit Memo"));
    end;


    procedure CalcAmountsOnPostedOrders(VendNo: Code[20];var RecCount: Integer): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        exit(CalcAmountsOnPostedDocs(VendNo,RecCount,VendorLedgerEntry."document type"::" "));
    end;


    procedure CalcAmountsOnUnpostedInvoices(VendNo: Code[20];var RecCount: Integer): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        exit(CalcAmountsOnUnpostedDocs(VendNo,RecCount,VendorLedgerEntry."document type"::Invoice));
    end;


    procedure CalcAmountsOnUnpostedCrMemos(VendNo: Code[20];var RecCount: Integer): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        exit(CalcAmountsOnUnpostedDocs(VendNo,RecCount,VendorLedgerEntry."document type"::"Credit Memo"));
    end;


    procedure DrillDownOnPostedInvoices(VendNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        with PurchInvHeader do begin
          SetRange("Buy-from Vendor No.",VendNo);
          SetFilter("Posting Date",GetCurrentYearFilter);

          Page.Run(Page::"Posted Purchase Invoices",PurchInvHeader);
        end;
    end;


    procedure DrillDownOnPostedCrMemo(VendNo: Code[20])
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        with PurchCrMemoHdr do begin
          SetRange("Buy-from Vendor No.",VendNo);
          SetFilter("Posting Date",GetCurrentYearFilter);

          Page.Run(Page::"Posted Purchase Credit Memos",PurchCrMemoHdr);
        end;
    end;


    procedure DrillDownOnPostedOrders(VendNo: Code[20])
    var
        PurchaseLine: Record "Purchase Line";
    begin
        with PurchaseLine do begin
          SetRange("Buy-from Vendor No.",VendNo);
          SetRange("Document Type","document type"::Order);
          SetFilter("Order Date",GetCurrentYearFilter);

          Page.Run(Page::"Purchase Orders",PurchaseLine);
        end;
    end;


    procedure DrillDownOnOutstandingInvoices(VendNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        SetFilterForUnpostedLines(PurchaseLine,VendNo,PurchaseHeader."document type"::Invoice);
        Page.Run(Page::"Purchase Invoices",PurchaseHeader);
    end;


    procedure DrillDownOnOutstandingCrMemos(VendNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        SetFilterForUnpostedLines(PurchaseLine,VendNo,PurchaseHeader."document type"::"Credit Memo");
        Page.Run(Page::"Purchase Credit Memos",PurchaseHeader);
    end;

    local procedure CalcAmountsOnPostedDocs(VendNo: Code[20];var RecCount: Integer;DocType: Integer): Decimal
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        with VendLedgEntry do begin
          SetFilterForPostedDocs(VendLedgEntry,VendNo,DocType);
          RecCount := Count;
          CalcSums("Purchase (LCY)");
          exit("Purchase (LCY)");
        end;
    end;

    local procedure CalcAmountsOnUnpostedDocs(VendNo: Code[20];var RecCount: Integer;DocType: Integer): Decimal
    var
        PurchaseLine: Record "Purchase Line";
        Result: Decimal;
        VAT: Decimal;
        OutstandingAmount: Decimal;
        OldDocumentNo: Code[20];
    begin
        RecCount := 0;
        Result := 0;

        SetFilterForUnpostedLines(PurchaseLine,VendNo,DocType);
        with PurchaseLine do begin
          if FindSet then
            repeat
              case "Document Type" of
                "document type"::Invoice:
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

    local procedure SetFilterForUnpostedLines(var PurchaseLine: Record "Purchase Line";VendNo: Code[20];DocumentType: Integer)
    begin
        with PurchaseLine do begin
          SetRange("Buy-from Vendor No.",VendNo);

          if DocumentType = -1 then
            SetFilter("Document Type",'%1|%2',"document type"::Invoice,"document type"::"Credit Memo")
          else
            SetRange("Document Type",DocumentType);
        end;
    end;

    local procedure SetFilterForPostedDocs(var VendLedgEntry: Record "Vendor Ledger Entry";VendNo: Code[20];DocumentType: Integer)
    begin
        with VendLedgEntry do begin
          SetRange("Buy-from Vendor No.",VendNo);
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
        DateFilterCalc.CreateFiscalYearFilter(CustDateFilter,CustDateName,WorkDate,0);
        exit(CustDateFilter);
    end;
}

