#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6030 "Service Statistics"
{
    Caption = 'Service Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = "Service Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Amount_General;TotalServLine[1]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Caption = 'Amount';
                    Editable = false;
                }
                field("Inv. Discount Amount_General";TotalServLine[1]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';

                    trigger OnValidate()
                    begin
                        UpdateInvDiscAmount;
                    end;
                }
                field("TotalAmount1[1]";TotalAmount1[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Caption = 'Total';

                    trigger OnValidate()
                    begin
                        UpdateTotalAmount(1);
                    end;
                }
                field("VAT Amount_General";VATAmount[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText[1]);
                    Caption = 'Tax Amount';
                    Editable = false;
                }
                field("Total Incl. VAT_General";TotalAmount2[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Caption = 'Total Incl. Tax';
                    Editable = false;
                }
                field("Sales (LCY)_General";TotalServLineLCY[1].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                }
                field("ProfitLCY[1]";ProfitLCY[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Profit ($)';
                    Editable = false;
                }
                field("AdjProfitLCY[1]";AdjProfitLCY[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit ($)';
                    Editable = false;
                }
                field("ProfitPct[1]";ProfitPct[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("AdjProfitPct[1]";AdjProfitPct[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("TotalServLine[1].Quantity";TotalServLine[1].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
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
                field("TotalServLineLCY[1].""Unit Cost (LCY)""";TotalServLineLCY[1]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                    Editable = false;
                }
                field("TotalAdjCostLCY[1]";TotalAdjCostLCY[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost ($)';
                    Editable = false;
                }
                field("TotalAdjCostLCY[1] - TotalServLineLCY[1].""Unit Cost (LCY)""";TotalAdjCostLCY[1] - TotalServLineLCY[1]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost Adjmt. Amount ($)';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupAdjmtValueEntries(0);
                    end;
                }
            }
            part(SubForm;"VAT Specification Subform")
            {
            }
            group("Service Line")
            {
                Caption = 'Service Line';
                fixed(Control1904230801)
                {
                    group(Items)
                    {
                        Caption = 'Items';
                        field("TotalServLine[5].Quantity";TotalServLine[5].Quantity)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field(Amount_Items;TotalServLine[5]."Line Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Amount';
                            Editable = false;
                        }
                        field("Inv. Discount Amount_Items";TotalServLine[5]."Inv. Discount Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Inv. Discount Amount';
                            Editable = false;
                        }
                        field(Total;TotalAmount1[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Total';
                            Editable = false;

                            trigger OnValidate()
                            begin
                                UpdateTotalAmount(2);
                            end;
                        }
                        field("VAT Amount_Items";VATAmount[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Tax Amount';
                            Editable = false;
                        }
                        field("Total Incl. VAT_Items";TotalAmount2[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Total Amount';
                            Editable = false;
                        }
                        field("Sales (LCY)_Items";TotalServLineLCY[5].Amount)
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
                    }
                    group(Resources)
                    {
                        Caption = 'Resources';
                        field("TotalServLine[6].Quantity";TotalServLine[6].Quantity)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field(Amount_Resources;TotalServLine[6]."Line Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            CaptionClass = GetCaptionClass(Text002,false);
                            Editable = false;
                        }
                        field("Inv. Discount Amount_Resources";TotalServLine[6]."Inv. Discount Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Inv. Discount Amount';
                            Editable = false;
                        }
                        field("TotalAmount1[6]";TotalAmount1[6])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            CaptionClass = GetCaptionClass(Text001,false);
                            Editable = false;

                            trigger OnValidate()
                            begin
                                UpdateTotalAmount(2);
                            end;
                        }
                        field("VAT Amount_Resources";VATAmount[6])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("Total Incl. VAT_Resources";TotalAmount2[6])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            CaptionClass = GetCaptionClass(Text001,true);
                            Editable = false;
                        }
                        field("Sales (LCY)_Resources";TotalServLineLCY[6].Amount)
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
                        field("AdjProfitLCY[6]";AdjProfitLCY[6])
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
                        field(Text006;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field("TotalServLineLCY[6].""Unit Cost (LCY)""";TotalServLineLCY[6]."Unit Cost (LCY)")
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost ($)';
                            Editable = false;
                        }
                        field(Control85;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control98;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                    }
                    group("Costs && G/L Accounts")
                    {
                        Caption = 'Costs && G/L Accounts';
                        field("TotalServLine[7].Quantity";TotalServLine[7].Quantity)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field(Amount_Costs;TotalServLine[7]."Line Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            CaptionClass = GetCaptionClass(Text002,false);
                            Editable = false;
                        }
                        field("Inv. Discount Amount_Costs";TotalServLine[7]."Inv. Discount Amount")
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

                            trigger OnValidate()
                            begin
                                UpdateTotalAmount(2);
                            end;
                        }
                        field("VAT Amount_Costs";VATAmount[7])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("Total Incl. VAT_Costs";TotalAmount2[7])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            CaptionClass = GetCaptionClass(Text001,true);
                            Editable = false;
                        }
                        field("Sales (LCY)_Costs";TotalServLineLCY[7].Amount)
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Amount ($)';
                            Editable = false;
                        }
                        field("ProfitLCY[7]";ProfitLCY[7])
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
                        field("ProfitPct[7]";ProfitPct[7])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                            Editable = false;
                        }
                        field(Control64;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field("TotalServLineLCY[7].""Unit Cost (LCY)""";TotalServLineLCY[7]."Unit Cost (LCY)")
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost ($)';
                            Editable = false;
                        }
                        field(Control87;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control99;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                    }
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
                field("Credit Limit (LCY)";Cust."Credit Limit (LCY)")
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
        ServLine: Record "Service Line";
        TempServLine: Record "Service Line" temporary;
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

        Clear(ServLine);
        Clear(TotalServLine);
        Clear(TotalServLineLCY);
        Clear(ServAmtsMgt);

        for i := 1 to 7 do begin
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
              AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalServLineLCY[i].Amount * 100,0.1);

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

        TempServLine.DeleteAll;
        Clear(TempServLine);
        ServAmtsMgt.GetServiceLines(Rec,TempServLine,0);
        ServLine.CalcVATAmountLines(0,Rec,TempServLine,TempVATAmountLine,false);
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
          ("Document Type" <> "document type"::Quote);
        CurrPage.Editable :=
          AllowVATDifference or AllowInvDisc;
        SetVATSpecification;
        CurrPage.SubForm.Page.SetParentControl := Page::"Service Statistics";
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification;
        if TempVATAmountLine.GetAnyLineModified then
          UpdateVATOnServLines;
        exit(true);
    end;

    var
        Text000: label 'Service %1 Statistics';
        Text001: label 'Total';
        Text002: label 'Amount';
        Text003: label '%1 must not be 0.';
        Text004: label '%1 must not be greater than %2.';
        Text005: label 'You cannot change the invoice discount because there is a %1 record for %2 %3.', Comment='You cannot change the invoice discount because there is a Cust. Invoice Disc. record for Invoice Disc. Code 10000.';
        TotalServLine: array [7] of Record "Service Line";
        TotalServLineLCY: array [7] of Record "Service Line";
        Cust: Record Customer;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        ServAmtsMgt: Codeunit "Serv-Amounts Mgt.";
        TotalAmount1: array [7] of Decimal;
        TotalAmount2: array [7] of Decimal;
        AdjProfitPct: array [7] of Decimal;
        AdjProfitLCY: array [7] of Decimal;
        TotalAdjCostLCY: array [7] of Decimal;
        VATAmount: array [7] of Decimal;
        VATAmountText: array [7] of Text[30];
        ProfitLCY: array [7] of Decimal;
        ProfitPct: array [7] of Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        i: Integer;
        PrevNo: Code[20];
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
        Text006: label 'Placeholder';

    local procedure UpdateHeaderInfo(IndexNo: Integer;var VATAmountLine: Record "VAT Amount Line")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
    begin
        TotalServLine[IndexNo]."Inv. Discount Amount" := VATAmountLine.GetTotalInvDiscAmount;
        TotalAmount1[IndexNo] :=
          TotalServLine[IndexNo]."Line Amount" - TotalServLine[IndexNo]."Inv. Discount Amount";
        VATAmount[IndexNo] := VATAmountLine.GetTotalVATAmount;
        if "Prices Including VAT" then begin
          TotalAmount1[IndexNo] := VATAmountLine.GetTotalAmountInclVAT;
          TotalAmount2[IndexNo] := TotalAmount1[IndexNo] - VATAmount[IndexNo];
          TotalServLine[IndexNo]."Line Amount" :=
            TotalAmount1[IndexNo] + TotalServLine[IndexNo]."Inv. Discount Amount";
        end else
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
          ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.1);

        AdjProfitLCY[IndexNo] := TotalServLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
        if TotalServLineLCY[IndexNo].Amount = 0 then
          AdjProfitPct[IndexNo] := 0
        else
          AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.1);
    end;

    local procedure GetVATSpecification()
    begin
        CurrPage.SubForm.Page.GetTempVATAmountLine(TempVATAmountLine);
        UpdateHeaderInfo(1,TempVATAmountLine);
    end;

    local procedure SetVATSpecification()
    begin
        CurrPage.SubForm.Page.SetServHeader := Rec;
        CurrPage.SubForm.Page.SetTempVATAmountLine(TempVATAmountLine);
        CurrPage.SubForm.Page.InitGlobals(
          "Currency Code",AllowVATDifference,AllowVATDifference,
          "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
    end;

    local procedure UpdateTotalAmount(IndexNo: Integer)
    var
        SaveTotalAmount: Decimal;
    begin
        CheckAllowInvDisc;
        if "Prices Including VAT" then begin
          SaveTotalAmount := TotalAmount1[IndexNo];
          UpdateInvDiscAmount;
          TotalAmount1[IndexNo] := SaveTotalAmount;
        end;

        with TotalServLine[IndexNo] do
          "Inv. Discount Amount" := "Line Amount" - TotalAmount1[IndexNo];
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

        if TotalServLine[1]."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
          Error(
            Text004,
            TotalServLine[1].FieldCaption("Inv. Discount Amount"),
            TempVATAmountLine.FieldCaption("Inv. Disc. Base Amount"));

        TempVATAmountLine.SetInvoiceDiscountAmount(
          TotalServLine[1]."Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
        UpdateHeaderInfo(1,TempVATAmountLine);
        CurrPage.SubForm.Page.SetTempVATAmountLine(TempVATAmountLine);

        "Invoice Discount Calculation" := "invoice discount calculation"::Amount;
        "Invoice Discount Value" := TotalServLine[1]."Inv. Discount Amount";
        Modify;
        UpdateVATOnServLines;
    end;

    local procedure GetCaptionClass(FieldCaption: Text[100];ReverseCaption: Boolean): Text[80]
    begin
        if "Prices Including VAT" xor ReverseCaption then
          exit('2,1,' + FieldCaption);
        exit('2,0,' + FieldCaption);
    end;

    local procedure UpdateVATOnServLines()
    var
        ServLine: Record "Service Line";
    begin
        GetVATSpecification;
        if TempVATAmountLine.GetAnyLineModified then begin
          ServLine.UpdateVATOnLines(0,Rec,ServLine,TempVATAmountLine);
          ServLine.UpdateVATOnLines(1,Rec,ServLine,TempVATAmountLine);
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

