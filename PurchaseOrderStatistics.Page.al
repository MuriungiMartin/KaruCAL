#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 403 "Purchase Order Statistics"
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
                field(LineAmountGeneral;TotalPurchLine[1]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Caption = 'Amount';
                    Editable = false;
                }
                field(InvDiscountAmount_General;TotalPurchLine[1]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';

                    trigger OnValidate()
                    begin
                        ActiveTab := Activetab::General;
                        UpdateInvDiscAmount(1);
                    end;
                }
                field(Total_General;TotalAmount1[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Caption = 'Total';

                    trigger OnValidate()
                    begin
                        ActiveTab := Activetab::General;
                        UpdateTotalAmount(1);
                    end;
                }
                field("VATAmount[1]";VATAmount[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText[1]);
                    Caption = 'Tax Amount';
                    Editable = false;
                }
                field(TotalInclVAT_General;TotalAmount2[1])
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
                field(Quantity_General;TotalPurchLine[1].Quantity)
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
                field(NoOfVATLines_General;TempVATAmountLine1.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempVATAmountLine1,false);
                        UpdateHeaderInfo(1,TempVATAmountLine1);
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

                    trigger OnValidate()
                    begin
                        ActiveTab := Activetab::Invoicing;
                        UpdateInvDiscAmount(2);
                    end;
                }
                field(Total_Invoicing;TotalAmount1[2])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Caption = 'Total';

                    trigger OnValidate()
                    begin
                        ActiveTab := Activetab::Invoicing;
                        UpdateTotalAmount(2);
                    end;
                }
                field(VATAmount_Invoicing;VATAmount[2])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText[2]);
                    Caption = 'Tax Amount';
                    Editable = false;
                }
                field(TotalInclVAT_Invoicing;TotalAmount2[2])
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
                field(Quantity_Invoicing;TotalPurchLine[2].Quantity)
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
                field(NoOfVATLines_Invoicing;TempVATAmountLine2.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ActiveTab := Activetab::Invoicing;
                        VATLinesDrillDown(TempVATAmountLine2,true);
                        UpdateHeaderInfo(2,TempVATAmountLine2);

                        if TempVATAmountLine2.GetAnyLineModified then begin
                          UpdateVATOnPurchLines;
                          RefreshOnAfterGetRecord;
                        end;
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
                    CaptionClass = FORMAT(VATAmountText[3]);
                    Caption = 'Tax Amount';
                    Editable = false;
                }
                field(TotalInclVAT_Shipping;TotalAmount2[3])
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
                field(Quantity_Shipping;TotalPurchLine[3].Quantity)
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
                field("TempVATAmountLine3.COUNT";TempVATAmountLine3.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempVATAmountLine3,false);
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
                        ActiveTab := Activetab::Prepayment;
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
                    ToolTip = 'Specifies the invoiced percentage of the prepayment amount.';
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
                    ToolTip = 'Specifies the deducted percentage of the prepayment amount to deduct.';
                }
                field("TotalPurchLine[1].""Prepmt Amt to Deduct""";TotalPurchLine[1]."Prepmt Amt to Deduct")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text009,false);
                    Editable = false;
                }
                field("TempVATAmountLine4.COUNT";TempVATAmountLine4.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempVATAmountLine4,true);
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
    begin
        RefreshOnAfterGetRecord;
    end;

    trigger OnOpenPage()
    begin
        PurchSetup.Get;
        AllowInvDisc :=
          not (PurchSetup."Calc. Inv. Discount" and VendInvDiscRecExists("Invoice Disc. Code"));
        AllowVATDifference :=
          PurchSetup."Allow VAT Difference" and
          not ("Document Type" in ["document type"::Quote,"document type"::"Blanket Order"]);
        VATLinesFormIsEditable := AllowVATDifference or AllowInvDisc;
        CurrPage.Editable := VATLinesFormIsEditable;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification(PrevTab);
        if TempVATAmountLine1.GetAnyLineModified or TempVATAmountLine2.GetAnyLineModified then
          UpdateVATOnPurchLines;
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
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        TempVATAmountLine2: Record "VAT Amount Line" temporary;
        TempVATAmountLine3: Record "VAT Amount Line" temporary;
        TempVATAmountLine4: Record "VAT Amount Line" temporary;
        PurchSetup: Record "Purchases & Payables Setup";
        PurchPost: Codeunit "Purch.-Post";
        VATLinesForm: Page "VAT Amount Lines";
        TotalAmount1: array [3] of Decimal;
        TotalAmount2: array [3] of Decimal;
        VATAmount: array [3] of Decimal;
        PrepmtTotalAmount: Decimal;
        PrepmtVATAmount: Decimal;
        PrepmtTotalAmount2: Decimal;
        VATAmountText: array [3] of Text[30];
        PrepmtVATAmountText: Text[30];
        PrepmtInvPct: Decimal;
        PrepmtDeductedPct: Decimal;
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
        UpdateInvDiscountQst: label 'There are one or more invoiced lines.\Do you want to update the invoice discount?';

    local procedure RefreshOnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
        PurchPostPrepayments: Codeunit "Purchase-Post Prepayments";
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

        for i := 1 to 3 do begin
          TempPurchLine.DeleteAll;
          Clear(TempPurchLine);
          Clear(PurchPost);
          PurchPost.GetPurchLines(Rec,TempPurchLine,i - 1);
          Clear(PurchPost);
          case i of
            1:
              PurchLine.CalcVATAmountLines(0,Rec,TempPurchLine,TempVATAmountLine1);
            2:
              PurchLine.CalcVATAmountLines(0,Rec,TempPurchLine,TempVATAmountLine2);
            3:
              PurchLine.CalcVATAmountLines(0,Rec,TempPurchLine,TempVATAmountLine3);
          end;

          PurchPost.SumPurchLinesTemp(
            Rec,TempPurchLine,i - 1,TotalPurchLine[i],TotalPurchLineLCY[i],
            VATAmount[i],VATAmountText[i]);
          if "Prices Including VAT" then begin
            TotalAmount2[i] := TotalPurchLine[i].Amount;
            TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
            TotalPurchLine[i]."Line Amount" := TotalAmount1[i] + TotalPurchLine[i]."Inv. Discount Amount";
          end else begin
            TotalAmount1[i] := TotalPurchLine[i].Amount;
            TotalAmount2[i] := TotalPurchLine[i]."Amount Including VAT";
          end;
        end;
        TempPurchLine.DeleteAll;
        Clear(TempPurchLine);
        PurchPostPrepayments.GetPurchLines(Rec,0,TempPurchLine);
        PurchPostPrepayments.SumPrepmt(
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

        TempVATAmountLine1.ModifyAll(Modified,false);
        TempVATAmountLine2.ModifyAll(Modified,false);
        TempVATAmountLine3.ModifyAll(Modified,false);
        TempVATAmountLine4.ModifyAll(Modified,false);

        PrevTab := -1;
        UpdateHeaderInfo(2,TempVATAmountLine2);
    end;

    local procedure UpdateHeaderInfo(IndexNo: Integer;var VATAmountLine: Record "VAT Amount Line")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
    begin
        TotalPurchLine[IndexNo]."Inv. Discount Amount" := VATAmountLine.GetTotalInvDiscAmount;
        TotalAmount1[IndexNo] :=
          TotalPurchLine[IndexNo]."Line Amount" - TotalPurchLine[IndexNo]."Inv. Discount Amount";
        VATAmount[IndexNo] := VATAmountLine.GetTotalVATAmount;
        if "Prices Including VAT" then begin
          TotalAmount1[IndexNo] := VATAmountLine.GetTotalAmountInclVAT;
          TotalAmount2[IndexNo] := TotalAmount1[IndexNo] - VATAmount[IndexNo];
          TotalPurchLine[IndexNo]."Line Amount" :=
            TotalAmount1[IndexNo] + TotalPurchLine[IndexNo]."Inv. Discount Amount";
        end else
          TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];

        if "Prices Including VAT" then
          TotalPurchLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
        else
          TotalPurchLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
        if "Currency Code" <> '' then begin
          if "Posting Date" = 0D then
            UseDate := WorkDate
          else
            UseDate := "Posting Date";

          TotalPurchLineLCY[IndexNo].Amount :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              UseDate,"Currency Code",TotalPurchLineLCY[IndexNo].Amount,"Currency Factor");
        end;
    end;

    local procedure GetVATSpecification(QtyType: Option General,Invoicing,Shipping)
    begin
        case QtyType of
          Qtytype::General:
            begin
              VATLinesForm.GetTempVATAmountLine(TempVATAmountLine1);
              if TempVATAmountLine1.GetAnyLineModified then
                UpdateHeaderInfo(1,TempVATAmountLine1);
            end;
          Qtytype::Invoicing:
            begin
              VATLinesForm.GetTempVATAmountLine(TempVATAmountLine2);
              if TempVATAmountLine2.GetAnyLineModified then
                UpdateHeaderInfo(2,TempVATAmountLine2);
            end;
          Qtytype::Shipping:
            VATLinesForm.GetTempVATAmountLine(TempVATAmountLine3);
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

        if InvoicedLineExists then
          if not Confirm(UpdateInvDiscountQst,false) then
            Error('');

        if ModifiedIndexNo = 1 then
          InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(false,"Currency Code")
        else
          InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(false,"Currency Code");

        if InvDiscBaseAmount = 0 then
          Error(Text003,TempVATAmountLine2.FieldCaption("Inv. Disc. Base Amount"));

        if TotalPurchLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
          Error(
            Text004,
            TotalPurchLine[ModifiedIndexNo].FieldCaption("Inv. Discount Amount"),
            TempVATAmountLine2.FieldCaption("Inv. Disc. Base Amount"));

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
                TempVATAmountLine1.SetInvoiceDiscountAmount(
                  "Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
              end else
                TempVATAmountLine2.SetInvoiceDiscountAmount(
                  "Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");

            if (i = 2) and PartialInvoicing then
              if IndexNo[i] = 1 then begin
                InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(false,"Currency Code");
                if InvDiscBaseAmount = 0 then
                  TempVATAmountLine1.SetInvoiceDiscountPercent(
                    0,"Currency Code","Prices Including VAT",false,"VAT Base Discount %")
                else
                  TempVATAmountLine1.SetInvoiceDiscountPercent(
                    100 * TempVATAmountLine2.GetTotalInvDiscAmount / InvDiscBaseAmount,
                    "Currency Code","Prices Including VAT",false,"VAT Base Discount %");
              end else begin
                InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(false,"Currency Code");
                if InvDiscBaseAmount = 0 then
                  TempVATAmountLine2.SetInvoiceDiscountPercent(
                    0,"Currency Code","Prices Including VAT",false,"VAT Base Discount %")
                else
                  TempVATAmountLine2.SetInvoiceDiscountPercent(
                    100 * TempVATAmountLine1.GetTotalInvDiscAmount / InvDiscBaseAmount,
                    "Currency Code","Prices Including VAT",false,"VAT Base Discount %");
              end;
          end;

        UpdateHeaderInfo(1,TempVATAmountLine1);
        UpdateHeaderInfo(2,TempVATAmountLine2);

        if ModifiedIndexNo = 1 then
          VATLinesForm.SetTempVATAmountLine(TempVATAmountLine1)
        else
          VATLinesForm.SetTempVATAmountLine(TempVATAmountLine2);

        "Invoice Discount Calculation" := "invoice discount calculation"::Amount;
        "Invoice Discount Value" := TotalPurchLine[1]."Inv. Discount Amount";
        Modify;
        UpdateVATOnPurchLines;
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

    local procedure UpdateVATOnPurchLines()
    var
        PurchLine: Record "Purchase Line";
    begin
        GetVATSpecification(ActiveTab);
        if TempVATAmountLine1.GetAnyLineModified then
          PurchLine.UpdateVATOnLines(0,Rec,PurchLine,TempVATAmountLine1);
        if TempVATAmountLine2.GetAnyLineModified then
          PurchLine.UpdateVATOnLines(1,Rec,PurchLine,TempVATAmountLine2);
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

    local procedure VATLinesDrillDown(var VATLinesToDrillDown: Record "VAT Amount Line";ThisTabAllowsVATEditing: Boolean)
    begin
        Clear(VATLinesForm);
        VATLinesForm.SetTempVATAmountLine(VATLinesToDrillDown);
        VATLinesForm.InitGlobals(
          "Currency Code",AllowVATDifference,AllowVATDifference and ThisTabAllowsVATEditing,
          "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
        VATLinesForm.RunModal;
        VATLinesForm.GetTempVATAmountLine(VATLinesToDrillDown);
    end;
}

