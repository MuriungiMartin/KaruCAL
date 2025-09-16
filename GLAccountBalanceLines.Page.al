#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 416 "G/L Account Balance Lines"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Period Start";"Period Start")
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Start';
                    Editable = false;
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Name';
                    Editable = false;
                }
                field(DebitAmount;GLAcc."Debit Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    BlankNumbers = BlankZero;
                    Caption = 'Debit Amount';
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        BalanceDrillDown;
                    end;
                }
                field(CreditAmount;GLAcc."Credit Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    BlankNumbers = BlankZero;
                    Caption = 'Credit Amount';
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        BalanceDrillDown;
                    end;
                }
                field(NetChange;GLAcc."Net Change")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    BlankZero = true;
                    Caption = 'Net Change';
                    DrillDown = true;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        BalanceDrillDown;
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
        if DebitCreditTotals then
          GLAcc.CalcFields("Net Change","Debit Amount","Credit Amount")
        else begin
          GLAcc.CalcFields("Net Change");
          if GLAcc."Net Change" > 0 then begin
            GLAcc."Debit Amount" := GLAcc."Net Change";
            GLAcc."Credit Amount" := 0
          end else begin
            GLAcc."Debit Amount" := 0;
            GLAcc."Credit Amount" := -GLAcc."Net Change"
          end
        end
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(PeriodFormMgt.FindDate(Which,Rec,GLPeriodLength));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(PeriodFormMgt.NextDate(Steps,Rec,GLPeriodLength));
    end;

    trigger OnOpenPage()
    begin
        Reset;
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        GLAcc: Record "G/L Account";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        GLPeriodLength: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        ClosingEntryFilter: Option Include,Exclude;
        DebitCreditTotals: Boolean;


    procedure Set(var NewGLAcc: Record "G/L Account";NewGLPeriodLength: Integer;NewAmountType: Option "Net Change",Balance;NewClosingEntryFilter: Option Include,Exclude;NewDebitCreditTotals: Boolean)
    begin
        GLAcc.Copy(NewGLAcc);
        GLPeriodLength := NewGLPeriodLength;
        AmountType := NewAmountType;
        ClosingEntryFilter := NewClosingEntryFilter;
        DebitCreditTotals := NewDebitCreditTotals;
        CurrPage.Update(false);
    end;

    local procedure BalanceDrillDown()
    var
        GLEntry: Record "G/L Entry";
    begin
        SetDateFilter;
        GLEntry.Reset;
        GLEntry.SetCurrentkey("G/L Account No.","Posting Date");
        GLEntry.SetRange("G/L Account No.",GLAcc."No.");
        if GLAcc.Totaling <> '' then
          GLEntry.SetFilter("G/L Account No.",GLAcc.Totaling);
        GLEntry.SetFilter("Posting Date",GLAcc.GetFilter("Date Filter"));
        GLEntry.SetFilter("Global Dimension 1 Code",GLAcc.GetFilter("Global Dimension 1 Filter"));
        GLEntry.SetFilter("Global Dimension 2 Code",GLAcc.GetFilter("Global Dimension 2 Filter"));
        GLEntry.SetFilter("Business Unit Code",GLAcc.GetFilter("Business Unit Filter"));
        Page.Run(0,GLEntry);
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          GLAcc.SetRange("Date Filter","Period Start","Period End")
        else
          GLAcc.SetRange("Date Filter",0D,"Period End");
        if ClosingEntryFilter = Closingentryfilter::Exclude then begin
          AccountingPeriod.SetCurrentkey("New Fiscal Year");
          AccountingPeriod.SetRange("New Fiscal Year",true);
          if GLAcc.GetRangeMin("Date Filter") = 0D then
            AccountingPeriod.SetRange("Starting Date",0D,GLAcc.GetRangemax("Date Filter"))
          else
            AccountingPeriod.SetRange(
              "Starting Date",
              GLAcc.GetRangeMin("Date Filter") + 1,
              GLAcc.GetRangemax("Date Filter"));
          if AccountingPeriod.Find('-') then
            repeat
              GLAcc.SetFilter(
                "Date Filter",GLAcc.GetFilter("Date Filter") + '&<>%1',
                ClosingDate(AccountingPeriod."Starting Date" - 1));
            until AccountingPeriod.Next = 0;
        end else
          GLAcc.SetRange(
            "Date Filter",
            GLAcc.GetRangeMin("Date Filter"),
            ClosingDate(GLAcc.GetRangemax("Date Filter")));
    end;
}

