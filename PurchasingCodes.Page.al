#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5727 "Purchasing Codes"
{
    ApplicationArea = Basic;
    Caption = 'Purchasing Codes';
    PageType = List;
    SourceTable = Purchasing;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for a purchasing activity.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the purchasing activity specified by the code.';
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the purchasing activity includes arranging for a drop shipment.';
                }
                field("Special Order";"Special Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this purchase activity includes arranging for a special order.';
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

