#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9038 "Production Planner Activities"
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
                    action("Change Production Order Status")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Change Production Order Status';
                        Image = ChangeStatus;
                        RunObject = Page "Change Production Order Status";
                    }
                    action("New Production Order")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Production Order';
                        RunObject = Page "Planned Production Order";
                        RunPageMode = Create;
                    }
                    action(Navigate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Navigate';
                        Image = Navigate;
                        RunObject = Page Navigate;
                    }
                }
            }
            cuegroup("Planning - Operations")
            {
                Caption = 'Planning - Operations';
                field("Purchase Orders";"Purchase Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Purchase Orders';
                    DrillDown = true;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of purchase orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
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
                    action("Edit Planning Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Planning Worksheet';
                        RunObject = Page "Planning Worksheet";
                    }
                    action("Edit Subcontracting Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Subcontracting Worksheet';
                        RunObject = Page "Subcontracting Worksheet";
                    }
                }
            }
            cuegroup(Design)
            {
                Caption = 'Design';
                field("Prod. BOMs under Development";"Prod. BOMs under Development")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Production BOM List";
                    ToolTip = 'Specifies the number of production BOMs that are under development that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Routings under Development";"Routings under Development")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Routing List";
                    ToolTip = 'Specifies the routings under development that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Item")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Item';
                        Image = NewItem;
                        RunObject = Page "Item Card";
                        RunPageMode = Create;
                    }
                    action("New Production BOM")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Production BOM';
                        RunObject = Page "Production BOM";
                        RunPageMode = Create;
                    }
                    action("New Routing")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Routing';
                        RunObject = Page Routing;
                        RunPageMode = Create;
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

        SetRange("User ID Filter",UserId);
    end;
}

