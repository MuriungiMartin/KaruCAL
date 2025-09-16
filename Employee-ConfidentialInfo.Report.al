#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5203 "Employee - Confidential Info."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Confidential Info..rdlc';
    Caption = 'Employee - Confidential Info.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Confidential Information";"Confidential Information")
        {
            DataItemTableView = sorting("Employee No.","Confidential Code","Line No.");
            RequestFilterFields = "Employee No.","Confidential Code";
            column(ReportForNavId_8509; 8509)
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
            column(Confidential_Information__TABLECAPTION__________ConfidentialInformationFilter;TableCaption + ': ' + ConfidentialInformationFilter)
            {
            }
            column(ConfidentialInformationFilter;ConfidentialInformationFilter)
            {
            }
            column(Confidential_Information__Employee_No__;"Employee No.")
            {
            }
            column(Employee_FullName;Employee.FullName)
            {
            }
            column(Confidential_Information__Confidential_Code_;"Confidential Code")
            {
            }
            column(Confidential_Information_Description;Description)
            {
            }
            column(Employee___Confidential_Info_Caption;Employee___Confidential_Info_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Confidential_Information_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Confidential_Information__Confidential_Code_Caption;FieldCaption("Confidential Code"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.Get("Employee No.");
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
        ConfidentialInformationFilter := "Confidential Information".GetFilters;
    end;

    var
        Employee: Record Employee;
        ConfidentialInformationFilter: Text;
        Employee___Confidential_Info_CaptionLbl: label 'Employee - Confidential Info.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

