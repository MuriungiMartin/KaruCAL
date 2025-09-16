#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7312 "Bin Content Create Wksh Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bin Content Create Wksh Report.rdlc';
    Caption = 'Bin Content Create Wksh Report';

    dataset
    {
        dataitem("Bin Creation Worksheet Line";"Bin Creation Worksheet Line")
        {
            DataItemTableView = sorting("Location Code","Zone Code","Bin Code","Item No.","Variant Code");
            RequestFilterFields = "Location Code","Zone Code","Bin Code";
            column(ReportForNavId_3470; 3470)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(LocCode_BinCreateWkshLine;"Location Code")
            {
                IncludeCaption = true;
            }
            column(WkshTmpltName_BinCreateWkshLine;"Worksheet Template Name")
            {
                IncludeCaption = true;
            }
            column(Name_BinCreateWkshLine;Name)
            {
                IncludeCaption = true;
            }
            column(ZoneCode_BinCreateWkshLine;"Zone Code")
            {
                IncludeCaption = true;
            }
            column(BinCode_BinCreateWkshLine;"Bin Code")
            {
                IncludeCaption = true;
            }
            column(WhseClassCode_BinCreateWkshLine;"Warehouse Class Code")
            {
                IncludeCaption = true;
            }
            column(BinType_BinCreateWkshLine;"Bin Type Code")
            {
                IncludeCaption = true;
            }
            column(BlkMvmt_BinCreateWkshLine;"Block Movement")
            {
                IncludeCaption = true;
            }
            column(BinRanking_BinCreateWkshLine;"Bin Ranking")
            {
                IncludeCaption = true;
            }
            column(ItemNo_BinCreateWkshLine;"Item No.")
            {
                IncludeCaption = true;
            }
            column(Desc_BinCreateWkshLine;Description)
            {
                IncludeCaption = true;
            }
            column(MinQty_BinCreateWkshLine;"Min. Qty.")
            {
                IncludeCaption = true;
            }
            column(MaxQty_BinCreateWkshLine;"Max. Qty.")
            {
                IncludeCaption = true;
            }
            column(VariantCode_BinCreateWkshLine;"Variant Code")
            {
                IncludeCaption = true;
            }
            column(QtyPerUOM_BinCreateWkshLine;"Qty. per Unit of Measure")
            {
                IncludeCaption = true;
            }
            column(UOMCode_BinCreateWkshLine;"Unit of Measure Code")
            {
                IncludeCaption = true;
            }
            column(Fixed_BinCreateWkshLine;Fixed)
            {
                IncludeCaption = true;
            }
            column("Fixed";Format(Fixed))
            {
            }
            column(BinContentCreationWorksheetLineCaption;BinContentCreationWorksheetLineCaptionLbl)
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

    var
        BinContentCreationWorksheetLineCaptionLbl: label 'Bin Content Creation Worksheet Line';
        CurrReportPageNoCaptionLbl: label 'Page';
}

