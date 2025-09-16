#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51510 "validate HR"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/validate HR.rdlc';

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
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C__No___Control1000000011;"No.")
            {
            }
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__Middle_Name_;"Middle Name")
            {
            }
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(HR_Employee_C_Names;Names)
            {
            }
            column(EmployeeCaption;EmployeeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Employee_C__No___Control1000000011Caption;FieldCaption("No."))
            {
            }
            column(HR_Employee_C__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(HR_Employee_C__Middle_Name_Caption;FieldCaption("Middle Name"))
            {
            }
            column(HR_Employee_C__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(HR_Employee_C_NamesCaption;FieldCaption(Names))
            {
            }
            column(HR_Employee_C__No__Caption;FieldCaption("No."))
            {
            }

            trigger OnAfterGetRecord()
            begin
                   Validate("HRM-Employee C"."Last Name");
                   Modify;
            end;

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

