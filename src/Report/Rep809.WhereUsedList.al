#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 809 "Where-Used List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Where-Used List.rdlc';
    Caption = 'Where-Used List';
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
            column(ItemTableCaption;TableCaption + ': ' + ItemFilter)
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
            column(WhereUsedListCaption;WhereUsedListCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            dataitem("BOM Component";"BOM Component")
            {
                DataItemLink = "No."=field("No.");
                DataItemTableView = sorting(Type,"No.") where(Type=const(Item));
                column(ReportForNavId_8421; 8421)
                {
                }
                dataitem(Item2;Item)
                {
                    DataItemLink = "No."=field("Parent Item No.");
                    DataItemTableView = sorting("No.");
                    column(ReportForNavId_9183; 9183)
                    {
                    }
                    column(Position_BOMComponent;"BOM Component".Position)
                    {
                        IncludeCaption = true;
                    }
                    column(ParentItemNo_BOMComponent;"BOM Component"."Parent Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_Item2;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantityper_BOMComponent;"BOM Component"."Quantity per")
                    {
                        DecimalPlaces = 0:5;
                        IncludeCaption = true;
                    }
                    column(BaseUnitofMeasure_Item2;"Base Unit of Measure")
                    {
                        IncludeCaption = true;
                    }
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
        WhereUsedListCaptionLbl: label 'Where-Used List';
        PageCaptionLbl: label 'Page';
}

