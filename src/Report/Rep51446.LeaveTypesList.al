#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51446 "Leave Types List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Leave Types List.rdlc';

    dataset
    {
        dataitem(UnknownTable61279;UnknownTable61279)
        {
            DataItemTableView = sorting(Code);
            column(ReportForNavId_3053; 3053)
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
            column(Leave_Types_Code;Code)
            {
            }
            column(Leave_Types_Description;Description)
            {
            }
            column(Leave_Types_Days;Days)
            {
            }
            column(Leave_TypesCaption;Leave_TypesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Leave_Types_CodeCaption;FieldCaption(Code))
            {
            }
            column(Leave_Types_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Leave_Types_DaysCaption;FieldCaption(Days))
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
        Leave_TypesCaptionLbl: label 'Leave Types';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

