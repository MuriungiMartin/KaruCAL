#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 399 "Purchase Receipt Statistics"
{
    Caption = 'Purchase Receipt Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Purch. Rcpt. Header";

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

        PurchRcptLine.SetRange("Document No.","No.");

        if PurchRcptLine.Find('-') then
          repeat
            LineQty := LineQty + PurchRcptLine.Quantity;
            TotalNetWeight := TotalNetWeight + (PurchRcptLine.Quantity * PurchRcptLine."Net Weight");
            TotalGrossWeight := TotalGrossWeight + (PurchRcptLine.Quantity * PurchRcptLine."Gross Weight");
            TotalVolume := TotalVolume + (PurchRcptLine.Quantity * PurchRcptLine."Unit Volume");
            if PurchRcptLine."Units per Parcel" > 0 then
              TotalParcels := TotalParcels + ROUND(PurchRcptLine.Quantity / PurchRcptLine."Units per Parcel",1,'>');
          until PurchRcptLine.Next = 0;
    end;

    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
}

