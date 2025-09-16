#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5826 "Inventory Posting Setup"
{
    ApplicationArea = Basic;
    Caption = 'Inventory Posting Setup';
    PageType = Worksheet;
    SourceTable = "Inventory Posting Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code for setting up posting groups of inventory to general ledger.';
                }
                field("Invt. Posting Group Code";"Invt. Posting Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the inventory posting group, in the combination of location and inventory posting group, that you are setting up.';
                }
                field("Inventory Account";"Inventory Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the G/L account that item transactions with this combination of location and inventory posting group are posted to.';
                }
                field("Inventory Account (Interim)";"Inventory Account (Interim)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the general ledger account to which to post transactions with the expected cost for items in this combination.';
                }
                field("WIP Account";"WIP Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post transactions for items in WIP inventory in this combination.';
                }
                field("Material Variance Account";"Material Variance Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the general ledger account to which to post material variance transactions for items in this combination.';
                }
                field("Capacity Variance Account";"Capacity Variance Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the general ledger account to which to post capacity variance transactions for items in this combination.';
                }
                field("Subcontracted Variance Account";"Subcontracted Variance Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post subcontracted variance transactions for items in this combination.';
                }
                field("Cap. Overhead Variance Account";"Cap. Overhead Variance Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post capacity overhead variance transactions for items in this combination.';
                }
                field("Mfg. Overhead Variance Account";"Mfg. Overhead Variance Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post manufacturing overhead variance transactions for items in this combination.';
                }
            }
            group(Control23)
            {
                field("Location Code2";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the location code for setting up posting groups of inventory to general ledger.';
                }
                field("Invt. Posting Group Code2";"Invt. Posting Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for the inventory posting group, in the combination of location and inventory posting group, that you are setting up.';
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

