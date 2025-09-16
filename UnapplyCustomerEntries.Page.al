#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 623 "Unapply Customer Entries"
{
    Caption = 'Unapply Customer Entries';
    DataCaptionExpression = Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Detailed Cust. Ledg. Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocuNo;DocNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document number of the entry to be unapplied.';
                }
                field(PostDate;PostingDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date of the entry to be unapplied.';
                }
            }
            repeater(Control1)
            {
                Editable = false;
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
                field("Initial Document Type";"Initial Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document type that the initial customer ledger entry was created with.';
                }
                field(GetDocumentNo;GetDocumentNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Initial Document No.';
                    DrillDown = false;
                    ToolTip = 'Specifies the number of the document for which the entry is unapplied.';
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
                field("Cust. Ledger Entry No.";"Cust. Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number of the customer ledger entry that the detailed customer ledger entry line was created for.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry number of the detailed customer ledger entry.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Unapply)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Unapply';
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.';

                trigger OnAction()
                var
                    CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
                begin
                    if IsEmpty then
                      Error(Text010);
                    if not Confirm(Text011,false) then
                      exit;

                    CustEntryApplyPostedEntries.PostUnApplyCustomer(DtldCustLedgEntry2,DocNo,PostingDate);
                    PostingDate := 0D;
                    DocNo := '';
                    DeleteAll;
                    Message(Text009);

                    CurrPage.Close;
                end;
            }
            action(Preview)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Preview Unapply';
                Image = ViewPostedOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Preview how unapplying one or more ledger entries will look like.';

                trigger OnAction()
                var
                    CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
                begin
                    if IsEmpty then
                      Error(Text010);

                    CustEntryApplyPostedEntries.PreviewUnapply(DtldCustLedgEntry2,DocNo,PostingDate);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        InsertEntries;
    end;

    var
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        Cust: Record Customer;
        DocNo: Code[20];
        PostingDate: Date;
        CustLedgEntryNo: Integer;
        Text009: label 'The entries were successfully unapplied.';
        Text010: label 'There is nothing to unapply.';
        Text011: label 'To unapply these entries, correcting entries will be posted.\Do you want to unapply the entries?';


    procedure SetDtldCustLedgEntry(EntryNo: Integer)
    begin
        DtldCustLedgEntry2.Get(EntryNo);
        CustLedgEntryNo := DtldCustLedgEntry2."Cust. Ledger Entry No.";
        PostingDate := DtldCustLedgEntry2."Posting Date";
        DocNo := DtldCustLedgEntry2."Document No.";
        Cust.Get(DtldCustLedgEntry2."Customer No.");
    end;

    local procedure InsertEntries()
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        if DtldCustLedgEntry2."Transaction No." = 0 then begin
          DtldCustLedgEntry.SetCurrentkey("Application No.","Customer No.","Entry Type");
          DtldCustLedgEntry.SetRange("Application No.",DtldCustLedgEntry2."Application No.");
        end else begin
          DtldCustLedgEntry.SetCurrentkey("Transaction No.","Customer No.","Entry Type");
          DtldCustLedgEntry.SetRange("Transaction No.",DtldCustLedgEntry2."Transaction No.");
        end;
        DtldCustLedgEntry.SetRange("Customer No.",DtldCustLedgEntry2."Customer No.");
        DeleteAll;
        if DtldCustLedgEntry.FindSet then
          repeat
            if (DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."entry type"::"Initial Entry") and
               not DtldCustLedgEntry.Unapplied
            then begin
              Rec := DtldCustLedgEntry;
              Insert;
            end;
          until DtldCustLedgEntry.Next = 0;
    end;

    local procedure GetDocumentNo(): Code[20]
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if CustLedgEntry.Get("Cust. Ledger Entry No.") then;
        exit(CustLedgEntry."Document No.");
    end;

    local procedure Caption(): Text[100]
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        exit(StrSubstNo(
            '%1 %2 %3 %4',
            Cust."No.",
            Cust.Name,
            CustLedgEntry.FieldCaption("Entry No."),
            CustLedgEntryNo));
    end;
}

