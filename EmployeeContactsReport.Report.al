#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51655 "Employee Contacts Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Contacts Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            DataItemTableView = sorting("No.");
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
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(HR_Employee_C__Cellular_Phone_Number_;"Cellular Phone Number")
            {
            }
            column(HR_Employee_C__Postal_Address_;"Postal Address")
            {
            }
            column(HR_Employee_C__E_Mail_;"E-Mail")
            {
            }
            column(Employee_Contacts_ReportCaption;Employee_Contacts_ReportCaptionLbl)
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
            column(Telephone_ContactCaption;Telephone_ContactCaptionLbl)
            {
            }
            column(HR_Employee_C__Postal_Address_Caption;FieldCaption("Postal Address"))
            {
            }
            column(HR_Employee_C__E_Mail_Caption;FieldCaption("E-Mail"))
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
        Employee_Contacts_ReportCaptionLbl: label 'Employee Contacts Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Telephone_ContactCaptionLbl: label 'Telephone Contact';
}

