#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10039 "Purchase Order Stats."
{
    Caption = 'Purchase Order Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Purchase Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("TotalPurchLine[1].""Line Amount""";TotalPurchLine[1]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Caption = 'Amount';
                    Editable = false;
                }
                field("TotalPurchLine[1].""Inv. Discount Amount""";TotalPurchLine[1]."Inv. Discount Amount")
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
                field("TotalAmount1[1]";TotalAmount1[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Caption = 'Total';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateTotalAmount(1);
                    end;
                }
                field(TaxAmount;VATAmount[1])
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
                    Caption = 'Total Incl. Tax';
                    Editable = false;
                }
                field("TotalPurchLineLCY[1].Amount";TotalPurchLineLCY[1].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Purchase ($)';
                    Editable = false;
                }
                field("TotalPurchLine[1].Quantity";TotalPurchLine[1].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[1].""Units per Parcel""";TotalPurchLine[1]."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[1].""Net Weight""";TotalPurchLine[1]."Net Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[1].""Gross Weight""";TotalPurchLine[1]."Gross Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[1].""Unit Volume""";TotalPurchLine[1]."Unit Volume")
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
                field("BreakdownAmt[1,1]";BreakdownAmt[1,1])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,1]);
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
                field(NoOfVATLines;TempSalesTaxLine1.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempSalesTaxLine1,false,Activetab::General);
                        UpdateHeaderInfo(1,TempSalesTaxLine1);
                    end;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("TotalPurchLine[2].""Line Amount""";TotalPurchLine[2]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Caption = 'Amount';
                    Editable = false;
                }
                field("TotalPurchLine[2].""Inv. Discount Amount""";TotalPurchLine[2]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateInvDiscAmount(2);
                    end;
                }
                field("TotalAmount1[2]";TotalAmount1[2])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Caption = 'Total';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateTotalAmount(2);
                    end;
                }
                field("VATAmount[2]";VATAmount[2])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                    Editable = false;
                }
                field("TotalAmount2[2]";TotalAmount2[2])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Caption = 'Total Incl. Tax';
                    Editable = false;
                }
                field("TotalPurchLineLCY[2].Amount";TotalPurchLineLCY[2].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Purchase ($)';
                    Editable = false;
                }
                field("TotalPurchLine[2].Quantity";TotalPurchLine[2].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[2].""Units per Parcel""";TotalPurchLine[2]."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[2].""Net Weight""";TotalPurchLine[2]."Net Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[2].""Gross Weight""";TotalPurchLine[2]."Gross Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[2].""Unit Volume""";TotalPurchLine[2]."Unit Volume")
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                label(BreakdownTitle2)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(BreakdownTitle);
                }
                field(BreakdownAmt5;BreakdownAmt[2,1])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2,1]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt6;BreakdownAmt[2,2])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2,2]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt7;BreakdownAmt[2,3])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2,3]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt8;BreakdownAmt[2,4])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2,4]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(NoOfVATLines_Invoice;TempSalesTaxLine2.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempSalesTaxLine2,true,Activetab::Invoicing);
                        UpdateHeaderInfo(2,TempSalesTaxLine2);
                    end;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("TotalPurchLine[3].""Line Amount""";TotalPurchLine[3]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Caption = 'Amount';
                    Editable = false;
                }
                field("TotalPurchLine[3].""Inv. Discount Amount""";TotalPurchLine[3]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;
                }
                field("TotalAmount1[3]";TotalAmount1[3])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Caption = 'Total';
                    Editable = false;
                }
                field("VATAmount[3]";VATAmount[3])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                    Editable = false;
                }
                field("TotalAmount2[3]";TotalAmount2[3])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Caption = 'Total Incl. Tax';
                    Editable = false;
                }
                field("TotalPurchLineLCY[3].Amount";TotalPurchLineLCY[3].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Purchase ($)';
                    Editable = false;
                }
                field("TotalPurchLine[3].Quantity";TotalPurchLine[3].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[3].""Units per Parcel""";TotalPurchLine[3]."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[3].""Net Weight""";TotalPurchLine[3]."Net Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[3].""Gross Weight""";TotalPurchLine[3]."Gross Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalPurchLine[3].""Unit Volume""";TotalPurchLine[3]."Unit Volume")
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                label(BreakdownTitle3)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(BreakdownTitle);
                }
                field(BreakdownAmt9;BreakdownAmt[3,1])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3,1]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt10;BreakdownAmt[3,2])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3,2]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt11;BreakdownAmt[3,3])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3,3]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(BreakdownAmt12;BreakdownAmt[3,4])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3,4]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                }
                field(NoOfVATLines_Shipping;TempSalesTaxLine3.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempSalesTaxLine3,false,Activetab::Shipping);
                        UpdateHeaderInfo(3,TempSalesTaxLine3);
                    end;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                field(PrepmtTotalAmount;PrepmtTotalAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text006,false);

                    trigger OnValidate()
                    begin
                        UpdatePrepmtAmount;
                    end;
                }
                field(PrepmtVATAmount;PrepmtVATAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(PrepmtVATAmountText);
                    Caption = 'Prepayment Amount Invoiced';
                    Editable = false;
                }
                field(PrepmtTotalAmount2;PrepmtTotalAmount2)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text006,true);
                    Caption = 'Prepmt. Amount Invoiced';
                    Editable = false;
                }
                field("TotalPurchLine[1].""Prepmt. Amt. Inv.""";TotalPurchLine[1]."Prepmt. Amt. Inv.")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text007,false);
                    Editable = false;
                }
                field(PrepmtInvPct;PrepmtInvPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced % of Prepayment Amt.';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Specifies the Invoiced Percentage of Prepayment Amt.';
                }
                field("TotalPurchLine[1].""Prepmt Amt Deducted""";TotalPurchLine[1]."Prepmt Amt Deducted")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text008,false);
                    Editable = false;
                }
                field(PrepmtDeductedPct;PrepmtDeductedPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deducted % of Prepayment Amt. to Deduct';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Specifies the Deducted Percentage of Prepayment Amt. to Deduct.';
                }
                field("TotalPurchLine[1].""Prepmt Amt to Deduct""";TotalPurchLine[1]."Prepmt Amt to Deduct")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text009,false);
                    Editable = false;
                }
                field(NoOfVATLines_Prepayment;TempVATAmountLine4.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempSalesTaxLine1,false,Activetab::Prepayment);
                        UpdateHeaderInfo(1,TempSalesTaxLine1);
                    end;
                }
            }
            group(Vendor)
            {
                Caption = 'Vendor';
                field("Vend.""Balance (LCY)""";Vend."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
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

        Clear(PurchLine);
        Clear(TotalPurchLine);
        Clear(TotalPurchLineLCY);
        Clear(BreakdownLabel);
        Clear(BreakdownAmt);

        PurchLine.Reset;

        for i := 1 to 3 do begin
          TempPurchLine.DeleteAll;
          Clear(TempPurchLine);
          Clear(PurchPost);
          PurchPost.GetPurchLines(Rec,TempPurchLine,i - 1);
          Clear(PurchPost);
          SalesTaxCalculate.StartSalesTaxCalculation;
          TempPurchLine.SetFilter(Type,'>0');
          TempPurchLine.SetFilter(Quantity,'<>0');
          if TempPurchLine.Find('-') then
            repeat
              SalesTaxCalculate.AddPurchLine(TempPurchLine);
            until TempPurchLine.Next = 0;
          TempPurchLine.Reset;
          case i of
            1:
              begin
                TempSalesTaxLine1.DeleteAll;
                SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
                SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine1);
              end;
            2:
              begin
                TempSalesTaxLine2.DeleteAll;
                SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
                SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine2);
              end;
            3:
              begin
                TempSalesTaxLine3.DeleteAll;
                SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
                SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine3);
              end;
          end;

          if Status = Status::Open then
            SalesTaxCalculate.DistTaxOverPurchLines(TempPurchLine);
          PurchPost.SumPurchLinesTemp(
            Rec,TempPurchLine,i - 1,TotalPurchLine[i],TotalPurchLineLCY[i],
            VATAmount[i],VATAmountText[i]);
          TotalAmount1[i] := TotalPurchLine[i].Amount;
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
                  if BrkIdx > ArrayLen(BreakdownAmt,2) then begin
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
        TempPurchLine.DeleteAll;
        Clear(TempPurchLine);
        PurchPostPrepmt.GetPurchLines(Rec,0,TempPurchLine);
        PurchPostPrepmt.SumPrepmt(
          Rec,TempPurchLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
        PrepmtInvPct :=
          Pct(TotalPurchLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
        PrepmtDeductedPct :=
          Pct(TotalPurchLine[1]."Prepmt Amt Deducted",TotalPurchLine[1]."Prepmt. Amt. Inv.");
        if "Prices Including VAT" then begin
          PrepmtTotalAmount2 := PrepmtTotalAmount;
          PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
        end else
          PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;

        if Vend.Get("Pay-to Vendor No.") then
          Vend.CalcFields("Balance (LCY)")
        else
          Clear(Vend);

        TempSalesTaxLine1.ModifyAll(Modified,false);
        TempSalesTaxLine2.ModifyAll(Modified,false);
        TempSalesTaxLine3.ModifyAll(Modified,false);

        PrevTab := -1;
    end;

    trigger OnOpenPage()
    begin
        PurchSetup.Get;
        AllowInvDisc :=
          not (PurchSetup."Calc. Inv. Discount" and VendInvDiscRecExists("Invoice Disc. Code"));
        AllowVATDifference :=
          PurchSetup."Allow VAT Difference" and
          not ("Document Type" in ["document type"::Quote,"document type"::"Blanket Order"]);
        VATLinesFormIsEditable := AllowVATDifference or AllowInvDisc or ("Tax Area Code" <> '');
        CurrPage.Editable := VATLinesFormIsEditable;
        TaxArea.Get("Tax Area Code");
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification(PrevTab);
        if TempSalesTaxLine1.GetAnyLineModified or TempSalesTaxLine2.GetAnyLineModified then
          UpdateTaxonPurchLines;
        exit(true);
    end;

    var
        Text000: label 'Purchase %1 Statistics';
        Text001: label 'Total';
        Text002: label 'Amount';
        Text003: label '%1 must not be 0.';
        Text004: label '%1 must not be greater than %2.';
        Text005: label 'You cannot change the invoice discount because there is a %1 record for %2 %3.';
        TotalPurchLine: array [3] of Record "Purchase Line";
        TotalPurchLineLCY: array [3] of Record "Purchase Line";
        Vend: Record Vendor;
        TempSalesTaxLine1: Record UnknownRecord10011 temporary;
        TempSalesTaxLine2: Record UnknownRecord10011 temporary;
        TempSalesTaxLine3: Record UnknownRecord10011 temporary;
        TempVATAmountLine4: Record "VAT Amount Line" temporary;
        PurchSetup: Record "Purchases & Payables Setup";
        SalesTaxDifference: Record UnknownRecord10012;
        TaxArea: Record "Tax Area";
        PurchPost: Codeunit "Purch.-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        VATLinesForm: Page "Sales Tax Lines Subform Dyn";
        TotalAmount1: array [3] of Decimal;
        TotalAmount2: array [3] of Decimal;
        VATAmount: array [3] of Decimal;
        PrepmtTotalAmount: Decimal;
        PrepmtVATAmount: Decimal;
        PrepmtTotalAmount2: Decimal;
        PrepmtVATAmountText: Text[30];
        PrepmtInvPct: Decimal;
        PrepmtDeductedPct: Decimal;
        VATAmountText: array [3] of Text[30];
        i: Integer;
        PrevNo: Code[20];
        ActiveTab: Option General,Invoicing,Shipping,Prepayment;
        PrevTab: Option General,Invoicing,Shipping,Prepayment;
        VATLinesFormIsEditable: Boolean;
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
        Text006: label 'Prepmt. Amount';
        Text007: label 'Prepmt. Amt. Invoiced';
        Text008: label 'Prepmt. Amt. Deducted';
        Text009: label 'Prepmt. Amt. to Deduct';
        BreakdownTitle: Text[35];
        BreakdownLabel: array [3,4] of Text[30];
        BreakdownAmt: array [3,4] of Decimal;
        BrkIdx: Integer;
        Text1020010: label 'Tax Breakdown:';
        Text1020011: label 'Sales Tax Breakdown:';
        Text1020012: label 'Other Taxes';

    local procedure UpdateHeaderInfo(IndexNo: Integer;var VATAmountLine: Record UnknownRecord10011)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
    begin
        TotalPurchLine[IndexNo]."Inv. Discount Amount" := VATAmountLine.GetTotalInvDiscAmount;
        TotalAmount1[IndexNo] :=
          TotalPurchLine[IndexNo]."Line Amount" - TotalPurchLine[IndexNo]."Inv. Discount Amount";
        VATAmount[IndexNo] := VATAmountLine.GetTotalTaxAmountFCY;
        if "Prices Including VAT" then
          TotalAmount2[IndexNo] := TotalPurchLine[IndexNo].Amount
        else
          TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];

        if "Prices Including VAT" then
          TotalPurchLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
        else
          TotalPurchLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
        if "Currency Code" <> '' then begin
          if ("Document Type" in ["document type"::"Blanket Order","document type"::Quote]) and
             ("Posting Date" = 0D)
          then
            UseDate := WorkDate
          else
            UseDate := "Posting Date";

          TotalPurchLineLCY[IndexNo].Amount :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              UseDate,"Currency Code",TotalPurchLineLCY[IndexNo].Amount,"Currency Factor");
        end;
    end;

    local procedure GetVATSpecification(StatisticsTab: Option General,Invoicing,Shipping)
    begin
        case StatisticsTab of
          Statisticstab::General:
            begin
              VATLinesForm.GetTempTaxAmountLine(TempSalesTaxLine1);
              UpdateHeaderInfo(1,TempSalesTaxLine1);
            end;
          Statisticstab::Invoicing:
            begin
              VATLinesForm.GetTempTaxAmountLine(TempSalesTaxLine2);
              UpdateHeaderInfo(2,TempSalesTaxLine2);
            end;
          Statisticstab::Shipping:
            VATLinesForm.GetTempTaxAmountLine(TempSalesTaxLine3);
        end;
    end;

    local procedure SetEditableForVATLinesForm(StatisticsTab: Option General,Invoicing,Shipping,Prepayment)
    begin
        case StatisticsTab of
          Statisticstab::General,Statisticstab::Invoicing:
            if Status = Status::Open then
              VATLinesForm.Editable := false
            else
              VATLinesForm.Editable := VATLinesFormIsEditable;
          Statisticstab::Shipping:
            VATLinesForm.Editable := false;
          Statisticstab::Prepayment:
            VATLinesForm.Editable := VATLinesFormIsEditable;
        end;
    end;

    local procedure UpdateTotalAmount(IndexNo: Integer)
    begin
        CheckAllowInvDisc;
        with TotalPurchLine[IndexNo] do
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

        if TotalPurchLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
          Error(
            Text004,
            TotalPurchLine[ModifiedIndexNo].FieldCaption("Inv. Discount Amount"),
            TempSalesTaxLine2.FieldCaption("Inv. Disc. Base Amount"));

        PartialInvoicing := (TotalPurchLine[1]."Line Amount" <> TotalPurchLine[2]."Line Amount");

        IndexNo[1] := ModifiedIndexNo;
        IndexNo[2] := 3 - ModifiedIndexNo;
        if (ModifiedIndexNo = 2) and PartialInvoicing then
          MaxIndexNo := 1
        else
          MaxIndexNo := 2;

        if not PartialInvoicing then
          if ModifiedIndexNo = 1 then
            TotalPurchLine[2]."Inv. Discount Amount" := TotalPurchLine[1]."Inv. Discount Amount"
          else
            TotalPurchLine[1]."Inv. Discount Amount" := TotalPurchLine[2]."Inv. Discount Amount";

        for i := 1 to MaxIndexNo do
          with TotalPurchLine[IndexNo[i]] do begin
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
        "Invoice Discount Value" := TotalPurchLine[1]."Inv. Discount Amount";
        Modify;
        UpdateTaxonPurchLines;
    end;

    local procedure UpdatePrepmtAmount()
    var
        TempPurchLine: Record "Purchase Line" temporary;
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
    begin
        PurchPostPrepmt.UpdatePrepmtAmountOnPurchLines(Rec,PrepmtTotalAmount);
        PurchPostPrepmt.GetPurchLines(Rec,0,TempPurchLine);
        PurchPostPrepmt.SumPrepmt(
          Rec,TempPurchLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
        PrepmtInvPct :=
          Pct(TotalPurchLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
        PrepmtDeductedPct :=
          Pct(TotalPurchLine[1]."Prepmt Amt Deducted",TotalPurchLine[1]."Prepmt. Amt. Inv.");
        if "Prices Including VAT" then begin
          PrepmtTotalAmount2 := PrepmtTotalAmount;
          PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
        end else
          PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;
        Modify;
    end;

    local procedure GetCaptionClass(FieldCaption: Text[100];ReverseCaption: Boolean): Text[80]
    begin
        if "Prices Including VAT" xor ReverseCaption then
          exit('2,1,' + FieldCaption);

        exit('2,0,' + FieldCaption);
    end;

    local procedure UpdateTaxonPurchLines()
    var
        PurchLine: Record "Purchase Line";
    begin
        GetVATSpecification(ActiveTab);

        PurchLine.Reset;
        PurchLine.SetRange("Document Type","Document Type");
        PurchLine.SetRange("Document No.","No.");
        PurchLine.FindFirst;

        if TempSalesTaxLine1.GetAnyLineModified then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          SalesTaxCalculate.PutSalesTaxAmountLineTable(
            TempSalesTaxLine1,
            SalesTaxDifference."document product area"::Purchase,
            "Document Type","No.");
          SalesTaxCalculate.DistTaxOverPurchLines(PurchLine);
          SalesTaxCalculate.SaveTaxDifferences;
        end;
        if TempSalesTaxLine2.GetAnyLineModified then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          SalesTaxCalculate.PutSalesTaxAmountLineTable(
            TempSalesTaxLine2,
            SalesTaxDifference."document product area"::Purchase,
            "Document Type","No.");
          SalesTaxCalculate.DistTaxOverPurchLines(PurchLine);
          SalesTaxCalculate.SaveTaxDifferences;
        end;
        PrevNo := '';
    end;

    local procedure VendInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        VendInvDisc: Record "Vendor Invoice Disc.";
    begin
        VendInvDisc.SetRange(Code,InvDiscCode);
        exit(VendInvDisc.FindFirst);
    end;

    local procedure CheckAllowInvDisc()
    var
        VendInvDisc: Record "Vendor Invoice Disc.";
    begin
        if not AllowInvDisc then
          Error(
            Text005,
            VendInvDisc.TableCaption,FieldCaption("Invoice Disc. Code"),"Invoice Disc. Code");
    end;

    local procedure Pct(Numerator: Decimal;Denominator: Decimal): Decimal
    begin
        if Denominator = 0 then
          exit(0);
        exit(ROUND(Numerator / Denominator * 10000,1));
    end;


    procedure VATLinesDrillDown(var VATLinesToDrillDown: Record UnknownRecord10011;ThisTabAllowsVATEditing: Boolean;ActiveTab: Option General,Invoicing,Shipping,Prepayment)
    begin
        Clear(VATLinesForm);
        VATLinesForm.SetTempTaxAmountLine(VATLinesToDrillDown);
        VATLinesForm.InitGlobals(
          "Currency Code",AllowVATDifference,AllowVATDifference and ThisTabAllowsVATEditing,
          "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
        SetEditableForVATLinesForm(ActiveTab);
        VATLinesForm.RunModal;
        VATLinesForm.GetTempTaxAmountLine(VATLinesToDrillDown);
    end;
}

