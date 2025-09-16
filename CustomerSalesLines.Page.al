#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 351 "Customer Sales Lines"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("Period Start";"Period Start")
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Start';
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Name';
                }
                field(BalanceDueLCY;Cust."Balance Due (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance Due ($)';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowCustEntriesDue;
                    end;
                }
                field("Cust.""Sales (LCY)""";Cust."Sales (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowCustEntries;
                    end;
                }
                field("Cust.""Profit (LCY)""";Cust."Profit (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit ($)';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowCustEntries;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetDateFilter;
        Cust.CalcFields("Balance Due (LCY)","Sales (LCY)","Profit (LCY)");
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(PeriodFormMgt.FindDate(Which,Rec,PeriodType));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(PeriodFormMgt.NextDate(Steps,Rec,PeriodType));
    end;

    trigger OnOpenPage()
    begin
        Reset;
    end;

    var
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";


    procedure Set(var NewCust: Record Customer;NewPeriodType: Integer;NewAmountType: Option "Net Change","Balance at Date")
    begin
        Cust.Copy(NewCust);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure ShowCustEntries()
    begin
        SetDateFilter;
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentkey("Customer No.","Posting Date");
        CustLedgEntry.SetRange("Customer No.",Cust."No.");
        CustLedgEntry.SetFilter("Posting Date",Cust.GetFilter("Date Filter"));
        CustLedgEntry.SetFilter("Global Dimension 1 Code",Cust.GetFilter("Global Dimension 1 Filter"));
        CustLedgEntry.SetFilter("Global Dimension 2 Code",Cust.GetFilter("Global Dimension 2 Filter"));
        Page.Run(0,CustLedgEntry);
    end;

    local procedure ShowCustEntriesDue()
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        SetDateFilter;
        DtldCustLedgEntry.Reset;
        DtldCustLedgEntry.SetCurrentkey("Customer No.","Initial Entry Due Date","Posting Date","Currency Code");
        DtldCustLedgEntry.SetRange("Customer No.",Cust."No.");
        DtldCustLedgEntry.SetFilter("Initial Entry Due Date",Cust.GetFilter("Date Filter"));
        DtldCustLedgEntry.SetFilter("Posting Date",'..%1',Cust.GetRangemax("Date Filter"));
        DtldCustLedgEntry.SetFilter("Initial Entry Global Dim. 1",Cust.GetFilter("Global Dimension 1 Filter"));
        DtldCustLedgEntry.SetFilter("Initial Entry Global Dim. 2",Cust.GetFilter("Global Dimension 2 Filter"));
        Page.Run(0,DtldCustLedgEntry)
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          Cust.SetRange("Date Filter","Period Start","Period End")
        else
          Cust.SetRange("Date Filter",0D,"Period End");
    end;
}

