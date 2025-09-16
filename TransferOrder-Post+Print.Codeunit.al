#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5707 "TransferOrder-Post + Print"
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
                DefaultNumber := Selection::Shipment;
              if (TransLine."Quantity Received" < TransLine.Quantity) and
                 (DefaultNumber = 0)
              then
                DefaultNumber := Selection::Receipt;
            until (TransLine.Next = 0) or (DefaultNumber > 0);

          if DefaultNumber = 0 then
            DefaultNumber := Selection::Shipment;
          Selection := StrMenu(Text000,DefaultNumber);
          case Selection of
            0:
              exit;
            Selection::Shipment:
              TransferPostShipment.Run(TransHeader);
            Selection::Receipt:
              TransferPostReceipt.Run(TransHeader);
          end;
          PrintReport(TransHeader,Selection);
        end;
    end;


    procedure PrintReport(TransHeaderSource: Record "Transfer Header";Selection: Option " ",Shipment,Receipt)
    begin
        with TransHeaderSource do
          case Selection of
            Selection::Shipment:
              PrintShipment("Last Shipment No.");
            Selection::Receipt:
              PrintReceipt("Last Receipt No.");
          end;
    end;

    local procedure PrintShipment(DocNo: Code[20])
    var
        TransShptHeader: Record "Transfer Shipment Header";
    begin
        if TransShptHeader.Get(DocNo) then begin
          TransShptHeader.SetRecfilter;
          TransShptHeader.PrintRecords(false);
        end;
    end;

    local procedure PrintReceipt(DocNo: Code[20])
    var
        TransRcptHeader: Record "Transfer Receipt Header";
    begin
        if TransRcptHeader.Get(DocNo) then begin
          TransRcptHeader.SetRecfilter;
          TransRcptHeader.PrintRecords(false);
        end;
    end;
}

