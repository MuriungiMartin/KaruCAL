#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5530 "Item Availability by Event"
{
    Caption = 'Item Availability by Event';
    DataCaptionExpression = PageCaption;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Inventory Page Data";
    SourceTableTemporary = true;
    SourceTableView = sorting("Period Start","Line No.")
                      order(ascending);

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(ItemNo;ItemNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                    TableRelation = Item;

                    trigger OnValidate()
                    begin
                        if ItemNo <> Item."No." then begin
                          Item.Get(ItemNo);
                          if LocationFilter <> '' then
                            Item.SetFilter("Location Filter",LocationFilter);
                          if VariantFilter <> '' then
                            Item.SetFilter("Variant Filter",VariantFilter);
                          InitAndCalculatePeriodEntries;
                        end;
                    end;
                }
                field(VariantFilter;VariantFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemVariant: Record "Item Variant";
                        ItemVariants: Page "Item Variants";
                    begin
                        ItemVariant.SetFilter("Item No.",ItemNo);
                        ItemVariants.SetTableview(ItemVariant);
                        ItemVariants.LookupMode := true;
                        if ItemVariants.RunModal = Action::LookupOK then begin
                          ItemVariants.GetRecord(ItemVariant);
                          Text := ItemVariant.Code;
                          exit(true);
                        end;
                        exit(false);
                    end;

                    trigger OnValidate()
                    begin
                        if VariantFilter <> Item.GetFilter("Variant Filter") then begin
                          Item.SetRange("Variant Filter");
                          if VariantFilter <> '' then
                            Item.SetFilter("Variant Filter",VariantFilter);
                          InitAndCalculatePeriodEntries;
                        end;
                    end;
                }
                field(LocationFilter;LocationFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Location: Record Location;
                        LocationList: Page "Location List";
                    begin
                        LocationList.SetTableview(Location);
                        LocationList.LookupMode := true;
                        if LocationList.RunModal = Action::LookupOK then begin
                          LocationList.GetRecord(Location);
                          Text := Location.Code;
                          exit(true);
                        end;
                        exit(false);
                    end;

                    trigger OnValidate()
                    begin
                        if LocationFilter <> Item.GetFilter("Location Filter") then begin
                          Item.SetRange("Location Filter");
                          if LocationFilter <> '' then
                            Item.SetFilter("Location Filter",LocationFilter);
                          InitAndCalculatePeriodEntries;
                        end;
                    end;
                }
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View by';
                    Importance = Promoted;
                    OptionCaption = 'Day,Week,Month,Quarter,Year';
                    ToolTip = 'Specifies which time intervals to group and view the availability figures.';

                    trigger OnValidate()
                    begin
                        CalculatePeriodEntries;
                    end;
                }
                field(LastUpdateTime;LastUpdateTime)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last Updated';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies when the availability figures in the Item Availability by Event window were last updated.';
                }
                field(ForecastName;ForecastName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Forecast Name';
                    Importance = Promoted;
                    TableRelation = "Production Forecast Name";
                    ToolTip = 'Specifies a production forecast you want to include as demand, when showing the item''s availability figures.';

                    trigger OnValidate()
                    begin
                        InitAndCalculatePeriodEntries;
                    end;
                }
                field(IncludePlanningSuggestions;IncludePlanningSuggestions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Include Planning Suggestions';
                    ToolTip = 'Specifies whether to include suggestions in planning or requisition worksheets, in the availability figures.';

                    trigger OnValidate()
                    begin
                        if IncludePlanningSuggestions then
                          IncludeBlanketOrders := true;

                        InitAndCalculatePeriodEntries;
                    end;
                }
                field(IncludeBlanketOrders;IncludeBlanketOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Include Blanket Sales Orders';
                    Editable = not IncludePlanningSuggestions;
                    ToolTip = 'Includes anticipated demand from blanket sales orders in availability figures.';

                    trigger OnValidate()
                    begin
                        InitAndCalculatePeriodEntries;
                    end;
                }
            }
            repeater(Control5)
            {
                Editable = false;
                IndentationColumn = Level;
                IndentationControls = Description;
                ShowAsTree = true;
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the first date in the selected period where a supply or demand event occurs that changes the item''s availability figures.';
                }
                field("Period Start";"Period Start")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies on which date the period starts, such as the first day of March, if the period is Month.';
                    Visible = true;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the description of the availability line.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the type of the source document or source line.';
                }
                field(Source;Source)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies which type of document or line the availability figure is based on.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the number of the document that the availability figure is based on.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies a variant code if you only want to view availability figures for that variant of the item.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the location of the demand document, from which the Item Availability by Event window was opened.';
                    Visible = false;
                }
                field("Gross Requirement";"Gross Requirement")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the item''s total demand.';
                }
                field("Reserved Requirement";"Reserved Requirement")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Scheduled Receipt";"Scheduled Receipt")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the sum of items on existing supply orders.';
                }
                field("Reserved Receipt";"Reserved Receipt")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Remaining Quantity (Base)";"Remaining Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the difference between the finished quantity and the planned quantity on the production order.';
                    Visible = false;
                }
                field("Projected Inventory";"Projected Inventory")
                {
                    ApplicationArea = Basic,Suite;
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Enabled = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the item''s availability.';
                }
                field(Forecast;Forecast)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the quantity that is demanded on the production forecast that the availability figure is based on.';
                }
                field("Forecasted Projected Inventory";"Forecasted Projected Inventory")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the item''s inventory, including anticipated demand from production forecasts or blanket sales orders.';
                }
                field("Remaining Forecast";"Remaining Forecast")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the quantity that remains on the production forecast, after the forecast quantity on the availability line has been consumed.';
                }
                field("Action Message";"Action Message")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the action message of the planning or requisition line that this availability figure is based on.';
                }
                field("Action Message Qty.";"Action Message Qty.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the quantity that is suggested in the planning or requisition line that this availability figure is based on.';
                }
                field("Suggested Projected Inventory";"Suggested Projected Inventory")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the item''s inventory, including the suggested supplies that occur in planning or requisition worksheet lines.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Recalculate)
            {
                ApplicationArea = Basic;
                Caption = 'Recalculate';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    InitAndCalculatePeriodEntries;
                end;
            }
            action("Show Document")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Document';
                Enabled = EnableShowDocumentAction;
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F7';
                ToolTip = 'Open the document that the selected line exists on.';

                trigger OnAction()
                begin
                    CalcInventoryPageData.ShowDocument("Source Document ID");
                end;
            }
        }
        area(navigation)
        {
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
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
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Item,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Period';
                        Image = Period;
                        ToolTip = 'Show the actual and projected quantity of an item over time according to a specified time interval, such as by day, week or month.';

                        trigger OnAction()
                        begin
                            Page.Run(Page::"Item Availability by Periods",Item,Item."No.");
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            Page.Run(Page::"Item Availability by Variant",Item,Item."No.");
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
                            Page.Run(Page::"Item Availability by Location",Item,Item."No.");
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Item,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Emphasize := EmphasizeLine;
        EnableShowDocumentAction := HasSourceDocument;
    end;

    trigger OnOpenPage()
    begin
        if ItemIsSet then
          InitAndCalculatePeriodEntries
        else
          InitItemRequestFields;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          SelectedDate := "Period Start";
    end;

    var
        Item: Record Item;
        TempInvtPageData: Record "Inventory Page Data" temporary;
        CalcInventoryPageData: Codeunit "Calc. Inventory Page Data";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ItemNo: Code[20];
        LocationFilter: Text;
        VariantFilter: Text;
        ForecastName: Code[10];
        PeriodType: Option Day,Week,Month,Quarter,Year;
        LastUpdateTime: DateTime;
        SelectedDate: Date;
        [InDataSet]
        IncludePlanningSuggestions: Boolean;
        [InDataSet]
        IncludeBlanketOrders: Boolean;
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        EnableShowDocumentAction: Boolean;

    local procedure InitAndCalculatePeriodEntries()
    begin
        Initialize;
        CalculatePeriodEntries;
    end;

    local procedure CalculatePeriodEntries()
    begin
        TempInvtPageData.Reset;
        TempInvtPageData.DeleteAll;
        TempInvtPageData.SetCurrentkey("Period Start","Line No.");
        CalcInventoryPageData.CreatePeriodEntries(TempInvtPageData,PeriodType);

        Reset;
        DeleteAll;
        SetCurrentkey("Period Start","Line No.");

        TempInvtPageData.SetRange(Level,0);
        if TempInvtPageData.Find('-') then
          repeat
            CalcInventoryPageData.DetailsForPeriodEntry(TempInvtPageData,true);
            CalcInventoryPageData.DetailsForPeriodEntry(TempInvtPageData,false);
          until TempInvtPageData.Next = 0;
        TempInvtPageData.SetRange(Level);

        ExpandAll;
    end;

    local procedure Initialize()
    begin
        Item.SetRange("Drop Shipment Filter",false);
        CalcInventoryPageData.Initialize(Item,ForecastName,IncludeBlanketOrders,0D,IncludePlanningSuggestions);
        LastUpdateTime := CurrentDatetime;
    end;

    local procedure ExpandAll()
    var
        RunningInventory: Decimal;
        RunningInventoryForecast: Decimal;
        RunningInventoryPlan: Decimal;
    begin
        Reset;
        DeleteAll;
        SetCurrentkey("Period Start","Line No.");

        if TempInvtPageData.Find('-') then
          repeat
            Rec := TempInvtPageData;
            UpdateInventorys(RunningInventory,RunningInventoryForecast,RunningInventoryPlan);
            Insert;
          until TempInvtPageData.Next = 0;

        if Find('-') then;
    end;

    local procedure EmphasizeLine(): Boolean
    begin
        exit(Level = 0);
    end;

    local procedure HasSourceDocument(): Boolean
    begin
        exit((Level > 0) and (Format("Source Document ID") <> ''));
    end;

    local procedure InitItemRequestFields()
    begin
        Clear(Item);
        Clear(ItemNo);
        Clear(LocationFilter);
        Clear(VariantFilter);
        Clear(LastUpdateTime);
    end;

    local procedure UpdateItemRequestFields(var Item: Record Item)
    begin
        ItemNo := Item."No.";
        LocationFilter := '';
        if Item.GetFilter("Location Filter") <> '' then
          LocationFilter := Item.GetFilter("Location Filter");
        VariantFilter := '';
        if Item.GetFilter("Variant Filter") <> '' then
          VariantFilter := Item.GetFilter("Variant Filter");
    end;

    local procedure ItemIsSet(): Boolean
    begin
        exit(Item."No." <> '');
    end;

    local procedure PageCaption(): Text[250]
    begin
        exit(StrSubstNo('%1 %2',Item."No.",Item.Description));
    end;


    procedure SetItem(var NewItem: Record Item)
    begin
        Item.Copy(NewItem);
        UpdateItemRequestFields(Item);
    end;


    procedure SetForecastName(NewForcastName: Code[10])
    begin
        ForecastName := NewForcastName;
    end;


    procedure SetIncludePlan(NewIncludePlanningSuggestions: Boolean)
    begin
        IncludePlanningSuggestions := NewIncludePlanningSuggestions;
    end;


    procedure GetSelectedDate(): Date
    begin
        exit(SelectedDate);
    end;
}

