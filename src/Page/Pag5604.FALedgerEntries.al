#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5604 "FA Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'FA Ledger Entries';
    DataCaptionFields = "FA No.","Depreciation Book Code";
    Editable = false;
    PageType = List;
    SourceTable = "FA Ledger Entry";
    SourceTableView = sorting("Entry No.");
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
                    ToolTip = 'Specifies the entry document type.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the document number on the entry.';
                }
                field("FA Posting Group";"FA Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the fixed asset the entry is linked to.';
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the depreciation book used when the entry was posted.';
                }
                field("FA Posting Category";"FA Posting Category")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the posting category assigned to the entry when it was posted.';
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the fixed asset posting type used when the entry was posted.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code the entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code the entry is linked to.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the entry amount in currency.';
                }
                field("Reclassification Entry";"Reclassification Entry")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether the entry was made to reclassify a fixed asset, for example, to change the dimension the fixed asset is linked to.';
                }
                field("Index Entry";"Index Entry")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies this entry is an index entry.';
                    Visible = false;
                }
                field("No. of Depreciation Days";"No. of Depreciation Days")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of depreciation days that were used for calculating depreciation for the fixed asset entry.';
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the type of balancing account used in the entry: G/L Account, Bank Account, or Fixed Asset.';
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
                    ToolTip = 'Specifies the ID of the user associated with the entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the source code linked to the entry.';
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
                    ToolTip = 'Specifies the G/L number for the entry that was created in the general ledger for this fixed asset transaction.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number that is assigned to the entry.';
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
                action(CancelEntries)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Cancel Entries';
                    Ellipsis = true;
                    Image = CancelLine;
                    ToolTip = 'Remove one or more fixed asset ledger entries from the FA Ledger Entries window. If you posted erroneous transactions to one or more fixed assets, you can use this function to cancel the fixed asset ledger entries. In the FA Ledger Entries window, select the entry or entries that you want to cancel.';

                    trigger OnAction()
                    begin
                        FALedgEntry.Copy(Rec);
                        CurrPage.SetSelectionFilter(FALedgEntry);
                        Clear(CancelFAEntries);
                        CancelFAEntries.GetFALedgEntry(FALedgEntry);
                        CancelFAEntries.RunModal;
                        Clear(CancelFAEntries);
                    end;
                }
                separator(Action37)
                {
                }
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
                        FADeprBook: Record "FA Depreciation Book";
                    begin
                        Clear(ReversalEntry);
                        if Reversed then
                          ReversalEntry.AlreadyReversedEntry(TableCaption,"Entry No.");
                        if "Journal Batch Name" = '' then
                          ReversalEntry.TestFieldError;
                        FADeprBook.Get("FA No.","Depreciation Book Code");
                        if FADeprBook."Disposal Date" > 0D then
                          Error(Text001);
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
        FALedgEntry: Record "FA Ledger Entry";
        CancelFAEntries: Report "Cancel FA Entries";
        Navigate: Page Navigate;
        CannotUndoErr: label 'You cannot undo the FA Ledger Entry No. %1 by using the Reverse Transaction function because Depreciation Book %2 does not have the appropriate G/L integration setup.';
        Text001: label 'You cannot reverse the transaction because the fixed asset has been sold.';
}

