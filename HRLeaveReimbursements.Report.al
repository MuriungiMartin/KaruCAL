#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51178 "HR Leave Reimbursements"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Leave Reimbursements.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            RequestFilterFields = "No.","Leave Period Filter";
            column(ReportForNavId_6075; 6075)
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
            column(CI_Picture;CI.Picture)
            {
            }
            column(CI_City;CI.City)
            {
            }
            column(CI__Address_2______CI__Post_Code_;CI."Address 2"+' '+CI."Post Code")
            {
            }
            column(CI_Address;CI.Address)
            {
            }
            column(HR_Employees__No__;"No.")
            {
            }
            column(HR_Employees__FullName;"HRM-Employee C".FullName)
            {
            }
            column(EmployeeCaption;EmployeeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Leave_Reimbursement_ReportCaption;Employee_Leave_Reimbursement_ReportCaptionLbl)
            {
            }
            column(P_O__BoxCaption;P_O__BoxCaptionLbl)
            {
            }
            column(HR_Employees__No__Caption;FieldCaption("No."))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            dataitem(UnknownTable61659;UnknownTable61659)
            {
                DataItemLink = "Employee No"=field("No.");
                column(ReportForNavId_4961; 4961)
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Period_;"Leave Period")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Entry_Type_;"HRM-Leave Ledger"."Entry Type")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Type_;"Leave Type")
                {
                }
                column(HR_Leave_Ledger_Entries__No__of_days_;"No. of Days")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Posting_Description_;"HRM-Leave Ledger"."Transaction Description")
                {
                }
                column(HR_Leave_Ledger_Entries__Posting_Date_;"HRM-Leave Ledger"."Transaction Date")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Entry_Type_Caption;FieldCaption("HRM-Leave Ledger"."Entry Type"))
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Type_Caption;FieldCaption("Leave Type"))
                {
                }
                column(HR_Leave_Ledger_Entries__No__of_days_Caption;FieldCaption("No. of Days"))
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Posting_Description_Caption;FieldCaption("HRM-Leave Ledger"."Transaction Description"))
                {
                }
                column(HR_Leave_Ledger_Entries__Posting_Date_Caption;FieldCaption("HRM-Leave Ledger"."Transaction Date"))
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Period_Caption;FieldCaption("Leave Period"))
                {
                }
                column(HR_Leave_Ledger_Entries_Entry_No_;"Entry No.")
                {
                }
                column(HR_Leave_Ledger_Entries_Staff_No_;"HRM-Leave Ledger"."Employee No")
                {
                }

                trigger OnPreDataItem()
                begin
                    "HRM-Leave Ledger".SetFilter("HRM-Leave Ledger"."Leave Type",
                    "HRM-Employee C".GetFilter("HRM-Employee C"."Leave Type Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //"HR Employee c".VALIDATE("HR Employee c"."Allocated Leave Days");
                //LeaveBalance:="HR Employee c"."Leave Balance";
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
                          CI.Get();
                          CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        LeaveBalance: Decimal;
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_Leave_Reimbursement_ReportCaptionLbl: label 'Employee Leave Reimbursement Report';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        NameCaptionLbl: label 'Name';
        Leave_BalanceCaptionLbl: label 'Leave Balance';
        Day_s_CaptionLbl: label 'Day(s)';
}

