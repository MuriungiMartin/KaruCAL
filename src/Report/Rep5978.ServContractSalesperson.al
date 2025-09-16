#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5978 "Serv. Contract - Salesperson"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Serv. Contract - Salesperson.rdlc';
    Caption = 'Serv. Contract - Salesperson';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            DataItemTableView = sorting("Salesperson Code",Status) where("Contract Type"=const(Contract));
            RequestFilterFields = "Salesperson Code",Status,"Contract No.","Starting Date";
            column(ReportForNavId_9952; 9952)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ServCntrctFlt_ServContract;TableCaption + ': ' + ServContractFilter)
            {
            }
            column(ServContractFilter;ServContractFilter)
            {
            }
            column(SlspersonCod_ServContract;"Salesperson Code")
            {
                IncludeCaption = true;
            }
            column(ContractNo_ServContract;"Contract No.")
            {
                IncludeCaption = true;
            }
            column(CustomerNo_ServContract;"Customer No.")
            {
                IncludeCaption = true;
            }
            column(Name_ServContract;Name)
            {
                IncludeCaption = true;
            }
            column(StartingDate_ServContract;Format("Starting Date"))
            {
            }
            column(AnnualAmount_ServContract;"Annual Amount")
            {
                IncludeCaption = true;
            }
            column(ShiptoCode_ServContract;"Ship-to Code")
            {
                IncludeCaption = true;
            }
            column(CntrctGrCode_ServContract;"Contract Group Code")
            {
                IncludeCaption = true;
            }
            column(NextInvoDt_ServContract;Format("Next Invoice Date"))
            {
            }
            column(TtlFldCptnSalespersonCode;Text000 + FieldCaption("Salesperson Code"))
            {
            }
            column(TotalFor;TotalForLbl)
            {
            }
            column(ServContrctSalepersonCptn;ServContrctSalepersonCptnLbl)
            {
            }
            column(CurrReportPageNoCaptn;CurrReportPageNoCaptnLbl)
            {
            }
            column(ServContractStrtgDtCptn;ServContractStrtgDtCptnLbl)
            {
            }
            column(ServCntrctNxtInvDtCptn;ServCntrctNxtInvDtCptnLbl)
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
        ServContractFilter := "Service Contract Header".GetFilters;
    end;

    var
        Text000: label 'Total for ';
        ServContractFilter: Text;
        TotalForLbl: label 'Total ';
        ServContrctSalepersonCptnLbl: label 'Service Contract - Salesperson';
        CurrReportPageNoCaptnLbl: label 'Page';
        ServContractStrtgDtCptnLbl: label 'Starting Date';
        ServCntrctNxtInvDtCptnLbl: label 'Next Invoice Date';
}

