#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 29 "Vendor Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Vendor Ledger Entries';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Vendor Ledger Entry";
    SourceTableView = sorting("Entry No.")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the external document number that was entered on the purchase header or journal line.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field("Vendor Posting Group";"Vendor Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("PV Category";"PV Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Medical Claim";"Medical Claim")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Is a Medical Claim";"Is a Medical Claim")
                {
                    ApplicationArea = Basic;
                }
                field("PartTime Claim";"PartTime Claim")
                {
                    ApplicationArea = Basic;
                }
                field("Message to Recipient";"Message to Recipient")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code linked to the entry.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code linked to the entry.';
                    Visible = false;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the customer''s IC partner code, if the customer is one of your intercompany partners.';
                    Visible = false;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the purchaser whom the entry is linked to.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment method that was used to make the payment that resulted in the entry.';
                }
                field("Payment Reference";"Payment Reference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Creditor No.";"Creditor No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the vendor who sent the purchase invoice.';
                }
                field("Original Amount";"Original Amount")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original entry.';
                }
                field("Original Amt. (LCY)";"Original Amt. (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the amount that the entry originally consisted of, in $.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field("Amount (LCY)";"Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry in $.';
                    Visible = false;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Remaining Amt. (LCY)";"Remaining Amt. (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of balancing account used on the entry.';
                    Visible = false;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the balancing account number used on the entry.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the due date on the entry.';
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                }
                field("Pmt. Disc. Tolerance Date";"Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.';
                }
                field("Original Pmt. Disc. Possible";"Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
                }
                field("Remaining Pmt. Disc. Possible";"Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.';
                }
                field("Max. Payment Tolerance";"Max. Payment Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.';
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field("On Hold";"On Hold")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when a vendor ledger has been invoiced and you run the Suggest Vendor Payments batch job.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the user associated with the entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the source code that is linked to the entry.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the reason code on the entry.';
                    Visible = false;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction.';
                    Visible = false;
                }
                field("Reversed by Entry No.";"Reversed by Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the correcting entry that replaced the original entry in the reverse transaction.';
                    Visible = false;
                }
                field("Reversed Entry No.";"Reversed Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.';
                    Visible = false;
                }
                field("IRS 1099 Code";"IRS 1099 Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount for the 1099 code that the vendor entry is linked to.';
                    Visible = false;
                }
                field("IRS 1099 Amount";"IRS 1099 Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount for the 1099 code that the vendor entry is linked to.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the entry number that is assigned to the entry.';
                }
                field("Exported to Payment File";"Exported to Payment File")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the entry was created as a result of exporting a payment journal line.';
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic,Suite;
                ShowFilter = false;
            }
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
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Vendor Entries";
                    RunPageOnRec = true;
                    Scope = Repeater;
                    ToolTip = 'View the ledger entries that have been applied to this record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed Vendor Ledg. Entries";
                    RunPageLink = "Vendor Ledger Entry No."=field("Entry No."),
                                  "Vendor No."=field("Vendor No.");
                    RunPageView = sorting("Vendor Ledger Entry No.","Posting Date");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific vendor ledger entry';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ActionApplyEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';

                    trigger OnAction()
                    var
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        VendEntryApplyPostEntries: Codeunit "VendEntry-Apply Posted Entries";
                    begin
                        VendLedgEntry.Copy(Rec);
                        VendEntryApplyPostEntries.ApplyVendEntryFormEntry(VendLedgEntry);
                        Rec := VendLedgEntry;
                        CurrPage.Update;
                    end;
                }
                separator(Action66)
                {
                }
                action(UnapplyEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Unapply Entries';
                    Ellipsis = true;
                    Image = UnApply;
                    Scope = Repeater;
                    ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.';

                    trigger OnAction()
                    var
                        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
                    begin
                        VendEntryApplyPostedEntries.UnApplyVendLedgEntry("Entry No.");
                    end;
                }
                separator(Action68)
                {
                }
                action(ReverseTransaction)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Scope = Repeater;
                    ToolTip = 'Reverse an erroneous vendor ledger entry.';

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        Clear(ReversalEntry);
                        if Reversed then
                          ReversalEntry.AlreadyReversedEntry(TableCaption,"Entry No.");
                        if "Journal Batch Name" = '' then
                          ReversalEntry.TestFieldError;
                        TestField("Transaction No.");
                        ReversalEntry.ReverseTransaction("Transaction No.");
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCard("Document No.","Posting Date");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Select Incoming Document';
                        Enabled = not HasIncomingDocument;
                        Image = SelectLineToApply;
                        ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.SelectIncomingDocumentForPostedDocument("Document No.","Posting Date",RecordId);
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = not HasIncomingDocument;
                        Image = Attach;
                        ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPostedDocument("Document No.","Posting Date");
                        end;
                    }
                }
            }
            action("&Navigate")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
            action("Show Posted Document")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Posted Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Show details for the posted payment, invoice, or credit memo.';

                trigger OnAction()
                begin
                    ShowDoc
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "Incoming Document";
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists("Document No.","Posting Date");
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    trigger OnModifyRecord(): Boolean
    begin
          Codeunit.Run(Codeunit::"Vend. Entry-Edit",Rec);
          exit(false);
    end;

    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;

    var
        Navigate: Page Navigate;
        StyleTxt: Text;
        HasIncomingDocument: Boolean;
}

