#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 915 "Assemble to Order - Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Assemble to Order - Sales.rdlc';
    Caption = 'Assemble to Order - Sales';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            RequestFilterFields = "No.","Inventory Posting Group","Date Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            dataitem("Item Ledger Entry";"Item Ledger Entry")
            {
                DataItemLink = "Item No."=field("No.");
                DataItemTableView = sorting("Item No.","Entry Type") where("Entry Type"=const(Sale));
                column(ReportForNavId_7209; 7209)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TempATOSalesBuffer.UpdateBufferWithItemLedgEntry("Item Ledger Entry",not "Assemble to Order");
                end;

                trigger OnPreDataItem()
                begin
                    ItemFilters.Copyfilter("Date Filter","Posting Date");
                end;
            }

            trigger OnPreDataItem()
            begin
                ItemFilters.Copy(Item);
                Reset;
            end;
        }
        dataitem(ATOConsumptionLoop;"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=filter(1..));
            column(ReportForNavId_8505; 8505)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not FindNextRecord(TempATOSalesBuffer,Number) then
                  CurrReport.Break;

                if TempVisitedAsmHeader.Get(TempVisitedAsmHeader."document type"::Order,TempATOSalesBuffer."Order No.") then
                  CurrReport.Skip;
                TempVisitedAsmHeader."Document Type" := TempVisitedAsmHeader."document type"::Order;
                TempVisitedAsmHeader."No." := TempATOSalesBuffer."Order No.";
                TempVisitedAsmHeader.Insert;

                if TempATOSalesBuffer."Order No." <> '' then begin
                  TempATOSalesBuffer.Delete;
                  FetchAsmComponents(TempCompATOSalesBuffer,TempATOSalesBuffer."Order No.");
                  ConvertAsmComponentsToSale(TempATOSalesBuffer,TempCompATOSalesBuffer,TempATOSalesBuffer."Profit %");
                end;
            end;

            trigger OnPreDataItem()
            begin
                TempATOSalesBuffer.Reset;

                TempATOSalesBuffer.SetRange(Type,TempATOSalesBuffer.Type::Sale);
            end;
        }
        dataitem(Item2;Item)
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_9183; 9183)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(ItemTABLECAPTION_ItemFilter;TableCaption + ': ' + ItemFilters.GetFilters)
            {
            }
            column(Item_No;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(ShowChartAs;ShowChartAs)
            {
            }
            column(ChartTitle;StrSubstNo(Text000,SelectStr(ShowChartAs + 1 ,ShowChartAsTxt)))
            {
            }
            column(ItemHasAsmDetails;ItemHasAsmDetails)
            {
            }
            column(ShowAsmDetails;ShowAsmDetails)
            {
            }
            dataitem(ATOSalesBuffer;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=filter(1..));
                column(ReportForNavId_1801; 1801)
                {
                }
                column(ParentItemNo;TempATOSalesBuffer."Parent Item No.")
                {
                }
                column(Quantity;TempATOSalesBuffer.Quantity)
                {
                }
                column(SalesCost;TempATOSalesBuffer."Sales Cost")
                {
                }
                column(SalesAmt;TempATOSalesBuffer."Sales Amount")
                {
                }
                column(ProfitPct;TempATOSalesBuffer."Profit %")
                {
                }
                column(Type;TempATOSalesBuffer.Type)
                {
                    OptionCaption = ',Sales,Directly,Assembly,In Assembly';
                    OptionMembers = ,Sale,"Total Sale",Assembly,"Total Assembly";
                }

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                begin
                    if not FindNextRecord(TempATOSalesBuffer,Number) then
                      CurrReport.Break;
                    if TempATOSalesBuffer."Parent Item No." <> '' then begin
                      Item.Get(TempATOSalesBuffer."Parent Item No.");
                      TempATOSalesBuffer."Parent Description" := Item.Description;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TempATOSalesBuffer.Reset;
                TempATOSalesBuffer.SetRange("Item No.","No.");
                TempATOSalesBuffer.SetRange(Quantity,0);
                TempATOSalesBuffer.DeleteAll;
                TempATOSalesBuffer.SetRange(Quantity);
                if TempATOSalesBuffer.IsEmpty then
                  CurrReport.Skip;

                TempATOSalesBuffer.SetRange(Type,TempATOSalesBuffer.Type::Assembly);

                ItemHasAsmDetails := not TempATOSalesBuffer.IsEmpty;
                if not ShowAsmDetails then
                  TempATOSalesBuffer.DeleteAll;

                if not (ItemHasAsmDetails or IsInBOMComp("No.")) then
                  CurrReport.Skip;

                TempATOSalesBuffer.SetRange(Type);
            end;

            trigger OnPreDataItem()
            begin
                Copy(ItemFilters);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowAsmDetails;ShowAsmDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Assembly Details';
                    }
                    field(ShowChartAs;ShowChartAs)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Chart as';
                        OptionCaption = 'Quantity,Sales,Profit %';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Report_Caption = 'Assemble to Order - Sales';
        PageNo_Caption = 'Page';
        SoldQuantity_Caption = 'Total Sold';
        CostOfSale_Caption = 'Cost of Sale';
        SalesAmount_Caption = 'Sales Amount';
        ProfitPct_Caption = 'Profit %';
        ParentItemNo_Caption = 'Parent Item No.';
        Quantity_Caption = 'Quantity';
        ItemNo_Caption = 'Item No.';
        Description_Caption = 'Description';
    }

    trigger OnPreReport()
    begin
        TempATOSalesBuffer.Reset;
        TempATOSalesBuffer.DeleteAll;
    end;

    var
        TempATOSalesBuffer: Record "ATO Sales Buffer" temporary;
        TempVisitedAsmHeader: Record "Assembly Header" temporary;
        TempCompATOSalesBuffer: Record "ATO Sales Buffer" temporary;
        ItemFilters: Record Item;
        ShowChartAs: Option Quantity,Sales,"Profit %";
        ShowAsmDetails: Boolean;
        Text000: label 'Show as %1';
        ItemHasAsmDetails: Boolean;
        ShowChartAsTxt: label 'Quantity,Sales,Profit %';


    procedure InitializeRequest(NewShowChartAs: Option;NewShowAsmDetails: Boolean)
    begin
        ShowChartAs := NewShowChartAs;
        ShowAsmDetails := NewShowAsmDetails;
    end;

    local procedure FetchAsmComponents(var TempATOSalesBuffer: Record "ATO Sales Buffer" temporary;AsmOrderNo: Code[20])
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        with ItemLedgEntry do begin
          SetCurrentkey("Order Type","Order No.","Order Line No.");
          SetRange("Order Type","order type"::Assembly);
          SetRange("Order No.",AsmOrderNo);
          if FindSet then
            repeat
              if "Entry Type" = "entry type"::"Assembly Consumption" then
                TempATOSalesBuffer.UpdateBufferWithItemLedgEntry(ItemLedgEntry,false);
            until Next = 0;
        end;
    end;

    local procedure ConvertAsmComponentsToSale(var ToATOSalesBuffer: Record "ATO Sales Buffer";var FromCompATOSalesBuffer: Record "ATO Sales Buffer";ProfitPct: Decimal)
    var
        CopyOfATOSalesBuffer: Record "ATO Sales Buffer";
    begin
        CopyOfATOSalesBuffer.Copy(ToATOSalesBuffer);
        ToATOSalesBuffer.Reset;

        with FromCompATOSalesBuffer do begin
          Reset;
          if Find('-') then
            repeat
              ToATOSalesBuffer.UpdateBufferWithComp(FromCompATOSalesBuffer,ProfitPct,false);
              ToATOSalesBuffer.UpdateBufferWithComp(FromCompATOSalesBuffer,ProfitPct,true);
            until Next = 0;
          DeleteAll;
        end;

        ToATOSalesBuffer.Copy(CopyOfATOSalesBuffer);
    end;

    local procedure IsInBOMComp(ItemNo: Code[20]): Boolean
    var
        BOMComp: Record "BOM Component";
        ParentItem: Record Item;
    begin
        with BOMComp do begin
          SetCurrentkey(Type,"No.");
          SetRange(Type,Type::Item);
          SetRange("No.",ItemNo);
          if FindSet then
            repeat
              ParentItem.Get("Parent Item No.");
              if ParentItem."Assembly Policy" = ParentItem."assembly policy"::"Assemble-to-Order" then
                exit(true);
            until Next = 0;
        end;
    end;

    local procedure FindNextRecord(var ATOSalesBuffer: Record "ATO Sales Buffer";Position: Integer): Boolean
    begin
        if Position = 1 then
          exit(ATOSalesBuffer.FindSet);
        exit(ATOSalesBuffer.Next <> 0);
    end;
}

