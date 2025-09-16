#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6021 "Resource Service Zones"
{
    ApplicationArea = Basic;
    Caption = 'Resource Service Zones';
    PageType = List;
    SourceTable = "Resource Service Zone";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the title of the resource located in the service zone.';
                }
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service zone where the resource will be located. A resource can be located in more than one zone at a time.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date when the resource is located in the service zone.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the resource''s assignment to the service zone.';
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
    }
}

