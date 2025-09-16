#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 902 "Assembly Orders"
{
    ApplicationArea = Basic;
    Caption = 'Assembly Orders';
    CardPageID = "Assembly Order";
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = "Assembly Header";
    SourceTableView = where("Document Type"=filter(Order));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of assembly document the record represents in assemble-to-order scenarios.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number assigned to the assembly order from the number series that you set up in the Assembly Setup window.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the assembly item.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembled item is due to be available for use.';
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
                field("Assemble to Order";"Assemble to Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the assembly order is linked to a sales order, which indicates that the item is assembled to order.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that is being assembled with the assembly order.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly item that you expect to assemble with the assembly order.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit cost of the assembly item.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location to which you want to post output of the assembly item.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant of the item that is being assembled.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly item remain to be posted as assembled output.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Caption = 'RecordLinks';
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
            group(Line)
            {
                Caption = 'Line';
                Image = Line;
                group(Entries)
                {
                    Caption = 'Entries';
                    Image = Entries;
                    action("Item Ledger Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item Ledger E&ntries';
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
                        Caption = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Source Type"=filter(83|901),
                                      "Source Subtype"=filter("1"|"6"),
                                      "Source No."=field("No.");
                        RunPageView = sorting("Source Type","Source Subtype","Source No.");
                    }
                }
                action("Show Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Order';
                    Image = ViewOrder;
                    RunObject = Page "Assembly Order";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+F7';
                }
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
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    RunObject = Page "Assembly Order Statistics";
                    RunPageOnRec = true;
                    ShortCutKey = 'F7';
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
                action("Assembly BOM")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assembly BOM';
                    Image = AssemblyBOM;
                    RunObject = Page "Assembly BOM";
                    RunPageLink = "Parent Item No."=field("Item No.");
                }
                action(Comments)
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
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
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

                    trigger OnAction()
                    var
                        ReleaseAssemblyDoc: Codeunit "Release Assembly Document";
                    begin
                        ReleaseAssemblyDoc.Reopen(Rec);
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
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Batch Post Assembly Orders",true,true,Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
}

