#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51720 "HR Leave Application (1)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Leave Application (1).rdlc';

    dataset
    {
        dataitem(UnknownTable61125;UnknownTable61125)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Employee No";
            column(ReportForNavId_9741; 9741)
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
            column(USERID;UserId)
            {
            }
            column(HR_Leave_Requisition__No__;"No.")
            {
            }
            column(HR_Leave_Requisition_Date;Date)
            {
            }
            column(HR_Leave_Requisition__Employee_No_;"Employee No")
            {
            }
            column(HR_Leave_Requisition__Employee_Name_;"Employee Name")
            {
            }
            column(HR_Leave_Requisition__Campus_Code_;"Campus Code")
            {
            }
            column(HR_Leave_Requisition__Department_Code_;"Department Code")
            {
            }
            column(HR_Leave_Requisition__Applied_Days_;"Applied Days")
            {
            }
            column(HR_Leave_Requisition__Starting_Date_;"Starting Date")
            {
            }
            column(HR_Leave_Requisition__End_Date_;"End Date")
            {
            }
            column(HR_Leave_Requisition_Purpose;Purpose)
            {
            }
            column(HR_Leave_Requisition__Leave_Type_;"Leave Type")
            {
            }
            column(HR_Leave_Requisition__Leave_Balance_;"Leave Balance")
            {
            }
            column(HR_Leave_Requisition_Status;Status)
            {
            }
            column(LEAVE_APPLICATIONCaption;LEAVE_APPLICATIONCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Leave_Requisition__No__Caption;FieldCaption("No."))
            {
            }
            column(HR_Leave_Requisition_DateCaption;FieldCaption(Date))
            {
            }
            column(HR_Leave_Requisition__Employee_No_Caption;FieldCaption("Employee No"))
            {
            }
            column(HR_Leave_Requisition__Campus_Code_Caption;FieldCaption("Campus Code"))
            {
            }
            column(HR_Leave_Requisition__Department_Code_Caption;FieldCaption("Department Code"))
            {
            }
            column(HR_Leave_Requisition__Applied_Days_Caption;FieldCaption("Applied Days"))
            {
            }
            column(HR_Leave_Requisition__Starting_Date_Caption;FieldCaption("Starting Date"))
            {
            }
            column(HR_Leave_Requisition__End_Date_Caption;FieldCaption("End Date"))
            {
            }
            column(HR_Leave_Requisition_PurposeCaption;FieldCaption(Purpose))
            {
            }
            column(HR_Leave_Requisition__Leave_Type_Caption;FieldCaption("Leave Type"))
            {
            }
            column(HR_Leave_Requisition__Leave_Balance_Caption;FieldCaption("Leave Balance"))
            {
            }
            column(HR_Leave_Requisition_StatusCaption;FieldCaption(Status))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Table ID","Document Type","Document No.","Sequence No.") order(ascending);
                column(ReportForNavId_1171; 1171)
                {
                }
                column(Approval_Entry__Approver_ID_;"Approver ID")
                {
                }
                column(Approval_Entry_Status;Status)
                {
                }
                column(Approval_Entry__Last_Date_Time_Modified_;"Last Date-Time Modified")
                {
                }
                column(APPROVALSCaption;APPROVALSCaptionLbl)
                {
                }
                column(APPROVER_IDCaption;APPROVER_IDCaptionLbl)
                {
                }
                column(APPROVAL_DATECaption;APPROVAL_DATECaptionLbl)
                {
                }
                column(APPROVAL_ACTIONCaption;APPROVAL_ACTIONCaptionLbl)
                {
                }
                column(Approval_Entry_Table_ID;"Table ID")
                {
                }
                column(Approval_Entry_Document_Type;"Document Type")
                {
                }
                column(Approval_Entry_Document_No_;"Document No.")
                {
                }
                column(Approval_Entry_Sequence_No_;"Sequence No.")
                {
                }

                trigger OnPreDataItem()
                begin
                       "Approval Entry".SetFilter("Approval Entry"."Approver ID",'<>%1',"HRM-Leave Requisition"."User ID");
                end;
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
        LEAVE_APPLICATIONCaptionLbl: label 'LEAVE APPLICATION';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
        APPROVALSCaptionLbl: label 'APPROVALS';
        APPROVER_IDCaptionLbl: label 'APPROVER ID';
        APPROVAL_DATECaptionLbl: label 'APPROVAL DATE';
        APPROVAL_ACTIONCaptionLbl: label 'APPROVAL ACTION';
}

