#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6655 "Return Shipment Statistics"
{
    Caption = 'Return Shipment Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Return Shipment Header";

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

        ReturnShptLine.SetRange("Document No.","No.");

        if ReturnShptLine.Find('-') then
          repeat
            LineQty := LineQty + ReturnShptLine.Quantity;
            TotalNetWeight := TotalNetWeight + (ReturnShptLine.Quantity * ReturnShptLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (ReturnShptLine.Quantity * ReturnShptLine."Gross Weight");
            TotalVolume := TotalVolume + (ReturnShptLine.Quantity * ReturnShptLine."Unit Volume");
            if ReturnShptLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(ReturnShptLine.Quantity / ReturnShptLine."Units per Parcel",1,'>');
          until ReturnShptLine.Next = 0;
    end;

    var
        ReturnShptLine: Record "Return Shipment Line";
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
}

