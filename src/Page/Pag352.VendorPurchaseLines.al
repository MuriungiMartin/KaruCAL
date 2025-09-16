#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 352 "Vendor Purchase Lines"
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
                field(BalanceDueLCY;Vend."Balance Due (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance Due ($)';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowVendEntriesDue;
                    end;
                }
                field("Vend.""Purchases (LCY)""";Vend."Purchases (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Purchases ($)';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowVendEntries;
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
        Vend.CalcFields("Balance Due (LCY)","Purchases (LCY)");
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
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";


    procedure Set(var NewVend: Record Vendor;NewPeriodType: Integer;NewAmountType: Option "Net Change","Balance at Date")
    begin
        Vend.Copy(NewVend);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure ShowVendEntries()
    begin
        SetDateFilter;
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Vendor No.","Posting Date");
        VendLedgEntry.SetRange("Vendor No.",Vend."No.");
        VendLedgEntry.SetFilter("Posting Date",Vend.GetFilter("Date Filter"));
        VendLedgEntry.SetFilter("Global Dimension 1 Code",Vend.GetFilter("Global Dimension 1 Filter"));
        VendLedgEntry.SetFilter("Global Dimension 2 Code",Vend.GetFilter("Global Dimension 2 Filter"));
        Page.Run(0,VendLedgEntry);
    end;

    local procedure ShowVendEntriesDue()
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        SetDateFilter;
        DtldVendLedgEntry.Reset;
        DtldVendLedgEntry.SetCurrentkey("Vendor No.","Initial Entry Due Date","Posting Date","Currency Code");
        DtldVendLedgEntry.SetRange("Vendor No.",Vend."No.");
        DtldVendLedgEntry.SetFilter("Initial Entry Due Date",Vend.GetFilter("Date Filter"));
        DtldVendLedgEntry.SetFilter("Posting Date",'..%1',Vend.GetRangemax("Date Filter"));
        DtldVendLedgEntry.SetFilter("Initial Entry Global Dim. 1",Vend.GetFilter("Global Dimension 1 Filter"));
        DtldVendLedgEntry.SetFilter("Initial Entry Global Dim. 2",Vend.GetFilter("Global Dimension 2 Filter"));
        Page.Run(0,DtldVendLedgEntry)
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          Vend.SetRange("Date Filter","Period Start","Period End")
        else
          Vend.SetRange("Date Filter",0D,"Period End");
    end;
}

