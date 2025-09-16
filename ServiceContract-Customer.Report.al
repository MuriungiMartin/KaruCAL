#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5977 "Service Contract - Customer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Contract - Customer.rdlc';
    Caption = 'Service Contract - Customer';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            CalcFields = Name;
            DataItemTableView = sorting("Customer No.","Ship-to Code") where("Contract Type"=const(Contract));
            RequestFilterFields = "Customer No.","Ship-to Code","Contract No.";
            column(ReportForNavId_9952; 9952)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ServContractHdrCaption;TableCaption + ': ' + ServContractFilter)
            {
            }
            column(ServContractFilter;ServContractFilter)
            {
            }
            column(CustomerNoNameCaption;FieldCaption("Customer No.") + ' ' + "Customer No." + ' ' + Name)
            {
            }
            column(ContractNo_ServContract;"Contract No.")
            {
                IncludeCaption = true;
            }
            column(Status_ServContract;Format(Status))
            {
            }
            column(AmtperPeriod_ServContract;"Amount per Period")
            {
            }
            column(NextInvDate_ServContract;Format("Next Invoice Date"))
            {
            }
            column(InvPeriod_ServContract;Format("Invoice Period"))
            {
            }
            column(AnnualAmount_ServContract;"Annual Amount")
            {
                IncludeCaption = true;
            }
            column(Description_ServContract;Description)
            {
                IncludeCaption = true;
            }
            column(Prepaid_ServContract;Prepaid)
            {
                IncludeCaption = true;
            }
            column(ShiptoCode_ServContract;"Ship-to Code")
            {
                IncludeCaption = true;
            }
            column(AmtOnExpiredLines;AmountOnExpiredLines)
            {
            }
            column(PrepaidFmt_ServContract;Format(Prepaid))
            {
            }
            column(TotalForCustomerNoName;Text000 + FieldCaption("Customer No.") + ' ' + "Customer No." + ' ' + Name)
            {
            }
            column(CustomerNo_ServContract;"Customer No.")
            {
            }
            column(ServContractsCustCaption;ServContractsCustCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(StatusCaption;StatusCaptionLbl)
            {
            }
            column(AmtperPeriodCaption;AmtperPeriodCaptionLbl)
            {
            }
            column(ServContHdrNextInvDtCptn;ServContHdrNextInvDtCptnLbl)
            {
            }
            column(InvoicePeriodCaption;InvoicePeriodCaptionLbl)
            {
            }
            column(AmtonExpiredLinesCaption;AmtonExpiredLinesCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                AmountOnExpiredLines := 0;
                ServContractLine.SetRange("Contract Type","Contract Type");
                ServContractLine.SetRange("Contract No.","Contract No.");
                if ServContractLine.Find('-') then
                  repeat
                    if (("Expiration Date" <> 0D) and
                        ("Expiration Date" <= WorkDate)) or
                       ((ServContractLine."Contract Expiration Date" <> 0D) and
                        (ServContractLine."Contract Expiration Date" <= WorkDate))
                    then
                      AmountOnExpiredLines := AmountOnExpiredLines + ServContractLine."Line Amount";
                  until ServContractLine.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(AmountOnExpiredLines);
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
        ServContractFilter := "Service Contract Header".GetFilters;
    end;

    var
        Text000: label 'Total for ';
        ServContractLine: Record "Service Contract Line";
        ServContractFilter: Text;
        AmountOnExpiredLines: Decimal;
        ServContractsCustCaptionLbl: label 'Service Contracts - Customer';
        CurrReportPageNoCaptionLbl: label 'Page';
        StatusCaptionLbl: label 'Status';
        AmtperPeriodCaptionLbl: label 'Amount per Period';
        ServContHdrNextInvDtCptnLbl: label 'Next Invoice Date';
        InvoicePeriodCaptionLbl: label 'Invoice Period';
        AmtonExpiredLinesCaptionLbl: label 'Amount on Expired Lines';
        TotalCaptionLbl: label 'Total';
}

