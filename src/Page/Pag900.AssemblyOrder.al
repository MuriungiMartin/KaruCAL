#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 900 "Assembly Order"
{
    Caption = 'Assembly Order';
    PageType = Document;
    SourceTable = "Assembly Header";
    SourceTableView = sorting("Document Type","No.")
                      order(ascending)
                      where("Document Type"=const(Order));

    layout
    {
        area(content)
        {
            group(Control2)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;
                    ToolTip = 'Specifies the number assigned to the assembly order from the number series that you set up in the Assembly Setup window.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    Importance = Promoted;
                    TableRelation = Item."No." where ("Assembly BOM"=const(true));
                    ToolTip = 'Specifies the number of the item that is being assembled with the assembly order.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the assembly item.';
                }
                group(Control33)
                {
                    field(Quantity;Quantity)
                    {
                        ApplicationArea = Basic;
                        Editable = IsAsmToOrderEditable;
                        Importance = Promoted;
                        ToolTip = 'Specifies how many units of the assembly item that you expect to assemble with the assembly order.';

                        trigger OnValidate()
                        begin
                            CurrPage.SaveRecord;
                        end;
                    }
                    field("Quantity to Assemble";"Quantity to Assemble")
                    {
                        ApplicationArea = Basic;
                        Importance = Promoted;
                        ToolTip = 'Specifies how many of the assembly item units you want to partially post. To post the full quantity on the assembly order, leave the field unchanged.';

                        trigger OnValidate()
                        begin
                            CurrPage.SaveRecord;
                        end;
                    }
                    field("Unit of Measure Code";"Unit of Measure Code")
                    {
                        ApplicationArea = Basic;
                        Editable = IsAsmToOrderEditable;
                        ToolTip = 'Specifies the unit of measure code of the assembly item.';

                        trigger OnValidate()
                        begin
                            CurrPage.SaveRecord;
                        end;
                    }
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date on which the assembly order is posted.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the assembled item is due to be available for use.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly order is expected to start.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly order is expected to finish.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly item remain to be posted as assembled output.';
                }
                field("Assembled Quantity";"Assembled Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly item are posted as assembled output.';
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the assembly item are reserved for this assembly order header.';
                    Visible = false;
                }
                field("Assemble to Order";"Assemble to Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the assembly order is linked to a sales order, which indicates that the item is assembled to order.';

                    trigger OnDrillDown()
                    begin
                        ShowAsmToOrder;
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the document is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                }
            }
            part(Lines;"Assembly Order Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the item variant of the item that is being assembled.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the location to which you want to post output of the assembly item.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    ToolTip = 'Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of the assembly item''s direct unit cost that makes up indirect costs, such as freight and warehouse handling, associated with the assembly.';
                    Visible = false;
                }
                field("Overhead Rate";"Overhead Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the indirect cost of the assembly item as an absolute amount.';
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = IsUnitCostEditable;
                    ToolTip = 'Specifies the unit cost of the assembly item.';
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total unit cost of the assembly order.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control11;"Assembly Item - Details")
            {
                SubPageLink = "No."=field("Item No.");
            }
            part(Control44;"Component - Item FactBox")
            {
                Provider = Lines;
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
            }
            part(Control43;"Component - Resource Details")
            {
                Provider = Lines;
                SubPageLink = "No."=field("No.");
            }
            systempart(Control8;Links)
            {
            }
            systempart(Control9;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Item Availability by")
            {
                Caption = 'Item Availability by';
                Image = ItemAvailability;
                action("Event")
                {
                    ApplicationArea = Basic;
                    Caption = 'Event';
                    Image = "Event";

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByEvent);
                    end;
                }
                action(Period)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period';
                    Image = Period;

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByPeriod);
                    end;
                }
                action(Variant)
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant';
                    Image = ItemVariant;

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByVariant);
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
                        ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByLocation);
                    end;
                }
                action("BOM Level")
                {
                    ApplicationArea = Basic;
                    Caption = 'BOM Level';
                    Image = BOMLevel;

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByBOM);
                    end;
                }
            }
            group(General)
            {
                Caption = 'General';
                Image = AssemblyBOM;
                action("Assembly BOM")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assembly BOM';
                    Image = AssemblyBOM;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        ShowAssemblyList;
                    end;
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
                    end;
                }
                action("Item Tracking Lines")
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
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Assembly Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "Document No."=field("No."),
                                  "Document Line No."=const(0);
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                Image = Statistics;
                action(Action14)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    RunPageOnRec = true;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        ShowStatistics;
                    end;
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Pick Lines/Movement Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pick Lines/Movement Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity Lines";
                    RunPageLink = "Source Type"=const(901),
                                  "Source Subtype"=const("1"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.","Unit of Measure Code","Action Type","Breakbulk No.","Original Breakbulk");
                }
                action("Registered P&ick Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered P&ick Lines';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Whse. Act.-Lines";
                    RunPageLink = "Source Type"=const(901),
                                  "Source Subtype"=const("1"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
                }
                action("Registered Invt. Movement Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Invt. Movement Lines';
                    Image = RegisteredDocs;
                    RunObject = Page "Reg. Invt. Movement Lines";
                    RunPageLink = "Source Type"=const(901),
                                  "Source Subtype"=const("1"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
                }
                action("Asm.-to-Order Whse. Shpt. Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Asm.-to-Order Whse. Shpt. Line';
                    Enabled = not IsAsmToOrderEditable;
                    Image = ShipmentLines;

                    trigger OnAction()
                    var
                        ATOLink: Record "Assemble-to-Order Link";
                        WhseShptLine: Record "Warehouse Shipment Line";
                    begin
                        TestField("Assemble to Order",true);
                        ATOLink.Get("Document Type","No.");
                        WhseShptLine.SetCurrentkey("Source Type","Source Subtype","Source No.","Source Line No.","Assemble to Order");
                        WhseShptLine.SetRange("Source Type",Database::"Sales Line");
                        WhseShptLine.SetRange("Source Subtype",ATOLink."Document Type");
                        WhseShptLine.SetRange("Source No.",ATOLink."Document No.");
                        WhseShptLine.SetRange("Source Line No.",ATOLink."Document Line No.");
                        WhseShptLine.SetRange("Assemble to Order",true);
                        Page.RunModal(Page::"Asm.-to-Order Whse. Shpt. Line",WhseShptLine);
                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                group(Entries)
                {
                    Caption = 'Entries';
                    Image = Entries;
                    action("Item Ledger Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item Ledger Entries';
                        Image = ItemLedger;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Order Type"=const(Assembly),
                                      "Order No."=field("No.");
                        RunPageView = sorting("Order Type","Order No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("Capacity Ledger Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Capacity Ledger Entries';
                        Image = CapacityLedger;
                        RunObject = Page "Capacity Ledger Entries";
                        RunPageLink = "Order Type"=const(Assembly),
                                      "Order No."=field("No.");
                        RunPageView = sorting("Order Type","Order No.");
                    }
                    action("Resource Ledger Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resource Ledger Entries';
                        Image = ResourceLedger;
                        RunObject = Page "Resource Ledger Entries";
                        RunPageLink = "Order Type"=const(Assembly),
                                      "Order No."=field("No.");
                        RunPageView = sorting("Order Type","Order No.");
                    }
                    action("Value Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Order Type"=const(Assembly),
                                      "Order No."=field("No.");
                        RunPageView = sorting("Order Type","Order No.");
                    }
                    action("Warehouse Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Source Type"=filter(83|901),
                                      "Source Subtype"=filter("1"|"6"),
                                      "Source No."=field("No.");
                        RunPageView = sorting("Source Type","Source Subtype","Source No.");
                    }
                    action("Reservation Entries")
                    {
                        AccessByPermission = TableData Item=R;
                        ApplicationArea = Basic;
                        Caption = 'Reservation Entries';
                        Image = ReservationLedger;

                        trigger OnAction()
                        begin
                            ShowReservationEntries(true);
                        end;
                    }
                }
                action("Posted Assembly Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Assembly Orders';
                    Image = PostedOrder;
                    RunObject = Page "Posted Assembly Orders";
                    RunPageLink = "Order No."=field("No.");
                    RunPageView = sorting("Order No.");
                }
            }
            separator(Action52)
            {
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                separator(Action49)
                {
                }
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Release Assembly Document",Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseAssemblyDoc: Codeunit "Release Assembly Document";
                    begin
                        ReleaseAssemblyDoc.Reopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ShowAvailability)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Availability';
                    Image = ItemAvailbyLoc;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        ShowAvailability;
                    end;
                }
                action("Update Unit Cost")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Unit Cost';
                    Enabled = IsUnitCostEditable;
                    Image = UpdateUnitCost;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        UpdateUnitCost;
                    end;
                }
                action("Refresh Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Refresh Lines';
                    Image = RefreshLines;

                    trigger OnAction()
                    begin
                        RefreshBOM;
                        CurrPage.Update;
                    end;
                }
                action("&Reserve")
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        ShowReservation;
                    end;
                }
                action("Copy Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Image = CopyDocument;

                    trigger OnAction()
                    var
                        CopyAssemblyDocument: Report "Copy Assembly Document";
                    begin
                        CopyAssemblyDocument.SetAssemblyHeader(Rec);
                        CopyAssemblyDocument.RunModal;
                        if Get("Document Type","No.") then;
                    end;
                }
                separator(Action53)
                {
                }
            }
            group(ActionGroup80)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Create Inventor&y Movement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Inventor&y Movement';
                    Ellipsis = true;
                    Image = CreatePutAway;

                    trigger OnAction()
                    var
                        ATOMovementsCreated: Integer;
                        TotalATOMovementsToBeCreated: Integer;
                    begin
                        CreateInvtMovement(false,false,false,ATOMovementsCreated,TotalATOMovementsToBeCreated);
                    end;
                }
                action("Create Whse. Pick")
                {
                    AccessByPermission = TableData "Bin Content"=R;
                    ApplicationArea = Basic;
                    Caption = 'Create Whse. Pick';
                    Image = CreateWarehousePick;

                    trigger OnAction()
                    begin
                        CreatePick(true,UserId,0,false,false,false);
                    end;
                }
                action("Order &Tracking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        ShowTracking;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("P&ost")
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Enabled = IsAsmToOrderEditable;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Assembly-Post (Yes/No)",Rec);
                    end;
                }
                action("Post &Batch")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Batch Post Assembly Orders",true,true,Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
            group(Print)
            {
                Caption = 'Print';
                Image = Print;
                action("Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Order';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    var
                        DocPrint: Codeunit "Document-Print";
                    begin
                        DocPrint.PrintAsmHeader(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsUnitCostEditable := not IsStandardCostItem;
        IsAsmToOrderEditable := not IsAsmToOrder;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        AssemblyHeaderReserve: Codeunit "Assembly Header-Reserve";
    begin
        TestField("Assemble to Order",false);
        if (Quantity <> 0) and ItemExists("Item No.") then begin
          Commit;
          if not AssemblyHeaderReserve.DeleteLineConfirm(Rec) then
            exit(false);
          AssemblyHeaderReserve.DeleteLine(Rec);
        end;
    end;

    trigger OnOpenPage()
    begin
        IsUnitCostEditable := true;
        IsAsmToOrderEditable := true;

        UpdateWarningOnLines;
    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        [InDataSet]
        IsUnitCostEditable: Boolean;
        [InDataSet]
        IsAsmToOrderEditable: Boolean;
}

