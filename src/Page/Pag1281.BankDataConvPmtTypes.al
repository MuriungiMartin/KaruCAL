#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1281 "Bank Data Conv. Pmt. Types"
{
    Caption = 'Bank Data Conv. Pmt. Types';
    PageType = List;
    SourceTable = "Bank Data Conversion Pmt. Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the payment type. You set up payment types for a payment method so that the bank data conversion service can identify the payment type when exporting payments. The payment types are displayed in the Bank Data Conv. Pmt. Types window.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the payment type. You set up payment types for a payment method so that the bank data conversion service can identify the payment type when exporting payments. The payment types are displayed in the Bank Data Conv. Pmt. Types window.';
                }
            }
        }
    }

    actions
    {
    }
}

