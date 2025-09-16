#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5627 "FA Registers"
{
    ApplicationArea = Basic;
    Caption = 'FA Registers';
    Editable = false;
    PageType = List;
    SourceTable = "FA Register";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the FA register.';
                }
                field("Journal Type";"Journal Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the type of journal (G/L or Fixed Asset) that the entries were posted from.';
                }
                field("G/L Register No.";"G/L Register No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the G/L register that was created when the entries were posted.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date when the entries in the register were posted.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the ID of the user who created the FA register by posting the entries.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the source code for the entries in the FA register.';
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the general journal batch or FA journal batch that the entries were posted from.';
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the first FA entry number in the register.';
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the last FA entry number in the register.';
                }
                field("From Maintenance Entry No.";"From Maintenance Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the first maintenance entry number in the register.';
                }
                field("To Maintenance Entry No.";"To Maintenance Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the last maintenance entry number in the register.';
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
                action("F&A Ledger")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'F&A Ledger';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "FA Reg.-FALedger";
                    ToolTip = 'View the fixed asset ledger entries that are created when you post to fixed asset accounts. Fixed asset ledger entries are created by the posting of a purchase order, invoice, credit memo or journal line.';
                }
                action("Maintenance Ledger")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Maintenance Ledger';
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "FA Reg.-MaintLedger";
                    ToolTip = 'View the maintenance ledger entries for the selected fixed asset.';
                }
            }
        }
    }
}

