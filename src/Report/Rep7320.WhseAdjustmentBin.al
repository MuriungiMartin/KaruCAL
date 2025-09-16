#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7320 "Whse. Adjustment Bin"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Whse. Adjustment Bin.rdlc';
    Caption = 'Whse. Adjustment Bin';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Warehouse Entry";"Warehouse Entry")
        {
            DataItemTableView = sorting("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code");
            RequestFilterFields = "Location Code","Item No.";
            column(ReportForNavId_9585; 9585)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormated;Format(Today,0,4))
            {
            }
            column(Details;Details)
            {
            }
            column(WarehouseEntryTableCaption;TableCaption + ': ' + WhseEntryFilter)
            {
            }
            column(WhseEntryFilter;WhseEntryFilter)
            {
            }
            column(LocCode_WarehouseEntry;"Location Code")
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(WarehouseAdjBinCaption;WarehouseAdjBinCaptionLbl)
            {
            }
            column(WhseEntry2UOMCodeCaption;WhseEntry2.FieldCaption("Unit of Measure Code"))
            {
            }
            column(WhseEntry2QtyPerUOMCaption;WhseEntry2.FieldCaption("Qty. per Unit of Measure"))
            {
            }
            column(WhseEntry2QtyBaseCaption;WhseEntry2.FieldCaption("Qty. (Base)"))
            {
            }
            column(WhseEntry2QuantityCaption;WhseEntry2.FieldCaption(Quantity))
            {
            }
            column(WhseEntry2VariantCodeCaption;WhseEntry2.FieldCaption("Variant Code"))
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(WarehouseEntryLocCode;"Warehouse Entry"."Location Code")
                {
                }
                column(WarehouseEntryBinCode;"Warehouse Entry"."Bin Code")
                {
                }
                column(WarehouseEntryZoneCode;"Warehouse Entry"."Zone Code")
                {
                }
                column(IntHdr1;WhseEntry."Location Code" <> "Warehouse Entry"."Location Code")
                {
                }
                column(WarehouseEntryItemNo;"Warehouse Entry"."Item No.")
                {
                }
                column(IntHdr2;WhseEntry."Item No." <> "Warehouse Entry"."Item No.")
                {
                }
                column(WhseEntryQuantity;WhseEntry.Quantity)
                {
                    DecimalPlaces = 2:2;
                }
                column(WhseEntryQtyBase;WhseEntry."Qty. (Base)")
                {
                    DecimalPlaces = 2:2;
                }
                column(WarehouseEntryQtyPerUOM;"Warehouse Entry"."Qty. per Unit of Measure")
                {
                }
                column(WarehouseEntryUOMCode;"Warehouse Entry"."Unit of Measure Code")
                {
                }
                column(WarehouseEntryVariantCode;"Warehouse Entry"."Variant Code")
                {
                }
                column(WarehouseEntryLocCodeCaption;WarehouseEntryLocCodeCaptionLbl)
                {
                }
                column(WarehouseEntryBinCodeCaption;WarehouseEntryBinCodeCaptionLbl)
                {
                }
                column(WarehouseEntryZoneCodeCaption;WarehouseEntryZoneCodeCaptionLbl)
                {
                }
                column(WarehouseEntryItemNoCaption;WarehouseEntryItemNoCaptionLbl)
                {
                }

                trigger OnPostDataItem()
                begin
                    WhseEntry.FindLast;
                    "Warehouse Entry" := WhseEntry;
                end;

                trigger OnPreDataItem()
                begin
                    if Details then
                      CurrReport.Break;

                    WhseEntry.Reset;
                    WhseEntry.SetCurrentkey("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code");
                    WhseEntry.SetRange("Item No.","Warehouse Entry"."Item No.");
                    WhseEntry.SetRange("Bin Code",Location."Adjustment Bin Code");
                    WhseEntry.SetRange("Location Code","Warehouse Entry"."Location Code");
                    WhseEntry.SetRange("Variant Code","Warehouse Entry"."Variant Code");
                    WhseEntry.SetRange("Unit of Measure Code","Warehouse Entry"."Unit of Measure Code");
                    WhseEntry.CalcSums("Qty. (Base)",Quantity);
                    if (WhseEntry."Qty. (Base)" = 0) and not ZeroQty then
                      CurrReport.Break;
                end;
            }
            dataitem(WhseEntry2;"Warehouse Entry")
            {
                DataItemLink = "Location Code"=field("Location Code"),"Bin Code"=field("Bin Code"),"Item No."=field("Item No."),"Variant Code"=field("Variant Code"),"Unit of Measure Code"=field("Unit of Measure Code");
                DataItemTableView = sorting("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code");
                column(ReportForNavId_4696; 4696)
                {
                }
                column(WhseEntry2LocCode;"Location Code")
                {
                }
                column(WhseEntry2BinCode;"Bin Code")
                {
                }
                column(WhseEntry2ZoneCode;"Zone Code")
                {
                }
                column(WhseEntry2ItemNo;"Item No.")
                {
                }
                column(WhseEntry2Quantity;Quantity)
                {
                }
                column(WhseEntry2QtyPerUOM;"Qty. per Unit of Measure")
                {
                }
                column(WhseEntry2UOMCode;"Unit of Measure Code")
                {
                }
                column(WhseEntry2QtyBase;"Qty. (Base)")
                {
                }
                column(WhseEntry2VariantCode;"Variant Code")
                {
                }
                column(TotalForItemNo;Text000 + FieldCaption("Item No."))
                {
                }
                column(TotalForLocCode;Text000 + FieldCaption("Location Code"))
                {
                }
                column(WhseEntry2LocationCodeCaption;FieldCaption("Location Code"))
                {
                }
                column(WhseEntry2BinCodeCaption;FieldCaption("Bin Code"))
                {
                }
                column(WhseEntry2ZoneCodeCaption;FieldCaption("Zone Code"))
                {
                }
                column(WhseEntry2ItemNoCaption;FieldCaption("Item No."))
                {
                }

                trigger OnPostDataItem()
                begin
                    if "Bin Code" <> '' then
                      "Warehouse Entry" := WhseEntry2;
                end;

                trigger OnPreDataItem()
                begin
                    if not Details then
                      CurrReport.Break;
                    if not Find('-') then
                      CurrReport.Break;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Location.Code <> "Location Code" then begin
                  Location.Get("Location Code");
                  if Location."Adjustment Bin Code" = '' then
                    CurrReport.Skip
                    ;
                  SetRange("Bin Code",Location."Adjustment Bin Code");
                  if not Find('-') then
                    CurrReport.Break;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Clear(Location);
                if not Find('-') then
                  CurrReport.Break;
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
                    field(ZeroQty;ZeroQty)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Zero Quantity';
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
        WhseEntryFilter := "Warehouse Entry".GetFilters;
    end;

    var
        Location: Record Location;
        WhseEntry: Record "Warehouse Entry";
        WhseEntryFilter: Text;
        Text000: label 'Total for ';
        Details: Boolean;
        ZeroQty: Boolean;
        CurrReportPageNoCaptionLbl: label 'Page';
        WarehouseAdjBinCaptionLbl: label 'Warehouse Adjustment Bin';
        WarehouseEntryLocCodeCaptionLbl: label 'Location Code';
        WarehouseEntryBinCodeCaptionLbl: label 'Bin No';
        WarehouseEntryZoneCodeCaptionLbl: label 'Zone Code';
        WarehouseEntryItemNoCaptionLbl: label 'Item No.';
}

