#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10312 "Reason Code List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reason Code List.rdlc';
    Caption = 'Reason Code List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Reason Code";"Reason Code")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_6118; 6118)
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
            column(Reason_Code__TABLECAPTION__________ReasonFilter;"Reason Code".TableCaption + ': ' + ReasonFilter)
            {
            }
            column(ReasonFilter;ReasonFilter)
            {
            }
            column(Reason_Code_Code;Code)
            {
            }
            column(Reason_Code_Description;Description)
            {
            }
            column(Reason_Code_ListCaption;Reason_Code_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Reason_Code_CodeCaption;FieldCaption(Code))
            {
            }
            column(Reason_Code_DescriptionCaption;FieldCaption(Description))
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
        ReasonFilter := "Reason Code".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        ReasonFilter: Text;
        Reason_Code_ListCaptionLbl: label 'Reason Code List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

