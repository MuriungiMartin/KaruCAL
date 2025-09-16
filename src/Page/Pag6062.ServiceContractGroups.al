#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6062 "Service Contract Groups"
{
    ApplicationArea = Basic;
    Caption = 'Service Contract Groups';
    PageType = List;
    SourceTable = "Contract Group";
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
                    ToolTip = 'Specifies a code for the contract group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the contract group.';
                }
                field("Disc. on Contr. Orders Only";"Disc. on Contr. Orders Only")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that contract/service discounts only apply to service lines linked to service orders created for the service contracts in the contract group.';
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

