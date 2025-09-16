#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2104 "O365 Sales Item List"
{
    Caption = 'Item List';
    CardPageID = "O365 Item Card";
    Editable = true;
    ModifyAllowed = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = Item;
    SourceTableView = sorting(Description);

    layout
    {
        area(content)
        {
            repeater(Item)
            {
                Caption = 'Item';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the item. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit in which the item is held in inventory.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the item card represents a physical item (Inventory) or a service (Service).';
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the price for one unit of the item, in $.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
                    Visible = false;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the item picture.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

