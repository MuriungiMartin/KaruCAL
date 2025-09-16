#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5656 "Insurance Registers"
{
    ApplicationArea = Basic;
    Caption = 'Insurance Registers';
    Editable = false;
    PageType = List;
    SourceTable = "Insurance Register";
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
                    ToolTip = 'Specifies the number of the insurance register.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date when the entries in the register were posted.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the ID of the user who created the insurance register by posting the entries.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the source code for the entries in the insurance register.';
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the insurance journal batch name that the entries were posted from.';
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the first insurance entry number in the register.';
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the last insurance entry number in the register.';
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
                action("Ins&urance Coverage Ledger")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Ins&urance Coverage Ledger';
                    Image = InsuranceLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Ins. Reg.-Show Coverage Ledger";
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View insurance ledger entries that were created when you post to an insurance account from a purchase invoice, credit memo or journal line.';
                }
            }
        }
    }
}

