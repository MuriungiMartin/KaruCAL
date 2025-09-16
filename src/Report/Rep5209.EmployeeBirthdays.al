#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5209 "Employee - Birthdays"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Birthdays.rdlc';
    Caption = 'Employee - Birthdays';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Global Dimension 1 Code","Global Dimension 2 Code";
            column(ReportForNavId_7528; 7528)
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
            column(Employee_TABLECAPTION__________EmployeeFilter;TableCaption + ': ' + EmployeeFilter)
            {
            }
            column(EmployeeFilter;EmployeeFilter)
            {
            }
            column(Employee__No__;"No.")
            {
            }
            column(FullName;FullName)
            {
            }
            column(Employee__Birth_Date_;Format("Birth Date"))
            {
            }
            column(Employee___BirthdaysCaption;Employee___BirthdaysCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee__No__Caption;FieldCaption("No."))
            {
            }
            column(Full_NameCaption;Full_NameCaptionLbl)
            {
            }
            column(Employee__Birth_Date_Caption;Employee__Birth_Date_CaptionLbl)
            {
            }
        }
    }

    requestpage
    {
        Caption = 'Employee - Birthdays';

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
        EmployeeFilter := o.GetFilters;
    end;

    var
        EmployeeFilter: Text;
        Employee___BirthdaysCaptionLbl: label 'Employee - Birthdays';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Full_NameCaptionLbl: label 'Full Name';
        Employee__Birth_Date_CaptionLbl: label 'Birth Date';
}

