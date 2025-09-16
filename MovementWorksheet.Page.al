#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7351 "Movement Worksheet"
{
    ApplicationArea = Basic;
    Caption = 'Movement Worksheet';
    DataCaptionFields = Name;
    DelayedInsert = true;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Whse. Worksheet Line";
    SourceTableView = sorting("Worksheet Template Name",Name,"Location Code","Sorting Sequence No.");
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentWkshName;CurrentWkshName)
            {
                ApplicationArea = Basic;
                Caption = 'Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    LookupWhseWkshName(Rec,CurrentWkshName,CurrentLocationCode);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    CheckWhseWkshName(CurrentWkshName,CurrentLocationCode,Rec);
                    CurrentWkshNameOnAfterValidate;
                end;
            }
            field(CurrentLocationCode;CurrentLocationCode)
            {
                ApplicationArea = Basic;
                Caption = 'Location Code';
                Editable = false;
            }
            field(CurrentSortingMethod;CurrentSortingMethod)
            {
                ApplicationArea = Basic;
                Caption = 'Sorting Method';
                OptionCaption = ' ,Item,,To Bin Code,Due Date';
                ToolTip = 'Specifies the method by which the movement worksheet lines are sorted.';

                trigger OnValidate()
                begin
                    CurrentSortingMethodOnAfterVal;
                end;
            }
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that the line concerns.';

                    trigger OnValidate()
                    begin
                        GetItem("Item No.",ItemDescription);
                        ItemNoOnAfterValidate;
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the item on the line, if any.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item on the line.';
                }
                field("From Zone Code";"From Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the zone from which the items should be taken.';
                }
                field("From Bin Code";"From Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin from which the items should be taken.';
                }
                field("To Zone Code";"To Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone in which the items should be placed.';
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin into which the items should be placed.';

                    trigger OnValidate()
                    begin
                        ToBinCodeOnAfterValidate;
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item you want to move.';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be handled in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled.';
                }
                field("Qty. Outstanding (Base)";"Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled, expressed in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. to Handle";"Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item you want to move.';

                    trigger OnValidate()
                    begin
                        QtytoHandleOnAfterValidate;
                    end;
                }
                field("Qty. to Handle (Base)";"Qty. to Handle (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity you want to handle, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Handled";"Qty. Handled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that has been handled and registered.';
                }
                field("Qty. Handled (Base)";"Qty. Handled (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that has been handled and registered, in the base unit of measure.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the due date of the line.';

                    trigger OnValidate()
                    begin
                        DueDateOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item when it is placed in the bin in the To Bin Code field.';
                }
                field("ROUND(CheckAvailQtytoMove / ItemUOM.""Qty. per Unit of Measure"",0.00001)";ROUND(CheckAvailQtytoMove / ItemUOM."Qty. per Unit of Measure",0.00001))
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Qty. to Move';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies how many item units are available to be moved from the From bin, taking into account other warehouse movements for the item.';
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
            part(Control8;"Lot Numbers by Bin FactBox")
            {
                SubPageLink = "Item No."=field("Item No."),
                              "Variant Code"=field("Variant Code"),
                              "Location Code"=field("Location Code");
                Visible = false;
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
                    Promoted = true;
                    PromotedCategory = Process;
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
                    Promoted = true;
                    PromotedCategory = Process;
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
                    Promoted = true;
                    PromotedCategory = Process;
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
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Autofill Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Caption = 'Autofill Qty. to Handle';
                    Image = AutofillQtyToHandle;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        WhseWkshLine: Record "Whse. Worksheet Line";
                    begin
                        WhseWkshLine.Copy(Rec);
                        AutofillQtyToHandle(WhseWkshLine);
                    end;
                }
                action("Delete Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Qty. to Handle';
                    Image = DeleteQtyToHandle;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        WhseWkshLine: Record "Whse. Worksheet Line";
                    begin
                        WhseWkshLine.Copy(Rec);
                        DeleteQtyToHandle(WhseWkshLine);
                    end;
                }
                separator(Action54)
                {
                }
                action("Calculate Bin &Replenishment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate Bin &Replenishment';
                    Ellipsis = true;
                    Image = CalculateBinReplenishment;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Location: Record Location;
                        BinContent: Record "Bin Content";
                        ReplenishBinContent: Report "Calculate Bin Replenishment";
                    begin
                        Location.Get("Location Code");
                        ReplenishBinContent.InitializeRequest(
                          "Worksheet Template Name",Name,"Location Code",
                          Location."Allow Breakbulk",false,false);

                        BinContent.SetRange("Location Code",Location.Code);
                        ReplenishBinContent.SetTableview(BinContent);
                        ReplenishBinContent.Run;
                        Clear(ReplenishBinContent);
                    end;
                }
                action("Get Bin Content")
                {
                    AccessByPermission = TableData "Bin Content"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get Bin Content';
                    Ellipsis = true;
                    Image = GetBinContent;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        BinContent: Record "Bin Content";
                        DummyRec: Record "Whse. Internal Put-away Header";
                        GetBinContent: Report "Whse. Get Bin Content";
                    begin
                        BinContent.SetRange("Location Code","Location Code");
                        GetBinContent.SetTableview(BinContent);
                        GetBinContent.InitializeReport(Rec,DummyRec,0);
                        GetBinContent.Run;
                    end;
                }
                separator(Action3)
                {
                }
                action("Create Movement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Movement';
                    Ellipsis = true;
                    Image = CreateMovement;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WhseWkshLine: Record "Whse. Worksheet Line";
                    begin
                        WhseWkshLine.SetFilter(Quantity,'>0');
                        WhseWkshLine.CopyFilters(Rec);
                        if WhseWkshLine.FindFirst then
                          MovementCreate(WhseWkshLine)
                        else
                          Error(Text001);

                        WhseWkshLine.Reset;
                        CopyFilters(WhseWkshLine);
                        FilterGroup(2);
                        SetRange("Worksheet Template Name","Worksheet Template Name");
                        SetRange(Name,Name);
                        SetRange("Location Code",CurrentLocationCode);
                        FilterGroup(0);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetItem("Item No.",ItemDescription);
    end;

    trigger OnAfterGetRecord()
    begin
        if not ItemUOM.Get("Item No.","From Unit of Measure Code") then
          ItemUOM.Init;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ItemDescription := '';
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Sorting Sequence No." := GetSortSeqNo(CurrentSortingMethod);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        "Sorting Sequence No." := GetSortSeqNo(CurrentSortingMethod);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(
          CurrentWkshTemplateName,CurrentWkshName,
          CurrentLocationCode,CurrentSortingMethod,xRec."Line No.");
    end;

    trigger OnOpenPage()
    var
        WhseWkshSelected: Boolean;
    begin
        OpenedFromBatch := (Name <> '') and ("Worksheet Template Name" = '');
        if OpenedFromBatch then begin
          CurrentWkshName := Name;
          CurrentLocationCode := "Location Code";
          OpenWhseWksh(Rec,CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
          exit;
        end;
        TemplateSelection(Page::"Movement Worksheet",2,Rec,WhseWkshSelected);
        if not WhseWkshSelected then
          Error('');
        OpenWhseWksh(Rec,CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
    end;

    var
        ItemUOM: Record "Item Unit of Measure";
        CurrentWkshTemplateName: Code[10];
        CurrentWkshName: Code[10];
        CurrentLocationCode: Code[10];
        CurrentSortingMethod: Option " ",Item,,"Shelf/Bin No.","Due Date";
        ItemDescription: Text[50];
        Text001: label 'There is nothing to handle.';
        OpenedFromBatch: Boolean;

    local procedure ItemNoOnAfterValidate()
    begin
        if CurrentSortingMethod = Currentsortingmethod::Item then
          CurrPage.Update;
    end;

    local procedure ToBinCodeOnAfterValidate()
    begin
        if CurrentSortingMethod = Currentsortingmethod::"Shelf/Bin No." then
          CurrPage.Update;
    end;

    local procedure QuantityOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QtytoHandleOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure DueDateOnAfterValidate()
    begin
        if CurrentSortingMethod = Currentsortingmethod::"Due Date" then
          CurrPage.Update;
    end;

    local procedure CurrentWkshNameOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetWhseWkshName(CurrentWkshName,CurrentLocationCode,Rec);
        CurrPage.Update(false);
    end;

    local procedure CurrentSortingMethodOnAfterVal()
    begin
        SortWhseWkshLines(
          CurrentWkshTemplateName,CurrentWkshName,
          CurrentLocationCode,CurrentSortingMethod);
        CurrPage.Update(false);
        SetCurrentkey("Worksheet Template Name",Name,"Location Code","Sorting Sequence No.");
    end;
}

