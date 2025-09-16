#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1284 "Outstanding Bank Transactions"
{
    Caption = 'Outstanding Bank Transactions';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Outstanding Bank Transaction";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = DocumentNoIndent;
                IndentationControls = "External Document No.";
                ShowAsTree = true;
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the posting date of the entry.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of document that generated the entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the document that generated the entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the entry.';
                }
                field(Applied;Applied)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the entry has been applied.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number that identifies the entry.';
                }
                field(Indentation;Indentation)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the level of indentation for the transaction. Indented transactions usually indicate deposits.';
                    Visible = false;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the external document number for this transaction.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DocumentNoIndent := Indentation;
    end;

    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;

    var
        OutstandingBankTrxTxt: label 'Outstanding Bank Transactions';
        OutstandingPaymentTrxTxt: label 'Outstanding Payment Transactions';
        DocumentNoIndent: Integer;


    procedure SetRecords(var TempOutstandingBankTransaction: Record "Outstanding Bank Transaction" temporary)
    begin
        Copy(TempOutstandingBankTransaction,true);
    end;


    procedure SetPageCaption(TransactionType: Option)
    begin
        if TransactionType = Type::"Bank Account Ledger Entry" then
          CurrPage.Caption(OutstandingBankTrxTxt)
        else
          CurrPage.Caption(OutstandingPaymentTrxTxt);
    end;
}

