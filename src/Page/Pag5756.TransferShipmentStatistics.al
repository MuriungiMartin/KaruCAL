#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5756 "Transfer Shipment Statistics"
{
    Caption = 'Transfer Shipment Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Transfer Shipment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(LineQty;LineQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                }
                field(TotalParcels;TotalParcels)
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                }
                field(TotalNetWeight;TotalNetWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                }
                field(TotalGrossWeight;TotalGrossWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                }
                field(TotalVolume;TotalVolume)
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        TransShptLine: Record "Transfer Shipment Line";
    begin
        ClearAll;

        TransShptLine.SetRange("Document No.","No.");

        if TransShptLine.Find('-') then
          repeat
            LineQty := LineQty + TransShptLine.Quantity;
            TotalNetWeight :=
              TotalNetWeight + (TransShptLine.Quantity * TransShptLine."Net Weight");
            TotalGrossWeight :=
              TotalGrossWeight + (TransShptLine.Quantity * TransShptLine."Gross Weight");
            TotalVolume :=
              TotalVolume + (TransShptLine.Quantity * TransShptLine."Unit Volume");
            if TransShptLine."Units per Parcel" > 0 then
              TotalParcels :=
                TotalParcels +
                ROUND(TransShptLine.Quantity / TransShptLine."Units per Parcel",1,'>');
          until TransShptLine.Next = 0;
    end;

    var
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
}

