#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 365 "Format Address"
{

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        i: Integer;


    procedure FormatAddr(var AddrArray: array [8] of Text[90];Name: Text[90];Name2: Text[90];Contact: Text[90];Addr: Text[50];Addr2: Text[50];City: Text[50];PostCode: Code[20];County: Text[50];CountryCode: Code[10])
    var
        Country: Record "Country/Region";
        InsertText: Integer;
        Index: Integer;
        NameLineNo: Integer;
        Name2LineNo: Integer;
        AddrLineNo: Integer;
        Addr2LineNo: Integer;
        ContLineNo: Integer;
        PostCodeCityLineNo: Integer;
        CountyLineNo: Integer;
        CountryLineNo: Integer;
    begin
        Clear(AddrArray);

        if CountryCode = '' then begin
          GLSetup.Get;
          Clear(Country);
          Country."Address Format" := GLSetup."Local Address Format";
          Country."Contact Address Format" := GLSetup."Local Cont. Addr. Format";
        end else
          Country.Get(CountryCode);

        case Country."Contact Address Format" of
          Country."contact address format"::First:
            begin
              NameLineNo := 2;
              Name2LineNo := 3;
              ContLineNo := 1;
              AddrLineNo := 4;
              Addr2LineNo := 5;
              PostCodeCityLineNo := 6;
              CountyLineNo := 7;
              CountryLineNo := 8;
            end;
          Country."contact address format"::"After Company Name":
            begin
              NameLineNo := 1;
              Name2LineNo := 2;
              ContLineNo := 3;
              AddrLineNo := 4;
              Addr2LineNo := 5;
              PostCodeCityLineNo := 6;
              CountyLineNo := 7;
              CountryLineNo := 8;
            end;
          Country."contact address format"::Last:
            begin
              NameLineNo := 1;
              Name2LineNo := 2;
              ContLineNo := 8;
              AddrLineNo := 3;
              Addr2LineNo := 4;
              PostCodeCityLineNo := 5;
              CountyLineNo := 6;
              CountryLineNo := 7;
            end;
        end;

        AddrArray[NameLineNo] := Name;
        AddrArray[Name2LineNo] := Name2;
        AddrArray[AddrLineNo] := Addr;
        AddrArray[Addr2LineNo] := Addr2;

        case Country."Address Format" of
          Country."address format"::"Post Code+City",
          Country."address format"::"City+County+Post Code",
          Country."address format"::"City+County+New Line+Post Code",
          Country."address format"::"Post Code+City+County",
          Country."address format"::"City+Post Code":
            begin
              AddrArray[ContLineNo] := Contact;
              GeneratePostCodeCity(AddrArray[PostCodeCityLineNo],AddrArray[CountyLineNo],City,PostCode,County,Country);
              AddrArray[CountryLineNo] := Country.Name;
              CompressArray(AddrArray);
            end;
          Country."address format"::"Blank Line+Post Code+City":
            begin
              if ContLineNo < PostCodeCityLineNo then
                AddrArray[ContLineNo] := Contact;
              CompressArray(AddrArray);

              Index := 1;
              InsertText := 1;
              repeat
                if AddrArray[Index] = '' then begin
                  case InsertText of
                    2:
                      GeneratePostCodeCity(AddrArray[Index],AddrArray[Index + 1],City,PostCode,County,Country);
                    3:
                      AddrArray[Index] := Country.Name;
                    4:
                      if ContLineNo > PostCodeCityLineNo then
                        AddrArray[Index] := Contact;
                  end;
                  InsertText := InsertText + 1;
                end;
                Index := Index + 1;
              until Index = 9;
            end;
        end;
    end;


    procedure FormatPostCodeCity(var PostCodeCityText: Text[90];var CountyText: Text[50];City: Text[50];PostCode: Code[20];County: Text[50];CountryCode: Code[10])
    var
        Country: Record "Country/Region";
    begin
        Clear(PostCodeCityText);
        Clear(CountyText);

        if CountryCode = '' then begin
          GLSetup.Get;
          Clear(Country);
          Country."Address Format" := GLSetup."Local Address Format";
          Country."Contact Address Format" := GLSetup."Local Cont. Addr. Format";
        end else
          Country.Get(CountryCode);

        GeneratePostCodeCity(PostCodeCityText,CountyText,City,PostCode,County,Country);
    end;

    local procedure GeneratePostCodeCity(var PostCodeCityText: Text[90];var CountyText: Text[50];City: Text[50];PostCode: Code[20];County: Text[50];Country: Record "Country/Region")
    var
        DummyString: Text;
        OverMaxStrLen: Integer;
    begin
        DummyString := '';
        OverMaxStrLen := MaxStrLen(PostCodeCityText);
        if OverMaxStrLen < MaxStrLen(DummyString) then
          OverMaxStrLen += 1;

        case Country."Address Format" of
          Country."address format"::"Post Code+City":
            begin
              if PostCode <> '' then
                PostCodeCityText := DelStr(PostCode + ' ' + City,OverMaxStrLen)
              else
                PostCodeCityText := City;
              CountyText := County;
            end;
          Country."address format"::"City+County+Post Code":
            begin
              CountyText := '';
              if PostCode = '' then begin
                if County = '' then
                  PostCodeCityText := City
                else
                  PostCodeCityText := DelStr(City,MaxStrLen(PostCodeCityText) - StrLen(County) - 2) + ', ' + County;
              end else
                if County = '' then
                  PostCodeCityText := DelStr(City,MaxStrLen(PostCodeCityText) - StrLen(PostCode) - 1) + ', ' + PostCode
                else
                  PostCodeCityText :=
                    DelStr(City,MaxStrLen(PostCodeCityText) - StrLen(PostCode) - StrLen(County) - 4) +
                    ', ' + County + '  ' + PostCode;
            end;
          Country."address format"::"City+County+New Line+Post Code":
            begin
              CountyText := PostCode;
              if County = '' then
                PostCodeCityText := City
              else
                PostCodeCityText := DelStr(City,MaxStrLen(PostCodeCityText) - StrLen(County) - 2) + ', ' + County;
            end;
          Country."address format"::"Post Code+City+County":
            begin
              if PostCode <> '' then
                PostCodeCityText := DelStr(PostCode + ' ' + City + ', ' + County,OverMaxStrLen)
              else
                PostCodeCityText := DelStr(City + ', ' + County,OverMaxStrLen);
            end;
          Country."address format"::"City+Post Code":
            begin
              if PostCode <> '' then
                PostCodeCityText := DelStr(City,MaxStrLen(PostCodeCityText) - StrLen(PostCode) - 1) + ', ' + PostCode
              else
                PostCodeCityText := City;
              CountyText := County;
            end;
          Country."address format"::"Blank Line+Post Code+City":
            begin
              if PostCode <> '' then
                PostCodeCityText := DelStr(PostCode + ' ' + City,OverMaxStrLen)
              else
                PostCodeCityText := City;
              CountyText := County;
            end;
        end;
    end;


    procedure GetCompanyAddr(RespCenterCode: Code[10];var ResponsibilityCenter: Record "Responsibility Center";var CompanyInfo: Record "Company Information";var CompanyAddr: array [8] of Text[50])
    begin
        if ResponsibilityCenter.Get(RespCenterCode) then begin
          RespCenter(CompanyAddr,ResponsibilityCenter);
          CompanyInfo."Phone No." := ResponsibilityCenter."Phone No.";
          CompanyInfo."Fax No." := ResponsibilityCenter."Fax No.";
        end else
          Company(CompanyAddr,CompanyInfo);
    end;


    procedure Company(var AddrArray: array [8] of Text[50];var CompanyInfo: Record "Company Information")
    begin
        with CompanyInfo do
          FormatAddr(
            AddrArray,Name,"Name 2",'',Address,"Address 2",
            City,"Post Code",County,'');
    end;


    procedure Customer(var AddrArray: array [8] of Text[50];var Cust: Record Customer)
    begin
        with Cust do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure Vendor(var AddrArray: array [8] of Text[50];var Vend: Record Vendor)
    begin
        with Vend do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure BankAcc(var AddrArray: array [8] of Text[50];var BankAcc: Record "Bank Account")
    begin
        with BankAcc do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure SalesHeaderSellTo(var AddrArray: array [8] of Text[50];var SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do
          FormatAddr(
            AddrArray,"Sell-to Customer Name","Sell-to Customer Name 2","Sell-to Contact","Sell-to Address","Sell-to Address 2",
            "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code");
    end;


    procedure SalesHeaderBillTo(var AddrArray: array [8] of Text[50];var SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
    end;


    procedure SalesHeaderShipTo(var AddrArray: array [8] of Text[50];CustAddr: array [8] of Text[50];var SalesHeader: Record "Sales Header") ShowShippingAddr: Boolean
    var
        CountryRegion: Record "Country/Region";
        SellToCountry: Code[50];
    begin
        with SalesHeader do begin
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
          if CountryRegion.Get("Sell-to Country/Region Code") then
            SellToCountry := CountryRegion.Name;
          ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
          for i := 1 to ArrayLen(AddrArray) do
            if (AddrArray[i] <> CustAddr[i]) and (AddrArray[i] <> '') and (AddrArray[i] <> SellToCountry) then
              ShowShippingAddr := true;
        end;
    end;


    procedure PurchHeaderBuyFrom(var AddrArray: array [8] of Text[50];var PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do
          FormatAddr(
            AddrArray,"Buy-from Vendor Name","Buy-from Vendor Name 2","Buy-from Contact","Buy-from Address","Buy-from Address 2",
            "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code");
    end;


    procedure PurchHeaderPayTo(var AddrArray: array [8] of Text[50];var PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do
          FormatAddr(
            AddrArray,"Pay-to Name","Pay-to Name 2","Pay-to Contact","Pay-to Address","Pay-to Address 2",
            "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code");
    end;


    procedure PurchHeaderShipTo(var AddrArray: array [8] of Text[50];var PurchHeader: Record "Purchase Header")
    begin
        with PurchHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure SalesShptSellTo(var AddrArray: array [8] of Text[50];var SalesShptHeader: Record "Sales Shipment Header")
    begin
        with SalesShptHeader do
          FormatAddr(
            AddrArray,"Sell-to Customer Name","Sell-to Customer Name 2","Sell-to Contact","Sell-to Address","Sell-to Address 2",
            "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code");
    end;


    procedure SalesShptBillTo(var AddrArray: array [8] of Text[50];ShipToAddr: array [8] of Text[50];var SalesShptHeader: Record "Sales Shipment Header") ShowCustAddr: Boolean
    begin
        with SalesShptHeader do begin
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
          ShowCustAddr := "Bill-to Customer No." <> "Sell-to Customer No.";
          for i := 1 to ArrayLen(AddrArray) do
            if ShipToAddr[i] <> AddrArray[i] then
              ShowCustAddr := true;
        end;
    end;


    procedure SalesShptShipTo(var AddrArray: array [8] of Text[50];var SalesShptHeader: Record "Sales Shipment Header")
    begin
        with SalesShptHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure SalesInvSellTo(var AddrArray: array [8] of Text[50];var SalesInvHeader: Record "Sales Invoice Header")
    begin
        with SalesInvHeader do
          FormatAddr(
            AddrArray,"Sell-to Customer Name","Sell-to Customer Name 2","Sell-to Contact","Sell-to Address","Sell-to Address 2",
            "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code");
    end;


    procedure SalesInvBillTo(var AddrArray: array [8] of Text[50];var SalesInvHeader: Record "Sales Invoice Header")
    begin
        with SalesInvHeader do
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
    end;


    procedure SalesInvShipTo(var AddrArray: array [8] of Text[50];CustAddr: array [8] of Text[50];var SalesInvHeader: Record "Sales Invoice Header") ShowShippingAddr: Boolean
    begin
        with SalesInvHeader do begin
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
          ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
          for i := 1 to ArrayLen(AddrArray) do
            if AddrArray[i] <> CustAddr[i] then
              ShowShippingAddr := true;
        end;
    end;


    procedure SalesCrMemoSellTo(var AddrArray: array [8] of Text[50];var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        with SalesCrMemoHeader do
          FormatAddr(
            AddrArray,"Sell-to Customer Name","Sell-to Customer Name 2","Sell-to Contact","Sell-to Address","Sell-to Address 2",
            "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code");
    end;


    procedure SalesCrMemoBillTo(var AddrArray: array [8] of Text[50];var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        with SalesCrMemoHeader do
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
    end;


    procedure SalesCrMemoShipTo(var AddrArray: array [8] of Text[50];CustAddr: array [8] of Text[50];var SalesCrMemoHeader: Record "Sales Cr.Memo Header") ShowShippingAddr: Boolean
    begin
        with SalesCrMemoHeader do begin
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
          ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
          for i := 1 to ArrayLen(AddrArray) do
            if AddrArray[i] <> CustAddr[i] then
              ShowShippingAddr := true;
        end;
    end;


    procedure SalesRcptSellTo(var AddrArray: array [8] of Text[50];var ReturnRcptHeader: Record "Return Receipt Header")
    begin
        with ReturnRcptHeader do
          FormatAddr(
            AddrArray,"Sell-to Customer Name","Sell-to Customer Name 2","Sell-to Contact","Sell-to Address","Sell-to Address 2",
            "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code");
    end;


    procedure SalesRcptBillTo(var AddrArray: array [8] of Text[50];ShipToAddr: array [8] of Text[50];var ReturnRcptHeader: Record "Return Receipt Header") ShowCustAddr: Boolean
    begin
        with ReturnRcptHeader do begin
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
          ShowCustAddr := "Bill-to Customer No." <> "Sell-to Customer No.";
          for i := 1 to ArrayLen(AddrArray) do
            if AddrArray[i] <> ShipToAddr[i] then
              ShowCustAddr := true;
        end;
    end;


    procedure SalesRcptShipTo(var AddrArray: array [8] of Text[50];var ReturnRcptHeader: Record "Return Receipt Header")
    begin
        with ReturnRcptHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure PurchRcptBuyFrom(var AddrArray: array [8] of Text[50];var PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        with PurchRcptHeader do
          FormatAddr(
            AddrArray,"Buy-from Vendor Name","Buy-from Vendor Name 2","Buy-from Contact","Buy-from Address","Buy-from Address 2",
            "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code");
    end;


    procedure PurchRcptPayTo(var AddrArray: array [8] of Text[50];var PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        with PurchRcptHeader do
          FormatAddr(
            AddrArray,"Pay-to Name","Pay-to Name 2","Pay-to Contact","Pay-to Address","Pay-to Address 2",
            "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code");
    end;


    procedure PurchRcptShipTo(var AddrArray: array [8] of Text[50];var PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        with PurchRcptHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure PurchInvBuyFrom(var AddrArray: array [8] of Text[50];var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        with PurchInvHeader do
          FormatAddr(
            AddrArray,"Buy-from Vendor Name","Buy-from Vendor Name 2","Buy-from Contact","Buy-from Address","Buy-from Address 2",
            "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code");
    end;


    procedure PurchInvPayTo(var AddrArray: array [8] of Text[50];var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        with PurchInvHeader do
          FormatAddr(
            AddrArray,"Pay-to Name","Pay-to Name 2","Pay-to Contact","Pay-to Address","Pay-to Address 2",
            "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code");
    end;


    procedure PurchInvShipTo(var AddrArray: array [8] of Text[50];var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        with PurchInvHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure PurchCrMemoBuyFrom(var AddrArray: array [8] of Text[50];var PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.")
    begin
        with PurchCrMemoHeader do
          FormatAddr(
            AddrArray,"Buy-from Vendor Name","Buy-from Vendor Name 2","Buy-from Contact","Buy-from Address","Buy-from Address 2",
            "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code");
    end;


    procedure PurchCrMemoPayTo(var AddrArray: array [8] of Text[50];var PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.")
    begin
        with PurchCrMemoHeader do
          FormatAddr(
            AddrArray,"Pay-to Name","Pay-to Name 2","Pay-to Contact","Pay-to Address","Pay-to Address 2",
            "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code");
    end;


    procedure PurchCrMemoShipTo(var AddrArray: array [8] of Text[50];var PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.")
    begin
        with PurchCrMemoHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure PurchShptBuyFrom(var AddrArray: array [8] of Text[50];var ReturnShptHeader: Record "Return Shipment Header")
    begin
        with ReturnShptHeader do
          FormatAddr(
            AddrArray,"Buy-from Vendor Name","Buy-from Vendor Name 2","Buy-from Contact","Buy-from Address","Buy-from Address 2",
            "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code");
    end;


    procedure PurchShptPayTo(var AddrArray: array [8] of Text[50];var ReturnShptHeader: Record "Return Shipment Header")
    begin
        with ReturnShptHeader do
          FormatAddr(
            AddrArray,"Pay-to Name","Pay-to Name 2","Pay-to Contact","Pay-to Address","Pay-to Address 2",
            "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code");
    end;


    procedure PurchShptShipTo(var AddrArray: array [8] of Text[50];var ReturnShptHeader: Record "Return Shipment Header")
    begin
        with ReturnShptHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure AltAddr(var AddrArray: array [8] of Text[50];var Employee: Record Employee;var AlternativeAddr: Record "Alternative Address")
    begin
        with AlternativeAddr do
          FormatAddr(
            AddrArray,CopyStr(Employee.FullName,1,50),'','',Address,
            "Address 2",City,"Post Code",County,"Country/Region Code");
    end;


    procedure Employee(var AddrArray: array [8] of Text[50];var Employee: Record Employee)
    begin
        with Employee do
          FormatAddr(
            AddrArray,CopyStr(FullName,1,50),'','',Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure EmployeeAltAddr(var AddrArray: array [8] of Text[50];var Employee: Record Employee)
    var
        AlternativeAddr: Record "Alternative Address";
    begin
        AlternativeAddr.Get(Employee."No.",Employee."Alt. Address Code");
        with AlternativeAddr do
          FormatAddr(
            AddrArray,CopyStr(Employee.FullName,1,50),'','',Address,
            "Address 2",City,"Post Code",County,"Country/Region Code");
    end;


    procedure VendBankAcc(var AddrArray: array [8] of Text[50];var VendBankAcc: Record "Vendor Bank Account")
    begin
        with VendBankAcc do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure CustBankAcc(var AddrArray: array [8] of Text[50];var CustBankAcc: Record "Customer Bank Account")
    begin
        with CustBankAcc do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure RespCenter(var AddrArray: array [8] of Text[50];var RespCenter: Record "Responsibility Center")
    begin
        with RespCenter do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure TransferShptTransferFrom(var AddrArray: array [8] of Text[50];var TransShptHeader: Record "Transfer Shipment Header")
    begin
        with TransShptHeader do
          FormatAddr(
            AddrArray,"Transfer-from Name","Transfer-from Name 2","Transfer-from Contact","Transfer-from Address",
            "Transfer-from Address 2",
            "Transfer-from City","Transfer-from Post Code","Transfer-from County","Trsf.-from Country/Region Code");
    end;


    procedure TransferShptTransferTo(var AddrArray: array [8] of Text[50];var TransShptHeader: Record "Transfer Shipment Header")
    begin
        with TransShptHeader do
          FormatAddr(
            AddrArray,"Transfer-to Name","Transfer-to Name 2","Transfer-to Contact","Transfer-to Address","Transfer-to Address 2",
            "Transfer-to City","Transfer-to Post Code","Transfer-to County","Trsf.-to Country/Region Code");
    end;


    procedure TransferRcptTransferFrom(var AddrArray: array [8] of Text[50];var TransRcptHeader: Record "Transfer Receipt Header")
    begin
        with TransRcptHeader do
          FormatAddr(
            AddrArray,"Transfer-from Name","Transfer-from Name 2","Transfer-from Contact","Transfer-from Address",
            "Transfer-from Address 2",
            "Transfer-from City","Transfer-from Post Code","Transfer-from County","Trsf.-from Country/Region Code");
    end;


    procedure TransferRcptTransferTo(var AddrArray: array [8] of Text[50];var TransRcptHeader: Record "Transfer Receipt Header")
    begin
        with TransRcptHeader do
          FormatAddr(
            AddrArray,"Transfer-to Name","Transfer-to Name 2","Transfer-to Contact","Transfer-to Address","Transfer-to Address 2",
            "Transfer-to City","Transfer-to Post Code","Transfer-to County","Trsf.-to Country/Region Code");
    end;


    procedure TransferHeaderTransferFrom(var AddrArray: array [8] of Text[50];var TransHeader: Record "Transfer Header")
    begin
        with TransHeader do
          FormatAddr(
            AddrArray,"Transfer-from Name","Transfer-from Name 2","Transfer-from Contact","Transfer-from Address",
            "Transfer-from Address 2",
            "Transfer-from City","Transfer-from Post Code","Transfer-from County","Trsf.-from Country/Region Code");
    end;


    procedure TransferHeaderTransferTo(var AddrArray: array [8] of Text[50];var TransHeader: Record "Transfer Header")
    begin
        with TransHeader do
          FormatAddr(
            AddrArray,"Transfer-to Name","Transfer-to Name 2","Transfer-to Contact","Transfer-to Address","Transfer-to Address 2",
            "Transfer-to City","Transfer-to Post Code","Transfer-to County","Trsf.-to Country/Region Code");
    end;


    procedure ContactAddr(var AddrArray: array [8] of Text[50];var Cont: Record Contact)
    begin
        ContactAddrAlt(AddrArray,Cont,Cont.ActiveAltAddress(WorkDate),WorkDate)
    end;


    procedure ContactAddrAlt(var AddrArray: array [8] of Text[50];var Cont: Record Contact;AltAddressCode: Code[10];ActiveDate: Date)
    var
        RMSetup: Record "Marketing Setup";
        ContCompany: Record Contact;
        ContAltAddr: Record "Contact Alt. Address";
        CompanyAltAddressCode: Code[10];
        ContIdenticalAddress: Boolean;
    begin
        RMSetup.Get;

        if (Cont.Type = Cont.Type::Person) and (Cont."Company No." <> '') then begin
          ContCompany.Get(Cont."Company No.");
          CompanyAltAddressCode := ContCompany.ActiveAltAddress(ActiveDate);
          ContIdenticalAddress := Cont.IdenticalAddress(ContCompany);
        end;

        case true of
          AltAddressCode <> '':
            with ContAltAddr do begin
              Get(Cont."No.",AltAddressCode);
              FormatAddr(
                AddrArray,"Company Name","Company Name 2",Cont.Name,Address,"Address 2",
                City,"Post Code",County,"Country/Region Code");
            end;
          (Cont.Type = Cont.Type::Person) and
          (Cont."Company No." <> '') and
          (CompanyAltAddressCode <> '') and
          RMSetup."Inherit Address Details" and
          ContIdenticalAddress:
            with ContAltAddr do begin
              Get(Cont."Company No.",CompanyAltAddressCode);
              FormatAddr(
                AddrArray,"Company Name","Company Name 2",Cont.Name,Address,"Address 2",
                City,"Post Code",County,"Country/Region Code");
            end;
          (Cont.Type = Cont.Type::Person) and
          (Cont."Company No." <> ''):
            with Cont do
              FormatAddr(
                AddrArray,ContCompany.Name,ContCompany."Name 2",Name,Address,"Address 2",
                City,"Post Code",County,"Country/Region Code")
          else
            with Cont do
              FormatAddr(
                AddrArray,Name,"Name 2",'',Address,"Address 2",
                City,"Post Code",County,"Country/Region Code")
        end;
    end;


    procedure ServiceOrderSellto(var AddrArray: array [8] of Text[50];ServHeader: Record "Service Header")
    begin
        with ServHeader do
          FormatAddr(
            AddrArray,Name,"Name 2","Contact Name",Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure ServiceOrderShipto(var AddrArray: array [8] of Text[50];ServHeader: Record "Service Header")
    begin
        with ServHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure ServContractSellto(var AddrArray: array [8] of Text[50];ServContract: Record "Service Contract Header")
    begin
        with ServContract do begin
          CalcFields(Name,"Name 2",Address,"Address 2","Post Code",City,County,"Country/Region Code");
          FormatAddr(
            AddrArray,Name,"Name 2","Contact Name",Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
        end;
    end;


    procedure ServContractShipto(var AddrArray: array [8] of Text[50];ServContract: Record "Service Contract Header")
    begin
        with ServContract do begin
          CalcFields(
            "Ship-to Name","Ship-to Name 2","Ship-to Address","Ship-to Address 2",
            "Ship-to Post Code","Ship-to City","Ship-to County","Ship-to Country/Region Code");
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Contact Name","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
        end;
    end;


    procedure ServiceInvBillTo(var AddrArray: array [8] of Text[50];var ServiceInvHeader: Record "Service Invoice Header")
    begin
        with ServiceInvHeader do
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
    end;


    procedure ServiceInvShipTo(var AddrArray: array [8] of Text[50];CustAddr: array [8] of Text[50];var ServiceInvHeader: Record "Service Invoice Header") ShowShippingAddr: Boolean
    begin
        with ServiceInvHeader do begin
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
          ShowShippingAddr := "Customer No." <> "Bill-to Customer No.";
          for i := 1 to ArrayLen(AddrArray) do
            if AddrArray[i] <> CustAddr[i] then
              ShowShippingAddr := true;
        end;
    end;


    procedure ServiceShptShipTo(var AddrArray: array [8] of Text[50];var ServiceShptHeader: Record "Service Shipment Header")
    begin
        with ServiceShptHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure ServiceShptSellTo(var AddrArray: array [8] of Text[50];var ServiceShptHeader: Record "Service Shipment Header")
    begin
        with ServiceShptHeader do
          FormatAddr(
            AddrArray,Name,"Name 2","Contact Name",Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure ServiceShptBillTo(var AddrArray: array [8] of Text[50];ShipToAddr: array [8] of Text[50];var ServiceShptHeader: Record "Service Shipment Header") ShowCustAddr: Boolean
    begin
        with ServiceShptHeader do begin
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
          ShowCustAddr := "Bill-to Customer No." <> "Customer No.";
          for i := 1 to ArrayLen(AddrArray) do
            if ShipToAddr[i] <> AddrArray[i] then
              ShowCustAddr := true;
        end;
    end;


    procedure ServiceCrMemoBillTo(var AddrArray: array [8] of Text[50];var ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    begin
        with ServiceCrMemoHeader do
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
    end;


    procedure ServiceCrMemoShipTo(var AddrArray: array [8] of Text[50];CustAddr: array [8] of Text[50];var ServiceCrMemoHeader: Record "Service Cr.Memo Header") ShowShippingAddr: Boolean
    begin
        with ServiceCrMemoHeader do begin
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
          ShowShippingAddr := "Customer No." <> "Bill-to Customer No.";
          for i := 1 to ArrayLen(AddrArray) do
            if AddrArray[i] <> CustAddr[i] then
              ShowShippingAddr := true;
        end;
    end;


    procedure ServiceHeaderSellTo(var AddrArray: array [8] of Text[50];var ServiceHeader: Record "Service Header")
    begin
        with ServiceHeader do
          FormatAddr(
            AddrArray,Name,"Name 2","Contact No.",Address,"Address 2",
            City,"Post Code",County,"Country/Region Code");
    end;


    procedure ServiceHeaderBillTo(var AddrArray: array [8] of Text[50];var ServiceHeader: Record "Service Header")
    begin
        with ServiceHeader do
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
    end;


    procedure ServiceHeaderShipTo(var AddrArray: array [8] of Text[50];var ServiceHeader: Record "Service Header")
    begin
        with ServiceHeader do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure PostalBarCode(AddressType: Option): Text[100]
    begin
        if AddressType = AddressType then
          exit('');
        exit('');
    end;


    procedure SalesHeaderArchBillTo(var AddrArray: array [8] of Text[50];var SalesHeaderArch: Record "Sales Header Archive")
    begin
        with SalesHeaderArch do
          FormatAddr(
            AddrArray,"Bill-to Name","Bill-to Name 2","Bill-to Contact","Bill-to Address","Bill-to Address 2",
            "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code");
    end;


    procedure SalesHeaderArchShipTo(var AddrArray: array [8] of Text[50];CustAddr: array [8] of Text[50];var SalesHeaderArch: Record "Sales Header Archive") ShowShippingAddr: Boolean
    var
        CountryRegion: Record "Country/Region";
        SellToCountry: Code[50];
    begin
        with SalesHeaderArch do begin
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
          ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
          if CountryRegion.Get("Sell-to Country/Region Code") then
            SellToCountry := CountryRegion.Name;
          for i := 1 to ArrayLen(AddrArray) do
            if (AddrArray[i] <> CustAddr[i]) and (AddrArray[i] <> '') and (AddrArray[i] <> SellToCountry) then
              ShowShippingAddr := true;
        end;
    end;


    procedure PurchHeaderBuyFromArch(var AddrArray: array [8] of Text[50];var PurchHeaderArch: Record "Purchase Header Archive")
    begin
        with PurchHeaderArch do
          FormatAddr(
            AddrArray,"Buy-from Vendor Name","Buy-from Vendor Name 2","Buy-from Contact","Buy-from Address","Buy-from Address 2",
            "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code");
    end;


    procedure PurchHeaderPayToArch(var AddrArray: array [8] of Text[50];var PurchHeaderArch: Record "Purchase Header Archive")
    begin
        with PurchHeaderArch do
          FormatAddr(
            AddrArray,"Pay-to Name","Pay-to Name 2","Pay-to Contact","Pay-to Address","Pay-to Address 2",
            "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code");
    end;


    procedure PurchHeaderShipToArch(var AddrArray: array [8] of Text[50];var PurchHeaderArch: Record "Purchase Header Archive")
    begin
        with PurchHeaderArch do
          FormatAddr(
            AddrArray,"Ship-to Name","Ship-to Name 2","Ship-to Contact","Ship-to Address","Ship-to Address 2",
            "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code");
    end;


    procedure Reminder(var AddrArray: array [8] of Text[50];var ReminderHeader: Record "Reminder Header")
    begin
        with ReminderHeader do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
    end;


    procedure IssuedReminder(var AddrArray: array [8] of Text[50];var IssuedReminderHeader: Record "Issued Reminder Header")
    begin
        with IssuedReminderHeader do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
    end;


    procedure FinanceChargeMemo(var AddrArray: array [8] of Text[50];var FinanceChargeMemoHeader: Record "Finance Charge Memo Header")
    begin
        with FinanceChargeMemoHeader do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
    end;


    procedure IssuedFinanceChargeMemo(var AddrArray: array [8] of Text[50];var IssuedFinChargeMemoHeader: Record "Issued Fin. Charge Memo Header")
    begin
        with IssuedFinChargeMemoHeader do
          FormatAddr(
            AddrArray,Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
    end;
}

