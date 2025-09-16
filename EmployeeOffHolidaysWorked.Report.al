#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51331 "Employee Off/Holidays Worked"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee OffHolidays Worked.rdlc';

    dataset
    {
        dataitem(UnknownTable61283;UnknownTable61283)
        {
            DataItemTableView = sorting("Employee No",Date);
            RequestFilterFields = "Employee No";
            column(ReportForNavId_7544; 7544)
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
            column(Employee_Off_Holidays__Employee_No_;"Employee No")
            {
            }
            column(EmployeeNames;EmployeeNames)
            {
            }
            column(Employee_Off_Holidays_Date;Date)
            {
            }
            column(Employee_Off_Holidays_Approved;Approved)
            {
            }
            column(Employee_Off_HolidaysCaption;Employee_Off_HolidaysCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Off_Holidays__Employee_No_Caption;FieldCaption("Employee No"))
            {
            }
            column(Employee_Off_Holidays_ApprovedCaption;FieldCaption(Approved))
            {
            }
            column(Employee_Off_Holidays_DateCaption;FieldCaption(Date))
            {
            }
            column(Employee_NamesCaption;Employee_NamesCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.Reset;
                Employee.SetRange(Employee."No.","HRM-Emp. Off/Holidays"."Employee No");
                if Employee.Find('-') then
                EmployeeNames:=Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Employee No");
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
        Employee: Record UnknownRecord61188;
        EmployeeNames: Text[200];
        Employee_Off_HolidaysCaptionLbl: label 'Employee Off/Holidays';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_NamesCaptionLbl: label 'Employee Names';
}

