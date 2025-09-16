#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5759 "Posted Transfer Receipt Lines"
{
    Caption = 'Posted Transfer Receipt Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Receipt Line";

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
                    ToolTip = 'Specifies the document number associated with this transfer line.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that you want to transfer.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item being transferred.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item specified on the line.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item.';
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the receipt date of the transfer receipt line.';
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
                        TransRcptHeader: Record "Transfer Receipt Header";
                    begin
                        TransRcptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Transfer Receipt",TransRcptHeader);
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

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          LookupOKOnPush;
    end;

    var
        FromTransRcptLine: Record "Transfer Receipt Line";
        TempTransRcptLine: Record "Transfer Receipt Line" temporary;
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        UnitCost: Decimal;
        CreateCostDistrib: Boolean;
        [InDataSet]
        DocumentNoHideValue: Boolean;


    procedure Initialize(NewItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";NewUnitCost: Decimal)
    begin
        ItemChargeAssgntPurch := NewItemChargeAssgntPurch;
        UnitCost := NewUnitCost;
        CreateCostDistrib := true;
    end;

    local procedure IsFirstLine(DocNo: Code[20];LineNo: Integer): Boolean
    var
        TransRcptLine: Record "Transfer Receipt Line";
    begin
        TempTransRcptLine.Reset;
        TempTransRcptLine.CopyFilters(Rec);
        TempTransRcptLine.SetRange("Document No.",DocNo);
        if not TempTransRcptLine.FindFirst then begin
          TransRcptLine.CopyFilters(Rec);
          TransRcptLine.SetRange("Document No.",DocNo);
          TransRcptLine.FindFirst;
          TempTransRcptLine := TransRcptLine;
          TempTransRcptLine.Insert;
        end;
        if TempTransRcptLine."Line No." = LineNo then
          exit(true);
    end;

    local procedure LookupOKOnPush()
    begin
        if CreateCostDistrib then begin
          FromTransRcptLine.Copy(Rec);
          CurrPage.SetSelectionFilter(FromTransRcptLine);
          if FromTransRcptLine.FindFirst then begin
            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
            AssignItemChargePurch.CreateTransferRcptChargeAssgnt(FromTransRcptLine,ItemChargeAssgntPurch);
          end;
        end;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstLine("Document No.","Line No.") then
          DocumentNoHideValue := true;
    end;
}

