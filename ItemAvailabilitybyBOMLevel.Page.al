#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5871 "Item Availability by BOM Level"
{
    Caption = 'Item Availability by BOM Level';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "BOM Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Option)
            {
                Caption = 'Option';
                field(ItemFilter;ItemFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Filter';
                    ToolTip = 'Specifies the item you want to show availability information for.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        ItemList: Page "Item List";
                    begin
                        ItemList.SetTableview(Item);
                        ItemList.LookupMode := true;
                        if ItemList.RunModal = Action::LookupOK then begin
                          ItemList.GetRecord(Item);
                          Text := Item."No.";
                          exit(true);
                        end;
                        exit(false);
                    end;

                    trigger OnValidate()
                    begin
                        IsCalculated := false;
                        RefreshPage;
                    end;
                }
                field(LocationFilter;LocationFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Filter';
                    ToolTip = 'Specifies the location that you want to show item availability for.';

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
                        IsCalculated := false;
                        RefreshPage;
                    end;
                }
                field(VariantFilter;VariantFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant Filter';
                    ToolTip = 'Specifies the item variant you want to show availability for.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemVariant: Record "Item Variant";
                        ItemVariants: Page "Item Variants";
                    begin
                        ItemVariant.SetFilter("Item No.",ItemFilter);
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
                        IsCalculated := false;
                        RefreshPage;
                    end;
                }
                field(DemandDate;DemandDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Demand Date';
                    ToolTip = 'Specifies the date when you want to potentially make the parents, or top items, shown in the Item Availability by BOM Level window.';

                    trigger OnValidate()
                    begin
                        IsCalculated := false;
                        RefreshPage;
                    end;
                }
                field(IsCalculated;IsCalculated)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculated';
                    Editable = false;
                    ToolTip = 'This object supports the program infrastructure and is intended for internal use.';
                }
                field(ShowTotalAvailability;ShowTotalAvailability)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Total Availability';
                    ToolTip = 'Specifies whether the Item Availability by BOM Level window shows availability of all items, including the potential availability of parents.';

                    trigger OnValidate()
                    begin
                        IsCalculated := false;
                        RefreshPage;
                    end;
                }
            }
            repeater(Group)
            {
                Caption = 'Lines';
                IndentationColumn = Indentation;
                ShowAsTree = true;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = IsParentExpr;
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the item''s description.';
                }
                field(HasWarning;HasWarning)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Warning';
                    Editable = false;
                    Style = Attention;
                    StyleExpr = HasWarning;

                    trigger OnDrillDown()
                    begin
                        if HasWarning then
                          ShowWarnings;
                    end;
                }
                field(Bottleneck;Bottleneck)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies which item in the BOM structure restricts you from making a larger quantity than what is shown in the Able to Make Top Item field.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code that you entered in the Variant Filter field in the Item Availability by BOM Level window.';
                    Visible = false;
                }
                field("Qty. per Parent";"Qty. per Parent")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the component are required to assemble or produce one unit of the parent.';
                }
                field("Qty. per Top Item";"Qty. per Top Item")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the component are required to assemble or produce one unit of the top item.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the item''s unit of measure.';
                }
                field("Replenishment System";"Replenishment System")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the item''s replenishment system.';
                }
                field("Available Quantity";"Available Quantity")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the line are available, regardless of how many parents you can make with the item.';
                }
                field("Unused Quantity";"Unused Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the part of the item''s total availability that is not required to make the quantities that are shown in the fields.';
                    Visible = false;
                }
                field("Needed by Date";"Needed by Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies when the item must be available to make the parent or top item.';
                }
                field("Able to Make Parent";"Able to Make Parent")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the BOM item on the collapsible line above it can be assembled or produced.';
                }
                field("Able to Make Top Item";"Able to Make Top Item")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the BOM item on the top line can be assembled or produced.';
                }
                field("Gross Requirement";"Gross Requirement")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies the total demand for the item.';
                    Visible = false;
                }
                field("Scheduled Receipts";"Scheduled Receipts")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item are inbound on orders.';
                    Visible = false;
                }
                field("Safety Lead Time";"Safety Lead Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies any safety lead time that is defined for the item.';
                    Visible = false;
                }
                field("Rolled-up Lead-Time Offset";"Rolled-up Lead-Time Offset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cumulative lead time of components under a parent item.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
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
                        ItemAvail(ItemAvailFormsMgt.ByEvent);
                    end;
                }
                action(Period)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period';
                    Image = Period;

                    trigger OnAction()
                    begin
                        ItemAvail(ItemAvailFormsMgt.ByPeriod);
                    end;
                }
                action(Variant)
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant';
                    Image = ItemVariant;

                    trigger OnAction()
                    begin
                        ItemAvail(ItemAvailFormsMgt.ByVariant);
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
                        ItemAvail(ItemAvailFormsMgt.ByLocation);
                    end;
                }
                action("BOM Level")
                {
                    ApplicationArea = Basic;
                    Caption = 'BOM Level';
                    Image = BOMLevel;

                    trigger OnAction()
                    begin
                        ItemAvail(ItemAvailFormsMgt.ByBOM);
                    end;
                }
            }
        }
        area(processing)
        {
            action("Previous Period")
            {
                ApplicationArea = Basic;
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Previous Period';

                trigger OnAction()
                begin
                    DemandDate := CalcDate('<-1D>',DemandDate);
                    RefreshPage;
                end;
            }
            action("Next Period")
            {
                ApplicationArea = Basic;
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Next Period';

                trigger OnAction()
                begin
                    DemandDate := CalcDate('<+1D>',DemandDate);
                    RefreshPage;
                end;
            }
            action("Show Warnings")
            {
                ApplicationArea = Basic;
                Caption = 'Show Warnings';
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowWarningsForAllLines;
                end;
            }
        }
        area(reporting)
        {
            action("Item - Able to Make (Timeline)")
            {
                ApplicationArea = Basic;
                Caption = 'Item - Able to Make (Timeline)';
                Image = Trendscape;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowAbleToMakeTimeline;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        DummyBOMWarningLog: Record "BOM Warning Log";
    begin
        IsParentExpr := not "Is Leaf";

        HasWarning := not IsLineOk(false,DummyBOMWarningLog);
    end;

    trigger OnOpenPage()
    begin
        ShowTotalAvailability := true;
        if DemandDate = 0D then
          DemandDate := WorkDate;
        RefreshPage;
    end;

    var
        Item: Record Item;
        AsmHeader: Record "Assembly Header";
        ProdOrderLine: Record "Prod. Order Line";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        [InDataSet]
        IsParentExpr: Boolean;
        ItemFilter: Code[250];
        LocationFilter: Code[250];
        VariantFilter: Code[250];
        DemandDate: Date;
        IsCalculated: Boolean;
        ShowTotalAvailability: Boolean;
        ShowBy: Option Item,Assembly,Production;
        Text000: label 'Could not find items with BOM levels.';
        Text001: label 'There are no warnings.';
        [InDataSet]
        HasWarning: Boolean;


    procedure InitItem(var NewItem: Record Item)
    begin
        Item.Copy(NewItem);
        ItemFilter := Item."No.";
        VariantFilter := Item.GetFilter("Variant Filter");
        LocationFilter := Item.GetFilter("Location Filter");
        ShowBy := Showby::Item;
    end;


    procedure InitAsmOrder(NewAsmHeader: Record "Assembly Header")
    begin
        AsmHeader := NewAsmHeader;
        ShowBy := Showby::Assembly;
    end;


    procedure InitProdOrder(NewProdOrderLine: Record "Prod. Order Line")
    begin
        ProdOrderLine := NewProdOrderLine;
        ShowBy := Showby::Production;
    end;


    procedure InitDate(NewDemandDate: Date)
    begin
        DemandDate := NewDemandDate;
    end;

    local procedure RefreshPage()
    var
        CalcBOMTree: Codeunit "Calculate BOM Tree";
    begin
        Item.SetRange("Date Filter",0D,DemandDate);
        Item.SetFilter("Location Filter",LocationFilter);
        Item.SetFilter("Variant Filter",VariantFilter);
        Item.SetFilter("No.",ItemFilter);
        CalcBOMTree.SetItemFilter(Item);

        CalcBOMTree.SetShowTotalAvailability(ShowTotalAvailability);
        case ShowBy of
          Showby::Item:
            begin
              Item.FindFirst;
              if not Item.HasBOM then
                Error(Text000);
              CalcBOMTree.GenerateTreeForItems(Item,Rec,1);
            end;
          Showby::Production:
            begin
              ProdOrderLine."Due Date" := DemandDate;
              CalcBOMTree.GenerateTreeForProdLine(ProdOrderLine,Rec,1);
            end;
          Showby::Assembly:
            begin
              AsmHeader."Due Date" := DemandDate;
              CalcBOMTree.GenerateTreeForAsm(AsmHeader,Rec,1);
            end;
        end;

        CurrPage.Update(false);
        IsCalculated := true;
    end;


    procedure GetSelectedDate(): Date
    begin
        exit(DemandDate);
    end;

    local procedure ItemAvail(AvailType: Option)
    var
        Item: Record Item;
    begin
        TestField(Type,Type::Item);

        Item.Get("No.");
        Item.SetFilter("No.","No.");
        Item.SetRange("Date Filter",0D,"Needed by Date");
        Item.SetFilter("Location Filter",LocationFilter);
        Item.SetFilter("Variant Filter","Variant Code");
        if ShowBy <> Showby::Item then
          Item.SetFilter("Location Filter","Location Code");
        if Indentation = 0 then
          Item.SetFilter("Variant Filter",VariantFilter);

        ItemAvailFormsMgt.ShowItemAvailFromItem(Item,AvailType);
    end;

    local procedure ShowAbleToMakeTimeline()
    var
        Item: Record Item;
        ItemAbleToMakeTimeline: Report "Item - Able to Make (Timeline)";
    begin
        TestField(Type,Type::Item);

        Item.Get("No.");
        Item.SetFilter("No.","No.");

        with ItemAbleToMakeTimeline do begin
          if Indentation = 0 then begin
            case ShowBy of
              Showby::Item:
                begin
                  Item.SetFilter("Location Filter",LocationFilter);
                  Item.SetFilter("Variant Filter",VariantFilter);
                end;
              Showby::Assembly:
                InitAsmOrder(AsmHeader);
              Showby::Production:
                InitProdOrder(ProdOrderLine);
            end;
          end else begin
            Item.SetFilter("Location Filter",LocationFilter);
            Item.SetFilter("Variant Filter",VariantFilter);
          end;

          SetTableview(Item);
          Initialize("Needed by Date",0,7,true);
          Run;
        end;
    end;

    local procedure ShowWarnings()
    var
        TempBOMWarningLog: Record "BOM Warning Log" temporary;
    begin
        if IsLineOk(true,TempBOMWarningLog) then
          Message(Text001)
        else
          Page.RunModal(Page::"BOM Warning Log",TempBOMWarningLog);
    end;

    local procedure ShowWarningsForAllLines()
    var
        TempBOMWarningLog: Record "BOM Warning Log" temporary;
    begin
        if AreAllLinesOk(TempBOMWarningLog) then
          Message(Text001)
        else
          Page.RunModal(Page::"BOM Warning Log",TempBOMWarningLog);
    end;
}

