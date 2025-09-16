#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6502 "Item Tracking Codes"
{
    ApplicationArea = Basic;
    Caption = 'Item Tracking Codes';
    CardPageID = "Item Tracking Code Card";
    PageType = List;
    SourceTable = "Item Tracking Code";
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
                    ToolTip = 'Specifies the code of the record.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item tracking code.';
                }
                field("SN Specific Tracking";"SN Specific Tracking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that when handling an outbound unit of the item in question, you must always specify which existing serial number to handle.';
                    Visible = false;
                }
                field("Lot Specific Tracking";"Lot Specific Tracking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that when handling an outbound unit, always specify which existing lot number to handle.';
                    Visible = false;
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

