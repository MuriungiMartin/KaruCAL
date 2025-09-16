#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1327 "Adjust Inventory"
{
    Caption = 'Adjust Inventory';
    PageType = StandardDialog;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the unit in which the item is held in inventory. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Current Inventory';
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
                }
                field(NewInventory;NewInventory)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'New Inventory';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the inventory quantity that will be recorded for the item when you choose the OK button.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        NewInventory := Inventory
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        AdjustItemInventory: Codeunit "Adjust Item Inventory";
        ErrorText: Text;
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then begin
          ErrorText := AdjustItemInventory.PostAdjustmentToItemLedger(Rec,NewInventory);
          if ErrorText <> '' then
            Message(ErrorText);
        end;
    end;

    var
        NewInventory: Decimal;
}

