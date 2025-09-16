#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51659 "KCA Employee Contract Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Employee Contract Status.rdlc';

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
            column(HR_Employee_C__Contract_End_Date_;"Contract End Date")
            {
            }
            column(KCA_University_Employee_Contract_Status_ReportCaption;KCA_University_Employee_Contract_Status_ReportCaptionLbl)
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
            column(Employment_DateCaption;Employment_DateCaptionLbl)
            {
            }
            column(HR_Employee_C__Contract_End_Date_Caption;FieldCaption("Contract End Date"))
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
        KCA_University_Employee_Contract_Status_ReportCaptionLbl: label 'KCA University Employee Contract Status Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employment_DateCaptionLbl: label 'Employment Date';
}

