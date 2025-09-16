#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51216 "Hr Employee Important Dates"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hr Employee Important Dates.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            RequestFilterFields = "No.","Directorate Name","Station Name","Department Code";
            column(ReportForNavId_6075; 6075)
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
            column(CI_Name;CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address;CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2;CI."Address 2")
            {
                IncludeCaption = true;
            }
            column(CI_City;CI.City)
            {
                IncludeCaption = true;
            }
            column(CI_EMail;CI."E-Mail")
            {
                IncludeCaption = true;
            }
            column(CI_HomePage;CI."Home Page")
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(CI_Picture;CI.Picture)
            {
                IncludeCaption = true;
            }
            column(HR_Employees__No__;"No.")
            {
            }
            column(HR_Employees__ID_Number_;"ID Number")
            {
            }
            column(HR_Employees__Job_Description_;'')
            {
            }
            column(HR_Employees__Date_Of_Joining_the_Company_;"Date Of Join")
            {
            }
            column(HR_Employees__FullName;"HRM-Employee C".FullName)
            {
            }
            column(HR_Employees__Cell_Phone_Number_;"Cellular Phone Number")
            {
            }
            column(EmployeeCaption;EmployeeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_ListCaption;Employee_ListCaptionLbl)
            {
            }
            column(P_O__BoxCaption;P_O__BoxCaptionLbl)
            {
            }
            column(HR_Employees__No__Caption;FieldCaption("No."))
            {
            }
            column(HR_Employees__ID_Number_Caption;FieldCaption("ID Number"))
            {
            }
            column(HR_Employees__Job_Description_Caption;'Job')
            {
            }
            column(HR_Employees__Date_Of_Joining_the_Company_Caption;FieldCaption("Date Of Join"))
            {
            }
            column(Full_NamesCaption;Full_NamesCaptionLbl)
            {
            }
            column(LengthOfService_HREmployees;"HRM-Employee C"."Length Of Service")
            {
            }
            column(JobScale_HREmployees;'Salary Scale:')
            {
            }
            column(DateOfBirth_HREmployees;"HRM-Employee C"."Date Of Birth")
            {
            }
            column(DateOfPresentAppointment_HREmployees;"HRM-Employee C"."Date Of Present Appointment")
            {
            }
            column(ConfirmationDate_HREmployees;"HRM-Employee C"."Confirmation Date")
            {
            }
            column(RetirementDate_HREmployees;"HRM-Employee C"."Retirement date")
            {
            }
            column(Age_HREmployees;"HRM-Employee C".Age)
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

    trigger OnPreReport()
    begin
                            CI.Get();
                            CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_ListCaptionLbl: label 'Employee List';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        Full_NamesCaptionLbl: label 'Full Names';
}

