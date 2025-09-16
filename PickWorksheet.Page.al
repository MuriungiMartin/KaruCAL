#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7345 "Pick Worksheet"
{
    ApplicationArea = Basic;
    Caption = 'Pick Worksheet';
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
                Caption = 'Batch Name';
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
                OptionCaption = ' ,Item,Document,Shelf or Bin,Due Date,Ship-To';
                ToolTip = 'Specifies the method by which the movement lines are sorted.';

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
                    OptionCaption = ' ,,Shipment,,Internal Pick,Production,,,Assembly';
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
                field("To Zone Code";"To Zone Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the zone in which the items should be placed.';
                    Visible = false;
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the bin into which the items should be placed.';
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
                field("Qty. to Handle";"Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item you want to move.';

                    trigger OnValidate()
                    begin
                        QtytoHandleOnAfterValidate;
                    end;
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled.';
                }
                field(AvailableQtyToPick;AvailableQtyToPick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Qty. to Pick';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity on the pick worksheet line that is available to pick. This quantity includes released warehouse shipment lines.';
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
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping advice on the warehouse shipment line associated with this worksheet line.';
                }
                field("Destination Type";"Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of destination associated with the warehouse worksheet line.';
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer, vendor, or location for which the items should be processed.';
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document to which the line relates.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source number of the document from which the line originates.';
                    Visible = false;
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source line number of the document from which the entry originates.';
                    Visible = false;
                }
                field(QtyCrossDockedUOM;QtyCrossDockedUOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock Bin';
                    DecimalPlaces = 0:5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",true);
                    end;
                }
                field(QtyCrossDockedUOMBase;QtyCrossDockedUOMBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",true);
                    end;
                }
                field(QtyCrossDockedAllUOMBase;QtyCrossDockedAllUOMBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock Bin (Base all UOM)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",false);
                    end;
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
                    RunPageView = sorting("Item No.","Location Code","Variant Code","Bin Type Code","Unit of Measure Code","Lot No.","Serial No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
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
                action("Get Warehouse Documents")
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
                        RetrieveWhsePickDoc: Codeunit "Get Source Doc. Outbound";
                    begin
                        RetrieveWhsePickDoc.GetSingleWhsePickDoc(
                          CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
                        SortWhseWkshLines(
                          CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode,CurrentSortingMethod);
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

                    trigger OnAction()
                    var
                        PickWkshLine: Record "Whse. Worksheet Line";
                    begin
                        PickWkshLine.Copy(Rec);
                        AutofillQtyToHandle(PickWkshLine);
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
                        PickWkshLine: Record "Whse. Worksheet Line";
                    begin
                        PickWkshLine.Copy(Rec);
                        DeleteQtyToHandle(PickWkshLine);
                    end;
                }
                separator(Action54)
                {
                }
                action(CreatePick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Whse. Create Pick",Rec);
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
        CrossDockMgt.CalcCrossDockedItems("Item No.","Variant Code","Unit of Measure Code","Location Code",
          QtyCrossDockedUOMBase,
          QtyCrossDockedAllUOMBase);
        QtyCrossDockedUOM := 0;
        if  "Qty. per Unit of Measure" <> 0 then
          QtyCrossDockedUOM := ROUND(QtyCrossDockedUOMBase / "Qty. per Unit of Measure",0.00001);
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
        TemplateSelection(Page::"Pick Worksheet",1,Rec,WhseWkshSelected);
        if not WhseWkshSelected then
          Error('');
        OpenWhseWksh(Rec,CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
    end;

    var
        WMSMgt: Codeunit "WMS Management";
        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
        CurrentWkshTemplateName: Code[10];
        CurrentWkshName: Code[10];
        CurrentLocationCode: Code[10];
        CurrentSortingMethod: Option " ",Item,Document,"Shelf/Bin No.","Due Date","Ship-To";
        ItemDescription: Text[50];
        QtyCrossDockedUOM: Decimal;
        QtyCrossDockedAllUOMBase: Decimal;
        QtyCrossDockedUOMBase: Decimal;
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
          CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode,CurrentSortingMethod);
        CurrPage.Update(false);
        SetCurrentkey("Worksheet Template Name",Name,"Location Code","Sorting Sequence No.");
    end;
}

