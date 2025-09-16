#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7303 "Warehouse Register - Quantity"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Warehouse Register - Quantity.rdlc';
    Caption = 'Warehouse Register - Quantity';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Warehouse Register";"Warehouse Register")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_5723; 5723)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(WhseRegisterCaptionWithFilter;TableCaption + ': ' + WhseRegFilter)
            {
            }
            column(WhseRegFilter;WhseRegFilter)
            {
            }
            column(No_WarehouseRegister;"No.")
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(WarehouseRegisterQuantityCaption;WarehouseRegisterQuantityCaptionLbl)
            {
            }
            column(WarehouseEntryRegisteringDateCaption;WarehouseEntryRegisteringDateCaptionLbl)
            {
            }
            column(ItemDescriptionCaption;ItemDescriptionCaptionLbl)
            {
            }
            column(WarehouseRegisterNoCaption;WarehouseRegisterNoCaptionLbl)
            {
            }
            dataitem("Warehouse Entry";"Warehouse Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_9585; 9585)
                {
                }
                column(EntryNo_WarehouseEntry;"Entry No.")
                {
                    IncludeCaption = true;
                }
                column(Quantity_WarehouseEntry;Quantity)
                {
                    IncludeCaption = true;
                }
                column(ItemNo_WarehouseEntry;"Item No.")
                {
                    IncludeCaption = true;
                }
                column(WhseDocNo_WarehouseEntry;"Whse. Document No.")
                {
                    IncludeCaption = true;
                }
                column(RegDate_WarehouseEntry;Format("Registering Date"))
                {
                }
                column(ZoneCode_WarehouseEntry;"Zone Code")
                {
                    IncludeCaption = true;
                }
                column(BinCode_WarehouseEntry;"Bin Code")
                {
                    IncludeCaption = true;
                }
                column(Cubage_WarehouseEntry;Cubage)
                {
                    IncludeCaption = true;
                }
                column(Weight_WarehouseEntry;Weight)
                {
                    IncludeCaption = true;
                }
                column(UOMCode_WarehouseEntry;"Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(VariantCode_WarehouseEntry;"Variant Code")
                {
                    IncludeCaption = true;
                }
                column(ItemDescription;ItemDescription)
                {
                }
                column(SerialNo_WarehouseEntry;"Serial No.")
                {
                    IncludeCaption = true;
                }
                column(LotNo_WarehouseEntry;"Lot No.")
                {
                    IncludeCaption = true;
                }
                column(EntryType_WarehouseEntry;"Entry Type")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    if Item."No." <> "Item No." then begin
                      if not Item.Get("Item No.") then
                        Item.Init;
                      ItemDescription := Item.Description;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.","Warehouse Register"."From Entry No.","Warehouse Register"."To Entry No.");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
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
        WhseRegFilter := "Warehouse Register".GetFilters;
    end;

    var
        Item: Record Item;
        WhseRegFilter: Text;
        ItemDescription: Text[50];
        CurrReportPageNoCaptionLbl: label 'Page';
        WarehouseRegisterQuantityCaptionLbl: label 'Warehouse Register - Quantity';
        WarehouseEntryRegisteringDateCaptionLbl: label 'Registering Date';
        ItemDescriptionCaptionLbl: label 'Description';
        WarehouseRegisterNoCaptionLbl: label 'Register No.';
}

