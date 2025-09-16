#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51657 "Employee Length of Service"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Length of Service.rdlc';

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
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C__Contract_Type_;"Contract Type")
            {
            }
            column(HR_Employee_C__Date_Of_Birth_;"Date Of Birth")
            {
            }
            column(HR_Employee_C_Age;Age)
            {
            }
            column(HR_Employee_C__Date_Of_Join_;"Date Of Join")
            {
            }
            column(HR_Employee_C__Length_Of_Service_;"Length Of Service")
            {
            }
            column(Employee_Length_of_Service_ReportCaption;Employee_Length_of_Service_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Employee_C__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(HR_Employee_C__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(HR_Employee_C__No__Caption;FieldCaption("No."))
            {
            }
            column(HR_Employee_C__Contract_Type_Caption;FieldCaption("Contract Type"))
            {
            }
            column(HR_Employee_C__Date_Of_Birth_Caption;FieldCaption("Date Of Birth"))
            {
            }
            column(HR_Employee_C_AgeCaption;FieldCaption(Age))
            {
            }
            column(Date_EmployedCaption;Date_EmployedCaptionLbl)
            {
            }
            column(HR_Employee_C__Length_Of_Service_Caption;FieldCaption("Length Of Service"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                    if "HRM-Employee C"."Date Of Join"<>0D then
                    "HRM-Employee C".Validate("HRM-Employee C"."Date Of Join");
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
        Employee_Length_of_Service_ReportCaptionLbl: label 'Employee Length of Service Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Date_EmployedCaptionLbl: label 'Date Employed';
}

