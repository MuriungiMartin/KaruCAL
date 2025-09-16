#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5204 "Employee - Staff Absences"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Staff Absences.rdlc';
    Caption = 'Employee - Staff Absences';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Employee Absence";"Employee Absence")
        {
            DataItemTableView = sorting("Employee No.","From Date");
            RequestFilterFields = "Employee No.","From Date","Cause of Absence Code";
            column(ReportForNavId_6328; 6328)
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
            column(Employee_Absence__TABLECAPTION__________AbsenceFilter;TableCaption + ': ' + AbsenceFilter)
            {
            }
            column(AbsenceFilter;AbsenceFilter)
            {
            }
            column(Employee_Absence__Employee_No__;"Employee No.")
            {
            }
            column(Employee_FullName;Employee.FullName)
            {
            }
            column(Employee_Absence__From_Date_;Format("From Date"))
            {
            }
            column(Employee_Absence__To_Date_;Format("To Date"))
            {
            }
            column(Employee_Absence__Cause_of_Absence_Code_;"Cause of Absence Code")
            {
            }
            column(Employee_Absence_Description;Description)
            {
            }
            column(Employee_Absence_Quantity;Quantity)
            {
            }
            column(Employee_Absence__Unit_of_Measure_Code_;"Unit of Measure Code")
            {
            }
            column(Employee___Staff_AbsencesCaption;Employee___Staff_AbsencesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Absence__From_Date_Caption;Employee_Absence__From_Date_CaptionLbl)
            {
            }
            column(Employee_Absence__To_Date_Caption;Employee_Absence__To_Date_CaptionLbl)
            {
            }
            column(Employee_Absence__Cause_of_Absence_Code_Caption;FieldCaption("Cause of Absence Code"))
            {
            }
            column(Employee_Absence_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Employee_Absence_QuantityCaption;FieldCaption(Quantity))
            {
            }
            column(Employee_Absence__Unit_of_Measure_Code_Caption;FieldCaption("Unit of Measure Code"))
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
        AbsenceFilter := "Employee Absence".GetFilters;
    end;

    var
        Employee: Record Employee;
        AbsenceFilter: Text;
        Employee___Staff_AbsencesCaptionLbl: label 'Employee - Staff Absences';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_Absence__From_Date_CaptionLbl: label 'From Date';
        Employee_Absence__To_Date_CaptionLbl: label 'To Date';
}

