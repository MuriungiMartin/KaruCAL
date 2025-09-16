#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51242 "HR Appraisal Reports"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Appraisal Reports.rdlc';

    dataset
    {
        dataitem(UnknownTable61232;UnknownTable61232)
        {
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(AppraisalStage_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H"."Appraisal Stage")
            {
            }
            column(JobTitle_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H"."Job Title")
            {
            }
            column(EmployeeNo_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H"."Employee No")
            {
            }
            column(EmployeeName_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H"."Employee Name")
            {
            }
            column(AppraisalNo_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H"."Appraisal No")
            {
            }
            column(Supervisor_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H".Supervisor)
            {
            }
            column(AppraisalType_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H"."Appraisal Type")
            {
            }
            column(Sent_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H".Sent)
            {
            }
            column(AppraisalPeriod_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H"."Appraisal Period")
            {
            }
            column(Status_HRAppraisalGoalSettingH;"HRM-Appraisal Goal Setting H".Status)
            {
            }
            dataitem(UnknownTable61233;UnknownTable61233)
            {
                DataItemLink = "Appraisal No"=field("Appraisal No");
                column(ReportForNavId_1102755011; 1102755011)
                {
                }
                column(MsrmentCriteriaTargetDate_HRAppraisalGoalSettingL;"HRM-Appraisal Goal Setting L"."Criteria/Target Date")
                {
                }
                column(PlannedTargetsObjectives_HRAppraisalGoalSettingL;"HRM-Appraisal Goal Setting L"."Planned Targets/Objectives")
                {
                }
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
}

