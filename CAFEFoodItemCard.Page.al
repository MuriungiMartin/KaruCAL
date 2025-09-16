#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65017 "CAFE Food Item Card"
{
    Caption = 'Item Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Item,History,Special Prices & Discounts,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = Item;
    SourceTableView = where("Item Category Code"=filter('FOOD'));

    layout
    {
        area(content)
        {
            group(Item)
            {
                Caption = 'Item';
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the item.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a description of the item.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Enabled = InventoryItemEditable;
                    Importance = Promoted;
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
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the unit in which the item is held in inventory.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        Get("No.");
                    end;
                }
                field("Sales Unit of Measure";"Sales Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("Purch. Unit of Measure";"Purch. Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Control1000000008;"Assembly BOM")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates if the item is an assembly BOM.';
                }
                field("Item Category Code";"Item Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the category that the item belongs to.';

                    trigger OnValidate()
                    var
                        ItemAttributeManagement: Codeunit "Item Attribute Management";
                    begin
                        ItemAttributeManagement.InheritAttributesFromItemCategory(Rec,"Item Category Code",xRec."Item Category Code");
                        //CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData("No.");
                        //EnableCostingControls;
                    end;
                }
                field("Product Group Code";"Product Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains a product group code associated with the item category.';
                    Visible = false;
                }
            }
            group("Price & Posting")
            {
                Caption = 'Price & Posting';
                field("Costing Method";"Costing Method")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies how the item''s cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.';

                    trigger OnValidate()
                    begin
                        //EnableCostingControls;
                    end;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = PriceEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the price for one unit of the item, in $.';
                }
                field("Price Includes VAT";"Price Includes VAT")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on sales document lines for this item should be shown with or without tax.';
                    Visible = UseVAT;

                    trigger OnValidate()
                    begin
                        if "Price Includes VAT" = xRec."Price Includes VAT" then
                          exit;
                    end;
                }
                field("Profit %";"Profit %")
                {
                    ApplicationArea = Basic,Suite;
                    DecimalPlaces = 2:2;
                    Editable = ProfitEditable;
                    ToolTip = 'Specifies the profit margin you want to sell the item at.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = UnitCostEnable;
                    ToolTip = 'Specifies the cost per unit of the item.';

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                    end;
                }
            }
            group("Financial Details")
            {
                Caption = 'Financial Details';
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the item''s general product posting group. It links business transactions made for this item with the general ledger to account for the value of trade with the item.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Tax product posting group. Links business transactions made for this item with the general ledger, to account for Tax amounts resulting from trade with the item.';
                    Visible = UseVAT;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                    Visible = UseSalesTax;
                }
                field("Inventory Posting Group";"Inventory Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = InventoryItemEditable;
                    Importance = Additional;
                    ShowMandatory = InventoryItemEditable;
                    ToolTip = 'Specifies the inventory posting group. Links business transactions made for the item with an inventory account in the general ledger, to group amounts for that item type.';
                }
            }
            group(Replenishment)
            {
                Caption = 'Replenishment';
                field("Replenishment System";"Replenishment System")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the type of supply order created by the planning system when the item needs to be replenished.';
                }
                field("Reordering Policy";"Reordering Policy")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the reordering policy.';

                    trigger OnValidate()
                    begin
                        EnablePlanningControls
                    end;
                }
                field("Production BOM No.";"Production BOM No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the production BOM.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
            }
            action("Item Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Item Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Journal";
            }
        }
        area(reporting)
        {
            action("Item Turnover")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Item Turnover';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Turnover";
                ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
            }
            action("Item Transaction Detail")
            {
                ApplicationArea = Basic;
                Caption = 'Item Transaction Detail';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Item Transaction Detail";
            }
        }
        area(navigation)
        {
            group("E&ntries")
            {
                Caption = 'E&ntries';
                Image = Entries;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category5;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No."=field("No.");
                    RunPageView = sorting("Item No.")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action("&Phys. Inventory Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Phys. Inventory Ledger Entries';
                    Image = PhysicalInventoryLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Phys. Inventory Ledger Entries";
                    RunPageLink = "Item No."=field("No.");
                    RunPageView = sorting("Item No.");
                    ToolTip = 'View how many units of the item you had in stock at the last physical count.';
                }
            }
            group(Availability)
            {
                Caption = 'Availability';
                Image = ItemAvailability;
                action(ItemsByLocation)
                {
                    AccessByPermission = TableData Location=R;
                    ApplicationArea = Basic;
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;
                    ToolTip = 'Show a list of items grouped by location.';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Items by Location",Rec);
                    end;
                }
            }
            group("&Item Availability by")
            {
                Caption = '&Item Availability by';
                Image = ItemAvailability;
                action("<Action110>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Event';
                    Image = "Event";
                    ToolTip = 'View how the actual and projected inventory level of an item will develop over time according to supply and demand events.';

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
                    end;
                }
                action(Period)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Period';
                    Image = Period;
                    RunObject = Page "Item Availability by Periods";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Location Filter"=field("Location Filter"),
                                  "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                  "Variant Filter"=field("Variant Filter");
                    ToolTip = 'Show the actual and projected quantity of an item over time according to a specified time interval, such as by day, week or month.';
                }
                action(Location)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location';
                    Image = Warehouse;
                    RunObject = Page "Item Availability by Location";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Location Filter"=field("Location Filter"),
                                  "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                  "Variant Filter"=field("Variant Filter");
                }
            }
            group(ActionGroup102)
            {
                Caption = 'Statistics';
                Image = Statistics;
                action(Statistics)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                    trigger OnAction()
                    var
                        ItemStatistics: Page "Item Statistics";
                    begin
                        ItemStatistics.SetItem(Rec);
                        ItemStatistics.RunModal;
                    end;
                }
                action("Entry Statistics")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Item Entry Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Location Filter"=field("Location Filter"),
                                  "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                  "Variant Filter"=field("Variant Filter");
                    ToolTip = 'View statistics for item ledger entries.';
                }
            }
            group("Assembly/Production")
            {
                Caption = 'Assembly/Production';
                Image = Production;
                action(Structure)
                {
                    ApplicationArea = Basic;
                    Caption = 'Structure';
                    Image = Hierarchy;

                    trigger OnAction()
                    var
                        BOMStructure: Page "BOM Structure";
                    begin
                        BOMStructure.InitItem(Rec);
                        BOMStructure.Run;
                    end;
                }
                action("Cost Shares")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Shares';
                    Image = CostBudget;

                    trigger OnAction()
                    var
                        BOMCostShares: Page "BOM Cost Shares";
                    begin
                        BOMCostShares.InitItem(Rec);
                        BOMCostShares.Run;
                    end;
                }
            }
            group("Assemb&ly")
            {
                Caption = 'Assemb&ly';
                Image = AssemblyBOM;
                action("Assembly BOM")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assembly BOM';
                    Image = BOM;
                    RunObject = Page "Assembly BOM";
                    RunPageLink = "Parent Item No."=field("No.");
                }
                action("Where-Used")
                {
                    ApplicationArea = Basic;
                    Caption = 'Where-Used';
                    Image = Track;
                    RunObject = Page "Where-Used List";
                    RunPageLink = Type=const(Item),
                                  "No."=field("No.");
                    RunPageView = sorting(Type,"No.");
                }
                action("Calc. Stan&dard Cost")
                {
                    AccessByPermission = TableData "BOM Component"=R;
                    ApplicationArea = Basic;
                    Caption = 'Calc. Stan&dard Cost';
                    Image = CalculateCost;

                    trigger OnAction()
                    begin
                        Clear(CalculateStdCost);
                        CalculateStdCost.CalcItem("No.",true);
                    end;
                }
                action("Calc. Unit Price")
                {
                    AccessByPermission = TableData "BOM Component"=R;
                    ApplicationArea = Basic;
                    Caption = 'Calc. Unit Price';
                    Image = SuggestItemPrice;

                    trigger OnAction()
                    begin
                        Clear(CalculateStdCost);
                        CalculateStdCost.CalcAssemblyItemPrice("No.")
                    end;
                }
            }
            group(Production)
            {
                Caption = 'Production';
                Image = Production;
                action("Production BOM")
                {
                    ApplicationArea = Basic;
                    Caption = 'Production BOM';
                    Image = BOM;
                    RunObject = Page "Production BOM";
                    RunPageLink = "No."=field("Production BOM No.");
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        CreateItemFromTemplate;
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        //ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);

        EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode + '|' +
          WorkflowEventHandling.RunWorkflowOnItemChangedCode;

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(Database::Item,EventFilter);

        //CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData("No.");
    end;

    trigger OnAfterGetRecord()
    begin
        EnableControls
    end;

    trigger OnInit()
    begin
        InitControls
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        InsertItemUnitOfMeasure;
        "Item Category Code":='FOOD';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Item Category Code":='FOOD';
        OnNewRec
    end;

    trigger OnOpenPage()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
        EnableControls;

        GLSetup.Get;
        UseVAT := GLSetup."VAT in Use";
        UseSalesTax := not UseVAT;
    end;

    var
        ApplicationAreaSetup: Record "Application Area Setup";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SkilledResourceList: Page "Skilled Resource List";
        IsFoundationEnabled: Boolean;
        ShowStockoutWarningDefaultYes: Boolean;
        ShowStockoutWarningDefaultNo: Boolean;
        ShowPreventNegInventoryDefaultYes: Boolean;
        ShowPreventNegInventoryDefaultNo: Boolean;
        [InDataSet]
        TimeBucketEnable: Boolean;
        [InDataSet]
        SafetyLeadTimeEnable: Boolean;
        [InDataSet]
        SafetyStockQtyEnable: Boolean;
        [InDataSet]
        ReorderPointEnable: Boolean;
        [InDataSet]
        ReorderQtyEnable: Boolean;
        [InDataSet]
        MaximumInventoryEnable: Boolean;
        [InDataSet]
        MinimumOrderQtyEnable: Boolean;
        [InDataSet]
        MaximumOrderQtyEnable: Boolean;
        [InDataSet]
        OrderMultipleEnable: Boolean;
        [InDataSet]
        IncludeInventoryEnable: Boolean;
        [InDataSet]
        ReschedulingPeriodEnable: Boolean;
        [InDataSet]
        LotAccumulationPeriodEnable: Boolean;
        [InDataSet]
        DampenerPeriodEnable: Boolean;
        [InDataSet]
        DampenerQtyEnable: Boolean;
        [InDataSet]
        OverflowLevelEnable: Boolean;
        [InDataSet]
        StandardCostEnable: Boolean;
        [InDataSet]
        UnitCostEnable: Boolean;
        [InDataSet]
        SocialListeningSetupVisible: Boolean;
        [InDataSet]
        SocialListeningVisible: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        [InDataSet]
        InventoryItemEditable: Boolean;
        [InDataSet]
        UnitCostEditable: Boolean;
        ProfitEditable: Boolean;
        PriceEditable: Boolean;
        UseSalesTax: Boolean;
        UseVAT: Boolean;
        SpecialPricesAndDiscountsTxt: Text;
        CreateNewTxt: label 'Create New...';
        ViewOrChangeExistingTxt: label 'View or Change Existing...';
        CreateNewSpecialPriceTxt: label 'Create New Special Price...';
        CreateNewSpecialDiscountTxt: label 'Create New Special Discount...';
        EnabledApprovalWorkflowsExist: Boolean;
        EventFilter: Text;
        NoFieldVisible: Boolean;
        NewMode: Boolean;

    local procedure EnableControls()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        InventoryItemEditable := Type = Type::Inventory;

        if Type = Type::Inventory then begin
          ItemLedgerEntry.SetRange("Item No.","No.");
          UnitCostEditable := ItemLedgerEntry.IsEmpty;
        end else
          UnitCostEditable := true;

        ProfitEditable := "Price/Profit Calculation" <> "price/profit calculation"::"Profit=Price-Cost";
        PriceEditable := "Price/Profit Calculation" <> "price/profit calculation"::"Price=Cost+Profit";

        EnablePlanningControls;
        EnableCostingControls;

        EnableShowStockOutWarning;

        SetSocialListeningFactboxVisibility;
        NoFieldVisible := DocumentNoVisibility.ItemNoIsVisible;
        EnableShowShowEnforcePositivInventory;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

        UpdateSpecialPricesAndDiscountsTxt;
    end;

    local procedure OnNewRec()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        if GuiAllowed then begin
          EnableControls;
          if "No." = '' then
            if DocumentNoVisibility.ItemNoSeriesIsDefault then
              NewMode := true;
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

    local procedure InsertItemUnitOfMeasure()
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        if "Base Unit of Measure" <> '' then begin
          ItemUnitOfMeasure.Init;
          ItemUnitOfMeasure."Item No." := "No.";
          ItemUnitOfMeasure.Validate(Code,"Base Unit of Measure");
          ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
          ItemUnitOfMeasure.Insert;
        end;
    end;

    local procedure EnableShowShowEnforcePositivInventory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get;
        ShowPreventNegInventoryDefaultYes := InventorySetup."Prevent Negative Inventory";
        ShowPreventNegInventoryDefaultNo := not ShowPreventNegInventoryDefaultYes;
    end;

    local procedure EnablePlanningControls()
    var
        PlanningGetParam: Codeunit "Planning-Get Parameters";
        TimeBucketEnabled: Boolean;
        SafetyLeadTimeEnabled: Boolean;
        SafetyStockQtyEnabled: Boolean;
        ReorderPointEnabled: Boolean;
        ReorderQtyEnabled: Boolean;
        MaximumInventoryEnabled: Boolean;
        MinimumOrderQtyEnabled: Boolean;
        MaximumOrderQtyEnabled: Boolean;
        OrderMultipleEnabled: Boolean;
        IncludeInventoryEnabled: Boolean;
        ReschedulingPeriodEnabled: Boolean;
        LotAccumulationPeriodEnabled: Boolean;
        DampenerPeriodEnabled: Boolean;
        DampenerQtyEnabled: Boolean;
        OverflowLevelEnabled: Boolean;
    begin
        PlanningGetParam.SetUpPlanningControls("Reordering Policy","Include Inventory",
          TimeBucketEnabled,SafetyLeadTimeEnabled,SafetyStockQtyEnabled,
          ReorderPointEnabled,ReorderQtyEnabled,MaximumInventoryEnabled,
          MinimumOrderQtyEnabled,MaximumOrderQtyEnabled,OrderMultipleEnabled,IncludeInventoryEnabled,
          ReschedulingPeriodEnabled,LotAccumulationPeriodEnabled,
          DampenerPeriodEnabled,DampenerQtyEnabled,OverflowLevelEnabled);

        TimeBucketEnable := TimeBucketEnabled;
        SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
        SafetyStockQtyEnable := SafetyStockQtyEnabled;
        ReorderPointEnable := ReorderPointEnabled;
        ReorderQtyEnable := ReorderQtyEnabled;
        MaximumInventoryEnable := MaximumInventoryEnabled;
        MinimumOrderQtyEnable := MinimumOrderQtyEnabled;
        MaximumOrderQtyEnable := MaximumOrderQtyEnabled;
        OrderMultipleEnable := OrderMultipleEnabled;
        IncludeInventoryEnable := IncludeInventoryEnabled;
        ReschedulingPeriodEnable := ReschedulingPeriodEnabled;
        LotAccumulationPeriodEnable := LotAccumulationPeriodEnabled;
        DampenerPeriodEnable := DampenerPeriodEnabled;
        DampenerQtyEnable := DampenerQtyEnabled;
        OverflowLevelEnable := OverflowLevelEnabled;
    end;

    local procedure EnableCostingControls()
    begin
        StandardCostEnable := "Costing Method" = "costing method"::Standard;
        UnitCostEnable := "Costing Method" <> "costing method"::Standard;
    end;

    local procedure SetSocialListeningFactboxVisibility()
    var
        SocialListeningMgt: Codeunit "Social Listening Management";
    begin
        SocialListeningMgt.GetItemFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    end;

    local procedure InitControls()
    begin
        UnitCostEnable := true;
        StandardCostEnable := true;
        OverflowLevelEnable := true;
        DampenerQtyEnable := true;
        DampenerPeriodEnable := true;
        LotAccumulationPeriodEnable := true;
        ReschedulingPeriodEnable := true;
        IncludeInventoryEnable := true;
        OrderMultipleEnable := true;
        MaximumOrderQtyEnable := true;
        MinimumOrderQtyEnable := true;
        MaximumInventoryEnable := true;
        ReorderQtyEnable := true;
        ReorderPointEnable := true;
        SafetyStockQtyEnable := true;
        SafetyLeadTimeEnable := true;
        TimeBucketEnable := true;

        InventoryItemEditable := Type = Type::Inventory;
        "Costing Method" := "costing method"::FIFO;
        UnitCostEditable := true;
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

    local procedure CreateItemFromTemplate()
    var
        ItemTemplate: Record "Item Template";
        Item: Record Item;
    begin
        if NewMode then begin
          if ItemTemplate.NewItemFromTemplate(Item) then begin
            Copy(Item);
            CurrPage.Update;
          end;

          // Enforce FIFO costing method for Foundation
          if ApplicationAreaSetup.IsFoundationEnabled then
            Item.Validate("Costing Method","costing method"::FIFO);

          NewMode := false;
        end;
    end;
}

