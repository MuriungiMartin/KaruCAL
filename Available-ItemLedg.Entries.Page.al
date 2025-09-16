#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 504 "Available - Item Ledg. Entries"
{
    Caption = 'Available - Item Ledg. Entries';
    DataCaptionExpression = CaptionText;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData "Item Ledger Entry"=rm;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Item No.",Open);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a serial number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location that the entry is linked to.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that remains in inventory in the Quantity field if the entry is an increase (a purchase or positive adjustment).';
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                }
                field(QtyToReserve;QtyToReserve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of the item that is available for reservation.';
                }
                field(ReservedThisLine;ReservedThisLine)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Reserved Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity of the item that is reserved from the item ledger entry, for the current line or entry.';

                    trigger OnDrillDown()
                    begin
                        ReservEntry2.Reset;
                        ReserveItemLedgEntry.FilterReservFor(ReservEntry2,Rec);
                        ReservEntry2.SetRange("Reservation Status",ReservEntry2."reservation status"::Reservation);
                        ReservMgt.MarkReservConnection(ReservEntry2,ReservEntry);
                        Page.RunModal(Page::"Reservation Entries",ReservEntry2);
                        UpdateReservFrom;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
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
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Image = Reserve;
                    ToolTip = 'Reserve the quantity that is required on the document line that you opened this window for.';

                    trigger OnAction()
                    var
                        NewQtyReservedThisLine2: Decimal;
                    begin
                        ReservEntry.LockTable;
                        UpdateReservMgt;
                        ReservMgt.ItemLedgEntryUpdateValues(Rec,QtyToReserve,QtyReservedThisLine);
                        ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine2,NewQtyReservedThisLine);
                        if MaxQtyDefined and (Abs(MaxQtyToReserve) < Abs(NewQtyReservedThisLine)) then
                          NewQtyReservedThisLine := MaxQtyToReserve;

                        ReservMgt.CopySign(NewQtyReservedThisLine,QtyToReserve);
                        if NewQtyReservedThisLine <> 0 then begin
                          if Abs(NewQtyReservedThisLine) > Abs(QtyToReserve) then begin
                            CreateReservation(QtyToReserve);
                            MaxQtyToReserve := MaxQtyToReserve - QtyToReserve;
                          end else begin
                            CreateReservation(NewQtyReservedThisLine);
                            MaxQtyToReserve := MaxQtyToReserve - NewQtyReservedThisLine;
                          end;
                          if MaxQtyToReserve < 0 then
                            MaxQtyToReserve := 0;
                        end else
                          Error(Text000);
                    end;
                }
                action(CancelReservation)
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = '&Cancel Reservation';
                    Image = Cancel;
                    ToolTip = 'Cancel the reservation that exists for the document line that you opened this window for.';

                    trigger OnAction()
                    begin
                        if not Confirm(Text001,false) then
                          exit;

                        ReservMgt.ItemLedgEntryUpdateValues(Rec,QtyToReserve,QtyReservedThisLine);

                        ReservEntry2.Copy(ReservEntry);
                        if ReservMgt.IsPositive then
                          ReserveItemLedgEntry.FilterReservFor(ReservEntry2,Rec)
                        else
                          Error(Text99000000);
                        ReservEntry2.SetRange("Expected Receipt Date");
                        if ReservEntry2.Find('-') then begin
                          UpdateReservMgt;
                          repeat
                            ReservEngineMgt.CancelReservation(ReservEntry2);
                          until ReservEntry2.Next = 0;

                          TotalAvailQty := TotalAvailQty + QtyReservedThisLine;
                          MaxQtyToReserve := MaxQtyToReserve + QtyReservedThisLine;
                          UpdateReservFrom;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ReservMgt.ItemLedgEntryUpdateValues(Rec,QtyToReserve,QtyReservedThisLine);
    end;

    trigger OnOpenPage()
    begin
        ReservEntry.TestField("Source Type");

        Reset;
        SetRange("Item No.",ReservEntry."Item No.");
        SetRange("Variant Code",ReservEntry."Variant Code");
        SetRange("Location Code",ReservEntry."Location Code");
        SetRange("Drop Shipment",false);
        SetRange(Open,true);
        if ReservMgt.FieldFilterNeeded2(ReservEntry,ReservMgt.IsPositive,0) then
          SetFilter("Lot No.",ReservMgt.GetFieldFilter);
        if ReservMgt.FieldFilterNeeded2(ReservEntry,ReservMgt.IsPositive,1) then
          SetFilter("Serial No.",ReservMgt.GetFieldFilter);
        if ReservMgt.IsPositive then begin
          SetRange(Positive,true);
          SetFilter("Remaining Quantity",'>0');
        end else begin
          SetRange(Positive,false);
          SetFilter("Remaining Quantity",'<0');
        end;
    end;

    var
        Text000: label 'Fully reserved.';
        Text001: label 'Do you want to cancel the reservation?';
        Text002: label 'Reservation cannot be carried out because the available quantity is already allocated in a warehouse.';
        Text99000000: label 'You can only cancel reservations to inventory.';
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ReqLine: Record "Requisition Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        TransLine: Record "Transfer Line";
        ServiceLine: Record "Service Line";
        JobPlanningLine: Record "Job Planning Line";
        AssemblyLine: Record "Assembly Line";
        AssemblyHeader: Record "Assembly Header";
        ReservMgt: Codeunit "Reservation Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        ReservePlanningComponent: Codeunit "Plng. Component-Reserve";
        ReserveItemLedgEntry: Codeunit "Item Ledger Entry-Reserve";
        ReserveTransLine: Codeunit "Transfer Line-Reserve";
        ReserveServiceLine: Codeunit "Service Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
        AssemblyHeaderReserve: Codeunit "Assembly Header-Reserve";
        QtyToReserve: Decimal;
        QtyReservedThisLine: Decimal;
        NewQtyReservedThisLine: Decimal;
        TotalAvailQty: Decimal;
        MaxQtyToReserve: Decimal;
        MaxQtyDefined: Boolean;
        CaptionText: Text[80];


    procedure SetSalesLine(var CurrentSalesLine: Record "Sales Line";CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentSalesLine.TestField(Type,CurrentSalesLine.Type::Item);
        SalesLine := CurrentSalesLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetSalesLine(SalesLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReserveSalesLine.FilterReservFor(ReservEntry,SalesLine);
        CaptionText := ReserveSalesLine.Caption(SalesLine);
    end;


    procedure SetReqLine(var CurrentReqLine: Record "Requisition Line";CurrentReservEntry: Record "Reservation Entry")
    begin
        ReqLine := CurrentReqLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetReqLine(ReqLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReserveReqLine.FilterReservFor(ReservEntry,ReqLine);
        CaptionText := ReserveReqLine.Caption(ReqLine);
    end;


    procedure SetPurchLine(var CurrentPurchLine: Record "Purchase Line";CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentPurchLine.TestField(Type,CurrentPurchLine.Type::Item);
        PurchLine := CurrentPurchLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetPurchLine(PurchLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReservePurchLine.FilterReservFor(ReservEntry,PurchLine);
        CaptionText := ReservePurchLine.Caption(PurchLine);
    end;


    procedure SetProdOrderLine(var CurrentProdOrderLine: Record "Prod. Order Line";CurrentReservEntry: Record "Reservation Entry")
    begin
        ProdOrderLine := CurrentProdOrderLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetProdOrderLine(ProdOrderLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReserveProdOrderLine.FilterReservFor(ReservEntry,ProdOrderLine);
        CaptionText := ReserveProdOrderLine.Caption(ProdOrderLine);
    end;


    procedure SetProdOrderComponent(var CurrentProdOrderComp: Record "Prod. Order Component";CurrentReservEntry: Record "Reservation Entry")
    begin
        ProdOrderComp := CurrentProdOrderComp;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetProdOrderComponent(ProdOrderComp);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReserveProdOrderComp.FilterReservFor(ReservEntry,ProdOrderComp);
        CaptionText := ReserveProdOrderComp.Caption(ProdOrderComp);
    end;


    procedure SetPlanningComponent(var CurrentPlanningComponent: Record "Planning Component";CurrentReservEntry: Record "Reservation Entry")
    begin
        PlanningComponent := CurrentPlanningComponent;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetPlanningComponent(PlanningComponent);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReservePlanningComponent.FilterReservFor(ReservEntry,PlanningComponent);
        CaptionText := ReservePlanningComponent.Caption(PlanningComponent);
    end;


    procedure SetTransferLine(var CurrentTransLine: Record "Transfer Line";CurrentReservEntry: Record "Reservation Entry";Direction: Option Outbound,Inbound)
    begin
        TransLine := CurrentTransLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetTransferLine(TransLine,Direction);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReserveTransLine.FilterReservFor(ReservEntry,TransLine,Direction);
        CaptionText := ReserveTransLine.Caption(TransLine);
    end;


    procedure SetServiceLine(var CurrentServiceLine: Record "Service Line";CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentServiceLine.TestField(Type,CurrentServiceLine.Type::Item);
        ServiceLine := CurrentServiceLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetServLine(ServiceLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReserveServiceLine.FilterReservFor(ReservEntry,ServiceLine);
        CaptionText := ReserveServiceLine.Caption(ServiceLine);
    end;


    procedure SetJobPlanningLine(var CurrentJobPlanningLine: Record "Job Planning Line";CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentJobPlanningLine.TestField(Type,CurrentJobPlanningLine.Type::Item);
        JobPlanningLine := CurrentJobPlanningLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetJobPlanningLine(JobPlanningLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        JobPlanningLineReserve.FilterReservFor(ReservEntry,JobPlanningLine);
        CaptionText := JobPlanningLineReserve.Caption(JobPlanningLine);
    end;


    procedure SetTotalAvailQty(TotalAvailQty2: Decimal)
    begin
        TotalAvailQty := TotalAvailQty2;
    end;


    procedure SetMaxQtyToReserve(NewMaxQtyToReserve: Decimal)
    begin
        MaxQtyToReserve := NewMaxQtyToReserve;
        MaxQtyDefined := true;
    end;


    procedure SetAssemblyLine(var CurrentAsmLine: Record "Assembly Line";CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentAsmLine.TestField(Type,CurrentAsmLine.Type::Item);
        AssemblyLine := CurrentAsmLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetAssemblyLine(AssemblyLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        AssemblyLineReserve.FilterReservFor(ReservEntry,AssemblyLine);
        CaptionText := AssemblyLineReserve.Caption(AssemblyLine);
    end;


    procedure SetAssemblyHeader(var CurrentAsmHeader: Record "Assembly Header";CurrentReservEntry: Record "Reservation Entry")
    begin
        AssemblyHeader := CurrentAsmHeader;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetAssemblyHeader(AssemblyHeader);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        AssemblyHeaderReserve.FilterReservFor(ReservEntry,AssemblyHeader);
        CaptionText := AssemblyHeaderReserve.Caption(AssemblyHeader);
    end;

    local procedure CreateReservation(var ReserveQuantity: Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TestField("Drop Shipment",false);
        TestField("Item No.",ReservEntry."Item No.");
        TestField("Variant Code",ReservEntry."Variant Code");
        TestField("Location Code",ReservEntry."Location Code");

        if TotalAvailQty < 0 then begin
          ReserveQuantity := 0;
          exit;
        end;

        if TotalAvailQty < ReserveQuantity then
          ReserveQuantity := TotalAvailQty;
        TotalAvailQty := TotalAvailQty - ReserveQuantity;

        if (TotalAvailQty = 0) and
           (ReserveQuantity = 0) and
           (QtyToReserve <> 0)
        then
          Error(Text002);

        UpdateReservMgt;
        TrackingSpecification.InitTrackingSpecification(
          Database::"Item Ledger Entry",0,'','',0,"Entry No.",
          "Variant Code","Location Code","Serial No.","Lot No.","Qty. per Unit of Measure");
        ReservMgt.CreateReservation(
          ReservEntry.Description,0D,0,ReserveQuantity,TrackingSpecification);
        UpdateReservFrom;
    end;

    local procedure UpdateReservFrom()
    begin
        case ReservEntry."Source Type" of
          Database::"Sales Line":
            begin
              SalesLine.Find;
              SetSalesLine(SalesLine,ReservEntry);
            end;
          Database::"Requisition Line":
            begin
              ReqLine.Find;
              SetReqLine(ReqLine,ReservEntry);
            end;
          Database::"Purchase Line":
            begin
              PurchLine.Find;
              SetPurchLine(PurchLine,ReservEntry);
            end;
          Database::"Prod. Order Line":
            begin
              ProdOrderLine.Find;
              SetProdOrderLine(ProdOrderLine,ReservEntry);
            end;
          Database::"Prod. Order Component":
            begin
              ProdOrderComp.Find;
              SetProdOrderComponent(ProdOrderComp,ReservEntry);
            end;
          Database::"Planning Component":
            begin
              PlanningComponent.Find;
              SetPlanningComponent(PlanningComponent,ReservEntry);
            end;
          Database::"Transfer Line":
            begin
              TransLine.Find;
              SetTransferLine(TransLine,ReservEntry,ReservEntry."Source Subtype");
            end;
          Database::"Service Line":
            begin
              ServiceLine.Find;
              SetServiceLine(ServiceLine,ReservEntry);
            end;
          Database::"Job Planning Line":
            begin
              JobPlanningLine.Find;
              SetJobPlanningLine(JobPlanningLine,ReservEntry);
            end;
          Database::"Assembly Line":
            begin
              AssemblyLine.Find;
              SetAssemblyLine(AssemblyLine,ReservEntry);
            end;
          Database::"Assembly Header":
            begin
              AssemblyHeader.Find;
              SetAssemblyHeader(AssemblyHeader,ReservEntry);
            end;
        end;
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
          Database::"Prod. Order Line":
            ReservMgt.SetProdOrderLine(ProdOrderLine);
          Database::"Prod. Order Component":
            ReservMgt.SetProdOrderComponent(ProdOrderComp);
          Database::"Planning Component":
            ReservMgt.SetPlanningComponent(PlanningComponent);
          Database::"Transfer Line":
            ReservMgt.SetTransferLine(TransLine,ReservEntry."Source Subtype");
          Database::"Service Line":
            ReservMgt.SetServLine(ServiceLine);
          Database::"Job Planning Line":
            ReservMgt.SetJobPlanningLine(JobPlanningLine);
          Database::"Assembly Line":
            ReservMgt.SetAssemblyLine(AssemblyLine);
          Database::"Assembly Header":
            ReservMgt.SetAssemblyHeader(AssemblyHeader);
        end;
        ReservMgt.SetSerialLotNo(ReservEntry."Serial No.",ReservEntry."Lot No.");
    end;

    local procedure ReservedThisLine(): Decimal
    begin
        ReservEntry2.Reset;
        ReserveItemLedgEntry.FilterReservFor(ReservEntry2,Rec);
        ReservEntry2.SetRange("Reservation Status",ReservEntry2."reservation status"::Reservation);
        exit(ReservMgt.MarkReservConnection(ReservEntry2,ReservEntry));
    end;
}

