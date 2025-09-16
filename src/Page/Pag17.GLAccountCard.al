#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 17 "G/L Account Card"
{
    Caption = 'G/L Account Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Account,Balance';
    RefreshOnActivate = true;
    SourceTable = "G/L Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the No. of the G/L Account you are setting up.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the general ledger account.';
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field("Account Category";"Account Category")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the category of the G/L account.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(SubCategoryDescription;SubCategoryDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Account Subcategory';
                    ToolTip = 'Specifies the subcategory of the account category of the G/L account.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupAccountSubCategory;
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        ValidateAccountSubCategory(SubCategoryDescription);
                        CurrPage.Update;
                    end;
                }
                field("GIFI Code";"GIFI Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a General Index of Financial Information (GIFI) code for the account.';
                }
                field("Debit/Credit";"Debit/Credit")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of entries that will normally be posted to this general ledger account.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this.';
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an account interval or a list of account numbers.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccountList: Page "G/L Account List";
                        OldText: Text;
                    begin
                        OldText := Text;
                        GLAccountList.LookupMode(true);
                        if not (GLAccountList.RunModal = Action::LookupOK) then
                          exit(false);

                        Text := OldText + GLAccountList.GetSelectionFilter;
                        exit(true);
                    end;
                }
                field("No. of Blank Lines";"No. of Blank Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of blank lines that you want inserted before this account in the chart of accounts.';
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether you want a new page to start immediately after this general ledger account when you print the chart of accounts. Select this field to start a new page after this general ledger account.';
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies a search name.';
                }
                field("Budget Controlled";"Budget Controlled")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the balance on this account.';
                }
                field("Reconciliation Account";"Reconciliation Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether this general ledger account will be included in the Reconciliation window in the general journal. To have the G/L account included in the window, place a check mark in the check box. You can find the Reconciliation window by clicking Actions, Posting in the General Journal window.';
                }
                field("Automatic Ext. Texts";"Automatic Ext. Texts")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that an extended text will be added automatically to the account.';
                }
                field("Direct Posting";"Direct Posting")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether you will be able to post directly or only indirectly to this general ledger account. To allow Direct Posting to the G/L account, place a check mark in the check box.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that entries cannot be posted to the G/L account.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when the G/L account was last modified.';
                }
                field("Omit Default Descr. in Jnl.";"Omit Default Descr. in Jnl.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the default description is automatically inserted in the Description field on journal lines created for this general ledger account.';
                }
                field("SAT Account Code";"SAT Account Code")
                {
                    ApplicationArea = Basic,Suite;
                    TableRelation = "SAT Account Code";
                    ToolTip = 'Specifies the account for electronic documents to the tax authorities.';
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Gen. Posting Type";"Gen. Posting Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general posting type to use when posting to this account.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the general business posting group that applies to the entry.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies a general product posting group code.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies a Tax Bus. Posting Group.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies a Tax Prod. Posting Group code.';
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("Default IC Partner G/L Acc. No";"Default IC Partner G/L Acc. No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies accounts that you often enter in the Bal. Account No. field on intercompany journal or document lines.';
                }
                field("Default Deferral Template Code";"Default Deferral Template Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Default Deferral Template';
                    ToolTip = 'Specifies the default deferral template that governs how to defer revenues and expenses to the periods when they occurred.';
                }
            }
            group(Consolidation)
            {
                Caption = 'Consolidation';
                field("Consol. Debit Acc.";"Consol. Debit Acc.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the account in a consolidated company to which to transfer debit balances on this account.';
                }
                field("Consol. Credit Acc.";"Consol. Credit Acc.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the account in a consolidated company to which to transfer credit balances on this account.';
                }
                field("Consol. Translation Method";"Consol. Translation Method")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the account''s consolidation translation method, which identifies the currency translation rate to be applied to the account.';
                }
            }
            group(Reporting)
            {
                Caption = 'Reporting';
                field("Exchange Rate Adjustment";"Exchange Rate Adjustment")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies how general ledger accounts will be adjusted for exchange rate fluctuations between $ and the additional reporting currency.';
                }
            }
            group("Cost Accounting")
            {
                Caption = 'Cost Accounting';
                field("Cost Type No.";"Cost Type No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies a cost type number to establish which cost type a general ledger account belongs to.';
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
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
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
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const("G/L Account"),
                                  "No."=field("No.");
                    ToolTip = 'View or add comments to the account.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
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
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
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
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    RunObject = Page "Receivables-Payables";
                    ToolTip = 'View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.';
                }
                action("Where-Used List")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Where-Used List';
                    Image = Track;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
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
                    PromotedCategory = Category5;
                    PromotedOnly = true;
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
                    PromotedCategory = Category5;
                    PromotedOnly = true;
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
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "G/L Balance by Dimension";
                    ToolTip = 'View a summary of the debit and credit balances by dimensions for the current account.';
                }
            }
            action("General Posting Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'General Posting Setup';
                Image = GeneralPostingSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "General Posting Setup";
                ToolTip = 'View or edit how you want to set up combinations of general business and general product posting groups.';
            }
            action("Tax Posting Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Tax Posting Setup';
                Image = VATPostingSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "VAT Posting Setup";
                ToolTip = 'View or edit combinations of Tax business posting groups and Tax product posting groups.';
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
            action(DocsWithoutIC)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Posted Documents without Incoming Document';
                Image = Documents;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
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
            action("Export GIFI Info. to Excel")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Export GIFI Info. to Excel';
                Image = ExportToExcel;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Export GIFI Info. to Excel";
                ToolTip = 'Export balance information using General Index of Financial Information (GIFI) codes and save the exported file in Excel. You can use the file to transfer information to your tax preparation software.';
            }
            action("Consol. Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = 'Consol. Trial Balance';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Consolidated Trial Balance";
            }
            action(Action1900210206)
            {
                ApplicationArea = Suite;
                Caption = 'G/L Register';
                Image = GLRegisters;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "G/L Register";
                ToolTip = 'View posted G/L entries.';
            }
            action("Trial Balance Detail/Summary")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance Detail/Summary';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance Detail/Summary";
                ToolTip = 'View general ledger account balances and activities for all the selected accounts, one transaction per line. You can include general ledger accounts which have a balance and including the closing entries within the period.';
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
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Apply Template")
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    ToolTip = 'Select a configuration template to quickly create a general ledger account.';

                    trigger OnAction()
                    var
                        ConfigTemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Account Subcategory Descript.");
        SubCategoryDescription := "Account Subcategory Descript.";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewGLAcc(xRec,BelowxRec);
    end;

    var
        SubCategoryDescription: Text[80];
}

