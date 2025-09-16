#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 27002 "SAT Payment Method Codes"
{
    Caption = 'SAT Payment Method Codes';
    PageType = List;
    SourceTable = UnknownTable27001;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the SAT payment method.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description the SAT payment method.';
                }
            }
        }
    }

    actions
    {
    }
}

