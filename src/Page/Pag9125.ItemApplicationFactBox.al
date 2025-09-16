#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9125 "Item Application FactBox"
{
    Caption = 'Item Application FactBox';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            field("Entry No.";"Entry No.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the entry number for the entry.';
            }
            field("Item No.";"Item No.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the number of the item in the entry.';
            }
            field("Item.""Costing Method""";Item."Costing Method")
            {
                ApplicationArea = Basic;
                Caption = 'Costing Method';
            }
            field("Posting Date";"Posting Date")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the entry''s posting date.';
            }
            field("Entry Type";"Entry Type")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies which type of transaction that the entry is created from.';
            }
            field(Quantity;Quantity)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the number of units of the item in the item entry.';
            }
            field("Reserved Quantity";"Reserved Quantity")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies how many units of the item on the line have been reserved.';
            }
            field("Remaining Quantity";"Remaining Quantity")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the quantity that remains in inventory in the Quantity field if the entry is an increase (a purchase or positive adjustment).';
            }
            field(Available;Available)
            {
                ApplicationArea = Basic;
                Caption = 'Available';
                DecimalPlaces = 0:5;
            }
            field(Applied;Applied)
            {
                ApplicationArea = Basic;
                Caption = 'Applied';
                DecimalPlaces = 0:5;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Reserved Quantity");
        Available := Quantity - "Reserved Quantity";
        Applied := ItemApplnEntry.OutboundApplied("Entry No.",false) - ItemApplnEntry.InboundApplied("Entry No.",false);

        if not Item.Get("Item No.") then
          Item.Reset;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        Available := 0;
        Applied := 0;
        Clear(Item);

        exit(Find(Which));
    end;

    var
        Item: Record Item;
        ItemApplnEntry: Record "Item Application Entry";
        Available: Decimal;
        Applied: Decimal;
}

