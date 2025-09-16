#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 576 "VAT Specification Subform"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "VAT Amount Line";
    SourceTableTemporary = true;

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
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax percentage that was used on the sales or purchase lines with this Tax Identifier.';
                }
                field("VAT Calculation Type";"VAT Calculation Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the total amount for sales or purchase lines with a specific Tax identifier.';
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
                    ApplicationArea = Basic;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the total net amount (amount excluding Tax) for sales or purchase lines with a specific Tax Identifier.';
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    Editable = VATAmountEditable;
                    ToolTip = 'Specifies the total of the Tax amounts on sales or purchase lines with a specific Tax Identifier.';

                    trigger OnValidate()
                    begin
                        if AllowVATDifference and not AllowVATDifferenceOnThisTab then
                          if ParentControl = Page::"Service Order Statistics" then
                            Error(Text000,FieldCaption("VAT Amount"),Text002)
                          else
                            Error(Text000,FieldCaption("VAT Amount"),Text003);

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
                    ApplicationArea = Basic;
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
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if MainFormActiveTab = Mainformactivetab::Other then
          VATAmountEditable := AllowVATDifference and not "Includes Prepayment"
        else
          VATAmountEditable := AllowVATDifference;
        InvoiceDiscountAmountEditable := AllowInvDisc and not "Includes Prepayment";
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

    var
        Text000: label '%1 can only be modified on the %2 tab.';
        Text001: label 'The total %1 for a document must not exceed the value %2 in the %3 field.';
        Currency: Record Currency;
        ServHeader: Record "Service Header";
        CurrencyCode: Code[10];
        AllowVATDifference: Boolean;
        AllowVATDifferenceOnThisTab: Boolean;
        PricesIncludingVAT: Boolean;
        AllowInvDisc: Boolean;
        VATBaseDiscPct: Decimal;
        ParentControl: Integer;
        Text002: label 'Details';
        Text003: label 'Invoicing';
        CurrentTabNo: Integer;
        MainFormActiveTab: Option Other,Prepayment;
        [InDataSet]
        VATAmountEditable: Boolean;
        [InDataSet]
        InvoiceDiscountAmountEditable: Boolean;


    procedure SetTempVATAmountLine(var NewVATAmountLine: Record "VAT Amount Line")
    begin
        DeleteAll;
        if NewVATAmountLine.Find('-') then
          repeat
            Copy(NewVATAmountLine);
            Insert;
          until NewVATAmountLine.Next = 0;
        CurrPage.Update(false);
    end;


    procedure GetTempVATAmountLine(var NewVATAmountLine: Record "VAT Amount Line")
    begin
        NewVATAmountLine.DeleteAll;
        if Find('-') then
          repeat
            NewVATAmountLine.Copy(Rec);
            NewVATAmountLine.Insert;
          until Next = 0;
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
        CurrPage.Update(false);
    end;

    local procedure FormCheckVATDifference()
    var
        VATAmountLine2: Record "VAT Amount Line";
        TotalVATDifference: Decimal;
    begin
        CheckVATDifference(CurrencyCode,AllowVATDifference);
        VATAmountLine2 := Rec;
        TotalVATDifference := Abs("VAT Difference") - Abs(xRec."VAT Difference");
        if Find('-') then
          repeat
            TotalVATDifference := TotalVATDifference + Abs("VAT Difference");
          until Next = 0;
        Rec := VATAmountLine2;
        if TotalVATDifference > Currency."Max. VAT Difference Allowed" then
          Error(
            Text001,FieldCaption("VAT Difference"),
            Currency."Max. VAT Difference Allowed",Currency.FieldCaption("Max. VAT Difference Allowed"));
    end;

    local procedure ModifyRec()
    var
        ServLine: Record "Service Line";
    begin
        Modified := true;
        Modify;

        if ((ParentControl = Page::"Service Order Statistics") and
            (CurrentTabNo <> 1)) or
           (ParentControl = Page::"Service Statistics")
        then
          if GetAnyLineModified then begin
            ServLine.UpdateVATOnLines(0,ServHeader,ServLine,Rec);
            ServLine.UpdateVATOnLines(1,ServHeader,ServLine,Rec);
          end;
    end;


    procedure SetParentControl(ID: Integer)
    begin
        ParentControl := ID;
    end;


    procedure SetServHeader(ServiceHeader: Record "Service Header")
    begin
        ServHeader := ServiceHeader;
    end;


    procedure SetCurrentTabNo(TabNo: Integer)
    begin
        CurrentTabNo := TabNo;
    end;
}

