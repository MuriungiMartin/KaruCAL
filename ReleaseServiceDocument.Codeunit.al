#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 416 "Release Service Document"
{
    TableNo = "Service Header";

    trigger OnRun()
    var
        ServLine: Record "Service Line";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
    begin
        if "Release Status" = "release status"::"Released to Ship" then
          exit;
        if "Document Type" = "document type"::Quote then
          TestField("Bill-to Customer No.");
        ServLine.SetRange("Document Type","Document Type");
        ServLine.SetRange("Document No.","No.");
        ServLine.SetFilter(Type,'<>%1',ServLine.Type::" ");
        ServLine.SetFilter(Quantity,'<>0');
        if ServLine.IsEmpty then
          Error(Text001,"Document Type","No.");
        InvtSetup.Get;
        if InvtSetup."Location Mandatory" then begin
          ServLine.SetCurrentkey(Type);
          ServLine.SetRange(Type,ServLine.Type::Item);
          if ServLine.FindSet then
            repeat
              ServLine.TestField("Location Code");
            until ServLine.Next = 0;
          ServLine.SetFilter(Type,'<>%1',ServLine.Type::" ");
        end;
        ServLine.Reset;
        Validate("Release Status","release status"::"Released to Ship");
        ServLine.SetServHeader(Rec);
        ServLine.CalcVATAmountLines(0,Rec,ServLine,TempVATAmountLine0,ServLine.IsShipment);
        ServLine.CalcVATAmountLines(1,Rec,ServLine,TempVATAmountLine1,ServLine.IsShipment);
        ServLine.UpdateVATOnLines(0,Rec,ServLine,TempVATAmountLine0);
        ServLine.UpdateVATOnLines(1,Rec,ServLine,TempVATAmountLine1);
        Modify(true);

        if "Document Type" = "document type"::Order then
          WhseServiceRelease.Release(Rec);
    end;

    var
        Text001: label 'There is nothing to release for %1 %2.', Comment='Example: There is nothing to release for Order 12345.';
        InvtSetup: Record "Inventory Setup";
        WhseServiceRelease: Codeunit "Whse.-Service Release";


    procedure Reopen(var ServHeader: Record "Service Header")
    begin
        with ServHeader do begin
          if "Release Status" = "release status"::Open then
            exit;
          Validate("Release Status","release status"::Open);
          Modify(true);
          if "Document Type" in ["document type"::Order] then
            WhseServiceRelease.Reopen(ServHeader);
        end;
    end;


    procedure PerformManualRelease(var ServHeader: Record "Service Header")
    begin
        Codeunit.Run(Codeunit::"Release Service Document",ServHeader);
    end;


    procedure PerformManualReopen(var ServHeader: Record "Service Header")
    begin
        Reopen(ServHeader);
    end;
}

