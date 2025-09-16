#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51448 "Leave Applications"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Leave Applications.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_3372; 3372)
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
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(HR_Employee_C__Middle_Name_;"Middle Name")
            {
            }
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(EmployeeCaption;EmployeeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Employee_C__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(HR_Employee_C__Middle_Name_Caption;FieldCaption("Middle Name"))
            {
            }
            column(HR_Employee_C__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(HR_Employee_C__No__Caption;FieldCaption("No."))
            {
            }
            column(Employee_Leave_Application__Application_Code_Caption;"HRM-Emp. Leave Application".FieldCaption("Application Code"))
            {
            }
            column(Employee_Leave_Application__Approval_Date_Caption;"HRM-Emp. Leave Application".FieldCaption("Approval Date"))
            {
            }
            column(Employee_Leave_Application__Approved_End_Date_Caption;"HRM-Emp. Leave Application".FieldCaption("Approved End Date"))
            {
            }
            column(Employee_Leave_Application_StatusCaption;"HRM-Emp. Leave Application".FieldCaption(Status))
            {
            }
            column(Employee_Leave_Application__Verification_Date_Caption;"HRM-Emp. Leave Application".FieldCaption("Verification Date"))
            {
            }
            column(Employee_Leave_Application__Verified_By_Manager_Caption;"HRM-Emp. Leave Application".FieldCaption("Verified By Manager"))
            {
            }
            column(Employee_Leave_Application__Approved_Start_Date_Caption;"HRM-Emp. Leave Application".FieldCaption("Approved Start Date"))
            {
            }
            column(Employee_Leave_Application__Approved_Days_Caption;"HRM-Emp. Leave Application".FieldCaption("Approved Days"))
            {
            }
            column(Employee_Leave_Application__Application_Date_Caption;"HRM-Emp. Leave Application".FieldCaption("Application Date"))
            {
            }
            column(Employee_Leave_Application__End_Date_Caption;"HRM-Emp. Leave Application".FieldCaption("End Date"))
            {
            }
            column(Employee_Leave_Application__Start_Date_Caption;"HRM-Emp. Leave Application".FieldCaption("Start Date"))
            {
            }
            column(Employee_Leave_Application__Days_Applied_Caption;"HRM-Emp. Leave Application".FieldCaption("Days Applied"))
            {
            }
            column(LeaveCaption;LeaveCaptionLbl)
            {
            }
            column(CommentCaption;CommentCaptionLbl)
            {
            }
            dataitem(UnknownTable61282;UnknownTable61282)
            {
                DataItemLink = "Employee No"=field("No.");
                column(ReportForNavId_8337; 8337)
                {
                }
                column(Employee_Leave_Application__Application_Code_;"Application Code")
                {
                }
                column(Employee_Leave_Application__Leave_Code_;"Leave Code")
                {
                }
                column(Employee_Leave_Application__Days_Applied_;"Days Applied")
                {
                }
                column(Employee_Leave_Application__Start_Date_;"Start Date")
                {
                }
                column(Employee_Leave_Application__End_Date_;"End Date")
                {
                }
                column(Employee_Leave_Application__Application_Date_;"Application Date")
                {
                }
                column(Employee_Leave_Application__Approved_Days_;"Approved Days")
                {
                }
                column(Employee_Leave_Application__Approved_Start_Date_;"Approved Start Date")
                {
                }
                column(Employee_Leave_Application__Verified_By_Manager_;"Verified By Manager")
                {
                }
                column(Employee_Leave_Application__Verification_Date_;"Verification Date")
                {
                }
                column(Employee_Leave_Application_Status;Status)
                {
                }
                column(Employee_Leave_Application__Approved_End_Date_;"Approved End Date")
                {
                }
                column(Employee_Leave_Application__Approval_Date_;"Approval Date")
                {
                }
                column(Employee_Leave_Application_Comments;Comments)
                {
                }
                column(Employee_Leave_Application_Employee_No;"Employee No")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        LeaveCaptionLbl: label 'Leave';
        CommentCaptionLbl: label 'Comment';
}

