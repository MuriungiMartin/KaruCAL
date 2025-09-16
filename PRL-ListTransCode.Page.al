#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68061 "PRL-List TransCode"
{
    PageType = List;
    SourceTable = UnknownTable61082;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Enabled = true;
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("IsCoop/LnRep";"IsCoop/LnRep")
                {
                    ApplicationArea = Basic;
                }
                field("coop parameters";"coop parameters")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Name";"Transaction Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Balance Type";"Balance Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field(Frequency;Frequency)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Is Cash";"Is Cash")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field(Taxable;Taxable)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Is Formula";"Is Formula")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field(Subledger;Subledger)
                {
                    ApplicationArea = Basic;
                }
                field(Formula;Formula)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Amount Preference";"Amount Preference")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Special Transactions";"Special Transactions")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Deduct Premium";"Deduct Premium")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Interest Rate";"Interest Rate")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("GL Account";"GL Account")
                {
                    ApplicationArea = Basic;
                }
                field("Repayment Method";"Repayment Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Fringe Benefit";"Fringe Benefit")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(View)
            {
                Caption = 'View';
                action("SetUp Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'SetUp Card';
                    RunObject = Page "PRL-Transaction Code";
                    RunPageLink = "Transaction Code"=field("Transaction Code");
                    RunPageView = sorting("Transaction Code");
                }
            }
        }
    }
}

