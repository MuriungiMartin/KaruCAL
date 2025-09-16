#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5807 "Item Charge Assgnt. (Sales)"
{
    Permissions = TableData "Sales Header"=r,
                  TableData "Sales Line"=r,
                  TableData "Sales Shipment Line"=r,
                  TableData "Item Charge Assignment (Sales)"=imd,
                  TableData "Return Receipt Line"=r;

    trigger OnRun()
    begin
    end;

    var
        Text000: label '&Equally,&Amount';


    procedure InsertItemChargeAssgnt(ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";ApplToDocType: Option;ApplToDocNo2: Code[20];ApplToDocLineNo2: Integer;ItemNo2: Code[20];Description2: Text[50];var NextLineNo: Integer)
    var
        ItemChargeAssgntSales2: Record "Item Charge Assignment (Sales)";
    begin
        NextLineNo := NextLineNo + 10000;

        ItemChargeAssgntSales2.Init;
        ItemChargeAssgntSales2."Document Type" := ItemChargeAssgntSales."Document Type";
        ItemChargeAssgntSales2."Document No." := ItemChargeAssgntSales."Document No.";
        ItemChargeAssgntSales2."Document Line No." := ItemChargeAssgntSales."Document Line No.";
        ItemChargeAssgntSales2."Line No." := NextLineNo;
        ItemChargeAssgntSales2."Item Charge No." := ItemChargeAssgntSales."Item Charge No.";
        ItemChargeAssgntSales2."Applies-to Doc. Type" := ApplToDocType;
        ItemChargeAssgntSales2."Applies-to Doc. No." := ApplToDocNo2;
        ItemChargeAssgntSales2."Applies-to Doc. Line No." := ApplToDocLineNo2;
        ItemChargeAssgntSales2."Item No." := ItemNo2;
        ItemChargeAssgntSales2.Description := Description2;
        ItemChargeAssgntSales2."Unit Cost" := ItemChargeAssgntSales."Unit Cost";
        ItemChargeAssgntSales2.Insert;
    end;


    procedure CreateDocChargeAssgn(LastItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";ShipmentNo: Code[20])
    var
        FromSalesLine: Record "Sales Line";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        NextLineNo: Integer;
    begin
        with LastItemChargeAssgntSales do begin
          FromSalesLine.SetRange("Document Type","Document Type");
          FromSalesLine.SetRange("Document No.","Document No.");
          FromSalesLine.SetRange(Type,FromSalesLine.Type::Item);
          if FromSalesLine.Find('-') then begin
            NextLineNo := "Line No.";
            ItemChargeAssgntSales.SetRange("Document Type","Document Type");
            ItemChargeAssgntSales.SetRange("Document No.","Document No.");
            ItemChargeAssgntSales.SetRange("Document Line No.","Document Line No.");
            ItemChargeAssgntSales.SetRange("Applies-to Doc. No.","Document No.");
            repeat
              if (FromSalesLine.Quantity <> 0) and
                 (FromSalesLine.Quantity <> FromSalesLine."Quantity Invoiced") and
                 (FromSalesLine."Job No." = '') and
                 ((ShipmentNo = '') or (FromSalesLine."Shipment No." = ShipmentNo)) and
                 FromSalesLine."Allow Item Charge Assignment"
              then begin
                ItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.",FromSalesLine."Line No.");
                if not ItemChargeAssgntSales.FindFirst then
                  InsertItemChargeAssgnt(
                    LastItemChargeAssgntSales,FromSalesLine."Document Type",
                    FromSalesLine."Document No.",FromSalesLine."Line No.",
                    FromSalesLine."No.",FromSalesLine.Description,NextLineNo);
              end;
            until FromSalesLine.Next = 0;
          end;
        end;
    end;


    procedure CreateShptChargeAssgnt(var FromSalesShptLine: Record "Sales Shipment Line";ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    var
        ItemChargeAssgntSales2: Record "Item Charge Assignment (Sales)";
        Nextline: Integer;
    begin
        Nextline := ItemChargeAssgntSales."Line No.";
        ItemChargeAssgntSales2.SetRange("Document Type",ItemChargeAssgntSales."Document Type");
        ItemChargeAssgntSales2.SetRange("Document No.",ItemChargeAssgntSales."Document No.");
        ItemChargeAssgntSales2.SetRange("Document Line No.",ItemChargeAssgntSales."Document Line No.");
        ItemChargeAssgntSales2.SetRange(
          "Applies-to Doc. Type",ItemChargeAssgntSales2."applies-to doc. type"::Shipment);
        repeat
          FromSalesShptLine.TestField("Job No.",'');
          ItemChargeAssgntSales2.SetRange("Applies-to Doc. No.",FromSalesShptLine."Document No.");
          ItemChargeAssgntSales2.SetRange("Applies-to Doc. Line No.",FromSalesShptLine."Line No.");
          if not ItemChargeAssgntSales2.FindFirst then
            InsertItemChargeAssgnt(ItemChargeAssgntSales,ItemChargeAssgntSales2."applies-to doc. type"::Shipment,
              FromSalesShptLine."Document No.",FromSalesShptLine."Line No.",
              FromSalesShptLine."No.",FromSalesShptLine.Description,Nextline);
        until FromSalesShptLine.Next = 0;
    end;


    procedure CreateRcptChargeAssgnt(var FromReturnRcptLine: Record "Return Receipt Line";ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    var
        ItemChargeAssgntSales2: Record "Item Charge Assignment (Sales)";
        Nextline: Integer;
    begin
        Nextline := ItemChargeAssgntSales."Line No.";
        ItemChargeAssgntSales2.SetRange("Document Type",ItemChargeAssgntSales."Document Type");
        ItemChargeAssgntSales2.SetRange("Document No.",ItemChargeAssgntSales."Document No.");
        ItemChargeAssgntSales2.SetRange("Document Line No.",ItemChargeAssgntSales."Document Line No.");
        ItemChargeAssgntSales2.SetRange(
          "Applies-to Doc. Type",ItemChargeAssgntSales2."applies-to doc. type"::"Return Receipt");
        repeat
          FromReturnRcptLine.TestField("Job No.",'');
          ItemChargeAssgntSales2.SetRange("Applies-to Doc. No.",FromReturnRcptLine."Document No.");
          ItemChargeAssgntSales2.SetRange("Applies-to Doc. Line No.",FromReturnRcptLine."Line No.");
          if not ItemChargeAssgntSales2.FindFirst then
            InsertItemChargeAssgnt(ItemChargeAssgntSales,ItemChargeAssgntSales2."applies-to doc. type"::"Return Receipt",
              FromReturnRcptLine."Document No.",FromReturnRcptLine."Line No.",
              FromReturnRcptLine."No.",FromReturnRcptLine.Description,Nextline);
        until FromReturnRcptLine.Next = 0;
    end;


    procedure SuggestAssignment(SalesLine2: Record "Sales Line";TotalQtyToAssign: Decimal;TotalAmtToAssign: Decimal)
    var
        Selection: Integer;
    begin
        Selection := StrMenu(Text000,2);
        if Selection = 0 then
          exit;
        SuggestAssignment2(SalesLine2,TotalQtyToAssign,TotalAmtToAssign,Selection);
    end;


    procedure SuggestAssignment2(SalesLine2: Record "Sales Line";TotalQtyToAssign: Decimal;TotalAmtToAssign: Decimal;Selection: Integer)
    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        ItemChargeAssgntSales2: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        CurrencyCode: Code[10];
        TotalAppliesToDocLineAmount: Decimal;
        RemainingNumOfLines: Integer;
    begin
        with SalesLine2 do begin
          SalesHeader.Get("Document Type","Document No.");
          if not Currency.Get("Currency Code") then
            Currency.InitRoundingPrecision;
          ItemChargeAssgntSales2.SetRange("Document Type","Document Type");
          ItemChargeAssgntSales2.SetRange("Document No.","Document No.");
          ItemChargeAssgntSales2.SetRange("Document Line No.","Line No.");
          if ItemChargeAssgntSales2.Find('-') then begin
            if Selection = 1 then begin
              repeat
                if not ItemChargeAssgntSales2.SalesLineInvoiced then begin
                  TempItemChargeAssgntSales.Init;
                  TempItemChargeAssgntSales := ItemChargeAssgntSales2;
                  TempItemChargeAssgntSales.Insert;
                end;
              until ItemChargeAssgntSales2.Next = 0;

              if TempItemChargeAssgntSales.Find('-') then begin
                RemainingNumOfLines := TempItemChargeAssgntSales.Count;
                repeat
                  ItemChargeAssgntSales2.Get(
                    TempItemChargeAssgntSales."Document Type",
                    TempItemChargeAssgntSales."Document No.",
                    TempItemChargeAssgntSales."Document Line No.",
                    TempItemChargeAssgntSales."Line No.");
                  ItemChargeAssgntSales2."Qty. to Assign" := ROUND(TotalQtyToAssign / RemainingNumOfLines,0.00001);
                  ItemChargeAssgntSales2."Amount to Assign" :=
                    ROUND(
                      ItemChargeAssgntSales2."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                      Currency."Amount Rounding Precision");
                  TotalQtyToAssign -= ItemChargeAssgntSales2."Qty. to Assign";
                  TotalAmtToAssign -= ItemChargeAssgntSales2."Amount to Assign";
                  RemainingNumOfLines := RemainingNumOfLines - 1;
                  ItemChargeAssgntSales2.Modify;
                until TempItemChargeAssgntSales.Next = 0;
              end;
            end else begin
              repeat
                if not ItemChargeAssgntSales2.SalesLineInvoiced then begin
                  TempItemChargeAssgntSales.Init;
                  TempItemChargeAssgntSales := ItemChargeAssgntSales2;
                  case ItemChargeAssgntSales2."Applies-to Doc. Type" of
                    ItemChargeAssgntSales2."applies-to doc. type"::Quote,
                    ItemChargeAssgntSales2."applies-to doc. type"::Order,
                    ItemChargeAssgntSales2."applies-to doc. type"::Invoice,
                    ItemChargeAssgntSales2."applies-to doc. type"::"Return Order",
                    ItemChargeAssgntSales2."applies-to doc. type"::"Credit Memo":
                      begin
                        SalesLine.Get(
                          ItemChargeAssgntSales2."Applies-to Doc. Type",
                          ItemChargeAssgntSales2."Applies-to Doc. No.",
                          ItemChargeAssgntSales2."Applies-to Doc. Line No.");
                        TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                          Abs(SalesLine."Line Amount");
                      end;
                    ItemChargeAssgntSales2."applies-to doc. type"::"Return Receipt":
                      begin
                        ReturnRcptLine.Get(
                          ItemChargeAssgntSales2."Applies-to Doc. No.",
                          ItemChargeAssgntSales2."Applies-to Doc. Line No.");
                        CurrencyCode := ReturnRcptLine.GetCurrencyCode;
                        if CurrencyCode = SalesHeader."Currency Code" then
                          TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                            Abs(ReturnRcptLine."Item Charge Base Amount")
                        else
                          TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              SalesHeader."Posting Date",CurrencyCode,SalesHeader."Currency Code",
                              Abs(ReturnRcptLine."Item Charge Base Amount"));
                      end;
                    ItemChargeAssgntSales2."applies-to doc. type"::Shipment:
                      begin
                        SalesShptLine.Get(
                          ItemChargeAssgntSales2."Applies-to Doc. No.",
                          ItemChargeAssgntSales2."Applies-to Doc. Line No.");
                        CurrencyCode := SalesShptLine.GetCurrencyCode;
                        if CurrencyCode = SalesHeader."Currency Code" then
                          TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                            Abs(SalesShptLine."Item Charge Base Amount")
                        else
                          TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              SalesHeader."Posting Date",CurrencyCode,SalesHeader."Currency Code",
                              Abs(SalesShptLine."Item Charge Base Amount"));
                      end;
                  end;
                  if TempItemChargeAssgntSales."Applies-to Doc. Line Amount" <> 0 then
                    TempItemChargeAssgntSales.Insert
                  else begin
                    ItemChargeAssgntSales2."Amount to Assign" := 0;
                    ItemChargeAssgntSales2."Qty. to Assign" := 0;
                    ItemChargeAssgntSales2.Modify;
                  end;
                  TotalAppliesToDocLineAmount += TempItemChargeAssgntSales."Applies-to Doc. Line Amount";
                end;
              until ItemChargeAssgntSales2.Next = 0;

              if TempItemChargeAssgntSales.Find('-') then
                repeat
                  ItemChargeAssgntSales2.Get(
                    TempItemChargeAssgntSales."Document Type",
                    TempItemChargeAssgntSales."Document No.",
                    TempItemChargeAssgntSales."Document Line No.",
                    TempItemChargeAssgntSales."Line No.");
                  if TotalQtyToAssign <> 0 then begin
                    ItemChargeAssgntSales2."Qty. to Assign" :=
                      ROUND(
                        TempItemChargeAssgntSales."Applies-to Doc. Line Amount" / TotalAppliesToDocLineAmount * TotalQtyToAssign,
                        0.00001);
                    ItemChargeAssgntSales2."Amount to Assign" :=
                      ROUND(
                        ItemChargeAssgntSales2."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                        Currency."Amount Rounding Precision");
                    TotalQtyToAssign -= ItemChargeAssgntSales2."Qty. to Assign";
                    TotalAmtToAssign -= ItemChargeAssgntSales2."Amount to Assign";
                    TotalAppliesToDocLineAmount -= TempItemChargeAssgntSales."Applies-to Doc. Line Amount";
                    ItemChargeAssgntSales2.Modify;
                  end;
                until TempItemChargeAssgntSales.Next = 0;
            end;
            TempItemChargeAssgntSales.DeleteAll;
          end;
        end;
    end;


    procedure SuggestAssignmentFromLine(var FromItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)")
    var
        Currency: Record Currency;
        SalesHeader: Record "Sales Header";
        ItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        TotalAmountToAssign: Decimal;
        TotalQtyToAssign: Decimal;
        ItemChargeAssgntLineAmt: Decimal;
        ItemChargeAssgntLineQty: Decimal;
    begin
        with FromItemChargeAssignmentSales do begin
          SalesHeader.Get("Document Type","Document No.");
          if not Currency.Get(SalesHeader."Currency Code") then
            Currency.InitRoundingPrecision;

          GetItemChargeAssgntLineAmounts(
            "Document Type","Document No.","Document Line No.",
            ItemChargeAssgntLineQty,ItemChargeAssgntLineAmt);

          if not ItemChargeAssignmentSales.Get("Document Type","Document No.","Document Line No.","Line No.") then
            exit;

          ItemChargeAssignmentSales."Qty. to Assign" := "Qty. to Assign";
          ItemChargeAssignmentSales."Amount to Assign" := "Amount to Assign";
          ItemChargeAssignmentSales.Modify;

          ItemChargeAssignmentSales.SetRange("Document Type","Document Type");
          ItemChargeAssignmentSales.SetRange("Document No.","Document No.");
          ItemChargeAssignmentSales.SetRange("Document Line No.","Document Line No.");
          ItemChargeAssignmentSales.CalcSums("Qty. to Assign","Amount to Assign");
          TotalQtyToAssign := ItemChargeAssignmentSales."Qty. to Assign";
          TotalAmountToAssign := ItemChargeAssignmentSales."Amount to Assign";

          if TotalAmountToAssign = ItemChargeAssgntLineAmt then
            exit;

          if TotalQtyToAssign = ItemChargeAssgntLineQty then begin
            TotalAmountToAssign := ItemChargeAssgntLineAmt;
            ItemChargeAssignmentSales.FindSet;
            repeat
              if not ItemChargeAssignmentSales.SalesLineInvoiced then begin
                TempItemChargeAssgntSales := ItemChargeAssignmentSales;
                TempItemChargeAssgntSales.Insert;
              end;
            until ItemChargeAssignmentSales.Next = 0;

            if TempItemChargeAssgntSales.FindSet then begin
              repeat
                ItemChargeAssignmentSales.Get(
                  TempItemChargeAssgntSales."Document Type",
                  TempItemChargeAssgntSales."Document No.",
                  TempItemChargeAssgntSales."Document Line No.",
                  TempItemChargeAssgntSales."Line No.");
                if TotalQtyToAssign <> 0 then begin
                  ItemChargeAssignmentSales."Amount to Assign" :=
                    ROUND(
                      ItemChargeAssignmentSales."Qty. to Assign" / TotalQtyToAssign * TotalAmountToAssign,
                      Currency."Amount Rounding Precision");
                  TotalQtyToAssign -= ItemChargeAssignmentSales."Qty. to Assign";
                  TotalAmountToAssign -= ItemChargeAssignmentSales."Amount to Assign";
                  ItemChargeAssignmentSales.Modify;
                end;
              until TempItemChargeAssgntSales.Next = 0;
            end;
          end;

          ItemChargeAssignmentSales.Get("Document Type","Document No.","Document Line No.","Line No.");
        end;

        FromItemChargeAssignmentSales := ItemChargeAssignmentSales;
    end;

    local procedure GetItemChargeAssgntLineAmounts(DocumentType: Option;DocumentNo: Code[20];DocumentLineNo: Integer;var ItemChargeAssgntLineQty: Decimal;var ItemChargeAssgntLineAmt: Decimal)
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
    begin
        SalesHeader.Get(DocumentType,DocumentNo);
        if SalesHeader."Currency Code" = '' then
          Currency.InitRoundingPrecision
        else
          Currency.Get(SalesHeader."Currency Code");

        with SalesLine do begin
          Get(DocumentType,DocumentNo,DocumentLineNo);
          TestField(Type,Type::"Charge (Item)");
          TestField("No.");
          TestField(Quantity);

          if ("Inv. Discount Amount" = 0) and
             ("Line Discount Amount" = 0) and
             (not SalesHeader."Prices Including VAT")
          then
            ItemChargeAssgntLineAmt := "Line Amount"
          else
            if SalesHeader."Prices Including VAT" then
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

