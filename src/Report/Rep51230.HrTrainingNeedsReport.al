#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51230 "Hr Training Needs Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hr Training Needs Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61242;UnknownTable61242)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Code_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Code)
            {
            }
            column(Description_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Description)
            {
            }
            column(ProposedStartDate_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Proposed Start Date")
            {
            }
            column(ProposedEndDate_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Proposed End Date")
            {
            }
            column(DurationUnits_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Duration Units")
            {
            }
            column(Duration_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Duration)
            {
            }
            column(CostOfTraining_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Cost Of Training")
            {
            }
            column(Location_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Location)
            {
            }
            column(NeedSource_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Need Source")
            {
            }
            column(Directorate_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Directorate)
            {
            }
            column(Department_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Department)
            {
            }
            column(Closed_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Closed)
            {
            }
            column(QualificationCode_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Qualification Code")
            {
            }
            column(QualificationType_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Qualification Type")
            {
            }
            column(QualificationDescription_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Qualification Description")
            {
            }
            column(TrainingApplicants_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Training Applicants")
            {
            }
            column(TrainingApplicantsPassed_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Training Applicants (Passed)")
            {
            }
            column(TrainingApplicantsFailed_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Training Applicants (Failed)")
            {
            }
            column(NoofRequiredParticipants_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."No of Required Participants")
            {
            }
            column(NatureofTraining_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Nature of Training")
            {
            }
            column(TrainingType_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Training Type")
            {
            }
            column(CourseVersion_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Course Version")
            {
            }
            column(CourseVersionDescription_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Course Version Description")
            {
            }
            column(IndividualCourse_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Individual Course")
            {
            }
            column(Status_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Status)
            {
            }
            column(QuarterOffered_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Quarter Offered")
            {
            }
            column(ApplicationDate_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Application Date")
            {
            }
            column(UserID_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."User ID")
            {
            }
            column(Trainingcategory_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Training category")
            {
            }
            column(NoofParticipants_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."No of Participants")
            {
            }
            column(DirectorateName_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Directorate Name")
            {
            }
            column(DepartmentName_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Department Name")
            {
            }
            column(EmployeeName_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Employee Name")
            {
            }
            column(Station_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis".Station)
            {
            }
            column(CourseCode_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Course Code")
            {
            }
            column(TrainingStatus_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Training Status")
            {
            }
            column(TableID_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Table ID")
            {
            }
            column(EmployeeNo_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Employee No.")
            {
            }
            column(StationName_HRTrainingNeedsAnalysis;"HRM-Training Needs Analysis"."Station Name")
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
            column(HR_Jobs_UserID;UserId)
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

