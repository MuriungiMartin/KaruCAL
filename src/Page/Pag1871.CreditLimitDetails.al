#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1871 "Credit Limit Details"
{
    Caption = 'Details';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                ToolTip = 'Specifies the number of the customer.';
            }
            field(Name;Name)
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                ToolTip = 'Specifies the customer''s name.';
            }
            field("Balance (LCY)";"Balance (LCY)")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';

                trigger OnDrillDown()
                begin
                    OpenCustomerLedgerEntries(false);
                end;
            }
            field(OrderAmountTotalLCY;OrderAmountTotalLCY)
            {
                ApplicationArea = Basic,Suite;
                AutoFormatType = 1;
                Caption = 'Outstanding Amt. ($)';
                Editable = false;
                ToolTip = 'Specifies the amount on sales to the customer that remains to be shipped. The amount is calculated as Amount x Outstanding Quantity / Quantity.';
            }
            field(ShippedRetRcdNotIndLCY;ShippedRetRcdNotIndLCY)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Shipped/Ret. Rcd. Not Invd. ($)';
                Editable = false;
                ToolTip = 'Specifies the amount on sales returns from the customer that are not yet refunded';
            }
            field(OrderAmountThisOrderLCY;OrderAmountThisOrderLCY)
            {
                ApplicationArea = Basic,Suite;
                AutoFormatType = 1;
                Caption = 'Current Amount ($)';
                Editable = false;
                ToolTip = 'Specifies the total amount the whole sales document.';
            }
            field(CustCreditAmountLCY;CustCreditAmountLCY)
            {
                ApplicationArea = Basic,Suite;
                AutoFormatType = 1;
                Caption = 'Total Amount ($)';
                Editable = false;
                ToolTip = 'Specifies the sum of the amounts in all of the preceding fields in the window.';
            }
            field("Credit Limit (LCY)";"Credit Limit (LCY)")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
            }
            field("Balance Due (LCY)";"Balance Due (LCY)")
            {
                ApplicationArea = Basic,Suite;
                CaptionClass = FORMAT(STRSUBSTNO(OverdueAmountsTxt,FORMAT(GETRANGEMAX("Date Filter"))));
                Editable = false;
                ToolTip = 'Specifies payments from the customer that are overdue per today''s date.';

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
                ApplicationArea = Basic,Suite;
                Caption = 'Invoiced Prepayment Amount ($)';
                Editable = false;
                ToolTip = 'Specifies your sales income from the customer based on invoiced prepayments.';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if GetFilter("Date Filter") = '' then
          SetFilter("Date Filter",'..%1',WorkDate);
        CalcFields("Balance (LCY)","Shipped Not Invoiced (LCY)","Serv Shipped Not Invoiced(LCY)");
    end;

    var
        OrderAmountTotalLCY: Decimal;
        ShippedRetRcdNotIndLCY: Decimal;
        OrderAmountThisOrderLCY: Decimal;
        CustCreditAmountLCY: Decimal;
        OverdueAmountsTxt: label 'Overdue Amounts ($) as of %1', Comment='%1=Date on which the amounts arebeing calculated.';


    procedure PopulateDataOnNotification(var CreditLimitNotification: Notification)
    begin
        CreditLimitNotification.SetData(FieldName("No."),Format("No."));
        CreditLimitNotification.SetData('OrderAmountTotalLCY',Format(OrderAmountTotalLCY));
        CreditLimitNotification.SetData('ShippedRetRcdNotIndLCY',Format(ShippedRetRcdNotIndLCY));
        CreditLimitNotification.SetData('OrderAmountThisOrderLCY',Format(OrderAmountThisOrderLCY));
        CreditLimitNotification.SetData('CustCreditAmountLCY',Format(CustCreditAmountLCY));
    end;


    procedure InitializeFromNotificationVar(CreditLimitNotification: Notification)
    var
        Customer: Record Customer;
    begin
        Get(CreditLimitNotification.GetData(Customer.FieldName("No.")));
        SetRange("No.","No.");

        if GetFilter("Date Filter") = '' then
          SetFilter("Date Filter",'..%1',WorkDate);
        CalcFields("Balance (LCY)","Shipped Not Invoiced (LCY)","Serv Shipped Not Invoiced(LCY)");

        Evaluate(OrderAmountTotalLCY,CreditLimitNotification.GetData('OrderAmountTotalLCY'));
        Evaluate(ShippedRetRcdNotIndLCY,CreditLimitNotification.GetData('ShippedRetRcdNotIndLCY'));
        Evaluate(OrderAmountThisOrderLCY,CreditLimitNotification.GetData('OrderAmountThisOrderLCY'));
        Evaluate(CustCreditAmountLCY,CreditLimitNotification.GetData('CustCreditAmountLCY'));
    end;


    procedure SetCustomerNumber(Value: Code[20])
    begin
        Get(Value);
    end;


    procedure SetOrderAmountTotalLCY(Value: Decimal)
    begin
        OrderAmountTotalLCY := Value;
    end;


    procedure SetShippedRetRcdNotIndLCY(Value: Decimal)
    begin
        ShippedRetRcdNotIndLCY := Value;
    end;


    procedure SetOrderAmountThisOrderLCY(Value: Decimal)
    begin
        OrderAmountThisOrderLCY := Value;
    end;


    procedure SetCustCreditAmountLCY(Value: Decimal)
    begin
        CustCreditAmountLCY := Value;
    end;
}

