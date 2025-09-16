#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9056 "Warehouse Worker Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Worker WMS Cue";

    layout
    {
        area(content)
        {
            cuegroup(Outbound)
            {
                Caption = 'Outbound';
                field("Unassigned Picks";"Unassigned Picks")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Picks";
                    ToolTip = 'Specifies the number of unassigned picks that are displayed in the Warehouse Worker WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("My Picks";"My Picks")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Picks";
                    ToolTip = 'Specifies the number of picks that are displayed in the Warehouse Worker WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Edit Pick Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Pick Worksheet';
                        RunObject = Page "Pick Worksheet";
                    }
                }
            }
            cuegroup(Inbound)
            {
                Caption = 'Inbound';
                field("Unassigned Put-aways";"Unassigned Put-aways")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Put-aways";
                    ToolTip = 'Specifies the number of unassigned put-always that are displayed in the Warehouse Worker WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("My Put-aways";"My Put-aways")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Put-aways";
                    ToolTip = 'Specifies the number of put-always that are displayed in the Warehouse Worker WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Edit Put-away Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Put-away Worksheet';
                        RunObject = Page "Put-away Worksheet";
                    }
                }
            }
            cuegroup(Internal)
            {
                Caption = 'Internal';
                field("Unassigned Movements";"Unassigned Movements")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Movements";
                    ToolTip = 'Specifies the number of unassigned movements that are displayed in the Warehouse Worker WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("My Movements";"My Movements")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Warehouse Movements";
                    ToolTip = 'Specifies the number of movements that are displayed in the Warehouse Worker WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Edit Movement Worksheet")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Movement Worksheet';
                        RunObject = Page "Movement Worksheet";
                    }
                    action("Edit Whse. Item Journal")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Whse. Item Journal';
                        RunObject = Page "Whse. Item Journal";
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

        LocationCode := WhseWMSCue.GetEmployeeLocation(UserId);
        SetFilter("Location Filter",LocationCode);
    end;

    var
        WhseWMSCue: Record "Warehouse WMS Cue";
        LocationCode: Text[1024];
}

