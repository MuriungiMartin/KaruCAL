#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5914 "Service Order Statistics"
{
    Caption = 'Service Order Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
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
                        ActiveTab := Activetab::General;
                        UpdateInvDiscAmount(1);
                    end;
                }
                field("TotalAmount1[1]";TotalAmount1[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,false);

                    trigger OnValidate()
                    begin
                        ActiveTab := Activetab::General;
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
                    Editable = false;

                    trigger OnValidate()
                    begin
                        TotalAmount21OnAfterValidate;
                    end;
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
                field(OriginalCostLCY;TotalServLineLCY[1]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Cost ($)';
                    Editable = false;
                }
                field(AdjustedCostLCY;TotalAdjCostLCY[1])
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
                field("No. of VAT Lines_General";TempVATAmountLine1.Count)
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
            group(Details)
            {
                Caption = 'Details';
                fixed(Control1904230801)
                {
                    group(Invoicing)
                    {
                        Caption = 'Invoicing';
                        field("TotalServLine[2].Quantity";TotalServLine[2].Quantity)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field(Amount_Invoicing;TotalServLine[2]."Line Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Amount';
                            Editable = false;
                        }
                        field("Inv. Discount Amount_Invoicing";TotalServLine[2]."Inv. Discount Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Inv. Discount Amount';

                            trigger OnValidate()
                            begin
                                ActiveTab := Activetab::Details;
                                UpdateInvDiscAmount(2);
                            end;
                        }
                        field(Total;TotalAmount1[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Total';

                            trigger OnValidate()
                            begin
                                ActiveTab := Activetab::Details;
                                UpdateTotalAmount(2);
                            end;
                        }
                        field("VAT Amount_Invoicing";VATAmount[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Tax Amount';
                            Editable = false;
                        }
                        field("Total Incl. VAT_Invoicing";TotalAmount2[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Total Amount';
                            Editable = false;
                        }
                        field("Sales (LCY)_Invoicing";TotalServLineLCY[2].Amount)
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Sales ($)';
                            Editable = false;
                        }
                        field("ProfitLCY[2]";ProfitLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Profit ($)';
                            Editable = false;
                        }
                        field("AdjProfitLCY[2]";AdjProfitLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Profit ($)';
                            Editable = false;
                        }
                        field("ProfitPct[2]";ProfitPct[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Original Profit %';
                            DecimalPlaces = 1:1;
                            Editable = false;
                        }
                        field("AdjProfitPct[2]";AdjProfitPct[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjusted Profit %';
                            DecimalPlaces = 1:1;
                            Editable = false;
                        }
                        field("TotalServLineLCY[2].""Unit Cost (LCY)""";TotalServLineLCY[2]."Unit Cost (LCY)")
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Cost ($)';
                            Editable = false;
                        }
                        field("TotalAdjCostLCY[2]";TotalAdjCostLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Cost ($)';
                            Editable = false;
                        }
                        field("TotalAdjCostLCY[2] - TotalServLineLCY[2].""Unit Cost (LCY)""";TotalAdjCostLCY[2] - TotalServLineLCY[2]."Unit Cost (LCY)")
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
                    group(Consuming)
                    {
                        Caption = 'Consuming';
                        field(Quantity_Consuming;TotalServLine[4].Quantity)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field(Text006;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control46;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control47;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control48;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control49;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control50;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field("ProfitLCY[4]";ProfitLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Profit ($)';
                            Editable = false;
                        }
                        field("AdjProfitLCY[4]";AdjProfitLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Profit ($)';
                            Editable = false;
                        }
                        field("ProfitPct[4]";ProfitPct[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Original Profit %';
                            DecimalPlaces = 1:1;
                            Editable = false;
                        }
                        field("AdjProfitPct[4]";AdjProfitPct[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjusted Profit %';
                            DecimalPlaces = 1:1;
                            Editable = false;
                        }
                        field("TotalServLineLCY[4].""Unit Cost (LCY)""";TotalServLineLCY[4]."Unit Cost (LCY)")
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost ($)';
                            Editable = false;
                        }
                        field("TotalAdjCostLCY[4]";TotalAdjCostLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Cost ($)';
                            Editable = false;
                        }
                        field("TotalAdjCostLCY[4] - TotalServLineLCY[4].""Unit Cost (LCY)""";TotalAdjCostLCY[4] - TotalServLineLCY[4]."Unit Cost (LCY)")
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjustment Cost ($)';
                            Editable = false;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupAdjmtValueEntries(1);
                            end;
                        }
                    }
                    group(Control1906106001)
                    {
                        Caption = 'Total';
                        field("TotalServLine[2].Quantity + TotalServLine[4].Quantity";TotalServLine[2].Quantity + TotalServLine[4].Quantity)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field("TotalServLine[2].""Line Amount""";TotalServLine[2]."Line Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            CaptionClass = GetCaptionClass(Text002,false);
                            Editable = false;
                        }
                        field("TotalServLine[2].""Inv. Discount Amount""";TotalServLine[2]."Inv. Discount Amount")
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Inv. Discount Amount';
                            Editable = false;

                            trigger OnValidate()
                            begin
                                ActiveTab := Activetab::Details;
                                UpdateInvDiscAmount(2);
                            end;
                        }
                        field("TotalAmount1[2]";TotalAmount1[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            CaptionClass = GetCaptionClass(Text001,false);
                            Editable = false;

                            trigger OnValidate()
                            begin
                                ActiveTab := Activetab::Details;
                                UpdateTotalAmount(2);
                            end;
                        }
                        field("VATAmount[2]";VATAmount[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("TotalAmount2[2]";TotalAmount2[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            CaptionClass = GetCaptionClass(Text001,true);
                            Editable = false;
                        }
                        field("TotalServLineLCY[2].Amount";TotalServLineLCY[2].Amount)
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Amount ($)';
                            Editable = false;
                        }
                        field("AdjProfitLCY[2] + AdjProfitLCY[4]";AdjProfitLCY[2] + AdjProfitLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit ($)';
                            Editable = false;
                        }
                        field("ProfitLCY[2] + ProfitLCY[4]";ProfitLCY[2] + ProfitLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit ($)';
                            Editable = false;
                        }
                        field(GetDetailsTotal;GetDetailsTotal)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                            Editable = false;
                        }
                        field(GetAdjDetailsTotal;GetAdjDetailsTotal)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                            Editable = false;
                        }
                        field("TotalServLineLCY[2].""Unit Cost (LCY)"" + TotalServLineLCY[4].""Unit Cost (LCY)""";TotalServLineLCY[2]."Unit Cost (LCY)" + TotalServLineLCY[4]."Unit Cost (LCY)")
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost ($)';
                            Editable = false;
                        }
                        field("TotalAdjCostLCY[2] + TotalAdjCostLCY[4]";TotalAdjCostLCY[2] + TotalAdjCostLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost ($)';
                            Editable = false;
                        }
                        field("(TotalAdjCostLCY[2] - TotalServLineLCY[2].""Unit Cost (LCY)"") + (TotalAdjCostLCY[4] - TotalServLineLCY[4].""Unit Cost (LCY)"")";(TotalAdjCostLCY[2] - TotalServLineLCY[2]."Unit Cost (LCY)") + (TotalAdjCostLCY[4] - TotalServLineLCY[4]."Unit Cost (LCY)"))
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost ($)';
                            Editable = false;
                        }
                    }
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field(Amount_Shipping;TotalServLine[3]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002,false);
                    Editable = false;
                }
                field("Inv. Discount Amount_Shipping";TotalServLine[3]."Inv. Discount Amount")
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
                    Editable = false;
                }
                field("VAT Amount_Shipping";VATAmount[3])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText[3]);
                    Editable = false;
                }
                field("Total Incl. VAT_Shipping";TotalAmount2[3])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,true);
                    Editable = false;
                }
                field("Sales (LCY)_Shipping";TotalServLineLCY[3].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    Editable = false;
                }
                field("TotalServLineLCY[3].""Unit Cost (LCY)""";TotalServLineLCY[3]."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost ($)';
                    Editable = false;
                }
                field("ProfitLCY[3]";ProfitLCY[3])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    Editable = false;
                }
                field("ProfitPct[3]";ProfitPct[3])
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field("TotalServLine[3].Quantity";TotalServLine[3].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[3].""Units per Parcel""";TotalServLine[3]."Units per Parcel")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parcels';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[3].""Net Weight""";TotalServLine[3]."Net Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[3].""Gross Weight""";TotalServLine[3]."Gross Weight")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("TotalServLine[3].""Unit Volume""";TotalServLine[3]."Unit Volume")
                {
                    ApplicationArea = Basic;
                    Caption = 'Volume';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field("No. of VAT Lines_Shipping";TempVATAmountLine3.Count)
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
            group("Service Line")
            {
                Caption = 'Service Line';
                fixed(Control1903442601)
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
                        field(Total2;TotalAmount1[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Total';
                            Editable = false;
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
                        field(Control51;Text006)
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
                        field(Control53;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control55;Text006)
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
                        field(Control52;Text006)
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
                        field(Control54;Text006)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control56;Text006)
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
                field("Credit Limit (LCY)_Customer";Cust."Credit Limit (LCY)")
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

        for i := 1 to 7 do begin
          TempServLine.DeleteAll;
          Clear(TempServLine);
          ServAmtsMgt.GetServiceLines(Rec,TempServLine,i - 1);

          case i of
            1:
              ServLine.CalcVATAmountLines(0,Rec,TempServLine,TempVATAmountLine1,false);
            2:
              ServLine.CalcVATAmountLines(0,Rec,TempServLine,TempVATAmountLine2,false);
            3:
              ServLine.CalcVATAmountLines(0,Rec,TempServLine,TempVATAmountLine3,false);
          end;

          ServAmtsMgt.SumServiceLinesTemp(
            Rec,TempServLine,i - 1,TotalServLine[i],TotalServLineLCY[i],
            VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);
          ProfitLCY[i] := MakeNegativeZero(ProfitLCY[i]);

          if i = 3 then
            TotalAdjCostLCY[i] := TotalServLineLCY[i]."Unit Cost (LCY)";

          if TotalServLineLCY[i].Amount = 0 then
            ProfitPct[i] := 0
          else
            ProfitPct[i] := ROUND(100 * ProfitLCY[i] / TotalServLineLCY[i].Amount,0.1);

          AdjProfitLCY[i] := TotalServLineLCY[i].Amount - TotalAdjCostLCY[i];
          AdjProfitLCY[i] := MakeNegativeZero(AdjProfitLCY[i]);
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

        TempVATAmountLine1.ModifyAll(Modified,false);
        TempVATAmountLine2.ModifyAll(Modified,false);
        TempVATAmountLine3.ModifyAll(Modified,false);

        PrevTab := -1;
    end;

    trigger OnOpenPage()
    begin
        SalesSetup.Get;
        AllowInvDisc := not (SalesSetup."Calc. Inv. Discount" and CustInvDiscRecExists("Invoice Disc. Code"));
        AllowVATDifference :=
          SalesSetup."Allow VAT Difference" and
          ("Document Type" <> "document type"::Quote);
        VATLinesFormIsEditable := AllowVATDifference or AllowInvDisc;
        CurrPage.Editable := VATLinesFormIsEditable;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification(PrevTab);
        if TempVATAmountLine1.GetAnyLineModified or TempVATAmountLine2.GetAnyLineModified then
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
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        TempVATAmountLine2: Record "VAT Amount Line" temporary;
        TempVATAmountLine3: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        ServAmtsMgt: Codeunit "Serv-Amounts Mgt.";
        VATLinesForm: Page "VAT Amount Lines";
        TotalAmount1: array [7] of Decimal;
        TotalAmount2: array [7] of Decimal;
        AdjProfitLCY: array [7] of Decimal;
        AdjProfitPct: array [7] of Decimal;
        TotalAdjCostLCY: array [7] of Decimal;
        VATAmount: array [7] of Decimal;
        VATAmountText: array [7] of Text[30];
        ProfitLCY: array [7] of Decimal;
        ProfitPct: array [7] of Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        i: Integer;
        PrevNo: Code[20];
        ActiveTab: Option General,Details,Shipping;
        PrevTab: Option General,Details,Shipping;
        VATLinesFormIsEditable: Boolean;
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
        ProfitLCY[IndexNo] := MakeNegativeZero(ProfitLCY[IndexNo]);
        if TotalServLineLCY[IndexNo].Amount = 0 then
          ProfitPct[IndexNo] := 0
        else
          ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.1);

        AdjProfitLCY[IndexNo] := TotalServLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
        AdjProfitLCY[IndexNo] := MakeNegativeZero(AdjProfitLCY[IndexNo]);
        if TotalServLineLCY[IndexNo].Amount = 0 then
          AdjProfitPct[IndexNo] := 0
        else
          AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.1);
    end;

    local procedure GetVATSpecification(QtyType: Option General,Details,Shipping)
    begin
        case QtyType of
          Qtytype::General:
            begin
              VATLinesForm.GetTempVATAmountLine(TempVATAmountLine1);
              UpdateHeaderInfo(1,TempVATAmountLine1);
            end;
          Qtytype::Details:
            begin
              VATLinesForm.GetTempVATAmountLine(TempVATAmountLine2);
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
          InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(false,"Currency Code")
        else
          InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(false,"Currency Code");

        if InvDiscBaseAmount = 0 then
          Error(Text003,TempVATAmountLine2.FieldCaption("Inv. Disc. Base Amount"));

        if TotalServLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
          Error(
            Text004,
            TotalServLine[ModifiedIndexNo].FieldCaption("Inv. Discount Amount"),
            TempVATAmountLine2.FieldCaption("Inv. Disc. Base Amount"));

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
        GetVATSpecification(ActiveTab);
        if TempVATAmountLine1.GetAnyLineModified then
          ServLine.UpdateVATOnLines(0,Rec,ServLine,TempVATAmountLine1);
        if TempVATAmountLine2.GetAnyLineModified then
          ServLine.UpdateVATOnLines(1,Rec,ServLine,TempVATAmountLine2);
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

    local procedure GetDetailsTotal(): Decimal
    begin
        if TotalServLineLCY[2].Amount = 0 then
          exit(0);
        exit(ROUND(100 * (ProfitLCY[2] + ProfitLCY[4]) / TotalServLineLCY[2].Amount,0.01));
    end;

    local procedure GetAdjDetailsTotal(): Decimal
    begin
        if TotalServLineLCY[2].Amount = 0 then
          exit(0);
        exit(ROUND(100 * (AdjProfitLCY[2] + AdjProfitLCY[4]) / TotalServLineLCY[2].Amount,0.01));
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

    local procedure TotalAmount21OnAfterValidate()
    begin
        with TotalServLine[1] do begin
          if "Prices Including VAT" then
            "Inv. Discount Amount" := "Line Amount" - "Amount Including VAT"
          else
            "Inv. Discount Amount" := "Line Amount" - Amount;
        end;
        ActiveTab := Activetab::General;
        UpdateInvDiscAmount(1);
    end;

    local procedure MakeNegativeZero(Amount: Decimal): Decimal
    begin
        if Amount < 0 then
          exit(0);
        exit(Amount);
    end;
}

