#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 256 "Payment Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Payment Journal';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Bank,Prepare,Approve';
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the batch name on the payment journal.';

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
                    ApplicationArea = Basic,Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the journal line.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Incoming Document Entry No.";"Incoming Document Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the incoming document that this general journal line is created for.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        if "Incoming Document Entry No." > 0 then
                          Hyperlink(GetIncomingDocumentURL);
                    end;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Applies-to Ext. Doc. No.";"Applies-to Ext. Doc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the external document number that will be exported in the payment file.';
                    Visible = false;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                    end;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Recipient Bank Account";"Recipient Bank Account")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the bank account that the amount will be transferred to after it has been exported from the payment journal.';
                }
                field("Message to Recipient";"Message to Recipient")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies a description of the entry. The field is automatically filled when the Account No. field is filled.';
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
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general posting type that will be used when you post the entry on this journal line.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
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
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total amount (including tax) that the journal line consists of, if it is a debit amount. The amount must be entered in the currency represented by the currency code on the line.';
                    Visible = false;
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total amount (including tax) that the journal line consists of, if it is a credit amount. The amount must be entered in the currency represented by the currency code on the line.';
                    Visible = false;
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the payment method that was used to make the payment that resulted in the entry.';
                }
                field("Payment Reference";"Payment Reference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Creditor No.";"Creditor No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the vendor who sent the purchase invoice.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ToolTip = 'Specifies the total amount (including tax) that the journal line consists of.';
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of Tax included in the total amount.';
                    Visible = false;
                }
                field("VAT Difference";"VAT Difference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the difference between the calculate tax amount and the tax amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. VAT Amount";"Bal. VAT Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of Bal. Tax included in the total amount.';
                    Visible = false;
                }
                field("Bal. VAT Difference";"Bal. VAT Difference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the difference between the calculate tax amount and the tax amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the balancing account type that should be used in this journal line.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted (for example, a cash account for cash purchases).';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type";"Bal. Gen. Posting Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general posting type that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. Gen. Bus. Posting Group";"Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. Gen. Prod. Posting Group";"Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Bus. Posting Group";"Bal. VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the Tax business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group";"Bal. VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the Tax product posting group that will be used when you post the entry on the journal line.';
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
                field("Applied (Yes/No)";IsApplied)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied (Yes/No)';
                    ToolTip = 'Specifies if the payment has been applied.';
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to ID";"Applies-to ID")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the entries that will be applied to by the journal line if you use the Apply Entries facility.';
                    Visible = false;
                }
                field(GetAppliesToDocDueDate;GetAppliesToDocDueDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applies-to Doc. Due Date';
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the due date from the Applies-to Doc. on the journal line.';
                }
                field("Bank Payment Type";"Bank Payment Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the payment journal line.';
                }
                field("Foreign Exchange Indicator";"Foreign Exchange Indicator")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an exchange indicator for the journal line. This is a required field. You can edit this field in the Purchase Journal window.';
                    Visible = false;
                }
                field("Foreign Exchange Ref.Indicator";"Foreign Exchange Ref.Indicator")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an exchange reference indicator for the journal line. This is a required field. You can edit this field in the Purchase Journal and the Payment Journal window.';
                    Visible = false;
                }
                field("Foreign Exchange Reference";"Foreign Exchange Reference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a foreign exchange reference code. This is a required field. You can edit this field in the Purchase Journal window.';
                    Visible = false;
                }
                field("Origin. DFI ID Qualifier";"Origin. DFI ID Qualifier")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the financial institution that will initiate the payment transactions sent by the originator. Select an ID for the originator''s Designated Financial Institution (DFI). This is a required field. You can edit this field in the Payment Journal window and the Purchase Journal window.';
                    Visible = false;
                }
                field("Receiv. DFI ID Qualifier";"Receiv. DFI ID Qualifier")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the financial institution that will receive the payment transactions. Select an ID for the receiver''s Designated Financial Institution (DFI). This is a required field. You can edit this field in the Payment Journal window and the Purchase Journal window.';
                    Visible = false;
                }
                field("Transaction Type Code";"Transaction Type Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a transaction type code for the general journal line. This code identifies the transaction type for the Electronic Funds Transfer (EFT).';
                }
                field("Gateway Operator OFAC Scr.Inc";"Gateway Operator OFAC Scr.Inc")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an Office of Foreign Assets Control (OFAC) gateway operator screening indicator. This is a required field. You can edit this field in the Payment Journal window and the Purchase Journal window.';
                    Visible = false;
                }
                field("Secondary OFAC Scr.Indicator";"Secondary OFAC Scr.Indicator")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a secondary Office of Foreign Assets Control (OFAC) gateway operator screening indicator. This is a required field. You can edit this field in the Payment Journal window and the Purchase Journal window.';
                    Visible = false;
                }
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a transaction code for the general journal line. This code identifies the transaction type for the Electronic Funds Transfer (EFT).';
                    Visible = false;
                }
                field("Company Entry Description";"Company Entry Description")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a company description for the journal line.';
                    Visible = false;
                }
                field("Payment Related Information 1";"Payment Related Information 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies payment related information for the general journal line.';
                    Visible = false;
                }
                field("Payment Related Information 2";"Payment Related Information 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional payment related information for the general journal line.';
                    Visible = false;
                }
                field("Check Printed";"Check Printed")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether a check has been printed for the amount on the payment journal line.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the reason code that has been entered on the journal lines.';
                    Visible = false;
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the customer or vendor that the payment relates to.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the customer or vendor that the payment relates to.';
                    Visible = false;
                }
                field(Control3;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a comment related to registering a payment.';
                    Visible = false;
                }
                field("Exported to Payment File";"Exported to Payment File")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the payment journal line was exported to a payment file.';
                    Visible = false;
                }
                field(TotalExportedAmount;TotalExportedAmount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Total Exported Amount';
                    DrillDown = true;
                    ToolTip = 'Specifies the amount for the payment journal line that has been exported to payment files that are not canceled.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownExportedAmount
                    end;
                }
                field("Has Payment Export Error";"Has Payment Export Error")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that an error occurred when you used the Export Payments to File function in the Payment Journal window.';
                    Visible = false;
                }
            }
            group(Control24)
            {
                fixed(Control80)
                {
                    group(Control82)
                    {
                        field(OverdueWarningText;OverdueWarningText)
                        {
                            ApplicationArea = Basic,Suite;
                            Style = Unfavorable;
                            StyleExpr = true;
                            ToolTip = 'Specifies the text that is displayed for overdue payments.';
                        }
                    }
                }
                fixed(Control1903561801)
                {
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName;AccName)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the account.';
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        field(BalAccName;BalAccName)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Bal. Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
                        }
                    }
                    group(Control1900545401)
                    {
                        Caption = 'Balance';
                        field(Balance;Balance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the payment journal on the line where the cursor is.';
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
                            ToolTip = 'Specifies the total balance in the payment journal.';
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic,Suite;
                ShowFilter = false;
            }
            part(Control7;"Payment Journal Errors Part")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Payment File Errors';
                SubPageLink = "Journal Template Name"=field("Journal Template Name"),
                              "Journal Batch Name"=field("Journal Batch Name"),
                              "Journal Line No."=field("Line No.");
            }
            part(Control1900919607;"Dimension Set Entries FactBox")
            {
                SubPageLink = "Dimension Set ID"=field("Dimension Set ID");
                Visible = false;
            }
            part(WorkflowStatusBatch;"Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Caption = 'Batch Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnBatch;
            }
            part(WorkflowStatusLine;"Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Caption = 'Line Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnLine;
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
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Incoming Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ToolTip = 'View or create an incoming document record that is linked to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        Validate("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RecordId));
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record that is being processed on the journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic,Suite;
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
            group("&Payments")
            {
                Caption = '&Payments';
                Image = Payment;
                action(SuggestVendorPayments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Suggest Vendor Payments';
                    Ellipsis = true;
                    Image = SuggestVendorPayments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Create payment suggestion as lines in the payment journal.';

                    trigger OnAction()
                    var
                        SuggestVendorPayments: Report "Suggest Vendor Payments";
                    begin
                        Clear(SuggestVendorPayments);
                        SuggestVendorPayments.SetGenJnlLine(Rec);
                        SuggestVendorPayments.RunModal;
                    end;
                }
                action(PreviewCheck)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'P&review Check';
                    Image = ViewCheck;
                    RunObject = Page "Check Preview";
                    RunPageLink = "Journal Template Name"=field("Journal Template Name"),
                                  "Journal Batch Name"=field("Journal Batch Name"),
                                  "Line No."=field("Line No.");
                    ToolTip = 'Preview the check before printing it.';
                }
                action(PrintCheck)
                {
                    AccessByPermission = TableData "Check Ledger Entry"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Print Check';
                    Ellipsis = true;
                    Image = PrintCheck;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Prepare to print the check.';

                    trigger OnAction()
                    begin
                        GenJnlLine.Reset;
                        GenJnlLine.Copy(Rec);
                        GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
                        GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
                        DocPrint.PrintCheck(GenJnlLine);
                        Codeunit.Run(Codeunit::"Adjust Gen. Journal Balance",Rec);
                    end;
                }
                group("Electronic Payments")
                {
                    Caption = 'Electronic Payments';
                    Image = ElectronicPayment;
                    action("E&xport")
                    {
                        ApplicationArea = Basic;
                        Caption = 'E&xport';
                        Ellipsis = true;
                        Image = Export;
                        Promoted = true;
                        PromotedCategory = Process;
                        ToolTip = 'Export payments on journal lines that are set to electronic payment to a file prior to transmitting the file to your bank.';

                        trigger OnAction()
                        var
                            BankAccount: Record "Bank Account";
                            BulkVendorRemitReporting: Codeunit "Bulk Vendor Remit Reporting";
                            GenJnlLineRecordRef: RecordRef;
                        begin
                            GenJnlLine.Reset;
                            GenJnlLine := Rec;
                            GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
                            GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");

                            if (("Bal. Account Type" = "bal. account type"::"Bank Account") and
                                BankAccount.Get("Bal. Account No.") and (BankAccount."Payment Export Format" <> ''))
                            then begin
                              Codeunit.Run(Codeunit::"Export Payment File (Yes/No)",GenJnlLine);
                              exit;
                            end;

                            if GenJnlLine.IsExportedToPaymentFile then
                              if not Confirm(ExportAgainQst) then
                                exit;

                            GenJnlLineRecordRef.GetTable(GenJnlLine);
                            GenJnlLineRecordRef.SetView(GenJnlLine.GetView);
                            BulkVendorRemitReporting.RunWithRecord(GenJnlLine);
                        end;
                    }
                    action(Void)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Void';
                        Ellipsis = true;
                        Image = VoidElectronicDocument;
                        Promoted = true;
                        PromotedCategory = Process;
                        ToolTip = 'Void the exported electronic payment file.';

                        trigger OnAction()
                        begin
                            GenJnlLine.Reset;
                            GenJnlLine := Rec;
                            GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
                            GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
                            Clear(VoidTransmitElecPayments);
                            VoidTransmitElecPayments.SetUsageType(1);   // Void
                            VoidTransmitElecPayments.SetTableview(GenJnlLine);
                            VoidTransmitElecPayments.RunModal;
                        end;
                    }
                    action(Transmit)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Transmit';
                        Ellipsis = true;
                        Image = TransmitElectronicDoc;
                        Promoted = true;
                        PromotedCategory = Process;
                        ToolTip = 'Transmit the exported electronic payment file to the bank.';

                        trigger OnAction()
                        begin
                            GenJnlLine.Reset;
                            GenJnlLine := Rec;
                            GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
                            GenJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
                            Clear(VoidTransmitElecPayments);
                            VoidTransmitElecPayments.SetUsageType(2);   // Transmit
                            VoidTransmitElecPayments.SetTableview(GenJnlLine);
                            VoidTransmitElecPayments.RunModal;
                        end;
                    }
                }
                action("Void Check")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Void Check';
                    Image = VoidCheck;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Void the check if, for example, the check is not cashed by the bank.';

                    trigger OnAction()
                    begin
                        TestField("Bank Payment Type","bank payment type"::"Computer Check");
                        TestField("Check Printed",true);
                        if Confirm(Text000,false,"Document No.") then
                          CheckManagement.VoidCheck(Rec);
                    end;
                }
                action("Void &All Checks")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Void &All Checks';
                    Image = VoidAllChecks;
                    ToolTip = 'Void all checks if, for example, the checks are not cashed by the bank.';

                    trigger OnAction()
                    begin
                        if Confirm(Text001,false) then begin
                          GenJnlLine.Reset;
                          GenJnlLine.Copy(Rec);
                          GenJnlLine.SetRange("Bank Payment Type","bank payment type"::"Computer Check");
                          GenJnlLine.SetRange("Check Printed",true);
                          if GenJnlLine.Find('-') then
                            repeat
                              GenJnlLine2 := GenJnlLine;
                              CheckManagement.VoidCheck(GenJnlLine2);
                            until GenJnlLine.Next = 0;
                        end;
                    end;
                }
                action(CreditTransferRegEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Credit Transfer Reg. Entries';
                    Image = ExportReceipt;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-Show CT Entries";
                    ToolTip = 'View or edit the credit transfer entries that are related to file export for credit transfers.';
                }
                action(CreditTransferRegisters)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Credit Transfer Registers';
                    Image = ExportElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Credit Transfer Registers";
                    ToolTip = 'View or edit the payment files that have been exported in connection with credit transfers.';
                }
            }
            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry"=R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Image = Approvals;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    GetCurrentlySelectedLines(GenJournalLine);
                    ApprovalsMgmt.ShowJournalApprovalEntries(GenJournalLine);
                end;
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
                    ApplicationArea = Basic,Suite;
                    Caption = 'Renumber Document Numbers';
                    Image = EditLines;
                    ToolTip = 'Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.';

                    trigger OnAction()
                    begin
                        RenumberDocumentNo
                    end;
                }
                action(ApplyEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';
                }
                action(ExportPaymentsToFile)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Export Payments to File';
                    Ellipsis = true;
                    Image = ExportFile;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Export a file with the payment information on the journal lines.';

                    trigger OnAction()
                    var
                        GenJnlLine: Record "Gen. Journal Line";
                    begin
                        GenJnlLine.CopyFilters(Rec);
                        GenJnlLine.FindFirst;
                        GenJnlLine.ExportPaymentFile;
                    end;
                }
                action(CalculatePostingDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Calculate Posting Date';
                    Image = CalcWorkCenterCalendar;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Calculate the date that will appear as the posting date on the journal lines.';

                    trigger OnAction()
                    begin
                        CalculatePostingDate;
                    end;
                }
                action("Insert Conv. $ Rndg. Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Insert Conv. $ Rndg. Lines';
                    Image = InsertCurrency;
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                    ToolTip = 'Insert a rounding correction line in the journal. This rounding correction line will balance in $ when amounts in the foreign currency also balance. You can then post the journal.';
                }
                action(PositivePayExport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Positive Pay Export';
                    Image = Export;

                    trigger OnAction()
                    var
                        GenJnlBatch: Record "Gen. Journal Batch";
                        BankAcc: Record "Bank Account";
                    begin
                        GenJnlBatch.Get("Journal Template Name",CurrentJnlBatchName);
                        if GenJnlBatch."Bal. Account Type" = GenJnlBatch."bal. account type"::"Bank Account" then begin
                          BankAcc."No." := GenJnlBatch."Bal. Account No.";
                          Page.Run(Page::"Positive Pay Export",BankAcc);
                        end;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Ctrl+F11';
                    ToolTip = 'View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.Run;
                    end;
                }
                action(PreCheck)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor Pre-Payment Journal';
                    Image = PreviewChecks;
                    ToolTip = 'View journal line entries, payment discounts, discount tolerance amounts, payment tolerance, and any errors associated with the entries. You can use the results of the report to review payment journal lines and to review the results of posting before you actually post.';

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        GenJournalBatch.Init;
                        GenJournalBatch.SetRange("Journal Template Name","Journal Template Name");
                        GenJournalBatch.SetRange(Name,"Journal Batch Name");
                        Report.Run(Report::"Vendor Pre-Payment Journal",true,false,GenJournalBatch);
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Basic,Suite;
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
                    ApplicationArea = Basic,Suite;
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
                    ApplicationArea = Basic,Suite;
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
                    ApplicationArea = Basic,Suite;
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
            group("Request Approval")
            {
                Caption = 'Request Approval';
                group(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    action(SendApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Journal Batch';
                        Enabled = not OpenApprovalEntriesOnBatchOrAnyJnlLineExist;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TrySendJournalBatchApprovalRequest(Rec);
                            SetControlAppearance;
                        end;
                    }
                    action(SendApprovalRequestJournalLine)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Selected Journal Lines';
                        Enabled = not OpenApprovalEntriesOnBatchOrCurrJnlLineExist;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send selected journal lines for approval.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
                group(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    action(CancelApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Journal Batch';
                        Enabled = CanCancelApprovalForJnlBatch;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TryCancelJournalBatchApprovalRequest(Rec);
                            SetControlAppearance;
                        end;
                    }
                    action(CancelApprovalRequestJournalLine)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Selected Journal Lines';
                        Enabled = CanCancelApprovalForJnlLine;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending selected journal lines for approval.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                action(CreateApprovalWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Approval Workflow';
                    Enabled = not EnabledApprovalWorkflowsExist;
                    Image = CreateWorkflow;
                    ToolTip = 'Set up an approval workflow for payment journal lines, by going through a few pages that will guide you.';

                    trigger OnAction()
                    var
                        TempApprovalWorkflowWizard: Record "Approval Workflow Wizard" temporary;
                    begin
                        TempApprovalWorkflowWizard."Journal Batch Name" := "Journal Batch Name";
                        TempApprovalWorkflowWizard."Journal Template Name" := "Journal Template Name";
                        TempApprovalWorkflowWizard."For All Batches" := false;
                        TempApprovalWorkflowWizard.Insert;

                        Page.RunModal(Page::"Pmt. App. Workflow Setup Wzrd.",TempApprovalWorkflowWizard);
                    end;
                }
                action(ManageApprovalWorkflows)
                {
                    ApplicationArea = Suite;
                    Caption = 'Manage Approval Workflows';
                    Enabled = EnabledApprovalWorkflowsExist;
                    Image = WorkflowSetup;
                    ToolTip = 'View or edit existing approval workflows for payment journal lines.';

                    trigger OnAction()
                    var
                        WorkflowManagement: Codeunit "Workflow Management";
                    begin
                        WorkflowManagement.NavigateToWorkflows(Database::"Gen. Journal Line",EventFilter);
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateGenJournalLineRequest(Rec);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'View or add comments.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if OpenApprovalEntriesOnJnlLineExist then
                          ApprovalsMgmt.GetApprovalComment(Rec)
                        else
                          if OpenApprovalEntriesOnJnlBatchExist then
                            if GenJournalBatch.Get("Journal Template Name","Journal Batch Name") then
                              ApprovalsMgmt.GetApprovalComment(GenJournalBatch);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        StyleTxt := GetOverdueDateInteractions(OverdueWarningText);
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        UpdateBalance;
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);

        if GenJournalBatch.Get("Journal Template Name","Journal Batch Name") then
          ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.Page.SetFilterOnWorkflowRecord(GenJournalBatch.RecordId);
        ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.Page.SetFilterOnWorkflowRecord(RecordId);

        EventFilter := WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode;
        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(Database::"Gen. Journal Line",EventFilter);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetOverdueDateInteractions(OverdueWarningText);
        ShowShortcutDimCode(ShortcutDimCode);
        HasPmtFileErr := HasPaymentFileErrors;
        SetControlAppearance;
    end;

    trigger OnInit()
    var
        PermissionManager: Codeunit "Permission Manager";
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CheckForPmtJnlErrors;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        HasPmtFileErr := false;
        UpdateBalance;
        SetUpNewLine(xRec,Balance,BelowxRec);
        Clear(ShortcutDimCode);
        if not VoidWarningDisplayed then begin
          GenJnlTemplate.Get("Journal Template Name");
          if not GenJnlTemplate."Force Doc. Balance" then
            Message(CheckCannotVoidMsg);
          VoidWarningDisplayed := true;
        end;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        BalAccName := '';

        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          SetControlAppearance;
          exit;
        end;
        GenJnlManagement.TemplateSelection(Page::"Payment Journal",4,false,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
        SetControlAppearance;
        VoidWarningDisplayed := false;
    end;

    var
        Text000: label 'Void Check %1?';
        Text001: label 'Void all printed checks?';
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        VoidTransmitElecPayments: Report "Void/Transmit Elec. Payments";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        CheckManagement: Codeunit CheckManagement;
        ChangeExchangeRate: Page "Change Exchange Rate";
        GLReconcile: Page Reconciliation;
        CurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        VoidWarningDisplayed: Boolean;
        HasPmtFileErr: Boolean;
        ShortcutDimCode: array [8] of Code[20];
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;
        ExportAgainQst: label 'One or more of the selected lines have already been exported. Do you want to export again?';
        StyleTxt: Text;
        OverdueWarningText: Text;
        CheckCannotVoidMsg: label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.';
        EventFilter: Text;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        ShowWorkflowStatusOnBatch: Boolean;
        ShowWorkflowStatusOnLine: Boolean;
        CanCancelApprovalForJnlBatch: Boolean;
        CanCancelApprovalForJnlLine: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;

    local procedure CheckForPmtJnlErrors()
    var
        BankAccount: Record "Bank Account";
        BankExportImportSetup: Record "Bank Export/Import Setup";
    begin
        if HasPmtFileErr then
          if ("Bal. Account Type" = "bal. account type"::"Bank Account") and BankAccount.Get("Bal. Account No.") then
            if BankExportImportSetup.Get(BankAccount."Payment Export Format") then
              if BankExportImportSetup."Check Export Codeunit" > 0 then
                Codeunit.Run(BankExportImportSetup."Check Export Codeunit",Rec);
    end;

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

    local procedure GetCurrentlySelectedLines(var GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(GenJournalLine);
        exit(GenJournalLine.FindSet);
    end;

    local procedure SetControlAppearance()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if GenJournalBatch.Get("Journal Template Name","Journal Batch Name") then;
        OpenApprovalEntriesExistForCurrUser :=
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RecordId) or
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);

        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RecordId);
        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries("Journal Template Name","Journal Batch Name");

        CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RecordId);
        CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;
}

