#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9050 "Whse Ship & Receive Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Basic Cue";

    layout
    {
        area(content)
        {
            cuegroup("Outbound - Today")
            {
                Caption = 'Outbound - Today';
                field("Rlsd. Sales Orders Until Today";"Rlsd. Sales Orders Until Today")
                {
                    ApplicationArea = Basic;
                    Caption = 'Released Sales Orders Until Today';
                    DrillDown = true;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of released sales orders that are displayed in the Warehouse Basic Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Posted Sales Shipments - Today";"Posted Sales Shipments - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Posted Sales Shipments";
                    ToolTip = 'Specifies the number of posted sales shipments that are displayed in the Basic Warehouse Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
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
                field("Exp. Purch. Orders Until Today";"Exp. Purch. Orders Until Today")
                {
                    ApplicationArea = Basic;
                    Caption = 'Expected Purch. Orders Until Today';
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of expected purchase orders that are displayed in the Basic Warehouse Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Posted Purch. Receipts - Today";"Posted Purch. Receipts - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Posted Purchase Receipts";
                    ToolTip = 'Specifies the number of posted purchase receipts that are displayed in the Warehouse Basic Cue on the Role Center. The documents are filtered by today''s date.';
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
                }
            }
            cuegroup(Internal)
            {
                Caption = 'Internal';
                field("Invt. Picks Until Today";"Invt. Picks Until Today")
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Picks Until Today';
                    DrillDownPageID = "Inventory Picks";
                    ToolTip = 'Specifies the number of inventory picks that are displayed in the Warehouse Basic Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Invt. Put-aways Until Today";"Invt. Put-aways Until Today")
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Put-aways Until Today';
                    DrillDownPageID = "Inventory Put-aways";
                    ToolTip = 'Specifies the number of inventory put-always that are displayed in the Warehouse Basic Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Inventory Pick")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Inventory Pick';
                        RunObject = Page "Inventory Pick";
                        RunPageMode = Create;
                    }
                    action("New Inventory Put-away")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Inventory Put-away';
                        RunObject = Page "Inventory Put-away";
                        RunPageMode = Create;
                    }
                    action("Edit Item Reclassification Journal")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Item Reclassification Journal';
                        Image = OpenWorksheet;
                        RunObject = Page "Item Reclass. Journal";
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

        LocationCode := WhseWMSCue.GetEmployeeLocation(UserId);
        SetFilter("Location Filter",LocationCode);
    end;

    var
        WhseWMSCue: Record "Warehouse WMS Cue";
        LocationCode: Text[1024];
}

