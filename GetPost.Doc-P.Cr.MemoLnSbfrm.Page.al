#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5859 "Get Post.Doc-P.Cr.MemoLn Sbfrm"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Purch. Cr. Memo Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Suite;
                    HideValue = DocumentNoHideValue;
                    Lookup = false;
                    StyleExpr = 'Strong';
                    ToolTip = 'Specifies the credit memo number.';
                }
                field("PurchCrMemoHeader.""Posting Date""";PurchCrMemoHeader."Posting Date")
                {
                    ApplicationArea = Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date of the record.';
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the items were received.';
                    Visible = false;
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor that you bought the items on the credit memo from.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the line type.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies an item number that identifies the account number that identifies the general ledger account used when posting the line.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
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
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that this item is a nonstock item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies either the name of, or a description of, the item or general ledger account.';
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
                    ToolTip = 'Specifies the code for the location where the credit memo line is registered.';
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
                    ToolTip = 'Specifies the code for the dimension value associated with the credit memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension value associated with the credit memo.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure code for the item.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of units of the item specified on the credit memo line.';
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
                field(DirectUnitCost;DirectUnitCost)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = PurchCrMemoHeader."Currency Code";
                    AutoFormatType = 2;
                    Caption = 'Direct Unit Cost';
                    Visible = false;
                }
                field(LineAmount;LineAmount)
                {
                    ApplicationArea = Suite;
                    AutoFormatExpression = PurchCrMemoHeader."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Line Amount';
                    ToolTip = 'Specifies the amount on the line.';
                }
                field("PurchCrMemoHeader.""Currency Code""";PurchCrMemoHeader."Currency Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code';
                    Visible = false;
                }
                field("PurchCrMemoHeader.""Prices Including VAT""";PurchCrMemoHeader."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices Including Tax';
                    Visible = false;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the line discount % granted on items on each individual line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount amount that was granted on the line.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the credit memo line could have been included in an invoice discount calculation.';
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
                    ToolTip = 'Specifies the job number the purchase invoice line is linked to.';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order that the purchase credit memo originates from.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order line that the purchase credit memo line originates from.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of a particular item entry to which the credit memo was applied.';
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
                    ApplicationArea = Suite;
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
                        Dimensions;
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
          PurchCrMemoLine := Rec;
          while true do begin
            ShowRec := IsShowRec(Rec);
            if ShowRec then
              exit(true);
            if Next(1) = 0 then begin
              Rec := PurchCrMemoLine;
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

        PurchCrMemoLine := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          ShowRec := IsShowRec(Rec);
          if ShowRec then begin
            RealSteps := RealSteps + NextSteps;
            PurchCrMemoLine := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := PurchCrMemoLine;
        Find;
        exit(RealSteps);
    end;

    var
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        TempPurchCrMemoLine: Record "Purch. Cr. Memo Line" temporary;
        DirectUnitCost: Decimal;
        LineAmount: Decimal;
        [InDataSet]
        DocumentNoHideValue: Boolean;
        ShowRec: Boolean;

    local procedure IsFirstDocLine(): Boolean
    begin
        TempPurchCrMemoLine.Reset;
        TempPurchCrMemoLine.CopyFilters(Rec);
        TempPurchCrMemoLine.SetRange("Document No.","Document No.");
        if not TempPurchCrMemoLine.FindFirst then begin
          PurchCrMemoLine.CopyFilters(Rec);
          PurchCrMemoLine.SetRange("Document No.","Document No.");
          if not PurchCrMemoLine.FindFirst then
            exit(false);
          TempPurchCrMemoLine := PurchCrMemoLine;
          TempPurchCrMemoLine.Insert;
        end;

        if "Document No." <> PurchCrMemoHeader."No." then
          PurchCrMemoHeader.Get("Document No.");

        DirectUnitCost := "Direct Unit Cost";
        LineAmount := "Line Amount";

        exit("Line No." = TempPurchCrMemoLine."Line No.");
    end;

    local procedure IsShowRec(PurchCrMemoLine2: Record "Purch. Cr. Memo Line"): Boolean
    begin
        with PurchCrMemoLine2 do begin
          if "Document No." <> PurchCrMemoHeader."No." then
            PurchCrMemoHeader.Get("Document No.");
          if PurchCrMemoHeader."Prepayment Credit Memo" then
            exit(false);
          if Type <> Type::Item then
            exit(true);
        end;
    end;


    procedure GetSelectedLine(var FromPurchCrMemoLine: Record "Purch. Cr. Memo Line")
    begin
        FromPurchCrMemoLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromPurchCrMemoLine);
    end;

    local procedure ShowDocument()
    begin
        if not PurchCrMemoHeader.Get("Document No.") then
          exit;
        Page.Run(Page::"Posted Purchase Credit Memo",PurchCrMemoHeader);
    end;

    local procedure Dimensions()
    var
        FromPurchCrMemoLine: Record "Purch. Cr. Memo Line";
    begin
        GetSelectedLine(FromPurchCrMemoLine);
        FromPurchCrMemoLine.ShowDimensions;
    end;

    local procedure ItemTrackingLines()
    var
        FromPurchCrMemoLine: Record "Purch. Cr. Memo Line";
    begin
        GetSelectedLine(FromPurchCrMemoLine);
        FromPurchCrMemoLine.ShowItemTrackingLines;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}

