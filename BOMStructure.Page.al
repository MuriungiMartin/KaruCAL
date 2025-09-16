#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5870 "BOM Structure"
{
    Caption = 'BOM Structure';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "BOM Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            grid(Option)
            {
                Caption = 'Option';
                field(ItemFilter;ItemFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Filter';
                    ToolTip = 'Specifies the items that are shown in the BOM Structure window.';

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
                        RefreshPage;
                    end;
                }
            }
            repeater(Group)
            {
                Caption = 'Lines';
                IndentationColumn = Indentation;
                ShowAsTree = true;
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item''s position in the BOM hierarchy. Lower-level items are indented under their parents.';
                }
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
                    Style = Strong;
                    StyleExpr = IsParentExpr;
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
                    ToolTip = 'Specifies if the BOM line has setup or data issues.';

                    trigger OnDrillDown()
                    begin
                        if HasWarning then
                          ShowWarnings;
                    end;
                }
                field("Low-Level Code";"Low-Level Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item''s level in the BOM.';
                    Visible = false;
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
                field("Lead-Time Offset";"Lead-Time Offset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total number of days that are required to assemble or produce the item.';
                    Visible = false;
                }
                field("Safety Lead Time";"Safety Lead Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies any safety lead time that is defined for the item.';
                    Visible = false;
                }
                field("Lead Time Calculation";"Lead Time Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how long it takes to replenish the item, by purchase, assembly, or production.';
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
        ShowBy: Option Item,Assembly,Production;
        Text000: label 'Could not find items with BOM levels.';
        [InDataSet]
        HasWarning: Boolean;
        Text001: label 'There are no warnings.';


    procedure InitItem(var NewItem: Record Item)
    begin
        Item.Copy(NewItem);
        ItemFilter := Item."No.";
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

    local procedure RefreshPage()
    var
        CalcBOMTree: Codeunit "Calculate BOM Tree";
    begin
        Item.SetFilter("No.",ItemFilter);
        CalcBOMTree.SetItemFilter(Item);
        case ShowBy of
          Showby::Item:
            begin
              Item.FindFirst;
              if (not Item.HasBOM) and (Item."Routing No." = '') then
                Error(Text000);
              CalcBOMTree.GenerateTreeForItems(Item,Rec,0);
            end;
          Showby::Production:
            CalcBOMTree.GenerateTreeForProdLine(ProdOrderLine,Rec,0);
          Showby::Assembly:
            CalcBOMTree.GenerateTreeForAsm(AsmHeader,Rec,0);
        end;

        CurrPage.Update(false);
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

    local procedure ItemAvail(AvailType: Option)
    var
        Item: Record Item;
    begin
        TestField(Type,Type::Item);

        Item.Get("No.");
        Item.SetFilter("No.","No.");
        Item.SetRange("Date Filter",0D,"Needed by Date");
        Item.SetFilter("Variant Filter","Variant Code");
        if ShowBy <> Showby::Item then
          Item.SetFilter("Location Filter","Location Code");

        ItemAvailFormsMgt.ShowItemAvailFromItem(Item,AvailType);
    end;
}

