#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 283 "Recurring General Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Recurring General Journal';
    DataCaptionExpression = DataCaption;
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
                ApplicationArea = Suite;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the batch name on the recurring general journal.';

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
                field("Recurring Method";"Recurring Method")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a recurring method if the Recurring field of the General Journal Template table indicates the journal is recurring.';
                }
                field("Recurring Frequency";"Recurring Frequency")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a recurring frequency if the Recurring field of the General Journal Template table indicates the journal is recurring.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the journal line.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                    end;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the depreciation book to which the line will be posted, if you have selected Fixed Asset in the Account Type field.';
                    Visible = false;
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the FA posting type, if you have selected Fixed Asset in the Account Type field.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the entry. The field is automatically filled when the Account No. field is filled.';
                }
                field("Business Unit Code";"Business Unit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the business unit that the entry derives from in a consolidated company.';
                    Visible = false;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the salesperson or purchaser who is linked to the journal line.';
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
                    ToolTip = 'Specifies the code of the currency for the amounts on the journal line.';
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
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general posting type that will be used when you post the entry on this journal line.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general business posting group that will be used when you post the entry on the journal line.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general product posting group that will be used when you post the entry on the journal line.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax business posting group code that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the Tax product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Debit Amount";"Debit Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the total amount (including tax) that the journal line consists of, if it is a debit amount.';
                    Visible = false;
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the total amount (including tax) that the journal line consists of, if it is a credit amount.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the total amount (including tax) that the journal line consists of.';
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount of Tax included in the total amount.';
                    Visible = false;
                }
                field("VAT Difference";"VAT Difference")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the difference between the calculate tax amount and the tax amount that you have entered manually.';
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
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code that represents the payments terms that apply to the entry on the journal line.';
                    Visible = false;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the journal line will be applied to an already-posted document.';
                    Visible = false;
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the journal line will be applied to an already-posted document.';
                    Visible = false;
                }
                field("Applies-to ID";"Applies-to ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entries that will be applied to by the journal line if you use the Apply Entries facility.';
                    Visible = false;
                }
                field("On Hold";"On Hold")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the journal line has been invoiced and you execute the payment suggestions batch job, or a finance charge memo or reminder.';
                    Visible = false;
                }
                field("Bank Payment Type";"Bank Payment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the payment journal line.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the reason code that has been entered on the journal lines.';
                    Visible = false;
                }
                field("Allocated Amt. (LCY)";"Allocated Amt. (LCY)")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount that has been allocated when you have used the Allocations function in the Gen. Jnl. Allocation table.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        GenJnlAlloc.Reset;
                        GenJnlAlloc.SetRange("Journal Template Name","Journal Template Name");
                        GenJnlAlloc.SetRange("Journal Batch Name","Journal Batch Name");
                        GenJnlAlloc.SetRange("Journal Line No.","Line No.");
                        Page.RunModal(Page::Allocations,GenJnlAlloc);
                        CurrPage.Update(false);
                    end;
                }
                field("Bill-to/Pay-to No.";"Bill-to/Pay-to No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the address code of the customer or vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Ship-to/Order Address Code";"Ship-to/Order Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the last date the recurring journal will be posted, if you have indicated in the journal is recurring.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a comment related to registering a payment.';
                    Visible = false;
                }
            }
            group(Control28)
            {
                fixed(Control1902205001)
                {
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName;AccName)
                        {
                            ApplicationArea = Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the account.';
                        }
                    }
                    group(Control1903866901)
                    {
                        Caption = 'Balance';
                        field(Balance;Balance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the recurring general journal on the line where the cursor is.';
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
                            ToolTip = 'Specifies the total balance in the recurring general journal.';
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
                action(Allocations)
                {
                    ApplicationArea = Suite;
                    Caption = 'Allocations';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Allocations;
                    RunPageLink = "Journal Template Name"=field("Journal Template Name"),
                                  "Journal Batch Name"=field("Journal Batch Name"),
                                  "Journal Line No."=field("Line No.");
                    ToolTip = 'Allocate the amount on the selected journal line to the accounts that you specify.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
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
                    ApplicationArea = Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record that is being processed on the journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Suite;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Insert Conv. $ Rndg. Lines")
                {
                    ApplicationArea = Suite;
                    Caption = 'Insert Conv. $ Rndg. Lines';
                    Image = InsertCurrency;
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                    ToolTip = 'Insert a rounding correction line in the journal. This rounding correction line will balance in $ when amounts in the foreign currency also balance. You can then post the journal.';
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-Post";
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                }
                action(Preview)
                {
                    ApplicationArea = Suite;
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
                    ApplicationArea = Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-Post+Print";
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
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
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          exit;
        end;
        GenJnlManagement.TemplateSelection(Page::"Recurring General Journal",0,true,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        GenJnlAlloc: Record "Gen. Jnl. Allocation";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ChangeExchangeRate: Page "Change Exchange Rate";
        CurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        ShortcutDimCode: array [8] of Code[20];
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(
          Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

