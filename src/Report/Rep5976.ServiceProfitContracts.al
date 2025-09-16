#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5976 "Service Profit (Contracts)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Profit (Contracts).rdlc';
    Caption = 'Service Profit (Contracts)';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            CalcFields = Name;
            DataItemTableView = sorting("Responsibility Center","Service Zone Code",Status,"Contract Group Code") where("Contract Type"=const(Contract));
            RequestFilterFields = "Responsibility Center","Contract Group Code","Contract No.","Posted Service Order Filter","Date Filter";
            column(ReportForNavId_9952; 9952)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(ServContractFilter_ServContract;TableCaption + ': ' + ServContractFilter)
            {
            }
            column(ServContractFilter;ServContractFilter)
            {
            }
            column(RespCenter_ServContract;"Responsibility Center")
            {
            }
            column(AmountLCY_ServLedgEntry;-"Service Ledger Entry"."Amount (LCY)")
            {
            }
            column(ContractDiscAmt_ServLedgEntry;-"Service Ledger Entry"."Contract Disc. Amount")
            {
            }
            column(DisAmt_ServLedgEntry;-"Service Ledger Entry"."Discount Amount")
            {
            }
            column(CostAmt_ServLedgEntry;-"Service Ledger Entry"."Cost Amount")
            {
            }
            column(RespCenter;RespCenterLbl)
            {
            }
            column(ProfitAmt_ServContract;ProfitAmount)
            {
                AutoFormatType = 1;
            }
            column(ProfitPct_ServContract;ProfitPct)
            {
                DecimalPlaces = 1:1;
            }
            column(Total;TotalLbl)
            {
            }
            column(TotalProfitAmt;TotalProfitAmount)
            {
                AutoFormatType = 1;
            }
            column(TotalCostAmt;TotalCostAmount)
            {
                AutoFormatType = 1;
            }
            column(TotalDiscountAmt;TotalDiscountAmount)
            {
                AutoFormatType = 1;
            }
            column(TotalContractDiscAmount;TotalContractDiscAmount)
            {
                AutoFormatType = 1;
            }
            column(TotalSalesAmount;TotalSalesAmount)
            {
                AutoFormatType = 1;
            }
            column(ServiceProfitServiceContractsCaption;ServiceProfitServiceContractsCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(ProfitCaption;ProfitCaptionLbl)
            {
            }
            column(ProfitAmountLCYCaption;ProfitAmountLCYCaptionLbl)
            {
            }
            column(ServiceCostAmountLCYCaption;ServiceCostAmountLCYCaptionLbl)
            {
            }
            column(ServiceDiscAmountLCYCaption;ServiceDiscAmountLCYCaptionLbl)
            {
            }
            column(ContractDiscAmountLCYCaption;ContractDiscAmountLCYCaptionLbl)
            {
            }
            column(ServiceAmountLCYCaption;ServiceAmountLCYCaptionLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            column(ResponsibilityCenterCaption;ResponsibilityCenterCaptionLbl)
            {
            }
            dataitem("Service Ledger Entry";"Service Ledger Entry")
            {
                DataItemLink = "Service Contract No."=field("Contract No."),"Posting Date"=field("Date Filter"),"Service Order No."=field("Posted Service Order Filter");
                DataItemTableView = sorting("Service Contract No.") where("Entry Type"=const(Sale),Open=const(false));
                column(ReportForNavId_1141; 1141)
                {
                }
                column(CustNoName_ServContract;"Service Contract Header"."Customer No." + ' ' + "Service Contract Header".Name)
                {
                }
                column(Desc_ServContract;"Service Contract Header"."Contract No." + ' ' + "Service Contract Header".Description)
                {
                }
                column(ProfitPct_ServLedgEntry;ProfitPct)
                {
                    DecimalPlaces = 1:1;
                }
                column(ProfitAmount_ServLedgEntry;ProfitAmount)
                {
                    AutoFormatType = 1;
                }
                column(Type_ServLedgEntry;Type)
                {
                    IncludeCaption = true;
                }
                column(No_ServLedgEntry;"No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_ServLedgEntry;Description)
                {
                    IncludeCaption = true;
                }
                column(AmountLCY;-"Amount (LCY)")
                {
                }
                column(ContractDiscAmt;-"Contract Disc. Amount")
                {
                }
                column(DiscountAmt;-"Discount Amount")
                {
                }
                column(CostAmt;-"Cost Amount")
                {
                }
                column(PostingDate_ServLedgEntry;Format("Posting Date"))
                {
                }
                column(ShowDetail;ShowDetail)
                {
                }
                column(ServContract;ServContractLbl)
                {
                }
                column(ServContractNo_ServLedgEntry;"Service Contract No.")
                {
                }
                column(CustomerCaption;CustomerCaptionLbl)
                {
                }
                column(ServiceContractCaption;ServiceContractCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ProfitAmount := -"Amount (LCY)" + "Cost Amount";
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(
                      ServLedgerEntry.Quantity,ServLedgerEntry."Amount (LCY)",ServLedgerEntry."Discount Amount",
                      ServLedgerEntry."Cost Amount",ServLedgerEntry."Contract Disc. Amount",ProfitAmount);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ServLedgerEntry.SetRange("Service Contract No.");
                ServLedgerEntry.SetFilter("Posting Date",GetFilter("Date Filter"));

                if not ServLedgerEntry.FindFirst then
                  CurrReport.Skip;

                ProfitAmount := -"Service Ledger Entry"."Amount (LCY)" + "Service Ledger Entry"."Cost Amount";
            end;

            trigger OnPreDataItem()
            begin
                ServLedgerEntry.SetCurrentkey("Service Contract No.");
                ServLedgerEntry.SetRange("Entry Type",ServLedgerEntry."entry type"::Sale);
                ServLedgerEntry.SetRange(Open,false);
                CurrReport.CreateTotals(
                  "Service Ledger Entry"."Amount (LCY)","Service Ledger Entry"."Cost Amount",
                  "Service Ledger Entry"."Discount Amount","Service Ledger Entry"."Contract Disc. Amount",ProfitAmount);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowDetail;ShowDetail)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Details';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        TypeCaption = 'Type';
    }

    trigger OnPreReport()
    begin
        ServContractFilter := "Service Contract Header".GetFilters;
        TotalSalesAmount := 0;
        TotalDiscountAmount := 0;
        TotalContractDiscAmount := 0;
        TotalCostAmount := 0;
        TotalProfitAmount := 0;
    end;

    var
        ServLedgerEntry: Record "Service Ledger Entry";
        TotalSalesAmount: Decimal;
        TotalDiscountAmount: Decimal;
        TotalContractDiscAmount: Decimal;
        TotalCostAmount: Decimal;
        TotalProfitAmount: Decimal;
        ProfitAmount: Decimal;
        ProfitPct: Decimal;
        ServContractFilter: Text;
        ShowDetail: Boolean;
        RespCenterLbl: label 'Total for Responsibility Center';
        TotalLbl: label 'Total:';
        ServiceProfitServiceContractsCaptionLbl: label 'Service Profit (Service Contracts)';
        PageCaptionLbl: label 'Page';
        ProfitCaptionLbl: label 'Profit %';
        ProfitAmountLCYCaptionLbl: label 'Profit Amount ($)';
        ServiceCostAmountLCYCaptionLbl: label 'Service Cost Amount ($)';
        ServiceDiscAmountLCYCaptionLbl: label 'Service Disc. Amount ($)';
        ContractDiscAmountLCYCaptionLbl: label 'Contract Disc. Amount ($)';
        ServiceAmountLCYCaptionLbl: label 'Service Amount ($)';
        PostingDateCaptionLbl: label 'Posting Date';
        ResponsibilityCenterCaptionLbl: label 'Responsibility Center:';
        ServContractLbl: label 'Total for Service Contract';
        CustomerCaptionLbl: label 'Customer:';
        ServiceContractCaptionLbl: label 'Service Contract:';


    procedure InitializeRequest(ShowDetailFrom: Boolean)
    begin
        ShowDetail := ShowDetailFrom;
    end;
}

