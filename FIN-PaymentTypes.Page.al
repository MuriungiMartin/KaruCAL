#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68182 "FIN-Payment Types"
{
    ApplicationArea = Basic;
    PageType = Worksheet;
    SourceTable = UnknownTable61129;
    SourceTableView = where(Type=const(Payment));
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("VAT Chargeable";"VAT Chargeable")
                {
                    ApplicationArea = Basic;
                }
                field("Withholding Tax Chargeable";"Withholding Tax Chargeable")
                {
                    ApplicationArea = Basic;
                }
                field("PAYE Tax Chargeable";"PAYE Tax Chargeable")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Code";"VAT Code")
                {
                    ApplicationArea = Basic;
                }
                field("Withholding Tax Code";"Withholding Tax Code")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Withheld Code";"VAT Withheld Code")
                {
                    ApplicationArea = Basic;
                }
                field("Pays Levy";"Pays Levy")
                {
                    ApplicationArea = Basic;
                }
                field("Levy Code";"Levy Code")
                {
                    ApplicationArea = Basic;
                }
                field("PAYE Tax Code";"PAYE Tax Code")
                {
                    ApplicationArea = Basic;
                }
                field("Use PAYE Table";"Use PAYE Table")
                {
                    ApplicationArea = Basic;
                }
                field("Default Grouping";"Default Grouping")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account";"G/L Account")
                {
                    ApplicationArea = Basic;
                }
                field("Pending Voucher";"Pending Voucher")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account";"Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field("Transation Remarks";"Transation Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Reference";"Payment Reference")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Payment On Account";"Customer Payment On Account")
                {
                    ApplicationArea = Basic;
                }
                field("Direct Expense";"Direct Expense")
                {
                    ApplicationArea = Basic;
                }
                field("Calculate Retention";"Calculate Retention")
                {
                    ApplicationArea = Basic;
                }
                field("Retention Code";"Retention Code")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Retention Fee Code";"Retention Fee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Retention Fee Applicable";"Retention Fee Applicable")
                {
                    ApplicationArea = Basic;
                }
                field("Subsistence?";"Subsistence?")
                {
                    ApplicationArea = Basic;
                }
                field("Council Claim?";"Council Claim?")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone Allowance?";"Telephone Allowance?")
                {
                    ApplicationArea = Basic;
                }
                field("WHT 2 Code";"WHT 2 Code")
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

