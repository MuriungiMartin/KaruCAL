#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9053 "WMS Ship & Receive Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Warehouse WMS Cue";

    layout
    {
        area(content)
        {
            cuegroup("Outbound - Today")
            {
                Caption = 'Outbound - Today';
                field("Released Sales Orders - Today";"Released Sales Orders - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of released sales orders that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Shipments - Today";"Shipments - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Shipment List";
                    ToolTip = 'Specifies the number of shipments that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Picked Shipments - Today";"Picked Shipments - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Shipment List";
                    ToolTip = 'Specifies the number of picked shipments that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Posted Shipments - Today";"Posted Shipments - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Posted Whse. Shipment List";
                    ToolTip = 'Specifies the number of posted shipments that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Whse. Shipment")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Whse. Shipment';
                        RunObject = Page "Warehouse Shipment";
                        RunPageMode = Create;
                    }
                    action("New Transfer Order")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Transfer Order';
                        RunObject = Page "Transfer Order";
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup("Inbound - Today")
            {
                Caption = 'Inbound - Today';
                field("Expected Purchase Orders";"Expected Purchase Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of expected purchase orders that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field(Arrivals;Arrivals)
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Receipts";
                    ToolTip = 'Specifies the number of arrivals that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Posted Receipts - Today";"Posted Receipts - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Posted Whse. Receipt List";
                    ToolTip = 'Specifies the number of posted receipts that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Purchase Order")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Purchase Order';
                        RunObject = Page "Purchase Order";
                        RunPageMode = Create;
                    }
                    action("New Whse. Receipt")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Whse. Receipt';
                        RunObject = Page "Warehouse Receipt";
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup(Internal)
            {
                Caption = 'Internal';
                field("Picks - All";"Picks - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Picks";
                    ToolTip = 'Specifies the number of picks that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Put-aways - All";"Put-aways - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Put-aways";
                    ToolTip = 'Specifies the number of put-always that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Movements - All";"Movements - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Movements";
                    ToolTip = 'Specifies the number of movements that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Registered Picks - Today";"Registered Picks - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Registered Whse. Picks";
                    ToolTip = 'Specifies the number of registered picks that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Edit Put-away Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Put-away Worksheet';
                        RunObject = Page "Put-away Worksheet";
                    }
                    action("Edit Pick Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Pick Worksheet';
                        RunObject = Page "Pick Worksheet";
                    }
                    action("Edit Movement Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Movement Worksheet';
                        RunObject = Page "Movement Worksheet";
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetRange("Date Filter",0D,WorkDate);
        SetRange("Date Filter2",WorkDate,WorkDate);

        LocationCode := GetEmployeeLocation(UserId);
        SetFilter("Location Filter",LocationCode);
    end;

    var
        LocationCode: Text[1024];
}

