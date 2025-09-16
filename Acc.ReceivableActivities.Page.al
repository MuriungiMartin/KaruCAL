#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9034 "Acc. Receivable Activities"
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
                field("Overdue Sales Documents";"Overdue Sales Documents")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Customer Ledger Entries";
                    ToolTip = 'Specifies the number of sales invoices where the customer is late with payment.';
                }
                field("Sales Return Orders - All";"Sales Return Orders - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Return Order List";
                    ToolTip = 'Specifies the number of sales return orders that are displayed in the Finance Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Customers - Blocked";"Customers - Blocked")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Customer List";
                    ToolTip = 'Specifies the number of customer that are blocked from further sales.';
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
            cuegroup("Document Approvals")
            {
                Caption = 'Document Approvals';
                field("SOs Pending Approval";"SOs Pending Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales orders that are pending approval.';
                }
                field("Approved Sales Orders";"Approved Sales Orders")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of approved sales orders.';
                }
            }
            cuegroup(Deposits)
            {
                Caption = 'Deposits';
                field("Deposits to Post";"Deposits to Post")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Deposits to Post';
                    DrillDownPageID = "Deposit List";
                    ToolTip = 'Specifies the deposits that will be posted.';
                }

                actions
                {
                    action("New Deposit")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Deposit';
                        RunObject = Page Deposit;
                        RunPageMode = Create;
                        ToolTip = 'Create a new deposit. ';
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetFilter("Overdue Date Filter",'<%1',WorkDate);
    end;
}

