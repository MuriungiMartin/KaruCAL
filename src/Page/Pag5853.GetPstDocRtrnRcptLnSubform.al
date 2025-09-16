#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5853 "Get Pst.Doc-RtrnRcptLn Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Return Receipt Line";

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
                    ToolTip = 'Specifies the number of the return receipt.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the item(s) on the sales return are received.';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer you sent the original invoice to.';
                    Visible = false;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who returned the items to you.';
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
                    ToolTip = 'Specifies the number of the return receipt line.';
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
                    ToolTip = 'Specifies the variant number of the returned items.';
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
                    ToolTip = 'Specifies either the name of, or the description of, the item, general ledger account, or item charge.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that explains why the item is returned.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the currency code for the amount on this line.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location in which the return receipt line was registered.';
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
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 2.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code for the items sold.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item, general ledger account, or item charge specified on the line.';
                }
                field("Return Qty. Rcd. Not Invd.";"Return Qty. Rcd. Not Invd.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity from the line that has been posted as received but that has not yet been posted as invoiced.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure used for the item (bottle or piece, for example).';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies your cost in local currency of one unit of the item.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job number corresponding to the sales invoice or credit memo.';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the blanket order that the return receipt originates from.';
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
                    ToolTip = 'Specifies the number of the item ledger entry that the return receipt line is applied from.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the items were applied to when the return receipt was posted.';
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
                    ToolTip = 'Open the document that the selected line exists on.';

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

    var
        ReturnRcptLine: Record "Return Receipt Line";
        TempReturnRcptLine: Record "Return Receipt Line" temporary;
        [InDataSet]
        DocumentNoHideValue: Boolean;

    local procedure IsFirstDocLine(): Boolean
    begin
        TempReturnRcptLine.Reset;
        TempReturnRcptLine.CopyFilters(Rec);
        TempReturnRcptLine.SetRange("Document No.","Document No.");
        if not TempReturnRcptLine.FindFirst then begin
          ReturnRcptLine.CopyFilters(Rec);
          ReturnRcptLine.SetRange("Document No.","Document No.");
          if not ReturnRcptLine.FindFirst then
            exit(false);
          TempReturnRcptLine := ReturnRcptLine;
          TempReturnRcptLine.Insert;
        end;

        exit("Line No." = TempReturnRcptLine."Line No.");
    end;


    procedure GetSelectedLine(var FromReturnRcptLine: Record "Return Receipt Line")
    begin
        FromReturnRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromReturnRcptLine);
    end;

    local procedure ShowDocument()
    var
        ReturnRcptHeader: Record "Return Receipt Header";
    begin
        if not ReturnRcptHeader.Get("Document No.") then
          exit;
        Page.Run(Page::"Posted Return Receipt",ReturnRcptHeader);
    end;

    local procedure ItemTrackingLines()
    var
        FromReturnRcptLine: Record "Return Receipt Line";
    begin
        GetSelectedLine(FromReturnRcptLine);
        FromReturnRcptLine.ShowItemTrackingLines;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}

