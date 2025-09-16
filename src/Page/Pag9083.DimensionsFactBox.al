#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9083 "Dimensions FactBox"
{
    Caption = 'Dimensions';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Default Dimension";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Dimension Code";"Dimension Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the default dimension.';
                }
                field("Dimension Value Code";"Dimension Value Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code to suggest as the default dimension.';
                }
                field("Value Posting";"Value Posting")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how default dimensions and their values must be used.';
                }
            }
        }
    }

    actions
    {
    }
}

