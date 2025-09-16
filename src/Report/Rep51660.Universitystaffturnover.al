#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51660 "University staff turn over"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/University staff turn over.rdlc';

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
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(HR_Employee_C__Date_Of_Join_;"Date Of Join")
            {
            }
            column(HR_Employee_C__Date_Of_Leaving_;"Date Of Leaving")
            {
            }
            column(HR_Employee_C__Termination_Category_;"Termination Category")
            {
            }
            column(Staff_Turn_Over_ReportCaption;Staff_Turn_Over_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Employee_C__No__Caption;FieldCaption("No."))
            {
            }
            column(HR_Employee_C__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(HR_Employee_C__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(Employement_DateCaption;Employement_DateCaptionLbl)
            {
            }
            column(HR_Employee_C__Date_Of_Leaving_Caption;FieldCaption("Date Of Leaving"))
            {
            }
            column(HR_Employee_C__Termination_Category_Caption;FieldCaption("Termination Category"))
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
        Staff_Turn_Over_ReportCaptionLbl: label 'Staff Turn Over Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employement_DateCaptionLbl: label 'Employement Date';
}

