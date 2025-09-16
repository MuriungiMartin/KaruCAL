#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5206 "Employee - Qualifications"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Qualifications.rdlc';
    Caption = 'Employee - Qualifications';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Employee Qualification";"Employee Qualification")
        {
            DataItemTableView = sorting("Employee No.","Line No.");
            RequestFilterFields = "Employee No.","Qualification Code";
            column(ReportForNavId_6340; 6340)
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
            column(Employee_Qualification__TABLECAPTION__________EmployeeQualificationFilter;TableCaption + ': ' + EmployeeQualificationFilter)
            {
            }
            column(EmployeeQualificationFilter;EmployeeQualificationFilter)
            {
            }
            column(Employee_Qualification__Employee_No__;"Employee No.")
            {
            }
            column(Employee_FullName;Employee.FullName)
            {
            }
            column(Employee_Qualification__Qualification_Code_;"Qualification Code")
            {
            }
            column(Employee_Qualification__From_Date_;Format("From Date"))
            {
            }
            column(Employee_Qualification__To_Date_;Format("To Date"))
            {
            }
            column(Employee_Qualification_Type;Type)
            {
            }
            column(Employee_Qualification_Description;Description)
            {
            }
            column(Employee_Qualification__Institution_Company_;"Institution/Company")
            {
            }
            column(Employee___QualificationsCaption;Employee___QualificationsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Qualification__Institution_Company_Caption;FieldCaption("Institution/Company"))
            {
            }
            column(Employee_Qualification_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Employee_Qualification_TypeCaption;FieldCaption(Type))
            {
            }
            column(Employee_Qualification__To_Date_Caption;Employee_Qualification__To_Date_CaptionLbl)
            {
            }
            column(Employee_Qualification__From_Date_Caption;Employee_Qualification__From_Date_CaptionLbl)
            {
            }
            column(Employee_Qualification__Qualification_Code_Caption;FieldCaption("Qualification Code"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.Get("Employee No.");
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
        EmployeeQualificationFilter := "Employee Qualification".GetFilters;
    end;

    var
        Employee: Record Employee;
        EmployeeQualificationFilter: Text;
        Employee___QualificationsCaptionLbl: label 'Employee - Qualifications';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_Qualification__To_Date_CaptionLbl: label 'To Date';
        Employee_Qualification__From_Date_CaptionLbl: label 'From Date';
}

