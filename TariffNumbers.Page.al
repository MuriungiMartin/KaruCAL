#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 310 "Tariff Numbers"
{
    ApplicationArea = Basic;
    Caption = 'Tariff Numbers';
    PageType = List;
    SourceTable = "Tariff Number";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tariff number for the item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item.';
                }
                field("Supplementary Units";"Supplementary Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the customs and tax authorities require information about quantity and unit of measure for this item.';
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

