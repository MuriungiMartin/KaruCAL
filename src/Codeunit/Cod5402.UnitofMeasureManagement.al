#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5402 "Unit of Measure Management"
{

    trigger OnRun()
    begin
    end;

    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ResourceUnitOfMeasure: Record "Resource Unit of Measure";
        Text001: label 'Quantity per unit of measure must be defined.';


    procedure GetQtyPerUnitOfMeasure(Item: Record Item;UnitOfMeasureCode: Code[10]): Decimal
    begin
        Item.TestField("No.");
        if UnitOfMeasureCode in [Item."Base Unit of Measure",''] then
          exit(1);
        if (Item."No." <> ItemUnitOfMeasure."Item No.") or
           (UnitOfMeasureCode <> ItemUnitOfMeasure.Code)
        then
          ItemUnitOfMeasure.Get(Item."No.",UnitOfMeasureCode);
        ItemUnitOfMeasure.TestField("Qty. per Unit of Measure");
        exit(ItemUnitOfMeasure."Qty. per Unit of Measure");
    end;


    procedure GetResQtyPerUnitOfMeasure(Resource: Record Resource;UnitOfMeasureCode: Code[10]): Decimal
    begin
        Resource.TestField("No.");
        if UnitOfMeasureCode in [Resource."Base Unit of Measure",''] then
          exit(1);
        if (Resource."No." <> ResourceUnitOfMeasure."Resource No.") or
           (UnitOfMeasureCode <> ResourceUnitOfMeasure.Code)
        then
          ResourceUnitOfMeasure.Get(Resource."No.",UnitOfMeasureCode);
        ResourceUnitOfMeasure.TestField("Qty. per Unit of Measure");
        exit(ResourceUnitOfMeasure."Qty. per Unit of Measure");
    end;


    procedure CalcBaseQty(Qty: Decimal;QtyPerUOM: Decimal): Decimal
    begin
        if QtyPerUOM = 0 then
          Error(Text001);

        exit(RoundQty(Qty * QtyPerUOM));
    end;


    procedure CalcQtyFromBase(QtyBase: Decimal;QtyPerUOM: Decimal): Decimal
    begin
        if QtyPerUOM = 0 then
          Error(Text001);

        exit(RoundQty(QtyBase / QtyPerUOM));
    end;


    procedure RoundQty(Qty: Decimal): Decimal
    begin
        exit(ROUND(Qty,QtyRndPrecision));
    end;


    procedure QtyRndPrecision(): Decimal
    begin
        exit(0.00001);
    end;
}

