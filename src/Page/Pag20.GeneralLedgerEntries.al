#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 20 "General Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'General Ledger Entries';
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "G/L Entry";
    SourceTableView = sorting("G/L Account No.","Posting Date")
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
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Document Type that the entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry''s Document No.';
                }
                field("G/L Account No.";"G/L Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the account that the entry has been posted to.';
                }
                field("Count Doc No";"Count Doc No")
                {
                    ApplicationArea = Basic;
                }
                field(Available;Available)
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account Name";"G/L Account Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the account that the entry has been posted to.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Job No. corresponding the to G/L entry.';
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction is with if the entry was posted from an intercompany transaction.';
                    Visible = false;
                }
                field("Gen. Posting Type";"Gen. Posting Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Gen. Posting Type that applies to the entry.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general business posting group that applies to the entry.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general product posting group that applies to the entry.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that was posted on the entry.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Amount of the entry.';
                }
                field("Additional-Currency Amount";"Additional-Currency Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general ledger entry that is posted if you post in an additional reporting currency.';
                    Visible = false;
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax Amount that was posted as a result of the entry.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of balancing account used in the entry: G/L Account, Bank Account, Vendor, Customer, or Fixed Asset.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the G/L account or the bank account, that a balancing entry has been posted to.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user that is associated with the entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Source Code that is linked to the entry.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code on the entry.';
                    Visible = false;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction (correction) made by the Reverse function.';
                    Visible = false;
                }
                field("Reversed by Entry No.";"Reversed by Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the correcting entry. If the field Specifies a number, the entry cannot be reversed again.';
                    Visible = false;
                }
                field("Reversed Entry No.";"Reversed Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.';
                    Visible = false;
                }
                field("FA Entry Type";"FA Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is automatically updated.';
                    Visible = false;
                }
                field("FA Entry No.";"FA Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is automatically updated.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Entry No. that the program has given the entry.';
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
                        CurrPage.SaveRecord;
                    end;
                }
                action(GLDimensionOverview)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'G/L Dimension Overview';
                    Image = Dimensions;
                    ToolTip = 'View an overview of general ledger entries and dimensions.';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"G/L Entries Dimension Overview",Rec);
                    end;
                }
                action("Value Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Value Entries';
                    Image = ValueLedger;
                    Scope = Repeater;
                    ToolTip = 'View all amounts relating to an item.';

                    trigger OnAction()
                    begin
                        ShowValueEntries;
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
                    ApplicationArea = Basic,Suite;
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Scope = Repeater;
                    ToolTip = 'Reverse a posted general ledger entry.';

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
                        ReversalEntry.ReverseTransaction("Transaction No.")
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
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
            action(DocsWithoutIC)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Posted Documents without Incoming Document';
                Image = Documents;
                ToolTip = 'View posted purchase and sales documents under the G/L account that do not have related incoming document records.';

                trigger OnAction()
                var
                    PostedDocsWithNoIncBuf: Record "Posted Docs. With No Inc. Buf.";
                begin
                    Copyfilter("G/L Account No.",PostedDocsWithNoIncBuf."G/L Account No. Filter");
                    Page.Run(Page::"Posted Docs. With No Inc. Doc.",PostedDocsWithNoIncBuf);
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

    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;

    var
        GLAcc: Record "G/L Account";
        HasIncomingDocument: Boolean;

    local procedure GetCaption(): Text[250]
    begin
        if GLAcc."No." <> "G/L Account No." then
          if not GLAcc.Get("G/L Account No.") then
            if GetFilter("G/L Account No.") <> '' then
              if GLAcc.Get(GetRangeMin("G/L Account No.")) then;
        exit(StrSubstNo('%1 %2',GLAcc."No.",GLAcc.Name))
    end;
}

