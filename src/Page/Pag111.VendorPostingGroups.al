#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 111 "Vendor Posting Groups"
{
    ApplicationArea = Basic;
    Caption = 'Vendor Posting Groups';
    PageType = List;
    SourceTable = "Vendor Posting Group";
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
                    ToolTip = 'Specifies a vendor posting group code.';
                }
                field("Payables Account";"Payables Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post payables due to vendors in this posting group.';
                }
                field("Service Charge Acc.";"Service Charge Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post service charges due to vendors in this posting group.';
                }
                field("Payment Disc. Debit Acc.";"Payment Disc. Debit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post reductions in payment discounts received from vendors in this posting group.';
                }
                field("Payment Disc. Credit Acc.";"Payment Disc. Credit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post payment discounts received from vendors in this posting group.';
                }
                field("Invoice Rounding Account";"Invoice Rounding Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies to which account to post amounts resulting from invoice rounding when you post transactions involving vendors.';
                    Visible = true;
                }
                field("Debit Curr. Appln. Rndg. Acc.";"Debit Curr. Appln. Rndg. Acc.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general ledger account number to post rounding differences that can occur when you apply entries in different currencies to one another.';
                }
                field("Credit Curr. Appln. Rndg. Acc.";"Credit Curr. Appln. Rndg. Acc.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general ledger account number to post rounding differences that can occur when you apply entries in different currencies to one another.';
                }
                field("Debit Rounding Account";"Debit Rounding Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post rounding differences from remaining amount.';
                }
                field("Credit Rounding Account";"Credit Rounding Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post rounding differences from remaining amount.';
                }
                field("Payment Tolerance Debit Acc.";"Payment Tolerance Debit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post purchase tolerance amounts when you post payments for purchases with this particular combination of business posting group and product posting group.';
                }
                field("Payment Tolerance Credit Acc.";"Payment Tolerance Credit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post purchase tolerance amounts when you post payments for purchases with this particular combination of business posting group and product posting group.';
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

