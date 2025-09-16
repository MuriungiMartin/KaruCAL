#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 569 "Chart of Accs. (Analysis View)"
{
    Caption = 'Chart of Accs. (Analysis View)';
    Editable = false;
    PageType = List;
    SourceTable = "G/L Account (Analysis View)";
    SourceTableTemporary = true;

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
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the No. of the G/L Account you are setting up.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the name of the general ledger account.';
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the purpose of the account.';
                }
                field("Direct Posting";"Direct Posting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether you will be able to post directly or only indirectly to this general ledger account.';
                    Visible = false;
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an account interval or a list of account numbers.';
                }
                field("Gen. Posting Type";"Gen. Posting Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general posting type to use when posting to this account.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a general business posting group.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
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
                    ApplicationArea = Basic;
                    BlankZero = true;
                    DrillDownPageID = "Analysis View Entries";
                    LookupPageID = "Analysis View Entries";
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
                field("Budgeted Amount";"Budgeted Amount")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Analysis View Budget Entries";
                    LookupPageID = "Analysis View Budget Entries";
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
                    RunObject = Page "G/L Account Card";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Budget Filter"=field("Budget Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "G/L Account No."=field("No.");
                    RunPageView = sorting("G/L Account No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const("G/L Account"),
                                  "No."=field("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Basic;
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
                        ApplicationArea = Basic;
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
                    ApplicationArea = Basic;
                    Caption = 'E&xtended Text';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name"=const("G/L Account"),
                                  "No."=field("No.");
                    RunPageView = sorting("Table Name","No.","Language Code","All Language Codes","Starting Date","Ending Date");
                }
                action("Receivables-Payables")
                {
                    ApplicationArea = Basic;
                    Caption = 'Receivables-Payables';
                    Image = ReceivablesPayables;
                    RunObject = Page "Receivables-Payables";
                }
            }
            group("&Balance")
            {
                Caption = '&Balance';
                Image = Balance;
                action("G/L &Account Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L &Account Balance';
                    Image = GLAccountBalance;
                    RunObject = Page "G/L Account Balance";
                    RunPageLink = "No."=field("No."),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                  "Business Unit Filter"=field("Business Unit Filter");
                }
                action("G/L &Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L &Balance';
                    Image = GLBalance;
                    RunObject = Page "G/L Balance";
                    RunPageOnRec = true;
                }
                action("G/L Balance by &Dimension")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Balance by &Dimension';
                    Image = GLBalanceDimension;
                    RunObject = Page "G/L Balance by Dimension";
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
                    ApplicationArea = Basic;
                    Caption = 'Indent Chart of Accounts';
                    Image = IndentChartofAccounts;
                    RunObject = Codeunit "G/L Account-Indent";
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


    procedure InsertTempGLAccAnalysisViews(var GLAcc: Record "G/L Account")
    begin
        if GLAcc.Find('-') then
          repeat
            Init;
            TransferFields(GLAcc,true);
            "Account Source" := "account source"::"G/L Account";
            Insert;
          until GLAcc.Next = 0;
    end;


    procedure InsertTempCFAccountAnalysisVie(var CFAccount: Record "Cash Flow Account")
    begin
        if CFAccount.Find('-') then
          repeat
            Init;
            "No." := CFAccount."No.";
            Name := CFAccount.Name;
            "Account Type" := CFAccount."Account Type";
            Blocked := CFAccount.Blocked;
            "New Page" := CFAccount."New Page";
            "No. of Blank Lines" := CFAccount."No. of Blank Lines";
            Indentation := CFAccount.Indentation;
            "Last Date Modified" := CFAccount."Last Date Modified";
            Totaling := CFAccount.Totaling;
            Comment := CFAccount.Comment;
            "Account Source" := "account source"::"Cash Flow Account";
            Insert;
          until CFAccount.Next = 0;
    end;

    local procedure FormatLine()
    begin
        NameIndent := Indentation;
        Emphasize := "Account Type" <> "account type"::Posting;
    end;
}

