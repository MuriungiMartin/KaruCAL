#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9126 "Lot Numbers by Bin FactBox"
{
    Caption = 'Lot Numbers by Bin';
    PageType = ListPart;
    SourceTable = "Lot Numbers by Bin Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control7)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item that exists as lot numbers in the bin.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone that is assigned to the bin where the lot number exists.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin where the lot number exists.';
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the lot number that exists in the bin.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many items with the lot number exist in the bin.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        FillTempTable;
        exit(Find(Which));
    end;

    local procedure FillTempTable()
    var
        LotNosByBinCode: Query "Lot Numbers by Bin";
    begin
        LotNosByBinCode.SetRange(Item_No,GetRangeMin("Item No."));
        LotNosByBinCode.SetRange(Variant_Code,GetRangeMin("Variant Code"));
        LotNosByBinCode.SetRange(Location_Code,GetRangeMin("Location Code"));
        LotNosByBinCode.Open;

        DeleteAll;

        while LotNosByBinCode.Read do begin
          Init;
          "Item No." := LotNosByBinCode.Item_No;
          "Variant Code" := LotNosByBinCode.Variant_Code;
          "Zone Code" := LotNosByBinCode.Zone_Code;
          "Bin Code" := LotNosByBinCode.Bin_Code;
          "Location Code" := LotNosByBinCode.Location_Code;
          "Lot No." := LotNosByBinCode.Lot_No;
          "Qty. (Base)" := LotNosByBinCode.Sum_Qty_Base;
          Insert;
        end;
    end;
}

