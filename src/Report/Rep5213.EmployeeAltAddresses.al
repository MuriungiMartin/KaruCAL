#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5213 "Employee - Alt. Addresses"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Alt. Addresses.rdlc';
    Caption = 'Employee - Alt. Addresses';
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
            column(AlternativeAddr_Address;AlternativeAddr.Address)
            {
            }
            column(PostCodeCityText;PostCodeCityText)
            {
            }
            column(Employee___Alt__AddressesCaption;Employee___Alt__AddressesCaptionLbl)
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
            column(AddressCaption;AddressCaptionLbl)
            {
            }
            column(Post_Code_CityCaption;Post_Code_CityCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if (Today <= "Alt. Address End Date") and
                   (Today >= "Alt. Address Start Date") and
                   ("Alt. Address Code" <> '')
                then begin
                  AlternativeAddr.Get("No.","Alt. Address Code");
                  FormatAddr.FormatPostCodeCity(
                    PostCodeCityText,CountyText,AlternativeAddr.City,
                    AlternativeAddr."Post Code",AlternativeAddr.County,
                    AlternativeAddr."Country/Region Code");
                end else
                  CurrReport.Skip;
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
        EmployeeFilter := o.GetFilters;
    end;

    var
        AlternativeAddr: Record "Alternative Address";
        FormatAddr: Codeunit "Format Address";
        PostCodeCityText: Text[50];
        CountyText: Text[50];
        EmployeeFilter: Text;
        Employee___Alt__AddressesCaptionLbl: label 'Employee - Alt. Addresses';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Full_NameCaptionLbl: label 'Full Name';
        AddressCaptionLbl: label 'Address';
        Post_Code_CityCaptionLbl: label 'ZIP Code/City';
}

