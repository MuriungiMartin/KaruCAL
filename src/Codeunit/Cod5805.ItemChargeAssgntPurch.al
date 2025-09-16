#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5805 "Item Charge Assgnt. (Purch.)"
{
    Permissions = TableData "Purchase Header"=r,
                  TableData "Purchase Line"=r,
                  TableData "Purch. Rcpt. Line"=r,
                  TableData "Item Charge Assignment (Purch)"=imd,
                  TableData "Return Shipment Line"=r;

    trigger OnRun()
    begin
    end;

    var
        Text000: label '&Equally,&Amount';


    procedure InsertItemChargeAssgnt(ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";ApplToDocType: Option;ApplToDocNo2: Code[20];ApplToDocLineNo2: Integer;ItemNo2: Code[20];Description2: Text[50];var NextLineNo: Integer)
    var
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
    begin
        NextLineNo := NextLineNo + 10000;

        ItemChargeAssgntPurch2.Init;
        ItemChargeAssgntPurch2."Document Type" := ItemChargeAssgntPurch."Document Type";
        ItemChargeAssgntPurch2."Document No." := ItemChargeAssgntPurch."Document No.";
        ItemChargeAssgntPurch2."Document Line No." := ItemChargeAssgntPurch."Document Line No.";
        ItemChargeAssgntPurch2."Line No." := NextLineNo;
        ItemChargeAssgntPurch2."Item Charge No." := ItemChargeAssgntPurch."Item Charge No.";
        ItemChargeAssgntPurch2."Applies-to Doc. Type" := ApplToDocType;
        ItemChargeAssgntPurch2."Applies-to Doc. No." := ApplToDocNo2;
        ItemChargeAssgntPurch2."Applies-to Doc. Line No." := ApplToDocLineNo2;
        ItemChargeAssgntPurch2."Item No." := ItemNo2;
        ItemChargeAssgntPurch2.Description := Description2;
        ItemChargeAssgntPurch2."Unit Cost" := ItemChargeAssgntPurch."Unit Cost";
        ItemChargeAssgntPurch2.Insert;
    end;


    procedure CreateDocChargeAssgnt(LastItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";ReceiptNo: Code[20])
    var
        FromPurchLine: Record "Purchase Line";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        NextLineNo: Integer;
    begin
        with LastItemChargeAssgntPurch do begin
          FromPurchLine.SetRange("Document Type","Document Type");
          FromPurchLine.SetRange("Document No.","Document No.");
          FromPurchLine.SetRange(Type,FromPurchLine.Type::Item);
          if FromPurchLine.Find('-') then begin
            NextLineNo := "Line No.";
            ItemChargeAssgntPurch.Reset;
            ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
            ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
            ItemChargeAssgntPurch.SetRange("Document Line No.","Document Line No.");
            ItemChargeAssgntPurch.SetRange("Applies-to Doc. No.","Document No.");
            repeat
              if (FromPurchLine.Quantity <> 0) and
                 (FromPurchLine.Quantity <> FromPurchLine."Quantity Invoiced") and
                 (FromPurchLine."Work Center No." = '') and
                 ((ReceiptNo = '') or (FromPurchLine."Receipt No." = ReceiptNo)) and
                 FromPurchLine."Allow Item Charge Assignment"
              then begin
                ItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.",FromPurchLine."Line No.");
                if not ItemChargeAssgntPurch.FindFirst then
                  InsertItemChargeAssgnt(
                    LastItemChargeAssgntPurch,FromPurchLine."Document Type",
                    FromPurchLine."Document No.",FromPurchLine."Line No.",
                    FromPurchLine."No.",FromPurchLine.Description,NextLineNo);
              end;
            until FromPurchLine.Next = 0;
          end;
        end;
    end;


    procedure CreateRcptChargeAssgnt(var FromPurchRcptLine: Record "Purch. Rcpt. Line";ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        NextLine: Integer;
    begin
        FromPurchRcptLine.TestField("Work Center No.",'');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SetRange("Document Type",ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.",ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SetRange(
          "Applies-to Doc. Type",ItemChargeAssgntPurch2."applies-to doc. type"::Receipt);
        repeat
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.",FromPurchRcptLine."Document No.");
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.",FromPurchRcptLine."Line No.");
          if not ItemChargeAssgntPurch2.FindFirst then
            InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."applies-to doc. type"::Receipt,
              FromPurchRcptLine."Document No.",FromPurchRcptLine."Line No.",
              FromPurchRcptLine."No.",FromPurchRcptLine.Description,NextLine);
        until FromPurchRcptLine.Next = 0;
    end;


    procedure CreateTransferRcptChargeAssgnt(var FromTransRcptLine: Record "Transfer Receipt Line";ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        NextLine: Integer;
    begin
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SetRange("Document Type",ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.",ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SetRange(
          "Applies-to Doc. Type",ItemChargeAssgntPurch2."applies-to doc. type"::"Transfer Receipt");
        repeat
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.",FromTransRcptLine."Document No.");
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.",FromTransRcptLine."Line No.");
          if not ItemChargeAssgntPurch2.FindFirst then
            InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."applies-to doc. type"::"Transfer Receipt",
              FromTransRcptLine."Document No.",FromTransRcptLine."Line No.",
              FromTransRcptLine."Item No.",FromTransRcptLine.Description,NextLine);
        until FromTransRcptLine.Next = 0;
    end;


    procedure CreateShptChargeAssgnt(var FromReturnShptLine: Record "Return Shipment Line";ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        NextLine: Integer;
    begin
        FromReturnShptLine.TestField("Job No.",'');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SetRange("Document Type",ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.",ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SetRange(
          "Applies-to Doc. Type",ItemChargeAssgntPurch2."applies-to doc. type"::"Return Shipment");
        repeat
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.",FromReturnShptLine."Document No.");
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.",FromReturnShptLine."Line No.");
          if not ItemChargeAssgntPurch2.FindFirst then
            InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."applies-to doc. type"::"Return Shipment",
              FromReturnShptLine."Document No.",FromReturnShptLine."Line No.",
              FromReturnShptLine."No.",FromReturnShptLine.Description,NextLine);
        until FromReturnShptLine.Next = 0;
    end;


    procedure CreateSalesShptChargeAssgnt(var FromSalesShptLine: Record "Sales Shipment Line";ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        NextLine: Integer;
    begin
        FromSalesShptLine.TestField("Job No.",'');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SetRange("Document Type",ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.",ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SetRange(
          "Applies-to Doc. Type",ItemChargeAssgntPurch2."applies-to doc. type"::"Sales Shipment");
        repeat
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.",FromSalesShptLine."Document No.");
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.",FromSalesShptLine."Line No.");
          if not ItemChargeAssgntPurch2.FindFirst then
            InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."applies-to doc. type"::"Sales Shipment",
              FromSalesShptLine."Document No.",FromSalesShptLine."Line No.",
              FromSalesShptLine."No.",FromSalesShptLine.Description,NextLine);
        until FromSalesShptLine.Next = 0;
    end;


    procedure CreateReturnRcptChargeAssgnt(var FromReturnRcptLine: Record "Return Receipt Line";ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        NextLine: Integer;
    begin
        FromReturnRcptLine.TestField("Job No.",'');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SetRange("Document Type",ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.",ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.",ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SetRange(
          "Applies-to Doc. Type",ItemChargeAssgntPurch2."applies-to doc. type"::"Return Receipt");
        repeat
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.",FromReturnRcptLine."Document No.");
          ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.",FromReturnRcptLine."Line No.");
          if not ItemChargeAssgntPurch2.FindFirst then
            InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."applies-to doc. type"::"Return Receipt",
              FromReturnRcptLine."Document No.",FromReturnRcptLine."Line No.",
              FromReturnRcptLine."No.",FromReturnRcptLine.Description,NextLine);
        until FromReturnRcptLine.Next = 0;
    end;


    procedure SuggestAssgnt(PurchLine: Record "Purchase Line";TotalQtyToAssign: Decimal;TotalAmtToAssign: Decimal)
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        Selection: Integer;
    begin
        with PurchLine do begin
          ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
          ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
          ItemChargeAssgntPurch.SetRange("Document Line No.","Line No.");
        end;
        if ItemChargeAssgntPurch.IsEmpty then
          exit;

        ItemChargeAssgntPurch.SetFilter("Applies-to Doc. Type",'<>%1',ItemChargeAssgntPurch."applies-to doc. type"::"Transfer Receipt");
        if ItemChargeAssgntPurch.IsEmpty then
          Selection := 1
        else
          Selection := StrMenu(Text000,2);

        if Selection = 0 then
          exit;

        SuggestAssgnt2(PurchLine,TotalQtyToAssign,TotalAmtToAssign,Selection);
    end;


    procedure SuggestAssgnt2(PurchLine2: Record "Purchase Line";TotalQtyToAssign: Decimal;TotalAmtToAssign: Decimal;Selection: Integer)
    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReturnShptLine: Record "Return Shipment Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary;
        CurrencyCode: Code[10];
        TotalAppliesToDocLineAmount: Decimal;
        RemainingNumOfLines: Integer;
    begin
        with PurchLine2 do begin
          PurchHeader.Get("Document Type","Document No.");
          if not Currency.Get("Currency Code") then
            Currency.InitRoundingPrecision;
          ItemChargeAssgntPurch2.SetRange("Document Type","Document Type");
          ItemChargeAssgntPurch2.SetRange("Document No.","Document No.");
          ItemChargeAssgntPurch2.SetRange("Document Line No.","Line No.");
          if ItemChargeAssgntPurch2.Find('-') then begin
            if Selection = 1 then begin
              repeat
                if not ItemChargeAssgntPurch2.PurchLineInvoiced then begin
                  TempItemChargeAssgntPurch.Init;
                  TempItemChargeAssgntPurch := ItemChargeAssgntPurch2;
                  TempItemChargeAssgntPurch.Insert;
                end;
              until ItemChargeAssgntPurch2.Next = 0;

              if TempItemChargeAssgntPurch.Find('-') then begin
                RemainingNumOfLines := TempItemChargeAssgntPurch.Count;
                repeat
                  ItemChargeAssgntPurch2.Get(
                    TempItemChargeAssgntPurch."Document Type",
                    TempItemChargeAssgntPurch."Document No.",
                    TempItemChargeAssgntPurch."Document Line No.",
                    TempItemChargeAssgntPurch."Line No.");
                  ItemChargeAssgntPurch2."Qty. to Assign" := ROUND(TotalQtyToAssign / RemainingNumOfLines,0.00001);
                  ItemChargeAssgntPurch2."Amount to Assign" :=
                    ROUND(
                      ItemChargeAssgntPurch2."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                      Currency."Amount Rounding Precision");
                  TotalQtyToAssign -= ItemChargeAssgntPurch2."Qty. to Assign";
                  TotalAmtToAssign -= ItemChargeAssgntPurch2."Amount to Assign";
                  RemainingNumOfLines := RemainingNumOfLines - 1;
                  ItemChargeAssgntPurch2.Modify;
                until TempItemChargeAssgntPurch.Next = 0;
              end;
            end else begin
              repeat
                if not ItemChargeAssgntPurch2.PurchLineInvoiced then begin
                  TempItemChargeAssgntPurch.Init;
                  TempItemChargeAssgntPurch := ItemChargeAssgntPurch2;
                  case ItemChargeAssgntPurch2."Applies-to Doc. Type" of
                    ItemChargeAssgntPurch2."applies-to doc. type"::Quote,
                    ItemChargeAssgntPurch2."applies-to doc. type"::Order,
                    ItemChargeAssgntPurch2."applies-to doc. type"::Invoice,
                    ItemChargeAssgntPurch2."applies-to doc. type"::"Return Order",
                    ItemChargeAssgntPurch2."applies-to doc. type"::"Credit Memo":
                      begin
                        PurchLine.Get(
                          ItemChargeAssgntPurch2."Applies-to Doc. Type",
                          ItemChargeAssgntPurch2."Applies-to Doc. No.",
                          ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                          Abs(PurchLine."Line Amount");
                      end;
                    ItemChargeAssgntPurch2."applies-to doc. type"::Receipt:
                      begin
                        PurchRcptLine.Get(
                          ItemChargeAssgntPurch2."Applies-to Doc. No.",
                          ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                        CurrencyCode := PurchRcptLine.GetCurrencyCodeFromHeader;
                        if CurrencyCode = PurchHeader."Currency Code" then
                          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                            Abs(PurchRcptLine."Item Charge Base Amount")
                        else
                          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                              Abs(PurchRcptLine."Item Charge Base Amount"));
                      end;
                    ItemChargeAssgntPurch2."applies-to doc. type"::"Return Shipment":
                      begin
                        ReturnShptLine.Get(
                          ItemChargeAssgntPurch2."Applies-to Doc. No.",
                          ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                        CurrencyCode := ReturnShptLine.GetCurrencyCode;
                        if CurrencyCode = PurchHeader."Currency Code" then
                          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                            Abs(ReturnShptLine."Item Charge Base Amount")
                        else
                          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                              Abs(ReturnShptLine."Item Charge Base Amount"));
                      end;
                    ItemChargeAssgntPurch2."applies-to doc. type"::"Sales Shipment":
                      begin
                        SalesShptLine.Get(
                          ItemChargeAssgntPurch2."Applies-to Doc. No.",
                          ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                        CurrencyCode := SalesShptLine.GetCurrencyCode;
                        if CurrencyCode = PurchHeader."Currency Code" then
                          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                            Abs(SalesShptLine."Item Charge Base Amount")
                        else
                          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                              Abs(SalesShptLine."Item Charge Base Amount"));
                      end;
                    ItemChargeAssgntPurch2."applies-to doc. type"::"Return Receipt":
                      begin
                        ReturnRcptLine.Get(
                          ItemChargeAssgntPurch2."Applies-to Doc. No.",
                          ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                        CurrencyCode := ReturnRcptLine.GetCurrencyCode;
                        if CurrencyCode = PurchHeader."Currency Code" then
                          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                            Abs(ReturnRcptLine."Item Charge Base Amount")
                        else
                          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                              Abs(ReturnRcptLine."Item Charge Base Amount"));
                      end;
                  end;
                  if TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" <> 0 then
                    TempItemChargeAssgntPurch.Insert
                  else begin
                    ItemChargeAssgntPurch2."Amount to Assign" := 0;
                    ItemChargeAssgntPurch2."Qty. to Assign" := 0;
                    ItemChargeAssgntPurch2.Modify;
                  end;
                  TotalAppliesToDocLineAmount += TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
                end;
              until ItemChargeAssgntPurch2.Next = 0;

              if TempItemChargeAssgntPurch.Find('-') then
                repeat
                  ItemChargeAssgntPurch2.Get(
                    TempItemChargeAssgntPurch."Document Type",
                    TempItemChargeAssgntPurch."Document No.",
                    TempItemChargeAssgntPurch."Document Line No.",
                    TempItemChargeAssgntPurch."Line No.");
                  if TotalQtyToAssign <> 0 then begin
                    ItemChargeAssgntPurch2."Qty. to Assign" :=
                      ROUND(TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" / TotalAppliesToDocLineAmount * TotalQtyToAssign,
                        0.00001);
                    ItemChargeAssgntPurch2."Amount to Assign" :=
                      ROUND(
                        ItemChargeAssgntPurch2."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                        Currency."Amount Rounding Precision");
                    TotalQtyToAssign -= ItemChargeAssgntPurch2."Qty. to Assign";
                    TotalAmtToAssign -= ItemChargeAssgntPurch2."Amount to Assign";
                    TotalAppliesToDocLineAmount -= TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
                    ItemChargeAssgntPurch2.Modify;
                  end;
                until TempItemChargeAssgntPurch.Next = 0;
            end;
            TempItemChargeAssgntPurch.DeleteAll;
          end;
        end;
    end;


    procedure SuggestAssgntFromLine(var FromItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)")
    var
        Currency: Record Currency;
        PurchHeader: Record "Purchase Header";
        ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary;
        TotalAmountToAssign: Decimal;
        TotalQtyToAssign: Decimal;
        ItemChargeAssgntLineAmt: Decimal;
        ItemChargeAssgntLineQty: Decimal;
    begin
        with FromItemChargeAssignmentPurch do begin
          PurchHeader.Get("Document Type","Document No.");
          if not Currency.Get(PurchHeader."Currency Code") then
            Currency.InitRoundingPrecision;

          GetItemChargeAssgntLineAmounts(
            "Document Type","Document No.","Document Line No.",
            ItemChargeAssgntLineQty,ItemChargeAssgntLineAmt);

          if not ItemChargeAssignmentPurch.Get("Document Type","Document No.","Document Line No.","Line No.") then
            exit;

          ItemChargeAssignmentPurch."Qty. to Assign" := "Qty. to Assign";
          ItemChargeAssignmentPurch."Amount to Assign" := "Amount to Assign";
          ItemChargeAssignmentPurch.Modify;

          ItemChargeAssignmentPurch.SetRange("Document Type","Document Type");
          ItemChargeAssignmentPurch.SetRange("Document No.","Document No.");
          ItemChargeAssignmentPurch.SetRange("Document Line No.","Document Line No.");
          ItemChargeAssignmentPurch.CalcSums("Qty. to Assign","Amount to Assign");
          TotalQtyToAssign := ItemChargeAssignmentPurch."Qty. to Assign";
          TotalAmountToAssign := ItemChargeAssignmentPurch."Amount to Assign";

          if TotalAmountToAssign = ItemChargeAssgntLineAmt then
            exit;

          if TotalQtyToAssign = ItemChargeAssgntLineQty then begin
            TotalAmountToAssign := ItemChargeAssgntLineAmt;
            ItemChargeAssignmentPurch.FindSet;
            repeat
              if not ItemChargeAssignmentPurch.PurchLineInvoiced then begin
                TempItemChargeAssgntPurch := ItemChargeAssignmentPurch;
                TempItemChargeAssgntPurch.Insert;
              end;
            until ItemChargeAssignmentPurch.Next = 0;

            if TempItemChargeAssgntPurch.FindSet then begin
              repeat
                ItemChargeAssignmentPurch.Get(
                  TempItemChargeAssgntPurch."Document Type",
                  TempItemChargeAssgntPurch."Document No.",
                  TempItemChargeAssgntPurch."Document Line No.",
                  TempItemChargeAssgntPurch."Line No.");
                if TotalQtyToAssign <> 0 then begin
                  ItemChargeAssignmentPurch."Amount to Assign" :=
                    ROUND(
                      ItemChargeAssignmentPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmountToAssign,
                      Currency."Amount Rounding Precision");
                  TotalQtyToAssign -= ItemChargeAssignmentPurch."Qty. to Assign";
                  TotalAmountToAssign -= ItemChargeAssignmentPurch."Amount to Assign";
                  ItemChargeAssignmentPurch.Modify;
                end;
              until TempItemChargeAssgntPurch.Next = 0;
            end;
          end;

          ItemChargeAssignmentPurch.Get("Document Type","Document No.","Document Line No.","Line No.");
        end;

        FromItemChargeAssignmentPurch := ItemChargeAssignmentPurch;
    end;

    local procedure GetItemChargeAssgntLineAmounts(DocumentType: Option;DocumentNo: Code[20];DocumentLineNo: Integer;var ItemChargeAssgntLineQty: Decimal;var ItemChargeAssgntLineAmt: Decimal)
    var
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        Currency: Record Currency;
    begin
        PurchHeader.Get(DocumentType,DocumentNo);
        if not Currency.Get(PurchHeader."Currency Code") then
          Currency.InitRoundingPrecision;

        with PurchLine do begin
          Get(DocumentType,DocumentNo,DocumentLineNo);
          TestField(Type,Type::"Charge (Item)");
          TestField("No.");
          TestField(Quantity);

          if ("Inv. Discount Amount" = 0) and
             ("Line Discount Amount" = 0) and
             (not PurchHeader."Prices Including VAT")
          then
            ItemChargeAssgntLineAmt := "Line Amount"
          else
            if PurchHeader."Prices Including VAT" then
              ItemChargeAssgntLineAmt :=
                ROUND(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                  Currency."Amount Rounding Precision")
            else
              ItemChargeAssgntLineAmt := "Line Amount" - "Inv. Discount Amount";

          ItemChargeAssgntLineAmt :=
            ROUND(
              ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
              Currency."Amount Rounding Precision");
          ItemChargeAssgntLineQty := "Qty. to Invoice";
        end;
    end;
}

