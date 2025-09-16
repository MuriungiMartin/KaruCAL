#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51447 "Employee Leave"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Leave.rdlc';

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
            column(HR_Employee_C_Position;Position)
            {
            }
            column(HR_Employee_C__Salespers__Purch__Code_;"Salespers./Purch. Code")
            {
            }
            column(HR_Employee_C__Department_Code_;"Department Code")
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
            column(HR_Employee_C_PositionCaption;FieldCaption(Position))
            {
            }
            column(HR_Employee_C__Salespers__Purch__Code_Caption;FieldCaption("Salespers./Purch. Code"))
            {
            }
            column(HR_Employee_C__Department_Code_Caption;FieldCaption("Department Code"))
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
            column(Employee_Leaves_BalanceCaption;"HRM-Emp. Leaves".FieldCaption(Balance))
            {
            }
            column(Employee_Leaves__Maturity_Date_Caption;"HRM-Emp. Leaves".FieldCaption("Maturity Date"))
            {
            }
            column(Employee_Leaves__Leave_Code_Caption;"HRM-Emp. Leaves".FieldCaption("Leave Code"))
            {
            }
            dataitem(UnknownTable61281;UnknownTable61281)
            {
                DataItemLink = "Employee No"=field("No.");
                column(ReportForNavId_5449; 5449)
                {
                }
                column(Employee_Leaves__Leave_Code_;"Leave Code")
                {
                }
                column(Employee_Leaves__Maturity_Date_;"Maturity Date")
                {
                }
                column(Employee_Leaves_Balance;Balance)
                {
                }
                column(Employee_Leaves_Employee_No;"Employee No")
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
}

