#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 7300 "Lot Numbers by Bin"
{
    Caption = 'Lot Numbers by Bin';
    OrderBy = ascending(Bin_Code);

    elements
    {
        dataitem(Warehouse_Entry;"Warehouse Entry")
        {
            column(Location_Code;"Location Code")
            {
            }
            column(Item_No;"Item No.")
            {
            }
            column(Variant_Code;"Variant Code")
            {
            }
            column(Zone_Code;"Zone Code")
            {
            }
            column(Bin_Code;"Bin Code")
            {
            }
            column(Lot_No;"Lot No.")
            {
                ColumnFilter = Lot_No=filter(<>'');
            }
            column(Sum_Qty_Base;"Qty. (Base)")
            {
                ColumnFilter = Sum_Qty_Base=filter(<>0);
                Method = Sum;
            }
        }
    }
}

