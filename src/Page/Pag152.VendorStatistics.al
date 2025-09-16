#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 152 "Vendor Statistics"
{
    Caption = 'Vendor Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = Vendor;

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
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year.';

                    trigger OnDrillDown()
                    var
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                    begin
                        DtldVendLedgEntry.SetRange("Vendor No.","No.");
                        Copyfilter("Global Dimension 1 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 1");
                        Copyfilter("Global Dimension 2 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 2");
                        Copyfilter("Currency Filter",DtldVendLedgEntry."Currency Code");
                        VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
                    end;
                }
                field("Outstanding Orders (LCY)";"Outstanding Orders (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of outstanding orders (in $) to this vendor.';
                }
                field("Amt. Rcd. Not Invoiced (LCY)";"Amt. Rcd. Not Invoiced (LCY)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amt. Rcd. Not Invd. ($)';
                    ToolTip = 'Specifies the total invoice amount (in $) for the items you have received but not yet been invoiced for.';
                }
                field("Outstanding Invoices (LCY)";"Outstanding Invoices (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of the vendor''s outstanding purchase invoices in $.';
                }
                field(GetTotalAmountLCY;GetTotalAmountLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Total ($)';
                    ToolTip = 'Specifies the payment amount that you owe the vendor for completed purchases plus purchases that are still ongoing.';
                }
                field("Balance Due (LCY)";CalcOverDueBalance)
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(STRSUBSTNO(Text000,FORMAT(CurrentDate)));

                    trigger OnDrillDown()
                    var
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                    begin
                        DtldVendLedgEntry.SetFilter("Vendor No.","No.");
                        Copyfilter("Global Dimension 1 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 1");
                        Copyfilter("Global Dimension 2 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 2");
                        Copyfilter("Currency Filter",DtldVendLedgEntry."Currency Code");
                        VendLedgEntry.DrillDownOnOverdueEntries(DtldVendLedgEntry);
                    end;
                }
                field(GetInvoicedPrepmtAmountLCY;GetInvoicedPrepmtAmountLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced Prepayment Amount ($)';
                    ToolTip = 'Specifies your payments to the vendor based on invoiced prepayments.';
                }
            }
            group(Purchases)
            {
                Caption = 'Purchases';
                fixed(Control1904230801)
                {
                    group("This Period")
                    {
                        Caption = 'This Period';
                        field("VendDateName[1]";VendDateName[1])
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                        field("VendPurchLCY[1]";VendPurchLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Purchase ($)';
                            ToolTip = 'Specifies your total purchases.';
                        }
                        field("VendInvDiscAmountLCY[1]";VendInvDiscAmountLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Discount ($)';
                            ToolTip = 'specifies the sum of invoice discounts that the vendor has granted to you.';
                        }
                        field("InvAmountsLCY[1]";InvAmountsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been invoiced to the vendor.';
                        }
                        field("VendReminderChargeAmtLCY[1]";VendReminderChargeAmtLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Reminder Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts the vendor has reminded you of.';
                        }
                        field("VendFinChargeAmtLCY[1]";VendFinChargeAmtLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Fin. Charges ($)';
                            ToolTip = 'Specifies the sum of amounts that the vendor has charged on finance charge memos.';
                        }
                        field("VendCrMemoAmountsLCY[1]";VendCrMemoAmountsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cr. Memo Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that the vendor has refunded you.';
                        }
                        field("VendPaymentsLCY[1]";VendPaymentsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payments ($)';
                            ToolTip = 'Specifies the sum of payments made to the vendor in the current fiscal year.';
                        }
                        field("VendRefundsLCY[1]";VendRefundsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Refunds ($)';
                            ToolTip = 'Specifies the sum of refunds received from the vendor.';
                        }
                        field("VendOtherAmountsLCY[1]";VendOtherAmountsLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Other Amounts ($)';
                            ToolTip = 'Specifies the sum of other amounts for the vendor';
                        }
                        field("VendPaymentDiscLCY[1]";VendPaymentDiscLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Discounts ($)';
                            ToolTip = 'Specifies the sum of payment discounts the vendor has granted to you.';
                        }
                        field("VendPaymentDiscTolLCY[1]";VendPaymentDiscTolLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Tol. ($)';
                            ToolTip = 'Specifies the sum of payment discount tolerance from the vendor.';
                        }
                        field("VendPaymentTolLCY[1]";VendPaymentTolLCY[1])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Tolerances ($)';
                            ToolTip = 'Specifies the sum of payment tolerance from the vendor.';
                        }
                    }
                    group("This Year")
                    {
                        Caption = 'This Year';
                        field(Text001;Text001)
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                        field("VendPurchLCY[2]";VendPurchLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Purchase ($)';
                            ToolTip = 'Specifies your total purchases.';
                        }
                        field("VendInvDiscAmountLCY[2]";VendInvDiscAmountLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Discount ($)';
                            ToolTip = 'specifies the sum of invoice discounts that the vendor has granted to you.';
                        }
                        field("InvAmountsLCY[2]";InvAmountsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been invoiced to the vendor.';
                        }
                        field("VendReminderChargeAmtLCY[2]";VendReminderChargeAmtLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Reminder Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts the vendor has reminded you of.';
                        }
                        field("VendFinChargeAmtLCY[2]";VendFinChargeAmtLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Fin. Charges ($)';
                            ToolTip = 'Specifies the sum of amounts that the vendor has charged on finance charge memos.';
                        }
                        field("VendCrMemoAmountsLCY[2]";VendCrMemoAmountsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cr. Memo Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that the vendor has refunded you.';
                        }
                        field("VendPaymentsLCY[2]";VendPaymentsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payments ($)';
                            ToolTip = 'Specifies the sum of payments made to the vendor in the current fiscal year.';
                        }
                        field("VendRefundsLCY[2]";VendRefundsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Refunds ($)';
                            ToolTip = 'Specifies the sum of refunds received from the vendor.';
                        }
                        field("VendOtherAmountsLCY[2]";VendOtherAmountsLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Other Amounts ($)';
                            ToolTip = 'Specifies the sum of other amounts for the vendor';
                        }
                        field("VendPaymentDiscLCY[2]";VendPaymentDiscLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Discounts ($)';
                            ToolTip = 'Specifies the sum of payment discounts the vendor has granted to you.';
                        }
                        field("VendPaymentDiscTolLCY[2]";VendPaymentDiscTolLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Tol. ($)';
                            ToolTip = 'Specifies the sum of payment discount tolerance from the vendor.';
                        }
                        field("VendPaymentTolLCY[2]";VendPaymentTolLCY[2])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Tolerances ($)';
                            ToolTip = 'Specifies the sum of payment tolerance from the vendor.';
                        }
                    }
                    group("Last Year")
                    {
                        Caption = 'Last Year';
                        field(Control81;Text001)
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                        field("VendPurchLCY[3]";VendPurchLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Purchase ($)';
                            ToolTip = 'Specifies your total purchases.';
                        }
                        field("VendInvDiscAmountLCY[3]";VendInvDiscAmountLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Discount ($)';
                            ToolTip = 'specifies the sum of invoice discounts that the vendor has granted to you.';
                        }
                        field("InvAmountsLCY[3]";InvAmountsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been invoiced to the vendor.';
                        }
                        field("VendReminderChargeAmtLCY[3]";VendReminderChargeAmtLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Reminder Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts the vendor has reminded you of.';
                        }
                        field("VendFinChargeAmtLCY[3]";VendFinChargeAmtLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Fin. Charges ($)';
                            ToolTip = 'Specifies the sum of amounts that the vendor has charged on finance charge memos.';
                        }
                        field("VendCrMemoAmountsLCY[3]";VendCrMemoAmountsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cr. Memo Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that the vendor has refunded you.';
                        }
                        field("VendPaymentsLCY[3]";VendPaymentsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payments ($)';
                            ToolTip = 'Specifies the sum of payments made to the vendor in the current fiscal year.';
                        }
                        field("VendRefundsLCY[3]";VendRefundsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Refunds ($)';
                            ToolTip = 'Specifies the sum of refunds received from the vendor.';
                        }
                        field("VendOtherAmountsLCY[3]";VendOtherAmountsLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Other Amounts ($)';
                            ToolTip = 'Specifies the sum of other amounts for the vendor';
                        }
                        field("VendPaymentDiscLCY[3]";VendPaymentDiscLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Discounts ($)';
                            ToolTip = 'Specifies the sum of payment discounts the vendor has granted to you.';
                        }
                        field("VendPaymentDiscTolLCY[3]";VendPaymentDiscTolLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Tol. ($)';
                            ToolTip = 'Specifies the sum of payment discount tolerance from the vendor.';
                        }
                        field("VendPaymentTolLCY[3]";VendPaymentTolLCY[3])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Tolerances ($)';
                            ToolTip = 'Specifies the sum of payment tolerance from the vendor.';
                        }
                    }
                    group("To Date")
                    {
                        Caption = 'To Date';
                        field(Control82;Text001)
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                        field("VendPurchLCY[4]";VendPurchLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Purchase ($)';
                            ToolTip = 'Specifies your total purchases.';
                        }
                        field("VendInvDiscAmountLCY[4]";VendInvDiscAmountLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Discount ($)';
                            ToolTip = 'specifies the sum of invoice discounts that the vendor has granted to you.';
                        }
                        field("InvAmountsLCY[4]";InvAmountsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Inv. Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that have been invoiced to the vendor.';
                        }
                        field("VendReminderChargeAmtLCY[4]";VendReminderChargeAmtLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Reminder Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts the vendor has reminded you of.';
                        }
                        field("VendFinChargeAmtLCY[4]";VendFinChargeAmtLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Fin. Charges ($)';
                            ToolTip = 'Specifies the sum of amounts that the vendor has charged on finance charge memos.';
                        }
                        field("VendCrMemoAmountsLCY[4]";VendCrMemoAmountsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Cr. Memo Amounts ($)';
                            ToolTip = 'Specifies the sum of amounts that the vendor has refunded you.';
                        }
                        field("VendPaymentsLCY[4]";VendPaymentsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Payments ($)';
                            ToolTip = 'Specifies the sum of payments made to the vendor in the current fiscal year.';
                        }
                        field("VendRefundsLCY[4]";VendRefundsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Refunds ($)';
                            ToolTip = 'Specifies the sum of refunds received from the vendor.';
                        }
                        field("VendOtherAmountsLCY[4]";VendOtherAmountsLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Other Amounts ($)';
                            ToolTip = 'Specifies the sum of other amounts for the vendor';
                        }
                        field("VendPaymentDiscLCY[4]";VendPaymentDiscLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Discounts ($)';
                            ToolTip = 'Specifies the sum of payment discounts the vendor has granted to you.';
                        }
                        field("VendPaymentDiscTolLCY[4]";VendPaymentDiscTolLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Tol. ($)';
                            ToolTip = 'Specifies the sum of payment discount tolerance from the vendor.';
                        }
                        field("VendPaymentTolLCY[4]";VendPaymentTolLCY[4])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Tolerances ($)';
                            ToolTip = 'Specifies the sum of payment tolerance from the vendor.';
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
    begin
        if CurrentDate <> WorkDate then begin
          CurrentDate := WorkDate;
          DateFilterCalc.CreateAccountingPeriodFilter(VendDateFilter[1],VendDateName[1],CurrentDate,0);
          DateFilterCalc.CreateFiscalYearFilter(VendDateFilter[2],VendDateName[2],CurrentDate,0);
          DateFilterCalc.CreateFiscalYearFilter(VendDateFilter[3],VendDateName[3],CurrentDate,-1);
        end;

        SetRange("Date Filter",0D,CurrentDate);

        for i := 1 to 4 do begin
          SetFilter("Date Filter",VendDateFilter[i]);
          CalcFields(
            "Purchases (LCY)","Inv. Discounts (LCY)","Inv. Amounts (LCY)","Pmt. Discounts (LCY)",
            "Pmt. Disc. Tolerance (LCY)","Pmt. Tolerance (LCY)",
            "Fin. Charge Memo Amounts (LCY)","Cr. Memo Amounts (LCY)","Payments (LCY)",
            "Reminder Amounts (LCY)","Refunds (LCY)","Other Amounts (LCY)");
          VendPurchLCY[i] := "Purchases (LCY)";
          VendInvDiscAmountLCY[i] := "Inv. Discounts (LCY)";
          InvAmountsLCY[i] := "Inv. Amounts (LCY)";
          VendPaymentDiscLCY[i] := "Pmt. Discounts (LCY)";
          VendPaymentDiscTolLCY[i] := "Pmt. Disc. Tolerance (LCY)";
          VendPaymentTolLCY[i] := "Pmt. Tolerance (LCY)";
          VendReminderChargeAmtLCY[i] := "Reminder Amounts (LCY)";
          VendFinChargeAmtLCY[i] := "Fin. Charge Memo Amounts (LCY)";
          VendCrMemoAmountsLCY[i] := "Cr. Memo Amounts (LCY)";
          VendPaymentsLCY[i] := "Payments (LCY)";
          VendRefundsLCY[i] := "Refunds (LCY)";
          VendOtherAmountsLCY[i] := "Other Amounts (LCY)";
        end;
        SetRange("Date Filter",0D,CurrentDate);
    end;

    var
        Text000: label 'Overdue Amounts ($) as of %1';
        DateFilterCalc: Codeunit "DateFilter-Calc";
        VendDateFilter: array [4] of Text[30];
        VendDateName: array [4] of Text[30];
        CurrentDate: Date;
        VendPurchLCY: array [4] of Decimal;
        VendInvDiscAmountLCY: array [4] of Decimal;
        VendPaymentDiscLCY: array [4] of Decimal;
        VendPaymentDiscTolLCY: array [4] of Decimal;
        VendPaymentTolLCY: array [4] of Decimal;
        VendReminderChargeAmtLCY: array [4] of Decimal;
        VendFinChargeAmtLCY: array [4] of Decimal;
        VendCrMemoAmountsLCY: array [4] of Decimal;
        VendPaymentsLCY: array [4] of Decimal;
        VendRefundsLCY: array [4] of Decimal;
        VendOtherAmountsLCY: array [4] of Decimal;
        i: Integer;
        InvAmountsLCY: array [4] of Decimal;
        Text001: label 'Placeholder';
}

