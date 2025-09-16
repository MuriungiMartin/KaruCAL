#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1293 "Pmt. Rec. Journals Overview"
{
    Caption = 'Unprocessed Payments';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Bank Acc. Reconciliation";
    SourceTableView = where("Statement Type"=const("Payment Application"));

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
                field("Total Difference";"Total Difference")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Remaining Amount to Apply';
                    ToolTip = 'Specifies the sum of values in the Difference field on all lines in the Bank Acc. Reconciliation window that belong to the bank account reconciliation.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Bank Account Card")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Bank Account Card';
                Image = BankAccount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Payment Bank Account Card";
                RunPageLink = "No."=field("Bank Account No.");
                ToolTip = 'View or edit information about the bank account that is related to the payment reconciliation journal.';
            }
            action(ViewJournal)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'View Journal';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'View the payment reconciliation lines from the bank statement for the account. This information can help when posting the transactions recorded by the bank that have not yet been recorded.';

                trigger OnAction()
                var
                    BankAccReconciliation: Record "Bank Acc. Reconciliation";
                begin
                    if not BankAccReconciliation.Get("Statement Type","Bank Account No.","Statement No.") then
                      exit;

                    OpenList(Rec);
                end;
            }
        }
    }
}

