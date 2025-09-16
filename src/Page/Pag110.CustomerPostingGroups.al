#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 110 "Customer Posting Groups"
{
    ApplicationArea = Basic;
    Caption = 'Customer Posting Groups';
    PageType = List;
    SourceTable = "Customer Posting Group";
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
                    ToolTip = 'Specifies a customer posting group code.';
                }
                field("Receivables Account";"Receivables Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post receivables from customers in this posting group.';
                }
                field("Service Charge Acc.";"Service Charge Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post service charges for customers in this posting group.';
                }
                field("Payment Disc. Debit Acc.";"Payment Disc. Debit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post payment discounts granted to customers in this posting group.';
                }
                field("Payment Disc. Credit Acc.";"Payment Disc. Credit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post reductions in payment discounts granted to customers in this posting group.';
                }
                field("Interest Account";"Interest Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post interest from reminders and finance charge memos for customers in this posting group.';
                }
                field("Additional Fee Account";"Additional Fee Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post additional fees from reminders and finance charge memos for customers in this posting group.';
                }
                field("Add. Fee per Line Account";"Add. Fee per Line Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the account that additional fees are posted to.';
                }
                field("Invoice Rounding Account";"Invoice Rounding Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies to which account to post amounts resulting from invoice rounding when you post transactions involving customers.';
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
                    ToolTip = 'Specifies the general ledger account number to post payment tolerance when you post payments for sales with this particular combination of business group and product group.';
                }
                field("Payment Tolerance Credit Acc.";"Payment Tolerance Credit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post payment tolerance when you post payments for sales with this particular combination of business group and product group.';
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

