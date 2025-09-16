#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5207 "Employee - Addresses"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Addresses.rdlc';
    Caption = 'Employee - Addresses';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_7528; 7528)
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
            column(Employee_TABLECAPTION__________EmployeeFilter;TableCaption + ': ' + EmployeeFilter)
            {
            }
            column(EmployeeFilter;EmployeeFilter)
            {
            }
            column(Employee__No__;"No.")
            {
            }
            column(FullName;FullName)
            {
            }
            column(Employee_Address;Address)
            {
            }
            column(PostCodeCityText;PostCodeCityText)
            {
            }
            column(Employee___AddressesCaption;Employee___AddressesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee__No__Caption;FieldCaption("No."))
            {
            }
            column(Full_NameCaption;Full_NameCaptionLbl)
            {
            }
            column(Employee_AddressCaption;FieldCaption(Address))
            {
            }
            column(Post_Code_CityCaption;Post_Code_CityCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.FormatPostCodeCity(
                  PostCodeCityText,CountyText,City,"Post Code",County,"Country/Region Code");
            end;
        }
    }

    requestpage
    {
        Caption = 'Employee - Addresses';

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
        EmployeeFilter := o.GetFilters;
    end;

    var
        FormatAddr: Codeunit "Format Address";
        PostCodeCityText: Text[50];
        CountyText: Text[50];
        EmployeeFilter: Text;
        Employee___AddressesCaptionLbl: label 'Employee - Addresses';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Full_NameCaptionLbl: label 'Full Name';
        Post_Code_CityCaptionLbl: label 'ZIP Code/City';
}

