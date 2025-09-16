#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5937 "Service Items Out of Warranty"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Items Out of Warranty.rdlc';
    Caption = 'Service Items Out of Warranty';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Item";"Service Item")
        {
            CalcFields = "No. of Active Contracts";
            DataItemTableView = sorting("Warranty Ending Date (Parts)","Customer No.","Ship-to Code");
            RequestFilterFields = "Warranty Ending Date (Parts)","Customer No.","Ship-to Code";
            column(ReportForNavId_5875; 5875)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ServItmTblCptServItemFilt;TableCaption + ': ' + ServItemFilter)
            {
            }
            column(ServItemFilter;ServItemFilter)
            {
            }
            column(CustomerNo_ServItem;"Customer No.")
            {
                IncludeCaption = true;
            }
            column(SerialNo_ServItem;"Serial No.")
            {
                IncludeCaption = true;
            }
            column(WrntyEndgDtParts_ServItem;Format("Warranty Ending Date (Parts)"))
            {
            }
            column(No_ServItem;"No.")
            {
                IncludeCaption = true;
            }
            column(ShiptoCode_ServItem;"Ship-to Code")
            {
                IncludeCaption = true;
            }
            column(Name_ServItem;Name)
            {
                IncludeCaption = true;
            }
            column(Description_ServItem;Description)
            {
                IncludeCaption = true;
            }
            column(NoofActvContrct_ServItem;"No. of Active Contracts")
            {
                IncludeCaption = true;
            }
            column(ServItemOutofWarrantyCptn;ServItemOutofWarrantyCptnLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ServItmWrntyEndgDtPrtCptn;ServItmWrntyEndgDtPrtCptnLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields(Name,"Ship-to Name");
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Warranty Ending Date (Parts)") = '' then
                  SetFilter("Warranty Ending Date (Parts)",'<>%1',0D);
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
        ServItemFilter := "Service Item".GetFilters;
    end;

    var
        ServItemFilter: Text;
        ServItemOutofWarrantyCptnLbl: label 'Service Items Out of Warranty';
        CurrReportPageNoCaptionLbl: label 'Page';
        ServItmWrntyEndgDtPrtCptnLbl: label 'Warranty Ending Date (Parts)';
}

