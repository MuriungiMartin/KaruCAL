#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 151 "Customer Statistics"
{
    Caption = 'Customer Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales.';

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SetRange("Customer No.","No.");
                        Copyfilter("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        Copyfilter("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        Copyfilter("Currency Filter",DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                group(Sales)
                {
                    Caption = 'Sales';
                    field("Outstanding Orders (LCY)";"Outstanding Orders (LCY)")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies your expected sales income from the customer in $ based on ongoing sales orders.';
                    }
                    field("Shipped Not Invoiced (LCY)";"Shipped Not Invoiced (LCY)")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies your expected sales income from the customer based on ongoing sales orders where items have been shipped.';
                    }
                    field("Outstanding Invoices (LCY)";"Outstanding Invoices (LCY)")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies your expected sales income from the customer in $ based on unpaid sales invoices.';
                    }
                }
                group(Service)
                {
                    Caption = 'Service';
                    field("Outstanding Serv. Orders (LCY)";"Outstanding Serv. Orders (LCY)")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies your expected service income from the customer in $ based on ongoing service orders.';
                    }
                    field("Serv Shipped Not Invoiced(LCY)";"Serv Shipped Not Invoiced(LCY)")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies your expected service income from the customer in $ based on service orders that are shipped but not invoiced.';
                    }
                    field("Outstanding Serv.Invoices(LCY)";"Outstanding Serv.Invoices(LCY)")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies your expected service income from the customer in $ based on unpaid service invoices.';
                    }
                }
                field(GetTotalAmountLCY;GetTotalAmountLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Total ($)';
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales plus sales that are still ongoing.';
                }
                field("Credit Limit (LCY)";"Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
                }
                field("Balance Due (LCY)";CalcOverdueBalance)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(STRSUBSTNO(Text000,FORMAT(CurrentDate)));

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SetFilter("Customer No.","No.");
                        Copyfilter("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        Copyfilter("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        Copyfilter("Currency Filter",DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                    end;
                }
                field(GetInvoicedPrepmtAmountLCY;GetInvoicedPrepmtAmountLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Prepayment Amount ($)';
                    ToolTip = 'Specifies your sales income from the customer based on invoiced prepayments.';
                }
            }
            group(Control1904305601)
            {
                Caption = 'Sales';
                fixed(Control1904230801)
                {
                    group("This Period")
                    {
                        Caption = 'This Period';
                        field("CustDateName[1]";CustDateName[1])
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                        field("CustSalesLCY[1]";CustSalesLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Sales ($)';
                            ToolTip = 'Specifies your total sales turnover in the fiscal year.';
                        }
                        field("CustSalesLCY[1] - CustProfit[1]";CustSalesLCY[1] - CustProfit[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Costs ($)';
                            ToolTip = 'Specifies the original costs that were associated with the sales when they were originally posted.';
                        }
                        field("CustProfit[1]";CustProfit[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Profit ($)';
                            ToolTip = 'Specifies the original profit that was associated with the sales when they were originally posted.';
                        }
                        field("ProfitPct[1]";ProfitPct[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Original Profit %';
                            DecimalPlaces = 1:1;
                            ToolTip = 'Specifies the original percentage of profit that was associated with the sales when they were originally posted.';
                        }
                        field("CustSalesLCY[1] - CustProfit[1] - AdjmtCostLCY[1]";CustSalesLCY[1] - CustProfit[1] - AdjmtCostLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Costs ($)';
                            ToolTip = 'Specifies the costs that have been adjusted for changes in the purchase prices of the goods.';
                        }
                        field("AdjCustProfit[1]";AdjCustProfit[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Profit ($)';
                            ToolTip = 'Specifies the profit, taking into consideration changes in the purchase prices of the goods.';
                        }
                        field("AdjProfitPct[1]";AdjProfitPct[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjusted Profit %';
                            DecimalPlaces = 1:1;
                            ToolTip = 'Specifies the percentage of profit for all sales, including changes that occurred in the purchase prices of the goods.';
                        }
                        field("-AdjmtCostLCY[1]";-AdjmtCostLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cost Adjmt. Amounts ($)';
                            ToolTip = 'Specifies the sum of the differences between original costs of the goods and the adjusted costs.';
                        }
                        field("CustInvDiscAmountLCY[1]";CustInvDiscAmountLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Discounts ($)';
                            ToolTip = 'Specifies the sum of invoice discount amounts granted the customer.';
                        }
                        field("InvAmountsLCY[1]";InvAmountsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been invoiced to the customer.';
                        }
                        field("CustReminderChargeAmtLCY[1]";CustReminderChargeAmtLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Reminder Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that the customer has been reminded to pay.';
                        }
                        field("CustFinChargeAmtLCY[1]";CustFinChargeAmtLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Fin. Charges ($)';
                            ToolTip = 'Specifies the sum of amounts that the customer has been charged on finance charge memos.';
                        }
                        field("CustCrMemoAmountsLCY[1]";CustCrMemoAmountsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cr. Memo Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been refunded to the customer.';
                        }
                        field("CustPaymentsLCY[1]";CustPaymentsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payments ($)';
                            ToolTip = 'Specifies the sum of payments received from the customer in the current fiscal year.';
                        }
                        field("CustRefundsLCY[1]";CustRefundsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Refunds ($)';
                            ToolTip = 'Specifies the sum of refunds paid to the customer.';
                        }
                        field("CustOtherAmountsLCY[1]";CustOtherAmountsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Other Amounts ($)';
                            ToolTip = 'Specifies the sum of other amounts for the customer.';
                        }
                        field("CustPaymentDiscLCY[1]";CustPaymentDiscLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Discounts ($)';
                            ToolTip = 'Specifies the sum of payment discounts granted to the customer.';
                        }
                        field("CustPaymentDiscTolLCY[1]";CustPaymentDiscTolLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Tol. ($)';
                            ToolTip = 'Specifies the sum of payment discount tolerance for the customer.';
                        }
                        field("CustPaymentTolLCY[1]";CustPaymentTolLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Tolerances ($)';
                            ToolTip = 'Specifies the sum of payment tolerance for the customer.';
                        }
                    }
                    group("This Year")
                    {
                        Caption = 'This Year';
                        field(Text001;Text001)
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field("CustSalesLCY[2]";CustSalesLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Sales ($)';
                            ToolTip = 'Specifies your total sales turnover in the fiscal year.';
                        }
                        field("CustSalesLCY[2] - CustProfit[2]";CustSalesLCY[2] - CustProfit[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Costs ($)';
                            ToolTip = 'Specifies the original costs that were associated with the sales when they were originally posted.';
                        }
                        field("CustProfit[2]";CustProfit[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Profit ($)';
                            ToolTip = 'Specifies the original profit that was associated with the sales when they were originally posted.';
                        }
                        field("ProfitPct[2]";ProfitPct[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Original Profit %';
                            DecimalPlaces = 1:1;
                            ToolTip = 'Specifies the original percentage of profit that was associated with the sales when they were originally posted.';
                        }
                        field("CustSalesLCY[2] - CustProfit[2] - AdjmtCostLCY[2]";CustSalesLCY[2] - CustProfit[2] - AdjmtCostLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Costs ($)';
                            ToolTip = 'Specifies the costs that have been adjusted for changes in the purchase prices of the goods.';
                        }
                        field("AdjCustProfit[2]";AdjCustProfit[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Profit ($)';
                            ToolTip = 'Specifies the profit, taking into consideration changes in the purchase prices of the goods.';
                        }
                        field("AdjProfitPct[2]";AdjProfitPct[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjusted Profit %';
                            DecimalPlaces = 1:1;
                            ToolTip = 'Specifies the percentage of profit for all sales, including changes that occurred in the purchase prices of the goods.';
                        }
                        field("-AdjmtCostLCY[2]";-AdjmtCostLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjustment Costs ($)';
                            ToolTip = 'Specifies the sum of adjustment amounts.';
                        }
                        field("CustInvDiscAmountLCY[2]";CustInvDiscAmountLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Discounts ($)';
                            ToolTip = 'Specifies the sum of invoice discount amounts granted the customer.';
                        }
                        field("InvAmountsLCY[2]";InvAmountsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been invoiced to the customer.';
                        }
                        field("CustReminderChargeAmtLCY[2]";CustReminderChargeAmtLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Reminder Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that the customer has been reminded to pay.';
                        }
                        field("CustFinChargeAmtLCY[2]";CustFinChargeAmtLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Fin. Charges ($)';
                            ToolTip = 'Specifies the sum of amounts that the customer has been charged on finance charge memos.';
                        }
                        field("CustCrMemoAmountsLCY[2]";CustCrMemoAmountsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cr. Memo Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been refunded to the customer.';
                        }
                        field("CustPaymentsLCY[2]";CustPaymentsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payments ($)';
                            ToolTip = 'Specifies the sum of payments received from the customer in the current fiscal year.';
                        }
                        field("CustRefundsLCY[2]";CustRefundsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Refunds ($)';
                            ToolTip = 'Specifies the sum of refunds paid to the customer.';
                        }
                        field("CustOtherAmountsLCY[2]";CustOtherAmountsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Other Amounts ($)';
                            ToolTip = 'Specifies the sum of other amounts for the customer.';
                        }
                        field("CustPaymentDiscLCY[2]";CustPaymentDiscLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Discounts ($)';
                            ToolTip = 'Specifies the sum of payment discounts granted to the customer.';
                        }
                        field("CustPaymentDiscTolLCY[2]";CustPaymentDiscTolLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Tolerance ($)';
                            ToolTip = 'Specifies the sum of payment discount tolerance for the customer.';
                        }
                        field("CustPaymentTolLCY[2]";CustPaymentTolLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payment Tolerances ($)';
                            ToolTip = 'Specifies the sum of payment tolerance for the customer.';
                        }
                    }
                    group("Last Year")
                    {
                        Caption = 'Last Year';
                        field(Control122;Text001)
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field("CustSalesLCY[3]";CustSalesLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Sales ($)';
                            ToolTip = 'Specifies your total sales turnover in the fiscal year.';
                        }
                        field("CustSalesLCY[3] - CustProfit[3]";CustSalesLCY[3] - CustProfit[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Costs ($)';
                            ToolTip = 'Specifies the original costs that were associated with the sales when they were originally posted.';
                        }
                        field("CustProfit[3]";CustProfit[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Profit ($)';
                            ToolTip = 'Specifies the original profit that was associated with the sales when they were originally posted.';
                        }
                        field("ProfitPct[3]";ProfitPct[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Original Profit %';
                            DecimalPlaces = 1:1;
                            ToolTip = 'Specifies the original percentage of profit that was associated with the sales when they were originally posted.';
                        }
                        field("CustSalesLCY[3] - CustProfit[3] - AdjmtCostLCY[3]";CustSalesLCY[3] - CustProfit[3] - AdjmtCostLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Costs ($)';
                            ToolTip = 'Specifies the costs that have been adjusted for changes in the purchase prices of the goods.';
                        }
                        field("AdjCustProfit[3]";AdjCustProfit[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Profit ($)';
                            ToolTip = 'Specifies the profit, taking into consideration changes in the purchase prices of the goods.';
                        }
                        field("AdjProfitPct[3]";AdjProfitPct[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjusted Profit %';
                            DecimalPlaces = 1:1;
                            ToolTip = 'Specifies the percentage of profit for all sales, including changes that occurred in the purchase prices of the goods.';
                        }
                        field("-AdjmtCostLCY[3]";-AdjmtCostLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjustment Costs ($)';
                            ToolTip = 'Specifies the sum of adjustment amounts.';
                        }
                        field("CustInvDiscAmountLCY[3]";CustInvDiscAmountLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Discounts ($)';
                            ToolTip = 'Specifies the sum of invoice discount amounts granted the customer.';
                        }
                        field("InvAmountsLCY[3]";InvAmountsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been invoiced to the customer.';
                        }
                        field("CustReminderChargeAmtLCY[3]";CustReminderChargeAmtLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Reminder Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that the customer has been reminded to pay.';
                        }
                        field("CustFinChargeAmtLCY[3]";CustFinChargeAmtLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Fin. Charges ($)';
                            ToolTip = 'Specifies the sum of amounts that the customer has been charged on finance charge memos.';
                        }
                        field("CustCrMemoAmountsLCY[3]";CustCrMemoAmountsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cr. Memo Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been refunded to the customer.';
                        }
                        field("CustPaymentsLCY[3]";CustPaymentsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payments ($)';
                            ToolTip = 'Specifies the sum of payments received from the customer in the current fiscal year.';
                        }
                        field("CustRefundsLCY[3]";CustRefundsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Refunds ($)';
                            ToolTip = 'Specifies the sum of refunds paid to the customer.';
                        }
                        field("CustOtherAmountsLCY[3]";CustOtherAmountsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Other Amounts ($)';
                            ToolTip = 'Specifies the sum of other amounts for the customer.';
                        }
                        field("CustPaymentDiscLCY[3]";CustPaymentDiscLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Discounts ($)';
                            ToolTip = 'Specifies the sum of payment discounts granted to the customer.';
                        }
                        field("CustPaymentDiscTolLCY[3]";CustPaymentDiscTolLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Tolerance ($)';
                            ToolTip = 'Specifies the sum of payment discount tolerance for the customer.';
                        }
                        field("CustPaymentTolLCY[3]";CustPaymentTolLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payment Tolerances ($)';
                            ToolTip = 'Specifies the sum of payment tolerance for the customer.';
                        }
                    }
                    group("To Date")
                    {
                        Caption = 'To Date';
                        field(Control123;Text001)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field("CustSalesLCY[4]";CustSalesLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Sales ($)';
                            ToolTip = 'Specifies your total sales turnover in the fiscal year.';
                        }
                        field("CustSalesLCY[4] - CustProfit[4]";CustSalesLCY[4] - CustProfit[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Costs ($)';
                            ToolTip = 'Specifies the original costs that were associated with the sales when they were originally posted.';
                        }
                        field("CustProfit[4]";CustProfit[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Original Profit ($)';
                            ToolTip = 'Specifies the original profit that was associated with the sales when they were originally posted.';
                        }
                        field("ProfitPct[4]";ProfitPct[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Original Profit %';
                            DecimalPlaces = 1:1;
                            ToolTip = 'Specifies the original percentage of profit that was associated with the sales when they were originally posted.';
                        }
                        field("CustSalesLCY[4] - CustProfit[4] - AdjmtCostLCY[4]";CustSalesLCY[4] - CustProfit[4] - AdjmtCostLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Costs ($)';
                            ToolTip = 'Specifies the costs that have been adjusted for changes in the purchase prices of the goods.';
                        }
                        field("AdjCustProfit[4]";AdjCustProfit[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjusted Profit ($)';
                            ToolTip = 'Specifies the profit, taking into consideration changes in the purchase prices of the goods.';
                        }
                        field("AdjProfitPct[4]";AdjProfitPct[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjusted Profit %';
                            DecimalPlaces = 1:1;
                            ToolTip = 'Specifies the percentage of profit for all sales, including changes that occurred in the purchase prices of the goods.';
                        }
                        field("-AdjmtCostLCY[4]";-AdjmtCostLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Adjustment Costs ($)';
                            ToolTip = 'Specifies the sum of adjustment amounts.';
                        }
                        field("CustInvDiscAmountLCY[4]";CustInvDiscAmountLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Discounts ($)';
                            ToolTip = 'Specifies the sum of invoice discount amounts granted the customer.';
                        }
                        field("InvAmountsLCY[4]";InvAmountsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been invoiced to the customer.';
                        }
                        field("CustReminderChargeAmtLCY[4]";CustReminderChargeAmtLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Reminder Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that the customer has been reminded to pay.';
                        }
                        field("CustFinChargeAmtLCY[4]";CustFinChargeAmtLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Fin. Charges ($)';
                            ToolTip = 'Specifies the sum of amounts that the customer has been charged on finance charge memos.';
                        }
                        field("CustCrMemoAmountsLCY[4]";CustCrMemoAmountsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cr. Memo Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been refunded to the customer.';
                        }
                        field("CustPaymentsLCY[4]";CustPaymentsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payments ($)';
                            ToolTip = 'Specifies the sum of payments received from the customer in the current fiscal year.';
                        }
                        field("CustRefundsLCY[4]";CustRefundsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Refunds ($)';
                            ToolTip = 'Specifies the sum of refunds paid to the customer.';
                        }
                        field("CustOtherAmountsLCY[4]";CustOtherAmountsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Other Amounts ($)';
                            ToolTip = 'Specifies the sum of other amounts for the customer.';
                        }
                        field("CustPaymentDiscLCY[4]";CustPaymentDiscLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Discounts ($)';
                            ToolTip = 'Specifies the sum of payment discounts granted to the customer.';
                        }
                        field("CustPaymentDiscTolLCY[4]";CustPaymentDiscTolLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Tolerance ($)';
                            ToolTip = 'Specifies the sum of payment discount tolerance for the customer.';
                        }
                        field("CustPaymentTolLCY[4]";CustPaymentTolLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payment Tolerances ($)';
                            ToolTip = 'Specifies the sum of payment tolerance for the customer.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CostCalcMgt: Codeunit "Cost Calculation Management";
    begin
        if CurrentDate <> WorkDate then begin
          CurrentDate := WorkDate;
          DateFilterCalc.CreateAccountingPeriodFilter(CustDateFilter[1],CustDateName[1],CurrentDate,0);
          DateFilterCalc.CreateFiscalYearFilter(CustDateFilter[2],CustDateName[2],CurrentDate,0);
          DateFilterCalc.CreateFiscalYearFilter(CustDateFilter[3],CustDateName[3],CurrentDate,-1);
        end;

        SetRange("Date Filter",0D,CurrentDate);

        for i := 1 to 4 do begin
          SetFilter("Date Filter",CustDateFilter[i]);
          CalcFields(
            "Sales (LCY)","Profit (LCY)","Inv. Discounts (LCY)","Inv. Amounts (LCY)","Pmt. Discounts (LCY)",
            "Pmt. Disc. Tolerance (LCY)","Pmt. Tolerance (LCY)",
            "Fin. Charge Memo Amounts (LCY)","Cr. Memo Amounts (LCY)","Payments (LCY)",
            "Reminder Amounts (LCY)","Refunds (LCY)","Other Amounts (LCY)");
          CustSalesLCY[i] := "Sales (LCY)";
          CustProfit[i] := "Profit (LCY)" + CostCalcMgt.NonInvtblCostAmt(Rec);
          AdjmtCostLCY[i] := CustSalesLCY[i] - CustProfit[i] + CostCalcMgt.CalcCustActualCostLCY(Rec);
          AdjCustProfit[i] := CustProfit[i] + AdjmtCostLCY[i];

          if "Sales (LCY)" <> 0 then begin
            ProfitPct[i] := ROUND(100 * CustProfit[i] / "Sales (LCY)",0.1);
            AdjProfitPct[i] := ROUND(100 * AdjCustProfit[i] / "Sales (LCY)",0.1);
          end else begin
            ProfitPct[i] := 0;
            AdjProfitPct[i] := 0;
          end;

          InvAmountsLCY[i] := "Inv. Amounts (LCY)";
          CustInvDiscAmountLCY[i] := "Inv. Discounts (LCY)";
          CustPaymentDiscLCY[i] := "Pmt. Discounts (LCY)";
          CustPaymentDiscTolLCY[i] := "Pmt. Disc. Tolerance (LCY)";
          CustPaymentTolLCY[i] := "Pmt. Tolerance (LCY)";
          CustReminderChargeAmtLCY[i] := "Reminder Amounts (LCY)";
          CustFinChargeAmtLCY[i] := "Fin. Charge Memo Amounts (LCY)";
          CustCrMemoAmountsLCY[i] := "Cr. Memo Amounts (LCY)";
          CustPaymentsLCY[i] := "Payments (LCY)";
          CustRefundsLCY[i] := "Refunds (LCY)";
          CustOtherAmountsLCY[i] := "Other Amounts (LCY)";
        end;
        SetRange("Date Filter",0D,CurrentDate);
    end;

    var
        Text000: label 'Overdue Amounts ($) as of %1';
        DateFilterCalc: Codeunit "DateFilter-Calc";
        CustDateFilter: array [4] of Text[30];
        CustDateName: array [4] of Text[30];
        CurrentDate: Date;
        CustSalesLCY: array [4] of Decimal;
        AdjmtCostLCY: array [4] of Decimal;
        CustProfit: array [4] of Decimal;
        ProfitPct: array [4] of Decimal;
        AdjCustProfit: array [4] of Decimal;
        AdjProfitPct: array [4] of Decimal;
        CustInvDiscAmountLCY: array [4] of Decimal;
        CustPaymentDiscLCY: array [4] of Decimal;
        CustPaymentDiscTolLCY: array [4] of Decimal;
        CustPaymentTolLCY: array [4] of Decimal;
        CustReminderChargeAmtLCY: array [4] of Decimal;
        CustFinChargeAmtLCY: array [4] of Decimal;
        CustCrMemoAmountsLCY: array [4] of Decimal;
        CustPaymentsLCY: array [4] of Decimal;
        CustRefundsLCY: array [4] of Decimal;
        CustOtherAmountsLCY: array [4] of Decimal;
        i: Integer;
        InvAmountsLCY: array [4] of Decimal;
        Text001: label 'Placeholder';
}

