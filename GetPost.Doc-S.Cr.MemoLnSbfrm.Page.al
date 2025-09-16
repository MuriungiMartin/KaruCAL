#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5854 "Get Post.Doc-S.Cr.MemoLn Sbfrm"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Cr.Memo Line";

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
                    ToolTip = 'Specifies the credit memo number.';
                }
                field("SalesCrMemoHeader.""Posting Date""";SalesCrMemoHeader."Posting Date")
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
                    ToolTip = 'Specifies the number of the customer who you paid for the items.';
                    Visible = false;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer associated with the credit memo.';
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
                    ToolTip = 'Specifies a general ledger account number or an item number that identifies the general ledger account or item specified when the line was posted.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cross-reference number for this item.';
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
                    ToolTip = 'Specifies a code that explains why the item was returned.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location in which the credit memo line was registered.';
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
                    ToolTip = 'Specifies the dimension value code associated with the credit memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the credit memo.';
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
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the item (bottle or piece, for example).';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit cost of the item on the line.';
                    Visible = false;
                }
                field(UnitPrice;UnitPrice)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = SalesCrMemoHeader."Currency Code";
                    AutoFormatType = 2;
                    Caption = 'Unit Price';
                    Visible = false;
                }
                field(LineAmount;LineAmount)
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = SalesCrMemoHeader."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Line Amount';
                    ToolTip = 'Specifies the amount on the line.';
                }
                field("SalesCrMemoHeader.""Currency Code""";SalesCrMemoHeader."Currency Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code';
                    Visible = false;
                }
                field("SalesCrMemoHeader.""Prices Including VAT""";SalesCrMemoHeader."Prices Including VAT")
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
                    ToolTip = 'Specifies that all amounts are totaled.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the credit memo line could have included a possible invoice discount calculation.';
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
                    ToolTip = 'Specifies the job number that the sales line is linked to.';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order that the sales credit memo originates from.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order line that the sales credit memo line originates from.';
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the sales credit memo line is applied from.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry this credit memo was applied to.';
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
        if Find(Which) then begin
          SalesCrMemoLine := Rec;
          while true do begin
            ShowRec := IsShowRec(Rec);
            if ShowRec then
              exit(true);
            if Next(1) = 0 then begin
              Rec := SalesCrMemoLine;
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

        SalesCrMemoLine := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          ShowRec := IsShowRec(Rec);
          if ShowRec then begin
            RealSteps := RealSteps + NextSteps;
            SalesCrMemoLine := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := SalesCrMemoLine;
        Find;
        exit(RealSteps);
    end;

    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TempSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
        UnitPrice: Decimal;
        LineAmount: Decimal;
        [InDataSet]
        DocumentNoHideValue: Boolean;
        ShowRec: Boolean;

    local procedure IsFirstDocLine(): Boolean
    begin
        TempSalesCrMemoLine.Reset;
        TempSalesCrMemoLine.CopyFilters(Rec);
        TempSalesCrMemoLine.SetRange("Document No.","Document No.");
        if not TempSalesCrMemoLine.FindFirst then begin
          SalesCrMemoLine.CopyFilters(Rec);
          SalesCrMemoLine.SetRange("Document No.","Document No.");
          if not SalesCrMemoLine.FindFirst then
            exit(false);
          TempSalesCrMemoLine := SalesCrMemoLine;
          TempSalesCrMemoLine.Insert;
        end;

        if "Document No." <> SalesCrMemoHeader."No." then
          SalesCrMemoHeader.Get("Document No.");

        UnitPrice := "Unit Price";
        LineAmount := "Line Amount";

        exit("Line No." = TempSalesCrMemoLine."Line No.");
    end;

    local procedure IsShowRec(SalesCrMemoLine2: Record "Sales Cr.Memo Line"): Boolean
    begin
        with SalesCrMemoLine2 do begin
          if "Document No." <> SalesCrMemoHeader."No." then
            SalesCrMemoHeader.Get("Document No.");
          if SalesCrMemoHeader."Prepayment Credit Memo" then
            exit(false);
          if Type <> Type::Item then
            exit(true);
        end;
    end;


    procedure GetSelectedLine(var FromSalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        FromSalesCrMemoLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromSalesCrMemoLine);
    end;

    local procedure ShowDocument()
    begin
        if not SalesCrMemoHeader.Get("Document No.") then
          exit;
        Page.Run(Page::"Posted Sales Credit Memo",SalesCrMemoHeader);
    end;

    local procedure ItemTrackingLines()
    var
        FromSalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        GetSelectedLine(FromSalesCrMemoLine);
        FromSalesCrMemoLine.ShowItemTrackingLines;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}

