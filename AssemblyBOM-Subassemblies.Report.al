#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 811 "Assembly BOM - Subassemblies"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Assembly BOM - Subassemblies.rdlc';
    Caption = 'BOM - Sub-Assemblies';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = where("Assembly BOM"=const(true));
            RequestFilterFields = "No.","Base Unit of Measure","Shelf No.";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(temFilter_Item;TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
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
            column(UnitCost_Item;"Unit Cost")
            {
                IncludeCaption = true;
            }
            column(AlternativeItemNo_Item;"Alternative Item No.")
            {
                IncludeCaption = true;
            }
            column(BOMSubAssembliesCaption;BOMSubAssembliesCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                BOMComp.Reset;
                BOMComp.SetCurrentkey(Type,"No.");
                BOMComp.SetRange(Type,BOMComp.Type::Item);
                BOMComp.SetRange("No.","No.");
                if not BOMComp.FindFirst then // Not part of a BOM
                  CurrReport.Skip;
            end;
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
        BOMComp: Record "BOM Component";
        ItemFilter: Text;
        BOMSubAssembliesCaptionLbl: label 'BOM - Sub-Assemblies';
        CurrReportPageNoCaptionLbl: label 'Page';
}

