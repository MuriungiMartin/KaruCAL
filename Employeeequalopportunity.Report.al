#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51658 "Employee equal opportunity"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee equal opportunity.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_3372; 3372)
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
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C_Tribe;Tribe)
            {
            }
            column(HR_Employee_C_Gender;Gender)
            {
            }
            column(EMPLOYEE_EQUAL_OPPORTUNITY_Caption;EMPLOYEE_EQUAL_OPPORTUNITY_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Employee_C__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(HR_Employee_C__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(HR_Employee_C__No__Caption;FieldCaption("No."))
            {
            }
            column(HR_Employee_C_TribeCaption;FieldCaption(Tribe))
            {
            }
            column(HR_Employee_C_GenderCaption;FieldCaption(Gender))
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
        EMPLOYEE_EQUAL_OPPORTUNITY_CaptionLbl: label 'EMPLOYEE EQUAL OPPORTUNITY ';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

