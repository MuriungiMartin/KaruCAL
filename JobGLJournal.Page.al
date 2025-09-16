#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1020 "Job G/L Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Job G/L Journal';
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
                ApplicationArea = Jobs;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    PreviewGuid := CreateGuid;
                    CurrPage.SaveRecord;
                    GenJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    PreviewGuid := CreateGuid;
                    GenJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the journal line.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                    end;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of the entry. The field is automatically filled when the Account No. field is filled.';
                }
                field("Business Unit Code";"Business Unit Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general posting type that will be used when you post the entry on this journal line.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general business posting group that will be used when you post the entry on the journal line.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general product posting group that will be used when you post the entry on the journal line.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the vendor''s Tax specification to link transactions made for this vendor with the appropriate general ledger account according to the Tax posting setup.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code of the Tax product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("VAT %";"VAT %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the relevant Tax rate for the particular combination of Tax business posting group and Tax product posting group. Do not enter the percent sign, only the number. For example, if the Tax rate is 25 %, enter 25 in this field.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total amount (including Tax) that the journal line consists of.';
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount of Tax included in the total amount.';
                    Visible = false;
                }
                field("VAT Difference";"VAT Difference")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the difference between the calculate Tax amount and the Tax amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. VAT Amount";"Bal. VAT Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount of Bal. Tax included in the total amount.';
                    Visible = false;
                }
                field("Bal. VAT Difference";"Bal. VAT Difference")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the difference between the calculate Tax amount and the Tax amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the balancing account type that should be used in this journal line.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted (for example, a cash account for cash purchases).';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type";"Bal. Gen. Posting Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.';
                }
                field("Bal. Gen. Bus. Posting Group";"Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.';
                }
                field("Bal. Gen. Prod. Posting Group";"Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.';
                }
                field("Bal. VAT Bus. Posting Group";"Bal. VAT Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code of the Tax business posting group associated with the balancing account that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group";"Bal. VAT Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code of the Tax product posting group associated with the balancing account that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bill-to/Pay-to No.";"Bill-to/Pay-to No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the address code of the customer or vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Ship-to/Order Address Code";"Ship-to/Order Address Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code that represents the payments terms that apply to the entry on the journal line.';
                    Visible = false;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                    Visible = false;
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                    Visible = false;
                }
                field("Applies-to ID";"Applies-to ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                    Visible = false;
                }
                field("On Hold";"On Hold")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if the journal line has been invoiced, and you execute the payment suggestions batch job, or you create a finance charge memo or reminder.';
                    Visible = false;
                }
                field("Bank Payment Type";"Bank Payment Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the payment journal line.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the reason code that has been entered on the journal lines.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the related job.';

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the related job task number.';

                    trigger OnValidate()
                    begin
                        if JobTaskIsSet then
                          ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Planning Line No.";"Job Planning Line No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job planning line number to which the usage should be linked when the Job Journal is posted. You can only link to Job Planning Lines that have the Apply Usage Link option enabled.';
                    Visible = false;
                }
                field("Job Line Type";"Job Line Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the planning line(s) that was created together with the posting of a job ledger entry from the purchase line.';
                }
                field("Job Unit Of Measure Code";"Job Unit Of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit of measure code that is used to determine the unit price. This code specifies how the quantity is measured, for example, by the box or by the piece. The application retrieves this code from the corresponding item or resource card.';
                    Visible = false;
                }
                field("Job Quantity";"Job Quantity")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity for the job ledger entry that is derived from posting the journal line. If the Job Quantity is 0, the total amount on the job ledger entry will also be 0.';
                }
                field("Job Unit Cost";"Job Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job cost of one unit of the item or resource on the journal line. The value is calculated as follows: Job Total Cost ($) / Job Quantity.';
                }
                field("Job Unit Cost (LCY)";"Job Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job cost of one unit of the item or resource on the journal line, in the local currency. The value is calculated as follows: Job Total Cost ($) / Job Quantity.';
                }
                field("Job Total Cost";"Job Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if you have assigned a job number and a job task number to the journal line. It shows the amount excluding Tax divided by the job quantity for the journal line. The amount is shown in the currency specified for the job. The value field is calculated as follows: (Amount - Tax Amount) x (Job Currency Rate/Currency Rate).';
                }
                field("Job Total Cost (LCY)";"Job Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job total cost if you have assigned a job number and a job task number to the journal line. It shows the Amount ($) excluding Tax Amount ($)for the journal line.';
                }
                field("Job Unit Price";"Job Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit price for the selected account type and account number on the journal line.';
                }
                field("Job Unit Price (LCY)";"Job Unit Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit price, in the local currency, for the selected account type and account number on the journal line.';
                    Visible = false;
                }
                field("Job Line Amount";"Job Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line amount of the job ledger entry that was posted from the purchase line.';
                }
                field("Job Line Amount (LCY)";"Job Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line amount of the job ledger entry that was posted from the purchase line.';
                }
                field("Job Line Discount Amount";"Job Line Discount Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line discount amount of the job ledger entry that was posted from the purchase line. The amount is shown in the currency specified for the job.';
                }
                field("Job Line Discount %";"Job Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job line discount percentage that will be used for the job ledger entry. If you have set up a job-specific line discount percentage for the account type and account number, then it is inserted automatically. Otherwise, the discount percentage is based on the discount that is set up on the customer or item card.';
                }
                field("Job Total Price";"Job Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price for the journal line. The value is calculated as follows: Quantity x Unit Price ($).';
                    Visible = false;
                }
                field("Job Total Price (LCY)";"Job Total Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price for the journal line, in the local currency. The value is calculated as follows: Quantity x Unit Price ($).';
                }
                field("Job Remaining Qty.";"Job Remaining Qty.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity of the item that remains to complete a job.';
                    Visible = false;
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
                            ApplicationArea = Jobs;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        field(BalAccName;BalAccName)
                        {
                            ApplicationArea = Jobs;
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
                            ToolTip = 'Specifies the balance that has accumulated in the journal on the line that you selected.';
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
                    ApplicationArea = Jobs;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

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
                    ApplicationArea = Jobs;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record that is being processed on the journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Jobs;
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
                action("Renumber Document Numbers")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Renumber Document Numbers';
                    Image = EditLines;
                    ToolTip = 'Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.';

                    trigger OnAction()
                    begin
                        RenumberDocumentNo
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';
                    ToolTip = 'View what has been reconciled for the job. The window shows the quantity entered on the job journal lines, totaled by unit of measure and by work type.';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.Run;
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    begin
                        GenJnlPost.Preview(Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Jobs;
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
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        UpdateBalance;
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        PreviewGuid := CreateGuid;
    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        PreviewGuid := CreateGuid;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        PreviewGuid := CreateGuid;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance;
        SetUpNewLine(xRec,Balance,BelowxRec);
        Clear(ShortcutDimCode);
        Clear(AccName);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        PreviewGuid := CreateGuid;
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          exit;
        end;
        GenJnlManagement.TemplateSelection(Page::"Job G/L Journal",7,false,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ChangeExchangeRate: Page "Change Exchange Rate";
        GLReconcile: Page Reconciliation;
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
        PreviewGuid: Guid;

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
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

