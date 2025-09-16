#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7704 Functions
{
    ApplicationArea = Basic;
    Caption = 'Functions';
    Editable = false;
    PageType = List;
    SourceTable = "Miniform Function Group";
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
                    ToolTip = 'Specifies the code that represents the function used on the handheld device.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a short description of what the function is or how it functions.';
                }
                field(KeyDef;KeyDef)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the key that will trigger the function.';
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

