#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7181 "Purchases Info-Pane Management"
{

    trigger OnRun()
    begin
    end;

    var
        Item: Record Item;
        PurchHeader: Record "Purchase Header";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
        Vend: Record Vendor;
        Text000: label 'The Ship-to Address has been changed.';


    procedure CalcAvailability(var PurchLine: Record "Purchase Line"): Decimal
    var
        AvailableToPromise: Codeunit "Available to Promise";
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
    begin
        if GetItem(PurchLine) then begin
          if PurchLine."Expected Receipt Date" <> 0D then
            AvailabilityDate := PurchLine."Expected Receipt Date"
          else
            AvailabilityDate := WorkDate;

          Item.Reset;
          Item.SetRange("Date Filter",0D,AvailabilityDate);
          Item.SetRange("Variant Filter",PurchLine."Variant Code");
          Item.SetRange("Location Filter",PurchLine."Location Code");
          Item.SetRange("Drop Shipment Filter",false);

          exit(
            AvailableToPromise.QtyAvailabletoPromise(
              Item,
              GrossRequirement,
              ScheduledReceipt,
              AvailabilityDate,
              PeriodType,
              LookaheadDateformula));
        end;
    end;


    procedure CalcNoOfPurchasePrices(var PurchLine: Record "Purchase Line"): Integer
    begin
        if GetItem(PurchLine) then begin
          GetPurchHeader(PurchLine);
          exit(PurchPriceCalcMgt.NoOfPurchLinePrice(PurchHeader,PurchLine,true));
        end;
    end;


    procedure CalcNoOfPurchLineDisc(var PurchLine: Record "Purchase Line"): Integer
    begin
        if GetItem(PurchLine) then begin
          GetPurchHeader(PurchLine);
          exit(PurchPriceCalcMgt.NoOfPurchLineLineDisc(PurchHeader,PurchLine,true));
        end;
    end;

    local procedure GetItem(var PurchLine: Record "Purchase Line"): Boolean
    begin
        with Item do begin
          if (PurchLine.Type <> PurchLine.Type::Item) or (PurchLine."No." = '') then
            exit(false);

          if PurchLine."No." <> "No." then
            Get(PurchLine."No.");
          exit(true);
        end;
    end;

    local procedure GetPurchHeader(PurchLine: Record "Purchase Line")
    begin
        if (PurchLine."Document Type" <> PurchHeader."Document Type") or
           (PurchLine."Document No." <> PurchHeader."No.")
        then
          PurchHeader.Get(PurchLine."Document Type",PurchLine."Document No.");
    end;


    procedure CalcNoOfDocuments(var Vend: Record Vendor)
    begin
        Vend.CalcFields(
          "No. of Quotes","No. of Blanket Orders","No. of Orders","No. of Invoices",
          "No. of Return Orders","No. of Credit Memos","No. of Pstd. Return Shipments","No. of Pstd. Invoices",
          "No. of Pstd. Receipts","No. of Pstd. Credit Memos",
          "Buy-from No. Of Archived Doc.");
    end;


    procedure CalcTotalNoOfDocuments(VendNo: Code[20]): Integer
    begin
        GetVend(VendNo);
        with Vend do begin
          CalcNoOfDocuments(Vend);
          exit(
            "No. of Quotes" + "No. of Blanket Orders" + "No. of Orders" + "No. of Invoices" +
            "No. of Return Orders" + "No. of Credit Memos" +
            "No. of Pstd. Receipts" + "No. of Pstd. Invoices" +
            "No. of Pstd. Return Shipments" + "No. of Pstd. Credit Memos" +
            "Buy-from No. Of Archived Doc.");
        end;
    end;


    procedure CalcNoOfOrderAddr(VendNo: Code[20]): Integer
    begin
        GetVend(VendNo);
        Vend.CalcFields("No. of Order Addresses");
        exit(Vend."No. of Order Addresses");
    end;


    procedure CalcNoOfContacts(PurchHeader: Record "Purchase Header"): Integer
    var
        Cont: Record Contact;
        ContBusRelation: Record "Contact Business Relation";
    begin
        Cont.SetCurrentkey("Company No.");
        with PurchHeader do
          if "Buy-from Vendor No." <> '' then begin
            if Cont.Get("Buy-from Contact No.") then begin
              Cont.SetRange("Company No.",Cont."Company No.");
              exit(Cont.Count);
            end;
            ContBusRelation.Reset;
            ContBusRelation.SetCurrentkey("Link to Table","No.");
            ContBusRelation.SetRange("Link to Table",ContBusRelation."link to table"::Vendor);
            ContBusRelation.SetRange("No.","Buy-from Vendor No.");
            if ContBusRelation.FindFirst then begin
              Cont.SetRange("Company No.",ContBusRelation."Contact No.");
              exit(Cont.Count);
            end;
            exit(0)
            ;
          end;
    end;


    procedure CalcNoOfSubstitutions(var PurchLine: Record "Purchase Line"): Integer
    begin
        if GetItem(PurchLine) then begin
          Item.CalcFields("No. of Substitutes");
          exit(Item."No. of Substitutes");
        end;
    end;


    procedure DocExist(CurrentPurchHeader: Record "Purchase Header";VendNo: Code[20]): Boolean
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ReturnShipment: Record "Return Shipment Header";
        PurchHeader: Record "Purchase Header";
    begin
        if VendNo = '' then
          exit(false);
        with PurchInvHeader do begin
          SetCurrentkey("Buy-from Vendor No.");
          SetRange("Buy-from Vendor No.",VendNo);
          if not IsEmpty then
            exit(true);
        end;
        with PurchRcptHeader do begin
          SetCurrentkey("Buy-from Vendor No.");
          SetRange("Buy-from Vendor No.",VendNo);
          if not IsEmpty then
            exit(true);
        end;
        with PurchCrMemoHeader do begin
          SetCurrentkey("Buy-from Vendor No.");
          SetRange("Buy-from Vendor No.",VendNo);
          if not IsEmpty then
            exit(true);
        end;
        with PurchHeader do begin
          SetCurrentkey("Buy-from Vendor No.");
          SetRange("Buy-from Vendor No.",VendNo);
          if FindFirst then begin
            if ("Document Type" <> CurrentPurchHeader."Document Type") or
               ("No." <> CurrentPurchHeader."No.")
            then
              exit(true);
            if Find('>') then
              exit(true);
          end;
        end;
        with ReturnShipment do begin
          SetCurrentkey("Buy-from Vendor No.");
          SetRange("Buy-from Vendor No.",VendNo);
          if not IsEmpty then
            exit(true);
        end;
    end;


    procedure VendCommentExists(VendNo: Code[20]): Boolean
    begin
        GetVend(VendNo);
        Vend.CalcFields(Comment);
        exit(Vend.Comment);
    end;


    procedure ItemCommentExists(var PurchLine: Record "Purchase Line"): Boolean
    begin
        if GetItem(PurchLine) then begin
          Item.CalcFields(Comment);
          exit(Item.Comment);
        end;
    end;


    procedure LookupOrderAddr(var PurchHeader: Record "Purchase Header")
    var
        OrderAddress: Record "Order Address";
    begin
        with PurchHeader do begin
          OrderAddress.SetRange("Vendor No.","Buy-from Vendor No.");
          if Page.RunModal(0,OrderAddress) = Action::LookupOK then begin
            Validate("Order Address Code",OrderAddress.Code);
            Modify(true);
            Message(Text000);
          end;
        end;
    end;


    procedure LookupContacts(var PurchHeader: Record "Purchase Header")
    var
        Cont: Record Contact;
        ContBusRelation: Record "Contact Business Relation";
    begin
        with PurchHeader do begin
          if "Buy-from Vendor No." <> '' then begin
            if Cont.Get("Buy-from Contact No.") then
              Cont.SetRange("Company No.",Cont."Company No.")
            else begin
              ContBusRelation.Reset;
              ContBusRelation.SetCurrentkey("Link to Table","No.");
              ContBusRelation.SetRange("Link to Table",ContBusRelation."link to table"::Vendor);
              ContBusRelation.SetRange("No.","Buy-from Vendor No.");
              if ContBusRelation.FindFirst then
                Cont.SetRange("Company No.",ContBusRelation."Contact No.")
              else
                Cont.SetRange("No.",'');
            end;

            if Cont.Get("Buy-from Contact No.") then ;
          end else
            Cont.SetRange("No.",'');
          if Page.RunModal(0,Cont) = Action::LookupOK then begin
            Validate("Buy-from Contact No.",Cont."No.");
            Modify(true);
          end;
        end;
    end;


    procedure LookupItem(PurchLine: Record "Purchase Line")
    begin
        PurchLine.TestField(Type,PurchLine.Type::Item);
        PurchLine.TestField("No.");
        GetItem(PurchLine);
        Page.RunModal(Page::"Item Card",Item);
    end;


    procedure LookupItemComment(PurchLine: Record "Purchase Line")
    var
        CommentLine: Record "Comment Line";
    begin
        if GetItem(PurchLine) then begin
          CommentLine.SetRange("Table Name",CommentLine."table name"::Item);
          CommentLine.SetRange("No.",PurchLine."No.");
          Page.RunModal(Page::"Comment Sheet",CommentLine);
        end;
    end;

    local procedure GetVend(VendNo: Code[20])
    begin
        if VendNo <> '' then begin
          if VendNo <> Vend."No." then
            if not Vend.Get(VendNo) then
              Clear(Vend);
        end else
          Clear(Vend);
    end;


    procedure CalcNoOfPayToDocuments(var Vend: Record Vendor)
    begin
        Vend.CalcFields(
          "Pay-to No. of Quotes","Pay-to No. of Blanket Orders","Pay-to No. of Orders","Pay-to No. of Invoices",
          "Pay-to No. of Return Orders","Pay-to No. of Credit Memos","Pay-to No. of Pstd. Receipts",
          "Pay-to No. of Pstd. Invoices","Pay-to No. of Pstd. Return S.","Pay-to No. of Pstd. Cr. Memos",
          "Pay-to No. Of Archived Doc.");
    end;


    procedure CalcNoOfPurchaseCosts(var PurchLine: Record "Purchase Line"): Integer
    begin
        //IF GetItem(PurchLine) THEN BEGIN
        //  GetPurchHeader(PurchLine);
          exit(PurchLine."Unit Cost (LCY)");
        //END;
    end;


    procedure CalcNoOfBudget(var PurchLine: Record "Purchase Line"): Integer
    var
        BudgetaryControl: Record UnknownRecord61721;
    begin
        if not BudgetaryControl.Get then exit;
        //FABudget.SETRANGE(FABudget.FDBC,BudgetaryControl.Description);
        //FABudget.SETRANGE(FABudget.Charge,PurchLine."No.");
        //FABudget.CALCSUMS("Cost Amount");
        //EXIT(FABudget."Cost Amount");
    end;


    procedure CalcNoOfGLBudget(var PurchLine: Record "Purchase Line"): Integer
    begin
        //IF GetItem(PurchLine) THEN BEGIN
        //  GetPurchHeader(PurchLine);
          exit(PurchLine."Unit Cost (LCY)");
        //END;
    end;
}

