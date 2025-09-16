#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5202 "Employee - Misc. Article Info."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Misc. Article Info..rdlc';
    Caption = 'Employee - Misc. Article Info.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Misc. Article Information";"Misc. Article Information")
        {
            DataItemTableView = sorting("Employee No.","Misc. Article Code","Line No.");
            RequestFilterFields = "Employee No.","Misc. Article Code";
            column(ReportForNavId_4668; 4668)
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
            column(Misc__Article_Information__TABLECAPTION__________MiscArticleFilter;TableCaption + ': ' + MiscArticleFilter)
            {
            }
            column(MiscArticleFilter;MiscArticleFilter)
            {
            }
            column(Misc__Article_Information__Employee_No__;"Employee No.")
            {
            }
            column(Employee_FullName;Employee.FullName)
            {
            }
            column(Misc__Article_Information__Misc__Article_Code_;"Misc. Article Code")
            {
            }
            column(Misc__Article_Information_Description;Description)
            {
            }
            column(Misc__Article_Information__Serial_No__;"Serial No.")
            {
            }
            column(Employee___Misc__Article_Info_Caption;Employee___Misc__Article_Info_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Misc__Article_Information_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Misc__Article_Information__Misc__Article_Code_Caption;FieldCaption("Misc. Article Code"))
            {
            }
            column(Misc__Article_Information__Serial_No__Caption;FieldCaption("Serial No."))
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
        Caption = 'Employee - Misc. Article Info.';

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
        MiscArticleFilter := "Misc. Article Information".GetFilters;
    end;

    var
        Employee: Record Employee;
        MiscArticleFilter: Text;
        Employee___Misc__Article_Info_CaptionLbl: label 'Employee - Misc. Article Info.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

