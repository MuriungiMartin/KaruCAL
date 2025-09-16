#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50123 "Stock Transfer Receive"
{
    TableNo = "Transfer Header";

    trigger OnRun()
    begin
        TransHeader.Copy(Rec);
        Code;
        Rec := TransHeader;
    end;

    var
        Text000: label '&Ship,&Receive';
        TransHeader: Record "Transfer Header";

    local procedure "Code"()
    var
        TransLine: Record "Transfer Line";
        DefaultNumber: Option " ",Shipment,Receipt;
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        Selection: Option " ",Shipment,Receipt;
    begin
        with TransHeader do begin
          TransLine.SetRange("Document No.","No.");
          if TransLine.Find('-') then begin
            repeat
              if (TransLine."Quantity Shipped" < TransLine.Quantity) and
                 (DefaultNumber = Defaultnumber::" ") then
                DefaultNumber := Defaultnumber::Shipment;
              if (TransLine."Quantity Received" < TransLine.Quantity) and
                 (DefaultNumber = Defaultnumber::" ") then
                DefaultNumber := Defaultnumber::Receipt;
            until (TransLine.Next = 0) or (DefaultNumber > 0);
          end;
          TransferPostReceipt.Run(TransHeader);
         /* IF DefaultNumber = 0 THEN
            DefaultNumber := 1;
          //Selection := STRMENU(Text000,DefaultNumber);
          CASE Selection OF
            0:
              EXIT;
            1:
              TransferPostShipment.RUN(TransHeader);
            2:
              TransferPostReceipt.RUN(TransHeader);
          END;
          */
        end;

    end;
}

