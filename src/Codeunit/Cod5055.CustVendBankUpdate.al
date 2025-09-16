#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5055 "CustVendBank-Update"
{
    TableNo = Contact;

    trigger OnRun()
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        ContBusRel.SetRange("Contact No.","No.");
        ContBusRel.SetFilter("Link to Table",'<>''''');

        if ContBusRel.Find('-') then
          repeat
            case ContBusRel."Link to Table" of
              ContBusRel."link to table"::Customer:
                UpdateCustomer(Rec,ContBusRel);
              ContBusRel."link to table"::Vendor:
                UpdateVendor(Rec,ContBusRel);
              ContBusRel."link to table"::"Bank Account":
                UpdateBankAccount(Rec,ContBusRel);
            end;
          until ContBusRel.Next = 0;
    end;

    var
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        NoSerie: Code[10];
        PurchaserCode: Code[10];
        OurContactCode: Code[10];


    procedure UpdateCustomer(var Cont: Record Contact;var ContBusRel: Record "Contact Business Relation")
    var
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
        VATRegNo: Text[20];
    begin
        with Cust do begin
          Get(ContBusRel."No.");
          NoSerie := "No. Series";
          VATRegNo := "VAT Registration No.";
          TransferFields(Cont);
          "No." := ContBusRel."No.";
          "No. Series" := NoSerie;
          Modify;
          if ("VAT Registration No." <> '') and ("VAT Registration No." <> VATRegNo) then
            VATRegistrationLogMgt.LogCustomer(Cust);
        end;
    end;


    procedure UpdateVendor(var Cont: Record Contact;var ContBusRel: Record "Contact Business Relation")
    var
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
        VATRegNo: Text[20];
    begin
        with Vend do begin
          Get(ContBusRel."No.");
          NoSerie := "No. Series";
          PurchaserCode := "Purchaser Code";
          VATRegNo := "VAT Registration No.";
          TransferFields(Cont);
          "No." := ContBusRel."No.";
          "No. Series" := NoSerie;
          "Purchaser Code" := PurchaserCode;
          Modify;
          if ("VAT Registration No." <> '') and ("VAT Registration No." <> VATRegNo) then
            VATRegistrationLogMgt.LogVendor(Vend);
        end;
    end;


    procedure UpdateBankAccount(var Cont: Record Contact;var ContBusRel: Record "Contact Business Relation")
    begin
        with BankAcc do begin
          Get(ContBusRel."No.");
          NoSerie := "No. Series";
          OurContactCode := "Our Contact Code";
          Validate("Currency Code",Cont."Currency Code");
          TransferFields(Cont);
          "No." := ContBusRel."No.";
          "No. Series" := NoSerie;
          "Our Contact Code" := OurContactCode;
          Modify;
        end;
    end;
}

