#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5205 "Employee - Absences by Causes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Absences by Causes.rdlc';
    Caption = 'Employee - Absences by Causes';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Employee Absence";"Employee Absence")
        {
            DataItemTableView = sorting("Cause of Absence Code","From Date");
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
            column(Employee_Absence__TABLECAPTION__________EmployeeAbsenceFilter;TableCaption + ': ' + EmployeeAbsenceFilter)
            {
            }
            column(EmployeeAbsenceFilter;EmployeeAbsenceFilter)
            {
            }
            column(Employee_Absence_Description;Description)
            {
            }
            column(Employee_Absence__Cause_of_Absence_Code_;"Cause of Absence Code")
            {
            }
            column(Employee_Absence__From_Date_;Format("From Date"))
            {
            }
            column(Employee_Absence__To_Date_;Format("To Date"))
            {
            }
            column(Employee_Absence__Quantity__Base__;"Quantity (Base)")
            {
            }
            column(HumanResSetup__Base_Unit_of_Measure_;HumanResSetup."Base Unit of Measure")
            {
            }
            column(Employee_Absence__Employee_No__;"Employee No.")
            {
            }
            column(Employee_FullName;Employee.FullName)
            {
            }
            column(TotalAbsence;TotalAbsence)
            {
                DecimalPlaces = 0:2;
            }
            column(Employee___Absences_by_CausesCaption;Employee___Absences_by_CausesCaptionLbl)
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
            column(Employee_Absence__Employee_No__Caption;FieldCaption("Employee No."))
            {
            }
            column(Full_NameCaption;Full_NameCaptionLbl)
            {
            }
            column(Employee_Absence__Quantity__Base__Caption;FieldCaption("Quantity (Base)"))
            {
            }
            column(HumanResSetup__Base_Unit_of_Measure_Caption;HumanResSetup__Base_Unit_of_Measure_CaptionLbl)
            {
            }
            column(Total_AbsenceCaption;Total_AbsenceCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.Get("Employee No.");
                TotalAbsence := TotalAbsence + "Quantity (Base)";
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(TotalAbsence);
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
        EmployeeAbsenceFilter := "Employee Absence".GetFilters;
        HumanResSetup.Get;
        HumanResSetup.TestField("Base Unit of Measure");
    end;

    var
        Employee: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        EmployeeAbsenceFilter: Text;
        TotalAbsence: Decimal;
        Employee___Absences_by_CausesCaptionLbl: label 'Employee - Absences by Causes';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_Absence__From_Date_CaptionLbl: label 'From Date';
        Employee_Absence__To_Date_CaptionLbl: label 'To Date';
        Full_NameCaptionLbl: label 'Full Name';
        HumanResSetup__Base_Unit_of_Measure_CaptionLbl: label 'Base Unit of Measure';
        Total_AbsenceCaptionLbl: label 'Total Absence';
}

