#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5984 "Service Item Trend Lines"
{
    Caption = 'Lines';
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
                field("ServItem.""Prepaid Amount""";ServItem."Prepaid Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepaid Income';

                    trigger OnDrillDown()
                    begin
                        ShowServLedgEntries(false);
                    end;
                }
                field("ServItem.""Invoiced Amount""";ServItem."Invoiced Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Income';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowServLedgEntries(true);
                    end;
                }
                field("ServItem.""Parts Used""";ServItem."Parts Used")
                {
                    ApplicationArea = Basic;
                    Caption = 'Parts Used';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowServLedgEntriesByType(ServLedgEntry.Type::Item);
                    end;
                }
                field("ServItem.""Resources Used""";ServItem."Resources Used")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources Used';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowServLedgEntriesByType(ServLedgEntry.Type::Resource);
                    end;
                }
                field("ServItem.""Cost Used""";ServItem."Cost Used")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Used';

                    trigger OnDrillDown()
                    begin
                        ShowServLedgEntriesByType(ServLedgEntry.Type::"Service Cost");
                    end;
                }
                field(Profit;Profit)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Profit';
                }
                field(ProfitPct;ProfitPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit %';
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
        ServItem.CalcFields("Invoiced Amount","Resources Used","Parts Used","Cost Used","Prepaid Amount");
        Profit := ServItem."Invoiced Amount" - ServItem."Resources Used" - ServItem."Parts Used" - ServItem."Cost Used";
        if ServItem."Invoiced Amount" <> 0 then
          ProfitPct := ROUND((Profit / ServItem."Invoiced Amount") * 100,0.01)
        else
          ProfitPct := 0;
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
        ServItem: Record "Service Item";
        ServLedgEntry: Record "Service Ledger Entry";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        Profit: Decimal;
        ProfitPct: Decimal;


    procedure Set(var ServItem1: Record "Service Item";NewPeriodType: Integer;NewAmountType: Option "Net Change","Balance at Date")
    begin
        ServItem.Copy(ServItem1);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          ServItem.SetRange("Date Filter","Period Start","Period End")
        else
          ServItem.SetRange("Date Filter",0D,"Period End");
    end;

    local procedure ShowServLedgEntries(Prepaid: Boolean)
    begin
        SetDateFilter;
        ServLedgEntry.Reset;
        ServLedgEntry.SetCurrentkey("Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.",Type,"Posting Date");
        ServLedgEntry.SetRange("Service Item No. (Serviced)",ServItem."No.");
        ServLedgEntry.SetRange("Entry Type",ServLedgEntry."entry type"::Sale);
        ServLedgEntry.SetRange("Moved from Prepaid Acc.",Prepaid);
        ServLedgEntry.SetRange(Open,false);
        ServLedgEntry.SetFilter("Posting Date",ServItem.GetFilter("Date Filter"));
        Page.Run(0,ServLedgEntry);
    end;

    local procedure ShowServLedgEntriesByType(Type: Option)
    begin
        SetDateFilter;
        ServLedgEntry.Reset;
        ServLedgEntry.SetCurrentkey("Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.",Type,"Posting Date");
        ServLedgEntry.SetRange("Service Item No. (Serviced)",ServItem."No.");
        ServLedgEntry.SetRange("Entry Type",ServLedgEntry."entry type"::Sale);
        ServLedgEntry.SetRange(Type,Type);
        ServLedgEntry.SetFilter("Posting Date",ServItem.GetFilter("Date Filter"));
        Page.Run(0,ServLedgEntry);
    end;
}

