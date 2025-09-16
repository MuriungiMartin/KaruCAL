#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 204 "Resource Prices"
{
    ApplicationArea = Basic;
    Caption = 'Resource Prices';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "Resource Price";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code.';
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the currency code of the alternate sales price on this line.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the alternate sales price.';
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

