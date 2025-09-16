#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5628 "Fixed Asset G/L Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Fixed Asset G/L Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch of the general journal.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    GenJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the same date as the FA Posting Date field when the line is posted.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the journal line.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the appropriate document type for the amount you want to post.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a document number referring to the customer or vendor numbering system with whom you are trading items on this journal line.';
                    Visible = false;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccountName);
                    end;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccountName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the depreciation book to which the line will be posted.';
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the appropriate posting type for the amount you want to post.';
                }
                field(GetAddCurrCode;GetAddCurrCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'FA Add.-Currency Code';
                    Editable = false;
                    ToolTip = 'Specifies the code of the additional reporting currency, if you post in an additional reporting currency.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameterFA("FA Add.-Currency Factor",GetAddCurrCode,"Posting Date");
                        if ChangeExchangeRate.RunModal = Action::OK then
                          "FA Add.-Currency Factor" := ChangeExchangeRate.GetParameter;

                        Clear(ChangeExchangeRate);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the description from the fixed asset card when the FA No. field is filled in.';
                }
                field("Business Unit Code";"Business Unit Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.';
                    Visible = false;
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the campaign the journal line is linked to.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    AssistEdit = true;
                    ToolTip = 'Specifies the code for the currency if the amount is in a foreign currency.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        if ChangeExchangeRate.RunModal = Action::OK then
                          Validate("Currency Factor",ChangeExchangeRate.GetParameter);

                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Gen. Posting Type";"Gen. Posting Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the general posting type that will be used when you post the entry on this journal line.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the general business posting group that applies to the entry.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the general product posting group that will be used when you post the entry on the journal line.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the vendor''s Tax specification to link transactions made for this vendor with the appropriate general ledger account according to the Tax posting setup.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a Tax product posting group code.';
                    Visible = false;
                }
                field("Debit Amount";"Debit Amount")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a debit entry if the value in the Amount field is positive. A negative amount indicates a corrective entry.';
                    Visible = false;
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the total of the credit entries for the fixed asset.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the total amount the journal line consists of.';
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the amount of Tax included in the total amount.';
                    Visible = false;
                }
                field("VAT Difference";"VAT Difference")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the difference between the calculate Tax amount and the Tax amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. VAT Amount";"Bal. VAT Amount")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the amount of Bal. Tax included in the total amount.';
                    Visible = false;
                }
                field("Bal. VAT Difference";"Bal. VAT Difference")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the difference between the calculate Tax amount and the Tax amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the type of balancing account used in the entry: G/L Account, Bank Account, or Fixed Asset.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the balancing account used on the entry.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccountName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type";"Bal. Gen. Posting Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.';
                }
                field("Bal. Gen. Prod. Posting Group";"Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.';
                }
                field("Bal. VAT Bus. Posting Group";"Bal. VAT Bus. Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code of the Tax business posting group associated with the balancing account that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group";"Bal. VAT Prod. Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code of the Tax product posting group associated with the balancing account that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. Gen. Bus. Posting Group";"Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code that represents the payment terms that apply to the entry on the journal line.';
                    Visible = false;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                    Visible = false;
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                    Visible = false;
                }
                field("Applies-to ID";"Applies-to ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                    Visible = false;
                }
                field("On Hold";"On Hold")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies if the journal line has been invoiced, and you execute the payment suggestions batch job, or you create a finance charge memo or reminder.';
                    Visible = false;
                }
                field("Bank Payment Type";"Bank Payment Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the payment journal line.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reason code that will be inserted on the journal lines.';
                    Visible = false;
                }
                field("FA Posting Date";"FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date that will be used as the posting date on FA ledger entries.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Salvage Value";"Salvage Value")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the estimated residual value of a fixed asset when it can no longer be used.';
                    Visible = false;
                }
                field("No. of Depreciation Days";"No. of Depreciation Days")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of depreciation days if you have selected the Depreciation or Custom 1 option in the FA Posting Type field.';
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether to automatically post depreciation of the existing (old) fixed asset.';
                }
                field("Depr. Acquisition Cost";"Depr. Acquisition Cost")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether to post an additional acquisition cost and a possible salvage value to an acquired asset.';
                }
                field("Maintenance Code";"Maintenance Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a maintenance code.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Insurance No.";"Insurance No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies an insurance code if you have selected the Acquisition Cost option in the FA Posting Type field.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Budgeted FA No.";"Budgeted FA No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a fixed asset number.';
                }
                field("Duplicate in Depreciation Book";"Duplicate in Depreciation Book")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
                    Visible = false;
                }
                field("Use Duplication List";"Use Duplication List")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether the line is to be posted to all depreciation books, using different journal batches and with a check mark in the Part of Duplication List field.';
                    Visible = false;
                }
                field("FA Reclassification Entry";"FA Reclassification Entry")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies if the entry was generated from a fixed asset reclassification journal.';
                }
                field("FA Error Entry No.";"FA Error Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of a posted FA ledger entry to mark as an error entry.';
                }
            }
            group(Control30)
            {
                fixed(Control1901776101)
                {
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName;AccName)
                        {
                            ApplicationArea = FixedAssets;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        field(BalAccountName;BalAccountName)
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Bal. Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
                        }
                    }
                    group(Control1902759701)
                    {
                        Caption = 'Balance';
                        field(Balance;Balance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the journal.';
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field(TotalBalance;TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            ToolTip = 'Specifies the total balance in the journal.';
                            Visible = TotalBalanceVisible;
                        }
                    }
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the fixed asset.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the ledger entries for the selected fixed asset.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Renumber Document Numbers")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Renumber Document Numbers';
                    Image = EditLines;
                    ToolTip = 'Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.';

                    trigger OnAction()
                    begin
                        RenumberDocumentNo
                    end;
                }
                action("Apply Entries")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Apply open entries for the relevant account type.';
                }
                action("Insert FA &Bal. Account")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insert FA &Bal. Account';
                    Image = InsertBalanceAccount;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Insert the balancing account(s), on new journal lines, for the main account(s) on the journal line(s). This requires that balancing accounts are set up in the FA Posting Groups window for the related fixed asset transaction, such as acquisition cost, depreciation, write-down, or maintenance.';

                    trigger OnAction()
                    var
                        GenJnlLine: Record "Gen. Journal Line";
                        FAGetBalAcc: Codeunit "FA Get Balance Account";
                    begin
                        GenJnlLine.Copy(Rec);
                        CurrPage.SetSelectionFilter(GenJnlLine);
                        FAGetBalAcc.InsertAcc(GenJnlLine);
                    end;
                }
                action("Insert Conv. $ Rndg. Lines")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insert Conv. $ Rndg. Lines';
                    Image = InsertCurrency;
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                    ToolTip = 'Specifies amounts in $ if you enter foreign currency amounts in a general journal. However, even if all the journal lines balance in the foreign currency, when each journal line is converted and rounded to $, their $ sum may not balance. This means that a balanced transaction in foreign currency may not balance in $, and can therefore not be posted.';
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';
                    ToolTip = 'Review what effect posting the journal will have on general ledger accounts.';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.Run;
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    begin
                        GenJnlPost.Preview(Rec);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post+Print",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccountName);
        UpdateBalance;
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance;
        SetUpNewLine(xRec,Balance,BelowxRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        BalAccountName := '';
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          exit;
        end;
        GenJnlManagement.TemplateSelection(Page::"Fixed Asset G/L Journal",5,false,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ChangeExchangeRate: Page "Change Exchange Rate";
        GLReconcile: Page Reconciliation;
        CurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccountName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        AddCurrCodeIsFound: Boolean;
        ShortcutDimCode: array [8] of Code[20];
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure GetAddCurrCode(): Code[10]
    begin
        if not AddCurrCodeIsFound then begin
          AddCurrCodeIsFound := true;
          GLSetup.Get;
        end;
        exit(GLSetup."Additional Reporting Currency");
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

