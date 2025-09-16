#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 911 "Component - Item Details"
{
    Caption = 'Component - Item Details';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Basic;
                Caption = 'Item No.';
                ToolTip = 'Specifies the number of the item.';
            }
            field("Base Unit of Measure";"Base Unit of Measure")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the unit in which the item is held in inventory.';
            }
            field("Unit Price";"Unit Price")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the price for one unit of the item, in $.';
            }
            field("Unit Cost";"Unit Cost")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the cost per unit of the item.';
            }
            field("Standard Cost";"Standard Cost")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the unit cost that is used as a standard measure.';
            }
            field("No. of Substitutes";"No. of Substitutes")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the number of substitutions that have been registered for the item.';
            }
            field("Replenishment System";"Replenishment System")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the type of supply order created by the planning system when the item needs to be replenished.';
            }
            field("Vendor No.";"Vendor No.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the vendor code of who supplies this item by default.';
            }
        }
    }

    actions
    {
    }
}

