#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5755 "Transfer Statistics"
{
    Caption = 'Transfer Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Transfer Header";

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
        TransLine: Record "Transfer Line";
    begin
        ClearAll;

        TransLine.SetRange("Document No.","No.");
        TransLine.SetRange("Derived From Line No.",0);
        if TransLine.Find('-') then
          repeat
            LineQty := LineQty + TransLine.Quantity;
            TotalNetWeight := TotalNetWeight + (TransLine.Quantity * TransLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (TransLine.Quantity * TransLine."Gross Weight");
            TotalVolume := TotalVolume + (TransLine.Quantity * TransLine."Unit Volume");
            if TransLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(TransLine.Quantity / TransLine."Units per Parcel",1,'>');
          until TransLine.Next = 0;
    end;

    var
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
}

