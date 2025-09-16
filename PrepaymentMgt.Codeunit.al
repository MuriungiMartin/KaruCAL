#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 441 "Prepayment Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure SetSalesPrepaymentPct(var SalesLine: Record "Sales Line";Date: Date)
    var
        Cust: Record Customer;
        SalesPrepaymentPct: Record "Sales Prepayment %";
    begin
        with SalesPrepaymentPct do begin
          if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."No." = '') or
             (SalesLine."Document Type" <> SalesLine."document type"::Order)
          then
            exit;
          SetFilter("Starting Date",'..%1',Date);
          SetFilter("Ending Date",'%1|>=%2',0D,Date);
          SetRange("Item No.",SalesLine."No.");
          for "Sales Type" := "sales type"::Customer to "sales type"::"All Customers" do begin
            SetRange("Sales Type","Sales Type");
            case "Sales Type" of
              "sales type"::Customer:
                begin
                  SetRange("Sales Code",SalesLine."Bill-to Customer No.");
                  if ApplySalesPrepaymentPct(SalesLine,SalesPrepaymentPct) then
                    exit;
                end;
              "sales type"::"Customer Price Group":
                begin
                  Cust.Get(SalesLine."Bill-to Customer No.");
                  if Cust."Customer Price Group" <> '' then
                    SetRange("Sales Code",Cust."Customer Price Group");
                  if ApplySalesPrepaymentPct(SalesLine,SalesPrepaymentPct) then
                    exit;
                end;
              "sales type"::"All Customers":
                begin
                  SetRange("Sales Code");
                  if ApplySalesPrepaymentPct(SalesLine,SalesPrepaymentPct) then
                    exit;
                end;
            end;
          end;
        end;
    end;

    local procedure ApplySalesPrepaymentPct(var SalesLine: Record "Sales Line";var SalesPrepaymentPct: Record "Sales Prepayment %"): Boolean
    begin
        with SalesPrepaymentPct do
          if FindLast then begin
            SalesLine."Prepayment %" := "Prepayment %";
            exit(true);
          end;
    end;


    procedure SetPurchPrepaymentPct(var PurchLine: Record "Purchase Line";Date: Date)
    var
        PurchPrepaymentPct: Record "Purchase Prepayment %";
    begin
        with PurchPrepaymentPct do begin
          if (PurchLine.Type <> PurchLine.Type::Item) or (PurchLine."No." = '') or
             (PurchLine."Document Type" <> PurchLine."document type"::Order )
          then
            exit;
          SetFilter("Starting Date",'..%1',Date);
          SetFilter("Ending Date",'%1|>=%2',0D,Date);
          SetRange("Item No.",PurchLine."No.");
          SetRange("Vendor No.",PurchLine."Pay-to Vendor No.");
          if ApplyPurchPrepaymentPct(PurchLine,PurchPrepaymentPct) then
            exit;

          // All Vendors
          SetRange("Vendor No.",'');
          if ApplyPurchPrepaymentPct(PurchLine,PurchPrepaymentPct) then
            exit;
        end;
    end;

    local procedure ApplyPurchPrepaymentPct(var PurchLine: Record "Purchase Line";var PurchPrepaymentPct: Record "Purchase Prepayment %"): Boolean
    begin
        with PurchPrepaymentPct do
          if FindLast then begin
            PurchLine."Prepayment %" := "Prepayment %";
            exit(true);
          end;
    end;


    procedure TestSalesPrepayment(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        SalesLine.SetFilter("Prepmt. Line Amount",'<>%1',0);
        if SalesLine.FindSet then
          repeat
            if SalesLine."Prepmt. Amt. Inv." <> SalesLine."Prepmt. Line Amount" then
              exit(true);
          until SalesLine.Next = 0;
    end;


    procedure TestPurchasePrepayment(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type",PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.",PurchaseHeader."No.");
        PurchaseLine.SetFilter("Prepmt. Line Amount",'<>%1',0);
        if PurchaseLine.FindSet then
          repeat
            if PurchaseLine."Prepmt. Amt. Inv." <> PurchaseLine."Prepmt. Line Amount" then
              exit(true);
          until PurchaseLine.Next = 0;
    end;


    procedure TestSalesPayment(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesSetup.Get;
        if not SalesSetup."Check Prepmt. when Posting" then
          exit(false);

        SalesInvHeader.SetCurrentkey("Prepayment Order No.","Prepayment Invoice");
        SalesInvHeader.SetRange("Prepayment Order No.",SalesHeader."No.");
        SalesInvHeader.SetRange("Prepayment Invoice",true);
        if SalesInvHeader.FindSet then
          repeat
            CustLedgerEntry.SetCurrentkey("Document No.");
            CustLedgerEntry.SetRange("Document Type",CustLedgerEntry."document type"::Invoice);
            CustLedgerEntry.SetRange("Document No.",SalesInvHeader."No.");
            CustLedgerEntry.SetFilter("Remaining Amt. (LCY)",'<>%1',0);
            if not CustLedgerEntry.IsEmpty then
              exit(true);
          until SalesInvHeader.Next = 0;

        exit(false);
    end;


    procedure TestPurchasePayment(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PurchasesPayablesSetup.Get;
        if not PurchasesPayablesSetup."Check Prepmt. when Posting" then
          exit(false);

        PurchInvHeader.SetCurrentkey("Prepayment Order No.","Prepayment Invoice");
        PurchInvHeader.SetRange("Prepayment Order No.",PurchaseHeader."No.");
        PurchInvHeader.SetRange("Prepayment Invoice",true);
        if PurchInvHeader.FindSet then
          repeat
            VendLedgerEntry.SetCurrentkey("Document No.");
            VendLedgerEntry.SetRange("Document Type",VendLedgerEntry."document type"::Invoice);
            VendLedgerEntry.SetRange("Document No.",PurchInvHeader."No.");
            VendLedgerEntry.SetFilter("Remaining Amt. (LCY)",'<>%1',0);
            if not VendLedgerEntry.IsEmpty then
              exit(true);
          until PurchInvHeader.Next = 0;

        exit(false);
    end;
}

