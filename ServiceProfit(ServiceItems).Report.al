#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5938 "Service Profit (Service Items)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Profit (Service Items).rdlc';
    Caption = 'Service Profit (Service Items)';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Item";"Service Item")
        {
            DataItemTableView = sorting("Item No.","Serial No.");
            RequestFilterFields = "Item No.","Variant Code","No.","Date Filter";
            column(ReportForNavId_5875; 5875)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ToadayFormatted;Format(Today,0,4))
            {
            }
            column(Filter_ServItem;TableCaption + ': ' + ServItemFilter)
            {
            }
            column(ShowFilter;ServItemFilter)
            {
            }
            column(CostAmount;CostAmount)
            {
                AutoFormatType = 1;
            }
            column(DiscountAmount;DiscountAmount)
            {
                AutoFormatType = 1;
            }
            column(SalesAmount;SalesAmount)
            {
                AutoFormatType = 1;
            }
            column(ItemNo_ServItem;"Item No.")
            {
                IncludeCaption = true;
            }
            column(Desc_ServItem;Description)
            {
                IncludeCaption = true;
            }
            column(No_ServItem;"No.")
            {
                IncludeCaption = true;
            }
            column(ProfitAmount;ProfitAmount)
            {
                AutoFormatType = 1;
            }
            column(ProfitPct;ProfitPct)
            {
                DecimalPlaces = 1:1;
            }
            column(ContractDiscAmount;ContractDiscAmount)
            {
                AutoFormatType = 1;
            }
            column(ShowDetail;ShowDetail)
            {
            }
            column(ItemNoCaptionItemNo;Text000 + FieldCaption("Item No.") + ' ' + "Item No.")
            {
            }
            column(Total;TotalLbl)
            {
            }
            column(ServiceProfitServItemsCaption;ServiceProfitServItemsCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ServCostAmtLCYCaption;ServCostAmtLCYCaptionLbl)
            {
            }
            column(ServDiscAmtLCYCaption;ServDiscAmtLCYCaptionLbl)
            {
            }
            column(ServAmtLCYCaption;ServAmtLCYCaptionLbl)
            {
            }
            column(ProfitAmtLCYCaption;ProfitAmtLCYCaptionLbl)
            {
            }
            column(ProfitCaption;ProfitCaptionLbl)
            {
            }
            column(ContractDiscAmtLCYCaption;ContractDiscAmtLCYCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SalesAmount := 0;
                DiscountAmount := 0;
                ContractDiscAmount := 0;
                CostAmount := 0;
                ProfitAmount := 0;

                ServLedgerEntry.SetRange("Service Item No. (Serviced)","No.");
                ServLedgerEntry.SetFilter(
                  "Entry Type",'%1|%2',ServLedgerEntry."entry type"::Sale,
                  ServLedgerEntry."entry type"::Consume);
                ServLedgerEntry.SetFilter("Posting Date",GetFilter("Date Filter"));
                ServLedgerEntry.SetRange(Open,false);
                if ServLedgerEntry.FindSet then
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
                ServLedgerEntry.SetCurrentkey("Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.",Type,"Posting Date",Open);
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
        ServItemFilter := "Service Item".GetFilters;
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
        ServItemFilter: Text;
        ShowDetail: Boolean;
        TotalLbl: label 'Total:';
        ServiceProfitServItemsCaptionLbl: label 'Service Profit (Service Items)';
        CurrReportPageNoCaptionLbl: label 'Page';
        ServCostAmtLCYCaptionLbl: label 'Service Cost Amount ($)';
        ServDiscAmtLCYCaptionLbl: label 'Service Disc. Amount ($)';
        ServAmtLCYCaptionLbl: label 'Service Amount ($)';
        ProfitAmtLCYCaptionLbl: label 'Profit Amount ($)';
        ProfitCaptionLbl: label 'Profit %';
        ContractDiscAmtLCYCaptionLbl: label 'Contract Disc. Amount ($)';


    procedure InitializeRequest(NewShowDetail: Boolean)
    begin
        ShowDetail := NewShowDetail;
    end;
}

