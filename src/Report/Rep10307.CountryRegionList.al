#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10307 "Country/Region List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CountryRegion List.rdlc';
    Caption = 'Country/Region List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Country/Region";"Country/Region")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Address Format";
            column(ReportForNavId_4153; 4153)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Country_Region__TABLECAPTION__________CountryFilter;"Country/Region".TableCaption + ': ' + CountryFilter)
            {
            }
            column(CountryFilter;CountryFilter)
            {
            }
            column(Country_Region_Code;Code)
            {
            }
            column(Country_Region_Name;Name)
            {
            }
            column(Country_Region__Address_Format_;"Address Format")
            {
            }
            column(Country_Region__Contact_Address_Format_;"Contact Address Format")
            {
            }
            column(Country_Region__EU_Country_Region_Code_;"EU Country/Region Code")
            {
            }
            column(Country_Region_ListCaption;Country_Region_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Country_Region_CodeCaption;FieldCaption(Code))
            {
            }
            column(Country_Region_NameCaption;FieldCaption(Name))
            {
            }
            column(Country_Region__Address_Format_Caption;FieldCaption("Address Format"))
            {
            }
            column(Country_Region__Contact_Address_Format_Caption;FieldCaption("Contact Address Format"))
            {
            }
            column(Country_Region__EU_Country_Region_Code_Caption;FieldCaption("EU Country/Region Code"))
            {
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
        CompanyInformation.Get;
        CountryFilter := "Country/Region".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        CountryFilter: Text;
        Country_Region_ListCaptionLbl: label 'Country/Region List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

