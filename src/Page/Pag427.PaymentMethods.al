#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 427 "Payment Methods"
{
    ApplicationArea = Basic;
    Caption = 'Payment Methods';
    PageType = List;
    SourceTable = "Payment Method";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code to identify this payment method.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a text that describes the payment method.';
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the balancing account type that will be used with this payment method.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the balancing account that will be used in connection with this payment method.';
                }
                field("Direct Debit";"Direct Debit")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the payment method is used for direct debit collection.';
                }
                field("Direct Debit Pmt. Terms Code";"Direct Debit Pmt. Terms Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the payment terms that will be used when the payment method is used for direct debit collection.';
                }
                field("Pmt. Export Line Definition";"Pmt. Export Line Definition")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the data exchange definition in the Data Exchange Framework that is used to export payments.';
                }
                field("Bank Data Conversion Pmt. Type";"Bank Data Conversion Pmt. Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment type as required by the bank data conversion service when you export payments with the selected payment method.';
                }
                field("SAT Payment Method Code";"SAT Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment method for paying to the Mexican tax authorities (SAT)';
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

