#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6 "Finance Charge Terms"
{
    ApplicationArea = Basic;
    Caption = 'Finance Charge Terms';
    CardPageID = "Finance Charge Terms Card";
    PageType = List;
    SourceTable = "Finance Charge Terms";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the finance charge terms.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the finance charge terms.';
                }
                field("Interest Calculation";"Interest Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which entries should be used in interest calculation on finance charge memos.';
                }
                field("Interest Calculation Method";"Interest Calculation Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the interest calculation method for this set of finance charge terms.';
                }
                field("Interest Rate";"Interest Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage to use to calculate interest for this finance charge code.';
                }
                field("Interest Period (Days)";"Interest Period (Days)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the period that the interest rate applies to. Enter the number of days in the period.';
                }
                field("Minimum Amount (LCY)";"Minimum Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a minimum interest charge in $.';
                }
                field("Additional Fee (LCY)";"Additional Fee (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a fee amount in $.';
                }
                field("Grace Period";"Grace Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the grace period length for this set of finance charge terms.';
                }
                field("Due Date Calculation";"Due Date Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a formula that determines how to calculate the due date of the finance charge memo.';
                }
                field("Line Description";"Line Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description to be used in the Description field on the finance charge memo lines.';
                }
                field("Post Interest";"Post Interest")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether or not interest listed on the finance charge memo should be posted to the general ledger and customer accounts when the finance charge memo is issued.';
                }
                field("Post Additional Fee";"Post Additional Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether or not any additional fee listed on the finance charge memo should be posted to the general ledger and customer accounts when the memo is issued.';
                }
                field("Add. Line Fee in Interest";"Add. Line Fee in Interest")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that any additional fees are included in the interest calculation for the finance charge.';
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
        area(navigation)
        {
            group("Ter&ms")
            {
                Caption = 'Ter&ms';
                Image = BeginningText;
                action(BeginningText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beginning Text';
                    Image = BeginningText;
                    RunObject = Page "Finance Charge Text";
                    RunPageLink = "Fin. Charge Terms Code"=field(Code),
                                  Position=const(Beginning);
                    ToolTip = 'Define a beginning text for each finance charge term. The text will then be printed on the finance charge memo.';
                }
                action(EndingText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ending Text';
                    Image = EndingText;
                    RunObject = Page "Finance Charge Text";
                    RunPageLink = "Fin. Charge Terms Code"=field(Code),
                                  Position=const(Ending);
                    ToolTip = 'Define an ending text for each finance charge term. The text will then be printed on the finance charge memo.';
                }
                separator(Action35)
                {
                }
                action("C&urrencies")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&urrencies';
                    Image = Currency;
                    RunObject = Page "Currencies for Fin. Chrg Terms";
                    RunPageLink = "Fin. Charge Terms Code"=field(Code);
                    ToolTip = 'Set up finance charge terms in foreign currencies. For example, you can use this table to set up finance charge terms with an additional fee of FRF 100.';
                }
            }
        }
    }
}

