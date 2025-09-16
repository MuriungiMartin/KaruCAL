#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5955 "Dispatch Board"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Dispatch Board.rdlc';
    Caption = 'Dispatch Board';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Header";"Service Header")
        {
            DataItemTableView = sorting(Status,"Response Date","Response Time",Priority);
            RequestFilterFields = "Document Type","No.",Status,"Response Date","Customer No.","Service Zone Code","Contract No.";
            column(ReportForNavId_1634; 1634)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TableCaptionFilter_ServHeader;TableCaption + ': ' + ServHeaderFilter)
            {
            }
            column(ServHeaderFilter;ServHeaderFilter)
            {
            }
            column(ResponseDate_ServHeader;Format("Response Date"))
            {
            }
            column(ResponseTime_ServHeader;"Response Time")
            {
                IncludeCaption = true;
            }
            column(Priority_ServHeader;Priority)
            {
                IncludeCaption = true;
            }
            column(No_ServHeader;"No.")
            {
                IncludeCaption = true;
            }
            column(Status_ServHeader;Status)
            {
                IncludeCaption = true;
            }
            column(CustNo_ServHeader;"Customer No.")
            {
                IncludeCaption = true;
            }
            column(ShiptoCode_ServHeader;"Ship-to Code")
            {
                IncludeCaption = true;
            }
            column(Name_ServHeader;Name)
            {
                IncludeCaption = true;
            }
            column(ContractNo_ServHeader;"Contract No.")
            {
                IncludeCaption = true;
            }
            column(ServiceZoneCode_ServHeader;"Service Zone Code")
            {
                IncludeCaption = true;
            }
            column(NoofAllocations_ServHeader;"No. of Allocations")
            {
                IncludeCaption = true;
            }
            column(OrderDate_ServHeader;Format("Order Date"))
            {
            }
            column(Dispatch_BoardCaption;Dispatch_BoardCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ResponseDate_ServHeaderCaption;ResponseDate_ServHeaderCaptionLbl)
            {
            }
            column(OrderDate_ServHeaderCaption;OrderDate_ServHeaderCaptionLbl)
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
        ServHeaderFilter := "Service Header".GetFilters;
    end;

    var
        ServHeaderFilter: Text;
        Dispatch_BoardCaptionLbl: label 'Dispatch Board';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ResponseDate_ServHeaderCaptionLbl: label 'Response Date';
        OrderDate_ServHeaderCaptionLbl: label 'Order Date';
}

