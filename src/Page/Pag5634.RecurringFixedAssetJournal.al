#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5634 "Recurring Fixed Asset Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Recurring Fixed Asset Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "FA Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch of the fixed asset journal.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    FAJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    FAJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Recurring Method";"Recurring Method")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a recurring method, if you have indicated that the journal is recurring.';
                }
                field("Recurring Frequency";"Recurring Frequency")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a recurring frequency if you indicated that the journal is a recurring.';
                }
                field("FA Posting Date";"FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date that will be used as the posting date on FA ledger entries.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the same date as the FA Posting Date field when the line is posted.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the appropriate document type for the amount you want to post.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the resource you want to post an entry for.';

                    trigger OnValidate()
                    begin
                        FAJnlManagement.GetFA("FA No.",FADescription);
                    end;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the depreciation book to which the line will be posted.';
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the appropriate posting type for the amount you want to post.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Automatically retrieves the description from the FA card when the FA No. field is filled in.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the total amount the journal line consists of.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether to automatically post depreciation of the existing (old) fixed asset.';
                    Visible = false;
                }
                field("Maintenance Code";"Maintenance Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a maintenance code.';
                    Visible = false;
                }
                field("Insurance No.";"Insurance No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies an insurance code if you have selected the Acquisition Cost option in the FA Posting Type field.';
                    Visible = false;
                }
                field("Budgeted FA No.";"Budgeted FA No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a fixed asset number.';
                    Visible = false;
                }
                field("Duplicate in Depreciation Book";"Duplicate in Depreciation Book")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
                    Visible = false;
                }
                field("Use Duplication List";"Use Duplication List")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether the line is to be posted to all depreciation books, using different journal batches and with a check mark in the Part of Duplication List field.';
                    Visible = false;
                }
                field("FA Reclassification Entry";"FA Reclassification Entry")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Automatically selects the field if the entry was generated from an FA reclassification journal.';
                    Visible = false;
                }
                field("Index Entry";"Index Entry")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether to post an indexation.';
                    Visible = false;
                }
                field("FA Error Entry No.";"FA Error Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of a posted FA ledger entry to mark as an error entry.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the last date on which the recurring journal will be posted.';
                }
            }
            group(Control2)
            {
                fixed(Control1900116601)
                {
                    group("FA Description")
                    {
                        Caption = 'FA Description';
                        field(FADescription;FADescription)
                        {
                            ApplicationArea = FixedAssets;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies a description of the fixed asset.';
                        }
                    }
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
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
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("Fixed &Asset")
            {
                Caption = 'Fixed &Asset';
                Image = FixedAssets;
                action(Card)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Fixed Asset Card";
                    RunPageLink = "No."=field("FA No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the fixed asset.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Ledger E&ntries';
                    Image = FixedAssetLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Codeunit "FA Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the ledger entries for the selected fixed asset.';
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintFAJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"FA. Jnl.-Post",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        FAJnlPost: Codeunit "FA. Jnl.-Post";
                    begin
                        FAJnlPost.Preview(Rec);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"FA. Jnl.-Post+Print",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        FAJnlManagement.GetFA("FA No.",FADescription);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          FAJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
          exit;
        end;
        FAJnlManagement.TemplateSelection(Page::"Recurring Fixed Asset Journal",true,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        FAJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
    end;

    var
        FAJnlManagement: Codeunit FAJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        FADescription: Text[30];
        ShortcutDimCode: array [8] of Code[20];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        FAJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

