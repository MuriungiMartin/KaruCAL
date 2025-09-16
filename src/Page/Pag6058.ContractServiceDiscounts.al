#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6058 "Contract/Service Discounts"
{
    Caption = 'Contract/Service Discounts';
    DataCaptionFields = "Contract No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Contract/Service Discount";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the contract/service discount.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the resource group, cost, or service item group the discount applies to, based on the value in the Type field.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the discount becomes applicable to the contract or quote.';
                }
                field("Discount %";"Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount percentage.';
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

