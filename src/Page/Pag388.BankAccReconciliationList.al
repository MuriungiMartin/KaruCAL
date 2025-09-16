#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 388 "Bank Acc. Reconciliation List"
{
    ApplicationArea = Basic;
    Caption = 'Bank Acc. Reconciliation List';
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Bank Acc. Reconciliation";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(BankAccountNo;"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the bank account that you want to reconcile with the bank''s statement.';
                }
                field(StatementNo;"Statement No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the bank account statement.';
                }
                field(StatementDate;"Statement Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on the bank account statement.';
                }
                field(BalanceLastStatement;"Balance Last Statement")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ending balance shown on the last bank statement, which was used in the last posted bank reconciliation for this bank account.';
                }
                field(StatementEndingBalance;"Statement Ending Balance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ending balance shown on the bank''s statement that you want to reconcile with the bank account.';
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
            group("&Document")
            {
                Caption = '&Document';
                action(NewRec)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'New';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    ToolTip = 'Create a new bank account reconciliation.';

                    trigger OnAction()
                    var
                        BankReconciliationMgt: Codeunit "Bank Reconciliation Mgt.";
                    begin
                        BankReconciliationMgt.New(Rec,UseSharedTable);
                    end;
                }
                action(EditRec)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Edit';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Return';
                    ToolTip = 'Edit the list.';

                    trigger OnAction()
                    var
                        BankReconciliationMgt: Codeunit "Bank Reconciliation Mgt.";
                    begin
                        BankReconciliationMgt.Edit(Rec,UseSharedTable);
                    end;
                }
                action(RefreshList)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Refresh';
                    Image = RefreshLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Update the data with any changes made by other users since you opened the window.';

                    trigger OnAction()
                    begin
                        Refresh;
                    end;
                }
                action(DeleteRec)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Delete';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Delete the bank account reconciliation.';

                    trigger OnAction()
                    var
                        BankReconciliationMgt: Codeunit "Bank Reconciliation Mgt.";
                    begin
                        if not Confirm(DeleteConfirmQst) then
                          exit;

                        BankReconciliationMgt.Delete(Rec);
                        Refresh;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
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
                    var
                        BankReconciliationMgt: Codeunit "Bank Reconciliation Mgt.";
                    begin
                        BankReconciliationMgt.Post(Rec,Codeunit::"Bank Acc. Recon. Post (Yes/No)",Codeunit::"Bank Rec.-Post (Yes/No)");
                        Refresh;
                    end;
                }
                action(PostAndPrint)
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
                    var
                        BankReconciliationMgt: Codeunit "Bank Reconciliation Mgt.";
                    begin
                        BankReconciliationMgt.Post(Rec,Codeunit::"Bank Acc. Recon. Post+Print",Codeunit::"Bank Rec.-Post + Print");
                        Refresh;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        UseSharedTable := true;
    end;

    trigger OnOpenPage()
    begin
        Refresh;
    end;

    var
        UseSharedTable: Boolean;
        DeleteConfirmQst: label 'Do you want to delete the Reconciliation?';

    local procedure Refresh()
    var
        BankReconciliationMgt: Codeunit "Bank Reconciliation Mgt.";
    begin
        DeleteAll;
        BankReconciliationMgt.Refresh(Rec);
    end;
}

