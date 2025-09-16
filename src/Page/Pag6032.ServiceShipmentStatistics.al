#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6032 "Service Shipment Statistics"
{
    Caption = 'Service Shipment Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Service Shipment Header";

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
    begin
        ClearAll;

        ServShptLine.SetRange("Document No.","No.");

        if ServShptLine.Find('-') then
          repeat
            LineQty := LineQty + ServShptLine.Quantity;
            TotalNetWeight := TotalNetWeight + (ServShptLine.Quantity * ServShptLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (ServShptLine.Quantity * ServShptLine."Gross Weight");
            TotalVolume := TotalVolume + (ServShptLine.Quantity * ServShptLine."Unit Volume");
            if ServShptLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(ServShptLine.Quantity / ServShptLine."Units per Parcel",1,'>');
          until ServShptLine.Next = 0;
    end;

    var
        ServShptLine: Record "Service Shipment Line";
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
}

