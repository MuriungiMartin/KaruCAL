#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7130 "Item Budget"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Budget.rdlc';
    Caption = 'Item Budget';

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Global Dimension 1 Filter","Global Dimension 2 Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ItemBudgetFilter;ItemBudgetFilter)
            {
            }
            column(ValueType;ValueType)
            {
                OptionCaption = 'Sales Amount,Cost Amount,Quantity';
                OptionMembers = "Sales Amount","Cost Amount",Quantity;
            }
            column(AnalysisAreaSelection;AnalysisAreaSelection)
            {
                OptionCaption = 'Sales,Purchase';
                OptionMembers = Sales,Purchase;
            }
            column(InThousands;InThousands)
            {
            }
            column(ItemCaptionItemFilter;TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(PeriodStartDate1;Format(PeriodStartDate[1]))
            {
            }
            column(PeriodStartDate2;Format(PeriodStartDate[2]))
            {
            }
            column(PeriodStartDate3;Format(PeriodStartDate[3]))
            {
            }
            column(PeriodStartDate4;Format(PeriodStartDate[4]))
            {
            }
            column(PeriodStartDate5;Format(PeriodStartDate[5]))
            {
            }
            column(PeriodStartDate6;Format(PeriodStartDate[6]))
            {
            }
            column(PeriodStartDate21;Format(PeriodStartDate[2] - 1))
            {
            }
            column(PeriodStartDate31;Format(PeriodStartDate[3] - 1))
            {
            }
            column(PeriodStartDate41;Format(PeriodStartDate[4] - 1))
            {
            }
            column(PeriodStartDate51;Format(PeriodStartDate[5] - 1))
            {
            }
            column(PeriodStartDate61;Format(PeriodStartDate[6] - 1))
            {
            }
            column(PeriodStartDate71;Format(PeriodStartDate[7] - 1))
            {
            }
            column(ItemBudgetCaption;ItemBudgetCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemBudgetFilterCaption;ItemBudgetFilterCaptionLbl)
            {
            }
            column(ValueTypeCaption;ValueTypeCaptionLbl)
            {
            }
            column(AnalysisAreaSelectionCptn;AnalysisAreaSelectionCptnLbl)
            {
            }
            column(AmountsareinThousandsCptn;AmountsareinThousandsCptnLbl)
            {
            }
            column(ItemDescriptionCaption;ItemDescriptionCaptionLbl)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(No_Item;Item."No.")
                {
                    IncludeCaption = true;
                }
                column(Description_Item;Item.Description)
                {
                }
                column(ItemBudgetedAmount1;ItemBudgetedAmount[1])
                {
                    DecimalPlaces = 0:0;
                }
                column(ItemBudgetedAmount2;ItemBudgetedAmount[2])
                {
                    DecimalPlaces = 0:0;
                }
                column(ItemBudgetedAmount3;ItemBudgetedAmount[3])
                {
                    DecimalPlaces = 0:0;
                }
                column(ItemBudgetedAmount4;ItemBudgetedAmount[4])
                {
                    DecimalPlaces = 0:0;
                }
                column(ItemBudgetedAmount5;ItemBudgetedAmount[5])
                {
                    DecimalPlaces = 0:0;
                }
                column(ItemBudgetedAmount6;ItemBudgetedAmount[6])
                {
                    DecimalPlaces = 0:0;
                }
            }

            trigger OnAfterGetRecord()
            begin
                ItemStatBuffer.Reset;
                ItemStatBuffer.SetRange("Analysis Area Filter",AnalysisAreaSelection);
                ItemStatBuffer.SetRange("Item Filter","No.");
                ItemStatBuffer.SetFilter("Budget Filter",'%1',ItemBudgetFilter);
                ItemStatBuffer.SetFilter("Global Dimension 1 Filter",'%1',GetFilter("Global Dimension 1 Filter"));
                ItemStatBuffer.SetFilter("Global Dimension 2 Filter",'%1',GetFilter("Global Dimension 2 Filter"));
                for i := 1 to 6 do begin
                  ItemStatBuffer.SetRange("Date Filter",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                  case ValueType of
                    Valuetype::"Sales Amount":
                      begin
                        ItemStatBuffer.CalcFields("Budgeted Sales Amount");
                        if InThousands then
                          ItemStatBuffer."Budgeted Sales Amount" := ItemStatBuffer."Budgeted Sales Amount" / 1000;
                        ItemBudgetedAmount[i] := ROUND(ItemStatBuffer."Budgeted Sales Amount",1);
                      end;
                    Valuetype::"Cost Amount":
                      begin
                        ItemStatBuffer.CalcFields("Budgeted Cost Amount");
                        if InThousands then
                          ItemStatBuffer."Budgeted Cost Amount" := ItemStatBuffer."Budgeted Cost Amount" / 1000;
                        ItemBudgetedAmount[i] := ROUND(ItemStatBuffer."Budgeted Cost Amount",1);
                      end;
                    Valuetype::Quantity:
                      begin
                        ItemStatBuffer.CalcFields("Budgeted Quantity");
                        if InThousands then
                          ItemStatBuffer."Budgeted Quantity" := ItemStatBuffer."Budgeted Quantity" / 1000;
                        ItemBudgetedAmount[i] := ROUND(ItemStatBuffer."Budgeted Quantity",1);
                      end;
                  end;
                end;
                ItemStatBuffer.SetRange("Date Filter",PeriodStartDate[1],PeriodStartDate[7] - 1);
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
                    field(AnalysisArea;AnalysisAreaSelection)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Analysis Area';
                        OptionCaption = 'Sales,Purchase';
                        ToolTip = 'Specifies the application area of the item budget entry. Sales: The budget was set up in Sales & Receivables. Purchase: The budget was set up in Purchases & Payables.';
                    }
                    field(ItemBudgetFilterCtrl;ItemBudgetFilter)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Item Budget Filter';
                        TableRelation = "Item Budget Name".Name;
                        ToolTip = 'Specifies the item budget(s) for which budget figures are shown.';
                    }
                    field(ShowValueAs;ValueType)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Show Value As';
                        OptionCaption = 'Sales Amount,Cost Amount,Quantity';
                        ToolTip = 'Specifies if you want to view values in the budget by sales amount, cost amount, or quantity.';
                    }
                    field(StartingDate;PeriodStartDate[1])
                    {
                        ApplicationArea = Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(PeriodLength;PeriodLength)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the length of each period, for example, enter "1M" for one month.';
                    }
                    field(AmountsInWhole1000s;InThousands)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Amounts in whole 1000s';
                        ToolTip = 'Specifies if the amounts in the report are shown in whole 1000s.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodStartDate[1] = 0D then
              PeriodStartDate[1] := WorkDate;
            if Format(PeriodLength) = '' then
              Evaluate(PeriodLength,'<1M>');
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ItemFilter := Item.GetFilters;
        for i := 2 to 7 do
          PeriodStartDate[i] := CalcDate(PeriodLength,PeriodStartDate[i - 1]);
    end;

    var
        ItemStatBuffer: Record "Item Statistics Buffer";
        InThousands: Boolean;
        AnalysisAreaSelection: Option Sales,Purchase,Inventory;
        ValueType: Option "Sales Amount","Cost Amount",Quantity;
        ItemFilter: Text;
        ItemBudgetFilter: Text[250];
        PeriodLength: DateFormula;
        ItemBudgetedAmount: array [6] of Decimal;
        PeriodStartDate: array [7] of Date;
        i: Integer;
        ItemBudgetCaptionLbl: label 'Item Budget';
        CurrReportPageNoCaptionLbl: label 'Page';
        ItemBudgetFilterCaptionLbl: label 'Budget Filter';
        ValueTypeCaptionLbl: label 'Show Value As';
        AnalysisAreaSelectionCptnLbl: label 'Analysis Area';
        AmountsareinThousandsCptnLbl: label 'Amounts are in whole 1000s.';
        ItemDescriptionCaptionLbl: label 'Name';
}

