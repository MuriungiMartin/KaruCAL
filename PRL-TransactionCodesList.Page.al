#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68889 "PRL-Transaction Codes List"
{
    CardPageID = "PRL-Transaction Code";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61082;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Name";"Transaction Name")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(Frequency;Frequency)
                {
                    ApplicationArea = Basic;
                }
                field("Balance Type";"Balance Type")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Preference";"Amount Preference")
                {
                    ApplicationArea = Basic;
                }
                field("Is Cash";"Is Cash")
                {
                    ApplicationArea = Basic;
                }
                field("Is Formula";"Is Formula")
                {
                    ApplicationArea = Basic;
                }
                field(Taxable;Taxable)
                {
                    ApplicationArea = Basic;
                }
                field(Formula;Formula)
                {
                    ApplicationArea = Basic;
                }
                field("Recovery Priority";"Recovery Priority")
                {
                    ApplicationArea = Basic;
                }
                field(formulae;'E.g. ([0.05]+[0.20]*[24])/2268....')
                {
                    ApplicationArea = Basic;
                    Caption = 'Formula example';
                }
                field("Include Employer Deduction";"Include Employer Deduction")
                {
                    ApplicationArea = Basic;
                }
                field("Employer Deduction";"Employer Deduction")
                {
                    ApplicationArea = Basic;
                }
                field("Is Formula for employer";"Is Formula for employer")
                {
                    ApplicationArea = Basic;
                }
                field(EMPfORMULA;'E.g. ([0.05]+[0.20]*[24])/2268....')
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer Formula Example';
                }
                field("GL Account";"GL Account")
                {
                    ApplicationArea = Basic;
                }
                field("GL Employee Account";"GL Employee Account")
                {
                    ApplicationArea = Basic;
                }
                field("Special Transactions";"Special Transactions")
                {
                    ApplicationArea = Basic;
                }
                field("Deduct Premium";"Deduct Premium")
                {
                    ApplicationArea = Basic;
                }
                field("Fringe Benefit";"Fringe Benefit")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Rate";"Interest Rate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interest Rate (%)';
                }
                field("Repayment Method";"Repayment Method")
                {
                    ApplicationArea = Basic;
                }
                field("IsCoop/LnRep";"IsCoop/LnRep")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cooperate Parameters';
                }
                field("coop parameters";"coop parameters")
                {
                    ApplicationArea = Basic;
                }
                field(Subledger;Subledger)
                {
                    ApplicationArea = Basic;
                }
                field(CustomerPostingGroup;CustomerPostingGroup)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

