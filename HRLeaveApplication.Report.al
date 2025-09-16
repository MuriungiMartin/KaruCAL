#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51156 "HR Leave Application"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Leave Application.rdlc';

    dataset
    {
        dataitem(UnknownTable61125;UnknownTable61125)
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Document Number';
            column(ReportForNavId_1000000000; 1000000000)
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
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(EmployeeNo_HRLeaveApplication;"HRM-Leave Requisition"."Employee No")
            {
                IncludeCaption = true;
            }
            column(DaysApplied_HRLeaveApplication;"HRM-Leave Requisition"."Applied Days")
            {
                IncludeCaption = true;
            }
            column(ApplicationCode_HRLeaveApplication;"HRM-Leave Requisition"."No.")
            {
                IncludeCaption = true;
            }
            column(empName;"HRM-Leave Requisition"."Employee Name")
            {
                IncludeCaption = true;
            }
            column(AppliedDays;"HRM-Leave Requisition"."Applied Days")
            {
                IncludeCaption = true;
            }
            column(Reliever_HRLeaveApplication;"HRM-Leave Requisition"."Reliever No.")
            {
                IncludeCaption = true;
            }
            column(RelieverName_HRLeaveApplication;"HRM-Leave Requisition"."Reliever Name")
            {
                IncludeCaption = true;
            }
            column(StartDate_HRLeaveApplication;"HRM-Leave Requisition"."Starting Date")
            {
                IncludeCaption = true;
            }
            column(ReturnDate_HRLeaveApplication;"HRM-Leave Requisition"."Return Date")
            {
                IncludeCaption = true;
            }
            column(LeaveType_HRLeaveApplication;"HRM-Leave Requisition"."Leave Type")
            {
                IncludeCaption = true;
            }
            column(ApplicationDate_HRLeaveApplication;"HRM-Leave Requisition".Date)
            {
                IncludeCaption = true;
            }
            column(LEnd;"HRM-Leave Requisition"."End Date")
            {
            }
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Table ID","Document Type","Document No.","Sequence No.") order(ascending);
                column(ReportForNavId_1000000008; 1000000008)
                {
                }
                column(ApproverID_ApprovalEntry;"Approval Entry"."Approver ID")
                {
                    IncludeCaption = true;
                }
                dataitem("User Setup";"User Setup")
                {
                    DataItemLink = "User ID"=field("Approver ID");
                    DataItemTableView = sorting("User ID") order(ascending);
                    column(ReportForNavId_1000000009; 1000000009)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                      emp.Reset;
                      if emp.Get("HRM-Leave Requisition"."Employee No") then begin
                      end;
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
        CI.Get;
        CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        emp: Record UnknownRecord61188;
}

