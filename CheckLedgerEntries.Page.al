#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 374 "Check Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Check Ledger Entries';
    DataCaptionFields = "Bank Account No.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Check Ledger Entry";
    SourceTableView = sorting("Bank Account No.","Check Date")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Check Date";"Check Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the check date if a check is printed.';
                }
                field("Check No.";"Check No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the check number if a check is printed.';
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the bank account used for the check ledger entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a printing description for the check ledger entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount on the check ledger entry.';
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of balancing account used in the entry.';
                    Visible = false;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the balancing account used in the entry.';
                    Visible = false;
                }
                field("Entry Status";"Entry Status")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the printing (and posting) status of the check ledger entry.';
                }
                field("Original Entry Status";"Original Entry Status")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the entry before you changed it.';
                    Visible = false;
                }
                field("Bank Payment Type";"Bank Payment Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment type that applies to the entry.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the posting date of the check ledger entry.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document type linked to the check ledger entry. For example, Payment.';
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number on the check ledger entry.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry number assigned the check ledger entry.';
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
        area(navigation)
        {
            group("Chec&k")
            {
                Caption = 'Chec&k';
                Image = Check;
                action("Void Check")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Void Check';
                    Image = VoidCheck;

                    trigger OnAction()
                    var
                        CheckManagement: Codeunit CheckManagement;
                    begin
                        CheckManagement.FinancialVoidCheck(Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;

    var
        Navigate: Page Navigate;
}

