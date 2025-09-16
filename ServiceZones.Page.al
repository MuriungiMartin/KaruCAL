#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6020 "Service Zones"
{
    ApplicationArea = Basic;
    Caption = 'Service Zones';
    PageType = List;
    SourceTable = "Service Zone";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the service zone.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service zone.';
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
                action("Resource Service Zones")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Service Zones';
                    Image = Resource;
                    RunObject = Page "Resource Service Zones";
                    RunPageLink = "Service Zone Code"=field(Code);
                    RunPageView = sorting("Service Zone Code");
                }
            }
        }
    }
}

