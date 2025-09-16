#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 16 "Chart of Accounts"
{
    ApplicationArea = Basic;
    Caption = 'Chart of Accounts';
    CardPageID = "G/L Account Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Periodic Activities';
    RefreshOnActivate = true;
    SourceTable = "G/L Account";
    UsageCategory = Lists;

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
                    StyleExpr = NoEmphasize;
                    ToolTip = 'Specifies the No. of the G/L Account you are setting up.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ToolTip = 'Specifies the name of the general ledger account.';
                }
                field("GIFI Code";"GIFI Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a General Index of Financial Information (GIFI) code for the account.';
                    Visible = false;
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
                    Visible = false;
                }
                field("Account Subcategory Descript.";"Account Subcategory Descript.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Account Subcategory';
                    ToolTip = 'Specifies the subcategory of the account category of the G/L account.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this.';
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

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLaccList: Page "G/L Account List";
                    begin
                        GLaccList.LookupMode(true);
                        if not (GLaccList.RunModal = Action::LookupOK) then
                          exit(false);

                        Text := GLaccList.GetSelectionFilter;
                        exit(true);
                    end;
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
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the balance on this account.';
                }
                field("Budget Controlled";"Budget Controlled")
                {
                    ApplicationArea = Basic;
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
                field("Consol. Debit Acc.";"Consol. Debit Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the account number in a consolidated company to transfer credit balances.';
                    Visible = false;
                }
                field("Consol. Credit Acc.";"Consol. Credit Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if amounts without any payment tolerance amount from the customer and vendor ledger entries are used.';
                    Visible = false;
                }
                field("Cost Type No.";"Cost Type No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a cost type number to establish which cost type a general ledger account belongs to.';
                }
                field("Consol. Translation Method";"Consol. Translation Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the consolidation translation method that will be used for the account.';
                    Visible = false;
                }
                field("Default IC Partner G/L Acc. No";"Default IC Partner G/L Acc. No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies accounts that you often enter in the Bal. Account No. field on intercompany journal or document lines.';
                    Visible = false;
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
                Visible = true;
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
                    ToolTip = 'Show or add comments.';
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
                    ToolTip = 'View additional information that has been added to the description for the current account.';
                }
                action("Receivables-Payables")
                {
                    ApplicationArea = Suite;
                    Caption = 'Receivables-Payables';
                    Image = ReceivablesPayables;
                    RunObject = Page "Receivables-Payables";
                    ToolTip = 'Show a summary of receivables and payables.';
                }
                action("Where-Used List")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Where-Used List';
                    Image = Track;
                    ToolTip = 'Show setup tables where the current account is used.';

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
                    RunObject = Page "G/L Account Balance";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter");
                    ToolTip = 'View a summary of the debit and credit balances for different time periods for the current account.';
                }
                action("G/L &Balance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L &Balance';
                    Image = GLBalance;
                    RunObject = Page "G/L Balance";
                    RunPageLink = "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter");
                    RunPageOnRec = true;
                    ToolTip = 'View a summary of the debit and credit balances for different time periods for all accounts.';
                }
                action("G/L Balance by &Dimension")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Balance by &Dimension';
                    Image = GLBalanceDimension;
                    RunObject = Page "G/L Balance by Dimension";
                    ToolTip = 'View a summary of the debit and credit balances by dimensions for all accounts.';
                }
                separator(Action52)
                {
                    Caption = '';
                }
                action("G/L Account Balance/Bud&get")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Account Balance/Bud&get';
                    Image = Period;
                    RunObject = Page "G/L Account Balance/Budget";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter"),
                                  "Budget Filter"=field("Budget Filter");
                    ToolTip = 'View a summary of the debit and credit balances and the budgeted amounts for different time periods for the current account.';
                }
                action("G/L Balance/B&udget")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Balance/B&udget';
                    Image = ChartOfAccounts;
                    RunObject = Page "G/L Balance/Budget";
                    RunPageLink = "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter"),
                                  "Budget Filter"=field("Budget Filter");
                    RunPageOnRec = true;
                    ToolTip = 'View a summary of the debit and credit balances and the budgeted amounts for different time periods for the current account.';
                }
                separator(Action55)
                {
                }
                action("Chart of Accounts &Overview")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Chart of Accounts &Overview';
                    Image = Accounts;
                    RunObject = Page "Chart of Accounts Overview";
                    ToolTip = 'View the chart of accounts with different levels of detail where you can expand or collapse a section of the chart of accounts.';
                }
            }
            action("G/L Register")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "G/L Registers";
                ToolTip = 'View posted G/L entries.';
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(IndentChartOfAccounts)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Indent Chart of Accounts';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Codeunit "G/L Account-Indent";
                    ToolTip = 'Indent accounts between a Begin-Total and the matching End-Total one level to make the chart of accounts easier to read.';
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                action("General Journal")
                {
                    ApplicationArea = Basic;
                    Caption = 'General Journal';
                    Image = Journal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "General Journal";
                    ToolTip = 'Open the general journal, for example, to record or post a payment that has no related document.';
                }
                action("Close Income Statement")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Close Income Statement';
                    Image = CloseYear;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Report "Close Income Statement";
                    ToolTip = 'Start the transfer of the year''s result to an account in the balance sheet and close the income statement accounts.';
                }
                action("Export Electr. Accounting")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Export Electr. Accounting';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Export Electr. Accounting";
                    ToolTip = 'The default is the work date year. The taxes may apply to the previous calendar year so you may want to change this date if nothing prints.';
                }
                action(DocsWithoutIC)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Documents without Incoming Document';
                    Image = Documents;
                    ToolTip = 'Show a list of posted purchase and sales documents under the G/L account that do not have related incoming document records.';

                    trigger OnAction()
                    var
                        PostedDocsWithNoIncBuf: Record "Posted Docs. With No Inc. Buf.";
                    begin
                        if "Account Type" = "account type"::Posting then
                          PostedDocsWithNoIncBuf.SetRange("G/L Account No. Filter","No.")
                        else
                          if Totaling <> '' then
                            PostedDocsWithNoIncBuf.SetFilter("G/L Account No. Filter",Totaling)
                          else
                            exit;
                        Page.Run(Page::"Posted Docs. With No Inc. Doc.",PostedDocsWithNoIncBuf);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Chart of Accounts")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Chart of Accounts';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Chart of Accounts";
                ToolTip = 'View the chart of accounts.';
            }
            action(Action1900210206)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'G/L Register';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "G/L Register";
                ToolTip = 'View posted G/L entries.';
            }
            action("Reconcile AP to GL")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Reconcile AP to GL';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Reconcile AP to GL";
                ToolTip = 'List all items that have been received on purchase orders, but you have not been invoiced. The value of these items is not reflected in the general ledger because the cost is unknown until they are invoiced. The report gives an estimated value of the purchase orders, you can use as an accrual to your general ledger.';
            }
            action("Trial Balance Detail/Summary")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance Detail/Summary';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Trial Balance Detail/Summary";
                ToolTip = 'View general ledger account balances and activities for all the selected accounts, one transaction per line. You can include general ledger accounts which have a balance and including the closing entries within the period.';
            }
            action("Trial Balance")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Trial Balance";
                ToolTip = 'View the chart of accounts that have balances and net changes.';
            }
            action("Trial Balance, Spread Periods")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance, Spread Periods';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance, Spread Periods";
                ToolTip = 'View a trial balance with amounts shown in separate columns for each time period.';
            }
            action("Consol. Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = 'Consol. Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Consolidated Trial Balance";
            }
            action("Trial Balance, per Global Dim.")
            {
                ApplicationArea = Suite;
                Caption = 'Trial Balance, per Global Dim.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance, per Global Dim.";
                ToolTip = 'View three types of departmental trial balances: current trial balance and trial balances which compare current amounts to either the prior year or to the current budget. Each department selected will have a separate trial balance generated.';
            }
            action("Trial Balance, Spread G. Dim.")
            {
                ApplicationArea = Suite;
                Caption = 'Trial Balance, Spread G. Dim.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance, Spread G. Dim.";
                ToolTip = 'View the chart of accounts with balances or net changes, with each department in a separate column. This report can be used at the close of an accounting period or fiscal year.';
            }
            action("Account Schedule Layout")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Account Schedule Layout';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Account Schedule Layout";
                ToolTip = 'Adjust the layout of the account schedule.';
            }
            action("Account Schedule")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Account Schedule';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Account Schedule";
                ToolTip = 'Set up the account schedule to analyze figures in general ledger accounts or to compare general ledger entries with general ledger budget entries.';
            }
            action("Account Balances by GIFI Code")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Account Balances by GIFI Code';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Account Balances by GIFI Code";
                ToolTip = 'Review your account balances by General Index of Financial Information (GIFI) codes.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NoEmphasize := "Account Type" <> "account type"::Posting;
        NameIndent := Indentation;
        NameEmphasize := "Account Type" <> "account type"::Posting;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewGLAcc(xRec,BelowxRec);
    end;

    var
        [InDataSet]
        NoEmphasize: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
}

