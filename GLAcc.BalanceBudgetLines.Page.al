#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 350 "G/L Acc. Balance/Budget Lines"
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
                    BlankNumbers = BlankNegAndZero;
                    Caption = 'Debit Amount';
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        BalanceDrillDown;
                    end;
                }
                field("GLAcc.""Credit Amount""";GLAcc."Credit Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    BlankNumbers = BlankNegAndZero;
                    Caption = 'Credit Amount';
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        BalanceDrillDown;
                    end;
                }
                field("GLAcc.""Net Change""";GLAcc."Net Change")
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
                field("GLAcc.""Budgeted Debit Amount""";GLAcc."Budgeted Debit Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    BlankNumbers = BlankNegAndZero;
                    Caption = 'Budgeted Debit Amount';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        BudgetDrillDown;
                    end;

                    trigger OnValidate()
                    begin
                        SetDateFilter;
                        GLAcc.Validate("Budgeted Debit Amount");
                        CalcFormFields;
                    end;
                }
                field("GLAcc.""Budgeted Credit Amount""";GLAcc."Budgeted Credit Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    BlankNumbers = BlankNegAndZero;
                    Caption = 'Budgeted Credit Amount';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        BudgetDrillDown;
                    end;

                    trigger OnValidate()
                    begin
                        SetDateFilter;
                        GLAcc.Validate("Budgeted Credit Amount");
                        CalcFormFields;
                    end;
                }
                field("GLAcc.""Budgeted Amount""";GLAcc."Budgeted Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    BlankZero = true;
                    Caption = 'Budgeted Amount';
                    DrillDown = true;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        BudgetDrillDown;
                    end;

                    trigger OnValidate()
                    begin
                        SetDateFilter;
                        GLAcc.Validate("Budgeted Amount");
                        CalcFormFields;
                    end;
                }
                field(BudgetPct;BudgetPct)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Balance/Budget (%)';
                    DecimalPlaces = 1:1;
                    Editable = false;
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
        CalcFormFields;
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
        BudgetPct: Decimal;
        AmountType: Option "Net Change","Balance at Date";
        ClosingEntryFilter: Option Include,Exclude;


    procedure Set(var NewGLAcc: Record "G/L Account";NewGLPeriodLength: Integer;NewAmountType: Option "Net Change",Balance;NewClosingEntryFilter: Option Include,Exclude)
    begin
        GLAcc.Copy(NewGLAcc);
        GLPeriodLength := NewGLPeriodLength;
        AmountType := NewAmountType;
        ClosingEntryFilter := NewClosingEntryFilter;
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

    local procedure BudgetDrillDown()
    var
        GLBudgetEntry: Record "G/L Budget Entry";
    begin
        SetDateFilter;
        GLBudgetEntry.Reset;
        GLBudgetEntry.SetCurrentkey("Budget Name","G/L Account No.",Date);
        GLBudgetEntry.SetFilter("Budget Name",GLAcc.GetFilter("Budget Filter"));
        GLBudgetEntry.SetRange("G/L Account No.",GLAcc."No.");
        if GLAcc.Totaling <> '' then
          GLBudgetEntry.SetFilter("G/L Account No.",GLAcc.Totaling);
        GLBudgetEntry.SetFilter(Date,GLAcc.GetFilter("Date Filter"));
        GLBudgetEntry.SetFilter("Global Dimension 1 Code",GLAcc.GetFilter("Global Dimension 1 Filter"));
        GLBudgetEntry.SetFilter("Global Dimension 2 Code",GLAcc.GetFilter("Global Dimension 2 Filter"));
        GLBudgetEntry.SetFilter("Business Unit Code",GLAcc.GetFilter("Business Unit Filter"));
        Page.Run(0,GLBudgetEntry);
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then begin
          GLAcc.SetRange("Date Filter","Period Start","Period End");
        end else
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

    local procedure CalcFormFields()
    begin
        GLAcc.CalcFields("Net Change","Budgeted Amount");
        GLAcc."Debit Amount" := GLAcc."Net Change";
        GLAcc."Credit Amount" := -GLAcc."Net Change";
        GLAcc."Budgeted Debit Amount" := GLAcc."Budgeted Amount";
        GLAcc."Budgeted Credit Amount" := -GLAcc."Budgeted Amount";
        if GLAcc."Budgeted Amount" = 0 then
          BudgetPct := 0
        else
          BudgetPct := GLAcc."Net Change" / GLAcc."Budgeted Amount" * 100;
    end;
}

