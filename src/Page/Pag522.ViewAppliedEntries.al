#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 522 "View Applied Entries"
{
    Caption = 'View Applied Entries';
    DataCaptionExpression = CaptionExpr;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Worksheet;
    Permissions = TableData "Item Application Entry"=rimd;
    SaveValues = true;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                Editable = false;
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what type of document was posted to create the item ledger entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                }
                field("Document Line No.";"Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line on the posted document that corresponds to the item ledger entry.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item in the entry.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the items.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a serial number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the entry.';
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location that the entry is linked to.';
                    Visible = false;
                }
                field(ApplQty;ApplQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Applied Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity of the item ledger entry linked to an inventory decrease, or increase, as appropriate.';
                }
                field(Qty;Qty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity of the item ledger entry.';
                }
                field("Cost Amount (Actual)";"Cost Amount (Actual)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the adjusted cost, in $, of the quantity posting.';
                }
                field(GetUnitCostLCY;GetUnitCostLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Cost($)';
                    ToolTip = 'Specifies the unit cost of the item in the item ledger entry.';
                    Visible = false;
                }
                field("Invoiced Quantity";"Invoiced Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item on the line have been invoiced.';
                    Visible = true;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that remains in inventory in the Quantity field if the entry is an increase (a purchase or positive adjustment).';
                    Visible = true;
                }
                field("CostAvailable(Rec)";CostAvailable(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity Available for Cost Applications';
                    DecimalPlaces = 0:5;
                }
                field("QuantityAvailable(Rec)";QuantityAvailable(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Available for Quantity Application';
                    DecimalPlaces = 0:5;
                }
                field("Shipped Qty. Not Returned";"Shipped Qty. Not Returned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity for this item ledger entry that was shipped and has not yet been returned.';
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per item unit of measure.';
                    Visible = false;
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the items on the line have been shipped directly to the customer.';
                    Visible = false;
                }
                field("Applies-to Entry";"Applies-to Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item entry number that was applied to when the entry was posted, if an already-posted document was designated to be applied.';
                    Visible = false;
                }
                field("Applied Entry to Adjust";"Applied Entry to Adjust")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether there is one or more applied entries, which need to be adjusted.';
                    Visible = false;
                }
                field("Order Type";"Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which type of order that the entry was created in.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the order that created the entry.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number for the entry.';
                }
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
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("&Value Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    RunObject = Page "Value Entries";
                    RunPageLink = "Item Ledger Entry No."=field("Entry No.");
                    RunPageView = sorting("Item Ledger Entry No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
            }
        }
        area(processing)
        {
            action(RemoveAppButton)
            {
                ApplicationArea = Basic;
                Caption = 'Re&move Application';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                Visible = RemoveAppButtonVisible;

                trigger OnAction()
                begin
                    UnapplyRec;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetApplQty;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(Find(Which));
    end;

    trigger OnInit()
    begin
        RemoveAppButtonVisible := true;
    end;

    trigger OnOpenPage()
    begin
        CurrPage.LookupMode := not ShowApplied;
        RemoveAppButtonVisible := ShowApplied;
        Show;
    end;

    var
        RecordToShow: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        Apply: Codeunit "Item Jnl.-Post Line";
        ShowApplied: Boolean;
        ShowQuantity: Boolean;
        MaxToApply: Decimal;
        ApplQty: Decimal;
        Qty: Decimal;
        TotalApplied: Decimal;
        Text001: label 'Applied Entries';
        Text002: label 'Unapplied Entries';
        [InDataSet]
        RemoveAppButtonVisible: Boolean;


    procedure SetRecordToShow(var RecordToSet: Record "Item Ledger Entry";var ApplyCodeunit: Codeunit "Item Jnl.-Post Line";newShowApplied: Boolean)
    begin
        RecordToShow.Copy(RecordToSet);
        Apply := ApplyCodeunit;
        ShowApplied := newShowApplied;
    end;

    local procedure Show()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        Apprec: Record "Item Application Entry";
    begin
        with ItemLedgEntry do begin
          Get(RecordToShow."Entry No.");
          ShowQuantity := not (("Entry Type" in ["entry type"::Sale,"entry type"::Consumption,"entry type"::Output]) and Positive);

          MaxToApply := 0;
          if not ShowQuantity then
            MaxToApply := Quantity + Apprec.Returned("Entry No.");
        end;
        SetMyView(RecordToShow,ShowApplied,ShowQuantity,MaxToApply);
    end;

    local procedure SetMyView(ItemLedgEntry: Record "Item Ledger Entry";ShowApplied: Boolean;ShowQuantity: Boolean;MaxToApply: Decimal)
    begin
        InitView;
        case ShowQuantity of
          true:
            case ShowApplied of
              true:
                ShowQuantityApplied(ItemLedgEntry);
              false:
                begin
                  ShowQuantityOpen(ItemLedgEntry);
                  ShowCostOpen(ItemLedgEntry,MaxToApply);
                end;
            end;
          false:
            case ShowApplied of
              true:
                ShowCostApplied(ItemLedgEntry);
              false:
                ShowCostOpen(ItemLedgEntry,MaxToApply);
            end;
        end;

        if TempItemLedgEntry.FindSet then
          repeat
            Rec := TempItemLedgEntry;
            Insert;
          until TempItemLedgEntry.Next = 0;
    end;

    local procedure InitView()
    begin
        DeleteAll;
        TempItemLedgEntry.Reset;
        TempItemLedgEntry.DeleteAll;
    end;

    local procedure ShowQuantityApplied(ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        InitApplied;
        with ItemLedgEntry do
          if Positive then begin
            ItemApplnEntry.Reset;
            ItemApplnEntry.SetCurrentkey("Inbound Item Entry No.","Outbound Item Entry No.","Cost Application");
            ItemApplnEntry.SetRange("Inbound Item Entry No.","Entry No.");
            ItemApplnEntry.SetFilter("Outbound Item Entry No.",'<>%1&<>%2',"Entry No.",0);
            if ItemApplnEntry.Find('-') then
              repeat
                InsertTempEntry(ItemApplnEntry."Outbound Item Entry No.",ItemApplnEntry.Quantity,true);
              until ItemApplnEntry.Next = 0;
          end else begin
            ItemApplnEntry.Reset;
            ItemApplnEntry.SetCurrentkey("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
            ItemApplnEntry.SetRange("Outbound Item Entry No.","Entry No.");
            ItemApplnEntry.SetRange("Item Ledger Entry No.","Entry No.");
            if ItemApplnEntry.Find('-') then
              repeat
                InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.",-ItemApplnEntry.Quantity,true);
              until ItemApplnEntry.Next = 0;
          end;
    end;

    local procedure ShowQuantityOpen(ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry2: Record "Item Ledger Entry";
    begin
        with ItemLedgEntry do
          if "Remaining Quantity" <> 0 then begin
            ItemLedgEntry2.SetCurrentkey("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
            ItemLedgEntry2.SetRange("Item No.","Item No.");
            ItemLedgEntry2.SetRange("Location Code" ,"Location Code");
            ItemLedgEntry2.SetRange(Positive,not Positive);
            ItemLedgEntry2.SetRange(Open,true);
            if ItemLedgEntry2.Find('-') then
              repeat
                if (QuantityAvailable(ItemLedgEntry2) <> 0) and
                   not ItemApplnEntry.ExistsBetween("Entry No.",ItemLedgEntry2."Entry No.")
                then
                  InsertTempEntry(ItemLedgEntry2."Entry No.",0,true);
              until ItemLedgEntry2.Next = 0;
          end;
    end;

    local procedure ShowCostApplied(ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        InitApplied;
        with ItemLedgEntry do
          if Positive then begin
            ItemApplnEntry.Reset;
            ItemApplnEntry.SetCurrentkey("Inbound Item Entry No.","Outbound Item Entry No.","Cost Application");
            ItemApplnEntry.SetRange("Inbound Item Entry No.","Entry No.");
            ItemApplnEntry.SetFilter("Item Ledger Entry No.",'<>%1',"Entry No.");
            ItemApplnEntry.SetFilter("Outbound Item Entry No.",'<>%1',0);
            ItemApplnEntry.SetRange("Cost Application",true); // we want to show even average cost application
            if ItemApplnEntry.Find('-') then
              repeat
                InsertTempEntry(ItemApplnEntry."Outbound Item Entry No.",ItemApplnEntry.Quantity,false);
              until ItemApplnEntry.Next = 0;
          end else begin
            ItemApplnEntry.Reset;
            ItemApplnEntry.SetCurrentkey("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
            ItemApplnEntry.SetRange("Outbound Item Entry No.","Entry No.");
            ItemApplnEntry.SetFilter("Item Ledger Entry No.",'<>%1',"Entry No.");
            ItemApplnEntry.SetRange("Cost Application",true); // we want to show even average cost application
            if ItemApplnEntry.Find('-') then
              repeat
                InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.",-ItemApplnEntry.Quantity,false);
              until ItemApplnEntry.Next = 0;
          end;
    end;

    local procedure ShowCostOpen(ItemLedgEntry: Record "Item Ledger Entry";MaxToApply: Decimal)
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry2: Record "Item Ledger Entry";
    begin
        with ItemLedgEntry do begin
          ItemLedgEntry2.SetCurrentkey("Item No.",Positive,"Location Code","Variant Code");
          ItemLedgEntry2.SetRange("Item No.","Item No.");
          ItemLedgEntry2.SetRange("Location Code","Location Code");
          ItemLedgEntry2.SetRange(Positive,not Positive);
          ItemLedgEntry2.SetFilter("Shipped Qty. Not Returned",'<%1&>=%2',0,-MaxToApply);
          if (MaxToApply <> 0) and Positive then
            ItemLedgEntry2.SetFilter("Shipped Qty. Not Returned",'<=%1',-MaxToApply);
          if ItemLedgEntry2.Find('-') then
            repeat
              if (CostAvailable(ItemLedgEntry2) <> 0) and
                 not ItemApplnEntry.ExistsBetween("Entry No.",ItemLedgEntry2."Entry No.")
              then
                InsertTempEntry(ItemLedgEntry2."Entry No.",0,true);
            until ItemLedgEntry2.Next = 0;
        end;
    end;

    local procedure InsertTempEntry(EntryNo: Integer;AppliedQty: Decimal;ShowQuantity: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Get(EntryNo);

        if ShowQuantity then
          if AppliedQty * ItemLedgEntry.Quantity < 0 then
            exit;

        if not TempItemLedgEntry.Get(EntryNo) then begin
          TempItemLedgEntry.Reset;
          TempItemLedgEntry := ItemLedgEntry;
          TempItemLedgEntry.CalcFields("Reserved Quantity");
          TempItemLedgEntry.Quantity := AppliedQty;
          TempItemLedgEntry.Insert;
        end else begin
          TempItemLedgEntry.Quantity := TempItemLedgEntry.Quantity + AppliedQty;
          TempItemLedgEntry.Modify;
        end;

        TotalApplied := TotalApplied + AppliedQty;
    end;

    local procedure InitApplied()
    begin
        Clear(TotalApplied);
    end;

    local procedure RemoveApplications(Inbound: Integer;OutBound: Integer)
    var
        Application: Record "Item Application Entry";
    begin
        Application.SetCurrentkey("Inbound Item Entry No.","Outbound Item Entry No.");
        Application.SetRange("Inbound Item Entry No.",Inbound);
        Application.SetRange("Outbound Item Entry No.",OutBound);
        if Application.FindSet then
          repeat
            Apply.UnApply(Application);
            Apply.LogUnapply(Application);
          until Application.Next = 0;
    end;

    local procedure UnapplyRec()
    var
        Applyrec: Record "Item Ledger Entry";
        AppliedItemLedgEntry: Record "Item Ledger Entry";
    begin
        Applyrec.Get(RecordToShow."Entry No.");
        CurrPage.SetSelectionFilter(TempItemLedgEntry);
        if TempItemLedgEntry.FindSet then
          repeat
            AppliedItemLedgEntry.Get(TempItemLedgEntry."Entry No.");
            if AppliedItemLedgEntry."Entry No." <> 0 then begin
              if Applyrec.Positive then
                RemoveApplications(Applyrec."Entry No.",AppliedItemLedgEntry."Entry No.")
              else
                RemoveApplications(AppliedItemLedgEntry."Entry No.",Applyrec."Entry No.");
            end;
          until TempItemLedgEntry.Next = 0;

        BlockItem(Applyrec."Item No.");
        Show;
    end;


    procedure ApplyRec()
    var
        Applyrec: Record "Item Ledger Entry";
        AppliedItemLedgEntry: Record "Item Ledger Entry";
    begin
        Applyrec.Get(RecordToShow."Entry No.");
        CurrPage.SetSelectionFilter(TempItemLedgEntry);
        if TempItemLedgEntry.FindSet then
          repeat
            AppliedItemLedgEntry.Get(TempItemLedgEntry."Entry No.");
            if AppliedItemLedgEntry."Entry No." <> 0 then begin
              Apply.ReApply(Applyrec,AppliedItemLedgEntry."Entry No.");
              Apply.LogApply(Applyrec,AppliedItemLedgEntry);
            end;
          until TempItemLedgEntry.Next = 0;

        if Applyrec.Positive then
          RemoveDuplicateApplication(Applyrec."Entry No.");

        Show;
    end;

    local procedure RemoveDuplicateApplication(ItemLedgerEntryNo: Integer)
    var
        ItemApplicationEntry: Record "Item Application Entry";
    begin
        with ItemApplicationEntry do begin
          SetCurrentkey("Inbound Item Entry No.","Item Ledger Entry No.","Outbound Item Entry No.","Cost Application");
          SetRange("Inbound Item Entry No.",ItemLedgerEntryNo);
          SetRange("Item Ledger Entry No.",ItemLedgerEntryNo);
          SetFilter("Outbound Item Entry No.",'<>0');
          if not IsEmpty then begin
            SetRange("Outbound Item Entry No.",0);
            DeleteAll;
          end
        end;
    end;

    local procedure BlockItem(ItemNo: Code[20])
    var
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        if Item."Application Wksh. User ID" <> UpperCase(UserId) then
          Item.CheckBlockedByApplWorksheet;

        Item."Application Wksh. User ID" := UserId;
        Item.Modify(true);
    end;

    local procedure GetApplQty()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Get("Entry No.");
        ApplQty := Quantity;
        Qty := ItemLedgEntry.Quantity;
    end;

    local procedure QuantityAvailable(ILE: Record "Item Ledger Entry"): Decimal
    begin
        with ILE do begin
          CalcFields("Reserved Quantity");
          exit("Remaining Quantity" - "Reserved Quantity");
        end;
    end;

    local procedure CostAvailable(ILE: Record "Item Ledger Entry"): Decimal
    var
        Apprec: Record "Item Application Entry";
    begin
        with ILE do begin
          if "Shipped Qty. Not Returned" <> 0 then
            exit(-"Shipped Qty. Not Returned");

          exit("Remaining Quantity" + Apprec.Returned("Entry No."));
        end;
    end;

    local procedure CaptionExpr(): Text[250]
    begin
        if ShowApplied then
          exit(Text001);

        exit(Text002);
    end;
}

