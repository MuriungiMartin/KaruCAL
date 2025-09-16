#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 378 "Bank Account Balance Lines"
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
                field(NetChange;BankAcc."Net Change")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = BankAcc."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Net Change';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowBankAccEntries;
                    end;
                }
                field("BankAcc.""Net Change (LCY)""";BankAcc."Net Change (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Net Change ($)';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowBankAccEntries;
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
        BankAcc.CalcFields("Net Change","Net Change (LCY)");
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
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";


    procedure Set(var NewBankAcc: Record "Bank Account";NewPeriodType: Integer;NewAmountType: Option "Net Change","Balance at Date")
    begin
        BankAcc.Copy(NewBankAcc);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure ShowBankAccEntries()
    begin
        SetDateFilter;
        BankAccLedgEntry.Reset;
        BankAccLedgEntry.SetCurrentkey("Bank Account No.","Posting Date");
        BankAccLedgEntry.SetRange("Bank Account No.",BankAcc."No.");
        BankAccLedgEntry.SetFilter("Posting Date",BankAcc.GetFilter("Date Filter"));
        BankAccLedgEntry.SetFilter("Global Dimension 1 Code",BankAcc.GetFilter("Global Dimension 1 Filter"));
        BankAccLedgEntry.SetFilter("Global Dimension 2 Code",BankAcc.GetFilter("Global Dimension 2 Filter"));
        Page.Run(0,BankAccLedgEntry);
    end;


    procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          BankAcc.SetRange("Date Filter","Period Start","Period End")
        else
          BankAcc.SetRange("Date Filter",0D,"Period End");
    end;
}

