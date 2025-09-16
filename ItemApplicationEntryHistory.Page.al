#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 523 "Item Application Entry History"
{
    Caption = 'Item Application Entry History';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Item Application Entry History";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Primary Entry No.";"Primary Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a unique identifying number for each item application entry history record.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number of the removed item application entry.';
                }
                field("Item Ledger Entry No.";"Item Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number of the item ledger entry, for which the item application entry was recorded.';
                }
                field("Inbound Item Entry No.";"Inbound Item Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry corresponding to the inventory increase or positive quantity in inventory for this entry.';
                }
                field("Outbound Item Entry No.";"Outbound Item Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry corresponding to the inventory decrease for this entry.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item quantity being applied from the inventory decrease in the Outbound Item Entry No. field, to the inventory increase in the Inbound Item Entry No. field.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a date that corresponds to the posting date of the item ledger entry, for which this item application entry was created.';
                }
                field("Transferred-from Entry No.";"Transferred-from Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item ledger entry number of the inventory increase, if an item application entry originates from an item location transfer.';
                }
                field("Cost Application";"Cost Application")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which application entries should have the cost forwarded, or simply included, in an average cost calculation.';
                }
                field("Output Completely Invd. Date";"Output Completely Invd. Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the outbound item entries have been completely invoiced.';
                }
            }
        }
    }

    actions
    {
    }
}

