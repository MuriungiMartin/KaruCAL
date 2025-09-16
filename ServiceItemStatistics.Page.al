#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5982 "Service Item Statistics"
{
    Caption = 'Service Item Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Service Item";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                fixed(Control1903895201)
                {
                    group(Resources)
                    {
                        Caption = 'Resources';
                        field("OrderInvTotalPrice[1]";OrderInvTotalPrice[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Amount';
                        }
                        field("OrderUsageTotalPrice[1]";OrderUsageTotalPrice[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Usage (Amount)';
                        }
                        field("OrderUsageTotalCost[1]";OrderUsageTotalCost[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost Amount';
                        }
                        field("OrderUsageTotalQty[1]";OrderUsageTotalQty[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalInvQty[1]";OrderUsageTotalInvQty[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity Invoiced';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalConsQty[1]";OrderUsageTotalConsQty[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity Consumed';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderInvProfit[1]";OrderInvProfit[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit Amount';
                        }
                        field("OrderInvProfitPct[1]";OrderInvProfitPct[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                    }
                    group(Items)
                    {
                        Caption = 'Items';
                        field("OrderInvTotalPrice[2]";OrderInvTotalPrice[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Price';
                        }
                        field("OrderUsageTotalPrice[2]";OrderUsageTotalPrice[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                        }
                        field("OrderUsageTotalCost[2]";OrderUsageTotalCost[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Cost';
                        }
                        field("OrderUsageTotalQty[2]";OrderUsageTotalQty[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalInvQty[2]";OrderUsageTotalInvQty[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalConsQty[2]";OrderUsageTotalConsQty[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderInvProfit[2]";OrderInvProfit[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit';
                        }
                        field("OrderInvProfitPct[2]";OrderInvProfitPct[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                    }
                    group("Costs && G/L Accounts")
                    {
                        Caption = 'Costs && G/L Accounts';
                        field("OrderInvTotalPrice[3]";OrderInvTotalPrice[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Price';
                        }
                        field("OrderUsageTotalPrice[3]";OrderUsageTotalPrice[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                        }
                        field("OrderUsageTotalCost[3]";OrderUsageTotalCost[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Cost';
                        }
                        field("OrderUsageTotalQty[3]";OrderUsageTotalQty[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalInvQty[3]";OrderUsageTotalInvQty[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalConsQty[3]";OrderUsageTotalConsQty[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderInvProfit[3]";OrderInvProfit[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit';
                        }
                        field("OrderInvProfitPct[3]";OrderInvProfitPct[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                    }
                    group("Service Contracts")
                    {
                        Caption = 'Service Contracts';
                        field("OrderInvTotalPrice[4]";OrderInvTotalPrice[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Price';
                        }
                        field("OrderUsageTotalPrice[4]";OrderUsageTotalPrice[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                        }
                        field("OrderUsageTotalCost[4]";OrderUsageTotalCost[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Cost';
                        }
                        field("OrderUsageTotalQty[4]";OrderUsageTotalQty[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalInvQty[4]";OrderUsageTotalInvQty[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalConsQty[4]";OrderUsageTotalConsQty[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderInvProfit[4]";OrderInvProfit[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit';
                        }
                        field("OrderInvProfitPct[4]";OrderInvProfitPct[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                    }
                    group(Total)
                    {
                        Caption = 'Total';
                        field("OrderInvTotalPrice[5]";OrderInvTotalPrice[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Price';
                        }
                        field("OrderUsageTotalPrice[5]";OrderUsageTotalPrice[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                        }
                        field("OrderUsageTotalCost[5]";OrderUsageTotalCost[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Cost';
                        }
                        field("OrderUsageTotalQty[5]";OrderUsageTotalQty[5])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalInvQty[5]";OrderUsageTotalInvQty[5])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderUsageTotalConsQty[5]";OrderUsageTotalConsQty[5])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field("OrderInvProfit[5]";OrderInvProfit[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit';
                        }
                        field("OrderInvProfitPct[5]";OrderInvProfitPct[5])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ClearAll;

        for i := 1 to 4 do begin
          if i = "type filter"::"Service Cost" then
            SetFilter("Type Filter",'%1|%2',"type filter"::"Service Cost","type filter"::"G/L Account")
          else
            SetRange("Type Filter",i);
          CalcFields("Usage (Cost)","Usage (Amount)","Invoiced Amount","Total Quantity","Total Qty. Invoiced","Total Qty. Consumed");

          if i = 4 then begin
            CalcFields("Contract Cost");
            OrderUsageTotalCost[i] := "Contract Cost";
          end else
            OrderUsageTotalCost[i] := "Usage (Cost)";
          OrderUsageTotalCost[5] := OrderUsageTotalCost[5] + "Usage (Cost)";

          OrderUsageTotalPrice[i] := "Usage (Amount)";
          OrderUsageTotalPrice[5] := OrderUsageTotalPrice[5] + "Usage (Amount)";

          OrderInvTotalPrice[i] := "Invoiced Amount";
          OrderInvTotalPrice[5] := OrderInvTotalPrice[5] + "Invoiced Amount";

          OrderUsageTotalQty[i] := "Total Quantity";
          OrderUsageTotalQty[5] := OrderUsageTotalQty[5] + "Total Quantity";

          OrderUsageTotalInvQty[i] := "Total Qty. Invoiced";
          OrderUsageTotalInvQty[5] := OrderUsageTotalInvQty[5] + "Total Qty. Invoiced";

          OrderUsageTotalConsQty[i] := "Total Qty. Consumed";
          OrderUsageTotalConsQty[5] := OrderUsageTotalConsQty[5] + "Total Qty. Consumed";
        end;

        for i := 1 to 5 do begin
          OrderInvProfit[i] := OrderInvTotalPrice[i] - OrderUsageTotalCost[i];
          if OrderInvTotalPrice[i] <> 0 then
            OrderInvProfitPct[i] := CalcPercentage(OrderInvProfit[i],OrderInvTotalPrice[i])
          else
            OrderInvProfitPct[i] := 0;
        end;

        SetRange("Type Filter");
    end;

    var
        i: Integer;
        OrderUsageTotalCost: array [5] of Decimal;
        OrderUsageTotalPrice: array [5] of Decimal;
        OrderInvTotalPrice: array [5] of Decimal;
        OrderInvProfit: array [5] of Decimal;
        OrderInvProfitPct: array [5] of Decimal;
        OrderUsageTotalQty: array [5] of Decimal;
        OrderUsageTotalInvQty: array [5] of Decimal;
        OrderUsageTotalConsQty: array [5] of Decimal;

    local procedure CalcPercentage(PartAmount: Decimal;Base: Decimal): Decimal
    begin
        if Base <> 0 then
          exit(100 * PartAmount / Base);
        exit(0);
    end;
}

