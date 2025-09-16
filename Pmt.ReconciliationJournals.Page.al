#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1294 "Pmt. Reconciliation Journals"
{
    ApplicationArea = Basic;
    Caption = 'Payment Reconciliation Journals';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Bank';
    SourceTable = "Bank Acc. Reconciliation";
    SourceTableView = where("Statement Type"=const("Payment Application"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the bank account that you want to reconcile with the bank''s statement.';
                }
                field("Statement No.";"Statement No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the bank account statement.';
                }
                field("Total Transaction Amount";"Total Transaction Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sum of values in the Statement Amount field on all the lines in the Bank Acc. Reconciliation and Payment Reconciliation Journal windows.';
                }
                field("Total Difference";"Total Difference")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Caption = 'Remaining Amount to Apply';
                    Style = Unfavorable;
                    StyleExpr = true;
                    ToolTip = 'Specifies the total amount that exists on the bank account per the last time it was reconciled.';
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
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                Image = "Action";
                action(ImportBankTransactionsToNew)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Import Bank Transactions';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'To start the process of reconciling new payments, import a bank feed or electronic file containing the related bank transactions.';

                    trigger OnAction()
                    begin
                        ImportAndProcessToNewStatement
                    end;
                }
                action(EditJournal)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Edit Journal';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Return';
                    ToolTip = 'Modify an existing payment reconciliation journal for a bank account.';

                    trigger OnAction()
                    var
                        BankAccReconciliation: Record "Bank Acc. Reconciliation";
                    begin
                        if not BankAccReconciliation.Get("Statement Type","Bank Account No.","Statement No.") then
                          exit;

                        OpenWorksheet(Rec);
                    end;
                }
                action(NewJournal)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&New Journal';
                    Ellipsis = true;
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Create a payment reconciliation journal for a bank account to set up payments that have been recorded as transactions in an electronic bank and need to be applied to related open entries.';

                    trigger OnAction()
                    begin
                        OpenNewWorksheet
                    end;
                }
            }
            group(Bank)
            {
                Caption = 'Bank';
                action("Bank Account Card")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Account Card';
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Payment Bank Account Card";
                    RunPageLink = "No."=field("Bank Account No.");
                    ToolTip = 'View or edit information about the bank account that is related to the payment reconciliation journal.';
                }
                action("List of Bank Accounts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'List of Bank Accounts';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Payment Bank Account List";
                    ToolTip = 'View and edit information about the bank accounts that are associated with the payment reconciliation journals that you use to reconcile payment transactions.';
                }
            }
        }
    }
}

