#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5731 "Product Groups"
{
    ApplicationArea = Basic;
    Caption = 'Product Groups';
    DataCaptionFields = "Item Category Code";
    PageType = List;
    SourceTable = "Product Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item Category Code";"Item Category Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item category code to which this product group code belongs.';
                    Visible = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the product group that applies to the item.';
                }
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warehouse class code for the product group.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the product group.';
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

