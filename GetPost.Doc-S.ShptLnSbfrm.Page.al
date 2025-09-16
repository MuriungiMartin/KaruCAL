#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5851 "Get Post.Doc - S.ShptLn Sbfrm"
{
    Caption = 'Lines';
    Editable = false;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "Sales Shipment Line";

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
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Qty. Shipped Not Invoiced";"Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field(QtyNotReturned;QtyNotReturned)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. Not Returned';
                    DecimalPlaces = 0:5;
                }
                field(CalcQtyReturned;CalcQtyReturned)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. Returned';
                    DecimalPlaces = 0:5;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RevUnitCostLCY;RevUnitCostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 2;
                    Caption = 'Reverse Unit Cost ($)';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
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
                action(ShowDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        ShowPostedShipment;
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
                action(ItemTrackingLines)
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
          SalesShptLine := Rec;
          while true do begin
            ShowRec := IsShowRec(Rec);
            if ShowRec then
              exit(true);
            if Next(1) = 0 then begin
              Rec := SalesShptLine;
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

        SalesShptLine := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          ShowRec := IsShowRec(Rec);
          if ShowRec then begin
            RealSteps := RealSteps + NextSteps;
            SalesShptLine := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := SalesShptLine;
        Find;
        exit(RealSteps);
    end;

    var
        SalesShptLine: Record "Sales Shipment Line";
        TempSalesShptLine: Record "Sales Shipment Line" temporary;
        QtyNotReturned: Decimal;
        RevUnitCostLCY: Decimal;
        RevQtyFilter: Boolean;
        FillExactCostReverse: Boolean;
        Visible: Boolean;
        ShowRec: Boolean;
        [InDataSet]
        DocumentNoHideValue: Boolean;

    local procedure IsFirstDocLine(): Boolean
    var
        SalesShptLine2: Record "Sales Shipment Line";
        QtyNotReturned2: Decimal;
        RevUnitCostLCY2: Decimal;
    begin
        TempSalesShptLine.Reset;
        TempSalesShptLine.CopyFilters(Rec);
        TempSalesShptLine.SetRange("Document No.","Document No.");
        if not TempSalesShptLine.FindFirst then begin
          QtyNotReturned2 := QtyNotReturned;
          RevUnitCostLCY2 := RevUnitCostLCY;
          SalesShptLine2.CopyFilters(Rec);
          SalesShptLine2.SetRange("Document No.","Document No.");
          if not SalesShptLine2.FindSet then
            exit(false);
          repeat
            ShowRec := IsShowRec(SalesShptLine2);
            if ShowRec then begin
              TempSalesShptLine := SalesShptLine2;
              TempSalesShptLine.Insert;
            end;
          until (SalesShptLine2.Next = 0) or ShowRec;
          QtyNotReturned := QtyNotReturned2;
          RevUnitCostLCY := RevUnitCostLCY2;
        end;

        exit("Line No." = TempSalesShptLine."Line No.");
    end;

    local procedure IsShowRec(SalesShptLine2: Record "Sales Shipment Line"): Boolean
    begin
        with SalesShptLine2 do begin
          QtyNotReturned := 0;
          if RevQtyFilter and (Type = Type::" ") then
            exit("Attached to Line No." = 0);
          if Type <> Type::Item then
            exit(true);
          CalcShippedSaleNotReturned(QtyNotReturned,RevUnitCostLCY,FillExactCostReverse);
          if not RevQtyFilter then
            exit(true);
          exit(QtyNotReturned > 0);
        end;
    end;

    local procedure CalcQtyReturned(): Decimal
    begin
        if (Type = Type::Item) and (Quantity - QtyNotReturned > 0) then
          exit(Quantity - QtyNotReturned);
        exit(0);
    end;


    procedure Initialize(NewRevQtyFilter: Boolean;NewFillExactCostReverse: Boolean;NewVisible: Boolean)
    begin
        RevQtyFilter := NewRevQtyFilter;
        FillExactCostReverse := NewFillExactCostReverse;
        Visible := NewVisible;

        if Visible then begin
          TempSalesShptLine.Reset;
          TempSalesShptLine.DeleteAll;
        end;
    end;


    procedure GetSelectedLine(var FromSalesShptLine: Record "Sales Shipment Line")
    begin
        FromSalesShptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromSalesShptLine);
    end;

    local procedure ShowPostedShipment()
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        if not SalesShptHeader.Get("Document No.") then
          exit;
        Page.Run(Page::"Posted Sales Shipment",SalesShptHeader);
    end;

    local procedure ItemTrackingLines()
    var
        FromSalesShptLine: Record "Sales Shipment Line";
    begin
        GetSelectedLine(FromSalesShptLine);
        FromSalesShptLine.ShowItemTrackingLines;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}

