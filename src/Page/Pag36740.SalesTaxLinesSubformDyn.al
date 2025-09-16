#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36740 "Sales Tax Lines Subform Dyn"
{
    Caption = 'Sales Tax Lines Subform Dyn';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable10011;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax Area Code used on the sales or purchase lines with this Tax Group Code.';
                    Visible = false;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("Tax Jurisdiction Code";"Tax Jurisdiction Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax jurisdiction that is used for the Tax Area Code field on the purchase or sales lines.';
                }
                field("Tax Type";"Tax Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of tax that applies to the entry, such as sales tax, excise tax, or use tax.';
                    Visible = false;
                }
                field("Tax %";"Tax %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax Percentage that was used on the sales tax amount lines with this combination of Tax Area Code and Tax Group Code.';
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the net amount (excluding tax) for sales or purchase lines matching the combination of Tax Area Code and Tax Group Code.';
                }
                field("Tax Base Amount";"Tax Base Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the net amount (excluding tax) for sales or purchase lines.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of quantities from sales or purchase lines matching the combination of Tax Area Code and Tax Group Code found on this line.';
                    Visible = false;
                }
                field("Tax Amount";"Tax Amount")
                {
                    ApplicationArea = Basic,Suite;
                    DecimalPlaces = 2:5;
                    Editable = "Tax AmountEditable";
                    ToolTip = 'Specifies the sales tax calculated for this Sales Tax Amount Line.';

                    trigger OnValidate()
                    begin
                        if AllowVATDifference and not AllowVATDifferenceOnThisTab then
                          Error(Text000,FieldCaption("Tax Amount"));
                        "Amount Including Tax" := "Tax Amount" + "Tax Base Amount";

                        FormCheckVATDifference;
                        ModifyRec;
                    end;
                }
                field("Tax Difference";"Tax Difference")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 2:5;
                    ToolTip = 'Specifies the difference for the sales tax amount that is used for tax calculations.';
                    Visible = false;
                }
                field("Amount Including Tax";"Amount Including Tax")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the sum of the Tax Base Amount field and the Tax Amount field.';

                    trigger OnValidate()
                    begin
                        FormCheckVATDifference;
                    end;
                }
                field("Expense/Capitalize";"Expense/Capitalize")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the Tax Amount will be debited to an Expense or Capital account, rather than to a Payable or Receivable account.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        TempSalesTaxLine.Copy(Rec);
        if TempSalesTaxLine.Find(Which) then begin
          Rec := TempSalesTaxLine;
          exit(true);
        end;
        exit(false);
    end;

    trigger OnInit()
    begin
        "Tax AmountEditable" := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ModifyRec;
        exit(false);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ResultSteps: Integer;
    begin
        TempSalesTaxLine.Copy(Rec);
        ResultSteps := TempSalesTaxLine.Next(Steps);
        if ResultSteps <> 0 then
          Rec := TempSalesTaxLine;
        exit(ResultSteps);
    end;

    var
        Text000: label '%1 can only be modified on the Invoicing tab.';
        Text001: label 'The total %1 for a document must not exceed %2 = %3.';
        TempSalesTaxLine: Record UnknownRecord10011 temporary;
        Currency: Record Currency;
        CurrencyCode: Code[10];
        AllowVATDifference: Boolean;
        AllowVATDifferenceOnThisTab: Boolean;
        PricesIncludingVAT: Boolean;
        AllowInvDisc: Boolean;
        VATBaseDiscPct: Decimal;
        [InDataSet]
        "Tax AmountEditable": Boolean;


    procedure SetTempTaxAmountLine(var NewSalesTaxLine: Record UnknownRecord10011 temporary)
    begin
        TempSalesTaxLine.DeleteAll;
        if NewSalesTaxLine.Find('-') then
          repeat
            TempSalesTaxLine.Copy(NewSalesTaxLine);
            TempSalesTaxLine.Insert;
          until NewSalesTaxLine.Next = 0;
        CurrPage.Update;
    end;


    procedure GetTempTaxAmountLine(var NewSalesTaxLine: Record UnknownRecord10011 temporary)
    begin
        NewSalesTaxLine.DeleteAll;
        if TempSalesTaxLine.Find('-') then
          repeat
            NewSalesTaxLine.Copy(TempSalesTaxLine);
            NewSalesTaxLine.Insert;
          until TempSalesTaxLine.Next = 0;
    end;


    procedure InitGlobals(NewCurrencyCode: Code[10];NewAllowVATDifference: Boolean;NewAllowVATDifferenceOnThisTab: Boolean;NewPricesIncludingVAT: Boolean;NewAllowInvDisc: Boolean;NewVATBaseDiscPct: Decimal)
    begin
        CurrencyCode := NewCurrencyCode;
        AllowVATDifference := NewAllowVATDifference;
        AllowVATDifferenceOnThisTab := NewAllowVATDifferenceOnThisTab;
        PricesIncludingVAT := NewPricesIncludingVAT;
        AllowInvDisc := NewAllowInvDisc;
        VATBaseDiscPct := NewVATBaseDiscPct;
        "Tax AmountEditable" := AllowVATDifference;
        if CurrencyCode = '' then
          Currency.InitRoundingPrecision
        else
          Currency.Get(CurrencyCode);
        CurrPage.Update;
    end;


    procedure FormCheckVATDifference()
    var
        TaxAmountLine2: Record UnknownRecord10011;
        TotalVATDifference: Decimal;
    begin
        CheckTaxDifference(CurrencyCode,AllowVATDifference,PricesIncludingVAT);
        TaxAmountLine2 := TempSalesTaxLine;
        TotalVATDifference := Abs("Tax Difference") - Abs(xRec."Tax Difference");
        if TempSalesTaxLine.Find('-') then
          repeat
            TotalVATDifference := TotalVATDifference + Abs(TempSalesTaxLine."Tax Difference");
          until TempSalesTaxLine.Next = 0;
        TempSalesTaxLine := TaxAmountLine2;
        if TotalVATDifference > Currency."Max. VAT Difference Allowed" then
          Error(
            Text001,FieldCaption("Tax Difference"),
            Currency.FieldCaption("Max. VAT Difference Allowed"),Currency."Max. VAT Difference Allowed");
    end;

    local procedure ModifyRec()
    begin
        TempSalesTaxLine := Rec;
        TempSalesTaxLine.Modified := true;
        TempSalesTaxLine.Modify;
    end;
}

