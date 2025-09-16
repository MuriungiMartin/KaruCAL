#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5932 "Service-Get Shipment"
{
    TableNo = "Service Line";

    trigger OnRun()
    begin
        ServiceHeader.Get("Document Type","Document No.");
        ServiceHeader.TestField("Document Type",ServiceHeader."document type"::Invoice);

        Clear(ServiceShptLine);
        ServiceShptLine.SetCurrentkey("Bill-to Customer No.");
        ServiceShptLine.SetRange("Bill-to Customer No.",ServiceHeader."Bill-to Customer No.");
        ServiceShptLine.SetFilter("Qty. Shipped Not Invoiced",'<>0');
        ServiceShptLine.SetRange("Currency Code",ServiceHeader."Currency Code");
        ServiceShptLine.FilterGroup(2);

        GetServiceShipments.SetTableview(ServiceShptLine);
        GetServiceShipments.SetServiceHeader(ServiceHeader);
        GetServiceShipments.LookupMode(true);
        GetServiceShipments.RunModal;
    end;

    var
        Text001: label 'The %1 on the %2 %3 and the %4 %5 must be the same.';
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceShptHeader: Record "Service Shipment Header";
        ServiceShptLine: Record "Service Shipment Line";
        GetServiceShipments: Page "Get Service Shipment Lines";


    procedure CreateInvLines(var ServiceShptLine2: Record "Service Shipment Line")
    var
        TransferLine: Boolean;
    begin
        with ServiceShptLine2 do begin
          SetFilter("Qty. Shipped Not Invoiced",'<>0');
          if Find('-') then begin
            ServiceLine.LockTable;
            ServiceLine.SetRange("Document Type",ServiceHeader."Document Type");
            ServiceLine.SetRange("Document No.",ServiceHeader."No.");
            ServiceLine."Document Type" := ServiceHeader."Document Type";
            ServiceLine."Document No." := ServiceHeader."No.";

            repeat
              if ServiceShptHeader."No." <> "Document No." then begin
                ServiceShptHeader.Get("Document No.");
                TransferLine := true;
                if ServiceShptHeader."Currency Code" <> ServiceHeader."Currency Code" then begin
                  Message(
                    Text001,
                    ServiceHeader.FieldCaption("Currency Code"),
                    ServiceHeader.TableCaption,ServiceHeader."No.",
                    ServiceShptHeader.TableCaption,ServiceShptHeader."No.");
                  TransferLine := false;
                end;
                if ServiceShptHeader."Bill-to Customer No." <> ServiceHeader."Bill-to Customer No." then begin
                  Message(
                    Text001,
                    ServiceHeader.FieldCaption("Bill-to Customer No."),
                    ServiceHeader.TableCaption,ServiceHeader."No.",
                    ServiceShptHeader.TableCaption,ServiceShptHeader."No.");
                  TransferLine := false;
                end;
              end;
              if TransferLine then begin
                ServiceShptLine := ServiceShptLine2;

                ServiceShptLine.InsertInvLineFromShptLine(ServiceLine);
              end;
            until Next = 0;
          end;
        end;
    end;


    procedure SetServiceHeader(var ServiceHeader2: Record "Service Header")
    begin
        ServiceHeader.Get(ServiceHeader2."Document Type",ServiceHeader2."No.");
        ServiceHeader.TestField("Document Type",ServiceHeader."document type"::Invoice);
    end;
}

