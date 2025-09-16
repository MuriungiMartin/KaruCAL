#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9036 "Bookkeeper Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
            cuegroup(Payables)
            {
                Caption = 'Payables';
                field("Purchase Documents Due Today";"Purchase Documents Due Today")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Vendor Ledger Entries";
                    ToolTip = 'Specifies the number of purchase invoices where you are late with payment.';
                }
                field("Vendors - Payment on Hold";"Vendors - Payment on Hold")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Vendor List";
                    ToolTip = 'Specifies the number of vendor to whom your payment is on hold.';
                }
                field("Approved Purchase Orders";"Approved Purchase Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of approved purchase orders.';
                }

                actions
                {
                    action("Edit Payment Journal")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Edit Payment Journal';
                        RunObject = Page "Payment Journal";
                        ToolTip = 'Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.';
                    }
                    action("New Purchase Credit Memo")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Purchase Credit Memo';
                        RunObject = Page "Purchase Credit Memo";
                        RunPageMode = Create;
                        ToolTip = 'Create a new purchase credit memo so you can manage returned items to a vendor.';
                    }
                }
            }
            cuegroup(Receivables)
            {
                Caption = 'Receivables';
                field("SOs Pending Approval";"SOs Pending Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales orders that are pending approval.';
                }
                field("Overdue Sales Documents";"Overdue Sales Documents")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Customer Ledger Entries";
                    ToolTip = 'Specifies the number of sales invoices where the customer is late with payment.';
                }
                field("Approved Sales Orders";"Approved Sales Orders")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of approved sales orders.';
                }

                actions
                {
                    action("Edit Cash Receipt Journal")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Edit Cash Receipt Journal';
                        RunObject = Page "Cash Receipt Journal";
                        ToolTip = 'Register received payments in a cash receipt journal that may already contain journal lines.';
                    }
                    action("New Sales Credit Memo")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Sales Credit Memo';
                        RunObject = Page "Sales Credit Memo";
                        RunPageMode = Create;
                        ToolTip = 'Process a return or refund by creating a new sales credit memo.';
                    }
                }
            }
            cuegroup(Approvals)
            {
                Caption = 'Approvals';
                field("Requests Sent for Approval";"Requests Sent for Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Approval Entries";
                    ToolTip = 'Specifies request for certain documents, cards, or journal lines that your approver must approve before you can proceed.';
                }
                field("Requests to Approve";"Requests to Approve")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Requests to Approve";
                    ToolTip = 'Specifies request for certain documents, cards, or journal lines that you must approve for other users before they can proceed.';
                }
            }
            cuegroup("Cash Management")
            {
                Caption = 'Cash Management';
                field("Non-Applied Payments";"Non-Applied Payments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Reconciliation Journals';
                    DrillDownPageID = "Pmt. Reconciliation Journals";
                    Image = Cash;
                    ToolTip = 'Specifies journals where you can reconcile unpaid documents automatically with their related bank transactions by importing bank a bank statement feed or file.';
                }
                field("Bank Acc. Reconciliations";"Bank Acc. Reconciliations")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Acc. Reconciliations to Post';
                    DrillDownPageID = "Bank Acc. Reconciliation List";
                    ToolTip = 'Specifies bank account reconciliations that are ready to post. ';
                    Visible = BankReconWithAutoMatch;
                }
                field("Bank Reconciliations to Post";"Bank Reconciliations to Post")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Bank Acc. Reconciliation List";
                    ToolTip = 'Specifies that the bank reconciliations are ready to post.';
                    Visible = not BankReconWithAutoMatch;
                }
                field("Deposits to Post";"Deposits to Post")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Deposit List";
                    ToolTip = 'Specifies deposits that are ready to be posted.';
                }

                actions
                {
                    action("New Payment Reconciliation Journal")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Payment Reconciliation Journal';
                        ToolTip = 'Reconcile unpaid documents automatically with their related bank transactions by importing bank a bank statement feed or file.';

                        trigger OnAction()
                        var
                            BankAccReconciliation: Record "Bank Acc. Reconciliation";
                        begin
                            BankAccReconciliation.OpenNewWorksheet
                        end;
                    }
                    action("New Deposit")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Deposit';
                        RunObject = Page Deposit;
                        RunPageMode = Create;
                        ToolTip = 'Create a new deposit. ';
                    }
                    action("New Bank Reconciliation")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Bank Reconciliation';
                        Image = BankAccountRec;
                        ToolTip = 'Create a new bank account reconciliation.';

                        trigger OnAction()
                        var
                            BankAccReconciliation: Record "Bank Acc. Reconciliation";
                            BankReconciliationMgt: Codeunit "Bank Reconciliation Mgt.";
                        begin
                            BankReconciliationMgt.New(BankAccReconciliation,UseSharedTable);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        UseSharedTable := false;

        GeneralLedgerSetup.Get;
        BankReconWithAutoMatch := GeneralLedgerSetup."Bank Recon. with Auto. Match";
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetFilter("Due Date Filter",'<=%1',WorkDate);
        SetFilter("Overdue Date Filter",'<%1',WorkDate);
        SetFilter("User ID Filter",UserId);
    end;

    var
        BankReconWithAutoMatch: Boolean;
        UseSharedTable: Boolean;
}

