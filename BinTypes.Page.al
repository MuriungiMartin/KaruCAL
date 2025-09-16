#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7306 "Bin Types"
{
    ApplicationArea = Basic;
    Caption = 'Bin Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Bin Type";
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
                    ToolTip = 'Specifies a unique code for the bin type.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the bin type.';
                }
                field(Receive;Receive)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies to use the bin for items that have just arrived at the warehouse.';
                }
                field(Ship;Ship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies to use the bin for items that are about to be shipped out of the warehouse.';
                }
                field("Put Away";"Put Away")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies to use the bin for items that are being put away, such as receipts and internal put-always.';
                }
                field(Pick;Pick)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies to use the bin for items that can be picked for shipment, internal picks, and production.';
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

