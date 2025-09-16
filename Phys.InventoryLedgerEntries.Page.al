#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 390 "Phys. Inventory Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Phys. Inventory Ledger Entries';
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Phys. Inventory Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which you posted the Physical Inventory Journal that created this ledger entry.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of transaction that was posted from the Physical Inventory Journal that created the ledger entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number on the physical inventory ledger entry.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item in the ledger entry.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the items.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item in the ledger entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the ledger entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the ledger entry is linked to.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location for the item in the ledger entry.';
                    Visible = true;
                }
                field("Qty. (Calculated)";"Qty. (Calculated)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity on hand, as calculated by the program, of the item in the ledger entry.';
                }
                field("Qty. (Phys. Inventory)";"Qty. (Phys. Inventory)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the actual quantity on hand, as determined by taking a physical inventory, of the item in the ledger entry.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the difference between the quantities in the Quantity (Calculated) field and the Quantity (Physical Inventory) field for ledger entry.';
                }
                field("Unit Amount";"Unit Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount for one unit of the item in the ledger entry.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total amount for the items in the ledger entry.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the direct unit cost of the item in the ledger entry.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is associated with the ledger entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source code associated with the ledger entry.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code in the ledger entry.';
                    Visible = false;
                }
                field("Last Item Ledger Entry No.";"Last Item Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the last item ledger entry that provided the basis for the physical inventory ledger entry.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number assigned to the ledger entry.';
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
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
}

