#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 116 "G/L Registers"
{
    ApplicationArea = Basic;
    Caption = 'G/L Registers';
    Editable = false;
    PageType = List;
    SourceTable = "G/L Register";
    SourceTableView = sorting("No.")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the general ledger register.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date when the entries in the register were posted.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the user who posted the entries and created the general ledger register.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the source code for the entries in the register.';
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the general journal that the entries were posted from.';
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the register has been reversed (undone) from the Reverse Entries window.';
                    Visible = false;
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the first general ledger entry number in the register.';
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last general ledger entry number in the register.';
                }
                field("From VAT Entry No.";"From VAT Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the first tax entry number in the register.';
                }
                field("To VAT Entry No.";"To VAT Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last entry number in the register.';
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
            group("&Register")
            {
                Caption = '&Register';
                Image = Register;
                action("General Ledger")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'General Ledger';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "G/L Reg.-Gen. Ledger";
                    ToolTip = 'View the general ledger entries that resulted in the current register entry.';
                }
                action("Customer &Ledger")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer &Ledger';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "G/L Reg.-Cust.Ledger";
                    ToolTip = 'View the customer ledger entries that resulted in the current register entry.';
                }
                action("Ven&dor Ledger")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ven&dor Ledger';
                    Image = VendorLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "G/L Reg.-Vend.Ledger";
                    ToolTip = 'View the vendor ledger entries that resulted in the current register entry.';
                }
                action("Bank Account Ledger")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Account Ledger';
                    Image = BankAccountLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "G/L Reg.-Bank Account Ledger";
                    ToolTip = 'View the bank account ledger entries that resulted in the current register entry.';
                }
                action("Fixed &Asset Ledger")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Fixed &Asset Ledger';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "G/L Reg.-FALedger";
                    ToolTip = 'View registers that involve fixed assets.';
                }
                action("Maintenance Ledger")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Maintenance Ledger';
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "G/L Reg.-Maint.Ledger";
                    ToolTip = 'View the maintenance ledger entries for the selected fixed asset.';
                }
                action("Tax Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Entries';
                    Image = VATLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "G/L Reg.-VAT Entries";
                    ToolTip = 'View the tax entries that are associated with the current register entry.';
                }
                action("Item Ledger Relation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Ledger Relation';
                    Image = ItemLedger;
                    RunObject = Page "G/L - Item Ledger Relation";
                    RunPageLink = "G/L Register No."=field("No.");
                    RunPageView = sorting("G/L Register No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ReverseRegister)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Reverse Register';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Undo entries that were incorrectly posted from a general journal line or from a previous reversal.';

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        TestField("No.");
                        ReversalEntry.ReverseRegister("No.");
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Detail Trial Balance")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Detail Trial Balance";
                ToolTip = 'Print or save a detail trial balance for the general ledger accounts that you specify.';
            }
            action("Trial Balance")
            {
                ApplicationArea = Suite;
                Caption = 'Trial Balance';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance";
                ToolTip = 'Print or save the chart of accounts that have balances and net changes.';
            }
            action("Trial Balance by Period")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance by Period';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Trial Balance by Period";
                ToolTip = 'Print or save the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.';
            }
            action("G/L Register")
            {
                ApplicationArea = Suite;
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "G/L Register";
                ToolTip = 'View posted G/L entries.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FindSet then;
    end;
}

