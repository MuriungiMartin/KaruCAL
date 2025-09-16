#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9401 "VAT Amount Lines"
{
    Caption = 'Tax Amount Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "VAT Amount Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("VAT Identifier";"VAT Identifier")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contents of this field from the Tax Identifier field in the Tax Posting Setup table.';
                    Visible = false;
                }
                field("VAT %";"VAT %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax % that was used on the sales or purchase lines with this Tax Identifier.';
                }
                field("VAT Calculation Type";"VAT Calculation Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                }
                field("Inv. Disc. Base Amount";"Inv. Disc. Base Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the invoice discount base amount.';
                    Visible = false;
                }
                field("Invoice Discount Amount";"Invoice Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    Editable = InvoiceDiscountAmountEditable;
                    ToolTip = 'Specifies the invoice discount amount for a specific Tax identifier.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CalcVATFields(CurrencyCode,PricesIncludingVAT,VATBaseDiscPct);
                        ModifyRec;
                    end;
                }
                field("VAT Base";"VAT Base")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the total net amount (amount excluding Tax) for sales or purchase lines with a specific Tax Identifier.';
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    Editable = VATAmountEditable;
                    ToolTip = 'Specifies the total of the Tax amounts on sales or purchase lines with a specific Tax Identifier.';

                    trigger OnValidate()
                    begin
                        if AllowVATDifference and not AllowVATDifferenceOnThisTab then
                          Error(Text000,FieldCaption("VAT Amount"));

                        if PricesIncludingVAT then
                          "VAT Base" := "Amount Including VAT" - "VAT Amount"
                        else
                          "Amount Including VAT" := "VAT Amount" + "VAT Base";

                        FormCheckVATDifference;
                        ModifyRec;
                    end;
                }
                field("Calculated VAT Amount";"Calculated VAT Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the calculated Tax amount and is only used for reference when the user changes the Tax Amount manually.';
                    Visible = false;
                }
                field("VAT Difference";"VAT Difference")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the Tax Difference for one Tax Identifier.';
                    Visible = false;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the total of the amounts in the amount fields on the sales or purchase lines with a specific Tax Identifier, including Tax.';

                    trigger OnValidate()
                    begin
                        FormCheckVATDifference;
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        VATAmountEditable := AllowVATDifference and not "Includes Prepayment";
        InvoiceDiscountAmountEditable := AllowInvDisc and not "Includes Prepayment";
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        TempVATAmountLine.Copy(Rec);
        if TempVATAmountLine.Find(Which) then begin
          Rec := TempVATAmountLine;
          exit(true);
        end;
        exit(false);
    end;

    trigger OnInit()
    begin
        InvoiceDiscountAmountEditable := true;
        VATAmountEditable := true;
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
        TempVATAmountLine.Copy(Rec);
        ResultSteps := TempVATAmountLine.Next(Steps);
        if ResultSteps <> 0 then
          Rec := TempVATAmountLine;
        exit(ResultSteps);
    end;

    var
        Text000: label '%1 can only be modified on the Invoicing tab.';
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        CurrencyCode: Code[10];
        AllowVATDifference: Boolean;
        AllowVATDifferenceOnThisTab: Boolean;
        PricesIncludingVAT: Boolean;
        AllowInvDisc: Boolean;
        VATBaseDiscPct: Decimal;
        [InDataSet]
        VATAmountEditable: Boolean;
        [InDataSet]
        InvoiceDiscountAmountEditable: Boolean;
        Text001: label 'The total %1 for a document must not exceed the value %2 in the %3 field.';


    procedure SetTempVATAmountLine(var NewVATAmountLine: Record "VAT Amount Line")
    begin
        TempVATAmountLine.DeleteAll;
        if NewVATAmountLine.Find('-') then
          repeat
            TempVATAmountLine.Copy(NewVATAmountLine);
            TempVATAmountLine.Insert;
          until NewVATAmountLine.Next = 0;
    end;


    procedure GetTempVATAmountLine(var NewVATAmountLine: Record "VAT Amount Line")
    begin
        NewVATAmountLine.DeleteAll;
        if TempVATAmountLine.Find('-') then
          repeat
            NewVATAmountLine.Copy(TempVATAmountLine);
            NewVATAmountLine.Insert;
          until TempVATAmountLine.Next = 0;
    end;


    procedure InitGlobals(NewCurrencyCode: Code[10];NewAllowVATDifference: Boolean;NewAllowVATDifferenceOnThisTab: Boolean;NewPricesIncludingVAT: Boolean;NewAllowInvDisc: Boolean;NewVATBaseDiscPct: Decimal)
    begin
        CurrencyCode := NewCurrencyCode;
        AllowVATDifference := NewAllowVATDifference;
        AllowVATDifferenceOnThisTab := NewAllowVATDifferenceOnThisTab;
        PricesIncludingVAT := NewPricesIncludingVAT;
        AllowInvDisc := NewAllowInvDisc;
        VATBaseDiscPct := NewVATBaseDiscPct;
        VATAmountEditable := AllowVATDifference;
        InvoiceDiscountAmountEditable := AllowInvDisc;
        if CurrencyCode = '' then
          Currency.InitRoundingPrecision
        else
          Currency.Get(CurrencyCode);
    end;

    local procedure FormCheckVATDifference()
    var
        VATAmountLine2: Record "VAT Amount Line";
        TotalVATDifference: Decimal;
    begin
        CheckVATDifference(CurrencyCode,AllowVATDifference);
        VATAmountLine2 := TempVATAmountLine;
        TotalVATDifference := Abs("VAT Difference") - Abs(xRec."VAT Difference");
        if TempVATAmountLine.Find('-') then
          repeat
            TotalVATDifference := TotalVATDifference + Abs(TempVATAmountLine."VAT Difference");
          until TempVATAmountLine.Next = 0;
        TempVATAmountLine := VATAmountLine2;
        if TotalVATDifference > Currency."Max. VAT Difference Allowed" then
          Error(
            Text001,FieldCaption("VAT Difference"),
            Currency."Max. VAT Difference Allowed",Currency.FieldCaption("Max. VAT Difference Allowed"));
    end;

    local procedure ModifyRec()
    begin
        TempVATAmountLine := Rec;
        TempVATAmountLine.Modified := true;
        TempVATAmountLine.Modify;
    end;
}

