#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51329 Holidays
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Holidays.rdlc';

    dataset
    {
        dataitem(UnknownTable61280;UnknownTable61280)
        {
            DataItemTableView = sorting(Date);
            column(ReportForNavId_3682; 3682)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Holidays_Date;Date)
            {
            }
            column(Holidays_Description;Description)
            {
            }
            column(HolidaysCaption;HolidaysCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Holidays_DateCaption;FieldCaption(Date))
            {
            }
            column(Holidays_DescriptionCaption;FieldCaption(Description))
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
        HolidaysCaptionLbl: label 'Holidays';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

