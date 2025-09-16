#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5909 "Service Profit (Resp. Centers)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Profit (Resp. Centers).rdlc';
    Caption = 'Service Profit (Resp. Centers)';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Shipment Header";"Service Shipment Header")
        {
            DataItemTableView = sorting("Responsibility Center","Posting Date");
            RequestFilterFields = "Responsibility Center","Posting Date","No.";
            column(ReportForNavId_2735; 2735)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(TblCptnServShptHdrFilter;TableCaption + ': ' + ServShipmentHeaderFilter)
            {
            }
            column(ServShipmentHeaderFilter;ServShipmentHeaderFilter)
            {
            }
            column(RespCenter_ServShptHeader;"Responsibility Center")
            {
                IncludeCaption = true;
            }
            column(SalesAmount;SalesAmount)
            {
                AutoFormatType = 1;
            }
            column(ContractDiscAmount;ContractDiscAmount)
            {
                AutoFormatType = 1;
            }
            column(DiscountAmount;DiscountAmount)
            {
                AutoFormatType = 1;
            }
            column(CostAmount;CostAmount)
            {
                AutoFormatType = 1;
            }
            column(ProfitAmount;ProfitAmount)
            {
                AutoFormatType = 1;
            }
            column(ProfitPct;ProfitPct)
            {
                DecimalPlaces = 1:1;
            }
            column(No_ServShptHeader;"No.")
            {
                IncludeCaption = true;
            }
            column(PostingDate_ServShptHeader;Format("Posting Date"))
            {
            }
            column(CustNo_ServShptHeader;"Customer No.")
            {
                IncludeCaption = true;
            }
            column(ShipToCode_ServShptHeader;"Ship-to Code")
            {
                IncludeCaption = true;
            }
            column(ShowDetail;ShowDetail)
            {
            }
            column(RespCenter;Text000 + FieldCaption("Responsibility Center") + ' ' + "Responsibility Center")
            {
            }
            column(TotalFor;TotalForLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(ServProfitRespCentersCaption;ServProfitRespCentersCaptionLbl)
            {
            }
            column(ServiceAmountLCYCaption;ServiceAmountLCYCaptionLbl)
            {
            }
            column(ContractDiscAmountLCYCaption;ContractDiscAmountLCYCaptionLbl)
            {
            }
            column(ServDiscAmountLCYCaption;ServDiscAmountLCYCaptionLbl)
            {
            }
            column(ServCostAmountLCYCaption;ServCostAmountLCYCaptionLbl)
            {
            }
            column(ProfitAmountLCYCaption;ProfitAmountLCYCaptionLbl)
            {
            }
            column(ProfitCaption;ProfitCaptionLbl)
            {
            }
            column(ServShpHdrPostingDateCaption;ServShpHdrPostingDateCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SalesAmount := 0;
                DiscountAmount := 0;
                ContractDiscAmount := 0;
                CostAmount := 0;
                ProfitAmount := 0;

                ServLedgerEntry.SetRange("Service Order No.","Order No.");
                ServLedgerEntry.SetRange("Entry Type",ServLedgerEntry."entry type"::Sale);
                ServLedgerEntry.SetRange(Open,false);
                if ServLedgerEntry.Find('-') then
                  repeat
                    DiscountAmount := DiscountAmount + -ServLedgerEntry."Discount Amount";
                    ContractDiscAmount := ContractDiscAmount + -ServLedgerEntry."Contract Disc. Amount";
                    CostAmount := CostAmount + -ServLedgerEntry."Cost Amount";
                    SalesAmount := SalesAmount + -ServLedgerEntry."Amount (LCY)";
                  until ServLedgerEntry.Next = 0;

                if (SalesAmount = 0) and (CostAmount = 0) then
                  CurrReport.Skip;

                ProfitAmount := SalesAmount - CostAmount;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(SalesAmount,DiscountAmount,ContractDiscAmount,CostAmount,ProfitAmount);

                Clear(ServLedgerEntry);
                ServLedgerEntry.SetCurrentkey(
                  "Service Order No.","Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.","Posting Date",Open,Type);
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
    }

    trigger OnPreReport()
    begin
        ServShipmentHeaderFilter := "Service Shipment Header".GetFilters;
    end;

    var
        Text000: label 'Total for ';
        ServLedgerEntry: Record "Service Ledger Entry";
        SalesAmount: Decimal;
        DiscountAmount: Decimal;
        ContractDiscAmount: Decimal;
        CostAmount: Decimal;
        ProfitAmount: Decimal;
        ProfitPct: Decimal;
        ServShipmentHeaderFilter: Text;
        ShowDetail: Boolean;
        TotalForLbl: label 'Total:';
        PageCaptionLbl: label 'Page';
        ServProfitRespCentersCaptionLbl: label 'Service Profit (Responsibility Centers)';
        ServiceAmountLCYCaptionLbl: label 'Service Amount ($)';
        ContractDiscAmountLCYCaptionLbl: label 'Contract Discount Amount ($)';
        ServDiscAmountLCYCaptionLbl: label 'Service Discount Amount ($)';
        ServCostAmountLCYCaptionLbl: label 'Service Cost Amount ($)';
        ProfitAmountLCYCaptionLbl: label 'Profit Amount ($)';
        ProfitCaptionLbl: label 'Profit %';
        ServShpHdrPostingDateCaptionLbl: label 'Posting Date';


    procedure InitializeRequest(ShowDetailFrom: Boolean)
    begin
        ShowDetail := ShowDetailFrom;
    end;
}

