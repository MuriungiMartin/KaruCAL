#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 745 "VAT Report Error Log"
{
    Caption = 'Tax Report Error Log';
    Editable = false;
    PageType = List;
    SourceTable = "VAT Report Error Log";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the error number, such as 1.';
                }
                field("Error Message";"Error Message")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the error message that is the result of validating a tax report.';
                }
            }
        }
    }

    actions
    {
    }
}

