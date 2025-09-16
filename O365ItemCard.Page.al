#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2106 "O365 Item Card"
{
    Caption = 'Item';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Item,History,Special Prices & Discounts,Approve,Request Approval,Details';
    RefreshOnActivate = true;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(Item)
            {
                Caption = 'Item';
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a description of the item.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether this item is a service or an inventory item.';
                    Visible = false;
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Unit of Measure';
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the unit in which the item is held in inventory.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        Get("No.");
                    end;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = PriceEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the price for one unit of the item, in $.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cost per unit of the item.';
                    Visible = false;
                }
            }
            group(InventoryGrp)
            {
                Caption = 'Inventory';
                Visible = false;
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';

                    trigger OnAssistEdit()
                    begin
                        Modify(true);
                        Commit;
                        if Page.RunModal(Page::"Adjust Inventory",Rec) = Action::LookupOK then
                          Find;
                        CurrPage.Update
                    end;
                }
                field("Qty. on Sales Order";"Qty. on Sales Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
                }
                field(StockoutWarningDefaultYes;"Stockout Warning")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Stockout Warning';
                    OptionCaption = 'Default (Yes),No,Yes';
                    ToolTip = 'Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item''s inventory below zero.';
                    Visible = ShowStockoutWarningDefaultYes;
                }
                field(StockoutWarningDefaultNo;"Stockout Warning")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Stockout Warning';
                    OptionCaption = 'Default (No),No,Yes';
                    ToolTip = 'Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item''s inventory below zero.';
                    Visible = ShowStockoutWarningDefaultNo;
                }
            }
            group("Price & Posting")
            {
                Caption = 'Price & Posting';
                Visible = false;
                field(SpecialPricesAndDiscountsTxt;SpecialPricesAndDiscountsTxt)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Special Prices & Discounts';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies special prices and line discounts for the item.';

                    trigger OnDrillDown()
                    var
                        SalesPrice: Record "Sales Price";
                        SalesLineDiscount: Record "Sales Line Discount";
                        SalesPriceAndLineDiscounts: Page "Sales Price and Line Discounts";
                    begin
                        if SpecialPricesAndDiscountsTxt = ViewOrChangeExistingTxt then begin
                          SalesPriceAndLineDiscounts.InitPage(true);
                          SalesPriceAndLineDiscounts.LoadItem(Rec);
                          SalesPriceAndLineDiscounts.RunModal;
                          exit;
                        end;

                        case StrMenu(StrSubstNo('%1,%2',CreateNewSpecialPriceTxt,CreateNewSpecialDiscountTxt),1,'') of
                          1:
                            begin
                              SalesPrice.SetRange("Item No.","No.");
                              Page.RunModal(Page::"Sales Prices",SalesPrice);
                            end;
                          2:
                            begin
                              SalesLineDiscount.SetRange(Type,SalesLineDiscount.Type::Item);
                              SalesLineDiscount.SetRange(Code,"No.");
                              Page.RunModal(Page::"Sales Line Discounts",SalesLineDiscount);
                            end;
                        end;
                    end;
                }
                field("Profit %";"Profit %")
                {
                    ApplicationArea = Basic,Suite;
                    DecimalPlaces = 2:2;
                    Editable = ProfitEditable;
                    ToolTip = 'Specifies the profit margin you want to sell the item at.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                Visible = false;
                field("Standard Cost";"Standard Cost")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = StandardCostEnable;
                    Importance = Standard;
                    ToolTip = 'Specifies the unit cost that is used as a standard measure.';

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                    end;
                }
                field("Sales Unit of Measure";"Sales Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code used when you sell the item.';
                }
            }
            group("Tax Information")
            {
                Caption = 'Tax Information';
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls
    end;

    trigger OnInit()
    begin
        InitControls
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnNewRec
    end;

    trigger OnOpenPage()
    begin
        EnableControls
    end;

    var
        ShowStockoutWarningDefaultYes: Boolean;
        ShowStockoutWarningDefaultNo: Boolean;
        [InDataSet]
        StandardCostEnable: Boolean;
        ProfitEditable: Boolean;
        PriceEditable: Boolean;
        SpecialPricesAndDiscountsTxt: Text;
        CreateNewTxt: label 'Create New...';
        ViewOrChangeExistingTxt: label 'View or Change Existing...';
        CreateNewSpecialPriceTxt: label 'Create New Special Price...';
        CreateNewSpecialDiscountTxt: label 'Create New Special Discount...';

    local procedure EnableControls()
    begin
        ProfitEditable := "Price/Profit Calculation" <> "price/profit calculation"::"Profit=Price-Cost";
        PriceEditable := "Price/Profit Calculation" <> "price/profit calculation"::"Price=Cost+Profit";

        EnableCostingControls;

        EnableShowStockOutWarning;

        EnableShowShowEnforcePositivInventory;

        UpdateSpecialPricesAndDiscountsTxt;
    end;

    local procedure OnNewRec()
    var
        ItemTemplate: Record "Item Template";
        Item: Record Item;
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        if GuiAllowed then begin
          EnableControls;
          if "No." = '' then begin
            if not DocumentNoVisibility.ItemNoSeriesIsDefault then
              exit;

            if not ItemTemplate.NewItemFromTemplate(Item) then begin
              CurrPage.Close;
              exit;
            end;
          end;

          Rec := Item;
          InitDefaultValues;
          EnableControls;
          Item := Rec;

          CurrPage.Close;
          Page.Run(Page::"O365 Item Card",Item);
        end;
    end;

    local procedure EnableShowStockOutWarning()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        ShowStockoutWarningDefaultYes := SalesSetup."Stockout Warning";
        ShowStockoutWarningDefaultNo := not ShowStockoutWarningDefaultYes;

        EnableShowShowEnforcePositivInventory
    end;

    local procedure EnableShowShowEnforcePositivInventory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get;
    end;

    local procedure EnableCostingControls()
    begin
        StandardCostEnable := "Costing Method" = "costing method"::Standard;
    end;

    local procedure InitControls()
    begin
        StandardCostEnable := true;
    end;

    local procedure UpdateSpecialPricesAndDiscountsTxt()
    var
        TempSalesPriceAndLineDiscBuff: Record "Sales Price and Line Disc Buff" temporary;
    begin
        SpecialPricesAndDiscountsTxt := CreateNewTxt;
        TempSalesPriceAndLineDiscBuff.LoadDataForItem(Rec);
        if not TempSalesPriceAndLineDiscBuff.IsEmpty then
          SpecialPricesAndDiscountsTxt := ViewOrChangeExistingTxt;
    end;

    local procedure InitDefaultValues()
    var
        UnitOfMeasure: Record "Unit of Measure";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        VATProductPostingGroup: Record "VAT Product Posting Group";
        UnitOfMeasureDefaultCode: Code[10];
    begin
        UnitOfMeasureDefaultCode := 'PCS';
        UnitOfMeasure.SetRange(Code,UnitOfMeasureDefaultCode);

        if not UnitOfMeasure.IsEmpty then
          "Base Unit of Measure" := UnitOfMeasureDefaultCode;

        Type := Type::Service;
        "Costing Method" := "costing method"::FIFO;

        if GenProductPostingGroup.FindFirst then
          "Gen. Prod. Posting Group" := GenProductPostingGroup.Code;

        if VATProductPostingGroup.FindFirst then
          "VAT Prod. Posting Group" := VATProductPostingGroup.Code;
    end;
}

