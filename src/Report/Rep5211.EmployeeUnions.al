#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5211 "Employee - Unions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Unions.rdlc';
    Caption = 'Employee - Unions';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Union;Union)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_8618; 8618)
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
            column(Union_TABLECAPTION__________UnionFilter;TableCaption + ': ' + UnionFilter)
            {
            }
            column(UnionFilter;UnionFilter)
            {
            }
            column(Union_Code;Code)
            {
            }
            column(Union_Name;Name)
            {
            }
            column(Employee___UnionsCaption;Employee___UnionsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Full_NameCaption;Full_NameCaptionLbl)
            {
            }
            column(Employee__No__Caption;o.FieldCaption("No."))
            {
            }
            dataitem(Employee;Employee)
            {
                DataItemLink = "Union Code"=field(Code);
                DataItemTableView = sorting(Status,"Union Code");
                column(ReportForNavId_7528; 7528)
                {
                }
                column(Employee__No__;"No.")
                {
                }
                column(FullName;FullName)
                {
                }
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
        UnionFilter := Union.GetFilters;
    end;

    var
        UnionFilter: Text;
        Employee___UnionsCaptionLbl: label 'Employee - Unions';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Full_NameCaptionLbl: label 'Full Name';
}

