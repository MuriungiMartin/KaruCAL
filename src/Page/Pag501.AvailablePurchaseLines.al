#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 501 "Available - Purchase Lines"
{
    Caption = 'Available - Purchase Lines';
    DataCaptionExpression = CaptionText;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData "Purchase Line"=rm;
    SourceTable = "Purchase Line";
    SourceTableView = sorting("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document that you are about to create.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse.';
                }
                field("Outstanding Qty. (Base)";"Outstanding Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is automatically updated. The field shows the Outstanding Quantity expressed in base units of measure.';
                }
                field("Reserved Qty. (Base)";"Reserved Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Updates this field when the Reserved Quantity field is updated. The field shows the reserved quantity of the item expressed in base units of measure.';
                }
                field(QtyToReserveBase;QtyToReserveBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of the item on the line that is available for reservation.';
                }
                field(ReservedThisLine;ReservedThisLine)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Reserved Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity of the item that is reserved from the purchase line, for the current line or entry.';

                    trigger OnDrillDown()
                    begin
                        ReservEntry2.Reset;
                        ReservePurchLine.FilterReservFor(ReservEntry2,Rec);
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
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

                    trigger OnAction()
                    begin
                        ReservEntry.LockTable;
                        UpdateReservMgt;
                        ReservMgt.PurchLineUpdateValues(Rec,QtyToReserve,QtyToReserveBase,QtyReservedThisLine,QtyReservedThisLineBase);
                        ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine,NewQtyReservedThisLineBase);
                        ReservMgt.CopySign(NewQtyReservedThisLineBase,QtyToReserveBase);
                        ReservMgt.CopySign(NewQtyReservedThisLine,QtyToReserve);
                        if NewQtyReservedThisLineBase <> 0 then
                          if Abs(NewQtyReservedThisLineBase) > Abs(QtyToReserveBase) then
                            CreateReservation(QtyToReserve,QtyToReserveBase)
                          else
                            CreateReservation(NewQtyReservedThisLine,NewQtyReservedThisLineBase)
                        else
                          Error(Text000);
                    end;
                }
                action(CancelReservation)
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = '&Cancel Reservation';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        if not Confirm(Text001,false) then
                          exit;

                        ReservEntry2.Copy(ReservEntry);
                        ReservePurchLine.FilterReservFor(ReservEntry2,Rec);

                        if ReservEntry2.Find('-') then begin
                          UpdateReservMgt;
                          repeat
                            ReservEngineMgt.CancelReservation(ReservEntry2);
                          until ReservEntry2.Next = 0;

                          UpdateReservFrom;
                        end;
                    end;
                }
                action(ShowDocument)
                {
                    ApplicationArea = Basic;
                    Caption = '&Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        PurchHeader.Get("Document Type","Document No.");
                        PageManagement.PageRun(PurchHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ReservMgt.PurchLineUpdateValues(Rec,QtyToReserve,QtyToReserveBase,QtyReservedThisLine,QtyReservedThisLineBase);
    end;

    trigger OnOpenPage()
    begin
        ReservEntry.TestField("Source Type");

        SetRange("Document Type",CurrentSubType);
        SetRange(Type,Type::Item);
        SetRange("No.",ReservEntry."Item No.");
        SetRange("Variant Code",ReservEntry."Variant Code");
        SetRange("Job No.",'');
        SetRange("Drop Shipment",false);
        SetRange("Location Code",ReservEntry."Location Code");

        SetFilter("Expected Receipt Date",ReservMgt.GetAvailabilityFilter(ReservEntry."Shipment Date"));

        case CurrentSubType of
          0,1,2,4:
            if ReservMgt.IsPositive then
              SetFilter("Quantity (Base)",'>0')
            else
              SetFilter("Quantity (Base)",'<0');
          3,5:
            if ReservMgt.IsPositive then
              SetFilter("Quantity (Base)",'<0')
            else
              SetFilter("Quantity (Base)",'>0');
        end;
    end;

    var
        Text000: label 'Fully reserved.';
        Text001: label 'Do you want to cancel the reservation?';
        Text003: label 'Available Quantity is %1.';
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        PurchHeader: Record "Purchase Header";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ReqLine: Record "Requisition Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        TransLine: Record "Transfer Line";
        ServiceInvLine: Record "Service Line";
        JobPlanningLine: Record "Job Planning Line";
        AssemblyLine: Record "Assembly Line";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
        AssemblyHeaderReserve: Codeunit "Assembly Header-Reserve";
        ReservMgt: Codeunit "Reservation Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        ReservePlanningComponent: Codeunit "Plng. Component-Reserve";
        ReserveTransLine: Codeunit "Transfer Line-Reserve";
        ReserveServiceInvLine: Codeunit "Service Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        QtyReservedThisLine: Decimal;
        QtyReservedThisLineBase: Decimal;
        NewQtyReservedThisLine: Decimal;
        NewQtyReservedThisLineBase: Decimal;
        CaptionText: Text[80];
        Direction: Option Outbound,Inbound;
        CurrentSubType: Option;


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


    procedure SetTransferLine(var CurrentTransLine: Record "Transfer Line";CurrentReservEntry: Record "Reservation Entry";CurrDirection: Option Outbound,Inbound)
    begin
        TransLine := CurrentTransLine;
        ReservEntry := CurrentReservEntry;
        Direction := CurrDirection;

        Clear(ReservMgt);
        ReservMgt.SetTransferLine(TransLine,Direction);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReserveTransLine.FilterReservFor(ReservEntry,TransLine,Direction);
        CaptionText := ReserveTransLine.Caption(TransLine);
    end;


    procedure SetServiceInvLine(var CurrentServiceInvLine: Record "Service Line";CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentServiceInvLine.TestField(Type,CurrentServiceInvLine.Type::Item);
        ServiceInvLine := CurrentServiceInvLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetServLine(ServiceInvLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,true);
        ReserveServiceInvLine.FilterReservFor(ReservEntry,ServiceInvLine);
        CaptionText := ReserveServiceInvLine.Caption(ServiceInvLine);
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

    local procedure CreateReservation(ReservedQuantity: Decimal;ReserveQuantityBase: Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        CalcFields("Reserved Qty. (Base)");
        if (Abs("Outstanding Qty. (Base)") - Abs("Reserved Qty. (Base)")) < ReserveQuantityBase then
          Error(Text003,Abs("Outstanding Qty. (Base)") - "Reserved Qty. (Base)");

        TestField("Job No.",'');
        TestField("Drop Shipment",false);
        TestField("No.",ReservEntry."Item No.");
        TestField("Variant Code",ReservEntry."Variant Code");
        TestField("Location Code",ReservEntry."Location Code");

        UpdateReservMgt;
        TrackingSpecification.InitTrackingSpecification(
          Database::"Purchase Line","Document Type","Document No.",'',0,"Line No.",
          "Variant Code","Location Code",'','',"Qty. per Unit of Measure");
        ReservMgt.CreateReservation(
          ReservEntry.Description,"Expected Receipt Date",ReservedQuantity,ReserveQuantityBase,TrackingSpecification);
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
              ServiceInvLine.Find;
              SetServiceInvLine(ServiceInvLine,ReservEntry);
            end;
          Database::"Job Planning Line":
            begin
              JobPlanningLine.Find;
              SetJobPlanningLine(JobPlanningLine,ReservEntry);
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
            ReservMgt.SetServLine(ServiceInvLine);
          Database::"Job Planning Line":
            ReservMgt.SetJobPlanningLine(JobPlanningLine);
        end;
    end;

    local procedure ReservedThisLine(): Decimal
    begin
        ReservEntry2.Reset;
        if ReservEntry."Source Type" = Database::"Transfer Line" then
          ReservEntry."Source Subtype" := Direction;
        ReservePurchLine.FilterReservFor(ReservEntry2,Rec);
        ReservEntry2.SetRange("Reservation Status",ReservEntry2."reservation status"::Reservation);
        exit(ReservMgt.MarkReservConnection(ReservEntry2,ReservEntry));
    end;


    procedure SetCurrentSubType(SubType: Option)
    begin
        CurrentSubType := SubType;
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
}

