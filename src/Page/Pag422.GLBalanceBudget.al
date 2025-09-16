#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 422 "G/L Balance/Budget"
{
    Caption = 'G/L Balance/Budget';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "G/L Account";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(ClosingEntryFilter;ClosingEntryFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Closing Entries';
                    OptionCaption = 'Include,Exclude';
                    ToolTip = 'Specifies whether the balance shown will include closing entries. If you want to see the amounts on income statement accounts in closed years, you must exclude closing entries.';

                    trigger OnValidate()
                    begin
                        FindPeriod('');
                        ClosingEntryFilterOnAfterValid;
                    end;
                }
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Suite;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        if PeriodType = Periodtype::"Accounting Period" then
                          AccountingPerioPeriodTypeOnVal;
                        if PeriodType = Periodtype::Year then
                          YearPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Quarter then
                          QuarterPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Month then
                          MonthPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Week then
                          WeekPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Day then
                          DayPeriodTypeOnValidate;
                    end;
                }
                field(AmountType;AmountType)
                {
                    ApplicationArea = Suite;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        if AmountType = Amounttype::"Balance at Date" then
                          BalanceatDateAmountTypeOnValid;
                        if AmountType = Amounttype::"Net Change" then
                          NetChangeAmountTypeOnValidate;
                    end;
                }
            }
            repeater(Control5)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("No.";"No.")
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the No. of the G/L Account you are setting up.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the name of the general ledger account.';
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field("Debit Amount";"Debit Amount")
                {
                    ApplicationArea = Suite;
                    BlankNumbers = BlankNegAndZero;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the total of the debit entries that have been posted to the account.';
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = Suite;
                    BlankNumbers = BlankNegAndZero;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the total of the credit entries that have been posted to the account.';
                }
                field("Net Change";"Net Change")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the net change in the account balance during the time period in the Date Filter field.';
                    Visible = false;
                }
                field("Budgeted Debit Amount";"Budgeted Debit Amount")
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the Budgeted Debit Amount for the account.';

                    trigger OnValidate()
                    begin
                        CalcFormFields;
                        BudgetedDebitAmountOnAfterVali;
                    end;
                }
                field("Budgeted Credit Amount";"Budgeted Credit Amount")
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the Budgeted Credit Amount for the account.';

                    trigger OnValidate()
                    begin
                        CalcFormFields;
                        BudgetedCreditAmountOnAfterVal;
                    end;
                }
                field("Budgeted Amount";"Budgeted Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies either the G/L account''s total budget or, if you have specified a name in the Budget Name field, a specific budget.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CalcFormFields;
                        BudgetedAmountOnAfterValidate;
                    end;
                }
                field(BudgetPct;BudgetPct)
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    Caption = 'Balance/Budget (%)';
                    DecimalPlaces = 1:1;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies a summary of the debit and credit balances and the budgeted amounts for different time periods for the account that you select in the chart of accounts.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "G/L Account Card";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Budget Filter"=field("Budget Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the G/L account card for the selected record.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Suite;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "G/L Account No."=field("No.");
                    RunPageView = sorting("G/L Account No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const("G/L Account"),
                                  "No."=field("No.");
                    ToolTip = 'View or add comments.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(15),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("E&xtended Text")
                {
                    ApplicationArea = Suite;
                    Caption = 'E&xtended Text';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name"=const("G/L Account"),
                                  "No."=field("No.");
                    RunPageView = sorting("Table Name","No.","Language Code","All Language Codes","Starting Date","Ending Date");
                    ToolTip = 'View additional information that has been added to the description for the current account.';
                }
            }
        }
        area(processing)
        {
            action("Previous Period")
            {
                ApplicationArea = Suite;
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.';

                trigger OnAction()
                begin
                    FindPeriod('<=');
                end;
            }
            action("Next Period")
            {
                ApplicationArea = Suite;
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.';

                trigger OnAction()
                begin
                    FindPeriod('>=');
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Copy Budget")
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Budget';
                    Ellipsis = true;
                    Image = CopyBudget;
                    RunObject = Report "Copy G/L Budget";
                    ToolTip = 'Create a copy of the current budget.';
                }
                group("C&reate Budget")
                {
                    Caption = 'C&reate Budget';
                    Image = CreateLedgerBudget;
                    action("Amount by Period")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Amount by Period';
                        Ellipsis = true;
                        Image = AmountByPeriod;
                        ToolTip = 'View the balance amounts by the defined periods.';

                        trigger OnAction()
                        begin
                            GLAcc.Copy(Rec);
                            GLAcc.SetRange("No.","No.");
                            GLAcc.SetRange("Date Filter");
                            Report.Run(Report::"Budget Amount by Period",true,false,GLAcc);
                        end;
                    }
                    action("From History")
                    {
                        ApplicationArea = Suite;
                        Caption = 'From History';
                        Ellipsis = true;
                        Image = CopyLedgerToBudget;
                        ToolTip = 'View budget amounts based on an existing budget for the period, so that amounts created will not replace the existing amounts, but instead will be added to the existing budget amounts.';

                        trigger OnAction()
                        begin
                            GLAcc.Copy(Rec);
                            GLAcc.SetRange("No.","No.");
                            GLAcc.SetRange("Date Filter");
                            Report.Run(Report::"Budget from History",true,false,GLAcc);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        CalcFormFields;
        FormatLine;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewGLAcc(xRec,BelowxRec);
    end;

    trigger OnOpenPage()
    begin
        Codeunit.Run(Codeunit::"GLBudget-Open",Rec);
        FindPeriod('');
    end;

    var
        GLAcc: Record "G/L Account";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        ClosingEntryFilter: Option Include,Exclude;
        BudgetPct: Decimal;
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure FindPeriod(SearchText: Code[10])
    var
        Calendar: Record Date;
        AccountingPeriod: Record "Accounting Period";
        PeriodFormMgt: Codeunit PeriodFormManagement;
    begin
        if GetFilter("Date Filter") <> '' then begin
          Calendar.SetFilter("Period Start",GetFilter("Date Filter"));
          if not PeriodFormMgt.FindDate('+',Calendar,PeriodType) then
            PeriodFormMgt.FindDate('+',Calendar,Periodtype::Day);
          Calendar.SetRange("Period Start");
        end;
        PeriodFormMgt.FindDate(SearchText,Calendar,PeriodType);
        if AmountType = Amounttype::"Net Change" then
          if Calendar."Period Start" = Calendar."Period End" then
            SetRange("Date Filter",Calendar."Period Start")
          else
            SetRange("Date Filter",Calendar."Period Start",Calendar."Period End")
        else
          SetRange("Date Filter",0D,Calendar."Period End");
        if ClosingEntryFilter = Closingentryfilter::Exclude then begin
          AccountingPeriod.SetCurrentkey("New Fiscal Year");
          AccountingPeriod.SetRange("New Fiscal Year",true);
          if GetRangeMin("Date Filter") = 0D then
            AccountingPeriod.SetRange("Starting Date",0D,GetRangemax("Date Filter"))
          else
            AccountingPeriod.SetRange(
              "Starting Date",
              GetRangeMin("Date Filter") + 1,
              GetRangemax("Date Filter"));
          if AccountingPeriod.Find('-') then
            repeat
              SetFilter(
                "Date Filter",GetFilter("Date Filter") + '&<>%1',
                ClosingDate(AccountingPeriod."Starting Date" - 1));
            until AccountingPeriod.Next = 0;
        end else
          SetRange(
            "Date Filter",
            GetRangeMin("Date Filter"),
            ClosingDate(GetRangemax("Date Filter")));
    end;

    local procedure CalcFormFields()
    begin
        CalcFields("Net Change","Budgeted Amount");
        if "Net Change" >= 0 then begin
          "Debit Amount" := "Net Change";
          "Credit Amount" := 0;
        end else begin
          "Debit Amount" := 0;
          "Credit Amount" := -"Net Change";
        end;
        if "Budgeted Amount" >= 0 then begin
          "Budgeted Debit Amount" := "Budgeted Amount";
          "Budgeted Credit Amount" := 0;
        end else begin
          "Budgeted Debit Amount" := 0;
          "Budgeted Credit Amount" := -"Budgeted Amount";
        end;
        if "Budgeted Amount" = 0 then
          BudgetPct := 0
        else
          BudgetPct := "Net Change" / "Budgeted Amount" * 100;
    end;

    local procedure BudgetedDebitAmountOnAfterVali()
    begin
        CurrPage.Update;
    end;

    local procedure BudgetedCreditAmountOnAfterVal()
    begin
        CurrPage.Update;
    end;

    local procedure BudgetedAmountOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure DayPeriodTypeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure WeekPeriodTypeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure MonthPeriodTypeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QuarterPeriodTypeOnAfterValida()
    begin
        CurrPage.Update;
    end;

    local procedure YearPeriodTypeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure AccountingPerioPeriodTypeOnAft()
    begin
        CurrPage.Update;
    end;

    local procedure ClosingEntryFilterOnAfterValid()
    begin
        CurrPage.Update;
    end;

    local procedure NetChangeAmountTypeOnAfterVali()
    begin
        CurrPage.Update;
    end;

    local procedure BalanceatDateAmountTypeOnAfter()
    begin
        CurrPage.Update;
    end;

    local procedure DayPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure WeekPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure MonthPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure QuarterPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure YearPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure AccountingPerioPeriodTypOnPush()
    begin
        FindPeriod('');
    end;

    local procedure NetChangeAmountTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure BalanceatDateAmountTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure FormatLine()
    begin
        NameIndent := Indentation;
        Emphasize := "Account Type" <> "account type"::Posting;
    end;

    local procedure DayPeriodTypeOnValidate()
    begin
        DayPeriodTypeOnPush;
        DayPeriodTypeOnAfterValidate;
    end;

    local procedure WeekPeriodTypeOnValidate()
    begin
        WeekPeriodTypeOnPush;
        WeekPeriodTypeOnAfterValidate;
    end;

    local procedure MonthPeriodTypeOnValidate()
    begin
        MonthPeriodTypeOnPush;
        MonthPeriodTypeOnAfterValidate;
    end;

    local procedure QuarterPeriodTypeOnValidate()
    begin
        QuarterPeriodTypeOnPush;
        QuarterPeriodTypeOnAfterValida;
    end;

    local procedure YearPeriodTypeOnValidate()
    begin
        YearPeriodTypeOnPush;
        YearPeriodTypeOnAfterValidate;
    end;

    local procedure AccountingPerioPeriodTypeOnVal()
    begin
        AccountingPerioPeriodTypOnPush;
        AccountingPerioPeriodTypeOnAft;
    end;

    local procedure NetChangeAmountTypeOnValidate()
    begin
        NetChangeAmountTypeOnPush;
        NetChangeAmountTypeOnAfterVali;
    end;

    local procedure BalanceatDateAmountTypeOnValid()
    begin
        BalanceatDateAmountTypeOnPush;
        BalanceatDateAmountTypeOnAfter;
    end;
}

