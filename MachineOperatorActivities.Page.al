#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9047 "Machine Operator Activities"
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
                field("Released Prod. Orders - All";"Released Prod. Orders - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Rlsd. Prod. Orders Until Today";"Rlsd. Prod. Orders Until Today")
                {
                    ApplicationArea = Basic;
                    Caption = 'Released Prod. Orders Until Today';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Consumption Journal")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Consumption Journal';
                        Image = ConsumptionJournal;
                        RunObject = Page "Consumption Journal";
                    }
                    action("Output Journal")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Output Journal';
                        Image = OutputJournal;
                        RunObject = Page "Output Journal";
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
                    action("Register Absence - Machine Center")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Register Absence - Machine Center';
                        Image = CalendarMachine;
                        RunObject = Report "Reg. Abs. (from Machine Ctr.)";
                    }
                    action("Register Absence - Work Center")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Register Absence - Work Center';
                        Image = CalendarWorkcenter;
                        RunObject = Report "Reg. Abs. (from Work Center)";
                    }
                    action("Prod. Order - Job Card")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prod. Order - Job Card';
                        Image = "Report";
                        RunObject = Report "Prod. Order - Job Card";
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

        SetFilter("Date Filter",'<=%1',WorkDate)
    end;
}

