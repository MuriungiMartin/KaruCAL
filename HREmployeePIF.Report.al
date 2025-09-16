#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51152 "HR Employee PIF"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Employee PIF.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            RequestFilterFields = "No.";
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
            column(HR_Employees__No__;"No.")
            {
            }
            column(HR_Employees__Date_Of_Joining_the_Company_;"Date Of Join")
            {
            }
            column(HR_Employees__ID_Number_;"ID Number")
            {
            }
            column(HR_Employees__Date_Of_Birth_;"Date Of Birth")
            {
            }
            column(HR_Employees__Marital_Status_;"Marital Status")
            {
            }
            column(HR_Employees__PIN_Number_;"PIN Number")
            {
            }
            column(HR_Employees__NSSF_No__;"NSSF No.")
            {
            }
            column(HR_Employees__NHIF_No__;"NHIF No.")
            {
            }
            column(HR_Employees__Cell_Phone_Number_;"Cellular Phone Number")
            {
            }
            column(HR_Employees__Postal_Address_;"Postal Address")
            {
            }
            column(HR_Employees_City;City)
            {
            }
            column(HR_Employees__Post_Code_;"Post Code")
            {
            }
            column(HR_Employees__Main_Bank_;"Main Bank")
            {
            }
            column(HR_Employees__Branch_Bank_;"Branch Bank")
            {
            }
            column(HR_Employees__Bank_Account_Number_;"Bank Account Number")
            {
            }
            column(HR_Employees__FullName;"HRM-Employee C".FullName)
            {
            }
            column(EmployeeCaption;EmployeeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Personal_Information_FormCaption;Personal_Information_FormCaptionLbl)
            {
            }
            column(Section_A__Personal_DetailsCaption;Section_A__Personal_DetailsCaptionLbl)
            {
            }
            column(HR_Employees__NHIF_No__Caption;FieldCaption("NHIF No."))
            {
            }
            column(HR_Employees__NSSF_No__Caption;FieldCaption("NSSF No."))
            {
            }
            column(HR_Employees__PIN_Number_Caption;FieldCaption("PIN Number"))
            {
            }
            column(HR_Employees__Marital_Status_Caption;FieldCaption("Marital Status"))
            {
            }
            column(HR_Employees__Date_Of_Birth_Caption;FieldCaption("Date Of Birth"))
            {
            }
            column(HR_Employees__ID_Number_Caption;FieldCaption("ID Number"))
            {
            }
            column(HR_Employees__Date_Of_Joining_the_Company_Caption;FieldCaption("Date Of Join"))
            {
            }
            column(HR_Employees__No__Caption;FieldCaption("No."))
            {
            }
            column(HR_Employees__Cell_Phone_Number_Caption;FieldCaption("Cellular Phone Number"))
            {
            }
            column(HR_Employees__Postal_Address_Caption;FieldCaption("Postal Address"))
            {
            }
            column(Section_B__ContactsCaption;Section_B__ContactsCaptionLbl)
            {
            }
            column(HR_Employees_CityCaption;FieldCaption(City))
            {
            }
            column(HR_Employees__Post_Code_Caption;FieldCaption("Post Code"))
            {
            }
            column(Section_C__Bank_Account_DetailsCaption;Section_C__Bank_Account_DetailsCaptionLbl)
            {
            }
            column(HR_Employees__Main_Bank_Caption;FieldCaption("Main Bank"))
            {
            }
            column(HR_Employees__Branch_Bank_Caption;FieldCaption("Branch Bank"))
            {
            }
            column(HR_Employees__Bank_Account_Number_Caption;FieldCaption("Bank Account Number"))
            {
            }
            column(PictureCaption;PictureCaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
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
            dataitem(UnknownTable61660;UnknownTable61660)
            {
                DataItemLink = "Employee No."=field("No.");
                DataItemTableView = sorting("Employee No.","Line No.");
                column(ReportForNavId_6659; 6659)
                {
                }
                column(HR_Employee_Qualifications__Qualification_Type_;"Qualification Type")
                {
                }
                column(HR_Employee_Qualifications__Qualification_Code_;"Qualification Code")
                {
                }
                column(HR_Employee_Qualifications__Qualification_Description_;"Qualification Description")
                {
                }
                column(Section_D__Academic_and_Professional_QualificationsCaption;Section_D__Academic_and_Professional_QualificationsCaptionLbl)
                {
                }
                column(HR_Employee_Qualifications__Qualification_Type_Caption;FieldCaption("Qualification Type"))
                {
                }
                column(HR_Employee_Qualifications__Qualification_Description_Caption;FieldCaption("Qualification Description"))
                {
                }
                column(Qualification_CodeCaption;Qualification_CodeCaptionLbl)
                {
                }
                column(HR_Employee_Qualifications_Employee_No_;"Employee No.")
                {
                }
                column(HR_Employee_Qualifications_Line_No_;"Line No.")
                {
                }
            }
            dataitem(UnknownTable61214;UnknownTable61214)
            {
                DataItemLink = "Employee No."=field("No.");
                DataItemTableView = sorting("Employee No.","Company Name") where("Company Name"=filter(<>""));
                PrintOnlyIfDetail = false;
                column(ReportForNavId_2273; 2273)
                {
                }
                column(HR_Employment_History__Company_Name_;"Company Name")
                {
                }
                column(HR_Employment_History_From;From)
                {
                }
                column(HR_Employment_History__To_Date_;"To Date")
                {
                }
                column(HR_Employment_History__Job_Title_;"Job Title")
                {
                }
                column(HR_Employment_History__Key_Experience_;"Key Experience")
                {
                }
                column(Section_E__Employment_HistoryCaption;Section_E__Employment_HistoryCaptionLbl)
                {
                }
                column(HR_Employment_History__Company_Name_Caption;FieldCaption("Company Name"))
                {
                }
                column(HR_Employment_History_FromCaption;FieldCaption(From))
                {
                }
                column(HR_Employment_History__To_Date_Caption;FieldCaption("To Date"))
                {
                }
                column(HR_Employment_History__Job_Title_Caption;FieldCaption("Job Title"))
                {
                }
                column(HR_Employment_History__Key_Experience_Caption;FieldCaption("Key Experience"))
                {
                }
                column(HR_Employment_History_Employee_No_;"Employee No.")
                {
                }
            }
            dataitem(UnknownTable61323;UnknownTable61323)
            {
                DataItemLink = "Employee Code"=field("No.");
                column(ReportForNavId_1102755046; 1102755046)
                {
                }
                column(HR_Employee_Kin_Relationship;"HRM-Employee Kin".Relationship)
                {
                }
                column(HR_Employee_Kin_SurName;"HRM-Employee Kin".SurName)
                {
                }
                column(HR_Employee_Kin_Other_Names;"HRM-Employee Kin"."Other Names")
                {
                }
                column(HR_Employee_Kin_Date_Of_Birth;"HRM-Employee Kin"."Date Of Birth")
                {
                }
                column(HR_Employee_Kin_ID_No_Passport_No;"HRM-Employee Kin"."ID No/Passport No")
                {
                }
                column(HR_Employee_KinHome_Tel_No;"HRM-Employee Kin"."Home Tel No")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                                           //"HR Employees".GET("HR Employees"."No.");
                                           "HRM-Employee C".CalcFields("HRM-Employee C".Picture);
            end;
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
        Personal_Information_FormCaptionLbl: label 'Personal Information Form';
        Section_A__Personal_DetailsCaptionLbl: label 'Section A: Personal Details';
        Section_B__ContactsCaptionLbl: label 'Section B: Contacts';
        Section_C__Bank_Account_DetailsCaptionLbl: label 'Section C: Bank Account Details';
        PictureCaptionLbl: label 'Picture';
        NamesCaptionLbl: label 'Names';
        Section_D__Academic_and_Professional_QualificationsCaptionLbl: label 'Section D: Academic and Professional Qualifications';
        Qualification_CodeCaptionLbl: label 'Qualification Code';
        Section_E__Employment_HistoryCaptionLbl: label 'Section E: Employment History';
}

