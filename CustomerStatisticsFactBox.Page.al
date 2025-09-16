#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9082 "Customer Statistics FactBox"
{
    Caption = 'Customer Statistics';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = All;
                Caption = 'Customer No.';
                ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                Visible = ShowCustomerNo;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("Balance (LCY)";"Balance (LCY)")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';

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
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies your expected sales income from the customer in $ based on ongoing sales orders.';
                }
                field("Shipped Not Invoiced (LCY)";"Shipped Not Invoiced (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Shipped Not Invd. ($)';
                    ToolTip = 'Specifies your expected sales income from the customer in $ based on ongoing sales orders where items have been shipped.';
                }
                field("Outstanding Invoices (LCY)";"Outstanding Invoices (LCY)")
                {
                    ApplicationArea = Basic,Suite;
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
            field("Total (LCY)";GetTotalAmountLCY)
            {
                AccessByPermission = TableData "Sales Line"=R;
                ApplicationArea = Basic,Suite;
                AutoFormatType = 1;
                Caption = 'Total ($)';
                Importance = Promoted;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'Specifies the payment amount that the customer owes for completed sales plus sales that are still ongoing.';
            }
            field("Credit Limit (LCY)";"Credit Limit (LCY)")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
            }
            field("Balance Due (LCY)";CalcOverdueBalance)
            {
                ApplicationArea = Basic,Suite;
                CaptionClass = FORMAT(STRSUBSTNO(Text000,FORMAT(WORKDATE)));

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
            field("Sales (LCY)";GetSalesLCY)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Total Sales ($)';
                ToolTip = 'Specifies your total sales turnover with the customer in the current fiscal year. It is calculated from amounts excluding tax on all completed and open sales invoices and credit memos.';

                trigger OnDrillDown()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                    AccountingPeriod: Record "Accounting Period";
                begin
                    CustLedgEntry.Reset;
                    CustLedgEntry.SetRange("Customer No.","No.");
                    CustLedgEntry.SetRange(
                      "Posting Date",AccountingPeriod.GetFiscalYearStartDate(WorkDate),AccountingPeriod.GetFiscalYearEndDate(WorkDate));
                    Page.RunModal(Page::"Customer Ledger Entries",CustLedgEntry);
                end;
            }
            field(GetInvoicedPrepmtAmountLCY;GetInvoicedPrepmtAmountLCY)
            {
                AccessByPermission = TableData "Sales Line"=R;
                ApplicationArea = Basic;
                Caption = 'Invoiced Prepayment Amount ($)';
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        ShowCustomerNo := true;
    end;

    var
        Text000: label 'Overdue Amounts ($) as of %1';
        ShowCustomerNo: Boolean;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Customer Card",Rec);
    end;


    procedure SetCustomerNoVisibility(Visible: Boolean)
    begin
        ShowCustomerNo := Visible;
    end;
}

