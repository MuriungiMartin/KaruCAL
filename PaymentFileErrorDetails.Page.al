#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1229 "Payment File Error Details"
{
    Caption = 'Payment File Error Details';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Payment Jnl. Export Error Text";

    layout
    {
        area(content)
        {
            field("Error Text";"Error Text")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the error that is shown in the Payment Journal window in case payment lines cannot be exported.';
            }
            field("Additional Information";"Additional Information")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies more information that may help you resolve the error.';
            }
            field("Support URL";"Support URL")
            {
                ApplicationArea = Basic,Suite;
                ExtendedDatatype = URL;
                ToolTip = 'Specifies a web page containing information that may help you resolve the error.';
            }
        }
    }

    actions
    {
    }
}

