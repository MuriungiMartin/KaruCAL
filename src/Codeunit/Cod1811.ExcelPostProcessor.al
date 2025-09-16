#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1811 "Excel Post Processor"
{
    TableNo = "Config. Package Record";

    trigger OnRun()
    begin
        case "Table ID" of
          Database::Item:
            PostProcessItem(Rec);
          else
            exit;
        end;
    end;

    local procedure PostProcessItem(ConfigPackageRecord: Record "Config. Package Record")
    var
        Item: Record Item;
        AdjustItemInventory: Codeunit "Adjust Item Inventory";
        QuantityOnInventory: Decimal;
        ErrorText: Text;
    begin
        if not FindItemAndGetInventory(ConfigPackageRecord,Item,QuantityOnInventory) then
          exit;

        if (Item."Base Unit of Measure" = '') or
           (Item."Gen. Prod. Posting Group" = '') or
           (Item."Inventory Posting Group" = '')
        then
          exit;

        ErrorText := AdjustItemInventory.PostAdjustmentToItemLedger(Item,QuantityOnInventory);
        if ErrorText <> '' then
          Error(ErrorText);
    end;

    local procedure FindItemAndGetInventory(ConfigPackageRecord: Record "Config. Package Record";var Item: Record Item;var QuantityOnInventory: Decimal): Boolean
    var
        ConfigPackageData: Record "Config. Package Data";
    begin
        with ConfigPackageRecord do begin
          ConfigPackageData.Get("Package Code","Table ID","No.",Item.FieldNo("No."));
          if not Item.Get(ConfigPackageData.Value) then
            exit(false);
          if not ConfigPackageData.Get("Package Code","Table ID","No.",Item.FieldNo(Inventory)) then
            exit(false);
          if not Evaluate(QuantityOnInventory,ConfigPackageData.Value) then
            exit(false);
        end;

        exit(true);
    end;
}

