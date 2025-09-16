#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6059 "Contract Statistics"
{
    Caption = 'Contract Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Service Contract Header";

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
                        field("Income[1]";Income[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Amount';
                        }
                        field("TotalDiscount[1]";TotalDiscount[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Discount Amount';
                        }
                        field("TotalCost[1]";TotalCost[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost Amount';
                        }
                        field("ProfitAmount[1]";ProfitAmount[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit Amount';
                        }
                        field("ProfitAmountPercent[1]";ProfitAmountPercent[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field(Text000;Text000)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Prepaid Amount';
                            Visible = false;
                        }
                        field("Total Amount";Text000)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total Amount';
                            Visible = false;
                        }
                        field("Profit Amount";Text000)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit Amount';
                            Visible = false;
                        }
                        field("Profit %";Text000)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Profit %';
                            Visible = false;
                        }
                    }
                    group(Items)
                    {
                        Caption = 'Items';
                        field("Income[2]";Income[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Amount';
                        }
                        field("TotalDiscount[2]";TotalDiscount[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Discount Amount';
                        }
                        field("TotalCost[2]";TotalCost[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost Amount';
                        }
                        field("ProfitAmount[2]";ProfitAmount[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit Amount';
                        }
                        field("ProfitAmountPercent[2]";ProfitAmountPercent[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field(Control28;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control45;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control49;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control53;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                    }
                    group("Costs && G/L Accounts")
                    {
                        Caption = 'Costs && G/L Accounts';
                        field("Income[3]";Income[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Amount';
                        }
                        field("TotalDiscount[3]";TotalDiscount[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Discount Amount';
                        }
                        field("TotalCost[3]";TotalCost[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost Amount';
                        }
                        field("ProfitAmount[3]";ProfitAmount[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit Amount';
                        }
                        field("ProfitAmountPercent[3]";ProfitAmountPercent[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field(Control42;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control46;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control50;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control54;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                    }
                    group("Service Contracts")
                    {
                        Caption = 'Service Contracts';
                        field("Income[4]";Income[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Amount';
                        }
                        field("TotalDiscount[4]";TotalDiscount[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Discount Amount';
                        }
                        field("TotalCost[4]";TotalCost[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost Amount';
                        }
                        field("ProfitAmount[4]";ProfitAmount[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit Amount';
                        }
                        field("ProfitAmountPercent[4]";ProfitAmountPercent[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field(PrepaidIncome;PrepaidIncome)
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Prepaid Amount';
                        }
                        field(Control47;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control51;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control55;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                    }
                    group(Total)
                    {
                        Caption = 'Total';
                        field("Income[5]";Income[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Invoiced Amount';
                        }
                        field("TotalDiscount[5]";TotalDiscount[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Discount Amount';
                        }
                        field("TotalCost[5]";TotalCost[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Cost Amount';
                        }
                        field("ProfitAmount[5]";ProfitAmount[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Profit Amount';
                        }
                        field("ProfitAmountPercent[5]";ProfitAmountPercent[5])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit %';
                            DecimalPlaces = 1:1;
                        }
                        field(PrepaidIncome2;PrepaidIncome)
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Prepaid Amount';
                        }
                        field(TotalIncome;TotalIncome)
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Amount';
                        }
                        field(TotalProfit;TotalProfit)
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Profit Amount';
                        }
                        field(TotalProfitPct;TotalProfitPct)
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
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
    var
        ServLedgerEntry: Record "Service Ledger Entry";
    begin
        ClearAll;
        ServLedgerEntry.Reset;
        ServLedgerEntry.SetRange("Service Contract No.","Contract No.");
        ServLedgerEntry.SetRange("Entry Type",ServLedgerEntry."entry type"::Sale);
        SetRange("Type Filter","type filter"::"Service Contract");
        CalcFields(
          "Contract Invoice Amount","Contract Prepaid Amount","Contract Cost Amount",
          "Contract Discount Amount");

        Income[4] := "Contract Invoice Amount";
        TotalDiscount[4] := "Contract Discount Amount";
        TotalCost[4] := "Contract Cost Amount";
        ProfitAmount[4] := Income[4] - TotalCost[4];
        ProfitAmountPercent[4] := CalcPercentage(ProfitAmount[4],Income[4]);

        Income[5] := Income[5] + Income[4];
        PrepaidIncome := "Contract Prepaid Amount";

        TotalCost[5] := TotalCost[5] + TotalCost[4];
        TotalDiscount[5] := TotalDiscount[5] + TotalDiscount[4];
        for i := 1 to 3 do begin
          if i = 3 then
            SetFilter("Type Filter",'%1|%2',"type filter"::"Service Cost","type filter"::"G/L Account")
          else
            SetRange("Type Filter",i);
          ServLedgerEntry.SetRange(Type,i);
          if ServLedgerEntry.FindSet then
            repeat
              TotalDiscount[i] := TotalDiscount[i] - ServLedgerEntry."Discount Amount";
            until ServLedgerEntry.Next = 0;
          CalcFields("Contract Invoice Amount","Contract Discount Amount","Contract Cost Amount");

          Income[i] := "Contract Invoice Amount";
          Income[5] := Income[5] + "Contract Invoice Amount";

          TotalCost[i] := "Contract Cost Amount";
          TotalCost[5] := TotalCost[5] + TotalCost[i];

          TotalDiscount[5] := TotalDiscount[5] + TotalDiscount[i];
          ProfitAmount[i] := Income[i] - TotalCost[i];
          ProfitAmount[i] := MakeNegativeZero(ProfitAmount[i]);

          ProfitAmountPercent[i] := CalcPercentage(ProfitAmount[i],Income[i]);
        end;

        TotalIncome := Income[5] + PrepaidIncome;

        ProfitAmount[5] := Income[5] - TotalCost[5];
        ProfitAmountPercent[5] := CalcPercentage(ProfitAmount[5],Income[5]);
        ProfitAmountPercent[5] := MakeNegativeZero(ProfitAmountPercent[5]);
        ProfitAmount[5] := MakeNegativeZero(ProfitAmount[5]);

        TotalProfit := TotalIncome - TotalCost[5];
        TotalProfit := MakeNegativeZero(TotalProfit);

        TotalProfitPct := CalcPercentage(TotalProfit,TotalIncome);

        SetRange("Type Filter");
    end;

    var
        i: Integer;
        PrepaidIncome: Decimal;
        TotalIncome: Decimal;
        Income: array [5] of Decimal;
        TotalCost: array [5] of Decimal;
        TotalDiscount: array [5] of Decimal;
        ProfitAmount: array [5] of Decimal;
        ProfitAmountPercent: array [5] of Decimal;
        TotalProfit: Decimal;
        TotalProfitPct: Decimal;
        Text000: label 'Placeholder';

    local procedure CalcPercentage(PartAmount: Decimal;Base: Decimal): Decimal
    begin
        if Base <> 0 then
          exit(100 * PartAmount / Base);

        exit(0);
    end;

    local procedure MakeNegativeZero(Amount: Decimal): Decimal
    begin
        if Amount < 0 then
          exit(0);
        exit(Amount);
    end;
}

