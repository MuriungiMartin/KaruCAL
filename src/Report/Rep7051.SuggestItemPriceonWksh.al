#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7051 "Suggest Item Price on Wksh."
{
    Caption = 'Suggest Item Price on Wksh.';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Vendor No.","Inventory Posting Group";
            column(ReportForNavId_8129; 8129)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");
                with SalesPriceWksh do begin
                  Init;
                  Validate("Item No.",Item."No.");

                  if not ("Unit of Measure Code" in [Item."Base Unit of Measure",'']) then
                    if not ItemUnitOfMeasure.Get("Item No.","Unit of Measure Code") then
                      CurrReport.Skip;

                  Validate("Unit of Measure Code",ToUnitofMeasure.Code);
                  "Current Unit Price" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        WorkDate,ToCurrency.Code,
                        Item."Unit Price",
                        CurrExchRate.ExchangeRate(
                          WorkDate,ToCurrency.Code)) *
                      UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"),
                      ToCurrency."Unit-Amount Rounding Precision");

                  if "Current Unit Price" > PriceLowerLimit then
                    "New Unit Price" := "Current Unit Price" * UnitPriceFactor;

                  if RoundingMethod.Code <> '' then begin
                    RoundingMethod."Minimum Amount" := "New Unit Price";
                    if RoundingMethod.Find('=<') then begin
                      "New Unit Price" := "New Unit Price" + RoundingMethod."Amount Added Before";
                      if RoundingMethod.Precision > 0 then
                        "New Unit Price" :=
                          ROUND(
                            "New Unit Price",
                            RoundingMethod.Precision,CopyStr('=><',RoundingMethod.Type + 1,1));
                      "New Unit Price" := "New Unit Price" + RoundingMethod."Amount Added After";
                    end;
                  end;

                  CalcCurrentPrice(PriceAlreadyExists);

                  if not PriceAlreadyExists then
                    "VAT Bus. Posting Gr. (Price)" := Item."VAT Bus. Posting Gr. (Price)";

                  if PriceAlreadyExists or CreateNewPrices then begin
                    SalesPriceWksh2 := SalesPriceWksh;
                    if SalesPriceWksh2.Find('=') then
                      Modify
                    else
                      Insert;
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text000);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Copy to Sales Price Worksheet...")
                    {
                        Caption = 'Copy to Sales Price Worksheet...';
                        field(ToSalesType;ToSalesType)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Sales Type';
                            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';

                            trigger OnValidate()
                            begin
                                SalesCodeCtrlEnable := ToSalesType <> Tosalestype::"All Customers";
                                ToStartDateCtrlEnable := ToSalesType <> Tosalestype::Campaign;
                                ToEndDateCtrlEnable := ToSalesType <> Tosalestype::Campaign;

                                ToSalesCode := '';
                                ToStartDate := 0D;
                                ToEndDate := 0D;
                            end;
                        }
                        field(SalesCodeCtrl;ToSalesCode)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Sales Code';
                            Enabled = SalesCodeCtrlEnable;

                            trigger OnLookup(var Text: Text): Boolean
                            var
                                CustList: Page "Customer List";
                                CustPriceGrList: Page "Customer Price Groups";
                                CampaignList: Page "Campaign List";
                            begin
                                case ToSalesType of
                                  Tosalestype::Customer:
                                    begin
                                      CustList.LookupMode := true;
                                      CustList.SetRecord(ToCust);
                                      if CustList.RunModal = Action::LookupOK then begin
                                        CustList.GetRecord(ToCust);
                                        ToSalesCode := ToCust."No.";
                                      end;
                                    end;
                                  Tosalestype::"Customer Price Group":
                                    begin
                                      CustPriceGrList.LookupMode := true;
                                      CustPriceGrList.SetRecord(ToCustPriceGr);
                                      if CustPriceGrList.RunModal = Action::LookupOK then begin
                                        CustPriceGrList.GetRecord(ToCustPriceGr);
                                        ToSalesCode := ToCustPriceGr.Code;
                                      end;
                                    end;
                                  Tosalestype::Campaign:
                                    begin
                                      CampaignList.LookupMode := true;
                                      CampaignList.SetRecord(ToCampaign);
                                      if CampaignList.RunModal = Action::LookupOK then begin
                                        CampaignList.GetRecord(ToCampaign);
                                        ToSalesCode := ToCampaign."No.";
                                        ToStartDate := ToCampaign."Starting Date";
                                        ToEndDate := ToCampaign."Ending Date";
                                      end;
                                    end;
                                end;
                            end;

                            trigger OnValidate()
                            begin
                                ToSalesCodeOnAfterValidate;
                            end;
                        }
                        field("ToUnitofMeasure.Code";ToUnitofMeasure.Code)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Unit of Measure Code';
                            TableRelation = "Unit of Measure";
                        }
                        field("ToCurrency.Code";ToCurrency.Code)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Currency Code';
                            TableRelation = Currency;
                        }
                        field(ToStartDateCtrl;ToStartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';
                            Enabled = ToStartDateCtrlEnable;
                        }
                        field(ToEndDateCtrl;ToEndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';
                            Enabled = ToEndDateCtrlEnable;
                        }
                    }
                    field(PriceLowerLimit;PriceLowerLimit)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Only Amounts Above';
                        DecimalPlaces = 2:5;
                    }
                    field(UnitPriceFactor;UnitPriceFactor)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Adjustment Factor';
                        DecimalPlaces = 0:5;
                        MinValue = 0;
                    }
                    field("RoundingMethod.Code";RoundingMethod.Code)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Rounding Method';
                        TableRelation = "Rounding Method";
                    }
                    field(CreateNewPrices;CreateNewPrices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create New Prices';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            ToEndDateCtrlEnable := true;
            ToStartDateCtrlEnable := true;
            SalesCodeCtrlEnable := true;
        end;

        trigger OnOpenPage()
        begin
            if UnitPriceFactor = 0 then
              UnitPriceFactor := 1;

            SalesCodeCtrlEnable := true;
            if ToSalesType = Tosalestype::"All Customers" then
              SalesCodeCtrlEnable := false;

            SalesCodeCtrlEnable := ToSalesType <> Tosalestype::"All Customers";
            ToStartDateCtrlEnable := ToSalesType <> Tosalestype::Campaign;
            ToEndDateCtrlEnable := ToSalesType <> Tosalestype::Campaign;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        RoundingMethod.SetRange(Code,RoundingMethod.Code);
        if ToCurrency.Code = '' then begin
          ToCurrency.InitRoundingPrecision;
        end else begin
          ToCurrency.Find;
          ToCurrency.TestField("Unit-Amount Rounding Precision");
        end;

        if (ToSalesCode = '') and (ToSalesType <> Tosalestype::"All Customers") then
          Error(Text002,SalesPrice.FieldCaption("Sales Code"));

        if ToUnitofMeasure.Code <> '' then
          ToUnitofMeasure.Find;
        with SalesPriceWksh do begin
          Validate("Sales Type",ToSalesType);
          Validate("Sales Code",ToSalesCode);
          Validate("Currency Code",ToCurrency.Code);
          Validate("Starting Date",ToStartDate);
          Validate("Ending Date",ToEndDate);
          "Unit of Measure Code" := ToUnitofMeasure.Code;

          case ToSalesType of
            Tosalestype::Customer:
              begin
                ToCust."No." := ToSalesCode;
                ToCust.Find;
                "Price Includes VAT" := ToCust."Prices Including VAT";
                "Allow Line Disc." := ToCust."Allow Line Disc.";
              end;
            Tosalestype::"Customer Price Group":
              begin
                ToCustPriceGr.Code := ToSalesCode;
                ToCustPriceGr.Find;
                "Price Includes VAT" := ToCustPriceGr."Price Includes VAT";
                "Allow Line Disc." := ToCustPriceGr."Allow Line Disc.";
                "Allow Invoice Disc." := ToCustPriceGr."Allow Invoice Disc.";
              end;
          end;
        end;
    end;

    var
        Text000: label 'Processing items  #1##########';
        RoundingMethod: Record "Rounding Method";
        SalesPrice: Record "Sales Price";
        SalesPriceWksh2: Record "Sales Price Worksheet";
        SalesPriceWksh: Record "Sales Price Worksheet";
        ToCust: Record Customer;
        ToCustPriceGr: Record "Customer Price Group";
        ToCampaign: Record Campaign;
        ToCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ToUnitofMeasure: Record "Unit of Measure";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        UOMMgt: Codeunit "Unit of Measure Management";
        Window: Dialog;
        PriceAlreadyExists: Boolean;
        CreateNewPrices: Boolean;
        UnitPriceFactor: Decimal;
        PriceLowerLimit: Decimal;
        ToSalesType: Option Customer,"Customer Price Group","All Customers",Campaign;
        ToSalesCode: Code[20];
        ToStartDate: Date;
        ToEndDate: Date;
        Text002: label '%1 must be specified.';
        [InDataSet]
        SalesCodeCtrlEnable: Boolean;
        [InDataSet]
        ToStartDateCtrlEnable: Boolean;
        [InDataSet]
        ToEndDateCtrlEnable: Boolean;


    procedure InitializeRequest(NewToSalesType: Option;NewToSalesCode: Code[20];NewToStartDateText: Date;NewToEndDateText: Date;NewToCurrCode: Code[10];NewToUOMCode: Code[10])
    begin
        ToSalesType := NewToSalesType;
        ToSalesCode := NewToSalesCode;
        ToStartDate := NewToStartDateText;
        ToEndDate := NewToEndDateText;
        ToCurrency.Code := NewToCurrCode;
        ToUnitofMeasure.Code := NewToUOMCode;
    end;

    local procedure ToSalesCodeOnAfterValidate()
    begin
        if ToSalesType = Tosalestype::Campaign then
          if ToCampaign.Get(ToSalesCode) then begin
            ToStartDate := ToCampaign."Starting Date";
            ToEndDate := ToCampaign."Ending Date";
          end else begin
            ToStartDate := 0D;
            ToEndDate := 0D;
          end;
    end;


    procedure InitializeRequest2(NewToSalesType: Option;NewToSalesCode: Code[20];NewToStartDateText: Date;NewToEndDateText: Date;NewToCurrCode: Code[10];NewToUOMCode: Code[10];NewPriceLowerLimit: Decimal;NewUnitPriceFactor: Decimal;NewRoundingMethodCode: Code[10];NewCreateNewPrices: Boolean)
    begin
        InitializeRequest(NewToSalesType,NewToSalesCode,NewToStartDateText,NewToEndDateText,NewToCurrCode,NewToUOMCode);
        PriceLowerLimit := NewPriceLowerLimit;
        UnitPriceFactor := NewUnitPriceFactor;
        RoundingMethod.Code := NewRoundingMethodCode;
        CreateNewPrices := NewCreateNewPrices;
    end;
}

