#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 18 "G/L Account List"
{
    Caption = 'G/L Account List';
    CardPageID = "G/L Account Card";
    DataCaptionFields = "Search Name";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "G/L Account";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the No. of the G/L Account you are setting up.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the name of the general ledger account.';
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field("Account Category";"Account Category")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the category of the G/L account.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this.';
                }
                field("Gen. Posting Type";"Gen. Posting Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general posting type to use when posting to this account.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general business posting group that applies to the entry.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a general product posting group code.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a Tax Bus. Posting Group.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a Tax Prod. Posting Group code.';
                    Visible = false;
                }
                field("Direct Posting";"Direct Posting")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether you will be able to post directly or only indirectly to this general ledger account. To allow Direct Posting to the G/L account, place a check mark in the check box.';
                }
                field("Budget Controlled";"Budget Controlled")
                {
                    ApplicationArea = Basic;
                }
                field("Reconciliation Account";"Reconciliation Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether this general ledger account will be included in the Reconciliation window in the general journal. To have the G/L account included in the window, place a check mark in the check box. You can find the Reconciliation window by clicking Actions, Posting in the General Journal window.';
                }
                field("Default Deferral Template Code";"Default Deferral Template Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Default Deferral Template';
                    ToolTip = 'Specifies the default deferral template that governs how to defer revenues and expenses to the periods when they occurred.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1905532107;"Dimensions FactBox")
            {
                SubPageLink = "Table ID"=const(15),
                              "No."=field("No.");
                Visible = false;
            }
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
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "G/L Account No."=field("No.");
                    RunPageView = sorting("G/L Account No.")
                                  order(descending);
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
                    ToolTip = 'Set up additional text for the description of the selected item. Extended text can be inserted under the Description field on document lines for the item.';
                }
                action("Receivables-Payables")
                {
                    ApplicationArea = Suite;
                    Caption = 'Receivables-Payables';
                    Image = ReceivablesPayables;
                    RunObject = Page "Receivables-Payables";
                    ToolTip = 'View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.';
                }
                action("Where-Used List")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Where-Used List';
                    Image = Track;
                    ToolTip = 'View setup tables where a general ledger account is used.';

                    trigger OnAction()
                    var
                        CalcGLAccWhereUsed: Codeunit "Calc. G/L Acc. Where-Used";
                    begin
                        CalcGLAccWhereUsed.CheckGLAcc("No.");
                    end;
                }
            }
            group("&Balance")
            {
                Caption = '&Balance';
                Image = Balance;
                action("G/L &Account Balance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L &Account Balance';
                    Image = GLAccountBalance;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "G/L Account Balance";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter");
                    ToolTip = 'View a summary of the debit and credit balances for different time periods, for the account that you select in the chart of accounts.';
                }
                action("G/L &Balance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L &Balance';
                    Image = GLBalance;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "G/L Balance";
                    RunPageOnRec = true;
                    ToolTip = 'View a scrollable summary of the debit and credit balances for all the accounts in the chart of accounts, for the time period that you select.';
                }
                action("G/L Balance by &Dimension")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Balance by &Dimension';
                    Image = GLBalanceDimension;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "G/L Balance by Dimension";
                    ToolTip = 'View a summary of the debit and credit balances by dimensions for the current account.';
                }
            }
        }
        area(reporting)
        {
            action("Trial Balance")
            {
                ApplicationArea = Suite;
                Caption = 'Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Trial Balance";
                ToolTip = 'View general ledger account balances and activities for all the selected accounts, one transaction per line.';
            }
            action("Trial Balance by Period")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance by Period';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Trial Balance by Period";
                ToolTip = 'View general ledger account balances and activities for all the selected accounts, one transaction per line for a selected period.';
            }
            action("Detail Trial Balance")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Detail Trial Balance";
                ToolTip = 'View detail general ledger account balances and activities for all the selected accounts, one transaction per line.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLine;
    end;

    var
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;


    procedure SetSelection(var GLAcc: Record "G/L Account")
    begin
        CurrPage.SetSelectionFilter(GLAcc);
    end;


    procedure GetSelectionFilter(): Text
    var
        GLAcc: Record "G/L Account";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(GLAcc);
        exit(SelectionFilterManagement.GetSelectionFilterForGLAccount(GLAcc));
    end;

    local procedure FormatLine()
    begin
        NameIndent := Indentation;
        Emphasize := "Account Type" <> "account type"::Posting;
    end;
}

