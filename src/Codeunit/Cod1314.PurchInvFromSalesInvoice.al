#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1314 PurchInvFromSalesInvoice
{

    trigger OnRun()
    begin
    end;

    var
        CreatePurchInvOptionQst: label 'All Lines,Selected Lines';
        CreatePurchInvInstructionTxt: label 'A purchase invoice will be created. Select which sales invoice lines to use.';
        SelectVentorTxt: label 'Select a vendor to buy from.';
        TypeNotSupportedErr: label 'Type %1 is not supported.', Comment='Line or Document type';


    procedure CreatePurchaseInvoice(SalesHeader: Record "Sales Header";var SelectedSalesLine: Record "Sales Line")
    var
        Vendor: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
        SalesLine: Record "Sales Line";
        OptionNumber: Integer;
    begin
        OptionNumber := Dialog.StrMenu(CreatePurchInvOptionQst,1,CreatePurchInvInstructionTxt);

        if OptionNumber = 0 then
          exit;

        case OptionNumber of
          0:
            exit;
          1:
            begin
              SalesLine.SetRange("Document Type",SalesHeader."Document Type");
              SalesLine.SetRange("Document No.",SalesHeader."No.");
            end;
          2:
            SalesLine.Copy(SelectedSalesLine);
        end;

        if SelectVendor(Vendor,SalesLine) then begin
          CreatePurchaseHeader(PurchaseHeader,SalesHeader,Vendor);
          CopySalesLinesToPurchaseLines(PurchaseHeader,SalesLine);
          Page.Run(Page::"Purchase Invoice",PurchaseHeader);
        end;
    end;

    local procedure CreatePurchaseHeader(var PurchaseHeader: Record "Purchase Header";SalesHeader: Record "Sales Header";Vendor: Record Vendor)
    begin
        PurchaseHeader.Init;

        if SalesHeader."Document Type" in [SalesHeader."document type"::Invoice,SalesHeader."document type"::Order] then
          PurchaseHeader.Validate("Document Type",PurchaseHeader."document type"::Invoice)
        else
          Error(TypeNotSupportedErr,Format(SalesHeader."Document Type"));

        PurchaseHeader.InitRecord;
        PurchaseHeader.Validate("Buy-from Vendor No.",Vendor."No.");
        PurchaseHeader.Insert(true);
    end;

    local procedure CopySalesLinesToPurchaseLines(PurchaseHeader: Record "Purchase Header";var SalesLine: Record "Sales Line")
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseLineNo: Integer;
    begin
        PurchaseLineNo := 0;
        if SalesLine.Find('-') then
          repeat
            Clear(PurchaseLine);
            PurchaseLine.Init;
            PurchaseLine."Document No." := PurchaseHeader."No.";
            PurchaseLine."Document Type" := PurchaseHeader."Document Type";

            PurchaseLineNo := PurchaseLineNo + 10000;
            PurchaseLine."Line No." := PurchaseLineNo;

            case SalesLine.Type of
              SalesLine.Type::" ":
                PurchaseLine.Type := PurchaseLine.Type::" ";
              SalesLine.Type::Item:
                PurchaseLine.Type := PurchaseLine.Type::Item;
              else
                Error(TypeNotSupportedErr,Format(SalesLine.Type));
            end;

            PurchaseLine.Validate("No.",SalesLine."No.");
            PurchaseLine.Description := SalesLine.Description;

            if PurchaseLine."No." <> '' then begin
              PurchaseLine.Validate("Buy-from Vendor No.",PurchaseHeader."Buy-from Vendor No.");
              PurchaseLine.Validate("Pay-to Vendor No.",PurchaseHeader."Pay-to Vendor No.");
              PurchaseLine.Validate(Quantity,SalesLine.Quantity);
              PurchaseLine.Validate("Unit of Measure Code",SalesLine."Unit of Measure Code");
            end;

            PurchaseLine.Insert(true);
          until SalesLine.Next = 0;
    end;

    local procedure SelectVendor(var Vendor: Record Vendor;var SelectedSalesLine: Record "Sales Line"): Boolean
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        VendorList: Page "Vendor List";
        VendorNo: Code[20];
        DefaultVendorFound: Boolean;
    begin
        SalesLine.Copy(SelectedSalesLine);

        SalesLine.SetRange(Type,SalesLine.Type::Item);
        SalesLine.SetFilter("No.",'<>%1','');
        if SalesLine.FindSet then begin
          Item.Get(SalesLine."No.");
          VendorNo := Item."Vendor No.";
          DefaultVendorFound := (VendorNo <> '');

          while DefaultVendorFound and (SalesLine.Next <> 0) do begin
            Item.Get(SalesLine."No.");
            DefaultVendorFound := (VendorNo = Item."Vendor No.");
          end;

          if DefaultVendorFound then begin
            Vendor.Get(VendorNo);
            exit(true);
          end;
        end;

        VendorList.LookupMode(true);
        VendorList.Caption(SelectVentorTxt);
        if VendorList.RunModal = Action::LookupOK then begin
          VendorList.GetRecord(Vendor);
          exit(true);
        end;

        exit(false);
    end;
}

