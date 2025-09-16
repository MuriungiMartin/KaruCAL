#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7352 "Put-away Worksheet"
{
    ApplicationArea = Basic;
    Caption = 'Put-away Worksheet';
    DataCaptionFields = Name;
    InsertAllowed = false;
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
                OptionCaption = ' ,Item,Document,Shelf or Bin,Due Date';
                ToolTip = 'Specifies the method by which the warehouse internal put-away lines are sorted.';

                trigger OnValidate()
                begin
                    CurrentSortingMethodOnAfterVal;
                end;
            }
            repeater(Control1)
            {
                field("Whse. Document Type";"Whse. Document Type")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,Receipt,,Internal Put-away';
                    ToolTip = 'Specifies the type of warehouse document this line is associated with.';
                }
                field("Whse. Document No.";"Whse. Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse document.';
                }
                field("Whse. Document Line No.";"Whse. Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line in the warehouse document that is the basis for the worksheet line.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the item that the line concerns.';

                    trigger OnValidate()
                    begin
                        GetItem("Item No.",ItemDescription);
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the variant number of the item on the line, if any.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the description of the item on the line.';
                }
                field("From Zone Code";"From Zone Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Indicates the zone from which the items should be taken.';
                    Visible = false;
                }
                field("From Bin Code";"From Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the bin from which the items should be taken.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for information use.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item you want to move.';
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
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the unit of measure code of the item when it is placed in the bin in the To Bin Code field.';
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
                action("Source &Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source &Document Line';
                    Image = SourceDocLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        WMSMgt.ShowSourceDocLine(
                          "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
                    end;
                }
                action("Whse. Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Document Line';
                    Image = Line;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        WMSMgt.ShowWhseDocLine(
                          "Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Scope = Repeater;
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
                    Scope = Repeater;
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
                    Scope = Repeater;
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
                    Scope = Repeater;
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
                    Scope = Repeater;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(GetWarehouseDocuments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Warehouse Documents';
                    Ellipsis = true;
                    Image = GetSourceDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    var
                        GetWhsePutAwayDoc: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetWhsePutAwayDoc.GetSingleWhsePutAwayDoc(
                          CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
                        SortWhseWkshLines(
                          CurrentWkshTemplateName,CurrentWkshName,
                          CurrentLocationCode,CurrentSortingMethod);
                    end;
                }
                separator(Action3)
                {
                }
                action("Autofill Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Caption = 'Autofill Qty. to Handle';
                    Image = AutofillQtyToHandle;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;

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
                    Scope = Repeater;

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
                action(CreatePutAway)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Put-away';
                    Ellipsis = true;
                    Image = CreatePutAway;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        WhseWkshLine: Record "Whse. Worksheet Line";
                    begin
                        WhseWkshLine.CopyFilters(Rec);
                        if WhseWkshLine.FindFirst then
                          PutAwayCreate(WhseWkshLine)
                        else
                          Error(Text001);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetItem("Item No.",ItemDescription);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ItemDescription := '';
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
        TemplateSelection(Page::"Put-away Worksheet",0,Rec,WhseWkshSelected);
        if not WhseWkshSelected then
          Error('');
        OpenWhseWksh(Rec,CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
    end;

    var
        WMSMgt: Codeunit "WMS Management";
        CurrentWkshTemplateName: Code[10];
        CurrentWkshName: Code[10];
        CurrentLocationCode: Code[10];
        CurrentSortingMethod: Option " ",Item,Document,"Shelf/Bin No.","Due Date";
        ItemDescription: Text[50];
        Text001: label 'There is nothing to handle.';
        OpenedFromBatch: Boolean;

    local procedure QtytoHandleOnAfterValidate()
    begin
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

