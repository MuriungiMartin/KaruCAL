#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10133 "Bank Rec. Lines"
{
    Caption = 'Bank Rec. Lines';
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable10121;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bank account number from the Bank Rec. Header Table that this line applies to.';
                    Visible = false;
                }
                field("Statement No.";"Statement No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the statement number from the Bank Rec. Header Table that this line applies to.';
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line''s number.';
                    Visible = false;
                }
                field("Record Type";"Record Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of line the record refers to. The valid line types are: Check, Deposit, Adjustment.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Statement Date for Check or Deposit type. For Adjustment type lines, the entry will be the actual date the posting.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of account the entry on the journal line will be posted to.';
                    Visible = false;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the account number the entry on the journal line will be posted to.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the transaction on the bank reconciliation line.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the item, such as a check, that was deposited.';
                }
                field(Cleared;Cleared)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the check on the line has been cleared, as indicated on the bank statement.';
                }
                field("Cleared Amount";"Cleared Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount cleared by the bank, as indicated by the bank statement.';
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the Balance Account Type that will be posted to the G/L.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that you can select the number of the G/L, customer, vendor or bank account to which a balancing entry for the line will posted.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code for the amounts on the line, as it will be posted to the G/L.';
                    Visible = false;
                }
                field("Currency Factor";"Currency Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a currency factor for the reconciliation sub-line entry. The value is calculated based on currency code, exchange rate, and the bank record header’s statement date.';
                    Visible = false;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Bank Ledger Entry No.";"Bank Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number from the Bank Account Ledger Entry table record where the Bank Rec. Line record originated.';
                    Visible = false;
                }
                field("Check Ledger Entry No.";"Check Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number from the Bank Account Ledger Entry table record where the Bank Rec. Line record originated.';
                    Visible = false;
                }
                field("Adj. Source Record ID";"Adj. Source Record ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what type of Bank Rec. Line record was the source for the created Adjustment line. The valid types are Check or Deposit.';
                    Visible = false;
                }
                field("Adj. Source Document No.";"Adj. Source Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Document number from the Bank Rec. Line record that was the source for the created Adjustment line.';
                    Visible = false;
                }
                field("Adj. No. Series";"Adj. No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series, from the G/L Setup table, used to create the document number on the created Adjustment line.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

