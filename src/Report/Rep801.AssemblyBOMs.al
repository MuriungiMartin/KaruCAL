#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 801 "Assembly BOMs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Assembly BOMs.rdlc';
    Caption = 'BOMs';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Description";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ItemTableCaptionItemFilter;TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(No_Item;"No.")
            {
            }
            column(Description_Item;Description)
            {
            }
            column(BOMsCaption;BOMsCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(BOMCompAssemblyBOMCaption;BOMCompAssemblyBOMCaptionLbl)
            {
            }
            dataitem("BOM Component";"BOM Component")
            {
                CalcFields = "Assembly BOM";
                DataItemLink = "Parent Item No."=field("No.");
                DataItemTableView = sorting("Parent Item No.","Line No.");
                column(ReportForNavId_8421; 8421)
                {
                }
                column(Position_BOMComp;Position)
                {
                    IncludeCaption = true;
                }
                column(Type_BOMComp;Type)
                {
                    IncludeCaption = true;
                }
                column(No_BOMComp;"No.")
                {
                    IncludeCaption = true;
                }
                column(Description_BOMComp;Description)
                {
                    IncludeCaption = true;
                }
                column(AssemblyBOM_BOMComp;Format("Assembly BOM"))
                {
                }
                column(Quantityper_BOMComp;"Quantity per")
                {
                    IncludeCaption = true;
                }
                column(UnitofMeasureCode_BOMComp;"Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
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
        BOMsCaptionLbl: label 'BOMs';
        CurrReportPageNoCaptionLbl: label 'Page';
        BOMCompAssemblyBOMCaptionLbl: label 'BOM';
}

