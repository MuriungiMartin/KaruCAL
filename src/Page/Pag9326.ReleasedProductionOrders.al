#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9326 "Released Production Orders"
{
    ApplicationArea = Basic;
    Caption = 'Released Production Orders';
    CardPageID = "Released Production Order";
    Editable = false;
    PageType = List;
    SourceTable = "Production Order";
    SourceTableView = where(Status=const(Released));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Lookup = false;
                    ToolTip = 'Specifies the number of the production order.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the production order.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source number of the production order.';
                }
                field("Routing No.";"Routing No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the routing number used for this production order.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item or the family to produce (production quantity).';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension associated with the production order.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension associated with the production order.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code to which you want to post the finished product from this production order.';
                    Visible = false;
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting time of the production order.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the production order.';
                }
                field("Ending Time";"Ending Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending time of the production order.';
                    Visible = false;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending date of the production order.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the due date of the production order.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Finished Date";"Finished Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the actual finishing date of a finished production order.';
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the production order.';
                }
                field("Search Description";"Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the search description.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the production order card was last modified.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a bin to which you want to post the finished items.';
                    Visible = false;
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Pro&d. Order")
            {
                Caption = 'Pro&d. Order';
                Image = "Order";
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action("Item Ledger E&ntries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item Ledger E&ntries';
                        Image = ItemLedger;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Order Type"=const(Production),
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
                        RunPageLink = "Order Type"=const(Production),
                                      "Order No."=field("No.");
                        RunPageView = sorting("Order Type","Order No.");
                    }
                    action("Value Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Order Type"=const(Production),
                                      "Order No."=field("No.");
                        RunPageView = sorting("Order Type","Order No.");
                    }
                    action("&Warehouse Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Source Type"=filter(83|5407),
                                      "Source Subtype"=filter("3"|"4"|"5"),
                                      "Source No."=field("No.");
                        RunPageView = sorting("Source Type","Source Subtype","Source No.");
                    }
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Prod. Order Comment Sheet";
                    RunPageLink = Status=field(Status),
                                  "Prod. Order No."=field("No.");
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
                        ShowDocDim;
                    end;
                }
                separator(Action31)
                {
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Production Order Statistics";
                    RunPageLink = Status=field(Status),
                                  "No."=field("No."),
                                  "Date Filter"=field("Date Filter");
                    ShortCutKey = 'F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Change &Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Change &Status';
                    Ellipsis = true;
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Prod. Order Status Management";
                }
                action("&Update Unit Cost")
                {
                    ApplicationArea = Basic;
                    Caption = '&Update Unit Cost';
                    Ellipsis = true;
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ProdOrder: Record "Production Order";
                    begin
                        ProdOrder.SetRange(Status,Status);
                        ProdOrder.SetRange("No.","No.");

                        Report.RunModal(Report::"Update Unit Cost",true,true,ProdOrder);
                    end;
                }
                action("Create Inventor&y Put-away/Pick/Movement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Inventor&y Put-away/Pick/Movement';
                    Ellipsis = true;
                    Image = CreatePutAway;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CreateInvtPutAwayPick;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Prod. Order - Detail Calc.")
            {
                ApplicationArea = Basic;
                Caption = 'Prod. Order - Detail Calc.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Detailed Calc.";
            }
            action("Prod. Order - Precalc. Time")
            {
                ApplicationArea = Basic;
                Caption = 'Prod. Order - Precalc. Time';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Precalc. Time";
            }
            action("Production Order - Comp. and Routing")
            {
                ApplicationArea = Basic;
                Caption = 'Production Order - Comp. and Routing';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Prod. Order Comp. and Routing";
            }
            action(ProdOrderJobCard)
            {
                ApplicationArea = Basic;
                Caption = 'Production Order Job Card';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";

                trigger OnAction()
                begin
                    ManuPrintReport.PrintProductionOrder(Rec,0);
                end;
            }
            action("Production Order - Picking List")
            {
                ApplicationArea = Basic;
                Caption = 'Production Order - Picking List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Picking List";
            }
            action(ProdOrderMaterialRequisition)
            {
                ApplicationArea = Basic;
                Caption = 'Production Order - Material Requisition';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    ManuPrintReport.PrintProductionOrder(Rec,1);
                end;
            }
            action("Production Order List")
            {
                ApplicationArea = Basic;
                Caption = 'Production Order List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Prod. Order - List";
            }
            action(ProdOrderShortageList)
            {
                ApplicationArea = Basic;
                Caption = 'Production Order - Shortage List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    ManuPrintReport.PrintProductionOrder(Rec,2);
                end;
            }
            action("Production Order Statistics")
            {
                ApplicationArea = Basic;
                Caption = 'Production Order Statistics';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Production Order Statistics";
            }
        }
    }

    var
        ManuPrintReport: Codeunit "Manu. Print Report";
}

