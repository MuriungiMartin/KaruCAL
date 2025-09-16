#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6665 "Return Receipt Statistics"
{
    Caption = 'Return Receipt Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Return Receipt Header";

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

        ReturnRcptLine.SetRange("Document No.","No.");

        if ReturnRcptLine.Find('-') then
          repeat
            LineQty := LineQty + ReturnRcptLine.Quantity;
            TotalNetWeight := TotalNetWeight + (ReturnRcptLine.Quantity * ReturnRcptLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (ReturnRcptLine.Quantity * ReturnRcptLine."Gross Weight");
            TotalVolume := TotalVolume + (ReturnRcptLine.Quantity * ReturnRcptLine."Unit Volume");
            if ReturnRcptLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(ReturnRcptLine.Quantity / ReturnRcptLine."Units per Parcel",1,'>');
          until ReturnRcptLine.Next = 0;
    end;

    var
        ReturnRcptLine: Record "Return Receipt Line";
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
}

