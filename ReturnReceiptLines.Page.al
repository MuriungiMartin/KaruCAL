#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6667 "Return Receipt Lines"
{
    Caption = 'Return Receipt Lines';
    Editable = false;
    PageType = List;
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
                    StyleExpr = 'Strong';
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
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
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
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
                        ReturnRcptHeader: Record "Return Receipt Header";
                    begin
                        ReturnRcptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Return Receipt",ReturnRcptHeader);
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
        if AssignmentType = Assignmenttype::Sale then
          SetRange("Sell-to Customer No.",SellToCustomerNo);
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
        FromReturnRcptLine: Record "Return Receipt Line";
        TempReturnRcptLine: Record "Return Receipt Line" temporary;
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
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
        ReturnRcptLine: Record "Return Receipt Line";
    begin
        TempReturnRcptLine.Reset;
        TempReturnRcptLine.CopyFilters(Rec);
        TempReturnRcptLine.SetRange("Document No.",DocNo);
        if not TempReturnRcptLine.FindFirst then begin
          ReturnRcptLine.CopyFilters(Rec);
          ReturnRcptLine.SetRange("Document No.",DocNo);
          ReturnRcptLine.FindFirst;
          TempReturnRcptLine := ReturnRcptLine;
          TempReturnRcptLine.Insert;
        end;
        if TempReturnRcptLine."Line No." = LineNo then
          exit(true);
    end;

    local procedure LookupOKOnPush()
    begin
        FromReturnRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromReturnRcptLine);
        if FromReturnRcptLine.FindFirst then
          // CETAF start
          if AssignmentType = Assignmenttype::Sale then begin
            ItemChargeAssgntSales."Unit Cost" := UnitCost;
            AssignItemChargeSales.CreateRcptChargeAssgnt(FromReturnRcptLine,ItemChargeAssgntSales);
          end else
            if AssignmentType = Assignmenttype::Purchase then begin
              ItemChargeAssgntPurch."Unit Cost" := UnitCost;
              AssignItemChargePurch.CreateReturnRcptChargeAssgnt(FromReturnRcptLine,ItemChargeAssgntPurch);
            end;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstLine("Document No.","Line No.") then
          DocumentNoHideValue := true;
    end;
}

