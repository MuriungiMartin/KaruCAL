#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6080 "Serv. Pricing Profitability"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Serv. Pricing Profitability.rdlc';
    Caption = 'Serv. Pricing Profitability';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Price Group";"Service Price Group")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(ReportForNavId_4654; 4654)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ServPriceGrFilterCaption;TableCaption + ':' + ServPriceGrFilter)
            {
            }
            column(ServPriceGrpSetupCaption;"Serv. Price Group Setup".TableCaption + ':' + ServPriceGrSetupFilter)
            {
            }
            column(CustomerCaption;Customer.TableCaption + ':' + CustomerFilter)
            {
            }
            column(ServicePriceGroupCode;Code)
            {
            }
            column(ProfitAmt;ProfitAmt)
            {
            }
            column(Profit;ProfitPct)
            {
            }
            column(CostAmt;CostAmt)
            {
            }
            column(DiscountAmt;DiscountAmt)
            {
            }
            column(InvoiceAmt;InvoiceAmt)
            {
            }
            column(UsageAmt;UsageAmt)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(ServicePricingProfitabilityCaption;ServicePricingProfitabilityCaptionLbl)
            {
            }
            column(ServicePriceGroupCodeCaption;ServicePriceGroupCodeCaptionLbl)
            {
            }
            column(TotalforGroupCaption;TotalforGroupCaptionLbl)
            {
            }
            dataitem("Serv. Price Group Setup";"Serv. Price Group Setup")
            {
                DataItemLink = "Service Price Group Code"=field(Code);
                DataItemTableView = sorting("Service Price Group Code");
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Adjustment Type","Starting Date";
                column(ReportForNavId_2063; 2063)
                {
                }
                column(AdjmtType_ServPriceGrpSetup;"Adjustment Type")
                {
                }
                column(Amt_ServPriceGroupSetup;Amount)
                {
                }
                column(AdjmtType_ServPriceGrpSetupCaption;FieldCaption("Adjustment Type"))
                {
                }
                column(Amt_ServPriceGroupSetupCaption;FieldCaption(Amount))
                {
                }
                column(ServPriceGrpCode_ServPriceGrpSetup;"Service Price Group Code")
                {
                }
                column(FaultAreaCode_ServPriceGrpSetup;"Fault Area Code")
                {
                }
                column(CustPriceGrpCode_ServPriceGrpSetup;"Cust. Price Group Code")
                {
                }
                column(CurrencyCode_ServPriceGrpSetup;"Currency Code")
                {
                }
                column(StarteDate_ServPriceGrpSetup;"Starting Date")
                {
                }
                column(CustNo_ServShpItemLineCaption;"Service Shipment Item Line".FieldCaption("Customer No."))
                {
                }
                column(NameCaption;NameCaptionLbl)
                {
                }
                column(UsageAmountCaption;UsageAmountCaptionLbl)
                {
                }
                column(InvoiceAmountCaption;InvoiceAmountCaptionLbl)
                {
                }
                column(DiscountAmountCaption;DiscountAmountCaptionLbl)
                {
                }
                column(CostAmountCaption;CostAmountCaptionLbl)
                {
                }
                column(ProfitAmountCaption;ProfitAmountCaptionLbl)
                {
                }
                column(ProfitCaption;ProfitCaptionLbl)
                {
                }
                dataitem("Service Shipment Item Line";"Service Shipment Item Line")
                {
                    DataItemLink = "Service Price Group Code"=field("Service Price Group Code");
                    DataItemTableView = sorting("Service Price Group Code","Adjustment Type","Base Amount to Adjust","Customer No.");
                    RequestFilterFields = "Customer No.";
                    column(ReportForNavId_2078; 2078)
                    {
                    }
                    column(CustNo_ServShpItemLine;"Customer No.")
                    {
                    }
                    column(CustomerName;Customer.Name)
                    {
                    }
                    column(TotalCaption;TotalCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        UsageAmt := 0;
                        InvoiceAmt := 0;
                        DiscountAmt := 0;
                        CostAmt := 0;
                        ProfitPct := 0;
                        ProfitAmt := 0;

                        if not Customer.Get("Customer No.") then
                          Customer.Name := '';
                        SetRange("Customer No.","Customer No.");
                        repeat
                          GetServShipmentHeader;
                          if NewHeader then begin
                            ServLedgerEntry.Reset;
                            ServLedgerEntry.SetCurrentkey(
                              "Service Order No.",
                              "Service Item No. (Serviced)",
                              "Entry Type",
                              "Moved from Prepaid Acc.",
                              "Posting Date",
                              Open,
                              Type);
                            ServLedgerEntry.SetRange("Service Order No.",ServShipmentHeader."Order No.");
                            ServLedgerEntry.SetRange("Entry Type",ServLedgerEntry."entry type"::Usage);
                            ServLedgerEntry.SetRange("Posting Date",ServShipmentHeader."Posting Date");
                            ServLedgerEntry.CalcSums("Amount (LCY)");
                            UsageAmt += ServLedgerEntry."Amount (LCY)";
                          end;
                          ServInvHeader.Reset;
                          ServInvHeader.SetCurrentkey("Order No.");
                          ServInvHeader.SetRange("Order No.",ServShipmentHeader."Order No.");
                          if ServInvHeader.Find('-') then
                            repeat
                              with ServInvLine do begin
                                Reset;
                                SetCurrentkey("Document No.","Service Item Line No.",Type,"No.");
                                SetRange("Document No.",ServInvHeader."No.");
                                SetRange("Service Item Line No.","Service Shipment Item Line"."Line No.");
                                if Find('-') then
                                  repeat
                                    CostAmt += ROUND("Unit Cost (LCY)" * Quantity,Currency."Amount Rounding Precision");
                                    InvoiceAmt += CurrExchRate.ExchangeAmtFCYToLCY(
                                        ServShipmentHeader."Posting Date",
                                        ServShipmentHeader."Currency Code",
                                        ROUND("Unit Price" * Quantity,Currency."Amount Rounding Precision"),
                                        ServShipmentHeader."Currency Factor");
                                    DiscountAmt += CurrExchRate.ExchangeAmtFCYToLCY(
                                        ServShipmentHeader."Posting Date",
                                        ServShipmentHeader."Currency Code",
                                        "Line Discount Amount",
                                        ServShipmentHeader."Currency Factor");
                                  until Next = 0;
                              end;
                            until ServInvHeader.Next = 0;

                        until Next = 0;
                        SetRange("Customer No.");

                        ProfitAmt := InvoiceAmt - CostAmt;
                        if InvoiceAmt <> 0 then
                          ProfitPct := ROUND(ProfitAmt * 100 / InvoiceAmt,0.00001)
                        else
                          ProfitPct := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CurrReport.CreateTotals(UsageAmt,InvoiceAmt,DiscountAmt,CostAmt,ProfitAmt);
                    end;
                }

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(UsageAmt,InvoiceAmt,DiscountAmt,CostAmt,ProfitAmt);
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(UsageAmt,InvoiceAmt,DiscountAmt,CostAmt,ProfitAmt);
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
    var
        CaptionManagement: Codeunit "Caption Class";
    begin
        Currency.InitRoundingPrecision;
        ServPriceGrFilter := "Service Price Group".GetFilters;
        ServPriceGrSetupFilter := "Serv. Price Group Setup".GetFilters;
        CustomerFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);
    end;

    var
        CurrExchRate: Record "Currency Exchange Rate";
        Customer: Record Customer;
        ServShipmentHeader: Record "Service Shipment Header";
        ServInvHeader: Record "Service Invoice Header";
        ServInvLine: Record "Service Invoice Line";
        ServLedgerEntry: Record "Service Ledger Entry";
        Currency: Record Currency;
        ServPriceGrFilter: Text;
        ServPriceGrSetupFilter: Text;
        CustomerFilter: Text;
        UsageAmt: Decimal;
        InvoiceAmt: Decimal;
        DiscountAmt: Decimal;
        CostAmt: Decimal;
        ProfitPct: Decimal;
        ProfitAmt: Decimal;
        NewHeader: Boolean;
        PageCaptionLbl: label 'Page';
        ServicePricingProfitabilityCaptionLbl: label 'Service Pricing Profitability';
        ServicePriceGroupCodeCaptionLbl: label 'Service Price Group Code';
        TotalforGroupCaptionLbl: label 'Total for Group';
        NameCaptionLbl: label 'Name';
        UsageAmountCaptionLbl: label 'Usage Amount';
        InvoiceAmountCaptionLbl: label 'Invoice Amount';
        DiscountAmountCaptionLbl: label 'Discount Amount';
        CostAmountCaptionLbl: label 'Cost Amount';
        ProfitAmountCaptionLbl: label 'Profit Amount';
        ProfitCaptionLbl: label 'Profit %';
        TotalCaptionLbl: label 'Total';

    local procedure GetServShipmentHeader()
    begin
        NewHeader := false;
        if ServShipmentHeader."No." <> "Service Shipment Item Line"."No." then begin
          ServShipmentHeader.Get("Service Shipment Item Line"."No.");
          NewHeader := true;
        end;
    end;
}

