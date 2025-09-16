#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 570 "Chart of Accounts (G/L)"
{
    Caption = 'Chart of Accounts (G/L)';
    CardPageID = "G/L Account Card";
    Editable = false;
    PageType = List;
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
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this.';
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field("Direct Posting";"Direct Posting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether you will be able to post directly or only indirectly to this general ledger account.';
                    Visible = false;
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an account interval or a list of account numbers.';
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
                    ToolTip = 'Specifies a general product posting group.';
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
                field("Net Change";"Net Change")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the net change in the account balance during the time period in the Date Filter field.';
                }
                field("Balance at Date";"Balance at Date")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the G/L account balance on the last date included in the Date Filter field.';
                    Visible = false;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the balance on this account.';
                    Visible = false;
                }
                field("Additional-Currency Net Change";"Additional-Currency Net Change")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the net change in the account balance.';
                    Visible = false;
                }
                field("Add.-Currency Balance at Date";"Add.-Currency Balance at Date")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the G/L account balance (in the additional reporting currency) on the last date included in the Date Filter field.';
                    Visible = false;
                }
                field("Additional-Currency Balance";"Additional-Currency Balance")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the balance on this account, in the additional reporting currency.';
                    Visible = false;
                }
                field(Control34;"Budgeted Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies either the G/L account''s total budget or, if you have specified a name in the Budget Name field, a specific budget.';
                }
                field("Consol. Debit Acc.";"Consol. Debit Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the account number in a consolidated company to transfer credit balances.';
                    Visible = false;
                }
                field("Consol. Credit Acc.";"Consol. Credit Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the account number in a consolidated company to transfer credit balances.';
                    Visible = false;
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
                action(AccountGeneralLedgerEntries)
                {
                    ApplicationArea = Basic,Suite;
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
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(15),
                                      "No."=field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            GLAcc: Record "G/L Account";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(GLAcc);
                            DefaultDimMultiple.SetMultiGLAcc(GLAcc);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
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
                    ToolTip = 'View the extended description that is set up.';
                }
                action("Receivables-Payables")
                {
                    ApplicationArea = Suite;
                    Caption = 'Receivables-Payables';
                    Image = ReceivablesPayables;
                    RunObject = Page "Receivables-Payables";
                    ToolTip = 'View a summary of receivables and payables.';
                }
            }
            group("Underlying Entries")
            {
                Caption = 'Underlying Entries';
                action(NetChange)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Net Change';
                    Image = LedgerEntries;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "G/L Account No."=field(filter(Totaling)),
                                  "Posting Date"=field("Date Filter");
                    ToolTip = 'View the general ledger entries that make up the sum in the Net Change field.';
                }
                action("Budgeted Amount")
                {
                    ApplicationArea = Suite;
                    Caption = 'Budgeted Amount';
                    Image = GLRegisters;
                    RunObject = Page "G/L Budget Entries";
                    RunPageLink = "G/L Account No."=field(filter(Totaling)),
                                  Date=field("Date Filter");
                    ToolTip = 'View the budget entries that make up the sum in the Budgeted Amount field.';
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
                    RunObject = Page "G/L Account Balance";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter");
                    ToolTip = 'View a scrollable summary of the debit and credit balances for different time periods, for the account you select in the chart of accounts.';
                }
                action("G/L &Balance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L &Balance';
                    Image = GLBalance;
                    RunObject = Page "G/L Balance";
                    RunPageOnRec = true;
                    ToolTip = 'View a scrollable summary of the debit and credit balances for all the accounts in the chart of accounts, for the time period you select.';
                }
                action("G/L Balance by &Dimension")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Balance by &Dimension';
                    Image = GLBalanceDimension;
                    RunObject = Page "G/L Balance by Dimension";
                    ToolTip = 'View a summary of the debit and credit balances by dimensions for all accounts.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Indent Chart of Accounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Indent Chart of Accounts';
                    Image = IndentChartofAccounts;
                    RunObject = Codeunit "G/L Account-Indent";
                    ToolTip = 'Update the indentation of all of the G/L Accounts in the chart of accounts.';
                }
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

    local procedure FormatLine()
    begin
        NameIndent := Indentation;
        Emphasize := "Account Type" <> "account type"::Posting;
    end;
}

