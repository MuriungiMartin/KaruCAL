#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51650 "EMPLOYEE TEST"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EMPLOYEE TEST.rdlc';

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
            column(USERID;UserId)
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__Middle_Name_;"Middle Name")
            {
            }
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(HR_Employee_C_Initials;Initials)
            {
            }
            column(HR_Employee_C__Search_Name_;"Search Name")
            {
            }
            column(HR_Employee_C__Postal_Address_;"Postal Address")
            {
            }
            column(HR_Employee_C__Residential_Address_;"Residential Address")
            {
            }
            column(HR_Employee_C_City;City)
            {
            }
            column(HR_Employee_C__Post_Code_;"Post Code")
            {
            }
            column(HR_Employee_C_County;County)
            {
            }
            column(HR_Employee_C__Home_Phone_Number_;"Home Phone Number")
            {
            }
            column(HR_Employee_C__Cellular_Phone_Number_;"Cellular Phone Number")
            {
            }
            column(EmployeeCaption;EmployeeCaptionLbl)
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
            column(HR_Employee_C__Middle_Name_Caption;FieldCaption("Middle Name"))
            {
            }
            column(HR_Employee_C__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(HR_Employee_C_InitialsCaption;FieldCaption(Initials))
            {
            }
            column(HR_Employee_C__Search_Name_Caption;FieldCaption("Search Name"))
            {
            }
            column(HR_Employee_C__Postal_Address_Caption;FieldCaption("Postal Address"))
            {
            }
            column(HR_Employee_C__Residential_Address_Caption;FieldCaption("Residential Address"))
            {
            }
            column(HR_Employee_C_CityCaption;FieldCaption(City))
            {
            }
            column(HR_Employee_C__Post_Code_Caption;FieldCaption("Post Code"))
            {
            }
            column(HR_Employee_C_CountyCaption;FieldCaption(County))
            {
            }
            column(HR_Employee_C__Home_Phone_Number_Caption;FieldCaption("Home Phone Number"))
            {
            }
            column(HR_Employee_C__Cellular_Phone_Number_Caption;FieldCaption("Cellular Phone Number"))
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
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

