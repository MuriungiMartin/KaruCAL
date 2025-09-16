#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5757 "Transfer Receipt Statistics"
{
    Caption = 'Transfer Receipt Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Transfer Receipt Header";

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
        TransRcptLine: Record "Transfer Receipt Line";
    begin
        ClearAll;

        TransRcptLine.SetRange("Document No.","No.");

        if TransRcptLine.Find('-') then
          repeat
            LineQty := LineQty + TransRcptLine.Quantity;
            TotalNetWeight :=
              TotalNetWeight + (TransRcptLine.Quantity * TransRcptLine."Net Weight");
            TotalGrossWeight :=
              TotalGrossWeight + (TransRcptLine.Quantity * TransRcptLine."Gross Weight");
            TotalVolume :=
              TotalVolume + (TransRcptLine.Quantity * TransRcptLine."Unit Volume");
            if TransRcptLine."Units per Parcel" > 0 then
              TotalParcels :=
                TotalParcels +
                ROUND(TransRcptLine.Quantity / TransRcptLine."Units per Parcel",1,'>');
          until TransRcptLine.Next = 0;
    end;

    var
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
}

