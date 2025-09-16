#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5777 "Whse. Validate Source Line"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'must not be changed when a %1 for this %2 exists: ';
        Text001: label 'The %1 cannot be deleted when a related %2 exists.';
        Text002: label 'You cannot post consumption for order no. %1 because a quantity of %2 remains to be picked.';
        WhseActivLine: Record "Warehouse Activity Line";
        TableCaptionValue: Text[100];


    procedure SalesLineVerifyChange(var NewSalesLine: Record "Sales Line";var OldSalesLine: Record "Sales Line")
    begin
        with NewSalesLine do
          if WhseLinesExist(
               Database::"Sales Line",
               "Document Type",
               "Document No.",
               "Line No.",
               0,
               Quantity)
          then begin
            if Type <> OldSalesLine.Type then
              FieldError(
                Type,
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "No." <> OldSalesLine."No." then
              FieldError(
                "No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Variant Code" <> OldSalesLine."Variant Code" then
              FieldError(
                "Variant Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Location Code" <> OldSalesLine."Location Code" then
              FieldError(
                "Location Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Unit of Measure Code" <> OldSalesLine."Unit of Measure Code" then
              FieldError(
                "Unit of Measure Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Drop Shipment" <> OldSalesLine."Drop Shipment" then
              FieldError(
                "Drop Shipment",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Purchase Order No." <> OldSalesLine."Purchase Order No." then
              FieldError(
                "Purchase Order No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Purch. Order Line No." <> OldSalesLine."Purch. Order Line No." then
              FieldError(
                "Purch. Order Line No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Job No." <> OldSalesLine."Job No." then
              FieldError(
                "Job No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if Quantity <> OldSalesLine.Quantity then
              FieldError(
                Quantity,
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Qty. to Ship" <> OldSalesLine."Qty. to Ship" then
              FieldError(
                "Qty. to Ship",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Qty. to Assemble to Order" <> OldSalesLine."Qty. to Assemble to Order" then
              FieldError(
                "Qty. to Assemble to Order",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Shipment Date" <> OldSalesLine."Shipment Date" then
              FieldError(
                "Shipment Date",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));
          end;
    end;


    procedure SalesLineDelete(var SalesLine: Record "Sales Line")
    begin
        if WhseLinesExist(
             Database::"Sales Line",
             SalesLine."Document Type",
             SalesLine."Document No.",
             SalesLine."Line No.",
             0,
             SalesLine.Quantity)
        then
          Error(
            Text001,
            SalesLine.TableCaption,
            TableCaptionValue);
    end;


    procedure ServiceLineVerifyChange(var NewServiceLine: Record "Service Line";var OldServiceLine: Record "Service Line")
    var
        NewRecRef: RecordRef;
        OldRecRef: RecordRef;
    begin
        if not WhseLinesExist(
             Database::"Service Line",NewServiceLine."Document Type",NewServiceLine."Document No.",NewServiceLine."Line No.",0,
             NewServiceLine.Quantity)
        then
          exit;
        NewRecRef.GetTable(NewServiceLine);
        OldRecRef.GetTable(OldServiceLine);
        with NewServiceLine do begin
          VerifyFieldNotChanged(NewRecRef,OldRecRef,FieldNo(Type));
          VerifyFieldNotChanged(NewRecRef,OldRecRef,FieldNo("No."));
          VerifyFieldNotChanged(NewRecRef,OldRecRef,FieldNo("Location Code"));
          VerifyFieldNotChanged(NewRecRef,OldRecRef,FieldNo(Quantity));
          VerifyFieldNotChanged(NewRecRef,OldRecRef,FieldNo("Variant Code"));
          VerifyFieldNotChanged(NewRecRef,OldRecRef,FieldNo("Unit of Measure Code"));
        end;
    end;


    procedure ServiceLineDelete(var ServiceLine: Record "Service Line")
    begin
        if WhseLinesExist(
             Database::"Service Line",
             ServiceLine."Document Type",
             ServiceLine."Document No.",
             ServiceLine."Line No.",
             0,
             ServiceLine.Quantity)
        then
          Error(
            Text001,
            ServiceLine.TableCaption,
            TableCaptionValue);
    end;

    local procedure VerifyFieldNotChanged(NewRecRef: RecordRef;OldRecRef: RecordRef;FieldNumber: Integer)
    var
        NewFieldRef: FieldRef;
        OldFieldRef: FieldRef;
    begin
        NewFieldRef := NewRecRef.Field(FieldNumber);
        OldFieldRef := OldRecRef.Field(FieldNumber);
        if Format(OldFieldRef.Value) <> Format(NewFieldRef.Value) then
          NewFieldRef.FieldError(StrSubstNo(Text000,TableCaptionValue,NewRecRef.Caption));
    end;


    procedure PurchaseLineVerifyChange(var NewPurchLine: Record "Purchase Line";var OldPurchLine: Record "Purchase Line")
    begin
        with NewPurchLine do
          if WhseLinesExist(
               Database::"Purchase Line",
               "Document Type",
               "Document No.",
               "Line No.",
               0,
               Quantity)
          then begin
            if Type <> OldPurchLine.Type then
              FieldError(
                Type,
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "No." <> OldPurchLine."No." then
              FieldError(
                "No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Variant Code" <> OldPurchLine."Variant Code" then
              FieldError(
                "Variant Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Location Code" <> OldPurchLine."Location Code" then
              FieldError(
                "Location Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Unit of Measure Code" <> OldPurchLine."Unit of Measure Code" then
              FieldError(
                "Unit of Measure Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Drop Shipment" <> OldPurchLine."Drop Shipment" then
              FieldError(
                "Drop Shipment",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Sales Order No." <> OldPurchLine."Sales Order No." then
              FieldError(
                "Sales Order No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Sales Order Line No." <> OldPurchLine."Sales Order Line No." then
              FieldError(
                "Sales Order Line No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Special Order" <> OldPurchLine."Special Order" then
              FieldError(
                "Special Order",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Special Order Sales No." <> OldPurchLine."Special Order Sales No." then
              FieldError(
                "Special Order Sales No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Special Order Sales Line No." <> OldPurchLine."Special Order Sales Line No." then
              FieldError(
                "Special Order Sales Line No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Job No." <> OldPurchLine."Job No." then
              FieldError(
                "Job No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if Quantity <> OldPurchLine.Quantity then
              FieldError(
                Quantity,
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if "Qty. to Receive" <> OldPurchLine."Qty. to Receive" then
              FieldError(
                "Qty. to Receive",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));
          end;
    end;


    procedure PurchaseLineDelete(var PurchLine: Record "Purchase Line")
    begin
        if WhseLinesExist(
             Database::"Purchase Line",
             PurchLine."Document Type",
             PurchLine."Document No.",
             PurchLine."Line No.",
             0,
             PurchLine.Quantity)
        then
          Error(
            Text001,
            PurchLine.TableCaption,
            TableCaptionValue);
    end;


    procedure TransLineVerifyChange(var NewTransLine: Record "Transfer Line";var OldTransLine: Record "Transfer Line")
    begin
        with NewTransLine do begin
          if WhseLinesExist(Database::"Transfer Line",0,"Document No.","Line No.",0,Quantity) then begin
            TransLineCommonVerification(NewTransLine,OldTransLine);
            if "Qty. to Ship" <> OldTransLine."Qty. to Ship" then
              FieldError(
                "Qty. to Ship",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));
          end;

          if WhseLinesExist(Database::"Transfer Line",1,"Document No.","Line No.",0,Quantity) then begin
            TransLineCommonVerification(NewTransLine,OldTransLine);
            if "Qty. to Receive" <> OldTransLine."Qty. to Receive" then
              FieldError(
                "Qty. to Receive",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));
          end;
        end;
    end;

    local procedure TransLineCommonVerification(var NewTransLine: Record "Transfer Line";var OldTransLine: Record "Transfer Line")
    begin
        with NewTransLine do begin
          if "Item No." <> OldTransLine."Item No." then
            FieldError(
              "Item No.",
              StrSubstNo(Text000,
                TableCaptionValue,
                TableCaption));

          if "Variant Code" <> OldTransLine."Variant Code" then
            FieldError(
              "Variant Code",
              StrSubstNo(Text000,
                TableCaptionValue,
                TableCaption));

          if "Unit of Measure Code" <> OldTransLine."Unit of Measure Code" then
            FieldError(
              "Unit of Measure Code",
              StrSubstNo(Text000,
                TableCaptionValue,
                TableCaption));

          if Quantity <> OldTransLine.Quantity then
            FieldError(
              Quantity,
              StrSubstNo(Text000,
                TableCaptionValue,
                TableCaption));
        end;
    end;


    procedure TransLineDelete(var NewTransLine: Record "Transfer Line")
    begin
        with NewTransLine do begin
          if WhseLinesExist(Database::"Transfer Line",0,"Document No.","Line No.",0,Quantity) then
            Error(
              Text001,
              TableCaption,
              TableCaptionValue);
          if WhseLinesExist(Database::"Transfer Line",1,"Document No.","Line No.",0,Quantity) then
            Error(
              Text001,
              TableCaption,
              TableCaptionValue);
        end;
    end;


    procedure WhseLinesExist(SourceType: Integer;SourceSubType: Option;SourceNo: Code[20];SourceLineNo: Integer;SourceSublineNo: Integer;SourceQty: Decimal): Boolean
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        if ((SourceType = Database::"Purchase Line") and (SourceSubType = 1) and (SourceQty >= 0)) or
           ((SourceType = Database::"Purchase Line") and (SourceSubType = 5) and (SourceQty < 0)) or
           ((SourceType = Database::"Sales Line") and (SourceSubType = 1) and (SourceQty < 0)) or
           ((SourceType = Database::"Sales Line") and (SourceSubType = 5) and (SourceQty >= 0)) or
           ((SourceType = Database::"Transfer Line") and (SourceSubType = 1))
        then begin
          WhseRcptLine.SetCurrentkey(
            "Source Type","Source Subtype","Source No.","Source Line No.");
          WhseRcptLine.SetRange("Source Type",SourceType);
          WhseRcptLine.SetRange("Source Subtype",SourceSubType);
          WhseRcptLine.SetRange("Source No.",SourceNo);
          WhseRcptLine.SetRange("Source Line No.",SourceLineNo);
          if not WhseRcptLine.IsEmpty then begin
            TableCaptionValue := WhseRcptLine.TableCaption;
            exit(true);
          end;
        end;

        if ((SourceType = Database::"Purchase Line") and (SourceSubType = 1) and (SourceQty < 0)) or
           ((SourceType = Database::"Purchase Line") and (SourceSubType = 5) and (SourceQty >= 0)) or
           ((SourceType = Database::"Sales Line") and (SourceSubType = 1) and (SourceQty >= 0)) or
           ((SourceType = Database::"Sales Line") and (SourceSubType = 5) and (SourceQty < 0)) or
           ((SourceType = Database::"Transfer Line") and (SourceSubType = 0)) or
           ((SourceType = Database::"Service Line") and (SourceSubType = 1))
        then begin
          WhseShptLine.SetCurrentkey(
            "Source Type","Source Subtype","Source No.","Source Line No.");
          WhseShptLine.SetRange("Source Type",SourceType);
          WhseShptLine.SetRange("Source Subtype",SourceSubType);
          WhseShptLine.SetRange("Source No.",SourceNo);
          WhseShptLine.SetRange("Source Line No.",SourceLineNo);
          if not WhseShptLine.IsEmpty then begin
            TableCaptionValue := WhseShptLine.TableCaption;
            exit(true);
          end;
        end;

        WhseActivLine.SetCurrentkey(
          "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
        WhseActivLine.SetRange("Source Type",SourceType);
        WhseActivLine.SetRange("Source Subtype",SourceSubType);
        WhseActivLine.SetRange("Source No.",SourceNo);
        WhseActivLine.SetRange("Source Line No.",SourceLineNo);
        WhseActivLine.SetRange("Source Subline No.",SourceSublineNo);
        if not WhseActivLine.IsEmpty then begin
          TableCaptionValue := WhseActivLine.TableCaption;
          exit(true);
        end;

        TableCaptionValue := '';
        exit(false);
    end;


    procedure ProdComponentVerifyChange(var NewProdOrderComp: Record "Prod. Order Component";var OldProdOrderComp: Record "Prod. Order Component")
    begin
        with NewProdOrderComp do
          if WhseLinesExist(
               Database::"Prod. Order Component",
               Status,
               "Prod. Order No.",
               "Prod. Order Line No.",
               "Line No.",
               Quantity)
          then begin
            if Status <> OldProdOrderComp.Status then
              FieldError(
                Status,
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Prod. Order No." <> OldProdOrderComp."Prod. Order No." then
              FieldError(
                "Prod. Order No.",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Prod. Order Line No." <> OldProdOrderComp."Prod. Order Line No." then
              FieldError(
                "Prod. Order Line No.",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Line No." <> OldProdOrderComp."Line No." then
              FieldError(
                "Line No.",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Item No." <> OldProdOrderComp."Item No." then
              FieldError(
                "Item No.",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Variant Code" <> OldProdOrderComp."Variant Code" then
              FieldError(
                "Variant Code",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Location Code" <> OldProdOrderComp."Location Code" then
              FieldError(
                "Location Code",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Unit of Measure Code" <> OldProdOrderComp."Unit of Measure Code" then
              FieldError(
                "Unit of Measure Code",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Due Date" <> OldProdOrderComp."Due Date" then
              FieldError(
                "Due Date",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if Quantity <> OldProdOrderComp.Quantity then
              FieldError(
                Quantity,
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Quantity per" <> OldProdOrderComp."Quantity per" then
              FieldError(
                "Quantity per",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Expected Quantity" <> OldProdOrderComp."Expected Quantity" then
              FieldError(
                "Expected Quantity",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));
          end;
    end;


    procedure ProdComponentDelete(var ProdOrderComp: Record "Prod. Order Component")
    begin
        if WhseLinesExist(
             Database::"Prod. Order Component",
             ProdOrderComp.Status,
             ProdOrderComp."Prod. Order No.",
             ProdOrderComp."Prod. Order Line No.",
             ProdOrderComp."Line No.",
             ProdOrderComp.Quantity)
        then
          Error(
            Text001,
            ProdOrderComp.TableCaption,
            TableCaptionValue);
    end;


    procedure ItemLineVerifyChange(var NewItemJnlLine: Record "Item Journal Line";var OldItemJnlLine: Record "Item Journal Line")
    var
        AssemblyLine: Record "Assembly Line";
        ProdOrderComp: Record "Prod. Order Component";
        Location: Record Location;
        LinesExist: Boolean;
        QtyChecked: Boolean;
        QtyRemainingToBePicked: Decimal;
    begin
        with NewItemJnlLine do begin
          case "Entry Type" of
            "entry type"::"Assembly Consumption":
              begin
                TestField("Order Type","order type"::Assembly);
                if Location.Get("Location Code") and Location."Require Pick" and Location."Require Shipment" then
                  if AssemblyLine.Get(AssemblyLine."document type"::Order,"Order No.","Order Line No.") and
                     (Quantity >= 0)
                  then begin
                    QtyRemainingToBePicked := Quantity - AssemblyLine.CalcQtyPickedNotConsumed;
                    if QtyRemainingToBePicked > 0 then
                      Error(Text002,"Order No.",QtyRemainingToBePicked);
                    QtyChecked := true;
                  end;

                LinesExist := false;
              end;
            "entry type"::Consumption:
              begin
                TestField("Order Type","order type"::Production);
                if Location.Get("Location Code") and Location."Require Pick" and Location."Require Shipment" then
                  if ProdOrderComp.Get(
                       ProdOrderComp.Status::Released,
                       "Order No.","Order Line No.","Prod. Order Comp. Line No.") and
                     (ProdOrderComp."Flushing Method" = ProdOrderComp."flushing method"::Manual) and
                     (Quantity >= 0)
                  then begin
                    QtyRemainingToBePicked :=
                      Quantity - CalcNextLevelProdOutput(ProdOrderComp) -
                      ProdOrderComp."Qty. Picked" + ProdOrderComp."Expected Quantity" - ProdOrderComp."Remaining Quantity";
                    if QtyRemainingToBePicked > 0 then
                      Error(Text002,"Order No.",QtyRemainingToBePicked);
                    QtyChecked := true;
                  end;

                LinesExist :=
                  WhseLinesExist(
                    Database::"Prod. Order Component",
                    3,
                    "Order No.",
                    "Order Line No.",
                    "Prod. Order Comp. Line No.",
                    Quantity);
              end;
            "entry type"::Output:
              begin
                TestField("Order Type","order type"::Production);
                LinesExist :=
                  WhseLinesExist(
                    Database::"Prod. Order Line",
                    3,
                    "Order No.",
                    "Order Line No.",
                    0,
                    Quantity);
              end;
            else
              LinesExist := false;
          end;

          if LinesExist then begin
            if ("Item No." <> OldItemJnlLine."Item No.") and
               (OldItemJnlLine."Item No." <> '')
            then
              FieldError(
                "Item No.",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if ("Variant Code" <> OldItemJnlLine."Variant Code") and
               (OldItemJnlLine."Variant Code" <> '')
            then
              FieldError(
                "Variant Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if ("Location Code" <> OldItemJnlLine."Location Code") and
               (OldItemJnlLine."Location Code" <> '')
            then
              FieldError(
                "Location Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if ("Unit of Measure Code" <> OldItemJnlLine."Unit of Measure Code") and
               (OldItemJnlLine."Unit of Measure Code" <> '')
            then
              FieldError(
                "Unit of Measure Code",
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));

            if (Quantity <> OldItemJnlLine.Quantity) and
               (OldItemJnlLine.Quantity <> 0) and
               not QtyChecked
            then
              FieldError(
                Quantity,
                StrSubstNo(Text000,
                  TableCaptionValue,
                  TableCaption));
          end;
        end;
    end;


    procedure ProdOrderLineVerifyChange(var NewProdOrderLine: Record "Prod. Order Line";var OldProdOrderLine: Record "Prod. Order Line")
    begin
        with NewProdOrderLine do
          if WhseLinesExist(
               Database::"Prod. Order Line",
               Status,
               "Prod. Order No.",
               "Line No.",
               0,
               Quantity)
          then begin
            if Status <> OldProdOrderLine.Status then
              FieldError(
                Status,
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));

            if "Prod. Order No." <> OldProdOrderLine."Prod. Order No." then
              FieldError(
                "Prod. Order No.",
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));

            if "Line No." <> OldProdOrderLine."Line No." then
              FieldError(
                "Line No.",
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));

            if "Item No." <> OldProdOrderLine."Item No." then
              FieldError(
                "Item No.",
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));

            if "Variant Code" <> OldProdOrderLine."Variant Code" then
              FieldError(
                "Variant Code",
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));

            if "Location Code" <> OldProdOrderLine."Location Code" then
              FieldError(
                "Location Code",
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));

            if "Unit of Measure Code" <> OldProdOrderLine."Unit of Measure Code" then
              FieldError(
                "Unit of Measure Code",
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));

            if "Due Date" <> OldProdOrderLine."Due Date" then
              FieldError(
                "Due Date",
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));

            if Quantity <> OldProdOrderLine.Quantity then
              FieldError(
                Quantity,
                StrSubstNo(Text000,WhseActivLine.TableCaption,TableCaption));
          end;
    end;


    procedure ProdOrderLineDelete(var ProdOrderLine: Record "Prod. Order Line")
    begin
        with ProdOrderLine do
          if WhseLinesExist(
               Database::"Prod. Order Line",
               Status,
               "Prod. Order No.",
               "Line No.",
               0,
               Quantity)
          then
            Error(
              Text001,
              TableCaption,
              TableCaptionValue);
    end;


    procedure AssemblyLineVerifyChange(var NewAssemblyLine: Record "Assembly Line";var OldAssemblyLine: Record "Assembly Line")
    var
        Location: Record Location;
    begin
        if OldAssemblyLine.Type <> OldAssemblyLine.Type::Item then
          exit;

        with NewAssemblyLine do
          if WhseLinesExist(
               Database::"Assembly Line",
               "Document Type",
               "Document No.",
               "Line No.",
               0,
               Quantity)
          then begin
            if "Document Type" <> OldAssemblyLine."Document Type" then
              FieldError(
                "Document Type",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Document No." <> OldAssemblyLine."Document No." then
              FieldError(
                "Document No.",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Line No." <> OldAssemblyLine."Line No." then
              FieldError(
                "Line No.",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "No." <> OldAssemblyLine."No." then
              FieldError(
                "No.",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Variant Code" <> OldAssemblyLine."Variant Code" then
              FieldError(
                "Variant Code",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Location Code" <> OldAssemblyLine."Location Code" then
              FieldError(
                "Location Code",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Unit of Measure Code" <> OldAssemblyLine."Unit of Measure Code" then
              FieldError(
                "Unit of Measure Code",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Due Date" <> OldAssemblyLine."Due Date" then
              FieldError(
                "Due Date",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if Quantity <> OldAssemblyLine.Quantity then
              FieldError(
                Quantity,
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if "Quantity per" <> OldAssemblyLine."Quantity per" then
              FieldError(
                "Quantity per",
                StrSubstNo(Text000,
                  WhseActivLine.TableCaption,
                  TableCaption));

            if Location.Get("Location Code") and not Location."Require Shipment" then
              if "Quantity to Consume" <> OldAssemblyLine."Quantity to Consume" then
                FieldError(
                  "Quantity to Consume",
                  StrSubstNo(Text000,
                    WhseActivLine.TableCaption,
                    TableCaption));
          end;
    end;


    procedure AssemblyLineDelete(var AssemblyLine: Record "Assembly Line")
    begin
        if AssemblyLine.Type <> AssemblyLine.Type::Item then
          exit;

        if WhseLinesExist(
             Database::"Assembly Line",
             AssemblyLine."Document Type",
             AssemblyLine."Document No.",
             AssemblyLine."Line No.",
             0,
             AssemblyLine.Quantity)
        then
          Error(
            Text001,
            AssemblyLine.TableCaption,
            TableCaptionValue);
    end;


    procedure CalcNextLevelProdOutput(ProdOrderComp: Record "Prod. Order Component"): Decimal
    var
        Item: Record Item;
        WhseEntry: Record "Warehouse Entry";
        ProdOrderLine: Record "Prod. Order Line";
        OutputBase: Decimal;
    begin
        Item.Get(ProdOrderComp."Item No.");
        if Item."Replenishment System" = Item."replenishment system"::Purchase then
          exit(0);

        ProdOrderLine.SetRange(Status,ProdOrderComp.Status);
        ProdOrderLine.SetRange("Prod. Order No.",ProdOrderComp."Prod. Order No.");
        ProdOrderLine.SetRange("Item No.",ProdOrderComp."Item No.");
        ProdOrderLine.SetRange("Planning Level Code",ProdOrderComp."Planning Level Code");

        if ProdOrderLine.FindFirst then begin
          WhseEntry.SetCurrentkey("Source Type","Source Subtype","Source No.");
          WhseEntry.SetRange("Source Type",Database::"Item Journal Line");
          WhseEntry.SetRange("Source Subtype",5); // Output Journal
          WhseEntry.SetRange("Source No.",ProdOrderLine."Prod. Order No.");
          WhseEntry.SetRange("Source Line No.",ProdOrderLine."Line No.");
          WhseEntry.SetRange("Reference No.",ProdOrderLine."Prod. Order No.");
          WhseEntry.SetRange("Item No.",ProdOrderLine."Item No.");

          if WhseEntry.FindSet then
            repeat
              OutputBase += WhseEntry.Quantity;
            until WhseEntry.Next = 0;
        end;

        exit(OutputBase);
    end;
}

