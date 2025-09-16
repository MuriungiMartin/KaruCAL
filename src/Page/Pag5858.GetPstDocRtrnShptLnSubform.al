#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5858 "Get Pst.Doc-RtrnShptLn Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Return Shipment Line";

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
                    ToolTip = 'Specifies the number of the return shipment.';
                }
                field("Pay-to Vendor No.";"Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor that the items are returned to.';
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
                    ToolTip = 'Specifies a number that identifies the item, general ledger account, fixed asset, or item charge for the purchase line.';
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
                    ToolTip = 'Specifies either the name of, or a description of, the item, general ledger account, or item charge.';
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
                    ToolTip = 'Specifies the code for the location where items on the line are placed.';
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
                    ToolTip = 'Specifies the unit of measure code for the item.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item, general ledger account, or item charge specified on the line.';
                }
                field("Return Qty. Shipped Not Invd.";"Return Qty. Shipped Not Invd.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the returned item that has been posted as shipped but that has not yet been posted as invoiced.';
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
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job number corresponding to the purchase document (quote, order, invoice, or credit memo).';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the blanket order from which this return shipment line originates.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number of the blanket order line from which this return shipment line originates.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the items were applied to when the return shipment was posted.';
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
        ReturnShptLine: Record "Return Shipment Line";
        TempReturnShptLine: Record "Return Shipment Line" temporary;
        [InDataSet]
        DocumentNoHideValue: Boolean;

    local procedure IsFirstDocLine(): Boolean
    begin
        TempReturnShptLine.Reset;
        TempReturnShptLine.CopyFilters(Rec);
        TempReturnShptLine.SetRange("Document No.","Document No.");
        if not TempReturnShptLine.FindFirst then begin
          ReturnShptLine.CopyFilters(Rec);
          ReturnShptLine.SetRange("Document No.","Document No.");
          if not ReturnShptLine.FindFirst then
            exit(false);
          TempReturnShptLine := ReturnShptLine;
          TempReturnShptLine.Insert;
        end;

        exit("Line No." = TempReturnShptLine."Line No.");
    end;


    procedure GetSelectedLine(var FromReturnShptLine: Record "Return Shipment Line")
    begin
        FromReturnShptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromReturnShptLine);
    end;

    local procedure ShowDocument()
    var
        ReturnShptHeader: Record "Return Shipment Header";
    begin
        if not ReturnShptHeader.Get("Document No.") then
          exit;
        Page.Run(Page::"Posted Return Shipment",ReturnShptHeader);
    end;

    local procedure ItemTrackingLines()
    var
        FromReturnShptLine: Record "Return Shipment Line";
    begin
        GetSelectedLine(FromReturnShptLine);
        FromReturnShptLine.ShowItemTrackingLines;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}

