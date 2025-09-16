#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10135 "Item Sales Statistics"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Sales Statistics.rdlc';
    Caption = 'Item Sales Statistics';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            RequestFilterFields = "No.","Search Description","Inventory Posting Group","Statistics Group","Base Unit of Measure","Date Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(Title;Title)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(BreakdownByVariant;BreakdownByVariant)
            {
            }
            column(IncludeItemDescriptions;IncludeItemDescriptions)
            {
            }
            column(PrintOnlyIfSales;PrintOnlyIfSales)
            {
            }
            column(TLGroup;TLGroup)
            {
            }
            column(GroupField;GroupField)
            {
            }
            column(NoShow;NoShow)
            {
            }
            column(ItemDateFilterExsit;ItemDateFilterExsit)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(GroupName_________GroupNo;GroupName + ' ' + GroupNo)
            {
            }
            column(GroupDesc;GroupDesc)
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item__Base_Unit_of_Measure_;"Base Unit of Measure")
            {
            }
            column(Item__COGS__LCY__;"COGS (LCY)")
            {
            }
            column(Item__Unit_Price_;"Unit Price")
            {
            }
            column(Item__Sales__Qty___;"Sales (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Item__Sales__LCY__;"Sales (LCY)")
            {
            }
            column(Profit;Profit)
            {
            }
            column(ItemProfitPct;ItemProfitPct)
            {
                DecimalPlaces = 1:1;
            }
            column(QuantityReturned;QuantityReturned)
            {
                DecimalPlaces = 2:5;
            }
            column(NoVariant;NoVariant)
            {
            }
            column(Item_Description;Description)
            {
            }
            column(Text003_________GroupName_________GroupNo;Text003 + ' ' + GroupName + ' ' + GroupNo)
            {
            }
            column(Item__Sales__Qty____Control32;"Sales (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Item__Sales__LCY___Control33;"Sales (LCY)")
            {
            }
            column(Profit_Control34;Profit)
            {
            }
            column(ItemProfitPct_Control35;ItemProfitPct)
            {
                DecimalPlaces = 1:1;
            }
            column(QuantityReturned_Control3;QuantityReturned)
            {
                DecimalPlaces = 2:5;
            }
            column(Item__COGS__LCY___Control4;"COGS (LCY)")
            {
            }
            column(Item__Sales__Qty____Control37;"Sales (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Item__Sales__LCY___Control38;"Sales (LCY)")
            {
            }
            column(Profit_Control39;Profit)
            {
            }
            column(ItemProfitPct_Control40;ItemProfitPct)
            {
                DecimalPlaces = 1:1;
            }
            column(QuantityReturned_Control5;QuantityReturned)
            {
                DecimalPlaces = 2:5;
            }
            column(Item__COGS__LCY___Control6;"COGS (LCY)")
            {
            }
            column(Item_Inventory_Posting_Group;"Inventory Posting Group")
            {
            }
            column(Item_Vendor_No_;"Vendor No.")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Inventory_items_without_sales_are_not_included_on_this_report_Caption;Inventory_items_without_sales_are_not_included_on_this_report_CaptionLbl)
            {
            }
            column(Inventory_items_without_sales_during_the_above_period_are_not_included_on_this_report_Caption;Inventory_items_without_sales_during_the_above_period_are_not_included_on_this_report_CaptionLbl)
            {
            }
            column(Item__No__Caption;FieldCaption("No."))
            {
            }
            column(Item__Base_Unit_of_Measure_Caption;FieldCaption("Base Unit of Measure"))
            {
            }
            column(Item__COGS__LCY__Caption;FieldCaption("COGS (LCY)"))
            {
            }
            column(Item__Unit_Price_Caption;FieldCaption("Unit Price"))
            {
            }
            column(Item__Sales__Qty___Caption;FieldCaption("Sales (Qty.)"))
            {
            }
            column(Item__Sales__LCY__Caption;FieldCaption("Sales (LCY)"))
            {
            }
            column(ProfitCaption;ProfitCaptionLbl)
            {
            }
            column(ItemProfitPctCaption;ItemProfitPctCaptionLbl)
            {
            }
            column(QuantityReturnedCaption;QuantityReturnedCaptionLbl)
            {
            }
            column(Item__No__Caption_Control41;FieldCaption("No."))
            {
            }
            column(Item__Base_Unit_of_Measure_Caption_Control43;FieldCaption("Base Unit of Measure"))
            {
            }
            column(Item__Unit_Price_Caption_Control44;FieldCaption("Unit Price"))
            {
            }
            column(Item__Sales__Qty___Caption_Control45;FieldCaption("Sales (Qty.)"))
            {
            }
            column(QuantityReturnedCaption_Control46;QuantityReturnedCaption_Control46Lbl)
            {
            }
            column(Item__Sales__LCY__Caption_Control47;FieldCaption("Sales (LCY)"))
            {
            }
            column(Item__COGS__LCY__Caption_Control48;FieldCaption("COGS (LCY)"))
            {
            }
            column(ProfitCaption_Control49;ProfitCaption_Control49Lbl)
            {
            }
            column(ItemProfitPctCaption_Control50;ItemProfitPctCaption_Control50Lbl)
            {
            }
            column(Item_Variant_CodeCaption;Item_Variant_CodeCaptionLbl)
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }
            dataitem("Item Variant";"Item Variant")
            {
                DataItemLink = "Item No."=field("No.");
                DataItemTableView = sorting("Item No.",Code);
                column(ReportForNavId_7031; 7031)
                {
                }
                column(Item_Variant_Code;Code)
                {
                }
                column(Item__No___Control53;Item."No.")
                {
                }
                column(Item__Base_Unit_of_Measure__Control55;Item."Base Unit of Measure")
                {
                }
                column(Item__Unit_Price__Control56;Item."Unit Price")
                {
                }
                column(Item__Sales__Qty____Control57;Item."Sales (Qty.)")
                {
                    DecimalPlaces = 2:5;
                }
                column(QuantityReturned_Control58;QuantityReturned)
                {
                    DecimalPlaces = 2:5;
                }
                column(Item__Sales__LCY___Control59;Item."Sales (LCY)")
                {
                }
                column(Item__COGS__LCY___Control60;Item."COGS (LCY)")
                {
                }
                column(Profit_Control61;Profit)
                {
                }
                column(ItemProfitPct_Control62;ItemProfitPct)
                {
                    DecimalPlaces = 1:1;
                }
                column(Item_Description_Control63;Item.Description)
                {
                }
                column(Item_Variant_Description;Description)
                {
                }
                column(Item_Variant_Item_No_;"Item No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if BlankVariant then begin
                      Code := '';
                      "Item No." := '';
                      Description := 'Blank Variant';
                      "Description 2" := '';
                      BlankVariant := false;
                    end;

                    Item.SetRange("Variant Filter",Code);
                    Item.CalcFields("Sales (Qty.)","Sales (LCY)","COGS (LCY)");
                    if (Item."Sales (Qty.)" = 0) and PrintOnlyIfSales then
                      CurrReport.Skip;
                    Profit := Item."Sales (LCY)" - Item."COGS (LCY)";
                    if Item."Sales (LCY)" <> 0 then
                      ItemProfitPct := ROUND(Profit / Item."Sales (LCY)" * 100,0.1)
                    else
                      ItemProfitPct := 0;
                    QuantityReturned := 0;
                    ItemLedgerEntry.SetRange("Item No.",Item."No.");
                    ItemLedgerEntry.SetRange("Variant Code",Code);
                    if ItemLedgerEntry.Find('-') then
                      repeat
                        if ItemLedgerEntry."Invoiced Quantity" > 0 then begin
                          QuantityReturned := QuantityReturned + ItemLedgerEntry."Invoiced Quantity";
                          Item."Sales (Qty.)" := Item."Sales (Qty.)" + ItemLedgerEntry."Invoiced Quantity";
                        end;
                      until ItemLedgerEntry.Next = 0;
                    if (Item."Sales (Qty.)" = 0) and (QuantityReturned = 0) and
                       (Item."Sales (LCY)" = 0) and (Item."COGS (LCY)" = 0)
                    then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if not BreakdownByVariant then
                      CurrReport.Break;
                    if not AnyVariants then
                      CurrReport.Break;

                    BlankVariant := true;
                    CurrReport.CreateTotals(Item."Sales (Qty.)",Item."Sales (LCY)",Item."COGS (LCY)",
                      Profit,QuantityReturned);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                NoShow := false;
                if BreakdownByVariant then begin
                  NoVariant := Text002;
                  if AnyVariants then
                    NoShow := true;
                  // EXIT;
                end;

                SetRange("Variant Filter");
                CalcFields("Sales (Qty.)","Sales (LCY)","COGS (LCY)");
                if ("Sales (Qty.)" = 0) and PrintOnlyIfSales then
                  CurrReport.Skip;
                Profit := "Sales (LCY)" - "COGS (LCY)";
                if "Sales (LCY)" <> 0 then
                  ItemProfitPct := ROUND(Profit / "Sales (LCY)" * 100,0.1)
                else
                  ItemProfitPct := 0;
                QuantityReturned := 0;
                ItemLedgerEntry.SetRange("Item No.","No.");
                ItemLedgerEntry.SetRange("Variant Code");
                if ItemLedgerEntry.Find('-') then
                  repeat
                    if ItemLedgerEntry."Invoiced Quantity" > 0 then begin
                      QuantityReturned := QuantityReturned + ItemLedgerEntry."Invoiced Quantity";
                      "Sales (Qty.)" := "Sales (Qty.)" + ItemLedgerEntry."Invoiced Quantity";
                    end;
                  until ItemLedgerEntry.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Sales (Qty.)","Sales (LCY)","COGS (LCY)",
                  Profit,QuantityReturned);
                ItemLedgerEntry.SetCurrentkey("Entry Type","Item No.");
                ItemLedgerEntry.SetRange("Entry Type",ItemLedgerEntry."entry type"::Sale);
                Copyfilter("Date Filter",ItemLedgerEntry."Posting Date");
                Copyfilter("Global Dimension 1 Filter",ItemLedgerEntry."Global Dimension 1 Code");
                Copyfilter("Global Dimension 2 Filter",ItemLedgerEntry."Global Dimension 2 Code");
                Copyfilter("Location Filter",ItemLedgerEntry."Location Code");

                if StrPos(CurrentKey,FieldCaption("Inventory Posting Group")) = 1 then begin
                  if not ItemPostingGr.Get("Inventory Posting Group") then
                    ItemPostingGr.Init;
                  TLGroup := true;
                  GroupField := 2;
                  GroupName := ItemPostingGr.TableCaption;
                  GroupNo := "Inventory Posting Group";
                  GroupDesc := ItemPostingGr.Description;
                end;
                if StrPos(CurrentKey,FieldCaption("Vendor No.")) = 1 then begin
                  if not Vendor.Get("Vendor No.") then
                    Vendor.Init;
                  TLGroup := true;
                  GroupField := 3;
                  GroupName := Vendor.TableCaption;
                  GroupNo := "Vendor No.";
                  GroupDesc := Vendor.Name;
                end;
                if  (StrPos(CurrentKey,FieldCaption("Inventory Posting Group")) = 0) and
                   (StrPos(CurrentKey,FieldCaption("Vendor No.")) = 0)
                then begin
                  TLGroup := false;
                  GroupName := '';
                  GroupNo := '';
                  GroupDesc := '';
                end;
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
                    field(PrintOnlyIfSales;PrintOnlyIfSales)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Only Items with Sales';
                    }
                    field(IncludeItemDescriptions;IncludeItemDescriptions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Item Descriptions';
                    }
                    field(BreakdownByVariant;BreakdownByVariant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Breakdown By Variant';
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
    }

    trigger OnPreReport()
    begin
        Title := Text000;
        if BreakdownByVariant then
          Title := Title + ' - ' + Text001;

        CompanyInformation.Get;
        ItemFilter := Item.GetFilters;
        ItemDateFilterExsit := (Item.GetFilter("Date Filter") <> '');
    end;

    var
        CompanyInformation: Record "Company Information";
        ItemPostingGr: Record "Inventory Posting Group";
        Vendor: Record Vendor;
        ItemLedgerEntry: Record "Item Ledger Entry";
        IncludeItemDescriptions: Boolean;
        BreakdownByVariant: Boolean;
        BlankVariant: Boolean;
        NoShow: Boolean;
        ItemFilter: Text;
        Title: Text[80];
        NoVariant: Text[30];
        Profit: Decimal;
        QuantityReturned: Decimal;
        ItemProfitPct: Decimal;
        PrintOnlyIfSales: Boolean;
        GroupName: Text[30];
        GroupNo: Code[20];
        GroupDesc: Text[30];
        Text000: label 'Inventory Sales Statistics';
        Text001: label 'by Variant';
        Text002: label 'No Variants';
        Text003: label 'Total';
        TLGroup: Boolean;
        GroupField: Integer;
        ItemDateFilterExsit: Boolean;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Inventory_items_without_sales_are_not_included_on_this_report_CaptionLbl: label 'Inventory items without sales are not included on this report.';
        Inventory_items_without_sales_during_the_above_period_are_not_included_on_this_report_CaptionLbl: label 'Inventory items without sales during the above period are not included on this report.';
        ProfitCaptionLbl: label 'Profit';
        ItemProfitPctCaptionLbl: label 'Profit %';
        QuantityReturnedCaptionLbl: label 'Quantity Returned';
        QuantityReturnedCaption_Control46Lbl: label 'Quantity Returned';
        ProfitCaption_Control49Lbl: label 'Profit';
        ItemProfitPctCaption_Control50Lbl: label 'Profit %';
        Item_Variant_CodeCaptionLbl: label 'Variant Code';
        Report_TotalCaptionLbl: label 'Report Total';


    procedure AnyVariants(): Boolean
    var
        ItemVariant: Record "Item Variant";
    begin
        ItemVariant.SetRange("Item No.",Item."No.");
        exit(ItemVariant.FindFirst);
    end;
}

