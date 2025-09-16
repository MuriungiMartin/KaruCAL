#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9044 "Shop Super. basic Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Manufacturing Cue";

    layout
    {
        area(content)
        {
            cuegroup("Production Orders")
            {
                Caption = 'Production Orders';
                field("Planned Prod. Orders - All";"Planned Prod. Orders - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Planned Production Orders";
                    ToolTip = 'Specifies the number of planned production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Firm Plan. Prod. Orders - All";"Firm Plan. Prod. Orders - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Firm Planned Prod. Orders";
                    ToolTip = 'Specifies the number of firm planned production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Released Prod. Orders - All";"Released Prod. Orders - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Production Order")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Production Order';
                        RunObject = Page "Planned Production Order";
                        RunPageMode = Create;
                    }
                    action("View Production Order - Shortage List")
                    {
                        ApplicationArea = Basic;
                        Caption = 'View Production Order - Shortage List';
                        RunObject = Report "Prod. Order - Shortage List";
                    }
                    action("Change Production Order Status")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Change Production Order Status';
                        Image = ChangeStatus;
                        RunObject = Page "Change Production Order Status";
                    }
                }
            }
            cuegroup(Operations)
            {
                Caption = 'Operations';
                field("Prod. Orders Routings-in Queue";"Prod. Orders Routings-in Queue")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Prod. Order Routing";
                    ToolTip = 'Specifies the number of production order routings in queue that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Prod. Orders Routings-in Prog.";"Prod. Orders Routings-in Prog.")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Prod. Order Routing";
                    ToolTip = 'Specifies the number of inactive service orders that are displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Edit Order Planning")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Order Planning';
                        RunObject = Page "Order Planning";
                    }
                    action("Edit Consumption Journal")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Consumption Journal';
                        RunObject = Page "Consumption Journal";
                    }
                    action("Edit Output Journal")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Output Journal';
                        RunObject = Page "Output Journal";
                    }
                }
            }
            cuegroup("Warehouse Documents")
            {
                Caption = 'Warehouse Documents';
                field("Invt. Picks to Production";"Invt. Picks to Production")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Inventory Picks";
                    ToolTip = 'Specifies the number of inventory picks that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Invt. Put-aways from Prod.";"Invt. Put-aways from Prod.")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Inventory Put-aways";
                    ToolTip = 'Specifies the number of inventory put-always from production that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
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
    end;
}

