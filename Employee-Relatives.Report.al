#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5208 "Employee - Relatives"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Relatives.rdlc';
    Caption = 'Employee - Relatives';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Employee Relative";"Employee Relative")
        {
            DataItemTableView = sorting("Employee No.","Line No.");
            RequestFilterFields = "Employee No.","Relative Code";
            column(ReportForNavId_6239; 6239)
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
            column(Employee_Relative__TABLECAPTION__________RelativeFilter;TableCaption + ': ' + RelativeFilter)
            {
            }
            column(RelativeFilter;RelativeFilter)
            {
            }
            column(Employee_Relative__Employee_No__;"Employee No.")
            {
            }
            column(Employee_FullName;Employee.FullName)
            {
            }
            column(Employee_Relative__Relative_Code_;"Relative Code")
            {
            }
            column(Employee_Relative__First_Name_;"First Name")
            {
            }
            column(Employee_Relative__Last_Name_;"Last Name")
            {
            }
            column(Employee_Relative__Birth_Date_;Format("Birth Date"))
            {
            }
            column(Employee___RelativesCaption;Employee___RelativesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Relative__Birth_Date_Caption;Employee_Relative__Birth_Date_CaptionLbl)
            {
            }
            column(Employee_Relative__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(Employee_Relative__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(Employee_Relative__Relative_Code_Caption;FieldCaption("Relative Code"))
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
        RelativeFilter := "Employee Relative".GetFilters;
    end;

    var
        Employee: Record Employee;
        RelativeFilter: Text;
        Employee___RelativesCaptionLbl: label 'Employee - Relatives';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_Relative__Birth_Date_CaptionLbl: label 'Birth Date';
}

