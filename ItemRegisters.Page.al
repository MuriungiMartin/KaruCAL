#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 117 "Item Registers"
{
    ApplicationArea = Basic;
    Caption = 'Item Registers';
    Editable = false;
    PageType = List;
    SourceTable = "Item Register";
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
                    ToolTip = 'Specifies the number of the item register.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date when the entries in the register were posted.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the user who posted the entries and created the item register.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the source code for the entries in the register.';
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the item journal that the entries were posted from.';
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the first item entry number in the register.';
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last item entry number in the register.';
                }
                field("From Phys. Inventory Entry No.";"From Phys. Inventory Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the first physical inventory ledger entry number in the register.';
                }
                field("To Phys. Inventory Entry No.";"To Phys. Inventory Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last physical inventory ledger entry number in the register.';
                }
                field("From Value Entry No.";"From Value Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the first value entry number in the register.';
                }
                field("To Value Entry No.";"To Value Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last value entry number in this register.';
                }
                field("From Capacity Entry No.";"From Capacity Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the first capacity entry number in the register.';
                }
                field("To Capacity Entry No.";"To Capacity Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last capacity ledger entry number in this register.';
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
                action("Item Ledger")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Ledger';
                    Image = ItemLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Item Reg.-Show Ledger";
                    ToolTip = 'View the item ledger entries that resulted in the current register entry.';
                }
                action("Phys. Invent&ory Ledger")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Phys. Invent&ory Ledger';
                    Image = PhysicalInventoryLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Item Reg.-Show Inventory Ledg.";
                    ToolTip = 'View the physical inventory ledger entries that resulted in the current register entry.';
                }
                action("Value Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Value Entries';
                    Image = ValueLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Item Reg.- Show Value Entries";
                    ToolTip = 'View the item value entries that resulted in the current register entry.';
                }
                action("&Capacity Ledger")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Capacity Ledger';
                    Image = CapacityLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Item Reg.-Show Cap. Ledger";
                    ToolTip = 'View the capacity ledger entries that resulted in the current register entry.';
                }
            }
        }
    }
}

