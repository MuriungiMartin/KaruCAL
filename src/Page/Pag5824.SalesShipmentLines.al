#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5824 "Sales Shipment Lines"
{
    Caption = 'Sales Shipment Lines';
    Editable = false;
    PageType = List;
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
                    StyleExpr = 'Strong';
                    ToolTip = 'Specifies the shipment number.';
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer the items were shipped to.';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer the invoice for the shipment was sent to.';
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
                    ToolTip = 'Specifies the general ledger account or item number that identifies the general ledger account or item specified on the line.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the items sold.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the item or general ledger account, or some descriptive text.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the sales line.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the sales line.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location of the item on the shipment line which was posted.';
                    Visible = true;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code for the items sold.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the item (bottle or piece, for example).';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the items were applied to when the shipment was posted.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job number corresponding to the sales invoice or credit memo.';
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the items were shipped.';
                    Visible = false;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how much of the line has been invoiced.';
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
                        SalesShptHeader: Record "Sales Shipment Header";
                    begin
                        SalesShptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Sales Shipment",SalesShptHeader);
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
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DocumentNoHideValue := false;
        DocumentNoOnFormat;
    end;

    trigger OnOpenPage()
    begin
        if AssignmentType = Assignmenttype::Sale then begin
          SetCurrentkey("Sell-to Customer No.");
          SetRange("Sell-to Customer No.",SellToCustomerNo);
        end;
        FilterGroup(2);
        SetRange(Type,Type::Item);
        SetFilter(Quantity,'<>0');
        SetRange(Correction,false);
        SetRange("Job No.",'');
        FilterGroup(0);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          LookupOKOnPush;
    end;

    var
        FromSalesShptLine: Record "Sales Shipment Line";
        TempSalesShptLine: Record "Sales Shipment Line" temporary;
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
        SellToCustomerNo: Code[20];
        UnitCost: Decimal;
        AssignmentType: Option Sale,Purchase;
        [InDataSet]
        DocumentNoHideValue: Boolean;


    procedure InitializeSales(NewItemChargeAssgnt: Record "Item Charge Assignment (Sales)";NewSellToCustomerNo: Code[20];NewUnitCost: Decimal)
    begin
        ItemChargeAssgntSales := NewItemChargeAssgnt;
        SellToCustomerNo := NewSellToCustomerNo;
        UnitCost := NewUnitCost;
        AssignmentType := Assignmenttype::Sale;
    end;


    procedure InitializePurchase(NewItemChargeAssgnt: Record "Item Charge Assignment (Purch)";NewUnitCost: Decimal)
    begin
        ItemChargeAssgntPurch := NewItemChargeAssgnt;
        UnitCost := NewUnitCost;
        AssignmentType := Assignmenttype::Purchase;
    end;

    local procedure IsFirstLine(DocNo: Code[20];LineNo: Integer): Boolean
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin
        TempSalesShptLine.Reset;
        TempSalesShptLine.CopyFilters(Rec);
        TempSalesShptLine.SetRange("Document No.",DocNo);
        if not TempSalesShptLine.FindFirst then begin
          SalesShptLine.CopyFilters(Rec);
          SalesShptLine.SetRange("Document No.",DocNo);
          if SalesShptLine.FindFirst then begin
            TempSalesShptLine := SalesShptLine;
            TempSalesShptLine.Insert;
          end;
        end;
        if TempSalesShptLine."Line No." = LineNo then
          exit(true);
    end;

    local procedure LookupOKOnPush()
    begin
        FromSalesShptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromSalesShptLine);
        if FromSalesShptLine.FindFirst then
          if AssignmentType = Assignmenttype::Sale then begin
            ItemChargeAssgntSales."Unit Cost" := UnitCost;
            AssignItemChargeSales.CreateShptChargeAssgnt(FromSalesShptLine,ItemChargeAssgntSales);
          end else
            if AssignmentType = Assignmenttype::Purchase then begin
              ItemChargeAssgntPurch."Unit Cost" := UnitCost;
              AssignItemChargePurch.CreateSalesShptChargeAssgnt(FromSalesShptLine,ItemChargeAssgntPurch);
            end;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstLine("Document No.","Line No.") then
          DocumentNoHideValue := true;
    end;
}

