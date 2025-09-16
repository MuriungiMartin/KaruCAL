#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5935 "Service Items"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Items.rdlc';
    Caption = 'Service Items';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Item";"Service Item")
        {
            CalcFields = "No. of Active Contracts";
            DataItemTableView = sorting("Customer No.","Ship-to Code","Item No.","Serial No.");
            RequestFilterFields = "Customer No.","Ship-to Code";
            column(ReportForNavId_5875; 5875)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ServItemFltr;TableCaption + ': ' + ServItemFilter)
            {
            }
            column(ServItemFilter;ServItemFilter)
            {
            }
            column(CustomerNo_ServItem;"Customer No.")
            {
                IncludeCaption = true;
            }
            column(ShiptoCode_ServItem;"Ship-to Code")
            {
                IncludeCaption = true;
            }
            column(No_ServItem;"No.")
            {
                IncludeCaption = true;
            }
            column(SerialNo_ServItem;"Serial No.")
            {
                IncludeCaption = true;
            }
            column(Description_ServItem;Description)
            {
                IncludeCaption = true;
            }
            column(ServiceItemGroupCode_ServItem;"Service Item Group Code")
            {
                IncludeCaption = true;
            }
            column(ItemNo_ServItem;"Item No.")
            {
                IncludeCaption = true;
            }
            column(VariantCode_ServItem;"Variant Code")
            {
                IncludeCaption = true;
            }
            column(NoofActiveContracts_ServItem;"No. of Active Contracts")
            {
                IncludeCaption = true;
            }
            column(ServiceItemsCaption;ServiceItemsCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
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
        ServItemFilter := "Service Item".GetFilters;
    end;

    var
        ServItemFilter: Text;
        ServiceItemsCaptionLbl: label 'Service Items';
        CurrReportPageNoCaptionLbl: label 'Page';
}

