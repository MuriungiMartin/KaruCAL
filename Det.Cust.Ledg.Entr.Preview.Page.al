#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 127 "Det. Cust. Ledg. Entr. Preview"
{
    Caption = 'Detailed Cust. Ledg. Entries Preview';
    DataCaptionFields = "Cust. Ledger Entry No.","Customer No.";
    Editable = false;
    PageType = List;
    SourceTable = "Detailed Cust. Ledg. Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the posting date of the detailed customer ledger entry.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry type of the detailed customer ledger entry.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document type of the detailed customer ledger entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number of the transaction that created the entry.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer account number to which the entry is posted.';
                }
                field("Initial Entry Global Dim. 1";"Initial Entry Global Dim. 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Global Dimension 1 code of the initial customer ledger entry.';
                    Visible = false;
                }
                field("Initial Entry Global Dim. 2";"Initial Entry Global Dim. 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Global Dimension 2 code of the initial customer ledger entry.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the currency if the amount is in a foreign currency.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the detailed customer ledger entry.';
                }
                field("Amount (LCY)";"Amount (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the entry in $.';
                }
                field("Initial Entry Due Date";"Initial Entry Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which the initial entry is due for payment.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who created the entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field(Unapplied;Unapplied)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the entry has been unapplied (undone) from the Unapply Customer Entries window by the entry no. shown in the Unapplied by Entry No. field.';
                    Visible = false;
                }
                field("Unapplied by Entry No.";"Unapplied by Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the correcting entry, if the original entry has been unapplied (undone) from the Unapply Customer Entries window.';
                    Visible = false;
                }
                field("Cust. Ledger Entry No.";"Cust. Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number of the customer ledger entry that the detailed customer ledger entry line was created for.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }


    procedure Set(var TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary)
    begin
        if TempDtldCustLedgEntry.FindSet then
          repeat
            Rec := TempDtldCustLedgEntry;
            Insert;
          until TempDtldCustLedgEntry.Next = 0;
    end;
}

