#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9037 "Accountant Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
            cuegroup(Payments)
            {
                Caption = 'Payments';
                field("Overdue Purchase Documents";"Overdue Purchase Documents")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Vendor Ledger Entries";
                    ToolTip = 'Specifies the number of purchase invoices where your payment is late.';
                }
                field("Purchase Documents Due Today";"Purchase Documents Due Today")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Vendor Ledger Entries";
                    ToolTip = 'Specifies the number of purchase invoices that are due for payment today.';
                }
                field("Purch. Invoices Due Next Week";"Purch. Invoices Due Next Week")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of payments to vendors that are due next week.';
                }
                field("Purchase Discounts Next Week";"Purchase Discounts Next Week")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of purchase discounts that are available next week, for example, because the discount expires after next week.';
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
            cuegroup("Document Approvals")
            {
                Caption = 'Document Approvals';
                field("POs Pending Approval";"POs Pending Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of purchase orders that are pending approval.';
                }
                field("SOs Pending Approval";"SOs Pending Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales orders that are pending approval.';
                }

                actions
                {
                    action("Create Reminders...")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create Reminders...';
                        Image = CreateReminders;
                        RunObject = Report "Create Reminders";
                        ToolTip = 'Remind your customers of late payments.';
                    }
                    action("Create Finance Charge Memos...")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create Finance Charge Memos...';
                        Image = CreateFinanceChargememo;
                        RunObject = Report "Create Finance Charge Memos";
                        ToolTip = 'Issue finance charge memos to your customers as a consequence of late payment.';
                    }
                }
            }
            cuegroup(Financials)
            {
                Caption = 'Financials';
                field("Non-Applied Payments";"Non-Applied Payments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Unprocessed Payments';
                    DrillDownPageID = "Pmt. Reconciliation Journals";
                    Image = Cash;
                    ToolTip = 'Specifies journals where you can reconcile unpaid documents automatically with their related bank transactions by importing bank a bank statement feed or file.';
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
                }
            }
            cuegroup("Incoming Documents")
            {
                Caption = 'Incoming Documents';
                field("New Incoming Documents";"New Incoming Documents")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Incoming Documents";
                    ToolTip = 'Specifies the number of new incoming documents in the company. The documents are filtered by today''s date.';
                }
                field("Approved Incoming Documents";"Approved Incoming Documents")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Incoming Documents";
                    ToolTip = 'Specifies the number of approved incoming documents in the company. The documents are filtered by today''s date.';
                }
                field("OCR Completed";"OCR Completed")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Incoming Documents";
                    ToolTip = 'Specifies that incoming document records that have been created by the OCR service.';
                }

                actions
                {
                    action(CheckForOCR)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Receive from OCR Service';
                        RunObject = Codeunit "OCR - Receive from Service";
                        RunPageMode = View;
                        ToolTip = 'Process new incoming electronic documents that have been created by the OCR service and that you can convert to, for example, purchase invoices in Dynamics NAV.';
                    }
                }
            }
            cuegroup(Start)
            {
                Caption = 'Start';

                actions
                {
                    action("G/L Journal Entry")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'G/L Journal Entry';
                        Image = TileNew;
                        RunObject = Page "General Journal";
                        ToolTip = 'Prepare to post any transaction to the company books.';
                    }
                    action("Recurring G/L Entry")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Recurring G/L Entry';
                        Image = TileNew;
                        RunObject = Page "Recurring General Journal";
                        ToolTip = 'Prepare to post any recurring transaction to the company books.';
                    }
                    action("Payment Journal Entry")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Payment Journal Entry';
                        Image = TileNew;
                        RunObject = Page "Payment Journal";
                        ToolTip = 'Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueSetup: Codeunit "Cues And KPIs";
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetFilter("Due Date Filter",'<=%1',WorkDate);
        SetFilter("Overdue Date Filter",'<%1',WorkDate);
        SetFilter("Due Next Week Filter",'%1..%2',CalcDate('<1D>',WorkDate),CalcDate('<1W>',WorkDate));

        RoleCenterNotificationMgt.ShowNotifications;
    end;
}

