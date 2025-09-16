#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5808 "Item Age Composition - Value"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Age Composition - Value.rdlc';
    Caption = 'Item Age Composition - Value';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.") where(Type=const(Inventory));
            RequestFilterFields = "No.","Inventory Posting Group","Statistics Group","Location Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ItemTableCaptItemFilter;TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(PeriodStartDate21;Format(PeriodStartDate[2] + 1))
            {
            }
            column(PeriodStartDate3;Format(PeriodStartDate[3]))
            {
            }
            column(PeriodStartDate31;Format(PeriodStartDate[3] + 1))
            {
            }
            column(PeriodStartDate4;Format(PeriodStartDate[4]))
            {
            }
            column(PeriodStartDate41;Format(PeriodStartDate[4] + 1))
            {
            }
            column(PeriodStartDate5;Format(PeriodStartDate[5]))
            {
            }
            column(PrintLine;PrintLine)
            {
            }
            column(InvtValueRTC1;InvtValueRTC[1])
            {
            }
            column(InvtValueRTC2;InvtValueRTC[2])
            {
            }
            column(InvtValueRTC5;InvtValueRTC[5])
            {
            }
            column(InvtValueRTC4;InvtValueRTC[4])
            {
            }
            column(InvtValueRTC3;InvtValueRTC[3])
            {
            }
            column(TotalInvtValueRTC;TotalInvtValueRTC)
            {
            }
            column(InvtValue1_Item;InvtValue[1])
            {
                AutoFormatType = 1;
            }
            column(InvtValue2_Item;InvtValue[2])
            {
                AutoFormatType = 1;
            }
            column(InvtValue3_Item;InvtValue[3])
            {
                AutoFormatType = 1;
            }
            column(InvtValue4_Item;InvtValue[4])
            {
                AutoFormatType = 1;
            }
            column(InvtValue5_Item;InvtValue[5])
            {
                AutoFormatType = 1;
            }
            column(TotalInvtValue_Item;TotalInvtValue_Item)
            {
                AutoFormatType = 1;
            }
            column(ItemAgeCompositionValueCaption;ItemAgeCompositionValueCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(AfterCaption;AfterCaptionLbl)
            {
            }
            column(BeforeCaption;BeforeCaptionLbl)
            {
            }
            column(InventoryValueCaption;InventoryValueCaptionLbl)
            {
            }
            column(ItemDescriptionCaption;ItemDescriptionCaptionLbl)
            {
            }
            column(ItemNoCaption;ItemNoCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Item Ledger Entry";"Item Ledger Entry")
            {
                DataItemLink = "Item No."=field("No."),"Location Code"=field("Location Filter"),"Variant Code"=field("Variant Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Item No.",Open) where(Open=const(true));
                column(ReportForNavId_7209; 7209)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Remaining Quantity" = 0 then
                      CurrReport.Skip;
                    PrintLine := true;
                    CalcRemainingQty;

                    if Item."Costing Method" = Item."costing method"::Average then begin
                      TotalInvtValue_Item += AverageCost * TotalInvtQty;
                      InvtValue[i] += AverageCost * InvtQty[i];

                      TotalInvtValueRTC += AverageCost * TotalInvtQty;
                      InvtValueRTC[i] += AverageCost * InvtQty[i];
                    end else begin
                      CalcUnitCost;
                      TotalInvtValue_Item += UnitCost * Abs(TotalInvtQty);
                      InvtValue[i] += UnitCost * Abs(InvtQty[i]);

                      TotalInvtValueRTC += UnitCost * Abs(TotalInvtQty);
                      InvtValueRTC[i] += UnitCost * Abs(InvtQty[i]);
                    end
                end;

                trigger OnPreDataItem()
                begin
                    TotalInvtValue_Item := 0;
                    for i := 1 to 5 do
                      InvtValue[i] := 0;
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(TotalInvtValue_ItemLedgEntry;TotalInvtValue_Item)
                {
                    AutoFormatType = 1;
                }
                column(InvtValue5_ItemLedgEntry;InvtValue[5])
                {
                    AutoFormatType = 1;
                }
                column(InvtValue4_ItemLedgEntry;InvtValue[4])
                {
                    AutoFormatType = 1;
                }
                column(InvtValue3_ItemLedgEntry;InvtValue[3])
                {
                    AutoFormatType = 1;
                }
                column(InvtValue2_ItemLedgEntry;InvtValue[2])
                {
                    AutoFormatType = 1;
                }
                column(InvtValue1_ItemLedgEntry;InvtValue[1])
                {
                    AutoFormatType = 1;
                }
                column(Description_Item;Item.Description)
                {
                }
                column(No_Item;Item."No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Costing Method" = "costing method"::Average then
                  ItemCostMgt.CalculateAverageCost(Item,AverageCost,AverageCostACY);

                PrintLine := false;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(InvtValue,TotalInvtValue_Item);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(EndingDate;PeriodStartDate[5])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';

                        trigger OnValidate()
                        begin
                            if PeriodStartDate[5] = 0D then
                              Error(Text002);
                        end;
                    }
                    field(PeriodLength;PeriodLength)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Length';

                        trigger OnValidate()
                        begin
                            if Format(PeriodLength) = '' then
                              Evaluate(PeriodLength,'<0D>');
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodStartDate[5] = 0D then
              PeriodStartDate[5] := CalcDate('<CM>',WorkDate);
            if Format(PeriodLength) = '' then
              Evaluate(PeriodLength,'<1M>');
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        NegPeriodLength: DateFormula;
    begin
        ItemFilter := Item.GetFilters;

        PeriodStartDate[6] := Dmy2date(31,12,9999);
        Evaluate(NegPeriodLength,StrSubstNo('-%1',Format(PeriodLength)));
        for i := 1 to 3 do
          PeriodStartDate[5 - i] := CalcDate(NegPeriodLength,PeriodStartDate[6 - i]);
    end;

    var
        Text002: label 'Enter the ending date';
        ItemCostMgt: Codeunit ItemCostManagement;
        ItemFilter: Text;
        InvtValue: array [6] of Decimal;
        InvtValueRTC: array [6] of Decimal;
        InvtQty: array [6] of Decimal;
        UnitCost: Decimal;
        PeriodStartDate: array [6] of Date;
        PeriodLength: DateFormula;
        i: Integer;
        TotalInvtValue_Item: Decimal;
        TotalInvtValueRTC: Decimal;
        TotalInvtQty: Decimal;
        PrintLine: Boolean;
        AverageCost: Decimal;
        AverageCostACY: Decimal;
        ItemAgeCompositionValueCaptionLbl: label 'Item Age Composition - Value';
        CurrReportPageNoCaptionLbl: label 'Page';
        AfterCaptionLbl: label 'After...';
        BeforeCaptionLbl: label '...Before';
        InventoryValueCaptionLbl: label 'Inventory Value';
        ItemDescriptionCaptionLbl: label 'Description';
        ItemNoCaptionLbl: label 'Item No.';
        TotalCaptionLbl: label 'Total';

    local procedure CalcRemainingQty()
    begin
        with "Item Ledger Entry" do begin
          for i := 1 to 5 do
            InvtQty[i] := 0;

          TotalInvtQty := "Remaining Quantity";
          for i := 1 to 5 do
            if ("Posting Date" > PeriodStartDate[i]) and
               ("Posting Date" <= PeriodStartDate[i + 1])
            then
              if "Remaining Quantity" <> 0 then begin
                InvtQty[i] := "Remaining Quantity";
                exit;
              end;
        end;
    end;

    local procedure CalcUnitCost()
    var
        ValueEntry: Record "Value Entry";
    begin
        with ValueEntry do begin
          SetRange("Item Ledger Entry No.","Item Ledger Entry"."Entry No.");
          UnitCost := 0;

          if Find('-') then
            repeat
              if "Partial Revaluation" then
                SumUnitCost(UnitCost,"Cost Amount (Actual)" + "Cost Amount (Expected)","Valued Quantity")
              else
                SumUnitCost(UnitCost,"Cost Amount (Actual)" + "Cost Amount (Expected)","Item Ledger Entry".Quantity);
            until Next = 0;
        end;
    end;

    local procedure SumUnitCost(var UnitCost: Decimal;CostAmount: Decimal;Quantity: Decimal)
    begin
        UnitCost := UnitCost + CostAmount / Abs(Quantity);
    end;


    procedure InitializeRequest(NewEndingDate: Date;NewPeriodLength: DateFormula)
    begin
        PeriodStartDate[5] := NewEndingDate;
        PeriodLength := NewPeriodLength;
    end;
}

