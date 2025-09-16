#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 160 "Sales Statistics"
{
    Caption = 'Sales Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Amount;TotalSalesLine."Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the net amount of all the lines in the sales document.';
                }
                field(InvDiscountAmount;TotalSalesLine."Inv. Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    ToolTip = 'Specifies the invoice discount amount for the sales document.';

                    trigger OnValidate()
                    begin
                        UpdateInvDiscAmount;
                    end;
                }
                field(TotalAmount1;TotalAmount1)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Caption = 'Total';
                    ToolTip = 'Specifies the total amount less any invoice discount amount and excluding tax for the sales document.';

                    trigger OnValidate()
                    begin
                        UpdateTotalAmount;
                    end;
                }
                field(VATAmount;VATAmount)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText);
                    Caption = 'Tax Amount';
                    Editable = false;
                    ToolTip = 'Specifies the total tax amount that has been calculated for all the lines in the sales document.';
                }
                field(TotalAmount2;TotalAmount2)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Caption = 'Total Incl. Tax';
                    Editable = false;
                    ToolTip = 'Specifies the total amount including tax that will be posted to the customer''s account for all the lines in the sales document. This is the amount that the customer owes based on this sales document. If the document is a credit memo, it is the amount that you owe to the customer.';
                }
                field("TotalSalesLineLCY.Amount";TotalSalesLineLCY.Amount)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                    ToolTip = 'Specifies your total sales turnover in the fiscal year. It is calculated from amounts excluding tax on all completed and open sales invoices and credit memos.';
                }
                field(ProfitLCY;ProfitLCY)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Original Profit ($)';
                    Editable = false;
                    ToolTip = 'Specifies the original profit that was associated with the sales when they were originally posted.';
                }
                field(AdjProfitLCY;AdjProfitLCY)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit ($)';
                    Editable = false;
                    ToolTip = 'Specifies the profit, taking into consideration changes in the purchase prices of the goods.';
                }
                field(ProfitPct;ProfitPct)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    ToolTip = 'Specifies the original percentage of profit that was associated with the sales when they were originally posted.';
                }
                field(AdjProfitPct;AdjProfitPct)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    ToolTip = 'Specifies the percentage of profit for all sales, taking into account changes that occurred in the purchase prices of the goods.';
                }
                field("TotalSalesLine.Quantity";TotalSalesLine.Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity of G/L account entries, items, and/or resources in the sales document. If the amount is rounded, because the Invoice Rounding check box is selected in the Sales & Receivables Setup window, this field will contain the quantity of items in the sales document plus one.';
                }
                field("TotalSalesLine.""Units per Parcel""";TotalSalesLine."Units per Parcel")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the total number of parcels in the sales document.';
                }
                field("TotalSalesLine.""Net Weight""";TotalSalesLine."Net Weight")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the total net weight of the items in the sales document.';
                }
                field("TotalSalesLine.""Gross Weight""";TotalSalesLine."Gross Weight")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the total gross weight of the items in the sales document.';
                }
                field("TotalSalesLine.""Unit Volume""";TotalSalesLine."Unit Volume")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the total volume of the items in the sales document.';
                }
                field("TotalSalesLineLCY.""Unit Cost (LCY)""";TotalSalesLineLCY."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                    Editable = false;
                    ToolTip = 'Specifies the total cost, in $, of the G/L account entries, items, and/or resources in the sales document. The cost is calculated as unit cost x quantity of the items or resources.';
                }
                field(TotalAdjCostLCY;TotalAdjCostLCY)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost ($)';
                    Editable = false;
                    ToolTip = 'Specifies the total cost, in $, of the items in the sales document, adjusted for any changes in the original costs of these items. If this field contains zero, it means that there were no entries to calculate, possibly because of date compression or because the adjustment batch job has not yet been run.';
                }
                field("TotalAdjCostLCY - TotalSalesLineLCY.""Unit Cost (LCY)""";TotalAdjCostLCY - TotalSalesLineLCY."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Cost Adjmt. Amount ($)';
                    Editable = false;
                    ToolTip = 'Specifies the difference between the original cost and the total adjusted cost of the items in the sales document.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupAdjmtValueEntries(0);
                    end;
                }
            }
            part(SubForm;"VAT Specification Subform")
            {
                ApplicationArea = Basic,Suite;
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Cust.""Balance (LCY)""";Cust."Balance (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                    Editable = false;
                    ToolTip = 'Specifies the balance on the customer''s account.';
                }
                field("Cust.""Credit Limit (LCY)""";Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit ($)';
                    Editable = false;
                    ToolTip = 'Specifies the credit limit of the customer that you created the sales document for.';
                }
                field(CreditLimitLCYExpendedPct;CreditLimitLCYExpendedPct)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Expended % of Credit Limit ($)';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Specifies the expended percentage of the credit limit in ($).';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
    begin
        CurrPage.Caption(StrSubstNo(Text000,"Document Type"));
        if PrevNo = "No." then begin
          GetVATSpecification;
          exit;
        end;
        PrevNo := "No.";
        FilterGroup(2);
        SetRange("No.",PrevNo);
        FilterGroup(0);
        Clear(SalesLine);
        Clear(TotalSalesLine);
        Clear(TotalSalesLineLCY);
        Clear(SalesPost);

        SalesPost.GetSalesLines(Rec,TempSalesLine,0);
        Clear(SalesPost);
        SalesPost.SumSalesLinesTemp(
          Rec,TempSalesLine,0,TotalSalesLine,TotalSalesLineLCY,
          VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

        AdjProfitLCY := TotalSalesLineLCY.Amount - TotalAdjCostLCY;
        if TotalSalesLineLCY.Amount <> 0 then
          AdjProfitPct := ROUND(AdjProfitLCY / TotalSalesLineLCY.Amount * 100,0.1);

        if "Prices Including VAT" then begin
          TotalAmount2 := TotalSalesLine.Amount;
          TotalAmount1 := TotalAmount2 + VATAmount;
          TotalSalesLine."Line Amount" := TotalAmount1 + TotalSalesLine."Inv. Discount Amount";
        end else begin
          TotalAmount1 := TotalSalesLine.Amount;
          TotalAmount2 := TotalSalesLine."Amount Including VAT";
        end;

        if Cust.Get("Bill-to Customer No.") then
          Cust.CalcFields("Balance (LCY)")
        else
          Clear(Cust);
        if Cust."Credit Limit (LCY)" = 0 then
          CreditLimitLCYExpendedPct := 0
        else
          if Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0 then
            CreditLimitLCYExpendedPct := 0
          else
            if Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1 then
              CreditLimitLCYExpendedPct := 10000
            else
              CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);

        SalesLine.CalcVATAmountLines(0,Rec,TempSalesLine,TempVATAmountLine);
        TempVATAmountLine.ModifyAll(Modified,false);
        SetVATSpecification;
    end;

    trigger OnOpenPage()
    begin
        SalesSetup.Get;
        AllowInvDisc :=
          not (SalesSetup."Calc. Inv. Discount" and CustInvDiscRecExists("Invoice Disc. Code"));
        AllowVATDifference :=
          SalesSetup."Allow VAT Difference" and
          not ("Document Type" in ["document type"::Quote,"document type"::"Blanket Order"]);
        CurrPage.Editable :=
          AllowVATDifference or AllowInvDisc;
        SetVATSpecification;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification;
        if TempVATAmountLine.GetAnyLineModified then
          UpdateVATOnSalesLines;
        exit(true);
    end;

    var
        Text000: label 'Sales %1 Statistics';
        Text001: label 'Total';
        Text002: label 'Amount';
        Text003: label '%1 must not be 0.';
        Text004: label '%1 must not be greater than %2.';
        Text005: label 'You cannot change the invoice discount because there is a %1 record for %2 %3.', Comment='You cannot change the invoice discount because there is a Cust. Invoice Disc. record for Invoice Disc. Code 30000.';
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        Cust: Record Customer;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPost: Codeunit "Sales-Post";
        TotalAmount1: Decimal;
        TotalAmount2: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        PrevNo: Code[20];
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;

    local procedure UpdateHeaderInfo()
    var
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
    begin
        TotalSalesLine."Inv. Discount Amount" := TempVATAmountLine.GetTotalInvDiscAmount;
        TotalAmount1 :=
          TotalSalesLine."Line Amount" - TotalSalesLine."Inv. Discount Amount";
        VATAmount := TempVATAmountLine.GetTotalVATAmount;
        if "Prices Including VAT" then begin
          TotalAmount1 := TempVATAmountLine.GetTotalAmountInclVAT;
          TotalAmount2 := TotalAmount1 - VATAmount;
          TotalSalesLine."Line Amount" := TotalAmount1 + TotalSalesLine."Inv. Discount Amount";
        end else
          TotalAmount2 := TotalAmount1 + VATAmount;

        if "Prices Including VAT" then
          TotalSalesLineLCY.Amount := TotalAmount2
        else
          TotalSalesLineLCY.Amount := TotalAmount1;
        if "Currency Code" <> '' then begin
          if ("Document Type" in ["document type"::"Blanket Order","document type"::Quote]) and
             ("Posting Date" = 0D)
          then
            UseDate := WorkDate
          else
            UseDate := "Posting Date";

          TotalSalesLineLCY.Amount :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              UseDate,"Currency Code",TotalSalesLineLCY.Amount,"Currency Factor");
        end;
        ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
        if TotalSalesLineLCY.Amount = 0 then
          ProfitPct := 0
        else
          ProfitPct := ROUND(100 * ProfitLCY / TotalSalesLineLCY.Amount,0.01);

        AdjProfitLCY := TotalSalesLineLCY.Amount - TotalAdjCostLCY;
        if TotalSalesLineLCY.Amount = 0 then
          AdjProfitPct := 0
        else
          AdjProfitPct := ROUND(100 * AdjProfitLCY / TotalSalesLineLCY.Amount,0.01);
    end;

    local procedure GetVATSpecification()
    begin
        CurrPage.SubForm.Page.GetTempVATAmountLine(TempVATAmountLine);
        if TempVATAmountLine.GetAnyLineModified then
          UpdateHeaderInfo;
    end;

    local procedure SetVATSpecification()
    begin
        CurrPage.SubForm.Page.SetTempVATAmountLine(TempVATAmountLine);
        CurrPage.SubForm.Page.InitGlobals(
          "Currency Code",AllowVATDifference,AllowVATDifference,
          "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
    end;

    local procedure UpdateTotalAmount()
    var
        SaveTotalAmount: Decimal;
    begin
        CheckAllowInvDisc;
        if "Prices Including VAT" then begin
          SaveTotalAmount := TotalAmount1;
          UpdateInvDiscAmount;
          TotalAmount1 := SaveTotalAmount;
        end;
        with TotalSalesLine do
          "Inv. Discount Amount" := "Line Amount" - TotalAmount1;
        UpdateInvDiscAmount;
    end;

    local procedure UpdateInvDiscAmount()
    var
        InvDiscBaseAmount: Decimal;
    begin
        CheckAllowInvDisc;
        InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(false,"Currency Code");
        if InvDiscBaseAmount = 0 then
          Error(Text003,TempVATAmountLine.FieldCaption("Inv. Disc. Base Amount"));

        if TotalSalesLine."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
          Error(
            Text004,
            TotalSalesLine.FieldCaption("Inv. Discount Amount"),
            TempVATAmountLine.FieldCaption("Inv. Disc. Base Amount"));

        TempVATAmountLine.SetInvoiceDiscountAmount(
          TotalSalesLine."Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
        CurrPage.SubForm.Page.SetTempVATAmountLine(TempVATAmountLine);
        UpdateHeaderInfo;

        "Invoice Discount Calculation" := "invoice discount calculation"::Amount;
        "Invoice Discount Value" := TotalSalesLine."Inv. Discount Amount";
        Modify;
        UpdateVATOnSalesLines;
    end;

    local procedure GetCaptionClass(FieldCaption: Text[100];ReverseCaption: Boolean): Text[80]
    begin
        if "Prices Including VAT" xor ReverseCaption then
          exit('2,1,' + FieldCaption);

        exit('2,0,' + FieldCaption);
    end;

    local procedure UpdateVATOnSalesLines()
    var
        SalesLine: Record "Sales Line";
    begin
        GetVATSpecification;
        if TempVATAmountLine.GetAnyLineModified then begin
          SalesLine.UpdateVATOnLines(0,Rec,SalesLine,TempVATAmountLine);
          SalesLine.UpdateVATOnLines(1,Rec,SalesLine,TempVATAmountLine);
        end;
        PrevNo := '';
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SetRange(Code,InvDiscCode);
        exit(CustInvDisc.FindFirst);
    end;

    local procedure CheckAllowInvDisc()
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        if not AllowInvDisc then
          Error(
            Text005,
            CustInvDisc.TableCaption,FieldCaption("Invoice Disc. Code"),"Invoice Disc. Code");
    end;
}

