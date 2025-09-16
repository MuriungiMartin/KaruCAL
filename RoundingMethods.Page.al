#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65 "Rounding Methods"
{
    ApplicationArea = Basic;
    Caption = 'Rounding Methods';
    PageType = List;
    SourceTable = "Rounding Method";
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
                    ToolTip = 'Specifies a code for the rounding method for item prices.';
                }
                field("Minimum Amount";"Minimum Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the minimum amount to round.';
                }
                field("Amount Added Before";"Amount Added Before")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an amount to add before it is rounded.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how to round.';
                }
                field(Precision;Precision)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the size of the interval that you want between rounded amounts.';
                }
                field("Amount Added After";"Amount Added After")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an amount to add, after the amount has been rounded.';
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

