#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 286 "Recurring Item Jnl."
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Recurring Item Jnl.';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Item Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Suite;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the journal batch of the recurring item journal.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ItemJnlMgt.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ItemJnlMgt.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Recurring Method";"Recurring Method")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a recurring method, if you have indicated that the journal is recurring.';
                }
                field("Recurring Frequency";"Recurring Frequency")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a recurring frequency if you have indicated that the journal is recurring.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the item journal line.';
                    Visible = false;
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Suite;
                    OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';
                    ToolTip = 'Specifies the type of transaction that will be posted from the item journal line.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item on the journal line.';

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetItem("Item No.",ItemDescription);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the item on the journal line.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the item journal line is linked to.';
                    Visible = false;
                }
                field("New Shortcut Dimension 1 Code";"New Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the new dimension value code that the item journal line will be linked to.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the item journal line is linked to.';
                    Visible = false;
                }
                field("New Shortcut Dimension 2 Code";"New Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the new dimension value code that the item journal line will be linked to.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
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
                field("NewShortcutDimCode[3]";NewShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text001;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupNewShortcutDimCode(3,NewShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        TestField("Entry Type","entry type"::Transfer);
                        ValidateNewShortcutDimCode(3,NewShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
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
                field("NewShortcutDimCode[4]";NewShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text002;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupNewShortcutDimCode(4,NewShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        TestField("Entry Type","entry type"::Transfer);
                        ValidateNewShortcutDimCode(4,NewShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
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
                field("NewShortcutDimCode[5]";NewShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text003;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupNewShortcutDimCode(5,NewShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        TestField("Entry Type","entry type"::Transfer);
                        ValidateNewShortcutDimCode(5,NewShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
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
                field("NewShortcutDimCode[6]";NewShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text004;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupNewShortcutDimCode(6,NewShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        TestField("Entry Type","entry type"::Transfer);
                        ValidateNewShortcutDimCode(6,NewShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
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
                field("NewShortcutDimCode[7]";NewShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text005;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupNewShortcutDimCode(7,NewShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        TestField("Entry Type","entry type"::Transfer);
                        ValidateNewShortcutDimCode(7,NewShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
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
                field("NewShortcutDimCode[8]";NewShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text006;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupNewShortcutDimCode(8,NewShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        TestField("Entry Type","entry type"::Transfer);
                        ValidateNewShortcutDimCode(8,NewShortcutDimCode[8]);
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the inventory location where the item on the journal line will be registered.';
                    Visible = true;

                    trigger OnValidate()
                    var
                        WMSManagement: Codeunit "WMS Management";
                    begin
                        WMSManagement.CheckItemJnlLineLocation(Rec,xRec);
                    end;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a bin code for the item.';
                    Visible = false;
                }
                field("New Location Code";"New Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the new location to link to the items on this journal line.';
                    Visible = false;

                    trigger OnValidate()
                    var
                        WMSManagement: Codeunit "WMS Management";
                    begin
                        WMSManagement.CheckItemJnlLineLocation(Rec,xRec);
                    end;
                }
                field("New Bin Code";"New Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the new bin code to link to the items on this journal line.';
                    Visible = false;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general business posting group that will be used when you post the entry on the item journal line.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general product posting group that will be used for this item when you post the entry on the item journal line.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of units of the item to be included on the journal line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code if you have filled in the Sales Unit of Measure field on the item card.';
                }
                field("Unit Amount";"Unit Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the price of one unit of the item on the journal line.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the line''s net amount.';
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item indirect cost.';
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit cost of the item on the line.';
                }
                field("Applies-to Entry";"Applies-to Entry")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the quantity in the item journal line should be applied to an already-posted document.';
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number for the transaction type, for the purpose of reporting to Intrastat.';
                    Visible = false;
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the transport method.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code that applies to the journal line.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code that will be inserted on the journal lines.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the last date on which the recurring journal will be posted, if you have indicated that the journal is recurring.';
                }
            }
            group(Control26)
            {
                fixed(Control1902454601)
                {
                    group("Item Description")
                    {
                        Caption = 'Item Description';
                        field(ItemDescription;ItemDescription)
                        {
                            ApplicationArea = Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies a description of the item.';
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
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines(false);
                    end;
                }
                action("Bin Contents")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Contents List";
                    RunPageLink = "Location Code"=field("Location Code"),
                                  "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code");
                    RunPageView = sorting("Location Code","Bin Code","Item No.","Variant Code");
                }
            }
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Item Card";
                    RunPageLink = "No."=field("Item No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record that is being processed on the journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Suite;
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No."=field("Item No.");
                    RunPageView = sorting("Item No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and projected inventory level of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Period';
                        Image = Period;
                        ToolTip = 'Show the actual and projected quantity of an item over time according to a specified time interval, such as by day, week or month.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location=R;
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ToolTip = 'View how the inventory level of an item develops over time according to the bill of materials level that you select.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("E&xplode BOM")
                {
                    ApplicationArea = Suite;
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;
                    RunObject = Codeunit "Item Jnl.-Explode BOM";
                    ToolTip = 'View the contents of the bill of materials.';
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintItemJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Item Jnl.-Post";
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                }
                action("Post and &Print")
                {
                    ApplicationArea = Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Item Jnl.-Post+Print";
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                }
            }
            action("&Print")
            {
                ApplicationArea = Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    ItemJnlLine.Copy(Rec);
                    ItemJnlLine.SetRange("Journal Template Name","Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name","Journal Batch Name");
                    Report.RunModal(Report::"Inventory Movement",true,true,ItemJnlLine);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ItemJnlMgt.GetItem("Item No.",ItemDescription);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        ShowNewShortcutDimCode(NewShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
    begin
        Commit;
        if not ReserveItemJnlLine.DeleteLineConfirm(Rec) then
          exit(false);
        ReserveItemJnlLine.DeleteLine(Rec);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if "Entry Type" > "entry type"::"Negative Adjmt." then
          Error(Text000,"Entry Type");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
        Clear(NewShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
          exit;
        end;
        ItemJnlMgt.TemplateSelection(Page::"Recurring Item Jnl.",0,true,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        Text000: label 'You cannot use entry type %1 in this journal.';
        Text001: label '1,2,3,New ';
        Text002: label '1,2,4,New ';
        Text003: label '1,2,5,New ';
        Text004: label '1,2,6,New ';
        Text005: label '1,2,7,New ';
        Text006: label '1,2,8,New ';
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        CurrentJnlBatchName: Code[10];
        ItemDescription: Text[50];
        ShortcutDimCode: array [8] of Code[20];
        NewShortcutDimCode: array [8] of Code[20];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ItemJnlMgt.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

