#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 810 "Assembly BOM - Raw Materials"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Assembly BOM - Raw Materials.rdlc';
    Caption = 'BOM - Raw Materials';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = where("Assembly BOM"=const(false));
            RequestFilterFields = "No.","Base Unit of Measure","Shelf No.";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(CompanyName_Item;COMPANYNAME)
            {
            }
            column(ItemTableCaptionItemFilter;TableCaption + ': ' + ItemFilter)
            {
            }
            column(No_Item;"No.")
            {
                IncludeCaption = true;
            }
            column(Description_Item;Description)
            {
                IncludeCaption = true;
            }
            column(BaseUnitofMeasure_Item;"Base Unit of Measure")
            {
                IncludeCaption = true;
            }
            column(Inventory_Item;Inventory)
            {
                IncludeCaption = true;
            }
            column(VendorNo_Item;"Vendor No.")
            {
                IncludeCaption = true;
            }
            column(LeadTimeCalculation_Item;"Lead Time Calculation")
            {
                IncludeCaption = true;
            }
            column(BOMRawMaterialsCaption;BOMRawMaterialsCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
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
        ItemFilter := Item.GetFilters;
    end;

    var
        ItemFilter: Text;
        BOMRawMaterialsCaptionLbl: label 'BOM - Raw Materials';
        CurrReportPageNoCaptionLbl: label 'Page';
}

