#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10038 "Sales Order Stats."
{
    Caption = 'Sales Order Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("TotalSalesLine[1].""Line Amount""";TotalSalesLine[1]."Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Editable = false;
                }
                field("TotalSalesLine[1].""Inv. Discount Amount""";TotalSalesLine[1]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;
                    ToolTip = 'Specifies the invoice discount amount for the entire document. If the Calc. Inv. Discount field in the Sales & Receivables Setup window is selected, the discount is automatically calculated.';

                    trigger OnValidate()
                    begin
                        UpdateInvDiscAmount(1);
                    end;
                }
                field("TotalAmount1[1]";TotalAmount1[1])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateTotalAmount(1);
                    end;
                }
                field(TaxAmount;VATAmount[1])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                    Editable = false;
                    ToolTip = 'Specifies the tax amount.';
                }
                field("TotalAmount2[1]";TotalAmount2[1])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Editable = false;

                    trigger OnValidate()
                    begin
                        TotalAmount21OnAfterValidate;
                    end;
                }
                field("TotalSalesLineLCY[1].Amount";TotalSalesLineLCY[1].Amount)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                    ToolTip = 'Specifies the sales amount.';
                }
                field("ProfitLCY[1]";ProfitLCY[1])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the profit expressed as an amount.  ';
                }
                field("AdjProfitLCY[1]";AdjProfitLCY[1])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the difference between the amounts in the Amount and Cost fields on the sales order.';
                }
                field("ProfitPct[1]";ProfitPct[1])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the profit, expressed as a percentage, that was associated with the sales order when it was originally posted.';
                }
                field("AdjProfitPct[1]";AdjProfitPct[1])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the adjusted profit of the sales order expressed as a percentage.';
                }
                field("TotalSalesLine[1].Quantity";TotalSalesLine[1].Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the item quantity.';
                }
                field("TotalSalesLine[1].""Units per Parcel""";TotalSalesLine[1]."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                }
                field("TotalSalesLine[1].""Net Weight""";TotalSalesLine[1]."Net Weight")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the net weight of items on the sales order.';
                }
                field("TotalSalesLine[1].""Gross Weight""";TotalSalesLine[1]."Gross Weight")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the gross weight of items on the document.';
                }
                field("TotalSalesLine[1].""Unit Volume""";TotalSalesLine[1]."Unit Volume")
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                }
                field("TotalSalesLineLCY[1].""Unit Cost (LCY)""";TotalSalesLineLCY[1]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the original cost of the items on the sales document.';
                }
                field("TotalAdjCostLCY[1]";TotalAdjCostLCY[1])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the adjusted cost of the items on the sales order.';
                }
                field("TotalAdjCostLCY[1] - TotalSalesLineLCY[1].""Unit Cost (LCY)""";TotalAdjCostLCY[1] - TotalSalesLineLCY[1]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Cost Adjmt. Amount ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the adjusted cost of the sales order based on the total adjusted cost, total sales, and unit cost.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupAdjmtValueEntries(0);
                    end;
                }
                label(BreakdownTitle)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = FORMAT(BreakdownTitle);
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAmt2;BreakdownAmt[1,1])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,1]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAmt3;BreakdownAmt[1,2])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,2]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAm4;BreakdownAmt[1,3])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,3]);
                    Caption = 'BreakdownAm';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAm5;BreakdownAmt[1,4])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[1,4]);
                    Caption = 'BreakdownAm';
                    Editable = false;
                    Importance = Additional;
                }
                field(NoOfVATLines_General;TempSalesTaxLine1.Count)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of sales tax lines on the sales order.';

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
                field("TotalSalesLine[2].""Line Amount""";TotalSalesLine[2]."Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Editable = false;
                }
                field("TotalSalesLine[2].""Inv. Discount Amount""";TotalSalesLine[2]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;
                    ToolTip = 'Specifies the invoice discount amount for the entire sales document. If the Calc. Inv. Discount field in the Sales & Receivables Setup window is selected, the discount is automatically calculated.';

                    trigger OnValidate()
                    begin
                        UpdateInvDiscAmount(2);
                    end;
                }
                field("TotalAmount1[2]";TotalAmount1[2])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateTotalAmount(2);
                    end;
                }
                field("VATAmount[2]";VATAmount[2])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                    Editable = false;
                    ToolTip = 'Specifies the tax amount.';
                }
                field("TotalAmount2[2]";TotalAmount2[2])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Editable = false;
                }
                field("TotalSalesLineLCY[2].Amount";TotalSalesLineLCY[2].Amount)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                    ToolTip = 'Specifies the sales amount.';
                }
                field("ProfitLCY[2]";ProfitLCY[2])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Original Profit ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the profit, expressed as an amount, that was associated with the sales order when it was originally posted.';
                }
                field("AdjProfitLCY[2]";AdjProfitLCY[2])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the difference between the amounts in the Amount and Cost fields on the sales order.';
                }
                field("ProfitPct[2]";ProfitPct[2])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the profit, expressed as a percentage, that was associated with the sales order when it was originally posted.';
                }
                field("AdjProfitPct[2]";AdjProfitPct[2])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the adjusted profit of the sales order expressed as a percentage.';
                }
                field("TotalSalesLine[2].Quantity";TotalSalesLine[2].Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the item quantity.';
                }
                field("TotalSalesLine[2].""Units per Parcel""";TotalSalesLine[2]."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                }
                field("TotalSalesLine[2].""Net Weight""";TotalSalesLine[2]."Net Weight")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the net weight of items on the sales order.';
                }
                field("TotalSalesLine[2].""Gross Weight""";TotalSalesLine[2]."Gross Weight")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the gross weight of items on the document.';
                }
                field("TotalSalesLine[2].""Unit Volume""";TotalSalesLine[2]."Unit Volume")
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                }
                field("TotalSalesLineLCY[2].""Unit Cost (LCY)""";TotalSalesLineLCY[2]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the original cost of the items on the sales document.';
                }
                field("TotalAdjCostLCY[2]";TotalAdjCostLCY[2])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the adjusted cost of the items on the sales order.';
                }
                field("TotalAdjCostLCY[2] - TotalSalesLineLCY[2].""Unit Cost (LCY)""";TotalAdjCostLCY[2] - TotalSalesLineLCY[2]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Cost Adjmt. Amount ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the adjusted cost of the sales order based on the total adjusted cost, total sales, and unit cost.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupAdjmtValueEntries(1);
                    end;
                }
                label(BreakdownTitle2)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = FORMAT(BreakdownTitle);
                    Importance = Additional;
                }
                field(BreakdownAmt6;BreakdownAmt[2,1])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2,1]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAmt7;BreakdownAmt[2,2])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2,2]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAmt8;BreakdownAmt[2,3])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2,3]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAmt9;BreakdownAmt[2,4])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[2,4]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(NoOfVATLines_Invoicing;TempSalesTaxLine2.Count)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of sales tax lines on the sales order.';

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
                field("TotalSalesLine[3].""Line Amount""";TotalSalesLine[3]."Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Editable = false;
                }
                field("TotalSalesLine[3].""Inv. Discount Amount""";TotalSalesLine[3]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                    Editable = false;
                    ToolTip = 'Specifies the invoice discount amount for the entire sales document. If the Calc. Inv. Discount field in the Sales & Receivables Setup window is selected, the discount is automatically calculated.';
                }
                field("TotalAmount1[3]";TotalAmount1[3])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);
                    Editable = false;
                }
                field("VATAmount[3]";VATAmount[3])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Tax Amount';
                    Editable = false;
                    ToolTip = 'Specifies the tax amount.';
                }
                field("TotalAmount2[3]";TotalAmount2[3])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Editable = false;
                }
                field("TotalSalesLineLCY[3].Amount";TotalSalesLineLCY[3].Amount)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                    ToolTip = 'Specifies the sales amount.';
                }
                field("TotalSalesLineLCY[3].""Unit Cost (LCY)""";TotalSalesLineLCY[3]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Cost ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the cost of the sales order, rounded according to the Amount Rounding Precision field in the Currencies window.';
                }
                field("ProfitLCY[3]";ProfitLCY[3])
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the profit expressed as an amount.  ';
                }
                field("ProfitPct[3]";ProfitPct[3])
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the profit expressed as a percentage.  ';
                }
                field("TotalSalesLine[3].Quantity";TotalSalesLine[3].Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the item quantity.';
                }
                field("TotalSalesLine[3].""Units per Parcel""";TotalSalesLine[3]."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                }
                field("TotalSalesLine[3].""Net Weight""";TotalSalesLine[3]."Net Weight")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the net weight of items on the sales order.';
                }
                field("TotalSalesLine[3].""Gross Weight""";TotalSalesLine[3]."Gross Weight")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the gross weight of items on the document.';
                }
                field("TotalSalesLine[3].""Unit Volume""";TotalSalesLine[3]."Unit Volume")
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Importance = Additional;
                }
                label(BreakdownTitle3)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = FORMAT(BreakdownTitle);
                    Importance = Additional;
                }
                field(BreakdownAmt10;BreakdownAmt[3,1])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3,1]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAmt11;BreakdownAmt[3,2])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3,2]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAmt12;BreakdownAmt[3,3])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3,3]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(BreakdownAmt13;BreakdownAmt[3,4])
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    CaptionClass = FORMAT(BreakdownLabel[3,4]);
                    Caption = 'BreakdownAmt';
                    Editable = false;
                    Importance = Additional;
                }
                field(NoOfVATLines_Shipping;TempSalesTaxLine3.Count)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of sales tax lines on the sales order.';

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
                    Editable = false;
                }
                field("TotalSalesLine[1].""Prepmt. Amt. Inv.""";TotalSalesLine[1]."Prepmt. Amt. Inv.")
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
                field("TotalSalesLine[1].""Prepmt Amt Deducted""";TotalSalesLine[1]."Prepmt Amt Deducted")
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
                field("TotalSalesLine[1].""Prepmt Amt to Deduct""";TotalSalesLine[1]."Prepmt Amt to Deduct")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text009,false);
                    Editable = false;
                }
                field(NoOfVATLines_Prepayment;TempSalesTaxLine1.Count)
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
            group(Customer)
            {
                Caption = 'Customer';
                field("Cust.""Balance (LCY)""";Cust."Balance (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                    Editable = false;
                    ToolTip = 'Specifies the customer''s balance. ';
                }
                field("Cust.""Credit Limit (LCY)""";Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit ($)';
                    Editable = false;
                    ToolTip = 'Specifies the customer''s credit limit.';
                }
                field(CreditLimitLCYExpendedPct;CreditLimitLCYExpendedPct)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Expended % of Credit Limit ($)';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Specifies how must of the customer''s credit is used, expressed as a percentage of the credit limit.';
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
        SalesPostPrepmt: Codeunit "Sales-Post Prepayments";
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

        Clear(SalesLine);
        Clear(TotalSalesLine);
        Clear(TotalSalesLineLCY);
        Clear(BreakdownLabel);
        Clear(BreakdownAmt);

        SalesLine.Reset;

        for i := 1 to 3 do begin
          TempSalesLine.DeleteAll;
          Clear(TempSalesLine);
          Clear(SalesPost);
          SalesPost.GetSalesLines(Rec,TempSalesLine,i - 1);
          Clear(SalesPost);
          SalesTaxCalculate.StartSalesTaxCalculation;
          TempSalesLine.SetFilter(Type,'>0');
          TempSalesLine.SetFilter(Quantity,'<>0');
          if TempSalesLine.Find('-') then
            repeat
              SalesTaxCalculate.AddSalesLine(TempSalesLine);
            until TempSalesLine.Next = 0;
          TempSalesLine.Reset;
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
            SalesTaxCalculate.DistTaxOverSalesLines(TempSalesLine);
          SalesPost.SumSalesLinesTemp(
            Rec,TempSalesLine,i - 1,TotalSalesLine[i],TotalSalesLineLCY[i],
            VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);
          if i = 3 then
            TotalAdjCostLCY[i] := TotalSalesLineLCY[i]."Unit Cost (LCY)";

          AdjProfitLCY[i] := TotalSalesLineLCY[i].Amount - TotalAdjCostLCY[i];
          if TotalSalesLineLCY[i].Amount <> 0 then
            AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalSalesLineLCY[i].Amount * 100,0.1);
          TotalAmount1[i] := TotalSalesLine[i].Amount;
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
        TempSalesLine.DeleteAll;
        Clear(TempSalesLine);
        SalesPostPrepmt.GetSalesLines(Rec,0,TempSalesLine);
        SalesPostPrepmt.SumPrepmt(
          Rec,TempSalesLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
        PrepmtInvPct :=
          Pct(TotalSalesLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
        PrepmtDeductedPct :=
          Pct(TotalSalesLine[1]."Prepmt Amt Deducted",TotalSalesLine[1]."Prepmt. Amt. Inv.");
        if "Prices Including VAT" then begin
          PrepmtTotalAmount2 := PrepmtTotalAmount;
          PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
        end else
          PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;

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
        // TempSalesTaxLine4.MODIFYALL(Modified,FALSE);

        PrevTab := -1;
    end;

    trigger OnOpenPage()
    begin
        SalesSetup.Get;
        AllowInvDisc := not (SalesSetup."Calc. Inv. Discount" and CustInvDiscRecExists("Invoice Disc. Code"));
        AllowVATDifference :=
          SalesSetup."Allow VAT Difference" and
          not ("Document Type" in ["document type"::Quote,"document type"::"Blanket Order"]);
        VATLinesFormIsEditable := AllowVATDifference or AllowInvDisc or ("Tax Area Code" <> '');
        CurrPage.Editable := VATLinesFormIsEditable;
        TaxArea.Get("Tax Area Code");
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification(PrevTab);
        if TempSalesTaxLine1.GetAnyLineModified or TempSalesTaxLine2.GetAnyLineModified then
          UpdateTaxOnSalesLines;
        exit(true);
    end;

    var
        Text000: label 'Sales %1 Statistics';
        Text001: label 'Total';
        Text002: label 'Amount';
        Text003: label '%1 must not be 0.';
        Text004: label '%1 must not be greater than %2.';
        Text005: label 'You cannot change the invoice discount because there is a %1 record for %2 %3.';
        TotalSalesLine: array [3] of Record "Sales Line";
        TotalSalesLineLCY: array [3] of Record "Sales Line";
        Cust: Record Customer;
        TempSalesTaxLine1: Record UnknownRecord10011 temporary;
        TempSalesTaxLine2: Record UnknownRecord10011 temporary;
        TempSalesTaxLine3: Record UnknownRecord10011 temporary;
        TempVATAmountLine4: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        SalesTaxDifference: Record UnknownRecord10012;
        TaxArea: Record "Tax Area";
        SalesPost: Codeunit "Sales-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        VATLinesForm: Page "Sales Tax Lines Subform Dyn";
        TotalAmount1: array [3] of Decimal;
        TotalAmount2: array [3] of Decimal;
        VATAmount: array [3] of Decimal;
        PrepmtTotalAmount: Decimal;
        PrepmtVATAmount: Decimal;
        PrepmtTotalAmount2: Decimal;
        VATAmountText: array [3] of Text[30];
        PrepmtVATAmountText: Text[30];
        ProfitLCY: array [3] of Decimal;
        ProfitPct: array [3] of Decimal;
        AdjProfitLCY: array [3] of Decimal;
        AdjProfitPct: array [3] of Decimal;
        TotalAdjCostLCY: array [3] of Decimal;
        CreditLimitLCYExpendedPct: Decimal;
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
        BreakdownTitle: Text[35];
        BreakdownLabel: array [3,4] of Text[30];
        BreakdownAmt: array [3,4] of Decimal;
        BrkIdx: Integer;
        Text1020010: label 'Tax Breakdown:';
        Text1020011: label 'Sales Tax Breakdown:';
        Text1020012: label 'Other Taxes';

    local procedure UpdateHeaderInfo(IndexNo: Integer;var SalesTaxAmountLine: Record UnknownRecord10011 temporary)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
    begin
        TotalSalesLine[IndexNo]."Inv. Discount Amount" := SalesTaxAmountLine.GetTotalInvDiscAmount;
        TotalAmount1[IndexNo] :=
          TotalSalesLine[IndexNo]."Line Amount" - TotalSalesLine[IndexNo]."Inv. Discount Amount";
        VATAmount[IndexNo] := SalesTaxAmountLine.GetTotalTaxAmountFCY;
        if "Prices Including VAT" then
          TotalAmount2[IndexNo] := TotalSalesLine[IndexNo].Amount
        else
          TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];

        if "Prices Including VAT" then
          TotalSalesLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
        else
          TotalSalesLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
        if "Currency Code" <> '' then
          if ("Document Type" in ["document type"::"Blanket Order","document type"::Quote]) and
             ("Posting Date" = 0D)
          then
            UseDate := WorkDate
          else
            UseDate := "Posting Date";

        TotalSalesLineLCY[IndexNo].Amount :=
          CurrExchRate.ExchangeAmtFCYToLCY(
            UseDate,"Currency Code",TotalSalesLineLCY[IndexNo].Amount,"Currency Factor");

        ProfitLCY[IndexNo] := TotalSalesLineLCY[IndexNo].Amount - TotalSalesLineLCY[IndexNo]."Unit Cost (LCY)";
        if TotalSalesLineLCY[IndexNo].Amount = 0 then
          ProfitPct[IndexNo] := 0
        else
          ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalSalesLineLCY[IndexNo].Amount,0.01);

        AdjProfitLCY[IndexNo] := TotalSalesLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
        if TotalSalesLineLCY[IndexNo].Amount = 0 then
          AdjProfitPct[IndexNo] := 0
        else
          AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalSalesLineLCY[IndexNo].Amount,0.01);
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
    var
        SaveTotalAmount: Decimal;
    begin
        CheckAllowInvDisc;
        if "Prices Including VAT" then begin
          SaveTotalAmount := TotalAmount1[IndexNo];
          UpdateInvDiscAmount(IndexNo);
          TotalAmount1[IndexNo] := SaveTotalAmount;
        end;

        with TotalSalesLine[IndexNo] do
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

        if TotalSalesLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
          Error(
            Text004,
            TotalSalesLine[ModifiedIndexNo].FieldCaption("Inv. Discount Amount"),
            TempSalesTaxLine2.FieldCaption("Inv. Disc. Base Amount"));

        PartialInvoicing := (TotalSalesLine[1]."Line Amount" <> TotalSalesLine[2]."Line Amount");

        IndexNo[1] := ModifiedIndexNo;
        IndexNo[2] := 3 - ModifiedIndexNo;
        if (ModifiedIndexNo = 2) and PartialInvoicing then
          MaxIndexNo := 1
        else
          MaxIndexNo := 2;

        if not PartialInvoicing then
          if ModifiedIndexNo = 1 then
            TotalSalesLine[2]."Inv. Discount Amount" := TotalSalesLine[1]."Inv. Discount Amount"
          else
            TotalSalesLine[1]."Inv. Discount Amount" := TotalSalesLine[2]."Inv. Discount Amount";

        for i := 1 to MaxIndexNo do
          with TotalSalesLine[IndexNo[i]] do begin
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
        "Invoice Discount Value" := TotalSalesLine[1]."Inv. Discount Amount";
        Modify;

        UpdateTaxOnSalesLines;
    end;

    local procedure GetCaptionClass(FieldCaption: Text[100];ReverseCaption: Boolean): Text[80]
    begin
        if "Prices Including VAT" xor ReverseCaption then
          exit('2,1,' + FieldCaption);
        exit('2,0,' + FieldCaption);
    end;

    local procedure UpdateTaxOnSalesLines()
    var
        SalesLine: Record "Sales Line";
    begin
        GetVATSpecification(ActiveTab);

        SalesLine.Reset;
        SalesLine.SetRange("Document Type","Document Type");
        SalesLine.SetRange("Document No.","No.");
        SalesLine.FindFirst;

        if TempSalesTaxLine1.GetAnyLineModified then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          SalesTaxCalculate.PutSalesTaxAmountLineTable(
            TempSalesTaxLine1,
            SalesTaxDifference."document product area"::Sales,
            "Document Type","No.");
          SalesTaxCalculate.DistTaxOverSalesLines(SalesLine);
          SalesTaxCalculate.SaveTaxDifferences;
        end;
        if TempSalesTaxLine2.GetAnyLineModified then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          SalesTaxCalculate.PutSalesTaxAmountLineTable(
            TempSalesTaxLine2,
            SalesTaxDifference."document product area"::Sales,
            "Document Type","No.");
          SalesTaxCalculate.DistTaxOverSalesLines(SalesLine);
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

    local procedure TotalAmount21OnAfterValidate()
    begin
        with TotalSalesLine[1] do begin
          if "Prices Including VAT" then
            "Inv. Discount Amount" := "Line Amount" - "Amount Including VAT"
          else
            "Inv. Discount Amount" := "Line Amount" - Amount;
        end;
        UpdateInvDiscAmount(1);
    end;
}

