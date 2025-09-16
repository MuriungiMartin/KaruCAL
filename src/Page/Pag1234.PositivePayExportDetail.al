#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1234 "Positive Pay Export Detail"
{
    Caption = 'Positive Pay Export Detail';
    DelayedInsert = true;
    Editable = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Check Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the entry number assigned the check ledger entry.';
                }
                field("Check Date";"Check Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the check date if a check is printed.';
                }
                field("Check No.";"Check No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the check number if a check is printed.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a printing description for the check ledger entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount on the check ledger entry.';
                }
                field("Entry Status";"Entry Status")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the printing (and posting) status of the check ledger entry.';
                }
                field("Bank Payment Type";"Bank Payment Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the payment type that applies to the entry.';
                    Visible = false;
                }
                field("Bank Account Ledger Entry No.";"Bank Account Ledger Entry No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the entry number of the bank account ledger entry from which the check ledger entry was created.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the posting date of the check ledger entry.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the document type linked to the check ledger entry. For example, Payment.';
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the document number on the check ledger entry.';
                    Visible = false;
                }
                field("Original Entry Status";"Original Entry Status")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the status of the entry before you changed it.';
                    Visible = false;
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the bank account used for the check ledger entry.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the type of balancing account used in the entry.';
                    Visible = false;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the balancing account used in the entry.';
                    Visible = false;
                }
                field(Open;Open)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the user that posted the check ledger entry.';
                    Visible = false;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the external document number for this entry.';
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
        SetFilters;
    end;

    var
        LastUploadDate: Date;
        UploadCutoffDate: Date;


    procedure Set(NewLastUploadDate: Date;NewUploadCutoffDate: Date;NewBankAcctNo: Code[20])
    begin
        LastUploadDate := NewLastUploadDate;
        UploadCutoffDate := NewUploadCutoffDate;
        SetRange("Bank Account No.",NewBankAcctNo);
        SetFilters;
        CurrPage.Update(false);
    end;

    local procedure SetFilters()
    begin
        SetRange("Check Date",LastUploadDate,UploadCutoffDate);
        SetRange("Positive Pay Exported",false);
    end;
}

