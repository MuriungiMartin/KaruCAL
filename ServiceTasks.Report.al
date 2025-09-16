#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5904 "Service Tasks"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Tasks.rdlc';
    Caption = 'Service Tasks';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Item Line";"Service Item Line")
        {
            DataItemTableView = sorting("Response Date","Response Time",Priority);
            RequestFilterFields = "Repair Status Code","Response Date","Response Time","Resource Filter","Allocation Status Filter";
            column(ReportForNavId_6416; 6416)
            {
            }
            column(TodayFormat;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ServItem_ServItemLine;TableCaption + ': ' + ServItemLineFilter)
            {
            }
            column(ServItemLineFilter;ServItemLineFilter)
            {
            }
            column(ResponseDate_ServItemLine;Format("Response Date"))
            {
            }
            column(ResponseTime_ServItemLine;"Response Time")
            {
                IncludeCaption = true;
            }
            column(Priority_ServItemLine;Priority)
            {
                IncludeCaption = true;
            }
            column(DocNo_ServItemLine;"Document No.")
            {
                IncludeCaption = true;
            }
            column(RepairStatus_ServItemLine;"Repair Status Code")
            {
                IncludeCaption = true;
            }
            column(ServItemGr_ServItemLine;"Service Item Group Code")
            {
                IncludeCaption = true;
            }
            column(ServItemNo_ServItemLine;"Service Item No.")
            {
                IncludeCaption = true;
            }
            column(ItemNo_ServItemLine;"Item No.")
            {
                IncludeCaption = true;
            }
            column(SerialNo_ServItemLine;"Serial No.")
            {
                IncludeCaption = true;
            }
            column(ServShelfNo_ServItemLine;"Service Shelf No.")
            {
                IncludeCaption = true;
            }
            column(Warranty_ServItemLine;Warranty)
            {
                IncludeCaption = true;
            }
            column(ContractNo_ServItemLine;"Contract No.")
            {
                IncludeCaption = true;
            }
            column(FormatWarranty;Format(Warranty))
            {
            }
            column(ServiceTasksCaption;ServiceTasksCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ResponseDateCaption;ResponseDateCaptionLbl)
            {
            }

            trigger OnPreDataItem()
            begin
                if (GetFilter("Allocation Status Filter") <> '') or
                   (GetFilter("Resource Filter") <> '') or
                   (GetFilter("Resource Group Filter") <> '')
                then
                  SetFilter("No. of Allocations",'>0');
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
        ServItemLineFilter := "Service Item Line".GetFilters;
    end;

    var
        ServItemLineFilter: Text;
        ServiceTasksCaptionLbl: label 'Service Tasks';
        CurrReportPageNoCaptionLbl: label 'Page';
        ResponseDateCaptionLbl: label 'Response Date';
}

