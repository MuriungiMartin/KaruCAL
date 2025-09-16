#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5781 "Whse. Validate Source Header"
{

    trigger OnRun()
    begin
    end;


    procedure SalesHeaderVerifyChange(var NewSalesHeader: Record "Sales Header";var OldSalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        with NewSalesHeader do begin
          if "Shipping Advice" = OldSalesHeader."Shipping Advice" then
            exit;

          SalesLine.Reset;
          SalesLine.SetRange("Document Type",OldSalesHeader."Document Type");
          SalesLine.SetRange("Document No.",OldSalesHeader."No.");
          if SalesLine.FindSet then
            repeat
              ChangeWhseLines(
                Database::"Sales Line",
                SalesLine."Document Type",
                SalesLine."Document No.",
                SalesLine."Line No.",
                0,
                "Shipping Advice");
            until SalesLine.Next = 0;
        end;
    end;


    procedure ServiceHeaderVerifyChange(var NewServiceHeader: Record "Service Header";var OldServiceHeader: Record "Service Header")
    var
        ServiceLine: Record "Service Line";
    begin
        with NewServiceHeader do begin
          if "Shipping Advice" = OldServiceHeader."Shipping Advice" then
            exit;

          ServiceLine.Reset;
          ServiceLine.SetRange("Document Type",OldServiceHeader."Document Type");
          ServiceLine.SetRange("Document No.",OldServiceHeader."No.");
          if ServiceLine.Find('-') then
            repeat
              ChangeWhseLines(
                Database::"Service Line",
                ServiceLine."Document Type",
                ServiceLine."Document No.",
                ServiceLine."Line No.",
                0,
                "Shipping Advice");
            until ServiceLine.Next = 0;
        end;
    end;


    procedure TransHeaderVerifyChange(var NewTransHeader: Record "Transfer Header";var OldTransHeader: Record "Transfer Header")
    var
        TransLine: Record "Transfer Line";
    begin
        with NewTransHeader do begin
          if "Shipping Advice" = OldTransHeader."Shipping Advice" then
            exit;

          TransLine.Reset;
          TransLine.SetRange("Document No.",OldTransHeader."No.");
          if TransLine.Find('-') then
            repeat
              ChangeWhseLines(
                Database::"Transfer Line",
                0,// Outbound Transfer
                TransLine."Document No.",
                TransLine."Line No.",
                0,
                "Shipping Advice");
            until TransLine.Next = 0;
        end;
    end;

    local procedure ChangeWhseLines(SourceType: Integer;SourceSubType: Option;SourceNo: Code[20];SourceLineNo: Integer;SourceSublineNo: Integer;ShipAdvice: Integer)
    var
        WhseActivLine: Record "Warehouse Activity Line";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseWkshLine: Record "Whse. Worksheet Line";
    begin
        WhseShptLine.Reset;
        WhseShptLine.SetRange("Source Type",SourceType);
        WhseShptLine.SetRange("Source Subtype",SourceSubType);
        WhseShptLine.SetRange("Source No.",SourceNo);
        WhseShptLine.SetRange("Source Line No.",SourceLineNo);
        WhseShptLine.ModifyAll("Shipping Advice",ShipAdvice);

        WhseActivLine.Reset;
        WhseActivLine.SetRange("Source Type",SourceType);
        WhseActivLine.SetRange("Source Subtype",SourceSubType);
        WhseActivLine.SetRange("Source No.",SourceNo);
        WhseActivLine.SetRange("Source Line No.",SourceLineNo);
        WhseActivLine.SetRange("Source Subline No.",SourceSublineNo);
        WhseActivLine.ModifyAll("Shipping Advice",ShipAdvice);

        WhseWkshLine.Reset;
        WhseWkshLine.SetRange("Source Type",SourceType);
        WhseWkshLine.SetRange("Source Subtype",SourceSubType);
        WhseWkshLine.SetRange("Source No.",SourceNo);
        WhseWkshLine.SetRange("Source Line No.",SourceLineNo);
        WhseWkshLine.ModifyAll("Shipping Advice",ShipAdvice);
    end;
}

