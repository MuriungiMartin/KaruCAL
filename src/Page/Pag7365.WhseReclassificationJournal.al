#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7365 "Whse. Reclassification Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Whse. Reclassification Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Warehouse Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    LookupName(CurrentJnlBatchName,CurrentLocationCode,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    CheckName(CurrentJnlBatchName,CurrentLocationCode,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            field(CurrentLocationCode;CurrentLocationCode)
            {
                ApplicationArea = Basic;
                Caption = 'Location Code';
                Editable = false;
                Lookup = true;
                TableRelation = Location;
            }
            repeater(Control1)
            {
                field("Registering Date";"Registering Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the line is registered.';
                }
                field("Whse. Document No.";"Whse. Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Document No.';
                    ToolTip = 'Specifies the warehouse document number of the journal line.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item on the journal line.';

                    trigger OnValidate()
                    begin
                        GetItem("Item No.",ItemDescription);
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item.';
                }
                field("From Zone Code";"From Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone from which the item on the journal line is taken.';
                }
                field("From Bin Code";"From Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin from which the item on the journal line is taken.';
                }
                field("To Zone Code";"To Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone to which the item on the journal line will be moved.';
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin to which the item on the journal line will be moved.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    MinValue = 0;
                    ToolTip = 'Specifies the number of units of the item in the adjustment (positive or negative) or the reclassification.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the unit of measure for this item.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason Code';
                    ToolTip = 'Specifies the reason code for the warehouse journal line.';
                    Visible = false;
                }
            }
            group(Control22)
            {
                fixed(Control1900669001)
                {
                    group("Item Description")
                    {
                        Caption = 'Item Description';
                        field(ItemDescription;ItemDescription)
                        {
                            ApplicationArea = Basic;
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
                action(ItemTrackingLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
            }
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Item Card";
                    RunPageLink = "No."=field("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Warehouse Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Warehouse Entries';
                    Image = BinLedger;
                    RunObject = Page "Warehouse Entries";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Location Code"=field("Location Code");
                    RunPageView = sorting("Item No.","Location Code","Variant Code");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Location Code"=field("Location Code");
                    RunPageView = sorting("Item No.");
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
                    RunPageView = sorting("Location Code","Item No.","Variant Code");
                }
            }
        }
        area(processing)
        {
            group("&Registering")
            {
                Caption = '&Registering';
                Image = PostOrder;
                action("Test Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintWhseJnlLine(Rec);
                    end;
                }
                action(Register)
                {
                    ApplicationArea = Basic;
                    Caption = '&Register';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Whse. Jnl.-Register",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Register and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Register and &Print';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Whse. Jnl.-Register+Print",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetItem("Item No.",ItemDescription);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if "Journal Batch Name" <> '' then
          SetUpNewLine(xRec);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          CurrentLocationCode := "Location Code";
          OpenJnl(CurrentJnlBatchName,CurrentLocationCode,Rec);
          exit;
        end;
        TemplateSelection(Page::"Whse. Reclassification Journal",2,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        OpenJnl(CurrentJnlBatchName,CurrentLocationCode,Rec);
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        CurrentLocationCode: Code[10];
        ItemDescription: Text[50];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        SetName(CurrentJnlBatchName,CurrentLocationCode,Rec);
        CurrPage.Update(false);
    end;
}

