#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 154 "G/L Account Balance/Budget"
{
    Caption = 'G/L Account Balance/Budget';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
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
                        UpdateSubForm;
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
            part(GLBalanceLines;"G/L Acc. Balance/Budget Lines")
            {
                ApplicationArea = Suite;
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
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
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
        UpdateSubForm;
    end;

    trigger OnOpenPage()
    begin
        Codeunit.Run(Codeunit::"GLBudget-Open",Rec);
    end;

    var
        GLAcc: Record "G/L Account";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        ClosingEntryFilter: Option Include,Exclude;

    local procedure UpdateSubForm()
    begin
        CurrPage.GLBalanceLines.Page.Set(Rec,PeriodType,AmountType,ClosingEntryFilter);
    end;

    local procedure DayPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure WeekPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure MonthPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure QuarterPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure YearPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure AccountingPerioPeriodTypOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure NetChangeAmountTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure BalanceatDateAmountTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure DayPeriodTypeOnValidate()
    begin
        DayPeriodTypeOnPush;
    end;

    local procedure WeekPeriodTypeOnValidate()
    begin
        WeekPeriodTypeOnPush;
    end;

    local procedure MonthPeriodTypeOnValidate()
    begin
        MonthPeriodTypeOnPush;
    end;

    local procedure QuarterPeriodTypeOnValidate()
    begin
        QuarterPeriodTypeOnPush;
    end;

    local procedure YearPeriodTypeOnValidate()
    begin
        YearPeriodTypeOnPush;
    end;

    local procedure AccountingPerioPeriodTypeOnVal()
    begin
        AccountingPerioPeriodTypOnPush;
    end;

    local procedure NetChangeAmountTypeOnValidate()
    begin
        NetChangeAmountTypeOnPush;
    end;

    local procedure BalanceatDateAmountTypeOnValid()
    begin
        BalanceatDateAmountTypeOnPush;
    end;
}

