#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51870 "Leave Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Leave Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61125;UnknownTable61125)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Log;comp.Picture)
            {
            }
            column(CompName;comp.Name)
            {
            }
            column(No_HRMLeaveRequisition;"HRM-Leave Requisition"."No.")
            {
            }
            column(Date_HRMLeaveRequisition;"HRM-Leave Requisition".Date)
            {
            }
            column(EmployeeNo_HRMLeaveRequisition;"HRM-Leave Requisition"."Employee No")
            {
            }
            column(EmployeeName_HRMLeaveRequisition;"HRM-Leave Requisition"."Employee Name")
            {
            }
            column(CampusCode_HRMLeaveRequisition;"HRM-Leave Requisition"."Campus Code")
            {
            }
            column(DepartmentCode_HRMLeaveRequisition;"HRM-Leave Requisition"."Department Code")
            {
            }
            column(AppliedDays_HRMLeaveRequisition;"HRM-Leave Requisition"."Applied Days")
            {
            }
            column(StartingDate_HRMLeaveRequisition;"HRM-Leave Requisition"."Starting Date")
            {
            }
            column(EndDate_HRMLeaveRequisition;"HRM-Leave Requisition"."End Date")
            {
            }
            column(Purpose_HRMLeaveRequisition;"HRM-Leave Requisition".Purpose)
            {
            }
            column(LeaveType_HRMLeaveRequisition;"HRM-Leave Requisition"."Leave Type")
            {
            }
            column(LeaveBalance_HRMLeaveRequisition;"HRM-Leave Requisition"."Leave Balance")
            {
            }
            column(NoSeries_HRMLeaveRequisition;"HRM-Leave Requisition"."No. Series")
            {
            }
            column(Status_HRMLeaveRequisition;"HRM-Leave Requisition".Status)
            {
            }
            column(UserID_HRMLeaveRequisition;"HRM-Leave Requisition"."User ID")
            {
            }
            column(ResponsibilityCenter_HRMLeaveRequisition;"HRM-Leave Requisition"."Responsibility Center")
            {
            }
            column(Posted_HRMLeaveRequisition;"HRM-Leave Requisition".Posted)
            {
            }
            column(PostedBy_HRMLeaveRequisition;"HRM-Leave Requisition"."Posted By")
            {
            }
            column(PostingDate_HRMLeaveRequisition;"HRM-Leave Requisition"."Posting Date")
            {
            }
            column(ProcessLeaveAllowance_HRMLeaveRequisition;"HRM-Leave Requisition"."Process Leave Allowance")
            {
            }
            column(AvaillableDays_HRMLeaveRequisition;"HRM-Leave Requisition"."Availlable Days")
            {
            }
            column(ReturnDate_HRMLeaveRequisition;"HRM-Leave Requisition"."Return Date")
            {
            }
            column(RelieverNo_HRMLeaveRequisition;"HRM-Leave Requisition"."Reliever No.")
            {
            }
            column(RelieverName_HRMLeaveRequisition;"HRM-Leave Requisition"."Reliever Name")
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

    trigger OnInitReport()
    begin
        comp.Reset;
        if comp.FindFirst then begin
          comp.CalcFields(Picture);
        end
    end;

    var
        comp: Record "Company Information";
}

