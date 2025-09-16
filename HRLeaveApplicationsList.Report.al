#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51181 "HR Leave Applications List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Leave Applications List.rdlc';

    dataset
    {
        dataitem(UnknownTable61125;UnknownTable61125)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_3725; 3725)
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
            column(HR_Leave_Application__Application_Code_;"HRM-Leave Requisition"."No.")
            {
            }
            column(HR_Leave_Application__Application_Date_;"HRM-Leave Requisition".Date)
            {
            }
            column(HR_Leave_Application__Employee_No_;"HRM-Leave Requisition"."Employee No")
            {
            }
            column(HR_Leave_Application__Job_Tittle_;'')
            {
            }
            column(HR_Leave_Application_Supervisor;'')
            {
            }
            column(HR_Leave_Application__Leave_Type_;"HRM-Leave Requisition"."Leave Type")
            {
            }
            column(HR_Leave_Application__Days_Applied_;"HRM-Leave Requisition"."Applied Days")
            {
            }
            column(HR_Leave_Application__Start_Date_;"HRM-Leave Requisition"."Starting Date")
            {
            }
            column(HR_Leave_Application__Return_Date_;"HRM-Leave Requisition"."Return Date")
            {
            }
            column(HR_Leave_Application_Reliever;"HRM-Leave Requisition"."Reliever No.")
            {
            }
            column(HR_Leave_Application__Reliever_Name_;"HRM-Leave Requisition"."Reliever Name")
            {
            }
            column(HR_Leave_ApplicationCaption;HR_Leave_ApplicationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Leave_Application__Application_Code_Caption;'Application No.:')
            {
            }
            column(HR_Leave_Application__Application_Date_Caption;'Application Date')
            {
            }
            column(HR_Leave_Application__Employee_No_Caption;'Emp. No.')
            {
            }
            column(HR_Leave_Application__Job_Tittle_Caption;'')
            {
            }
            column(HR_Leave_Application_SupervisorCaption;'')
            {
            }
            column(HR_Leave_Application__Leave_Type_Caption;'Leave Type')
            {
            }
            column(HR_Leave_Application__Days_Applied_Caption;'Applied Days')
            {
            }
            column(HR_Leave_Application__Start_Date_Caption;'Start Date')
            {
            }
            column(HR_Leave_Application__Return_Date_Caption;'Return Date')
            {
            }
            column(HR_Leave_Application_RelieverCaption;'Reliever No.')
            {
            }
            column(HR_Leave_Application__Reliever_Name_Caption;'Reliever Name:')
            {
            }
            column(Picture;CI.Picture)
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
        CI.Get;
        CI.CalcFields(CI.Picture);
    end;

    var
        HR_Leave_ApplicationCaptionLbl: label 'HR Leave Application';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CI: Record "Company Information";
}

