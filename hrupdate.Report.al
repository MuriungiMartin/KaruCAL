#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51368 "hr update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/hr update.rdlc';

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

            trigger OnAfterGetRecord()
            begin
                "HRM-Employee C"."No.":=UpperCase("HRM-Employee C"."No.");
                "HRM-Employee C"."First Name":=UpperCase("HRM-Employee C"."First Name");
                "HRM-Employee C"."Middle Name":=UpperCase("HRM-Employee C"."Middle Name");
                "HRM-Employee C"."Last Name":=UpperCase("HRM-Employee C"."Last Name");
                "HRM-Employee C".Initials:=UpperCase("HRM-Employee C".Initials);
                "HRM-Employee C"."Search Name":=UpperCase("HRM-Employee C"."Search Name");
                "HRM-Employee C"."Postal Address":=UpperCase("HRM-Employee C"."Postal Address");
                "HRM-Employee C"."Residential Address":=UpperCase("HRM-Employee C"."Residential Address");
                "HRM-Employee C".City:=UpperCase("HRM-Employee C".City);
                "HRM-Employee C"."Post Code":=UpperCase("HRM-Employee C"."Post Code");
                "HRM-Employee C".County:=UpperCase("HRM-Employee C".County);
                "HRM-Employee C".Citizenship:=UpperCase("HRM-Employee C".Citizenship);
                "HRM-Employee C".Modify
                //if strlen("HR Employee"."No.")=
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

    var
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

