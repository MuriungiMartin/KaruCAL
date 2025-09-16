#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5510 "Production Journal"
{
    Caption = 'Production Journal';
    DataCaptionExpression = GetCaption;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Item Journal Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PostingDate;PostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies a posting date that will apply to all the lines in the production journal.';

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field(FlushingFilter;FlushingFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Flushing Method Filter';
                    OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward,All Methods';
                    ToolTip = 'Specifies which components to view and handle in the journal, according to their flushing method.';

                    trigger OnValidate()
                    begin
                        FlushingFilterOnAfterValidate;
                    end;
                }
            }
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of transaction that will be posted from the item journal line.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting date for the entry.';
                    Visible = false;
                }
                field("Order Line No.";"Order Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the line number of the order that created the entry.';
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies a document number for the journal line.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the item on the journal line.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Item.Get("Item No.") then
                          Page.RunModal(Page::"Item List",Item);
                    end;
                }
                field("Operation No.";"Operation No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the production operation on the item journal line when the journal functions as an output journal.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    OptionCaption = 'Work Center,Machine Center, ';
                    ToolTip = 'Specifies the journal type, which is either Work Center or Machine Center.';
                    Visible = true;
                }
                field("Flushing Method";"Flushing Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Manages the Flushing Method Filter field in the Production Journal window.';
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of a work center or a machine center, depending on the entry in the Type field.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = DescriptionEmphasize;
                    ToolTip = 'Specifies a description of the item on the journal line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Consumption Quantity';
                    Editable = QuantityEditable;
                    HideValue = QuantityHideValue;
                    ToolTip = 'Specifies the quantity of the component that will be posted as consumed.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code if you have filled in the Sales Unit of Measure field on the item card.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the inventory location where the item on the journal line will be registered.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a bin code for the item.';
                    Visible = false;
                }
                field("Work Shift Code";"Work Shift Code")
                {
                    ApplicationArea = Basic;
                    Editable = WorkShiftCodeEditable;
                    ToolTip = 'Specifies the work shift code for this Journal line.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the item journal line is linked to.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general business posting group that will be used when you post the entry on the item journal line.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general product posting group that will be used for this item when you post the entry on the item journal line.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the item journal line is linked to.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    Editable = StartingTimeEditable;
                    ToolTip = 'Specifies the starting time of the operation on the item journal line.';
                    Visible = false;
                }
                field("Ending Time";"Ending Time")
                {
                    ApplicationArea = Basic;
                    Editable = EndingTimeEditable;
                    ToolTip = 'Specifies the ending time of the operation on the item journal line.';
                    Visible = false;
                }
                field("Concurrent Capacity";"Concurrent Capacity")
                {
                    ApplicationArea = Basic;
                    Editable = ConcurrentCapacityEditable;
                    ToolTip = 'Specifies the concurrent capacity.';
                    Visible = false;
                }
                field("Setup Time";"Setup Time")
                {
                    ApplicationArea = Basic;
                    Editable = SetupTimeEditable;
                    HideValue = SetupTimeHideValue;
                    ToolTip = 'Specifies the time required to set up the machines for this journal line.';
                }
                field("Run Time";"Run Time")
                {
                    ApplicationArea = Basic;
                    Editable = RunTimeEditable;
                    HideValue = RunTimeHideValue;
                    ToolTip = 'Specifies the run time of the operations represented by this journal line.';
                }
                field("Cap. Unit of Measure Code";"Cap. Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = CapUnitofMeasureCodeEditable;
                    ToolTip = 'Specifies the unit of measure code for the capacity usage.';
                    Visible = false;
                }
                field("Scrap Code";"Scrap Code")
                {
                    ApplicationArea = Basic;
                    Editable = ScrapCodeEditable;
                    ToolTip = 'Specifies the scrap code.';
                    Visible = false;
                }
                field("Output Quantity";"Output Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = OutputQuantityEditable;
                    HideValue = OutputQuantityHideValue;
                    ToolTip = 'Specifies the quantity of the produced item that can be posted as output on the journal line.';
                }
                field("Scrap Quantity";"Scrap Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = ScrapQuantityEditable;
                    HideValue = ScrapQuantityHideValue;
                    ToolTip = 'Specifies the number of units produced incorrectly, and therefore cannot be used.';
                }
                field(Finished;Finished)
                {
                    ApplicationArea = Basic;
                    Editable = FinishedEditable;
                    ToolTip = 'Specifies that the operation represented by the output journal line is finished.';
                }
                field("Applies-to Entry";"Applies-to Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the quantity in the item journal line should be applied to an already-posted document.';
                    Visible = false;
                }
                field("Applies-from Entry";"Applies-from Entry")
                {
                    ApplicationArea = Basic;
                    Editable = AppliesFromEntryEditable;
                    ToolTip = 'Specifies the number of the outbound item ledger entry, whose cost is forwarded to the inbound item ledger entry.';
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the item journal line.';
                    Visible = false;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a document number referring to the customer or vendor numbering system with whom you are trading items on this journal line.';
                    Visible = false;
                }
            }
            group(Actual)
            {
                Caption = 'Actual';
                fixed(Control1902114901)
                {
                    group("Consump. Qty.")
                    {
                        Caption = 'Consump. Qty.';
                        field(ActualConsumpQty;ActualConsumpQty)
                        {
                            ApplicationArea = Basic;
                            DecimalPlaces = 0:5;
                            Editable = false;
                            HideValue = ActualConsumpQtyHideValue;
                            ShowCaption = false;
                        }
                    }
                    group(Control1901741901)
                    {
                        Caption = 'Setup Time';
                        field(ActualSetupTime;ActualSetupTime)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Setup Time';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            HideValue = ActualSetupTimeHideValue;
                        }
                    }
                    group(Control1902759401)
                    {
                        Caption = 'Run Time';
                        field(ActualRunTime;ActualRunTime)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Run Time';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            HideValue = ActualRunTimeHideValue;
                        }
                    }
                    group("Output Qty.")
                    {
                        Caption = 'Output Qty.';
                        field(ActualOutputQty;ActualOutputQty)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Output Qty.';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            HideValue = ActualOutputQtyHideValue;
                        }
                    }
                    group("Scrap Qty.")
                    {
                        Caption = 'Scrap Qty.';
                        field(ActualScrapQty;ActualScrapQty)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Scrap Qty.';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            HideValue = ActualScrapQtyHideValue;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
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
                action(ItemTrackingLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines(false);
                    end;
                }
                action("Bin Contents")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Contents List";
                    RunPageLink = "Location Code"=field("Location Code"),
                                  "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code");
                    RunPageView = sorting("Location Code","Bin Code","Item No.","Variant Code");
                }
            }
            group("Pro&d. Order")
            {
                Caption = 'Pro&d. Order';
                Image = "Order";
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Released Production Order";
                    RunPageLink = "No."=field("Order No.");
                    ShortCutKey = 'Shift+F7';
                }
                group("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = Entries;
                    action("Item Ledger E&ntries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item Ledger E&ntries';
                        Image = ItemLedger;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Order Type"=const(Production),
                                      "Order No."=field("Order No.");
                        RunPageView = sorting("Order Type","Order No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("Capacity Ledger Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Capacity Ledger Entries';
                        Image = CapacityLedger;
                        RunObject = Page "Capacity Ledger Entries";
                        RunPageLink = "Order Type"=const(Production),
                                      "Order No."=field("Order No.");
                        RunPageView = sorting("Order Type","Order No.");
                    }
                    action("Value Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Order Type"=const(Production),
                                      "Order No."=field("Order No.");
                        RunPageView = sorting("Order Type","Order No.");
                    }
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintItemJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        DeleteRecTemp;

                        PostingItemJnlFromProduction(false);

                        InsertTempRec;

                        SetFilterGroup;
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        DeleteRecTemp;

                        PostingItemJnlFromProduction(true);

                        InsertTempRec;

                        SetFilterGroup;
                        CurrPage.Update(false);
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    ItemJnlLine.Copy(Rec);
                    ItemJnlLine.SetRange("Journal Template Name","Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
                    Report.RunModal(Report::"Inventory Movement",true,true,ItemJnlLine);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetActTimeAndQtyBase;

        ControlsMngt;
    end;

    trigger OnAfterGetRecord()
    begin
        ActualScrapQtyHideValue := false;
        ActualOutputQtyHideValue := false;
        ActualRunTimeHideValue := false;
        ActualSetupTimeHideValue := false;
        ActualConsumpQtyHideValue := false;
        ScrapQuantityHideValue := false;
        OutputQuantityHideValue := false;
        RunTimeHideValue := false;
        SetupTimeHideValue := false;
        QuantityHideValue := false;
        DescriptionIndent := 0;
        ShowShortcutDimCode(ShortcutDimCode);
        DescriptionOnFormat;
        QuantityOnFormat;
        SetupTimeOnFormat;
        RunTimeOnFormat;
        OutputQuantityOnFormat;
        ScrapQuantityOnFormat;
        ActualConsumpQtyOnFormat;
        ActualSetupTimeOnFormat;
        ActualRunTimeOnFormat;
        ActualOutputQtyOnFormat;
        ActualScrapQtyOnFormat;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
    begin
        Commit;
        if not ReserveItemJnlLine.DeleteLineConfirm(Rec) then
          exit(false);
        ReserveItemJnlLine.DeleteLine(Rec);
    end;

    trigger OnInit()
    begin
        AppliesFromEntryEditable := true;
        QuantityEditable := true;
        OutputQuantityEditable := true;
        ScrapQuantityEditable := true;
        ScrapCodeEditable := true;
        FinishedEditable := true;
        WorkShiftCodeEditable := true;
        RunTimeEditable := true;
        SetupTimeEditable := true;
        CapUnitofMeasureCodeEditable := true;
        ConcurrentCapacityEditable := true;
        EndingTimeEditable := true;
        StartingTimeEditable := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        "Changed by User" := true;
    end;

    trigger OnOpenPage()
    begin
        SetFilterGroup;

        if ProdOrderLineNo <> 0 then
          ProdOrderLine.Get(ProdOrder.Status,ProdOrder."No.",ProdOrderLineNo);
    end;

    var
        Item: Record Item;
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        TempItemJrnlLine: Record "Item Journal Line" temporary;
        CostCalcMgt: Codeunit "Cost Calculation Management";
        ReportPrint: Codeunit "Test Report-Print";
        PostingDate: Date;
        xPostingDate: Date;
        ProdOrderLineNo: Integer;
        ShortcutDimCode: array [8] of Code[20];
        ToTemplateName: Code[10];
        ToBatchName: Code[10];
        ActualRunTime: Decimal;
        ActualSetupTime: Decimal;
        ActualOutputQty: Decimal;
        ActualScrapQty: Decimal;
        ActualConsumpQty: Decimal;
        FlushingFilter: Option Manual,Forward,Backward,"Pick + Forward","Pick + Backward","All Methods";
        [InDataSet]
        DescriptionIndent: Integer;
        [InDataSet]
        QuantityHideValue: Boolean;
        [InDataSet]
        SetupTimeHideValue: Boolean;
        [InDataSet]
        RunTimeHideValue: Boolean;
        [InDataSet]
        OutputQuantityHideValue: Boolean;
        [InDataSet]
        ScrapQuantityHideValue: Boolean;
        [InDataSet]
        ActualConsumpQtyHideValue: Boolean;
        [InDataSet]
        ActualSetupTimeHideValue: Boolean;
        [InDataSet]
        ActualRunTimeHideValue: Boolean;
        [InDataSet]
        ActualOutputQtyHideValue: Boolean;
        [InDataSet]
        ActualScrapQtyHideValue: Boolean;
        [InDataSet]
        StartingTimeEditable: Boolean;
        [InDataSet]
        EndingTimeEditable: Boolean;
        [InDataSet]
        ConcurrentCapacityEditable: Boolean;
        [InDataSet]
        CapUnitofMeasureCodeEditable: Boolean;
        [InDataSet]
        SetupTimeEditable: Boolean;
        [InDataSet]
        RunTimeEditable: Boolean;
        [InDataSet]
        WorkShiftCodeEditable: Boolean;
        [InDataSet]
        FinishedEditable: Boolean;
        [InDataSet]
        ScrapCodeEditable: Boolean;
        [InDataSet]
        ScrapQuantityEditable: Boolean;
        [InDataSet]
        OutputQuantityEditable: Boolean;
        [InDataSet]
        QuantityEditable: Boolean;
        [InDataSet]
        AppliesFromEntryEditable: Boolean;
        [InDataSet]
        DescriptionEmphasize: Text;


    procedure Setup(TemplateName: Code[10];BatchName: Code[10];ProductionOrder: Record "Production Order";ProdLineNo: Integer;PostDate: Date)
    begin
        ToTemplateName := TemplateName;
        ToBatchName := BatchName;
        ProdOrder := ProductionOrder;
        ProdOrderLineNo := ProdLineNo;
        PostingDate := PostDate;
        xPostingDate := PostingDate;

        FlushingFilter := Flushingfilter::Manual;
    end;

    local procedure GetActTimeAndQtyBase()
    begin
        ActualSetupTime := 0;
        ActualRunTime := 0;
        ActualOutputQty := 0;
        ActualScrapQty := 0;
        ActualConsumpQty := 0;

        if "Qty. per Unit of Measure" = 0 then
          "Qty. per Unit of Measure" := 1;
        if "Qty. per Cap. Unit of Measure" = 0 then
          "Qty. per Cap. Unit of Measure" := 1;

        if Item.Get("Item No.") then
          case "Entry Type" of
            "entry type"::Consumption:
              if ProdOrderComp.Get(
                   ProdOrder.Status,
                   "Order No.",
                   "Order Line No.",
                   "Prod. Order Comp. Line No.")
              then begin
                ProdOrderComp.CalcFields("Act. Consumption (Qty)"); // Base Unit
                ActualConsumpQty :=
                  ProdOrderComp."Act. Consumption (Qty)" / "Qty. per Unit of Measure";
                if Item."Rounding Precision" > 0 then
                  ActualConsumpQty := ROUND(ActualConsumpQty,Item."Rounding Precision",'>')
                else
                  ActualConsumpQty := ROUND(ActualConsumpQty,0.00001);
              end;
            "entry type"::Output:
              begin
                if ProdOrderLineNo = 0 then
                  if not ProdOrderLine.Get(ProdOrder.Status,ProdOrder."No.","Order Line No.") then
                    Clear(ProdOrderLine);
                if ProdOrderLine."Prod. Order No." <> '' then begin
                  CostCalcMgt.CalcActTimeAndQtyBase(
                    ProdOrderLine,"Operation No.",ActualRunTime,ActualSetupTime,ActualOutputQty,ActualScrapQty);
                  ActualSetupTime :=
                    ROUND(ActualSetupTime / "Qty. per Cap. Unit of Measure",0.00001);
                  ActualRunTime :=
                    ROUND(ActualRunTime / "Qty. per Cap. Unit of Measure",0.00001);

                  ActualOutputQty := ActualOutputQty / "Qty. per Unit of Measure";
                  ActualScrapQty := ActualScrapQty / "Qty. per Unit of Measure";
                  if Item."Rounding Precision" > 0 then begin
                    ActualOutputQty := ROUND(ActualOutputQty,Item."Rounding Precision",'>');
                    ActualScrapQty := ROUND(ActualScrapQty,Item."Rounding Precision",'>');
                  end else begin
                    ActualOutputQty := ROUND(ActualOutputQty,0.00001);
                    ActualScrapQty := ROUND(ActualScrapQty,0.00001);
                  end;
                end;
              end;
          end;
    end;

    local procedure ControlsMngt()
    var
        OperationExist: Boolean;
    begin
        if ("Entry Type" = "entry type"::Output) and
           ("Operation No." <> '')
        then
          OperationExist := true
        else
          OperationExist := false;

        StartingTimeEditable := OperationExist;
        EndingTimeEditable := OperationExist;
        ConcurrentCapacityEditable := OperationExist;
        CapUnitofMeasureCodeEditable := OperationExist;
        SetupTimeEditable := OperationExist;
        RunTimeEditable := OperationExist;
        WorkShiftCodeEditable := OperationExist;

        FinishedEditable := "Entry Type" = "entry type"::Output;
        ScrapCodeEditable := "Entry Type" = "entry type"::Output;
        ScrapQuantityEditable := "Entry Type" = "entry type"::Output;
        OutputQuantityEditable := "Entry Type" = "entry type"::Output;

        QuantityEditable := "Entry Type" = "entry type"::Consumption;
        AppliesFromEntryEditable := "Entry Type" = "entry type"::Consumption;
    end;

    local procedure DeleteRecTemp()
    begin
        TempItemJrnlLine.DeleteAll;

        if Find('-') then
          repeat
            case "Entry Type" of
              "entry type"::Consumption:
                if "Quantity (Base)" = 0 then begin
                  TempItemJrnlLine := Rec;
                  TempItemJrnlLine.Insert;

                  Delete;
                end;
              "entry type"::Output:
                if TimeIsEmpty and
                   ("Output Quantity (Base)" = 0) and ("Scrap Quantity (Base)" = 0)
                then begin
                  TempItemJrnlLine := Rec;
                  TempItemJrnlLine.Insert;

                  Delete;
                end;
            end;
          until Next = 0;
    end;

    local procedure InsertTempRec()
    begin
        if TempItemJrnlLine.Find('-') then
          repeat
            Rec := TempItemJrnlLine;
            "Changed by User" := false;
            Insert;
          until TempItemJrnlLine.Next = 0;
        TempItemJrnlLine.DeleteAll;
    end;


    procedure SetFilterGroup()
    begin
        FilterGroup(2);
        SetRange("Journal Template Name",ToTemplateName);
        SetRange("Journal Batch Name",ToBatchName);
        SetRange("Order Type","order type"::Production);
        SetRange("Order No.",ProdOrder."No.");
        if ProdOrderLineNo <> 0 then
          SetRange("Order Line No.",ProdOrderLineNo);
        SetFlushingFilter;
        FilterGroup(0);
    end;


    procedure SetFlushingFilter()
    begin
        if FlushingFilter <> Flushingfilter::"All Methods" then
          SetRange("Flushing Method",FlushingFilter)
        else
          SetRange("Flushing Method");
    end;

    local procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        SourceTableName: Text[100];
        Descrip: Text[100];
    begin
        SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,5405);
        if ProdOrderLineNo <> 0 then
          Descrip := ProdOrderLine.Description
        else
          Descrip := ProdOrder.Description;

        exit(StrSubstNo('%1 %2 %3',SourceTableName,ProdOrder."No.",Descrip));
    end;

    local procedure PostingDateOnAfterValidate()
    begin
        if PostingDate = 0D then
          PostingDate := xPostingDate;

        if PostingDate <> xPostingDate then begin
          ModifyAll("Posting Date",PostingDate);
          xPostingDate := PostingDate;
          CurrPage.Update(false);
        end;
    end;

    local procedure FlushingFilterOnAfterValidate()
    begin
        SetFilterGroup;
        CurrPage.Update(false);
    end;

    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := Level;
        if "Entry Type" = "entry type"::Output then
          DescriptionEmphasize := 'Strong'
        else
          DescriptionEmphasize := '';
    end;

    local procedure QuantityOnFormat()
    begin
        if "Entry Type" = "entry type"::Output then
          QuantityHideValue := true;
    end;

    local procedure SetupTimeOnFormat()
    begin
        if ("Entry Type" = "entry type"::Consumption) or
           ("Operation No." = '')
        then
          SetupTimeHideValue := true;
    end;

    local procedure RunTimeOnFormat()
    begin
        if ("Entry Type" = "entry type"::Consumption) or
           ("Operation No." = '')
        then
          RunTimeHideValue := true;
    end;

    local procedure OutputQuantityOnFormat()
    begin
        if "Entry Type" = "entry type"::Consumption then
          OutputQuantityHideValue := true;
    end;

    local procedure ScrapQuantityOnFormat()
    begin
        if "Entry Type" = "entry type"::Consumption then
          ScrapQuantityHideValue := true;
    end;

    local procedure ActualConsumpQtyOnFormat()
    begin
        if "Entry Type" = "entry type"::Output then
          ActualConsumpQtyHideValue := true;
    end;

    local procedure ActualSetupTimeOnFormat()
    begin
        if ("Entry Type" = "entry type"::Consumption) or
           ("Operation No." = '')
        then
          ActualSetupTimeHideValue := true;
    end;

    local procedure ActualRunTimeOnFormat()
    begin
        if ("Entry Type" = "entry type"::Consumption) or
           ("Operation No." = '')
        then
          ActualRunTimeHideValue := true;
    end;

    local procedure ActualOutputQtyOnFormat()
    begin
        if "Entry Type" = "entry type"::Consumption then
          ActualOutputQtyHideValue := true;
    end;

    local procedure ActualScrapQtyOnFormat()
    begin
        if "Entry Type" = "entry type"::Consumption then
          ActualScrapQtyHideValue := true;
    end;
}

