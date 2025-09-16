#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51328 "Leave Types"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Leave Types.rdlc';

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
            column(Leave_Types__Acrue_Days_;"Acrue Days")
            {
            }
            column(Leave_Types__Unlimited_Days_;"Unlimited Days")
            {
            }
            column(Leave_Types_Gender;Gender)
            {
            }
            column(Leave_Types_Balance;Balance)
            {
            }
            column(Leave_Types__Inclusive_of_Holidays_;"Inclusive of Holidays")
            {
            }
            column(Leave_Types__Inclusive_of_Saturday_;"Inclusive of Saturday")
            {
            }
            column(Leave_Types__Inclusive_of_Sunday_;"Inclusive of Sunday")
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
            column(Leave_Types__Acrue_Days_Caption;FieldCaption("Acrue Days"))
            {
            }
            column(Leave_Types__Unlimited_Days_Caption;FieldCaption("Unlimited Days"))
            {
            }
            column(Leave_Types_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Inc__HolidaysCaption;Inc__HolidaysCaptionLbl)
            {
            }
            column(Inc__Sat_Caption;Inc__Sat_CaptionLbl)
            {
            }
            column(Inc__SundayCaption;Inc__SundayCaptionLbl)
            {
            }
            column(Off_Holidays_LeaveCaption;Off_Holidays_LeaveCaptionLbl)
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
        Inc__HolidaysCaptionLbl: label 'Inc. Holidays';
        Inc__Sat_CaptionLbl: label 'Inc. Sat.';
        Inc__SundayCaptionLbl: label 'Inc. Sunday';
        Off_Holidays_LeaveCaptionLbl: label 'Off/Holidays Leave';
}

