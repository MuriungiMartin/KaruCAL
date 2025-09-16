#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1120 "Cost Type Balance/Budget"
{
    Caption = 'Cost Type Balance/Budget';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Cost Type";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(BudgetFilter;BudgetFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Budget Filter';
                    LookupPageID = "Cost Budget Names";
                    TableRelation = "Cost Budget Name".Name;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(CostCenterFilter;CostCenterFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Center Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CostCenter: Record "Cost Center";
                    begin
                        exit(CostCenter.LookupCostCenterFilter(Text));
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(CostObjectFilter;CostObjectFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Object Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CostObject: Record "Cost Object";
                    begin
                        exit(CostObject.LookupCostObjectFilter(Text));
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        FindPeriod('');
                    end;
                }
                field(AmountType;AmountType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        if (AmountType = Amounttype::"Balance at Date") or (AmountType = Amounttype::"Net Change") then
                          FindPeriod('');
                    end;
                }
            }
            repeater(Control12)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field(Number;"No.")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Net Change";"Net Change")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Debit Amount";"Debit Amount")
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankNegAndZero;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = false;
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankNegAndZero;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = false;
                }
                field("Budget Amount";"Budget Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnValidate()
                    begin
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
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Cost Type Card";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Cost Center Filter"=field("Cost Center Filter"),
                                  "Cost Object Filter"=field("Cost Object Filter"),
                                  "Budget Filter"=field("Budget Filter");
                    ShortCutKey = 'Shift+F7';
                }
                action("Cost E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost E&ntries';
                    Image = CostEntries;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Type No."=field("No."),
                                  "Posting Date"=field("Date Filter");
                    RunPageView = sorting("Cost Type No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            action(PreviousPeriod)
            {
                ApplicationArea = Basic;
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Previous Period';

                trigger OnAction()
                begin
                    FindPeriod('<=');
                end;
            }
            action(NextPeriod)
            {
                ApplicationArea = Basic;
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Next Period';

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
                    ApplicationArea = Basic;
                    Caption = 'Copy Budget';
                    Ellipsis = true;
                    Image = CopyBudget;
                    RunObject = Report "Copy G/L Budget";
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        CalcFormFields;
        NameIndent := Indentation;
        Emphasize := Type <> Type::"Cost Type";
    end;

    trigger OnOpenPage()
    begin
        BudgetFilter := GetFilter("Budget Filter");
        FindPeriod('');
    end;

    var
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        BudgetPct: Decimal;
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
        BudgetFilter: Code[10];
        CostCenterFilter: Text[1024];
        CostObjectFilter: Text[1024];

    local procedure FindPeriod(SearchText: Code[3])
    var
        Calendar: Record Date;
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

        CurrPage.Update(false);
    end;

    local procedure CalcFormFields()
    begin
        SetFilter("Budget Filter",BudgetFilter);
        SetFilter("Cost Center Filter",CostCenterFilter);
        SetFilter("Cost Object Filter",CostObjectFilter);

        CalcFields("Net Change","Budget Amount");
        if "Budget Amount" = 0 then
          BudgetPct := 0
        else
          BudgetPct := ROUND("Net Change" / "Budget Amount" * 100);
    end;
}

