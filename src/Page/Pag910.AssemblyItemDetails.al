#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 910 "Assembly Item - Details"
{
    Caption = 'Assembly Item - Details';
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
            field("Standard Cost";"Standard Cost")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the unit cost that is used as a standard measure.';
            }
            field("Unit Price";"Unit Price")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the price for one unit of the item, in $.';
            }
        }
    }

    actions
    {
    }
}

