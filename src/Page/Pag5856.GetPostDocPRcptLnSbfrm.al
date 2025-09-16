#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5856 "Get Post.Doc - P.RcptLn Sbfrm"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "Purch. Rcpt. Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    HideValue = DocumentNoHideValue;
                    Lookup = false;
                    StyleExpr = 'Strong';
                    ToolTip = 'Specifies the receipt number.';
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the items were expected.';
                }
                field("Pay-to Vendor No.";"Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor who invoiced the shipment.';
                    Visible = false;
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor that you bought the items from.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line type.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an item number that identifies the item or a general ledger account number for the general ledger account used when posting.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cross-reference number related to the item.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item.';
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this item is a nonstock item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies either the name of or a description of the item or general ledger account.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that explains why the item is returned.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the receipt line is registered.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code for the purchased items.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension value associated with the receipt.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension value associated with the receipt.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code for the item.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field("Qty. Rcd. Not Invoiced";"Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the returned item that has been posted as received but that has not yet been posted as invoiced.';
                }
                field(RemainingQty;RemainingQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remaining Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity from the posted document line that remains in inventory.';
                }
                field(CalcAppliedQty;CalcAppliedQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Applied Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity of the item in the line that has been used for outbound transactions.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the item (bottle or piece, for example).';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost, in $, of one unit of the item on the line.';
                    Visible = false;
                }
                field(RevUnitCostLCY;RevUnitCostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 2;
                    Caption = 'Reverse Unit Cost ($)';
                    ToolTip = 'Specifies the unit cost that will appear on the new document lines.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job number corresponding to the purchase document (quote, order, invoice, or credit memo).';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order that the purchase receipt originates from.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order line that the purchase receipt line originates from.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        ShowDocument;
                    end;
                }
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
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        ItemTrackingLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DocumentNoHideValue := false;
        DocumentNoOnFormat;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if not Visible then
          exit(false);

        if Find(Which) then begin
          PurchRcptLine := Rec;
          while true do begin
            ShowRec := IsShowRec(Rec);
            if ShowRec then
              exit(true);
            if Next(1) = 0 then begin
              Rec := PurchRcptLine;
              if Find(Which) then
                while true do begin
                  ShowRec := IsShowRec(Rec);
                  if ShowRec then
                    exit(true);
                  if Next(-1) = 0 then
                    exit(false);
                end;
            end;
          end;
        end;
        exit(false);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        RealSteps: Integer;
        NextSteps: Integer;
    begin
        if Steps = 0 then
          exit;

        PurchRcptLine := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          ShowRec := IsShowRec(Rec);
          if ShowRec then begin
            RealSteps := RealSteps + NextSteps;
            PurchRcptLine := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := PurchRcptLine;
        Find;
        exit(RealSteps);
    end;

    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        RemainingQty: Decimal;
        RevUnitCostLCY: Decimal;
        RevQtyFilter: Boolean;
        FillExactCostReverse: Boolean;
        Visible: Boolean;
        ShowRec: Boolean;
        [InDataSet]
        DocumentNoHideValue: Boolean;

    local procedure IsFirstDocLine(): Boolean
    var
        PurchRcptLine2: Record "Purch. Rcpt. Line";
        RemainingQty2: Decimal;
        RevUnitCostLCY2: Decimal;
    begin
        TempPurchRcptLine.Reset;
        TempPurchRcptLine.CopyFilters(Rec);
        TempPurchRcptLine.SetRange("Document No.","Document No.");
        if not TempPurchRcptLine.FindFirst then begin
          RemainingQty2 := RemainingQty;
          RevUnitCostLCY2 := RevUnitCostLCY;
          PurchRcptLine2.CopyFilters(Rec);
          PurchRcptLine2.SetRange("Document No.","Document No.");
          if not PurchRcptLine2.FindSet then
            exit(false);
          repeat
            ShowRec := IsShowRec(PurchRcptLine2);
            if ShowRec then begin
              TempPurchRcptLine := PurchRcptLine2;
              TempPurchRcptLine.Insert;
            end;
          until (PurchRcptLine2.Next = 0) or ShowRec;
          RemainingQty := RemainingQty2;
          RevUnitCostLCY := RevUnitCostLCY2;
        end;

        exit("Line No." = TempPurchRcptLine."Line No.");
    end;

    local procedure IsShowRec(PurchRcptLine2: Record "Purch. Rcpt. Line"): Boolean
    begin
        with PurchRcptLine2 do begin
          RemainingQty := 0;
          if RevQtyFilter and (Type = Type::" ") then
            exit("Attached to Line No." = 0);
          if Type <> Type::Item then
            exit(true);
          if ("Job No." <> '') or ("Prod. Order No." <> '') then
            exit(not RevQtyFilter);
          CalcReceivedPurchNotReturned(RemainingQty,RevUnitCostLCY,FillExactCostReverse);
          if not RevQtyFilter then
            exit(true);
          exit(RemainingQty > 0);
        end;
    end;

    local procedure CalcAppliedQty(): Decimal
    begin
        if (Type = Type::Item) and (Quantity - RemainingQty > 0) then
          exit(Quantity - RemainingQty);
        exit(0);
    end;


    procedure Initialize(NewRevQtyFilter: Boolean;NewFillExactCostReverse: Boolean;NewVisible: Boolean)
    begin
        RevQtyFilter := NewRevQtyFilter;
        FillExactCostReverse := NewFillExactCostReverse;
        Visible := NewVisible;

        if Visible then begin
          TempPurchRcptLine.Reset;
          TempPurchRcptLine.DeleteAll;
        end;
    end;


    procedure GetSelectedLine(var FromPurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        FromPurchRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromPurchRcptLine);
    end;

    local procedure ShowDocument()
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        if not PurchRcptHeader.Get("Document No.") then
          exit;
        Page.Run(Page::"Posted Purchase Receipt",PurchRcptHeader);
    end;

    local procedure ItemTrackingLines()
    var
        FromPurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        GetSelectedLine(FromPurchRcptLine);
        FromPurchRcptLine.ShowItemTrackingLines;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}

