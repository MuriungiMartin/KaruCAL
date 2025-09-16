#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10324 "Sales Tax Group List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Tax Group List.rdlc';
    Caption = 'Sales Tax Group List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Tax Group";"Tax Group")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_6966; 6966)
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
            column(Tax_Group__TABLECAPTION__________TaxGroupFilters;"Tax Group".TableCaption + ': ' + TaxGroupFilters)
            {
            }
            column(TaxGroupFilters;TaxGroupFilters)
            {
            }
            column(Tax_Group_Code;Code)
            {
            }
            column(Tax_Group_Description;Description)
            {
            }
            column(Sales_Tax_Group_ListCaption;Sales_Tax_Group_ListCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(Tax_Group_CodeCaption;FieldCaption(Code))
            {
            }
            column(Tax_Group_DescriptionCaption;FieldCaption(Description))
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
        TaxGroupFilters := "Tax Group".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        TaxGroupFilters: Text;
        Sales_Tax_Group_ListCaptionLbl: label 'Sales Tax Group List';
        PageCaptionLbl: label 'Page';
}

