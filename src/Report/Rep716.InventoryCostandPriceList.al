#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 716 "Inventory Cost and Price List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory Cost and Price List.rdlc';
    Caption = 'Inventory Cost and Price List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            RequestFilterFields = "No.","Location Filter","Variant Filter","Search Description","Assembly BOM","Inventory Posting Group";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ItemFilterCopyCaption;TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(InventPostingGr_Item;"Inventory Posting Group")
            {
            }
            column(No_Item;"No.")
            {
                IncludeCaption = true;
            }
            column(Desc_Item;Description)
            {
                IncludeCaption = true;
            }
            column(AssemblyBOM_Item;Format("Assembly BOM"))
            {
            }
            column(BaseUOM_Item;"Base Unit of Measure")
            {
                IncludeCaption = true;
            }
            column(AverageCost;AverageCost)
            {
                AutoFormatType = 1;
            }
            column(StandardCost_Item;"Standard Cost")
            {
                IncludeCaption = true;
            }
            column(LastDirectCost_Item;"Last Direct Cost")
            {
                IncludeCaption = true;
            }
            column(UnitPrice_Item;"Unit Price")
            {
                IncludeCaption = true;
            }
            column(Profit_Item;"Profit %")
            {
                DecimalPlaces = 1:1;
                IncludeCaption = true;
            }
            column(UnitPriceUnitCost_Item;"Unit Price" - "Unit Cost")
            {
            }
            column(UseStockkeepingUnitBody;UseStockkeepingUnit)
            {
            }
            column(LocationFilter_Item;"Location Filter")
            {
            }
            column(VariantFilter_Item;"Variant Filter")
            {
            }
            column(InvCostAndPriceListCaption;InvCostAndPriceListCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(BOMCaption;BOMCaptionLbl)
            {
            }
            column(AvgCostCaption;AvgCostCaptionLbl)
            {
            }
            column(ProfitCaption;ProfitCaptionLbl)
            {
            }
            column(LastDirCostCaption;LastDirCostCaptionLbl)
            {
            }
            column(LocationCodeCaption;LocationCodeCaptionLbl)
            {
            }
            column(VariantCodeCaption;VariantCodeCaptionLbl)
            {
            }
            dataitem("Stockkeeping Unit";"Stockkeeping Unit")
            {
                DataItemLink = "Item No."=field("No."),"Location Code"=field("Location Filter"),"Variant Code"=field("Variant Filter");
                DataItemTableView = sorting("Item No.","Location Code","Variant Code");
                column(ReportForNavId_5605; 5605)
                {
                }
                column(ItemUnitPriceUnitCostDiff;Item."Unit Price" - Item."Unit Cost")
                {
                }
                column(LastDirCost_StockKeepingUnit;"Last Direct Cost")
                {
                }
                column(StandardCost_StockKeepingUnit;"Standard Cost")
                {
                }
                column(AverageCost_StockKeepingUnit;AverageCost)
                {
                    AutoFormatType = 1;
                }
                column(ItemBaseUOM;Item."Base Unit of Measure")
                {
                }
                column(ItemAssemblyBOM;Format(Item."Assembly BOM"))
                {
                }
                column(LocationCode_StockKeepingUnit;"Location Code")
                {
                }
                column(VariantCode_StockKeepingUnit;"Variant Code")
                {
                }
                column(UseStockkeepingUnit;UseStockkeepingUnit)
                {
                }
                column(SKUPrintLoop;SKUPrintLoop)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Item2: Record Item;
                begin
                    SKUPrintLoop := SKUPrintLoop + 1;
                    if Item2.Get("Item No.") then begin
                      Item2.SetFilter("Location Filter","Location Code");
                      Item2.SetFilter("Variant Filter","Variant Code");
                      ItemCostMgt.CalculateAverageCost(Item2,AverageCost,AverageCostACY);
                      AverageCost := ROUND(AverageCost,GLSetup."Unit-Amount Rounding Precision");
                    end;

                    if PrintToExcel and UseStockkeepingUnit then
                      MakeExcelDataBody;
                end;

                trigger OnPreDataItem()
                begin
                    if not UseStockkeepingUnit then
                      CurrReport.Break;

                    SKUPrintLoop := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ItemCostMgt.CalculateAverageCost(Item,AverageCost,AverageCostACY);
                AverageCost := ROUND(AverageCost,GLSetup."Unit-Amount Rounding Precision");

                if PrintToExcel and not UseStockkeepingUnit then
                  MakeExcelDataBody;
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
                    field(UseStockkeepingUnit;UseStockkeepingUnit)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Use Stockkeeping Unit';
                    }
                    field(PrintToExcel;PrintToExcel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print to Excel';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PrintToExcel := false;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if PrintToExcel then
          CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        ItemFilter := Item.GetFilters;
        GetGLSetup;

        if PrintToExcel then
          MakeExcelInfo;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ExcelBuf: Record "Excel Buffer" temporary;
        ItemCostMgt: Codeunit ItemCostManagement;
        ItemFilter: Text;
        AverageCost: Decimal;
        AverageCostACY: Decimal;
        GLSetupRead: Boolean;
        UseStockkeepingUnit: Boolean;
        SKUPrintLoop: Integer;
        Text000: label 'Data';
        Text001: label 'Inventory Cost and Price List';
        Text002: label 'Company Name';
        Text003: label 'Report No.';
        Text004: label 'Report Name';
        Text005: label 'User ID';
        Text006: label 'Date';
        Text007: label 'Item Filters';
        Text008: label 'Profit';
        PrintToExcel: Boolean;
        Text009: label 'Stockkeeping Unit';
        Text010: label 'Average Cost';
        InvCostAndPriceListCaptionLbl: label 'Inventory Cost and Price List';
        PageNoCaptionLbl: label 'Page';
        BOMCaptionLbl: label 'BOM';
        AvgCostCaptionLbl: label 'Average Cost';
        ProfitCaptionLbl: label 'Profit';
        LastDirCostCaptionLbl: label 'Last Direct Cost';
        LocationCodeCaptionLbl: label 'Location Code';
        VariantCodeCaptionLbl: label 'Variant Code';

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
          GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        //ExcelBuf.AddInfoColumn(FORMAT(Text002),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        /*ExcelBuf.AddInfoColumn(COMPANYNAME,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text003),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text001),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text004),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::Report113,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text005),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text006),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text007),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Item.GETFILTERS,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);*/
        if UseStockkeepingUnit then begin
          ExcelBuf.NewRow;
        /*  ExcelBuf.AddInfoColumn(FORMAT(Text009),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
          ExcelBuf.AddInfoColumn(UseStockkeepingUnit,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);*/
        end;
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;

    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn(Item.FieldCaption("No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Description),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Assembly BOM"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Base Unit of Measure"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        if UseStockkeepingUnit then begin
          ExcelBuf.AddColumn("Stockkeeping Unit".FieldCaption("Location Code"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn("Stockkeeping Unit".FieldCaption("Variant Code"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        end;
        ExcelBuf.AddColumn(Format(Text010),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Standard Cost"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Last Direct Cost"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Unit Price"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Profit %"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text008),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
    end;


    procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Item."No.",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.Description,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item."Assembly BOM",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item."Base Unit of Measure",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        if UseStockkeepingUnit then begin
          ExcelBuf.AddColumn("Stockkeeping Unit"."Location Code",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
          ExcelBuf.AddColumn("Stockkeeping Unit"."Variant Code",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        end;
        ExcelBuf.AddColumn(AverageCost,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        if UseStockkeepingUnit then begin
          ExcelBuf.AddColumn("Stockkeeping Unit"."Standard Cost",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
          ExcelBuf.AddColumn("Stockkeeping Unit"."Last Direct Cost",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        end else begin
          ExcelBuf.AddColumn(Item."Standard Cost",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
          ExcelBuf.AddColumn(Item."Last Direct Cost",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        end;
        ExcelBuf.AddColumn(Item."Unit Price",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Item."Profit %",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Item."Unit Price" - Item."Unit Cost",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
    end;


    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel(Text000,Text001,COMPANYNAME,USERID);
        //ERROR('');
    end;


    procedure InitializeRequest(NewUseStockkeepingUnit: Boolean;NewPrintToExcel: Boolean)
    begin
        UseStockkeepingUnit := NewUseStockkeepingUnit;
        PrintToExcel := NewPrintToExcel;
    end;
}

