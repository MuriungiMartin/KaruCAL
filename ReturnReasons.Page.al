#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6635 "Return Reasons"
{
    ApplicationArea = Basic;
    Caption = 'Return Reasons';
    PageType = List;
    SourceTable = "Return Reason";
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
                    ToolTip = 'Specifies the code of the record.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the return reason.';
                }
                field("Default Location Code";"Default Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location where items that are returned for the reason in question are always placed.';
                }
                field("Inventory Value Zero";"Inventory Value Zero")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that items that are returned for the reason in question do not increase the inventory value.';
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

