#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5706 "TransferOrder-Post (Yes/No)"
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
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        DefaultNumber: Integer;
        Selection: Option " ",Shipment,Receipt;
    begin
        with TransHeader do begin
          TransLine.SetRange("Document No.","No.");
          if TransLine.Find('-') then
            repeat
              if (TransLine."Quantity Shipped" < TransLine.Quantity) and
                 (DefaultNumber = 0)
              then
                DefaultNumber := 1;
              if (TransLine."Quantity Received" < TransLine.Quantity) and
                 (DefaultNumber = 0)
              then
                DefaultNumber := 2;
            until (TransLine.Next = 0) or (DefaultNumber > 0);

          if DefaultNumber = 0 then
            DefaultNumber := 1;
          Selection := StrMenu(Text000,DefaultNumber);
          case Selection of
            0:
              exit;
            1:
              TransferPostShipment.Run(TransHeader);
            2:
              TransferPostReceipt.Run(TransHeader);
          end;
        end;
    end;
}

