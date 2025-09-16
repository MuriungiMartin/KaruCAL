#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5765 "Whse.-Post Shipment + Print"
{
    TableNo = "Warehouse Shipment Line";

    trigger OnRun()
    begin
        WhseShipLine.Copy(Rec);
        Code;
        Rec := WhseShipLine;
    end;

    var
        WhseShipLine: Record "Warehouse Shipment Line";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        Selection: Integer;
        Text000: label '&Ship,Ship &and Invoice';

    local procedure "Code"()
    var
        Invoice: Boolean;
    begin
        with WhseShipLine do begin
          if Find then begin
            Selection := StrMenu(Text000,2);
            if Selection = 0 then
              exit;
            Invoice := (Selection = 2);
          end;

          WhsePostShipment.SetPostingSettings(Invoice);
          WhsePostShipment.SetPrint(true);
          WhsePostShipment.Run(WhseShipLine);
          WhsePostShipment.GetResultMessage;
          Clear(WhsePostShipment);
        end;
    end;
}

