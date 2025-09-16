#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5806 "Purch. Receipt Lines"
{
    Caption = 'Purch. Receipt Lines';
    Editable = false;
    PageType = List;
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
                    StyleExpr = 'Strong';
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
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
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Order Line No.";"Order Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
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
                action("Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PurchRcptHeader: Record "Purch. Rcpt. Header";
                    begin
                        PurchRcptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Purchase Receipt",PurchRcptHeader);
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
                        CurrPage.SaveRecord;
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
                        ShowItemTrackingLines;
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

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        SetRange(Type,Type::Item);
        SetFilter(Quantity,'<>0');
        SetRange(Correction,false);
        FilterGroup(0);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          LookupOKOnPush;
    end;

    var
        FromPurchRcptLine: Record "Purch. Rcpt. Line";
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        UnitCost: Decimal;
        [InDataSet]
        DocumentNoHideValue: Boolean;


    procedure Initialize(NewItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";NewUnitCost: Decimal)
    begin
        ItemChargeAssgntPurch := NewItemChargeAssgntPurch;
        UnitCost := NewUnitCost;
    end;

    local procedure IsFirstDocLine(): Boolean
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        TempPurchRcptLine.Reset;
        TempPurchRcptLine.CopyFilters(Rec);
        TempPurchRcptLine.SetRange("Document No.","Document No.");
        if not TempPurchRcptLine.FindFirst then begin
          FilterGroup(2);
          PurchRcptLine.CopyFilters(Rec);
          FilterGroup(0);
          PurchRcptLine.SetRange("Document No.","Document No.");
          if not PurchRcptLine.FindFirst then
            exit(false);
          TempPurchRcptLine := PurchRcptLine;
          TempPurchRcptLine.Insert;
        end;
        if "Line No." = TempPurchRcptLine."Line No." then
          exit(true);
    end;

    local procedure LookupOKOnPush()
    begin
        FromPurchRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromPurchRcptLine);
        if FromPurchRcptLine.FindFirst then begin
          ItemChargeAssgntPurch."Unit Cost" := UnitCost;
          AssignItemChargePurch.CreateRcptChargeAssgnt(FromPurchRcptLine,ItemChargeAssgntPurch);
        end;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}

