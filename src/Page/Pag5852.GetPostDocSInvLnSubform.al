#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5852 "Get Post.Doc - S.InvLn Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = DocumentNoHideValue;
                    Lookup = false;
                    StyleExpr = 'Strong';
                    ToolTip = 'Specifies the invoice number.';
                }
                field("SalesInvHeader.""Posting Date""";SalesInvHeader."Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date of the record.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the date for this field from the Shipment Date field on the sales line, which is used for planning purposes.';
                    Visible = false;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who paid you for the items.';
                    Visible = false;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer the invoice was sent to.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the line type.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cross-reference number of the item specified on the line.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the items sold.';
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that this item is a nonstock item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the item or general ledger account, or some descriptive text.';
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
                    ToolTip = 'Specifies the location in which the invoice line was registered.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin from which the items were sold.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the invoice.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the invoice.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code for the items sold.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field(QtyNotReturned;QtyNotReturned)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Qty. Not Returned';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity from the posted document line that has been shipped to the customer and not returned by the customer.';
                }
                field(CalcQtyReturned;CalcQtyReturned)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Qty. Returned';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the quantity that was returned.';
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
                    ToolTip = 'Specifies the unit cost of the item on the invoice line.';
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
                field(UnitPrice;UnitPrice)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = SalesInvHeader."Currency Code";
                    AutoFormatType = 2;
                    Caption = 'Unit Price';
                    Visible = false;
                }
                field(LineAmount;LineAmount)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = SalesInvHeader."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Line Amount';
                    ToolTip = 'Specifies the amount on the line.';
                }
                field("SalesInvHeader.""Currency Code""";SalesInvHeader."Currency Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code';
                    Visible = false;
                }
                field("SalesInvHeader.""Prices Including VAT""";SalesInvHeader."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices Including Tax';
                    Visible = false;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the line discount % that was given on the line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of the discount given on the line.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the invoice line could have been included in a possible invoice discount calculation.';
                    Visible = false;
                }
                field("Inv. Discount Amount";"Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice discount amount calculated on the line.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job number that the sales invoice line is linked to.';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order that the invoice originates from.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order line that the invoice line originates from.';
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the sales invoice line is applied from.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry this invoice line was applied to.';
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
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction()
                    begin
                        ShowDocument;
                    end;
                }
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
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';

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
          SalesInvLine := Rec;
          while true do begin
            ShowRec := IsShowRec(Rec);
            if ShowRec then
              exit(true);
            if Next(1) = 0 then begin
              Rec := SalesInvLine;
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

        SalesInvLine := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          ShowRec := IsShowRec(Rec);
          if ShowRec then begin
            RealSteps := RealSteps + NextSteps;
            SalesInvLine := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := SalesInvLine;
        Find;
        exit(RealSteps);
    end;

    var
        ToSalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        TempSalesInvLine: Record "Sales Invoice Line" temporary;
        QtyNotReturned: Decimal;
        RevUnitCostLCY: Decimal;
        UnitPrice: Decimal;
        LineAmount: Decimal;
        RevQtyFilter: Boolean;
        FillExactCostReverse: Boolean;
        Visible: Boolean;
        ShowRec: Boolean;
        [InDataSet]
        DocumentNoHideValue: Boolean;

    local procedure IsFirstDocLine(): Boolean
    var
        SalesInvHeader2: Record "Sales Invoice Header";
        SalesInvLine2: Record "Sales Invoice Line";
        QtyNotReturned2: Decimal;
        RevUnitCostLCY2: Decimal;
    begin
        TempSalesInvLine.Reset;
        TempSalesInvLine.CopyFilters(Rec);
        TempSalesInvLine.SetRange("Document No.","Document No.");
        if not TempSalesInvLine.FindFirst then begin
          SalesInvHeader2 := SalesInvHeader;
          QtyNotReturned2 := QtyNotReturned;
          RevUnitCostLCY2 := RevUnitCostLCY;
          SalesInvLine2.CopyFilters(Rec);
          SalesInvLine2.SetRange("Document No.","Document No.");
          if not SalesInvLine2.FindSet then
            exit(false);
          repeat
            ShowRec := IsShowRec(SalesInvLine2);
            if ShowRec then begin
              TempSalesInvLine := SalesInvLine2;
              TempSalesInvLine.Insert;
            end;
          until (SalesInvLine2.Next = 0) or ShowRec;
          SalesInvHeader := SalesInvHeader2;
          QtyNotReturned := QtyNotReturned2;
          RevUnitCostLCY := RevUnitCostLCY2;
        end;

        if "Document No." <> SalesInvHeader."No." then
          SalesInvHeader.Get("Document No.");

        UnitPrice := "Unit Price";
        LineAmount := "Line Amount";

        exit("Line No." = TempSalesInvLine."Line No.");
    end;

    local procedure IsShowRec(SalesInvLine2: Record "Sales Invoice Line"): Boolean
    begin
        with SalesInvLine2 do begin
          QtyNotReturned := 0;
          if "Document No." <> SalesInvHeader."No." then
            SalesInvHeader.Get("Document No.");
          if SalesInvHeader."Prepayment Invoice" then
            exit(false);
          if RevQtyFilter then begin
            if SalesInvHeader."Currency Code" <> ToSalesHeader."Currency Code" then
              exit(false);
            if Type = Type::" " then
              exit("Attached to Line No." = 0);
          end;
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


    procedure Initialize(NewToSalesHeader: Record "Sales Header";NewRevQtyFilter: Boolean;NewFillExactCostReverse: Boolean;NewVisible: Boolean)
    begin
        ToSalesHeader := NewToSalesHeader;
        RevQtyFilter := NewRevQtyFilter;
        FillExactCostReverse := NewFillExactCostReverse;
        Visible := NewVisible;

        if Visible then begin
          TempSalesInvLine.Reset;
          TempSalesInvLine.DeleteAll;
        end;
    end;


    procedure GetSelectedLine(var FromSalesInvLine: Record "Sales Invoice Line")
    begin
        FromSalesInvLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromSalesInvLine);
    end;

    local procedure ShowDocument()
    begin
        if not SalesInvHeader.Get("Document No.") then
          exit;
        Page.Run(Page::"Posted Sales Invoice",SalesInvHeader);
    end;

    local procedure ItemTrackingLines()
    var
        FromSalesInvLine: Record "Sales Invoice Line";
    begin
        GetSelectedLine(FromSalesInvLine);
        FromSalesInvLine.ShowItemTrackingLines;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}

