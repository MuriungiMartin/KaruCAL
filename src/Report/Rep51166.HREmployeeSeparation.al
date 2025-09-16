#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51166 "HR Employee Separation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Employee Separation.rdlc';

    dataset
    {
        dataitem(UnknownTable61215;UnknownTable61215)
        {
            RequestFilterFields = "Employee No.","Directorate Name","Department Name","Station Name","Exit Clearance No";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(ExitClearanceNo_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Exit Clearance No")
            {
            }
            column(DateOfClearance_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Date Of Clearance")
            {
            }
            column(ClearanceRequester_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Clearance Requester")
            {
            }
            column(ReEmployInFuture_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Re Employ In Future")
            {
            }
            column(NatureOfSeparation_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Nature Of Separation")
            {
            }
            column(ReasonForLeavingOther_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Reason For Leaving (Other)")
            {
            }
            column(DateOfLeaving_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Date Of Leaving")
            {
            }
            column(DirectorateCode_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Directorate Code")
            {
            }
            column(DepartmentCode_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Department Code")
            {
            }
            column(Comment_HREmployeeExitInterviews;"HRM-Employee Exit Interviews".Comment)
            {
            }
            column(EmployeeNo_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Employee No.")
            {
            }
            column(NoSeries_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."No Series")
            {
            }
            column(FormSubmitted_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Form Submitted")
            {
            }
            column(EmployeeName_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Employee Name")
            {
            }
            column(ClearerName_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Clearer Name")
            {
            }
            column(Status_HREmployeeExitInterviews;"HRM-Employee Exit Interviews".Status)
            {
            }
            column(ResponsibilityCenter_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Responsibility Center")
            {
            }
            column(StationCode_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Station Code")
            {
            }
            column(StationName_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Station Name")
            {
            }
            column(DirectorateName_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Directorate Name")
            {
            }
            column(DepartmentName_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Department Name")
            {
            }
            column(DepartmentFilter_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Department Filter")
            {
            }
            column(StationFilter_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Station Filter")
            {
            }
            column(DirectorateFilter_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Directorate Filter")
            {
            }
            column(EmployeeType_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Employee Type")
            {
            }
            column(AppointmentDate_HREmployeeExitInterviews;"HRM-Employee Exit Interviews"."Appointment Date")
            {
            }
            column(Company_Name;CompanyInfo.Name)
            {
            }
            column(Company_Picture;CompanyInfo.Picture)
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

    var
        CompanyInfo: Record "Company Information";
        ExitInterview: Record UnknownRecord61101;
}

