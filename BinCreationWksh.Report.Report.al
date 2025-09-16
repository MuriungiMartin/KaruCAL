#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7311 "Bin Creation Wksh. Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bin Creation Wksh. Report.rdlc';
    Caption = 'Bin Creation Wksh. Report';

    dataset
    {
        dataitem("Bin Creation Worksheet Line";"Bin Creation Worksheet Line")
        {
            DataItemTableView = sorting("Location Code","Zone Code","Bin Code","Item No.","Variant Code");
            RequestFilterFields = "Worksheet Template Name",Name;
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
            column(WkShTmpltName_BinCreateWkshLine;"Worksheet Template Name")
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
            column(Desc_BinCreateWkshLine;Description)
            {
                IncludeCaption = true;
            }
            column(BinTypeCode_BinCreateWkshLine;"Bin Type Code")
            {
                IncludeCaption = true;
            }
            column(WhseClassCode_BinCreateWkshLine;"Warehouse Class Code")
            {
                IncludeCaption = true;
            }
            column(BlkMvmt_BinCreateWkshLine;"Block Movement")
            {
                IncludeCaption = true;
            }
            column(SplEquipCode_BinCreateWkshLine;"Special Equipment Code")
            {
                IncludeCaption = true;
            }
            column(BinRanking_BinCreateWkshLine;"Bin Ranking")
            {
                IncludeCaption = true;
            }
            column(MaxCubage_BinCreateWkshLine;"Maximum Cubage")
            {
                IncludeCaption = true;
            }
            column(MaxWeight_BinCreateWkshLine;"Maximum Weight")
            {
                IncludeCaption = true;
            }
            column(BinCreationWorksheetLineReportCaption;BinCreationWorksheetLineReportCaptionLbl)
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
        BinCreationWorksheetLineReportCaptionLbl: label 'Bin Creation Worksheet Line Report';
        CurrReportPageNoCaptionLbl: label 'Page';
}

