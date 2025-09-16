#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1005 "Job Task Dimensions"
{
    Caption = 'Job Task Dimensions';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Job Task Dimension";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Dimension Code";"Dimension Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the dimension that the dimension value filter will be linked to. To select a dimension codes, which are set up in the Dimensions window, click the drop-down arrow in the field.';
                }
                field("Dimension Value Code";"Dimension Value Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the dimension value that the dimension value filter will be linked to. To select a value code, which are set up in the Dimensions window, choose the drop-down arrow in the field.';
                }
            }
        }
    }

    actions
    {
    }
}

