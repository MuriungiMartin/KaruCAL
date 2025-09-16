#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7300 Zones
{
    Caption = 'Zones';
    DataCaptionFields = "Location Code";
    PageType = List;
    SourceTable = Zone;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code of the zone.';
                    Visible = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the zone.';
                }
                field("Bin Type Code";"Bin Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin type code for the zone. The bin type determines the inbound and outbound flow of items.';
                }
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warehouse class code of the zone. You can store items with the same warehouse class code in this zone.';
                }
                field("Special Equipment Code";"Special Equipment Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the special equipment to be used when you work in this zone.';
                }
                field("Zone Ranking";"Zone Ranking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Zone Ranking';
                    ToolTip = 'Specifies the ranking of the zone, which is copied to all bins created within the zone.';
                }
                field("Cross-Dock Bin Zone";"Cross-Dock Bin Zone")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if this is a cross-dock zone.';
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
            group("&Zone")
            {
                Caption = '&Zone';
                Image = Zones;
                action("&Bins")
                {
                    ApplicationArea = Basic;
                    Caption = '&Bins';
                    Image = Bins;
                    RunObject = Page Bins;
                    RunPageLink = "Location Code"=field("Location Code"),
                                  "Zone Code"=field(Code);
                }
            }
        }
    }
}

