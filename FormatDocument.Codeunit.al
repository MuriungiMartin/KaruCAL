#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 368 "Format Document"
{

    trigger OnRun()
    begin
    end;

    var
        PurchaserTxt: label 'Purchaser';
        SalespersonTxt: label 'Salesperson';
        TotalTxt: label 'Total %1', Comment='%1 = Currency Code';
        TotalInclVATTxt: label 'Total %1 Incl. Tax', Comment='%1 = Currency Code';
        TotalExclVATTxt: label 'Total %1 Excl. Tax', Comment='%1 = Currency Code';
        GLSetup: Record "General Ledger Setup";
        COPYTxt: label 'COPY', Locked=true;


    procedure GetCOPYText(): Text[30]
    begin
        exit(' ' + COPYTxt);
    end;


    procedure ParseComment(Comment: Text[80];var Description: Text[50];var Description2: Text[50])
    var
        SpacePointer: Integer;
    begin
        if StrLen(Comment) <= MaxStrLen(Description) then begin
          Description := CopyStr(Comment,1,MaxStrLen(Description));
          Description2 := '';
        end else begin
          SpacePointer := MaxStrLen(Description) + 1;
          while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
            SpacePointer := SpacePointer - 1;
          if SpacePointer = 1 then
            SpacePointer := MaxStrLen(Description) + 1;
          Description := CopyStr(Comment,1,SpacePointer - 1);
          Description2 := CopyStr(CopyStr(Comment,SpacePointer + 1),1,MaxStrLen(Description2));
        end;
    end;


    procedure SetTotalLabels(CurrencyCode: Code[10];var TotalText: Text[50];var TotalInclVATText: Text[50];var TotalExclVATText: Text[50])
    begin
        if CurrencyCode = '' then begin
          GLSetup.Get;
          GLSetup.TestField("LCY Code");
          TotalText := StrSubstNo(TotalTxt,GLSetup."LCY Code");
          TotalInclVATText := StrSubstNo(TotalInclVATTxt,GLSetup."LCY Code");
          TotalExclVATText := StrSubstNo(TotalExclVATTxt,GLSetup."LCY Code");
        end else begin
          TotalText := StrSubstNo(TotalTxt,CurrencyCode);
          TotalInclVATText := StrSubstNo(TotalInclVATTxt,CurrencyCode);
          TotalExclVATText := StrSubstNo(TotalExclVATTxt,CurrencyCode);
        end;
    end;


    procedure SetLogoPosition(LogoPosition: Option "No Logo",Left,Center,Right;var CompanyInfo1: Record "Company Information";var CompanyInfo2: Record "Company Information";var CompanyInfo3: Record "Company Information")
    begin
        case LogoPosition of
          Logoposition::"No Logo":
            ;
          Logoposition::Left:
            begin
              CompanyInfo3.Get;
              CompanyInfo3.CalcFields(Picture);
            end;
          Logoposition::Center:
            begin
              CompanyInfo1.Get;
              CompanyInfo1.CalcFields(Picture);
            end;
          Logoposition::Right:
            begin
              CompanyInfo2.Get;
              CompanyInfo2.CalcFields(Picture);
            end;
        end;
    end;


    procedure SetPaymentMethod(var PaymentMethod: Record "Payment Method";"Code": Code[10])
    begin
        if Code = '' then
          PaymentMethod.Init
        else
          PaymentMethod.Get(Code);
    end;


    procedure SetPaymentTerms(var PaymentTerms: Record "Payment Terms";"Code": Code[10];LanguageCode: Code[10])
    begin
        if Code = '' then
          PaymentTerms.Init
        else begin
          PaymentTerms.Get(Code);
          PaymentTerms.TranslateDescription(PaymentTerms,LanguageCode);
        end;
    end;


    procedure SetPurchaser(var SalespersonPurchaser: Record "Salesperson/Purchaser";"Code": Code[10];var PurchaserText: Text[50])
    begin
        if Code = '' then begin
          SalespersonPurchaser.Init;
          PurchaserText := '';
        end else begin
          SalespersonPurchaser.Get(Code);
          PurchaserText := PurchaserTxt;
        end;
    end;


    procedure SetShipmentMethod(var ShipmentMethod: Record "Shipment Method";"Code": Code[10];LanguageCode: Code[10])
    begin
        if Code = '' then
          ShipmentMethod.Init
        else begin
          ShipmentMethod.Get(Code);
          ShipmentMethod.TranslateDescription(ShipmentMethod,LanguageCode);
        end;
    end;


    procedure SetSalesPerson(var SalespersonPurchaser: Record "Salesperson/Purchaser";"Code": Code[10];var SalesPersonText: Text[50])
    begin
        if Code = '' then begin
          SalespersonPurchaser.Init;
          SalesPersonText := '';
        end else begin
          SalespersonPurchaser.Get(Code);
          SalesPersonText := SalespersonTxt;
        end;
    end;


    procedure SetText(Condition: Boolean;Caption: Text[80]): Text[80]
    begin
        if Condition then
          exit(Caption);

        exit('');
    end;
}

