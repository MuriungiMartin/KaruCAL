#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 207 "Resource Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Resource Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Res. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Jobs;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ResJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ResJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when you want to assign.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the resource journal line.';
                    Visible = false;
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an entry type for each line.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an external document number that is related to the resource transaction on this journal line.';
                    Visible = false;
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the resource that you want to post an entry for.';

                    trigger OnValidate()
                    begin
                        ResJnlManagement.GetRes("Resource No.",ResName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Resource Group No.";"Resource Group No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the resource group that this resource is assigned to.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the description or name of the resource you chose in the Resource No. field.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity of units you intend to post.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies how the resource is measured.';
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the direct unit cost. As a default value, the amount is retrieved from the resource card or Resource Cost table.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost.';
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost for this journal line.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit price.';
                }
                field("Total Price";"Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price on the journal line.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the reason code that has been entered on the journal lines.';
                    Visible = false;
                }
                field("Time Sheet No.";"Time Sheet No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of a time sheet.';
                    Visible = false;
                }
                field("Time Sheet Line No.";"Time Sheet Line No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line number for a time sheet.';
                    Visible = false;
                }
                field("Time Sheet Date";"Time Sheet Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when a time sheet is created.';
                    Visible = false;
                }
            }
            group(Control41)
            {
                fixed(Control1903222401)
                {
                    group("Resource Name")
                    {
                        Caption = 'Resource Name';
                        field(ResName;ResName)
                        {
                            ApplicationArea = Jobs;
                            Editable = false;
                            ShowCaption = false;
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
                    ApplicationArea = Jobs;
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
            group("&Resource")
            {
                Caption = '&Resource';
                Image = Resource;
                action(Card)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Resource Card";
                    RunPageLink = "No."=field("Resource No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record that is being processed on the journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Resource Ledger Entries";
                    RunPageLink = "Resource No."=field("Resource No.");
                    RunPageView = sorting("Resource No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
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
                    ApplicationArea = Jobs;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintResJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Jobs;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Res. Jnl.-Post",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Res. Jnl.-Post+Print",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SuggestLinesFromTimeSheets)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Suggest Lines from Time Sheets';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Fill the journal with lines that exist in the time sheets.';

                    trigger OnAction()
                    var
                        SuggestResJnlLines: Report "Suggest Res. Jnl. Lines";
                    begin
                        SuggestResJnlLines.SetResJnlLine(Rec);
                        SuggestResJnlLines.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ResJnlManagement.GetRes("Resource No.",ResName);
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
          ResJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          exit;
        end;
        ResJnlManagement.TemplateSelection(Page::"Resource Journal",false,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        ResJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        ResJnlManagement: Codeunit ResJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        ResName: Text[50];
        ShortcutDimCode: array [8] of Code[20];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ResJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

