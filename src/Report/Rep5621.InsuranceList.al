#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5621 "Insurance - List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Insurance - List.rdlc';
    Caption = 'Insurance - List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Insurance;Insurance)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_3288; 3288)
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
            column(Insurance_TABLECAPTION___________InsuranceFilter;TableCaption + ': ' + InsuranceFilter)
            {
            }
            column(InsuranceFilter;InsuranceFilter)
            {
            }
            column(Insurance__No__;"No.")
            {
            }
            column(Insurance_Description;Description)
            {
            }
            column(Insurance__Effective_Date_;Format("Effective Date"))
            {
            }
            column(Insurance__Policy_No__;"Policy No.")
            {
            }
            column(Insurance__Annual_Premium_;"Annual Premium")
            {
            }
            column(Insurance__Policy_Coverage_;"Policy Coverage")
            {
            }
            column(Insurance__Insurance_Type_;"Insurance Type")
            {
            }
            column(Insurance__Insurance_Vendor_No__;"Insurance Vendor No.")
            {
            }
            column(Insurance___ListCaption;Insurance___ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Insurance__No__Caption;FieldCaption("No."))
            {
            }
            column(Insurance_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Insurance__Effective_Date_Caption;Insurance__Effective_Date_CaptionLbl)
            {
            }
            column(Insurance__Policy_No__Caption;FieldCaption("Policy No."))
            {
            }
            column(Insurance__Annual_Premium_Caption;FieldCaption("Annual Premium"))
            {
            }
            column(Insurance__Policy_Coverage_Caption;FieldCaption("Policy Coverage"))
            {
            }
            column(Insurance__Insurance_Type_Caption;FieldCaption("Insurance Type"))
            {
            }
            column(Insurance__Insurance_Vendor_No__Caption;FieldCaption("Insurance Vendor No."))
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
        InsuranceFilter := Insurance.GetFilters;
    end;

    var
        InsuranceFilter: Text;
        Insurance___ListCaptionLbl: label 'Insurance - List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Insurance__Effective_Date_CaptionLbl: label 'Effective Date';
}

