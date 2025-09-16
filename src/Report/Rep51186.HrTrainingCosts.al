#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51186 "Hr Training Costs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hr Training Costs.rdlc';

    dataset
    {
        dataitem(UnknownTable61216;UnknownTable61216)
        {
            PrintOnlyIfDetail = false;
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(EmployeeNo_HRTrainingApplications;"HRM-Training Applications"."Employee No.")
            {
            }
            column(EmployeeName_HRTrainingApplications;"HRM-Training Applications"."Employee Name")
            {
            }
            column(DurationUnits_HRTrainingApplications;"HRM-Training Applications"."Duration Units")
            {
            }
            column(Duration_HRTrainingApplications;"HRM-Training Applications".Duration)
            {
            }
            column(FromDate_HRTrainingApplications;"HRM-Training Applications"."From Date")
            {
            }
            column(ToDate_HRTrainingApplications;"HRM-Training Applications"."To Date")
            {
            }
            column(Provider_HRTrainingApplications;"HRM-Training Applications".Trainer)
            {
            }
            column(ProviderName_HRTrainingApplications;"HRM-Training Applications"."Training Institution")
            {
            }
            column(Directorate_HRTrainingApplications;"HRM-Training Applications".Directorate)
            {
            }
            column(Department_HRTrainingApplications;"HRM-Training Applications".Department)
            {
            }
            column(Station_HRTrainingApplications;"HRM-Training Applications".Station)
            {
            }
            column(PeriodFilter_HRTrainingApplications;"HRM-Training Applications"."Period Filter")
            {
            }
            column(DepartmentName_HRTrainingApplications;"HRM-Training Applications"."Department Name")
            {
            }
            column(StationName_HRTrainingApplications;"HRM-Training Applications"."Station Name")
            {
            }
            column(DirectorateName_HRTrainingApplications;"HRM-Training Applications"."Directorate Name")
            {
            }
            column(QuarterOffered_HRTrainingApplications;"HRM-Training Applications"."Quarter Offered")
            {
            }
            column(TrainingEvaluationResults_HRTrainingApplications;"HRM-Training Applications"."Training Evaluation Results")
            {
            }
            column(Description_HRTrainingApplications;"HRM-Training Applications".Description)
            {
            }
            column(Location_HRTrainingApplications;"HRM-Training Applications".Location)
            {
            }
            column(CostOfTraining_HRTrainingApplications;"HRM-Training Applications"."Cost Of Training")
            {
            }
            column(CI_Picture;CI.Picture)
            {
            }
            column(CI_Address;CI.Address)
            {
            }
            column(CI__Address_2______CI__Post_Code_;CI."Address 2"+' '+CI."Post Code")
            {
            }
            column(CI_City;CI.City)
            {
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
            }
            column(CI_Name;CI.Name)
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
        CI.Reset;
        CI.Get();
        CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        TotTrainingCost: Decimal;
}

