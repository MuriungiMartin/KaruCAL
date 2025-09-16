#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10310 "Language List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Language List.rdlc';
    Caption = 'Language List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Language;Language)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_5798; 5798)
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
            column(Language_TABLECAPTION__________LanguageFilter;Language.TableCaption + ': ' + LanguageFilter)
            {
            }
            column(LanguageFilter;LanguageFilter)
            {
            }
            column(Language_Code;Code)
            {
            }
            column(Language_Name;Name)
            {
            }
            column(Language__Windows_Language_ID_;"Windows Language ID")
            {
            }
            column(Language__Windows_Language_Name_;"Windows Language Name")
            {
            }
            column(Language_ListCaption;Language_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Language_CodeCaption;FieldCaption(Code))
            {
            }
            column(Language_NameCaption;FieldCaption(Name))
            {
            }
            column(Language__Windows_Language_ID_Caption;FieldCaption("Windows Language ID"))
            {
            }
            column(Language__Windows_Language_Name_Caption;FieldCaption("Windows Language Name"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Windows Language Name");
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
        CompanyInformation.Get;
        LanguageFilter := Language.GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        LanguageFilter: Text;
        Language_ListCaptionLbl: label 'Language List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

