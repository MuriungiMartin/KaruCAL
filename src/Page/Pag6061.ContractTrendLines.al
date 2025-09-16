#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6061 "Contract Trend Lines"
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
                field("ServContract.""Contract Prepaid Amount""";ServContract."Contract Prepaid Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepaid Income';

                    trigger OnDrillDown()
                    begin
                        SetDateFilter;
                        ServLedgEntry.Reset;
                        ServLedgEntry.SetCurrentkey(Type,"No.","Entry Type","Moved from Prepaid Acc.","Posting Date");
                        ServLedgEntry.SetRange("Service Contract No.",ServContract."Contract No.");
                        ServLedgEntry.SetRange("Entry Type",ServLedgEntry."entry type"::Sale);
                        ServLedgEntry.SetRange("Moved from Prepaid Acc.",false);
                        ServLedgEntry.SetRange(Type,ServLedgEntry.Type::"Service Contract");
                        ServLedgEntry.SetRange(Open,false);
                        ServLedgEntry.SetRange(Prepaid,true);
                        ServLedgEntry.SetFilter("Posting Date",ServContract.GetFilter("Date Filter"));
                        Page.RunModal(0,ServLedgEntry);
                    end;
                }
                field("ServContract.""Contract Invoice Amount""";ServContract."Contract Invoice Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Income';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        SetDateFilter;
                        ServLedgEntry.Reset;
                        ServLedgEntry.SetCurrentkey(Type,"No.","Entry Type","Moved from Prepaid Acc.","Posting Date");
                        ServLedgEntry.SetRange("Service Contract No.",ServContract."Contract No.");
                        ServLedgEntry.SetRange("Entry Type",ServLedgEntry."entry type"::Sale);
                        ServLedgEntry.SetRange("Moved from Prepaid Acc.",true);
                        ServLedgEntry.SetRange(Open,false);
                        ServLedgEntry.SetFilter("Posting Date",ServContract.GetFilter("Date Filter"));
                        Page.RunModal(0,ServLedgEntry);
                    end;
                }
                field("ServContract.""Contract Cost Amount""";ServContract."Contract Cost Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Cost';

                    trigger OnDrillDown()
                    begin
                        SetDateFilter;
                        Clear(ServLedgEntry);
                        ServLedgEntry.SetCurrentkey(Type,"No.","Entry Type","Moved from Prepaid Acc.","Posting Date");
                        ServLedgEntry.SetRange("Entry Type",ServLedgEntry."entry type"::Usage);
                        ServLedgEntry.SetRange("Service Contract No.",ServContract."Contract No.");
                        ServLedgEntry.SetRange("Moved from Prepaid Acc.",true);
                        ServLedgEntry.SetRange(Open,false);
                        ServLedgEntry.SetFilter("Posting Date",ServContract.GetFilter("Date Filter"));
                        Page.RunModal(0,ServLedgEntry);
                    end;
                }
                field("ServContract.""Contract Discount Amount""";ServContract."Contract Discount Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Discount Amount';

                    trigger OnDrillDown()
                    begin
                        SetDateFilter;
                        Clear(ServLedgEntry);
                        ServLedgEntry.SetCurrentkey("Service Contract No.");
                        ServLedgEntry.SetRange("Service Contract No.",ServContract."Contract No.");
                        ServLedgEntry.SetRange("Entry Type",ServLedgEntry."entry type"::Usage);
                        ServLedgEntry.SetRange("Moved from Prepaid Acc.",true);
                        ServLedgEntry.SetRange(Open,false);
                        ServLedgEntry.SetFilter("Posting Date",ServContract.GetFilter("Date Filter"));
                        Page.RunModal(0,ServLedgEntry);
                    end;
                }
                field(ProfitAmount;ProfitAmount)
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
        ServContract.CalcFields(
          "Contract Invoice Amount",
          "Contract Discount Amount",
          "Contract Cost Amount",
          "Contract Prepaid Amount");
        ProfitAmount := ServContract."Contract Invoice Amount" - ServContract."Contract Cost Amount";
        if ServContract."Contract Invoice Amount" <> 0 then
          ProfitPct := ROUND((ProfitAmount / ServContract."Contract Invoice Amount") * 100,0.01)
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

    var
        ServContract: Record "Service Contract Header";
        ServLedgEntry: Record "Service Ledger Entry";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        ProfitAmount: Decimal;
        ProfitPct: Decimal;


    procedure Set(var NewServContract: Record "Service Contract Header";NewPeriodType: Integer;NewAmountType: Option "Net Change","Balance at Date")
    begin
        ServContract.Copy(NewServContract);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          ServContract.SetRange("Date Filter","Period Start","Period End")
        else
          ServContract.SetRange("Date Filter",0D,"Period End");
    end;
}

