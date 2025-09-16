#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9039 "O365 Sales Activities"
{
    Caption = 'O365 Sales Activities';
    Description = 'ENU=Activites';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "O365 Sales Cue";

    layout
    {
        area(content)
        {
            cuegroup(Invoiced)
            {
                Caption = 'Invoiced';
                field("Invoiced YTD";"Invoiced YTD")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyFormatTxt;
                    AutoFormatType = 10;
                    Caption = 'Year to Date';
                    ToolTip = 'Specifies the total invoiced amount for this year.';

                    trigger OnDrillDown()
                    begin
                        ShowYearlySalesOverview;
                    end;
                }
                field("Invoiced CM";"Invoiced CM")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyFormatTxt;
                    AutoFormatType = 10;
                    Caption = 'This Month';
                    ToolTip = 'Specifies the total amount invoiced for the current month.';

                    trigger OnDrillDown()
                    begin
                        ShowMonthlySalesOverview;
                    end;
                }
            }
            cuegroup(Payments)
            {
                Caption = 'Payments';
                field("Sales Invoices Outstanding";"Sales Invoices Outstanding")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyFormatTxt;
                    AutoFormatType = 10;
                    Caption = 'Outstanding';
                    ToolTip = 'Specifies the total amount that has not yet been paid.';

                    trigger OnDrillDown()
                    begin
                        ShowInvoices(false);
                    end;
                }
                field("Sales Invoices Overdue";"Sales Invoices Overdue")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = CurrencyFormatTxt;
                    AutoFormatType = 10;
                    Caption = 'Overdue';
                    ToolTip = 'Specifies the total amount that has not been paid and is after the due date.';

                    trigger OnDrillDown()
                    begin
                        ShowInvoices(true);
                    end;
                }
            }
            cuegroup("Invoice Now")
            {
                Caption = 'Invoice Now';

                actions
                {
                    action("New Invoice")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Invoice';
                        Image = TileBrickNew;
                        RunObject = Page "O365 Sales Invoice";
                        RunPageMode = Create;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"O365 Sales Initial Setup");
    end;

    trigger OnOpenPage()
    var
        AccountingPeriod: Record "Accounting Period";
        GLSetup: Record "General Ledger Setup";
        O365SalesStatistics: Codeunit "O365 Sales Statistics";
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        O365SalesStatistics.GetCurrentAccountingPeriod(AccountingPeriod);

        SetFilter("Due Date Filter",'..%1',WorkDate);
        SetFilter("Overdue Date Filter",'<%1',WorkDate);
        SetFilter("YTD Date Filter",'%1..%2',AccountingPeriod."Starting Date",WorkDate);
        SetFilter("CM Date Filter",'%1..%2',CalcDate('<CM+1D-1M>',WorkDate),WorkDate);

        GLSetup.Get;

        CurrencyFormatTxt := StrSubstNo('%1<precision, 0:0><standard format, 0>',GLSetup.GetCurrencySymbol);
        RoleCenterNotificationMgt.ShowNotifications;
    end;

    var
        CurrencyFormatTxt: Text;
        NoOutstandingMsg: label 'There are no outstanding invoices.';
        NoOverdueMsg: label 'There are no overdue invoices.';

    local procedure ShowInvoices(OnlyOverdue: Boolean)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        O365SalesStatistics: Codeunit "O365 Sales Statistics";
    begin
        CustLedgerEntry.SetRange(Open,true);
        if OnlyOverdue then
          CustLedgerEntry.SetFilter("Due Date",'<%1',WorkDate);

        if O365SalesStatistics.GetCustomersFromCustLedgerEntries(CustLedgerEntry,Customer) then
          Page.Run(Page::"O365 Outstanding Customer List",Customer)
        else // no customers
          if OnlyOverdue then
            Message(NoOverdueMsg)
          else
            Message(NoOutstandingMsg);
    end;

    local procedure ShowMonthlySalesOverview()
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        Month: Integer;
    begin
        Month := Date2dmy(WorkDate,2);
        TempNameValueBuffer.Init;
        TempNameValueBuffer.ID := Month;
        TempNameValueBuffer.Insert;

        Page.Run(Page::"O365 Sales Month Summary",TempNameValueBuffer);
    end;

    local procedure ShowYearlySalesOverview()
    var
        O365SalesStatistics: Codeunit "O365 Sales Statistics";
    begin
        if O365SalesStatistics.GetRelativeMonthToFY <> 1 then
          Page.Run(Page::"O365 Sales Year Summary")
        else
          ShowMonthlySalesOverview; // the current month is the first month in the FY
    end;
}

