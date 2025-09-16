#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5522 "Order Planning"
{
    ApplicationArea = Basic;
    Caption = 'Order Planning';
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Requisition Line";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DemandOrderFilterCtrl;DemandOrderFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Demand as';
                    Enabled = DemandOrderFilterCtrlEnable;
                    OptionCaption = 'All Demand,Production Demand,Sales Demand,Service Demand,Job Demand,Assembly Demand';
                    ToolTip = 'Specifies a filter to define which demand types you want to display in the Order Planning window.';

                    trigger OnValidate()
                    begin
                        DemandOrderFilterOnAfterValida;
                    end;
                }
            }
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowAsTree = true;
                field("Demand Date";"Demand Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the demanded date of the demand that the planning line represents.';
                }
                field(StatusText;StatusText)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FIELDCAPTION(Status);
                    Editable = false;
                    HideValue = StatusHideValue;
                }
                field(DemandTypeText;DemandTypeText)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FIELDCAPTION("Demand Type");
                    Editable = false;
                    HideValue = DemandTypeHideValue;
                    Lookup = false;
                    Style = Strong;
                    StyleExpr = DemandTypeEmphasize;
                }
                field(DemandSubtypeText;DemandSubtypeText)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FIELDCAPTION("Demand Subtype");
                    Editable = false;
                    Visible = false;
                }
                field("Demand Order No.";"Demand Order No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Order No.';
                    HideValue = DemandOrderNoHideValue;
                    Style = Strong;
                    StyleExpr = DemandOrderNoEmphasize;
                    ToolTip = 'Specifies the number of the demanded order that represents the planning line.';
                }
                field("Demand Line No.";"Demand Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number of the demand, such as a sales order line.';
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                    Editable = false;
                    ToolTip = 'Specifies the number of the item with insufficient availability and must be planned.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a code for an inventory location where the items that are being ordered will be registered.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = DescriptionEmphasize;
                    ToolTip = 'Specifies text that describes the entry.';
                }
                field("Demand Quantity";"Demand Quantity")
                {
                    ApplicationArea = Basic;
                    HideValue = DemandQuantityHideValue;
                    ToolTip = 'Specifies the quantity on the demand that the planning line represents.';
                    Visible = false;
                }
                field("Demand Qty. Available";"Demand Qty. Available")
                {
                    ApplicationArea = Basic;
                    HideValue = DemandQtyAvailableHideValue;
                    ToolTip = 'Specifies how many of the demand quantity are available.';
                    Visible = false;
                }
                field("Needed Quantity";"Needed Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the demand quantity that is not available and must be ordered to meet the demand represented on the planning line.';
                    Visible = true;
                }
                field("Replenishment System";"Replenishment System")
                {
                    ApplicationArea = Basic;
                    HideValue = ReplenishmentSystemHideValue;
                    ToolTip = 'Specifies which kind of order to use to create replenishment orders and order proposals.';

                    trigger OnValidate()
                    begin
                        ReplenishmentSystemOnAfterVali;
                    end;
                }
                field("Supply From";"Supply From")
                {
                    ApplicationArea = Basic;
                    Editable = SupplyFromEditable;
                    ToolTip = 'Specifies a value, according to the selected replenishment system, before a supply order can be created for the line.';
                }
                field(Reserve;Reserve)
                {
                    ApplicationArea = Basic;
                    Editable = ReserveEditable;
                    ToolTip = 'Specifies whether the item on the planning line has a setting of Always in the Reserve field on its item card.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. to Order';
                    HideValue = QuantityHideValue;
                    ToolTip = 'Specifies the quantity that will be ordered on the supply order, such as purchase or assembly, that you can create from the planning line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code used to determine the unit price.';
                    Visible = false;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the order date that will apply to the requisition worksheet line.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the manufacturing process, if the planned supply is a production order.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you can expect to receive the items.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit costs for the planning worksheet line.';
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the direct unit cost of this item.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code for the requisition lines.';
                    Visible = false;
                }
                field("Purchasing Code";"Purchasing Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the purchasing code for the item on the planning line.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code to be linked to the requisition worksheet line.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code to be linked to the requisition worksheet line.';
                    Visible = false;
                }
            }
            group(Control38)
            {
                fixed(Control1902204901)
                {
                    group("Available for Transfer")
                    {
                        Caption = 'Available for Transfer';
                        field(AvailableForTransfer;QtyOnOtherLocations)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Available For Transfer';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ToolTip = 'Specifies the quantity of the item on the active planning line, that is available on another location than the one defined.';

                            trigger OnAssistEdit()
                            begin
                                OrderPlanningMgt.InsertAltSupplyLocation(Rec);
                            end;
                        }
                    }
                    group("Substitutes Exist")
                    {
                        Caption = 'Substitutes Exist';
                        field(SubstitionAvailable;SubstitionAvailable)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Substitutes Exist';
                            DrillDown = false;
                            Editable = false;
                            Lookup = false;
                            ToolTip = 'Specifies if a substitute item exists for the component on the planning line.';

                            trigger OnAssistEdit()
                            var
                                ReqLine2: Record "Requisition Line";
                                xReqLine: Record "Requisition Line";
                                ReqLine3: Record "Requisition Line";
                            begin
                                ReqLine3 := Rec;
                                OrderPlanningMgt.InsertAltSupplySubstitution(ReqLine3);
                                Rec := ReqLine3;
                                Modify;

                                if OrderPlanningMgt.DeleteLine then begin
                                  xReqLine := Rec;
                                  ReqLine2.SetCurrentkey("User ID","Demand Type","Demand Subtype","Demand Order No.");
                                  ReqLine2.SetRange("User ID",UserId);
                                  ReqLine2.SetRange("Demand Type","Demand Type");
                                  ReqLine2.SetRange("Demand Subtype","Demand Subtype");
                                  ReqLine2.SetRange("Demand Order No.","Demand Order No.");
                                  ReqLine2.SetRange(Level,Level,Level + 1);
                                  ReqLine2.SetFilter("Line No.",'<>%1',"Line No.");
                                  if not ReqLine2.FindFirst then begin // No other children
                                    ReqLine2.SetRange("Line No.");
                                    ReqLine2.SetRange(Level,0);
                                    if ReqLine2.FindFirst then begin // Find and delete parent
                                      Rec := ReqLine2;
                                      Delete;
                                    end;
                                  end;

                                  Rec := xReqLine;
                                  Delete;
                                  CurrPage.Update(false);
                                end else
                                  CurrPage.Update(true);
                            end;
                        }
                    }
                    group("Quantity Available")
                    {
                        Caption = 'Quantity Available';
                        field(QuantityAvailable;QtyATP)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity Available';
                            DecimalPlaces = 0:5;
                            DrillDown = false;
                            Editable = false;
                            Lookup = false;
                            ToolTip = 'Specifies the total availability of the item on the active planning line, irrespective of quantities calculated for the line.';
                        }
                    }
                    group("Earliest Date Available")
                    {
                        Caption = 'Earliest Date Available';
                        field(EarliestShptDateAvailable;EarliestShptDateAvailable)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Earliest Date Available';
                            DrillDown = false;
                            Editable = false;
                            Lookup = false;
                            ToolTip = 'Specifies the arrival date of an inbound supply order that can cover the needed quantity on a date later than the demand date.';
                        }
                    }
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
                action("Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;

                    trigger OnAction()
                    begin
                        ShowDemandOrder;
                    end;
                }
                separator(Action63)
                {
                }
                action(Components)
                {
                    ApplicationArea = Basic;
                    Caption = 'Components';
                    Image = Components;
                    RunObject = Page "Planning Components";
                    RunPageLink = "Worksheet Template Name"=field("Worksheet Template Name"),
                                  "Worksheet Batch Name"=field("Journal Batch Name"),
                                  "Worksheet Line No."=field("Line No.");
                }
                action("Ro&uting")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ro&uting';
                    Image = Route;
                    RunObject = Page "Planning Routing";
                    RunPageLink = "Worksheet Template Name"=field("Worksheet Template Name"),
                                  "Worksheet Batch Name"=field("Journal Batch Name"),
                                  "Worksheet Line No."=field("Line No.");
                }
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
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        TestField(Type,Type::Item);
                        TestField("No.");
                        Item."No." := "No.";
                        Page.RunModal(Page::"Item Card",Item);
                    end;
                }
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location=R;
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalculatePlan)
                {
                    ApplicationArea = Basic;
                    Caption = '&Calculate Plan';
                    Image = CalculatePlan;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CalcPlan;
                        CurrPage.Update(false);
                    end;
                }
                separator(Action48)
                {
                }
                action("&Reserve")
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord;
                        ShowReservation;
                    end;
                }
                action(OrderTracking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    var
                        TrackingForm: Page "Order Tracking";
                    begin
                        TrackingForm.SetReqLine(Rec);
                        TrackingForm.RunModal;
                    end;
                }
                action("Refresh &Planning Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Refresh &Planning Line';
                    Ellipsis = true;
                    Image = RefreshPlanningLine;

                    trigger OnAction()
                    var
                        ReqLine2: Record "Requisition Line";
                    begin
                        ReqLine2.SetRange("Worksheet Template Name","Worksheet Template Name");
                        ReqLine2.SetRange("Journal Batch Name","Journal Batch Name");
                        ReqLine2.SetRange("Line No.","Line No.");

                        Report.RunModal(Report::"Refresh Planning Demand",true,false,ReqLine2);
                    end;
                }
                separator(Action36)
                {
                }
            }
            action("Make &Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Make &Orders';
                Ellipsis = true;
                Image = NewOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    MakeSupplyOrders: Codeunit "Make Supply Orders (Yes/No)";
                begin
                    MakeSupplyOrders.SetManufUserTemplate(MfgUserTempl);
                    MakeSupplyOrders.Run(Rec);

                    if MakeSupplyOrders.ActionMsgCarriedOut then begin
                      RefreshTempTable;
                      SetRecFilters;
                      CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if ReqLine.Get("Worksheet Template Name","Journal Batch Name","Line No.") then begin
          Rec := ReqLine;
          Modify
        end else
          if Get("Worksheet Template Name","Journal Batch Name","Line No.") then
            Delete;

        UpdateSupplyFrom;
        CalcItemAvail;
    end;

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        StatusText := Format(Status);
        StatusTextOnFormat(StatusText);
        DemandTypeText := Format("Demand Type");
        DemandTypeTextOnFormat(DemandTypeText);
        DemandSubtypeText := Format("Demand Subtype");
        DemandSubtypeTextOnFormat(DemandSubtypeText);
        DemandOrderNoOnFormat;
        DescriptionOnFormat;
        DemandQuantityOnFormat;
        DemandQtyAvailableOnFormat;
        ReplenishmentSystemOnFormat;
        QuantityOnFormat;
        ReserveOnFormat;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        xReqLine: Record "Requisition Line";
    begin
        xReqLine := Rec;
        while (Next <> 0) and (Level > xReqLine.Level) do
          Delete(true);
        Rec := xReqLine;
        xReqLine.Delete(true);
        Delete;
        exit(false);
    end;

    trigger OnInit()
    begin
        DemandOrderFilterCtrlEnable := true;
        SupplyFromEditable := true;
        ReserveEditable := true;
    end;

    trigger OnModifyRecord(): Boolean
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.Get("Worksheet Template Name","Journal Batch Name","Line No.");
        ReqLine.TransferFields(Rec,false);
        ReqLine.Modify(true);
    end;

    trigger OnOpenPage()
    begin
        if not MfgUserTempl.Get(UserId) then begin
          MfgUserTempl.Init;
          MfgUserTempl."User ID" := UserId;
          MfgUserTempl."Make Orders" := MfgUserTempl."make orders"::"The Active Order";
          MfgUserTempl."Create Purchase Order" := MfgUserTempl."create purchase order"::"Make Purch. Orders";
          MfgUserTempl."Create Production Order" := MfgUserTempl."create production order"::"Firm Planned";
          MfgUserTempl."Create Transfer Order" := MfgUserTempl."create transfer order"::"Make Trans. Orders";
          MfgUserTempl."Create Assembly Order" := MfgUserTempl."create assembly order"::"Make Assembly Orders";
          MfgUserTempl.Insert;
        end;

        InitTempRec;
    end;

    var
        ReqLine: Record "Requisition Line";
        SalesHeader: Record "Sales Header";
        ProdOrder: Record "Production Order";
        AsmHeader: Record "Assembly Header";
        ServHeader: Record "Service Header";
        Job: Record Job;
        MfgUserTempl: Record "Manufacturing User Template";
        OrderPlanningMgt: Codeunit "Order Planning Mgt.";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        DemandOrderFilter: Option "All Demands","Production Demand","Sales Demand","Service Demand","Job Demand","Assembly Demand";
        Text001: label 'Sales';
        Text002: label 'Production';
        Text003: label 'Service';
        Text004: label 'Jobs';
        [InDataSet]
        StatusHideValue: Boolean;
        [InDataSet]
        StatusText: Text[1024];
        [InDataSet]
        DemandTypeHideValue: Boolean;
        [InDataSet]
        DemandTypeEmphasize: Boolean;
        [InDataSet]
        DemandTypeText: Text[1024];
        [InDataSet]
        DemandSubtypeText: Text[1024];
        [InDataSet]
        DemandOrderNoHideValue: Boolean;
        [InDataSet]
        DemandOrderNoEmphasize: Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        DescriptionIndent: Integer;
        [InDataSet]
        DemandQuantityHideValue: Boolean;
        [InDataSet]
        DemandQtyAvailableHideValue: Boolean;
        [InDataSet]
        ReplenishmentSystemHideValue: Boolean;
        [InDataSet]
        QuantityHideValue: Boolean;
        [InDataSet]
        SupplyFromEditable: Boolean;
        [InDataSet]
        ReserveEditable: Boolean;
        [InDataSet]
        DemandOrderFilterCtrlEnable: Boolean;
        Text005: label 'Assembly';
        QtyOnOtherLocations: Decimal;
        SubstitionAvailable: Boolean;
        QtyATP: Decimal;
        EarliestShptDateAvailable: Date;


    procedure SetSalesOrder(SalesHeader2: Record "Sales Header")
    begin
        SalesHeader := SalesHeader2;
        DemandOrderFilter := Demandorderfilter::"Sales Demand";
        DemandOrderFilterCtrlEnable := false;
    end;


    procedure SetProdOrder(ProdOrder2: Record "Production Order")
    begin
        ProdOrder := ProdOrder2;
        DemandOrderFilter := Demandorderfilter::"Production Demand";
        DemandOrderFilterCtrlEnable := false;
    end;


    procedure SetAsmOrder(AsmHeader2: Record "Assembly Header")
    begin
        AsmHeader := AsmHeader2;
        DemandOrderFilter := Demandorderfilter::"Assembly Demand";
        DemandOrderFilterCtrlEnable := false;
    end;


    procedure SetServOrder(ServHeader2: Record "Service Header")
    begin
        ServHeader := ServHeader2;
        DemandOrderFilter := Demandorderfilter::"Service Demand";
        DemandOrderFilterCtrlEnable := false;
    end;


    procedure SetJobOrder(Job2: Record Job)
    begin
        Job := Job2;
        DemandOrderFilter := Demandorderfilter::"Job Demand";
        DemandOrderFilterCtrlEnable := false;
    end;

    local procedure InitTempRec()
    var
        ReqLine: Record "Requisition Line";
        ReqLineWithCursor: Record "Requisition Line";
    begin
        DeleteAll;

        ReqLine.Reset;
        ReqLine.CopyFilters(Rec);
        ReqLine.SetRange("User ID",UserId);
        ReqLine.SetRange("Worksheet Template Name",'');
        if ReqLine.FindSet then
          repeat
            Rec := ReqLine;
            Insert;
            if ReqLine.Level = 0 then
              FindReqLineForCursor(ReqLineWithCursor,ReqLine);
          until ReqLine.Next = 0;

        if FindFirst then
          if ReqLineWithCursor."Line No." > 0 then
            Rec := ReqLineWithCursor;

        SetRecFilters;
    end;

    local procedure FindReqLineForCursor(var ReqLineWithCursor: Record "Requisition Line";ActualReqLine: Record "Requisition Line")
    begin
        if ProdOrder."No." = '' then
          exit;

        if (ActualReqLine."Demand Type" = Database::"Prod. Order Component") and
           (ActualReqLine."Demand Subtype" = ProdOrder.Status) and
           (ActualReqLine."Demand Order No." = ProdOrder."No.")
        then
          ReqLineWithCursor := ActualReqLine;
    end;

    local procedure RefreshTempTable()
    var
        TempReqLine2: Record "Requisition Line";
        ReqLine: Record "Requisition Line";
    begin
        TempReqLine2.Copy(Rec);

        Reset;
        if Find('-') then
          repeat
            ReqLine := Rec;
            if not ReqLine.Find or
               ((Level = 0) and ((ReqLine.Next = 0) or (ReqLine.Level = 0)))
            then begin
              if Level = 0 then begin
                ReqLine := Rec;
                ReqLine.Find;
                ReqLine.Delete(true);
              end;
              Delete
            end;
          until Next = 0;

        Copy(TempReqLine2);
    end;


    procedure SetRecFilters()
    begin
        Reset;
        FilterGroup(2);
        SetRange("User ID",UserId);
        SetRange("Worksheet Template Name",'');

        case DemandOrderFilter of
          Demandorderfilter::"All Demands":
            begin
              SetRange("Demand Type");
              SetCurrentkey("User ID","Worksheet Template Name","Journal Batch Name","Line No.");
            end;
          Demandorderfilter::"Sales Demand":
            begin
              SetRange("Demand Type",Database::"Sales Line");
              SetCurrentkey("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
            end;
          Demandorderfilter::"Production Demand":
            begin
              SetRange("Demand Type",Database::"Prod. Order Component");
              SetCurrentkey("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
            end;
          Demandorderfilter::"Assembly Demand":
            begin
              SetRange("Demand Type",Database::"Assembly Line");
              SetCurrentkey("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
            end;
          Demandorderfilter::"Service Demand":
            begin
              SetRange("Demand Type",Database::"Service Line");
              SetCurrentkey("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
            end;
          Demandorderfilter::"Job Demand":
            begin
              SetRange("Demand Type",Database::"Job Planning Line");
              SetCurrentkey("User ID","Demand Type","Worksheet Template Name","Journal Batch Name","Line No.");
            end;
        end;
        FilterGroup(0);

        CurrPage.Update(false);
    end;

    local procedure ShowDemandOrder()
    var
        SalesHeader: Record "Sales Header";
        ProdOrder: Record "Production Order";
        ServHeader: Record "Service Header";
        Job: Record Job;
        AsmHeader: Record "Assembly Header";
    begin
        case "Demand Type" of
          Database::"Sales Line":
            begin
              SalesHeader.Get("Demand Subtype","Demand Order No.");
              case SalesHeader."Document Type" of
                SalesHeader."document type"::Order:
                  Page.Run(Page::"Sales Order",SalesHeader);
                SalesHeader."document type"::"Return Order":
                  Page.Run(Page::"Sales Return Order",SalesHeader);
              end;
            end;
          Database::"Prod. Order Component":
            begin
              ProdOrder.Get("Demand Subtype","Demand Order No.");
              case ProdOrder.Status of
                ProdOrder.Status::Planned:
                  Page.Run(Page::"Planned Production Order",ProdOrder);
                ProdOrder.Status::"Firm Planned":
                  Page.Run(Page::"Firm Planned Prod. Order",ProdOrder);
                ProdOrder.Status::Released:
                  Page.Run(Page::"Released Production Order",ProdOrder);
              end;
            end;
          Database::"Assembly Line":
            begin
              AsmHeader.Get("Demand Subtype","Demand Order No.");
              case AsmHeader."Document Type" of
                AsmHeader."document type"::Order:
                  Page.Run(Page::"Assembly Order",AsmHeader);
              end;
            end;
          Database::"Service Line":
            begin
              ServHeader.Get("Demand Subtype","Demand Order No.");
              case ServHeader."Document Type" of
                ServHeader."document type"::Order:
                  Page.Run(Page::"Service Order",ServHeader);
              end;
            end;
          Database::"Job Planning Line":
            begin
              Job.Get("Demand Order No.");
              case Job.Status of
                Job.Status::Open:
                  Page.Run(Page::"Job Card",Job);
              end;
            end;
        end;
    end;

    local procedure CalcItemAvail()
    begin
        QtyOnOtherLocations := CalcQtyOnOtherLocations;
        SubstitionAvailable := CalcSubstitionAvailable;
        QtyATP := CalcQtyATP;
        EarliestShptDateAvailable := CalcEarliestShptDateAvailable;
    end;

    local procedure CalcQtyOnOtherLocations(): Decimal
    var
        QtyOnOtherLocation: Decimal;
    begin
        if "No." = '' then
          exit;

        QtyOnOtherLocation := OrderPlanningMgt.AvailQtyOnOtherLocations(Rec); // Base Unit
        if "Qty. per Unit of Measure" = 0 then
          "Qty. per Unit of Measure" := 1;
        QtyOnOtherLocation := ROUND(QtyOnOtherLocation / "Qty. per Unit of Measure",0.00001);

        exit(QtyOnOtherLocation);
    end;

    local procedure CalcQtyATP(): Decimal
    var
        QtyATP: Decimal;
    begin
        if "No." = '' then
          exit;

        QtyATP := OrderPlanningMgt.CalcATPQty("No.","Variant Code","Location Code","Demand Date"); // Base Unit
        if "Qty. per Unit of Measure" = 0 then
          "Qty. per Unit of Measure" := 1;
        QtyATP := ROUND(QtyATP / "Qty. per Unit of Measure",0.00001);

        exit(QtyATP);
    end;

    local procedure CalcEarliestShptDateAvailable(): Date
    var
        Item: Record Item;
    begin
        if "No." = '' then
          exit;

        Item.Get("No.");
        if Item."Order Tracking Policy" = Item."order tracking policy"::"Tracking & Action Msg." then
          exit;

        exit(OrderPlanningMgt.CalcATPEarliestDate("No.","Variant Code","Location Code","Demand Date","Quantity (Base)"));
    end;

    local procedure CalcSubstitionAvailable(): Boolean
    begin
        if "No." = '' then
          exit;

        exit(OrderPlanningMgt.SubstitutionPossible(Rec));
    end;

    local procedure CalcPlan()
    var
        ReqLine: Record "Requisition Line";
    begin
        Reset;
        DeleteAll;

        Clear(OrderPlanningMgt);
        case DemandOrderFilter of
          Demandorderfilter::"Sales Demand":
            OrderPlanningMgt.SetSalesOrder;
          Demandorderfilter::"Assembly Demand":
            OrderPlanningMgt.SetAsmOrder;
          Demandorderfilter::"Production Demand":
            OrderPlanningMgt.SetProdOrder;
          Demandorderfilter::"Service Demand":
            OrderPlanningMgt.SetServOrder;
          Demandorderfilter::"Job Demand":
            OrderPlanningMgt.SetJobOrder;
        end;
        OrderPlanningMgt.GetOrdersToPlan(ReqLine);

        InitTempRec;
    end;

    local procedure UpdateSupplyFrom()
    begin
        SupplyFromEditable := not ("Replenishment System" in ["replenishment system"::"Prod. Order",
                                                              "replenishment system"::Assembly]);
    end;

    local procedure DemandOrderFilterOnAfterValida()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure ReplenishmentSystemOnAfterVali()
    begin
        UpdateSupplyFrom;
    end;

    local procedure StatusTextOnFormat(var Text: Text[1024])
    begin
        if "Demand Line No." = 0 then
          case "Demand Type" of
            Database::"Prod. Order Component":
              begin
                ProdOrder.Status := Status;
                Text := Format(ProdOrder.Status);
              end;
            Database::"Sales Line":
              begin
                SalesHeader.Status := Status;
                Text := Format(SalesHeader.Status);
              end;
            Database::"Service Line":
              begin
                ServHeader.Init;
                ServHeader.Status := Status;
                Text := Format(ServHeader.Status);
              end;
            Database::"Job Planning Line":
              begin
                Job.Init;
                Job.Status := Status;
                Text := Format(Job.Status);
              end;
            Database::"Assembly Line":
              begin
                AsmHeader.Status := Status;
                Text := Format(AsmHeader.Status);
              end;
          end;

        StatusHideValue := "Demand Line No." <> 0;
    end;

    local procedure DemandTypeTextOnFormat(var Text: Text[1024])
    begin
        if "Demand Line No." = 0 then
          case "Demand Type" of
            Database::"Sales Line":
              Text := Text001;
            Database::"Prod. Order Component":
              Text := Text002;
            Database::"Service Line":
              Text := Text003;
            Database::"Job Planning Line":
              Text := Text004;
            Database::"Assembly Line":
              Text := Text005;
          end;

        DemandTypeHideValue := "Demand Line No." <> 0;
        DemandTypeEmphasize := Level = 0;
    end;

    local procedure DemandSubtypeTextOnFormat(var Text: Text[1024])
    begin
        case "Demand Type" of
          Database::"Prod. Order Component":
            begin
              ProdOrder.Status := Status;
              Text := Format(ProdOrder.Status);
            end;
          Database::"Sales Line":
            begin
              SalesHeader."Document Type" := "Demand Subtype";
              Text := Format(SalesHeader."Document Type");
            end;
          Database::"Service Line":
            begin
              ServHeader."Document Type" := "Demand Subtype";
              Text := Format(ServHeader."Document Type");
            end;
          Database::"Job Planning Line":
            begin
              Job.Status := Status;
              Text := Format(Job.Status);
            end;
          Database::"Assembly Line":
            begin
              AsmHeader."Document Type" := "Demand Subtype";
              Text := Format(AsmHeader."Document Type");
            end;
        end
    end;

    local procedure DemandOrderNoOnFormat()
    begin
        DemandOrderNoHideValue := "Demand Line No." <> 0;
        DemandOrderNoEmphasize := Level = 0;
    end;

    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := Level + "Planning Level";
        DescriptionEmphasize := Level = 0;
    end;

    local procedure DemandQuantityOnFormat()
    begin
        DemandQuantityHideValue := Level = 0;
    end;

    local procedure DemandQtyAvailableOnFormat()
    begin
        DemandQtyAvailableHideValue := Level = 0;
    end;

    local procedure ReplenishmentSystemOnFormat()
    begin
        ReplenishmentSystemHideValue := "Replenishment System" = "replenishment system"::" ";
    end;

    local procedure QuantityOnFormat()
    begin
        QuantityHideValue := Level = 0;
    end;

    local procedure ReserveOnFormat()
    begin
        ReserveEditable := Level <> 0;
    end;
}

