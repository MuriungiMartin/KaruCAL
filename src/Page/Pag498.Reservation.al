#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 498 Reservation
{
    Caption = 'Reservation';
    DataCaptionExpression = CaptionText;
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = "Entry Summary";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ItemNo;ReservEntry."Item No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                    Editable = false;
                    ToolTip = 'Specifies the item number of the item that the reservation is for.';
                }
                field("ReservEntry.""Shipment Date""";ReservEntry."Shipment Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Shipment Date';
                    Editable = false;
                    ToolTip = 'Specifies the shipment date, expected receipt date, or posting date for the reservation.';
                }
                field("ReservEntry.Description";ReservEntry.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the reservation in the window.';
                }
                field(QtyToReserveBase;QtyToReserveBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity to Reserve';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity of the item that must be reserved for the line.';
                }
                field(QtyReservedBase;QtyReservedBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reserved Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of the item reserved for the line.';
                }
                field(UnreservedQuantity;QtyToReserveBase - QtyReservedBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unreserved Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the difference between the Quantity to Reserve field and the Reserved Quantity field.';
                }
            }
            repeater(Control1)
            {
                Editable = false;
                field("Summary Type";"Summary Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies which type of line or entry is summarized in the entry summary.';
                }
                field("Total Quantity";ReservMgt.FormatQty("Total Quantity"))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Total Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity of the item in inventory.';

                    trigger OnDrillDown()
                    begin
                        DrillDownTotalQuantity;
                    end;
                }
                field(TotalReservedQuantity;ReservMgt.FormatQty("Total Reserved Quantity"))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Total Reserved Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity of the item that is reserved on documents or entries.';

                    trigger OnDrillDown()
                    begin
                        DrillDownReservedQuantity;
                    end;
                }
                field(QtyAllocatedInWarehouse;ReservMgt.FormatQty("Qty. Alloc. in Warehouse"))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Qty. Allocated in Warehouse';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of the item that is allocated to activities in the warehouse.';
                }
                field("ReservMgt.FormatQty(""Res. Qty. on Picks & Shipmts."")";ReservMgt.FormatQty("Res. Qty. on Picks & Shipmts."))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Reserved Qty. on Picks and Shipments';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the sum of the overlap quantities.';
                    Visible = false;
                }
                field(TotalAvailableQuantity;ReservMgt.FormatQty("Total Available Quantity"))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Total Available Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity that is available for the user to reserve from entries of the type.';
                }
                field("Non-specific Reserved Qty.";"Non-specific Reserved Qty.")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity of the item that is reserved but does not have specific item tracking numbers in the reservation.';
                    Visible = false;
                }
                field("Current Reserved Quantity";ReservMgt.FormatQty(ReservedThisLine(Rec)))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Current Reserved Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies how many items in the entry are reserved for the line opened in the Reservation window.';

                    trigger OnDrillDown()
                    begin
                        DrillDownReservedThisLine;
                    end;
                }
            }
            label(NoteText)
            {
                ApplicationArea = Basic;
                CaptionClass = FORMAT(STRSUBSTNO(Text009,NonSpecificQty,FIELDCAPTION("Total Reserved Quantity")));
                Editable = false;
                MultiLine = true;
                Visible = NoteTextVisible;
            }
            group(Filters)
            {
                Caption = 'Filters';
                field("ReservEntry.""Variant Code""";ReservEntry."Variant Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant Code';
                    Editable = false;
                    ToolTip = 'Specifies the variant code for the reservation.';
                }
                field("ReservEntry.""Location Code""";ReservEntry."Location Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Code';
                    Editable = false;
                    ToolTip = 'Specifies the location code for the reservation.';
                }
                field("ReservEntry.""Serial No.""";ReservEntry."Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Serial No.';
                    Editable = false;
                    ToolTip = 'Specifies the serial number for an item in the reservation.';
                }
                field("ReservEntry.""Lot No.""";ReservEntry."Lot No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lot No.';
                    Editable = false;
                    ToolTip = 'Specifies the lot number for the reservation.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(AvailableToReserve)
                {
                    ApplicationArea = Basic;
                    Caption = '&Available to Reserve';
                    Image = ItemReservation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin
                        DrillDownTotalQuantity;
                    end;
                }
                action("&Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = '&Reservation Entries';
                    Image = ReservationLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        DrillDownReservedThisLine;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Auto Reserve")
                {
                    ApplicationArea = Basic;
                    Caption = '&Auto Reserve';
                    Image = AutoReserve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AutoReserve;
                    end;
                }
                action("Reserve from Current Line")
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve from Current Line';
                    Image = LineReserve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RemainingQtyToReserveBase: Decimal;
                        QtyReservedBefore: Decimal;
                        RemainingQtyToReserve: Decimal;
                    begin
                        RemainingQtyToReserveBase := QtyToReserveBase - QtyReservedBase;
                        if RemainingQtyToReserveBase = 0 then
                          Error(Text000);
                        QtyReservedBefore := QtyReservedBase;
                        if HandleItemTracking then
                          ReservMgt.SetItemTrackingHandling(2);
                        RemainingQtyToReserve := QtyToReserve - QtyReserved;
                        ReservMgt.AutoReserveOneLine(
                          "Entry No.",RemainingQtyToReserve,RemainingQtyToReserveBase,ReservEntry.Description,
                          ReservEntry."Shipment Date");
                        UpdateReservFrom;
                        if QtyReservedBefore = QtyReservedBase then
                          Error(Text002);
                    end;
                }
                action(CancelReservationCurrentLine)
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = '&Cancel Reservation from Current Line';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ReservEntry3: Record "Reservation Entry";
                        RecordsFound: Boolean;
                    begin
                        if not Confirm(Text003,false,"Summary Type") then
                          exit;
                        Clear(ReservEntry2);
                        ReservEntry2 := ReservEntry;
                        ReservMgt.SetPointerFilter(ReservEntry2);
                        ReservEntry2.SetRange("Reservation Status",ReservEntry2."reservation status"::Reservation);
                        ReservEntry2.SetRange("Disallow Cancellation",false);
                        if ReservEntry2.FindSet then
                          repeat
                            ReservEntry3.Get(ReservEntry2."Entry No.",not ReservEntry2.Positive);
                            if RelatesToSummEntry(ReservEntry3,Rec) then begin
                              ReservEngineMgt.CancelReservation(ReservEntry2);
                              RecordsFound := true;
                            end;
                          until ReservEntry2.Next = 0;

                        if RecordsFound then
                          UpdateReservFrom
                        else
                          Error(Text005);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FormIsOpen := true;
    end;

    var
        Text000: label 'Fully reserved.';
        Text001: label 'Full automatic Reservation is not possible.\Reserve manually.';
        Text002: label 'There is nothing available to reserve.';
        Text003: label 'Do you want to cancel all reservations in the %1?';
        Text005: label 'There are no reservations to cancel.';
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ReqLine: Record "Requisition Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        PlanningComponent: Record "Planning Component";
        ServiceLine: Record "Service Line";
        TransLine: Record "Transfer Line";
        JobPlanningLine: Record "Job Planning Line";
        ReservMgt: Codeunit "Reservation Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        AssemblyHeaderReserve: Codeunit "Assembly Header-Reserve";
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
        ReservePlanningComponent: Codeunit "Plng. Component-Reserve";
        ReserveServiceLine: Codeunit "Service Line-Reserve";
        ReserveTransLine: Codeunit "Transfer Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        AvailableSalesLines: Page "Available - Sales Lines";
        AvailablePurchLines: Page "Available - Purchase Lines";
        AvailableItemLedgEntries: Page "Available - Item Ledg. Entries";
        AvailableReqLines: Page "Available - Requisition Lines";
        AvailableProdOrderLines: Page "Available - Prod. Order Lines";
        AvailableProdOrderComps: Page "Available - Prod. Order Comp.";
        AvailablePlanningComponents: Page "Avail. - Planning Components";
        AvailableServiceLines: Page "Available - Service Lines";
        AvailableTransLines: Page "Available - Transfer Lines";
        AvailableItemTrackingLines: Page "Avail. - Item Tracking Lines";
        AvailableJobPlanningLines: Page "Available - Job Planning Lines";
        AvailableAssemblyHeaders: Page "Available - Assembly Headers";
        AvailableAssemblyLines: Page "Available - Assembly Lines";
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        QtyReserved: Decimal;
        QtyReservedBase: Decimal;
        ItemTrackingQtyToReserve: Decimal;
        ItemTrackingQtyToReserveBase: Decimal;
        NonSpecificQty: Decimal;
        CaptionText: Text[80];
        FullAutoReservation: Boolean;
        FormIsOpen: Boolean;
        HandleItemTracking: Boolean;
        Text006: label 'Do you want to reserve specific serial or lot numbers?';
        Text007: label ', %1 %2', Comment='%1 = Serial No.; %2 = Lot No.';
        Text008: label 'Action canceled.';
        Text009: label '%1 of the %2 are nonspecific and may be available.';
        [InDataSet]
        NoteTextVisible: Boolean;


    procedure SetSalesLine(var CurrentSalesLine: Record "Sales Line")
    begin
        CurrentSalesLine.TestField("Job No.",'');
        CurrentSalesLine.TestField("Drop Shipment",false);
        CurrentSalesLine.TestField(Type,CurrentSalesLine.Type::Item);
        CurrentSalesLine.TestField("Shipment Date");

        SalesLine := CurrentSalesLine;
        ReservEntry."Source Type" := Database::"Sales Line";
        ReservEntry."Source Subtype" := SalesLine."Document Type";
        ReservEntry."Source ID" := SalesLine."Document No.";
        ReservEntry."Source Ref. No." := SalesLine."Line No.";

        ReservEntry."Item No." := SalesLine."No.";
        ReservEntry."Variant Code" := SalesLine."Variant Code";
        ReservEntry."Location Code" := SalesLine."Location Code";
        ReservEntry."Shipment Date" := SalesLine."Shipment Date";

        CaptionText := ReserveSalesLine.Caption(SalesLine);
        UpdateReservFrom;
    end;


    procedure SetReqLine(var CurrentReqLine: Record "Requisition Line")
    begin
        CurrentReqLine.TestField("Sales Order No.",'');
        CurrentReqLine.TestField("Sales Order Line No.",0);
        CurrentReqLine.TestField("Sell-to Customer No.",'');
        CurrentReqLine.TestField(Type,CurrentReqLine.Type::Item);
        CurrentReqLine.TestField("Due Date");

        ReqLine := CurrentReqLine;

        ReservEntry."Source Type" := Database::"Requisition Line";
        ReservEntry."Source ID" := ReqLine."Worksheet Template Name";
        ReservEntry."Source Batch Name" := ReqLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := ReqLine."Line No.";

        ReservEntry."Item No." := ReqLine."No.";
        ReservEntry."Variant Code" := ReqLine."Variant Code";
        ReservEntry."Location Code" := ReqLine."Location Code";
        ReservEntry."Shipment Date" := ReqLine."Due Date";

        CaptionText := ReserveReqLine.Caption(ReqLine);
        UpdateReservFrom;
    end;


    procedure SetPurchLine(var CurrentPurchLine: Record "Purchase Line")
    begin
        CurrentPurchLine.TestField("Job No.",'');
        CurrentPurchLine.TestField("Drop Shipment",false);
        CurrentPurchLine.TestField(Type,CurrentPurchLine.Type::Item);
        CurrentPurchLine.TestField("Expected Receipt Date");

        PurchLine := CurrentPurchLine;
        ReservEntry."Source Type" := Database::"Purchase Line";
        ReservEntry."Source Subtype" := PurchLine."Document Type";
        ReservEntry."Source ID" := PurchLine."Document No.";
        ReservEntry."Source Ref. No." := PurchLine."Line No.";

        ReservEntry."Item No." := PurchLine."No.";
        ReservEntry."Variant Code" := PurchLine."Variant Code";
        ReservEntry."Location Code" := PurchLine."Location Code";
        ReservEntry."Shipment Date" := PurchLine."Expected Receipt Date";

        CaptionText := ReservePurchLine.Caption(PurchLine);
        UpdateReservFrom;
    end;


    procedure SetItemJnlLine(var CurrentItemJnlLine: Record "Item Journal Line")
    begin
        CurrentItemJnlLine.TestField("Drop Shipment",false);
        CurrentItemJnlLine.TestField("Posting Date");

        ItemJnlLine := CurrentItemJnlLine;
        ReservEntry."Source Type" := Database::"Item Journal Line";
        ReservEntry."Source Subtype" := ItemJnlLine."Entry Type";
        ReservEntry."Source ID" := ItemJnlLine."Journal Template Name";
        ReservEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := ItemJnlLine."Line No.";

        ReservEntry."Item No." := ItemJnlLine."Item No.";
        ReservEntry."Variant Code" := ItemJnlLine."Variant Code";
        ReservEntry."Location Code" := ItemJnlLine."Location Code";
        ReservEntry."Shipment Date" := ItemJnlLine."Posting Date";

        CaptionText := ReserveItemJnlLine.Caption(ItemJnlLine);
        UpdateReservFrom;
    end;


    procedure SetProdOrderLine(var CurrentProdOrderLine: Record "Prod. Order Line")
    begin
        CurrentProdOrderLine.TestField("Due Date");

        ProdOrderLine := CurrentProdOrderLine;
        ReservEntry."Source Type" := Database::"Prod. Order Line";
        ReservEntry."Source Subtype" := ProdOrderLine.Status;
        ReservEntry."Source ID" := ProdOrderLine."Prod. Order No.";
        ReservEntry."Source Prod. Order Line" := ProdOrderLine."Line No.";

        ReservEntry."Item No." := ProdOrderLine."Item No.";
        ReservEntry."Variant Code" := ProdOrderLine."Variant Code";
        ReservEntry."Location Code" := ProdOrderLine."Location Code";
        ReservEntry."Shipment Date" := ProdOrderLine."Due Date";

        CaptionText := ReserveProdOrderLine.Caption(ProdOrderLine);
        UpdateReservFrom;
    end;


    procedure SetProdOrderComponent(var CurrentProdOrderComp: Record "Prod. Order Component")
    begin
        CurrentProdOrderComp.TestField("Due Date");

        ProdOrderComp := CurrentProdOrderComp;
        ReservEntry."Source Type" := Database::"Prod. Order Component";
        ReservEntry."Source Subtype" := ProdOrderComp.Status;
        ReservEntry."Source ID" := ProdOrderComp."Prod. Order No.";
        ReservEntry."Source Prod. Order Line" := ProdOrderComp."Prod. Order Line No.";
        ReservEntry."Source Ref. No." := ProdOrderComp."Line No.";

        ReservEntry."Item No." := ProdOrderComp."Item No.";
        ReservEntry."Variant Code" := ProdOrderComp."Variant Code";
        ReservEntry."Location Code" := ProdOrderComp."Location Code";
        ReservEntry."Shipment Date" := ProdOrderComp."Due Date";

        CaptionText := ReserveProdOrderComp.Caption(ProdOrderComp);
        UpdateReservFrom;
    end;


    procedure SetAssemblyHeader(var CurrentAssemblyHeader: Record "Assembly Header")
    begin
        CurrentAssemblyHeader.TestField("Due Date");

        AssemblyHeader := CurrentAssemblyHeader;
        ReservEntry."Source Type" := Database::"Assembly Header";
        ReservEntry."Source Subtype" := AssemblyHeader."Document Type";
        ReservEntry."Source ID" := AssemblyHeader."No.";
        ReservEntry."Source Ref. No." := 0;

        ReservEntry."Item No." := AssemblyHeader."Item No.";
        ReservEntry."Variant Code" := AssemblyHeader."Variant Code";
        ReservEntry."Location Code" := AssemblyHeader."Location Code";
        ReservEntry."Shipment Date" := AssemblyHeader."Due Date";

        CaptionText := AssemblyHeaderReserve.Caption(AssemblyHeader);
        UpdateReservFrom;
    end;


    procedure SetAssemblyLine(var CurrentAssemblyLine: Record "Assembly Line")
    begin
        CurrentAssemblyLine.TestField(Type,CurrentAssemblyLine.Type::Item);
        CurrentAssemblyLine.TestField("Due Date");

        AssemblyLine := CurrentAssemblyLine;
        ReservEntry."Source Type" := Database::"Assembly Line";
        ReservEntry."Source Subtype" := AssemblyLine."Document Type";
        ReservEntry."Source ID" := AssemblyLine."Document No.";
        ReservEntry."Source Ref. No." := AssemblyLine."Line No.";

        ReservEntry."Item No." := AssemblyLine."No.";
        ReservEntry."Variant Code" := AssemblyLine."Variant Code";
        ReservEntry."Location Code" := AssemblyLine."Location Code";
        ReservEntry."Shipment Date" := AssemblyLine."Due Date";

        CaptionText := AssemblyLineReserve.Caption(AssemblyLine);
        UpdateReservFrom;
    end;


    procedure SetPlanningComponent(var CurrentPlanningComponent: Record "Planning Component")
    begin
        CurrentPlanningComponent.TestField("Due Date");

        PlanningComponent := CurrentPlanningComponent;
        ReservEntry."Source Type" := Database::"Planning Component";
        ReservEntry."Source ID" := PlanningComponent."Worksheet Template Name";
        ReservEntry."Source Batch Name" := PlanningComponent."Worksheet Batch Name";
        ReservEntry."Source Prod. Order Line" := PlanningComponent."Worksheet Line No.";
        ReservEntry."Source Ref. No." := PlanningComponent."Line No.";

        ReservEntry."Item No." := PlanningComponent."Item No.";
        ReservEntry."Variant Code" := PlanningComponent."Variant Code";
        ReservEntry."Location Code" := PlanningComponent."Location Code";
        ReservEntry."Shipment Date" := PlanningComponent."Due Date";

        CaptionText := ReservePlanningComponent.Caption(PlanningComponent);
        UpdateReservFrom;
    end;


    procedure SetTransLine(CurrentTransLine: Record "Transfer Line";Direction: Option Outbound,Inbound)
    begin
        ClearAll;

        TransLine := CurrentTransLine;
        ReservEntry."Source Type" := Database::"Transfer Line";
        ReservEntry."Source Subtype" := Direction;
        ReservEntry."Source ID" := CurrentTransLine."Document No.";
        ReservEntry."Source Prod. Order Line" := CurrentTransLine."Derived From Line No.";
        ReservEntry."Source Ref. No." := CurrentTransLine."Line No.";

        ReservEntry."Item No." := CurrentTransLine."Item No.";
        ReservEntry."Variant Code" := CurrentTransLine."Variant Code";
        case Direction of
          Direction::Outbound:
            begin
              ReservEntry."Location Code" := CurrentTransLine."Transfer-from Code";
              ReservEntry."Shipment Date" := CurrentTransLine."Shipment Date";
            end;
          Direction::Inbound:
            begin
              ReservEntry."Location Code" := CurrentTransLine."Transfer-to Code";
              ReservEntry."Shipment Date" := CurrentTransLine."Receipt Date";
            end;
        end;

        ReservEntry."Qty. per Unit of Measure" := CurrentTransLine."Qty. per Unit of Measure";

        CaptionText := ReserveTransLine.Caption(TransLine);
        UpdateReservFrom;
    end;


    procedure SetServiceLine(var CurrentServiceLine: Record "Service Line")
    begin
        CurrentServiceLine.TestField(Type,CurrentServiceLine.Type::Item);
        CurrentServiceLine.TestField("Needed by Date");

        ServiceLine := CurrentServiceLine;
        ReservEntry."Source Type" := Database::"Service Line";
        ReservEntry."Source Subtype" := ServiceLine."Document Type";
        ReservEntry."Source ID" := ServiceLine."Document No.";
        ReservEntry."Source Ref. No." := ServiceLine."Line No.";

        ReservEntry."Item No." := ServiceLine."No.";
        ReservEntry."Variant Code" := ServiceLine."Variant Code";
        ReservEntry."Location Code" := ServiceLine."Location Code";
        ReservEntry."Shipment Date" := ServiceLine."Needed by Date";

        CaptionText := ReserveServiceLine.Caption(ServiceLine);
        UpdateReservFrom;
    end;


    procedure SetJobPlanningLine(var CurrentJobPlanningLine: Record "Job Planning Line")
    begin
        CurrentJobPlanningLine.TestField(Type,CurrentJobPlanningLine.Type::Item);
        CurrentJobPlanningLine.TestField("Planning Date");

        JobPlanningLine := CurrentJobPlanningLine;
        ReservEntry."Source Type" := Database::"Job Planning Line";
        ReservEntry."Source Subtype" := JobPlanningLine.Status;
        ReservEntry."Source ID" := JobPlanningLine."Job No.";
        ReservEntry."Source Ref. No." := JobPlanningLine."Job Contract Entry No.";

        ReservEntry."Item No." := JobPlanningLine."No.";
        ReservEntry."Variant Code" := JobPlanningLine."Variant Code";
        ReservEntry."Location Code" := JobPlanningLine."Location Code";
        ReservEntry."Shipment Date" := JobPlanningLine."Planning Date";

        CaptionText := JobPlanningLineReserve.Caption(JobPlanningLine);
        UpdateReservFrom;
    end;


    procedure SetReservEntry(ReservEntry2: Record "Reservation Entry")
    begin
        ReservEntry := ReservEntry2;
        UpdateReservMgt;
    end;

    local procedure FilterReservEntry(var FilterReservEntry: Record "Reservation Entry";FromReservSummEntry: Record "Entry Summary")
    begin
        FilterReservEntry.SetRange("Item No.",ReservEntry."Item No.");

        case FromReservSummEntry."Entry No." of
          1:
            begin // Item Ledger Entry
              FilterReservEntry.SetRange("Source Type",Database::"Item Ledger Entry");
              FilterReservEntry.SetRange("Source Subtype",0);
              FilterReservEntry.SetRange("Expected Receipt Date");
            end;
          11,12,13,14,15,16:
            begin // Purchase Line
              FilterReservEntry.SetRange("Source Type",Database::"Purchase Line");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 11);
            end;
          21:
            begin // Requisition Line
              FilterReservEntry.SetRange("Source Type",Database::"Requisition Line");
              FilterReservEntry.SetRange("Source Subtype",0);
            end;
          31,32,33,34,35,36:
            begin // Sales Line
              FilterReservEntry.SetRange("Source Type",Database::"Sales Line");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 31);
            end;
          41,42,43,44,45:
            begin // Item Journal Line
              FilterReservEntry.SetRange("Source Type",Database::"Item Journal Line");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 41);
            end;
          61,62,63,64:
            begin // prod. order
              FilterReservEntry.SetRange("Source Type",Database::"Prod. Order Line");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 61);
            end;
          71,72,73,74:
            begin // prod. order
              FilterReservEntry.SetRange("Source Type",Database::"Prod. Order Component");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 71);
            end;
          91:
            begin // Planning Component
              FilterReservEntry.SetRange("Source Type",Database::"Planning Component");
              FilterReservEntry.SetRange("Source Subtype",0);
            end;
          101,102:
            begin // Transfer Line
              FilterReservEntry.SetRange("Source Type",Database::"Transfer Line");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 101);
            end;
          110:
            begin // Service Line
              FilterReservEntry.SetRange("Source Type",Database::"Service Line");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 109);
            end;
          131,132,133,134:
            begin // Job Planning Line
              FilterReservEntry.SetRange("Source Type",Database::"Job Planning Line");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 131);
            end;
          141,142,143,144,145:
            begin // Assembly Header
              FilterReservEntry.SetRange("Source Type",Database::"Assembly Header");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 141);
            end;
          151,152,153,154,155:
            begin // Assembly Line
              FilterReservEntry.SetRange("Source Type",Database::"Assembly Line");
              FilterReservEntry.SetRange("Source Subtype",FromReservSummEntry."Entry No." - 151);
            end;
        end;

        FilterReservEntry.SetRange(
          "Reservation Status",FilterReservEntry."reservation status"::Reservation);
        FilterReservEntry.SetRange("Location Code",ReservEntry."Location Code");
        FilterReservEntry.SetRange("Variant Code",ReservEntry."Variant Code");
        if ReservEntry.TrackingExists then begin
          FilterReservEntry.SetRange("Serial No.",ReservEntry."Serial No.");
          FilterReservEntry.SetRange("Lot No.",ReservEntry."Lot No.");
        end;
        FilterReservEntry.SetRange(Positive,ReservMgt.IsPositive);
    end;

    local procedure RelatesToSummEntry(var FilterReservEntry: Record "Reservation Entry";FromReservSummEntry: Record "Entry Summary"): Boolean
    begin
        case FromReservSummEntry."Entry No." of
          1: // Item Ledger Entry
            exit((FilterReservEntry."Source Type" = Database::"Item Ledger Entry") and
              (FilterReservEntry."Source Subtype" = 0));
          11,12,13,14,15,16: // Purchase Line
            exit((FilterReservEntry."Source Type" = Database::"Purchase Line") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 11));
          21: // Requisition Line
            exit((FilterReservEntry."Source Type" = Database::"Requisition Line") and
              (FilterReservEntry."Source Subtype" = 0));
          31,32,33,34,35,36: // Sales Line
            exit((FilterReservEntry."Source Type" = Database::"Sales Line") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 31));
          41,42,43,44,45: // Item Journal Line
            exit((FilterReservEntry."Source Type" = Database::"Item Journal Line") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 41));
          61,62,63,64: // Prod. Order
            exit((FilterReservEntry."Source Type" = Database::"Prod. Order Line") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 61));
          71,72,73,74: // Prod. Order Component
            exit((FilterReservEntry."Source Type" = Database::"Prod. Order Component") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 71));
          91: // Planning Component
            exit((FilterReservEntry."Source Type" = Database::"Planning Component") and
              (FilterReservEntry."Source Subtype" = 0));
          101,102: // Transfer Line
            exit((FilterReservEntry."Source Type" = Database::"Transfer Line") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 101));
          110: // Service Line
            exit((FilterReservEntry."Source Type" = Database::"Service Line") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 109));
          131,132,133,134: // Job Planning Line
            exit((FilterReservEntry."Source Type" = Database::"Job Planning Line") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 131));
          141,142,143,144,145: // Assembly Header
            exit((FilterReservEntry."Source Type" = Database::"Assembly Header") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 141));
          151,152,153,154,155: // Assembly Line
            exit((FilterReservEntry."Source Type" = Database::"Assembly Line") and
              (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 151));
        end;
    end;

    local procedure UpdateReservFrom()
    var
        EntrySummary: Record "Entry Summary";
        QtyPerUOM: Decimal;
        QtyReservedIT: Decimal;
    begin
        if not FormIsOpen then
          GetSerialLotNo(ItemTrackingQtyToReserve,ItemTrackingQtyToReserveBase);

        case ReservEntry."Source Type" of
          Database::"Sales Line":
            begin
              SalesLine.Find;
              SalesLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              if SalesLine."Document Type" = SalesLine."document type"::"Return Order" then begin
                SalesLine."Reserved Quantity" := -SalesLine."Reserved Quantity";
                SalesLine."Reserved Qty. (Base)" := -SalesLine."Reserved Qty. (Base)";
              end;
              QtyReserved := SalesLine."Reserved Quantity";
              QtyReservedBase := SalesLine."Reserved Qty. (Base)";
              QtyToReserve := SalesLine."Outstanding Quantity";
              QtyToReserveBase := SalesLine."Outstanding Qty. (Base)";
              QtyPerUOM := SalesLine."Qty. per Unit of Measure";
            end;
          Database::"Requisition Line":
            begin
              ReqLine.Find;
              ReqLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ReqLine."Reserved Quantity";
              QtyReservedBase := ReqLine."Reserved Qty. (Base)";
              QtyToReserve := ReqLine.Quantity;
              QtyToReserveBase := ReqLine."Quantity (Base)";
              QtyPerUOM := ReqLine."Qty. per Unit of Measure";
            end;
          Database::"Purchase Line":
            begin
              PurchLine.Find;
              PurchLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              if PurchLine."Document Type" = PurchLine."document type"::"Return Order" then begin
                PurchLine."Reserved Quantity" := -PurchLine."Reserved Quantity";
                PurchLine."Reserved Qty. (Base)" := -PurchLine."Reserved Qty. (Base)";
              end;
              QtyReserved := PurchLine."Reserved Quantity";
              QtyReservedBase := PurchLine."Reserved Qty. (Base)";
              QtyToReserve := PurchLine."Outstanding Quantity";
              QtyToReserveBase := PurchLine."Outstanding Qty. (Base)";
              QtyPerUOM := PurchLine."Qty. per Unit of Measure";
            end;
          Database::"Item Journal Line":
            begin
              ItemJnlLine.Find;
              ItemJnlLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ItemJnlLine."Reserved Quantity";
              QtyReservedBase := ItemJnlLine."Reserved Qty. (Base)";
              QtyToReserve := ItemJnlLine.Quantity;
              QtyToReserveBase := ItemJnlLine."Quantity (Base)";
              QtyPerUOM := ItemJnlLine."Qty. per Unit of Measure";
            end;
          Database::"Prod. Order Line":
            begin
              ProdOrderLine.Find;
              ProdOrderLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ProdOrderLine."Reserved Quantity";
              QtyReservedBase := ProdOrderLine."Reserved Qty. (Base)";
              QtyToReserve := ProdOrderLine."Remaining Quantity";
              QtyToReserveBase := ProdOrderLine."Remaining Qty. (Base)";
              QtyPerUOM := ProdOrderLine."Qty. per Unit of Measure";
            end;
          Database::"Prod. Order Component":
            begin
              ProdOrderComp.Find;
              ProdOrderComp.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ProdOrderComp."Reserved Quantity";
              QtyReservedBase := ProdOrderComp."Reserved Qty. (Base)";
              QtyToReserve := ProdOrderComp."Remaining Quantity";
              QtyToReserveBase := ProdOrderComp."Remaining Qty. (Base)";
              QtyPerUOM := ProdOrderComp."Qty. per Unit of Measure";
            end;
          Database::"Assembly Header":
            begin
              AssemblyHeader.Find;
              AssemblyHeader.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := AssemblyHeader."Reserved Quantity";
              QtyReservedBase := AssemblyHeader."Reserved Qty. (Base)";
              QtyToReserve := AssemblyHeader."Remaining Quantity";
              QtyToReserveBase := AssemblyHeader."Remaining Quantity (Base)";
              QtyPerUOM := AssemblyHeader."Qty. per Unit of Measure";
            end;
          Database::"Assembly Line":
            begin
              AssemblyLine.Find;
              AssemblyLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := AssemblyLine."Reserved Quantity";
              QtyReservedBase := AssemblyLine."Reserved Qty. (Base)";
              QtyToReserve := AssemblyLine."Remaining Quantity";
              QtyToReserveBase := AssemblyLine."Remaining Quantity (Base)";
              QtyPerUOM := AssemblyLine."Qty. per Unit of Measure";
            end;
          Database::"Planning Component":
            begin
              PlanningComponent.Find;
              PlanningComponent.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := PlanningComponent."Reserved Quantity";
              QtyReservedBase := PlanningComponent."Reserved Qty. (Base)";
              QtyToReserve := PlanningComponent.Quantity;
              QtyToReserveBase := PlanningComponent."Quantity (Base)";
              QtyPerUOM := PlanningComponent."Qty. per Unit of Measure";
            end;
          Database::"Transfer Line":
            begin
              TransLine.Find;
              if ReservEntry."Source Subtype" = 0 then begin // Outbound
                TransLine.CalcFields("Reserved Quantity Outbnd.","Reserved Qty. Outbnd. (Base)");
                QtyReserved := TransLine."Reserved Quantity Outbnd.";
                QtyReservedBase := TransLine."Reserved Qty. Outbnd. (Base)";
                QtyToReserve := TransLine."Outstanding Quantity";
                QtyToReserveBase := TransLine."Outstanding Qty. (Base)";
              end else begin // Inbound
                TransLine.CalcFields("Reserved Quantity Inbnd.","Reserved Qty. Inbnd. (Base)");
                QtyReserved := TransLine."Reserved Quantity Inbnd.";
                QtyReservedBase := TransLine."Reserved Qty. Inbnd. (Base)";
                QtyToReserve := TransLine."Outstanding Quantity";
                QtyToReserveBase := TransLine."Outstanding Qty. (Base)";
              end;
              QtyPerUOM := TransLine."Qty. per Unit of Measure";
            end;
          Database::"Service Line":
            begin
              ServiceLine.Find;
              ServiceLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ServiceLine."Reserved Quantity";
              QtyReservedBase := ServiceLine."Reserved Qty. (Base)";
              QtyToReserve := ServiceLine."Outstanding Quantity";
              QtyToReserveBase := ServiceLine."Outstanding Qty. (Base)";
              QtyPerUOM := ServiceLine."Qty. per Unit of Measure";
            end;
          Database::"Job Planning Line":
            begin
              JobPlanningLine.Find;
              JobPlanningLine.CalcFields("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := JobPlanningLine."Reserved Quantity";
              QtyReservedBase := JobPlanningLine."Reserved Qty. (Base)";
              QtyToReserve := JobPlanningLine."Remaining Qty.";
              QtyToReserveBase := JobPlanningLine."Remaining Qty. (Base)";
              QtyPerUOM := JobPlanningLine."Qty. per Unit of Measure";
            end;
        end;

        UpdateReservMgt;
        ReservMgt.UpdateStatistics(
          Rec,ReservEntry."Shipment Date",HandleItemTracking);

        if HandleItemTracking then begin
          EntrySummary := Rec;
          QtyReservedBase := 0;
          if FindSet then
            repeat
              QtyReservedBase += ReservedThisLine(Rec);
            until Next = 0;
          QtyReservedIT := ROUND(QtyReservedBase / QtyPerUOM,0.00001);
          if Abs(QtyReserved - QtyReservedIT) > 0.00001 then
            QtyReserved := QtyReservedIT;
          QtyToReserveBase := ItemTrackingQtyToReserveBase;
          if Abs(ItemTrackingQtyToReserve - QtyToReserve) > 0.00001 then
            QtyToReserve := ItemTrackingQtyToReserve;
          Rec := EntrySummary;
        end;

        UpdateNonSpecific; // Late Binding

        if FormIsOpen then
          CurrPage.Update;
    end;

    local procedure UpdateReservMgt()
    begin
        Clear(ReservMgt);
        case ReservEntry."Source Type" of
          Database::"Sales Line":
            ReservMgt.SetSalesLine(SalesLine);
          Database::"Requisition Line":
            ReservMgt.SetReqLine(ReqLine);
          Database::"Purchase Line":
            ReservMgt.SetPurchLine(PurchLine);
          Database::"Item Journal Line":
            ReservMgt.SetItemJnlLine(ItemJnlLine);
          Database::"Prod. Order Line":
            ReservMgt.SetProdOrderLine(ProdOrderLine);
          Database::"Prod. Order Component":
            ReservMgt.SetProdOrderComponent(ProdOrderComp);
          Database::"Assembly Header":
            ReservMgt.SetAssemblyHeader(AssemblyHeader);
          Database::"Assembly Line":
            ReservMgt.SetAssemblyLine(AssemblyLine);
          Database::"Planning Component":
            ReservMgt.SetPlanningComponent(PlanningComponent);
          Database::"Transfer Line":
            ReservMgt.SetTransferLine(TransLine,ReservEntry."Source Subtype");
          Database::"Service Line":
            ReservMgt.SetServLine(ServiceLine);
          Database::"Job Planning Line":
            ReservMgt.SetJobPlanningLine(JobPlanningLine);
        end;
        ReservMgt.SetSerialLotNo(ReservEntry."Serial No.",ReservEntry."Lot No.");
    end;

    local procedure DrillDownTotalQuantity()
    var
        Location: Record Location;
        CreatePick: Codeunit "Create Pick";
    begin
        if HandleItemTracking and ("Entry No." <> 1) then begin
          Clear(AvailableItemTrackingLines);
          AvailableItemTrackingLines.SetItemTrackingLine("Table ID","Source Subtype",ReservEntry,
            ReservMgt.IsPositive,ReservEntry."Shipment Date");
          AvailableItemTrackingLines.RunModal;
          exit;
        end;

        ReservEntry2 := ReservEntry;
        if not Location.Get(ReservEntry2."Location Code") then
          Clear(Location);
        case "Entry No." of
          1:
            begin // Item Ledger Entry
              Clear(AvailableItemLedgEntries);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableItemLedgEntries.SetSalesLine(SalesLine,ReservEntry2);
                    if Location."Bin Mandatory" or Location."Require Pick" then
                      AvailableItemLedgEntries.SetTotalAvailQty(
                        "Total Available Quantity" +
                        CreatePick.CheckOutBound(
                          ReservEntry2."Source Type",ReservEntry2."Source Subtype",
                          ReservEntry2."Source ID",ReservEntry2."Source Ref. No.",
                          ReservEntry2."Source Prod. Order Line"))
                    else
                      AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                    AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableItemLedgEntries.SetReqLine(ReqLine,ReservEntry2);
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableItemLedgEntries.SetPurchLine(PurchLine,ReservEntry2);
                    if Location."Bin Mandatory" or Location."Require Pick" and
                       (PurchLine."Document Type" = PurchLine."document type"::"Return Order")
                    then
                      AvailableItemLedgEntries.SetTotalAvailQty(
                        "Total Available Quantity" +
                        CreatePick.CheckOutBound(
                          ReservEntry2."Source Type",ReservEntry2."Source Subtype",
                          ReservEntry2."Source ID",ReservEntry2."Source Ref. No.",
                          ReservEntry2."Source Prod. Order Line"))
                    else
                      AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableItemLedgEntries.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableItemLedgEntries.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    if Location."Bin Mandatory" or Location."Require Pick" then
                      AvailableItemLedgEntries.SetTotalAvailQty(
                        "Total Available Quantity" +
                        CreatePick.CheckOutBound(
                          ReservEntry2."Source Type",ReservEntry2."Source Subtype",
                          ReservEntry2."Source ID",ReservEntry2."Source Ref. No.",
                          ReservEntry2."Source Prod. Order Line"))
                    else
                      AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableItemLedgEntries.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableItemLedgEntries.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    if Location."Bin Mandatory" or Location."Require Pick" then
                      AvailableItemLedgEntries.SetTotalAvailQty(
                        "Total Available Quantity" +
                        CreatePick.CheckOutBound(
                          ReservEntry2."Source Type",ReservEntry2."Source Subtype",
                          ReservEntry2."Source ID",ReservEntry2."Source Ref. No.",
                          ReservEntry2."Source Prod. Order Line"))
                    else
                      AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableItemLedgEntries.SetServiceLine(ServiceLine,ReservEntry2);
                    AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                    AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableItemLedgEntries.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                    AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                    AvailableItemLedgEntries.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableItemLedgEntries.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                    AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                    AvailableItemLedgEntries.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableItemLedgEntries.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                    AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                    AvailableItemLedgEntries.RunModal;
                  end ;
              end;
            end;
          11,12,13,14,15,16:
            begin // Purchase Line
              Clear(AvailablePurchLines);
              AvailablePurchLines.SetCurrentSubType("Entry No." - 11);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailablePurchLines.SetSalesLine(SalesLine,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailablePurchLines.SetReqLine(ReqLine,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailablePurchLines.SetPurchLine(PurchLine,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailablePurchLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailablePurchLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailablePurchLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailablePurchLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailablePurchLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailablePurchLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailablePurchLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailablePurchLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailablePurchLines.RunModal;
                  end ;
              end;
            end;
          21:
            begin // Requisition Line
              Clear(AvailableReqLines);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableReqLines.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableReqLines.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableReqLines.SetReqLine(ReqLine,ReservEntry2);
                    AvailableReqLines.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableReqLines.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableReqLines.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableReqLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableReqLines.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableReqLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableReqLines.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableReqLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableReqLines.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableReqLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableReqLines.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableReqLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailableReqLines.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableJobPlanningLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableJobPlanningLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableJobPlanningLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end ;
              end;
            end;
          31,32,33,34,35,36:
            begin // Sales Line
              Clear(AvailableSalesLines);
              AvailableSalesLines.SetCurrentSubType("Entry No." - 31);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableSalesLines.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableSalesLines.SetReqLine(ReqLine,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableSalesLines.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableSalesLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableSalesLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableSalesLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableSalesLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableSalesLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableSalesLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableSalesLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableSalesLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableSalesLines.RunModal;
                  end ;
              end;
            end;
          61,62,63,64:
            begin
              Clear(AvailableProdOrderLines);
              AvailableProdOrderLines.SetCurrentSubType("Entry No." - 61);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableProdOrderLines.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableProdOrderLines.SetReqLine(ReqLine,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableProdOrderLines.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableProdOrderLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableProdOrderLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableProdOrderLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableProdOrderLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableProdOrderLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableProdOrderLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableProdOrderLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableProdOrderLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableProdOrderLines.RunModal;
                  end ;
              end;
            end;
          71,72,73,74:
            begin
              Clear(AvailableProdOrderComps);
              AvailableProdOrderComps.SetCurrentSubType("Entry No." - 71);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableProdOrderComps.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableProdOrderComps.SetReqLine(ReqLine,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableProdOrderComps.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableProdOrderComps.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableProdOrderComps.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableProdOrderComps.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableProdOrderComps.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableProdOrderComps.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableProdOrderComps.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableProdOrderComps.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableProdOrderComps.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableProdOrderComps.RunModal;
                  end ;
              end;
            end;
          91:
            begin
              Clear(AvailablePlanningComponents);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailablePlanningComponents.SetSalesLine(SalesLine,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailablePlanningComponents.SetReqLine(ReqLine,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailablePlanningComponents.SetPurchLine(PurchLine,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailablePlanningComponents.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailablePlanningComponents.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailablePlanningComponents.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailablePlanningComponents.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailablePlanningComponents.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailablePlanningComponents.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailablePlanningComponents.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailablePlanningComponents.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailablePlanningComponents.RunModal;
                  end ;
              end;
            end;
          101,102:
            begin
              Clear(AvailableTransLines);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableTransLines.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableTransLines.SetReqLine(ReqLine,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableTransLines.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableTransLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableTransLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableTransLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableTransLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableTransLines.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableTransLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableTransLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableTransLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableTransLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableTransLines.RunModal;
                  end ;
              end;
            end;
          110:
            begin // Service Line
              Clear(AvailableServiceLines);
              AvailableServiceLines.SetCurrentSubType("Entry No." - 109);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableServiceLines.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableServiceLines.SetReqLine(ReqLine,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableServiceLines.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableServiceLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableServiceLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableServiceLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableServiceLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableServiceLines.SetServInvLine(ServiceLine,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableServiceLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableServiceLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableServiceLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableServiceLines.RunModal;
                  end ;
              end;
            end;
          131,132,133,134:
            begin // Job Planning Line
              Clear(AvailableJobPlanningLines);
              AvailableJobPlanningLines.SetCurrentSubType("Entry No." - 131);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableJobPlanningLines.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableJobPlanningLines.SetReqLine(ReqLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableJobPlanningLines.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableJobPlanningLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableJobPlanningLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableJobPlanningLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableJobPlanningLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableJobPlanningLines.SetServLine(ServiceLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableJobPlanningLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableJobPlanningLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableJobPlanningLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableJobPlanningLines.RunModal;
                  end ;
              end;
            end;
          141,  142:
            begin // Asm Header
              Clear(AvailableAssemblyHeaders);
              AvailableAssemblyHeaders.SetCurrentSubType("Entry No." - 141);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableAssemblyHeaders.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableAssemblyHeaders.SetReqLine(ReqLine,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableAssemblyHeaders.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableAssemblyHeaders.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableAssemblyHeaders.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableAssemblyHeaders.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableAssemblyHeaders.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableAssemblyHeaders.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableAssemblyHeaders.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableAssemblyHeaders.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableAssemblyHeaders.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableAssemblyHeaders.RunModal;
                  end ;
              end;
            end;
          151,152:
            begin // Asm Line
              Clear(AvailableAssemblyLines);
              AvailableAssemblyLines.SetCurrentSubType("Entry No." - 151);
              case ReservEntry2."Source Type" of
                Database::"Sales Line":
                  begin
                    AvailableAssemblyLines.SetSalesLine(SalesLine,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Requisition Line":
                  begin
                    AvailableAssemblyLines.SetReqLine(ReqLine,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Purchase Line":
                  begin
                    AvailableAssemblyLines.SetPurchLine(PurchLine,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Prod. Order Line":
                  begin
                    AvailableAssemblyLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Prod. Order Component":
                  begin
                    AvailableAssemblyLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Planning Component":
                  begin
                    AvailableAssemblyLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Transfer Line":
                  begin
                    AvailableAssemblyLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Service Line":
                  begin
                    AvailableAssemblyLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Job Planning Line":
                  begin
                    AvailableAssemblyLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end;
                Database::"Assembly Header":
                  begin
                    AvailableAssemblyLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end ;
                Database::"Assembly Line":
                  begin
                    AvailableAssemblyLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                    AvailableAssemblyLines.RunModal;
                  end ;
              end;
            end;
        end;

        UpdateReservFrom;
    end;

    local procedure DrillDownReservedQuantity()
    begin
        ReservEntry2.Reset;

        ReservEntry2.SetCurrentkey(
          "Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code",
          "Shipment Date","Expected Receipt Date","Serial No.","Lot No.");

        FilterReservEntry(ReservEntry2,Rec);
        Page.RunModal(Page::"Reservation Entries",ReservEntry2);

        UpdateReservFrom;
    end;

    local procedure DrillDownReservedThisLine()
    var
        ReservEntry3: Record "Reservation Entry";
        LotSNMatch: Boolean;
    begin
        Clear(ReservEntry2);

        ReservEntry2.SetCurrentkey(
          "Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code",
          "Shipment Date","Expected Receipt Date","Serial No.","Lot No.");

        FilterReservEntry(ReservEntry2,Rec);
        if ReservEntry2.Find('-') then
          repeat
            ReservEntry3.Get(ReservEntry2."Entry No.",not ReservEntry2.Positive);

            if ReservEntry.TrackingExists then
              LotSNMatch := (ReservEntry3."Serial No." = ReservEntry."Serial No.") and
                (ReservEntry3."Lot No." = ReservEntry."Lot No.")
            else
              LotSNMatch := true;

            ReservEntry2.Mark((ReservEntry3."Source Type" = ReservEntry."Source Type") and
              (ReservEntry3."Source Subtype" = ReservEntry."Source Subtype") and
              (ReservEntry3."Source ID" = ReservEntry."Source ID") and
              (ReservEntry3."Source Batch Name" = ReservEntry."Source Batch Name") and
              (ReservEntry3."Source Prod. Order Line" = ReservEntry."Source Prod. Order Line") and
              (ReservEntry3."Source Ref. No." = ReservEntry."Source Ref. No.") and
              ((LotSNMatch and HandleItemTracking) or
               not HandleItemTracking));
          until ReservEntry2.Next = 0;

        ReservEntry2.MarkedOnly(true);
        Page.RunModal(Page::"Reservation Entries",ReservEntry2);

        UpdateReservFrom;
    end;


    procedure ReservedThisLine(ReservSummEntry2: Record "Entry Summary" temporary) ReservedQuantity: Decimal
    var
        ReservEntry3: Record "Reservation Entry";
    begin
        Clear(ReservEntry2);

        ReservEntry2.SetCurrentkey(
          "Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code",
          "Shipment Date","Expected Receipt Date","Serial No.","Lot No.");
        ReservedQuantity := 0;

        FilterReservEntry(ReservEntry2,ReservSummEntry2);
        if ReservEntry2.Find('-') then
          repeat
            ReservEntry3.Get(ReservEntry2."Entry No.",not ReservEntry2.Positive);
            if (ReservEntry3."Source Type" = ReservEntry."Source Type") and
               (ReservEntry3."Source Subtype" = ReservEntry."Source Subtype") and
               (ReservEntry3."Source ID" = ReservEntry."Source ID") and
               (ReservEntry3."Source Batch Name" = ReservEntry."Source Batch Name") and
               (ReservEntry3."Source Prod. Order Line" = ReservEntry."Source Prod. Order Line") and
               (ReservEntry3."Source Ref. No." = ReservEntry."Source Ref. No.") and
               (((ReservEntry3."Serial No." = ReservEntry."Serial No.") and
                 (ReservEntry3."Lot No." = ReservEntry."Lot No.") and
                 HandleItemTracking) or
                not HandleItemTracking)
            then
              ReservedQuantity += ReservEntry2."Quantity (Base)" * CreateReservEntry.SignFactor(ReservEntry2);
          until ReservEntry2.Next = 0;

        exit(ReservedQuantity);
    end;

    local procedure GetSerialLotNo(var ItemTrackingQtyToReserve: Decimal;var ItemTrackingQtyToReserveBase: Decimal)
    var
        Item: Record Item;
        ReservEntry2: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        SignFactor: Integer;
    begin
        Item.Get(ReservEntry."Item No.");
        if Item."Item Tracking Code" = '' then
          exit;
        ReservEntry2 := ReservEntry;
        ReservMgt.SetPointerFilter(ReservEntry2);
        ItemTrackingMgt.SumUpItemTracking(ReservEntry2,TempTrackingSpecification,true,true);

        if TempTrackingSpecification.Find('-') then begin
          if not Confirm(StrSubstNo(Text006))
          then
            exit;
          repeat
            TempReservEntry.TransferFields(TempTrackingSpecification);
            TempReservEntry.Insert;
          until TempTrackingSpecification.Next = 0;

          if Page.RunModal(Page::"Item Tracking List",TempReservEntry) = Action::LookupOK then begin
            ReservEntry."Serial No." := TempReservEntry."Serial No.";
            ReservEntry."Lot No." := TempReservEntry."Lot No.";
            CaptionText += StrSubstNo(Text007,ReservEntry."Serial No.",ReservEntry."Lot No.");
            SignFactor := CreateReservEntry.SignFactor(TempReservEntry);
            ItemTrackingQtyToReserveBase := TempReservEntry."Quantity (Base)" * SignFactor;
            ItemTrackingQtyToReserve := ROUND(ItemTrackingQtyToReserveBase / TempReservEntry."Qty. per Unit of Measure",0.00001);
            HandleItemTracking := true;
          end else
            Error(Text008);
        end;
    end;

    local procedure UpdateNonSpecific()
    begin
        SetFilter("Non-specific Reserved Qty.",'>%1',0);
        NoteTextVisible := not IsEmpty;
        NonSpecificQty := "Non-specific Reserved Qty.";
        SetRange("Non-specific Reserved Qty.");
    end;


    procedure AutoReserve()
    begin
        if Abs(QtyToReserveBase) - Abs(QtyReservedBase) = 0 then
          Error(Text000);

        ReservMgt.AutoReserve(
          FullAutoReservation,ReservEntry.Description,
          ReservEntry."Shipment Date",QtyToReserve - QtyReserved,QtyToReserveBase - QtyReservedBase);
        if not FullAutoReservation then
          Message(Text001);
        UpdateReservFrom;
    end;
}

