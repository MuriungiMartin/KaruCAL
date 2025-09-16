#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 381 "Apply Bank Acc. Ledger Entries"
{
    Caption = 'Apply Bank Acc. Ledger Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Bank Account Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineApplied;LineApplied)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied';
                    Editable = false;
                    ToolTip = 'Specifies if the bank account ledger entry has been applied to its related bank transaction.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document type on the bank account entry. The document type will be Payment, Refund, or the field will be blank.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document number on the bank account entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the description of the bank account entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry denominated in the applicable foreign currency.';
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the amount that remains to be applied to. The amount is denominated in the applicable foreign currency.';
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies whether the amount on the bank account entry has been fully applied to, or if there is a remaining amount that must be applied to.';
                }
                field(Positive;Positive)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of balancing account used in the entry.';
                    Visible = false;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the balancing account used in the entry.';
                    Visible = false;
                }
                field("Statement Status";"Statement Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Statement No.";"Statement No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Statement Line No.";"Statement Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the statement line that has been applied to by this ledger entry line.';
                    Visible = false;
                }
                field("Check Ledger Entries";"Check Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the check ledger entries that are associated with the bank account ledger entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the dimension value linked to the entry.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the dimension value linked to the entry.';
                    Visible = false;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control7)
            {
                label(Control15)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Balance';
                    Editable = false;
                    ToolTip = 'Specifies the balance of the bank account since the last posting, including any amount in the Total on Outstanding Checks field.';
                }
                field(CheckBalance;CheckBalance)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Total on Outstanding Checks';
                    Editable = false;
                    ToolTip = 'Specifies the part of the bank account balance that consists of posted check ledger entries. The amount in this field is a subset of the amount in the Balance field under the right pane in the Bank Acc. Reconciliation window.';
                }
                field(BalanceToReconcile;BalanceToReconcile)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Balance To Reconcile';
                    Editable = false;
                    ToolTip = 'Specifies the balance of the bank account since the last posting, excluding any amount in the Total on Outstanding Checks field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        LineApplied := IsApplied;
        SetUserInteractions;
        CalcBalance;
    end;

    trigger OnAfterGetRecord()
    begin
        LineApplied := IsApplied;
        SetUserInteractions;
        CalcBalance;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        SetUserInteractions;
    end;

    var
        BankAccount: Record "Bank Account";
        StyleTxt: Text;
        LineApplied: Boolean;
        Balance: Decimal;
        CheckBalance: Decimal;
        BalanceToReconcile: Decimal;


    procedure GetSelectedRecords(var TempBankAccLedgerEntry: Record "Bank Account Ledger Entry" temporary)
    var
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        CurrPage.SetSelectionFilter(BankAccLedgerEntry);
        if BankAccLedgerEntry.FindSet then
          repeat
            TempBankAccLedgerEntry := BankAccLedgerEntry;
            TempBankAccLedgerEntry.Insert;
          until BankAccLedgerEntry.Next = 0;
    end;


    procedure SetUserInteractions()
    begin
        StyleTxt := SetStyle;
    end;

    local procedure CalcBalance()
    begin
        if BankAccount.Get("Bank Account No.") then begin
          BankAccount.CalcFields(Balance,"Total on Checks");
          Balance := BankAccount.Balance;
          CheckBalance := BankAccount."Total on Checks";
          BalanceToReconcile := CalcBalanceToReconcile;
        end;
    end;


    procedure ToggleMatchedFilter(SetFilterOn: Boolean)
    begin
        if SetFilterOn then begin
          SetRange("Statement Status","statement status"::Open);
          SetRange("Statement No.",'');
          SetRange("Statement Line No.",0);
        end else
          Reset;
        CurrPage.Update;
    end;

    local procedure CalcBalanceToReconcile(): Decimal
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccountLedgerEntry.CopyFilters(Rec);
        BankAccountLedgerEntry.CalcSums(Amount);
        exit(BankAccountLedgerEntry.Amount);
    end;
}

