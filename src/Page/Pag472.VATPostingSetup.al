#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 472 "VAT Posting Setup"
{
    ApplicationArea = Basic;
    Caption = 'Tax Posting Setup';
    CardPageID = "VAT Posting Setup Card";
    DataCaptionFields = "VAT Bus. Posting Group","VAT Prod. Posting Group";
    Editable = false;
    PageType = List;
    SourceTable = "VAT Posting Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a Tax business posting group code.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a Tax product posting group code.';
                }
                field("VAT Identifier";"VAT Identifier")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code to group various tax posting setups with similar attributes, for example tax percentage.';
                }
                field("VAT %";"VAT %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the relevant Tax rate for the particular combination of Tax business posting group and Tax product posting group. Do not enter the percent sign, only the number. For example, if the Tax rate is 25 %, enter 25 in this field.';
                }
                field("VAT Calculation Type";"VAT Calculation Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how tax will be calculated for purchases or sales of items with this particular combination of Tax business posting group and Tax product posting group.';
                }
                field("Unrealized VAT Type";"Unrealized VAT Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how to handle unrealized tax, which is tax that is calculated but not due until the invoice is paid.';
                    Visible = false;
                }
                field("Adjust for Payment Discount";"Adjust for Payment Discount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to recalculate tax amounts when you post payments that trigger payment discounts.';
                    Visible = false;
                }
                field("Sales VAT Account";"Sales VAT Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post sales tax for the particular combination of Tax business posting group and Tax product posting group.';
                    Visible = false;
                }
                field("Sales VAT Unreal. Account";"Sales VAT Unreal. Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post unrealized sales tax to.';
                    Visible = false;
                }
                field("Purchase VAT Account";"Purchase VAT Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post purchase tax for the particular combination of business group and product group.';
                    Visible = false;
                }
                field("Purch. VAT Unreal. Account";"Purch. VAT Unreal. Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post unrealized purchase tax to.';
                    Visible = false;
                }
                field("Reverse Chrg. VAT Acc.";"Reverse Chrg. VAT Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which you want to post reverse charge tax (purchase tax) for this combination of tax business posting group and tax product posting group, if you have selected the Reverse Charge Tax option in the VAT Calculation Type field.';
                    Visible = false;
                }
                field("Reverse Chrg. VAT Unreal. Acc.";"Reverse Chrg. VAT Unreal. Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post amounts for unrealized reverse charge tax to.';
                    Visible = false;
                }
                field("VAT Clause Code";"VAT Clause Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax Clause Code that is associated with the Tax Posting Setup.';
                }
                field("EU Service";"EU Service")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if this combination of Tax business posting group and Tax product posting group are to be reported as services in the periodic tax reports.';
                }
                field("Certificate of Supply Required";"Certificate of Supply Required")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Tax Category";"Tax Category")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax category in connection with electronic document sending. For example, when you send sales documents through the PEPPOL service, the value in this field is used to populate the TaxApplied element in the Supplier group. The number is based on the UNCL5305 standard.';
                }
            }
            group(Control52)
            {
                field("VAT Bus. Posting Group2";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a tax business posting group code.';
                }
                field("VAT Prod. Posting Group2";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a Tax product posting group code.';
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
        area(processing)
        {
            action(Copy)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Copy';
                Ellipsis = true;
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Copy a record with selected fields or all fields from the Tax posting setup to a new record. Before you start to copy you have to create the new record.';

                trigger OnAction()
                begin
                    CurrPage.SaveRecord;
                    CopyVATPostingSetup.SetVATSetup(Rec);
                    CopyVATPostingSetup.RunModal;
                    Clear(CopyVATPostingSetup);
                end;
            }
        }
    }

    var
        CopyVATPostingSetup: Report "Copy - VAT Posting Setup";
}

