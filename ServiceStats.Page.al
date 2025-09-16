#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10053 "Service Stats."
{
    Caption = 'Service Stats.';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Service Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("TotalServLine[1].""Line Amount""";TotalServLine[1]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Editable = false;
                }
                field("TotalServLine[1].""Inv. Discount Amount""";TotalServLine[1]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateInvDiscAmount(1);
                    end;
                }
                field("TotalServLine[1].Quantity";TotalServLine[1].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalAmount1[1]";TotalAmount1[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateTotalAmount(1);
                    end;
                }
                field(VATAmount;VATAmount[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                    Editable = false;
                }
                field("TotalAmount2[1]";TotalAmount2[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Editable = false;

                    trigger OnValidate()
                    begin
                        TotalAmount21OnAfterValidate;
                    end;
                }
                field("TotalServLineLCY[1].Amount";TotalServLineLCY[1].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                }
                field("TotalServLineLCY[1].""Unit Cost (LCY)""";TotalServLineLCY[1]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                    Editable = false;
                }
                field("ProfitLCY[1]";ProfitLCY[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                }
                field("ProfitPct[1]";ProfitPct[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("TotalServLine[1].""Units per Parcel""";TotalServLine[1]."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[1].""Net Weight""";TotalServLine[1]."Net Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[1].""Gross Weight""";TotalServLine[1]."Gross Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[1].""Unit Volume""";TotalServLine[1]."Unit Volume")
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                label(BreakdownTitle)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(BreakdownTitle);
                    Editable = false;
                }
                field(BreakdownAmt;BreakdownAmt[1,1])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,1]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt2;BreakdownAmt[1,2])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,2]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt3;BreakdownAmt[1,3])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,3]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt4;BreakdownAmt[1,4])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,4]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
            }
            part(SubForm;"Sales Tax Lines Serv. Subform")
            {
            }
            group("Service Line")
            {
                Caption = 'Service Line';
                label(Control1480055)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19041261;
                }
                label(Control1480056)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19014898;
                }
                field("TotalServLine[5].Quantity";TotalServLine[5].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                label(Control1480057)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19016980;
                }
                field("TotalServLine[6].Quantity";TotalServLine[6].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[5].""Line Amount""";TotalServLine[5]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Editable = false;
                }
                field("TotalServLine[6].""Line Amount""";TotalServLine[6]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Editable = false;
                }
                field("TotalServLine[5].""Inv. Discount Amount""";TotalServLine[5]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;
                }
                field("TotalServLine[6].""Inv. Discount Amount""";TotalServLine[6]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;
                }
                field("TotalAmount1[5]";TotalAmount1[5])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Editable = false;
                }
                field("TotalAmount1[6]";TotalAmount1[6])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Editable = false;
                }
                field("VATAmount[5]";VATAmount[5])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText[1]);
                    Editable = false;
                }
                field("TotalAmount2[5]";TotalAmount2[5])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Editable = false;
                }
                field("TotalServLineLCY[5].Amount";TotalServLineLCY[5].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                }
                field("ProfitLCY[5]";ProfitLCY[5])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Profit ($)';
                    Editable = false;
                }
                field("AdjProfitLCY[5]";AdjProfitLCY[5])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit ($)';
                    Editable = false;
                }
                field("ProfitPct[5]";ProfitPct[5])
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("AdjProfitPct[5]";AdjProfitPct[5])
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("TotalServLineLCY[5].""Unit Cost (LCY)""";TotalServLineLCY[5]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                    Editable = false;
                }
                field("TotalAdjCostLCY[5]";TotalAdjCostLCY[5])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost ($)';
                    Editable = false;
                }
                field("TotalAdjCostLCY[5] - TotalServLineLCY[5].""Unit Cost (LCY)""";TotalAdjCostLCY[5] - TotalServLineLCY[5]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost Adjmt. Amount ($)';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupAdjmtValueEntries(1);
                    end;
                }
                field("TotalServLine[7].Quantity";TotalServLine[7].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[7].""Line Amount""";TotalServLine[7]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Editable = false;
                }
                field("TotalServLine[7].""Inv. Discount Amount""";TotalServLine[7]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;
                }
                field("TotalAmount1[7]";TotalAmount1[7])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Editable = false;
                }
                field("VATAmount[6]";VATAmount[6])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Editable = false;
                }
                field("VATAmount[7]";VATAmount[7])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Editable = false;
                }
                field("TotalAmount2[6]";TotalAmount2[6])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Editable = false;
                }
                field("TotalAmount2[7]";TotalAmount2[7])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Editable = false;
                }
                field("TotalServLineLCY[6].Amount";TotalServLineLCY[6].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Amount ($)';
                    Editable = false;
                }
                field("TotalServLineLCY[7].Amount";TotalServLineLCY[7].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Amount ($)';
                    Editable = false;
                }
                field("ProfitLCY[6]";ProfitLCY[6])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                }
                field("ProfitLCY[7]";ProfitLCY[7])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                }
                field("AdjProfitLCY[6]";AdjProfitLCY[6])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                }
                field("AdjProfitLCY[7]";AdjProfitLCY[7])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                }
                field("ProfitPct[6]";ProfitPct[6])
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("ProfitPct[7]";ProfitPct[7])
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("TotalServLineLCY[6].""Unit Cost (LCY)""";TotalServLineLCY[6]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost ($)';
                    Editable = false;
                }
                field("TotalServLineLCY[7].""Unit Cost (LCY)""";TotalServLineLCY[7]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost ($)';
                    Editable = false;
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Cust.""Balance (LCY)""";Cust."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                    Editable = false;
                }
                field("Cust.""Credit Limit (LCY)""";Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit ($)';
                    Editable = false;
                }
                field(CreditLimitLCYExpendedPct;CreditLimitLCYExpendedPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expended % of Credit Limit ($)';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Specifies the Expended Percentage of Credit Limit ($).';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        ServLine: Record "Service Line";
        TempServLine: Record "Service Line" temporary;
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
    begin
        CurrPage.Caption(StrSubstNo(Text000,"Document Type"));

        if PrevNo = "No." then
          exit;
        PrevNo := "No.";
        FilterGroup(2);
        SetRange("No.",PrevNo);
        FilterGroup(0);

        Clear(ServLine);
        Clear(TotalServLine);
        Clear(TotalServLineLCY);
        Clear(ServAmtsMgt);
        Clear(BreakdownLabel);
        Clear(BreakdownAmt);

        for i := 1 to 7 do begin
          TempServLine.DeleteAll;
          Clear(TempServLine);
          ServAmtsMgt.GetServiceLines(Rec,TempServLine,i - 1);
          SalesTaxCalculate.StartSalesTaxCalculation;
          if not TaxArea."Use External Tax Engine" then begin
            TempServLine.SetFilter(Type,'>0');
            TempServLine.SetFilter(Quantity,'<>0');
            if TempServLine.Find('-') then
              repeat
                SalesTaxCalculate.AddServiceLine(TempServLine);
              until TempServLine.Next = 0;
          end;
          case i of
            1:
              begin
                TempSalesTaxLine1.DeleteAll;
                if TaxArea."Use External Tax Engine" then
                  SalesTaxCalculate.CallExternalTaxEngineForServ(Rec,true)
                else
                  SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
                SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine1);
              end;
            2:
              begin
                TempSalesTaxLine2.DeleteAll;
                if TaxArea."Use External Tax Engine" then
                  SalesTaxCalculate.CallExternalTaxEngineForServ(Rec,true)
                else
                  SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
                SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine2);
              end;
            3:
              begin
                TempSalesTaxLine3.DeleteAll;
                if TaxArea."Use External Tax Engine" then
                  SalesTaxCalculate.CallExternalTaxEngineForServ(Rec,true)
                else
                  SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
                SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine3);
              end;
          end;

          ServAmtsMgt.SumServiceLinesTemp(
            Rec,TempServLine,i - 1,TotalServLine[i],TotalServLineLCY[i],
            VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);
          // IF Status = Status::Open THEN
          SalesTaxCalculate.DistTaxOverServLines(TempServLine);
          // SalesPost.SumSalesLinesTemp(
          // Rec,TempSalesLine,i - 1,TotalServLine[i],TotalServLineLCY[i],
          // VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);
          if i = 3 then
            TotalAdjCostLCY[i] := TotalServLineLCY[i]."Unit Cost (LCY)";

          AdjProfitLCY[i] := TotalServLineLCY[i].Amount - TotalAdjCostLCY[i];
          if TotalServLineLCY[i].Amount <> 0 then
            AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalServLineLCY[i].Amount * 100,0.1);
          TotalAmount1[i] := TotalServLine[i].Amount;
          TotalAmount2[i] := TotalAmount1[i];
          VATAmount[i] := 0;

          SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
          BrkIdx := 0;
          PrevPrintOrder := 0;
          PrevTaxPercent := 0;
          if TaxArea."Country/Region" = TaxArea."country/region"::CA then
            BreakdownTitle := Text1020010
          else
            BreakdownTitle := Text1020011;
          with TempSalesTaxAmtLine do begin
            Reset;
            SetCurrentkey("Print Order","Tax Area Code for Key","Tax Jurisdiction Code");
            if Find('-') then
              repeat
                if ("Print Order" = 0) or
                   ("Print Order" <> PrevPrintOrder) or
                   ("Tax %" <> PrevTaxPercent)
                then begin
                  BrkIdx := BrkIdx + 1;
                  if BrkIdx > ArrayLen(BreakdownAmt) then begin
                    BrkIdx := BrkIdx - 1;
                    BreakdownLabel[i,BrkIdx] := Text1020012;
                  end else
                    BreakdownLabel[i,BrkIdx] := StrSubstNo("Print Description","Tax %");
                end;
                BreakdownAmt[i,BrkIdx] := BreakdownAmt[i,BrkIdx] + "Tax Amount";
                VATAmount[i] := VATAmount[i] + "Tax Amount";
              until Next = 0;
            TotalAmount2[i] := TotalAmount2[i] + VATAmount[i];
          end;
        end;
        TempServLine.DeleteAll;
        Clear(TempServLine); // ?????

        if Cust.Get("Bill-to Customer No.") then
          Cust.CalcFields("Balance (LCY)")
        else
          Clear(Cust);
        case true of
          Cust."Credit Limit (LCY)" = 0:
            CreditLimitLCYExpendedPct := 0;
          Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0:
            CreditLimitLCYExpendedPct := 0;
          Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1:
            CreditLimitLCYExpendedPct := 10000;
          else
            CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);
        end;

        TempSalesTaxLine1.ModifyAll(Modified,false);
        TempSalesTaxLine2.ModifyAll(Modified,false);
        TempSalesTaxLine3.ModifyAll(Modified,false);

        PrevTab := -1;
        SetVATSpecification(ActiveTab);

        SubformIsReady := true;
        OnActivateForm;
    end;

    trigger OnOpenPage()
    begin
        SalesSetup.Get;
        AllowInvDisc := not (SalesSetup."Calc. Inv. Discount" and CustInvDiscRecExists("Invoice Disc. Code"));
        AllowVATDifference :=
          SalesSetup."Allow VAT Difference" and
          not ("Document Type" in ["document type"::Quote]);
        SubformIsEditable := AllowVATDifference or AllowInvDisc or ("Tax Area Code" <> '');
        CurrPage.Editable := SubformIsEditable;
        TaxArea.Get("Tax Area Code");
        SetVATSpecification(ActiveTab);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification(PrevTab);
        if TempSalesTaxLine1.GetAnyLineModified or TempSalesTaxLine2.GetAnyLineModified then
          UpdateTaxonServLines;
        exit(true);
    end;

    var
        Text000: label 'Service %1 Statistics';
        Text001: label 'Total';
        Text002: label 'Amount';
        Text003: label '%1 must not be 0.';
        Text004: label '%1 must not be greater than %2.';
        Text005: label 'You cannot change the invoice discount because there is a %1 record for %2 %3.';
        TotalServLine: array [7] of Record "Service Line";
        TotalServLineLCY: array [7] of Record "Service Line";
        Cust: Record Customer;
        TempSalesTaxLine1: Record UnknownRecord10011 temporary;
        TempSalesTaxLine2: Record UnknownRecord10011 temporary;
        TempSalesTaxLine3: Record UnknownRecord10011 temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        SalesTaxDifference: Record UnknownRecord10012;
        TaxArea: Record "Tax Area";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        ServAmtsMgt: Codeunit "Serv-Amounts Mgt.";
        VATLinesForm: Page "Sales Tax Lines Subform";
        TotalAmount1: array [7] of Decimal;
        TotalAmount2: array [7] of Decimal;
        VATAmount: array [7] of Decimal;
        VATAmountText: array [7] of Text[30];
        ProfitLCY: array [7] of Decimal;
        ProfitPct: array [7] of Decimal;
        AdjProfitLCY: array [7] of Decimal;
        AdjProfitPct: array [7] of Decimal;
        TotalAdjCostLCY: array [7] of Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        i: Integer;
        PrevNo: Code[20];
        ActiveTab: Option General,Invoicing,Shipping,Prepayment;
        PrevTab: Option General,Invoicing,Shipping;
        SubformIsReady: Boolean;
        SubformIsEditable: Boolean;
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
        BreakdownTitle: Text[35];
        BreakdownLabel: array [3,4] of Text[30];
        BreakdownAmt: array [3,4] of Decimal;
        BrkIdx: Integer;
        Text1020010: label 'Tax Breakdown:';
        Text1020011: label 'Sales Tax Breakdown:';
        Text1020012: label 'Other Taxes';
        Text19041261: label 'Items';
        Text19014898: label 'Resources';
        Text19016980: label 'Costs && G/L Accounts';

    local procedure UpdateHeaderInfo(IndexNo: Integer;var SalesTaxAmountLine: Record UnknownRecord10011 temporary)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
    begin
        TotalServLine[IndexNo]."Inv. Discount Amount" := SalesTaxAmountLine.GetTotalInvDiscAmount;
        TotalAmount1[IndexNo] :=
          TotalServLine[IndexNo]."Line Amount" - TotalServLine[IndexNo]."Inv. Discount Amount";
        VATAmount[IndexNo] := SalesTaxAmountLine.GetTotalTaxAmountFCY;
        if "Prices Including VAT" then
          TotalAmount2[IndexNo] := TotalServLine[IndexNo].Amount
        else
          TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];

        if "Prices Including VAT" then
          TotalServLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
        else
          TotalServLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
        if "Currency Code" <> '' then
          if ("Document Type" = "document type"::Quote) and
             ("Posting Date" = 0D)
          then
            UseDate := WorkDate
          else
            UseDate := "Posting Date";

        TotalServLineLCY[IndexNo].Amount :=
          CurrExchRate.ExchangeAmtFCYToLCY(
            UseDate,"Currency Code",TotalServLineLCY[IndexNo].Amount,"Currency Factor");

        ProfitLCY[IndexNo] := TotalServLineLCY[IndexNo].Amount - TotalServLineLCY[IndexNo]."Unit Cost (LCY)";
        if TotalServLineLCY[IndexNo].Amount = 0 then
          ProfitPct[IndexNo] := 0
        else
          ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.01);

        AdjProfitLCY[IndexNo] := TotalServLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
        if TotalServLineLCY[IndexNo].Amount = 0 then
          AdjProfitPct[IndexNo] := 0
        else
          AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.01);
    end;

    local procedure GetVATSpecification(QtyType: Option General,Invoicing,Shipping)
    begin
        case QtyType of
          Qtytype::General:
            begin
              CurrPage.SubForm.Page.GetTempTaxAmountLine(TempSalesTaxLine1);
              UpdateHeaderInfo(1,TempSalesTaxLine1);
            end;
          Qtytype::Invoicing:
            begin
              CurrPage.SubForm.Page.GetTempTaxAmountLine(TempSalesTaxLine2);
              UpdateHeaderInfo(2,TempSalesTaxLine2);
            end;
          Qtytype::Shipping:
            CurrPage.SubForm.Page.GetTempTaxAmountLine(TempSalesTaxLine3);
        end;
    end;

    local procedure SetVATSpecification(QtyType: Option General,Invoicing,Shipping,Prepayment)
    begin
        if not SubformIsReady then
          exit;

        ActiveTab := QtyType;

        if PrevTab >= 0 then
          GetVATSpecification(PrevTab);
        PrevTab := ActiveTab;

        case QtyType of
          Qtytype::General:
            begin
              CurrPage.SubForm.Page.SetTempTaxAmountLine(TempSalesTaxLine1);
              CurrPage.SubForm.Page.InitGlobals(
                "Currency Code",AllowVATDifference,false,
                "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
            end;
          Qtytype::Invoicing:
            begin
              CurrPage.SubForm.Page.SetTempTaxAmountLine(TempSalesTaxLine2);
              CurrPage.SubForm.Page.InitGlobals(
                "Currency Code",AllowVATDifference,AllowVATDifference,
                "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
            end;
          Qtytype::Shipping:
            CurrPage.SubForm.Page.SetTempTaxAmountLine(TempSalesTaxLine3);
        end;
    end;

    local procedure UpdateTotalAmount(IndexNo: Integer)
    var
        SaveTotalAmount: Decimal;
    begin
        CheckAllowInvDisc;
        if "Prices Including VAT" then begin
          SaveTotalAmount := TotalAmount1[IndexNo];
          UpdateInvDiscAmount(IndexNo);
          TotalAmount1[IndexNo] := SaveTotalAmount;
        end;

        with TotalServLine[IndexNo] do
          "Inv. Discount Amount" := "Line Amount" - TotalAmount1[IndexNo];
        UpdateInvDiscAmount(IndexNo);
    end;

    local procedure UpdateInvDiscAmount(ModifiedIndexNo: Integer)
    var
        PartialInvoicing: Boolean;
        MaxIndexNo: Integer;
        IndexNo: array [2] of Integer;
        i: Integer;
        InvDiscBaseAmount: Decimal;
    begin
        CheckAllowInvDisc;
        if not (ModifiedIndexNo in [1,2]) then
          exit;

        if ModifiedIndexNo = 1 then
          InvDiscBaseAmount := TempSalesTaxLine1.GetTotalInvDiscBaseAmount(false,"Currency Code")
        else
          InvDiscBaseAmount := TempSalesTaxLine2.GetTotalInvDiscBaseAmount(false,"Currency Code");

        if InvDiscBaseAmount = 0 then
          Error(Text003,TempSalesTaxLine2.FieldCaption("Inv. Disc. Base Amount"));

        if TotalServLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
          Error(
            Text004,
            TotalServLine[ModifiedIndexNo].FieldCaption("Inv. Discount Amount"),
            TempSalesTaxLine2.FieldCaption("Inv. Disc. Base Amount"));

        PartialInvoicing := (TotalServLine[1]."Line Amount" <> TotalServLine[2]."Line Amount");

        IndexNo[1] := ModifiedIndexNo;
        IndexNo[2] := 3 - ModifiedIndexNo;
        if (ModifiedIndexNo = 2) and PartialInvoicing then
          MaxIndexNo := 1
        else
          MaxIndexNo := 2;

        if not PartialInvoicing then
          if ModifiedIndexNo = 1 then
            TotalServLine[2]."Inv. Discount Amount" := TotalServLine[1]."Inv. Discount Amount"
          else
            TotalServLine[1]."Inv. Discount Amount" := TotalServLine[2]."Inv. Discount Amount";

        for i := 1 to MaxIndexNo do
          with TotalServLine[IndexNo[i]] do begin
            if (i = 1) or not PartialInvoicing then
              if IndexNo[i] = 1 then begin
                TempSalesTaxLine1.SetInvoiceDiscountAmount(
                  "Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
              end else
                TempSalesTaxLine2.SetInvoiceDiscountAmount(
                  "Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");

            if (i = 2) and PartialInvoicing then
              if IndexNo[i] = 1 then begin
                InvDiscBaseAmount := TempSalesTaxLine2.GetTotalInvDiscBaseAmount(false,"Currency Code");
                if InvDiscBaseAmount = 0 then
                  TempSalesTaxLine1.SetInvoiceDiscountPercent(
                    0,"Currency Code","Prices Including VAT",false,"VAT Base Discount %")
                else
                  TempSalesTaxLine1.SetInvoiceDiscountPercent(
                    100 * TempSalesTaxLine2.GetTotalInvDiscAmount / InvDiscBaseAmount,
                    "Currency Code","Prices Including VAT",false,"VAT Base Discount %");
              end else begin
                InvDiscBaseAmount := TempSalesTaxLine1.GetTotalInvDiscBaseAmount(false,"Currency Code");
                if InvDiscBaseAmount = 0 then
                  TempSalesTaxLine2.SetInvoiceDiscountPercent(
                    0,"Currency Code","Prices Including VAT",false,"VAT Base Discount %")
                else
                  TempSalesTaxLine2.SetInvoiceDiscountPercent(
                    100 * TempSalesTaxLine1.GetTotalInvDiscAmount / InvDiscBaseAmount,
                    "Currency Code","Prices Including VAT",false,"VAT Base Discount %");
              end;
          end;

        UpdateHeaderInfo(1,TempSalesTaxLine1);
        UpdateHeaderInfo(2,TempSalesTaxLine2);

        if ModifiedIndexNo = 1 then
          VATLinesForm.SetTempTaxAmountLine(TempSalesTaxLine1)
        else
          VATLinesForm.SetTempTaxAmountLine(TempSalesTaxLine2);

        "Invoice Discount Calculation" := "invoice discount calculation"::Amount;
        "Invoice Discount Value" := TotalServLine[1]."Inv. Discount Amount";
        Modify;

        UpdateTaxonServLines;
    end;

    local procedure GetCaptionClass(FieldCaption: Text[100];ReverseCaption: Boolean): Text[80]
    begin
        if "Prices Including VAT" xor ReverseCaption then
          exit('2,1,' + FieldCaption);
        exit('2,0,' + FieldCaption);
    end;

    local procedure UpdateTaxonServLines()
    var
        ServLine: Record "Service Line";
    begin
        GetVATSpecification(ActiveTab);

        ServLine.Reset;
        ServLine.SetRange("Document Type","Document Type");
        ServLine.SetRange("No.","No.");
        ServLine.FindFirst;

        if TempSalesTaxLine1.GetAnyLineModified then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          SalesTaxCalculate.PutSalesTaxAmountLineTable(
            TempSalesTaxLine1,
            SalesTaxDifference."document product area"::Service,
            "Document Type","No.");
          SalesTaxCalculate.DistTaxOverServLines(ServLine);
          SalesTaxCalculate.SaveTaxDifferences;
        end;
        if TempSalesTaxLine2.GetAnyLineModified then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          SalesTaxCalculate.PutSalesTaxAmountLineTable(
            TempSalesTaxLine2,
            SalesTaxDifference."document product area"::Service,
            "Document Type","No.");
          SalesTaxCalculate.DistTaxOverServLines(ServLine);
          SalesTaxCalculate.SaveTaxDifferences;
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


    procedure VATLinesDrillDown(var VATLinesToDrillDown: Record UnknownRecord10011;ThisTabAllowsVATEditing: Boolean)
    begin
        Clear(VATLinesForm);
        VATLinesForm.SetTempTaxAmountLine(VATLinesToDrillDown);
        VATLinesForm.InitGlobals(
          "Currency Code",AllowVATDifference,AllowVATDifference and ThisTabAllowsVATEditing,
          "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
        VATLinesForm.RunModal;
        VATLinesForm.GetTempTaxAmountLine(VATLinesToDrillDown);
    end;


    procedure GetDetailsTotal(): Decimal
    begin
        if TotalServLineLCY[2].Amount = 0 then
          exit(0);
        exit(ROUND(100 * (ProfitLCY[2] + ProfitLCY[4]) / TotalServLineLCY[2].Amount,0.01));
    end;


    procedure GetAdjDetailsTotal(): Decimal
    begin
        if TotalServLineLCY[2].Amount = 0 then
          exit(0);
        exit(ROUND(100 * (AdjProfitLCY[2] + AdjProfitLCY[4]) / TotalServLineLCY[2].Amount,0.01));
    end;


    procedure UpdateHeaderServLine()
    var
        TempServLine: Record "Service Line" temporary;
    begin
        Clear(ServAmtsMgt);

        for i := 1 to 7 do
          if i in [1,5,6,7] then begin
            TempServLine.DeleteAll;
            Clear(TempServLine);
            ServAmtsMgt.GetServiceLines(Rec,TempServLine,i - 1);

            ServAmtsMgt.SumServiceLinesTemp(
              Rec,TempServLine,i - 1,TotalServLine[i],TotalServLineLCY[i],
              VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);

            if TotalServLineLCY[i].Amount = 0 then
              ProfitPct[i] := 0
            else
              ProfitPct[i] := ROUND(100 * ProfitLCY[i] / TotalServLineLCY[i].Amount,0.1);

            AdjProfitLCY[i] := TotalServLineLCY[i].Amount - TotalAdjCostLCY[i];
            if TotalServLineLCY[i].Amount <> 0 then
              AdjProfitPct[i] := ROUND(100 * AdjProfitLCY[i] / TotalServLineLCY[i].Amount,0.1);

            if "Prices Including VAT" then begin
              TotalAmount2[i] := TotalServLine[i].Amount;
              TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
              TotalServLine[i]."Line Amount" := TotalAmount1[i] + TotalServLine[i]."Inv. Discount Amount";
            end else begin
              TotalAmount1[i] := TotalServLine[i].Amount;
              TotalAmount2[i] := TotalServLine[i]."Amount Including VAT";
            end;
          end;
    end;

    local procedure TotalAmount21OnAfterValidate()
    begin
        with TotalServLine[1] do begin
          if "Prices Including VAT" then
            "Inv. Discount Amount" := "Line Amount" - "Amount Including VAT"
          else
            "Inv. Discount Amount" := "Line Amount" - Amount;
        end;
        UpdateInvDiscAmount(1);
    end;

    local procedure OnActivateForm()
    begin
        SetVATSpecification(ActiveTab);
    end;
}

