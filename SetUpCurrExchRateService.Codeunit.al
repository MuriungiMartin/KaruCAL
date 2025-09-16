#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1242 "Set Up Curr Exch Rate Service"
{

    trigger OnRun()
    var
        Currency: Record Currency;
        CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup";
        GLSetup: Record "General Ledger Setup";
    begin
        if Currency.IsEmpty then
          exit;
        if not CurrExchRateUpdateSetup.IsEmpty then
          exit;

        GLSetup.Get;
        if GLSetup."LCY Code" <> '' then
          SetupYahooDataExchange(CurrExchRateUpdateSetup,GetYahooURI);
        if GLSetup."LCY Code" = 'EUR' then
          SetupECBDataExchange(CurrExchRateUpdateSetup,GetECB_URI);
        Commit;
    end;

    var
        DummyDataExchColumnDef: Record "Data Exch. Column Def";
        DummyCurrExchRate: Record "Currency Exchange Rate";
        YAHOO_EXCH_RATESTxt: label 'YAHOO-EXCHANGE-RATES', Comment='Yahoo Currency Exchange Rate Code';
        ECB_EXCH_RATESTxt: label 'ECB-EXCHANGE-RATES', Comment='European Central Bank Currency Exchange Rate Code';
        YAHOO_EXCH_RATESDescTxt: label 'Yahoo Currency Exchange Rates Setup';
        ECB_EXCH_RATESDescTxt: label 'European Central Bank Currency Exchange Rates Setup';
        YahooFinanceURLTxt: label 'http://query.yahooapis.com/v1/public/yql?%1&env=store://datatables.org/alltableswithkeys', Locked=true;
        ECB_URLTxt: label 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml', Locked=true;
        YahooFinanceTermsOfUseTxt: label 'https://policies.yahoo.com/us/en/yahoo/terms/product-atos/yql/index.htm', Locked=true;
        YahooServiceProviderTxt: label 'Yahoo!', Locked=true;
        ECBServiceProviderTxt: label 'European Central Bank';


    procedure SetupYahooDataExchange(var CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup";PathToYahooService: Text)
    var
        DataExchLineDef: Record "Data Exch. Line Def";
        SuggestColDefinitionXML: Codeunit "Suggest Col. Definition - XML";
    begin
        DataExchLineDef.SetRange("Data Exch. Def Code",YAHOO_EXCH_RATESTxt);
        if DataExchLineDef.FindFirst then;

        CreateCurrencyExchangeSetup(
          CurrExchRateUpdateSetup,YAHOO_EXCH_RATESTxt,YAHOO_EXCH_RATESDescTxt,
          DataExchLineDef."Data Exch. Def Code",YahooServiceProviderTxt,YahooFinanceTermsOfUseTxt);

        if StrPos(PathToYahooService,'http') = 1 then
          CurrExchRateUpdateSetup.SetWebServiceURL(PathToYahooService);

        if DataExchLineDef."Data Exch. Def Code" = '' then begin
          CreateExchLineDef(DataExchLineDef,CurrExchRateUpdateSetup."Data Exch. Def Code",GetYahooRepeaterPath);
          SuggestColDefinitionXML.GenerateDataExchColDef(PathToYahooService,DataExchLineDef);

          MapYahooDataExch(DataExchLineDef);
        end;
        Commit;
    end;


    procedure SetupECBDataExchange(var CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup";PathToECBService: Text)
    var
        DataExchLineDef: Record "Data Exch. Line Def";
        SuggestColDefinitionXML: Codeunit "Suggest Col. Definition - XML";
    begin
        DataExchLineDef.SetRange("Data Exch. Def Code",ECB_EXCH_RATESTxt);
        if DataExchLineDef.FindFirst then;

        CreateCurrencyExchangeSetup(
          CurrExchRateUpdateSetup,ECB_EXCH_RATESTxt,ECB_EXCH_RATESDescTxt,
          DataExchLineDef."Data Exch. Def Code",ECBServiceProviderTxt,'');

        if StrPos(PathToECBService,'http') = 1 then
          CurrExchRateUpdateSetup.SetWebServiceURL(PathToECBService);

        if DataExchLineDef."Data Exch. Def Code" = '' then begin
          CreateExchLineDef(DataExchLineDef,CurrExchRateUpdateSetup."Data Exch. Def Code",GetECBRepeaterPath);
          SuggestColDefinitionXML.GenerateDataExchColDef(PathToECBService,DataExchLineDef);

          MapECBDataExch(DataExchLineDef);
        end;
        Commit;
    end;

    local procedure CreateCurrencyExchangeSetup(var CurrExchRateUpdateSetup: Record "Curr. Exch. Rate Update Setup";NewCode: Code[20];NewDesc: Text[250];NewDataExchCode: Code[20];NewServiceProvider: Text[30];NewTermOfUse: Text[250])
    begin
        CurrExchRateUpdateSetup.Init;
        CurrExchRateUpdateSetup.Validate("Data Exch. Def Code",NewDataExchCode);
        CurrExchRateUpdateSetup.Validate(Code,NewCode);
        CurrExchRateUpdateSetup.Validate(Description,NewDesc);
        CurrExchRateUpdateSetup.Validate("Service Provider",NewServiceProvider);
        CurrExchRateUpdateSetup.Validate("Terms of Service",NewTermOfUse);
        CurrExchRateUpdateSetup.Insert(true);
    end;


    procedure GetYahooURI(): Text
    var
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        QueryText: Text;
        CurrencyPairText: Text;
    begin
        GLSetup.Get;
        GLSetup.TestField("LCY Code");
        Currency.SetFilter(Code,'<>%1',GLSetup."LCY Code");
        Currency.FindSet;
        repeat
          if CurrencyPairText <> '' then
            CurrencyPairText := CurrencyPairText + ',';
          CurrencyPairText := CurrencyPairText + StrSubstNo('"%1%2"',GLSetup."LCY Code",Currency.Code);
        until Currency.Next = 0;

        QueryText :=
          StrSubstNo(
            'q=select * from yahoo.finance.xchange where pair in (%1)',CurrencyPairText);

        exit(StrSubstNo(YahooFinanceURLTxt,QueryText));
    end;


    procedure GetECB_URI(): Text
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        GLSetup.TestField("LCY Code",'EUR');
        exit(ECB_URLTxt);
    end;

    local procedure CreateExchLineDef(var DataExchLineDef: Record "Data Exch. Line Def";DataExchDefCode: Code[20];RepeaterPath: Text[250])
    begin
        DataExchLineDef.SetRange("Data Exch. Def Code",DataExchDefCode);
        DataExchLineDef.FindFirst;
        DataExchLineDef.Validate("Data Line Tag",RepeaterPath);
        DataExchLineDef.Modify(true);
    end;

    local procedure CreateExchMappingLine(DataExchMapping: Record "Data Exch. Mapping";FromColumnName: Text[250];ToFieldNo: Integer;DataType: Option;NewMultiplier: Decimal;NewDataFormat: Text[10];NewTransformationRule: Code[20];NewDefaultValue: Text[250])
    var
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
        DataExchColumnDef: Record "Data Exch. Column Def";
    begin
        with DataExchColumnDef do begin
          SetRange("Data Exch. Def Code",DataExchMapping."Data Exch. Def Code");
          SetRange("Data Exch. Line Def Code",DataExchMapping."Data Exch. Line Def Code");
          if NewDefaultValue <> '' then begin
            if FindLast then begin
              Init;
              "Column No." += 10000;
              Insert;
            end
          end else begin
            SetRange(Name,FromColumnName);
            FindFirst;
          end;
          Validate("Data Type",DataType);
          Validate("Data Format",NewDataFormat);
          Modify(true);
        end;

        with DataExchFieldMapping do begin
          Init;
          Validate("Data Exch. Def Code",DataExchMapping."Data Exch. Def Code");
          Validate("Data Exch. Line Def Code",DataExchMapping."Data Exch. Line Def Code");
          Validate("Table ID",DataExchMapping."Table ID");
          Validate("Column No.",DataExchColumnDef."Column No.");
          Validate("Field ID",ToFieldNo);
          Validate(Multiplier,NewMultiplier);
          Validate("Transformation Rule",NewTransformationRule);
          Validate("Default Value",NewDefaultValue);
          Insert(true);
        end;
    end;

    local procedure MapYahooDataExch(var DataExchLineDef: Record "Data Exch. Line Def")
    var
        DataExchMapping: Record "Data Exch. Mapping";
        TransformationRule: Record "Transformation Rule";
    begin
        DataExchMapping.Get(DataExchLineDef."Data Exch. Def Code",DataExchLineDef.Code,GetMappingTable);

        TransformationRule.CreateDefaultTransformations;
        CreateExchMappingLine(
          DataExchMapping,GetYahooCurrencyCodeXMLElement,GetCurrencyCodeFieldNo,
          DummyDataExchColumnDef."data type"::Text,1,'',TransformationRule.GetFourthToSixthSubstringCode,'');
        CreateExchMappingLine(
          DataExchMapping,GetYahooStartingDateXMLElement,GetStartingDateFieldNo,
          DummyDataExchColumnDef."data type"::Date,1,'',TransformationRule.GetUSDateFormatCode,'');

        CreateExchMappingLine(
          DataExchMapping,GetYahooExchRateAmtXMLElement,GetExchRateAmtFieldNo,
          DummyDataExchColumnDef."data type"::Decimal,1,'','','');
        CreateExchMappingLine(
          DataExchMapping,'',GetRelationalExchRateFieldNo,
          DummyDataExchColumnDef."data type"::Decimal,1,'','','1');
    end;

    local procedure MapECBDataExch(var DataExchLineDef: Record "Data Exch. Line Def")
    var
        DataExchMapping: Record "Data Exch. Mapping";
    begin
        DataExchMapping.Get(DataExchLineDef."Data Exch. Def Code",DataExchLineDef.Code,GetMappingTable);

        CreateExchMappingLine(
          DataExchMapping,GetECBCurrencyCodeXMLElement,GetCurrencyCodeFieldNo,
          DummyDataExchColumnDef."data type"::Text,1,'','','');
        CreateExchMappingLine(
          DataExchMapping,GetECBStartingDateXMLElement,GetStartingDateFieldNo,
          DummyDataExchColumnDef."data type"::Date,1,'','','');

        CreateExchMappingLine(
          DataExchMapping,GetECBExchRateXMLElement,GetExchRateAmtFieldNo,
          DummyDataExchColumnDef."data type"::Decimal,1,'','','');
        CreateExchMappingLine(
          DataExchMapping,'',GetRelationalExchRateFieldNo,
          DummyDataExchColumnDef."data type"::Decimal,1,'','','1');
    end;

    local procedure GetYahooRepeaterPath(): Text[250]
    begin
        exit('/query/results/rate');
    end;

    local procedure GetECBRepeaterPath(): Text[250]
    begin
        exit('/gesmes:Envelope/Cube/Cube/Cube');
    end;

    local procedure GetMappingTable(): Integer
    begin
        exit(Database::"Currency Exchange Rate")
    end;

    local procedure GetYahooCurrencyCodeXMLElement(): Text[250]
    begin
        exit('id');
    end;

    local procedure GetYahooExchRateAmtXMLElement(): Text[250]
    begin
        exit('Rate');
    end;

    local procedure GetYahooStartingDateXMLElement(): Text[250]
    begin
        exit('Date');
    end;

    local procedure GetECBCurrencyCodeXMLElement(): Text[250]
    begin
        exit('currency');
    end;

    local procedure GetECBExchRateXMLElement(): Text[250]
    begin
        exit('rate');
    end;

    local procedure GetECBStartingDateXMLElement(): Text[250]
    begin
        exit('time');
    end;

    local procedure GetCurrencyCodeFieldNo(): Integer
    begin
        exit(DummyCurrExchRate.FieldNo("Currency Code"));
    end;

    local procedure GetRelationalExchRateFieldNo(): Integer
    begin
        exit(DummyCurrExchRate.FieldNo("Relational Exch. Rate Amount"));
    end;

    local procedure GetExchRateAmtFieldNo(): Integer
    begin
        exit(DummyCurrExchRate.FieldNo("Exchange Rate Amount"));
    end;

    local procedure GetStartingDateFieldNo(): Integer
    begin
        exit(DummyCurrExchRate.FieldNo("Starting Date"));
    end;
}

