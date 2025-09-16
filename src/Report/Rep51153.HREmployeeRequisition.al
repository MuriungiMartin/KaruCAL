#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51153 "HR Employee Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Employee Requisition.rdlc';

    dataset
    {
        dataitem(UnknownTable61200;UnknownTable61200)
        {
            PrintOnlyIfDetail = false;
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(RequisitionNo_HREmployeeRequisitions;"HRM-Employee Requisitions"."Requisition No.")
            {
                IncludeCaption = true;
            }
            column(JobDescription_HREmployeeRequisitions;"HRM-Employee Requisitions"."Job Description")
            {
                IncludeCaption = true;
            }
            column(JobGrade_HREmployeeRequisitions;"HRM-Employee Requisitions"."Job Grade")
            {
                IncludeCaption = true;
            }
            column(GlobalDimension2Code_HREmployeeRequisitions;"HRM-Employee Requisitions"."Global Dimension 2 Code")
            {
                IncludeCaption = true;
            }
            column(ReasonforRequestOther_HREmployeeRequisitions;"HRM-Employee Requisitions"."Reason for Request(Other)")
            {
                IncludeCaption = true;
            }
            column(ReasonForRequest_HREmployeeRequisitions;"HRM-Employee Requisitions"."Reason For Request")
            {
                IncludeCaption = true;
            }
            column(TypeofContractRequired_HREmployeeRequisitions;"HRM-Employee Requisitions"."Type of Contract Required")
            {
                IncludeCaption = true;
            }
            column(AnyAdditionalInformation_HREmployeeRequisitions;"HRM-Employee Requisitions"."Any Additional Information")
            {
                IncludeCaption = true;
            }
            column(RequisitionDate_HREmployeeRequisitions;"HRM-Employee Requisitions"."Requisition Date")
            {
                IncludeCaption = true;
            }
            column(JobSupervisorManager_HREmployeeRequisitions;"HRM-Employee Requisitions"."Job Supervisor/Manager")
            {
                IncludeCaption = true;
            }
            column(CI_Picture;CI.Picture)
            {
                IncludeCaption = true;
            }
            column(CI_Name;CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address;CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2;CI."Address 2")
            {
                IncludeCaption = true;
            }
            column(CI_City;CI.City)
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
                IncludeCaption = true;
            }
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("Requisition No.");
                DataItemTableView = sorting("Table ID","Document Type","Document No.","Sequence No.") order(ascending) where(Status=const(Approved));
                column(ReportForNavId_1102755001; 1102755001)
                {
                }
                column(Comment_ApprovalEntry;"Approval Entry".Comment)
                {
                    IncludeCaption = true;
                }
                column(ApproverID_ApprovalEntry;"Approval Entry"."Approver ID")
                {
                    IncludeCaption = true;
                }
                column(DateTimeSentforApproval_ApprovalEntry;"Approval Entry"."Date-Time Sent for Approval")
                {
                    IncludeCaption = true;
                }
                column(SenderID_ApprovalEntry;"Approval Entry"."Sender ID")
                {
                    IncludeCaption = true;
                }
                column(LastDateTimeModified_ApprovalEntry;"Approval Entry"."Last Date-Time Modified")
                {
                }
                column(LastModifiedByID_ApprovalEntry;"Approval Entry"."Last Modified By ID")
                {
                }
                dataitem("User Setup";"User Setup")
                {
                    DataItemLink = "User ID"=field("Approver ID");
                    DataItemTableView = sorting("User ID") order(ascending);
                    column(ReportForNavId_1102755002; 1102755002)
                    {
                    }
                    column(UserID_UserSetup;"User Setup"."User ID")
                    {
                        IncludeCaption = true;
                    }
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

    trigger OnPreReport()
    begin
                         CI.Reset;
                         CI.Get();
                         CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
}

