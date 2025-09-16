#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 342 "Check Availability"
{
    Caption = 'Check Availability';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    InstructionalText = 'The available inventory is lower than the entered quantity. Do you still want to record the quantity?';
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ConfirmationDialog;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field(AvailableInventory;InventoryQty)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Available Inventory';
                DecimalPlaces = 0:5;
                Editable = false;
                ToolTip = 'Specifies the quantity of the item that is currently in inventory and not reserved for other demand.';
            }
            field(InventoryShortage;TotalQuantity)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Inventory Shortage';
                DecimalPlaces = 0:5;
                Editable = false;
                ToolTip = 'Specifies the quantity that is missing from inventory to fulfil the quantity on the line.';
            }
            part(ItemAvailabilityCheckDet;"Item Availability Check Det.")
            {
                SubPageLink = "No."=field("No.");
            }
        }
    }

    actions
    {
    }

    var
        InventoryQty: Decimal;
        TotalQuantity: Decimal;


    procedure SetValues(ItemNo: Code[20];UnitOfMeasureCode: Code[10];InventoryQty2: Decimal;GrossReq: Decimal;ReservedReq: Decimal;SchedRcpt: Decimal;ReservedRcpt: Decimal;CurrentQuantity: Decimal;CurrentReservedQty: Decimal;TotalQuantity2: Decimal;EarliestAvailDate: Date)
    begin
        Get(ItemNo);
        CurrPage.ItemAvailabilityCheckDet.Page.SetUnitOfMeasureCode(UnitOfMeasureCode);
        InventoryQty := InventoryQty2;
        CurrPage.ItemAvailabilityCheckDet.Page.SetGrossReq(GrossReq);
        CurrPage.ItemAvailabilityCheckDet.Page.SetReservedReq(ReservedReq);
        CurrPage.ItemAvailabilityCheckDet.Page.SetSchedRcpt(SchedRcpt);
        CurrPage.ItemAvailabilityCheckDet.Page.SetReservedRcpt(ReservedRcpt);
        CurrPage.ItemAvailabilityCheckDet.Page.SetCurrentQuantity(CurrentQuantity);
        CurrPage.ItemAvailabilityCheckDet.Page.SetCurrentReservedQty(CurrentReservedQty);
        TotalQuantity := TotalQuantity2;
        CurrPage.ItemAvailabilityCheckDet.Page.SetEarliestAvailDate(EarliestAvailDate);
    end;
}

