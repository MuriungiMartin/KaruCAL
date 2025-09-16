#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5641 "Maintenance Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Maintenance Ledger Entries';
    DataCaptionFields = "FA No.","Depreciation Book Code";
    Editable = false;
    PageType = List;
    SourceTable = "Maintenance Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("FA Posting Date";"FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the entry''s FA posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the document type that the entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the document number on the entry.';
                }
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the fixed asset that the entry is linked to.';
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the depreciation book that was used when the entry was posted.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field("Maintenance Code";"Maintenance Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the maintenance code that the entry is linked to.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the type of balancing account used in the entry: G/L Account, Bank Account, Customer, Vendor, or Fixed Asset.';
                    Visible = false;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the balancing account used on the entry.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the ID of the user that is associated with the entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the source code that is linked to the entry.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reason code on the entry.';
                    Visible = false;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether the entry has been part of a reverse transaction (correction) made by the Reverse function.';
                    Visible = false;
                }
                field("Reversed by Entry No.";"Reversed by Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the correcting entry.';
                    Visible = false;
                }
                field("Reversed Entry No.";"Reversed Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("G/L Entry No.";"G/L Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the G/L number for the entry that was created for this maintenance transaction.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the entry number that the program has given the entry.';
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
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ReverseTransaction)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    ToolTip = 'Undo an erroneous journal posting.';

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        Clear(ReversalEntry);
                        if Reversed then
                          ReversalEntry.AlreadyReversedEntry(TableCaption,"Entry No.");
                        if "Journal Batch Name" = '' then
                          ReversalEntry.TestFieldError;
                        if "Transaction No." = 0 then
                          Error(CannotUndoErr,"Entry No.","Depreciation Book Code");
                        TestField("G/L Entry No.");
                        ReversalEntry.ReverseTransaction("Transaction No.");
                    end;
                }
            }
            action("&Navigate")
            {
                ApplicationArea = FixedAssets;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
        CannotUndoErr: label 'You cannot undo the Maintenance Ledger Entry No. %1 by using the Reverse Transaction function because Depreciation Book %2 does not have the appropriate G/L integration setup.';
}

