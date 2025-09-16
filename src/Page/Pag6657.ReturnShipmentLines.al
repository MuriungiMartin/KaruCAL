#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6657 "Return Shipment Lines"
{
    Caption = 'Return Shipment Lines';
    Editable = false;
    PageType = List;
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
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Basic;
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
                        ReturnShptHeader: Record "Return Shipment Header";
                    begin
                        ReturnShptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Return Shipment",ReturnShptHeader);
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
        FromReturnShptLine: Record "Return Shipment Line";
        TempReturnShptLine: Record "Return Shipment Line" temporary;
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

    local procedure IsFirstLine(DocNo: Code[20];LineNo: Integer): Boolean
    var
        ReturnShptLine: Record "Return Shipment Line";
    begin
        TempReturnShptLine.Reset;
        TempReturnShptLine.CopyFilters(Rec);
        TempReturnShptLine.SetRange("Document No.",DocNo);
        if not TempReturnShptLine.FindFirst then begin
          ReturnShptLine.CopyFilters(Rec);
          ReturnShptLine.SetRange("Document No.",DocNo);
          ReturnShptLine.FindFirst;
          TempReturnShptLine := ReturnShptLine;
          TempReturnShptLine.Insert;
        end;
        if TempReturnShptLine."Line No." = LineNo then
          exit(true);
    end;

    local procedure LookupOKOnPush()
    begin
        FromReturnShptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromReturnShptLine);
        if FromReturnShptLine.FindFirst then begin
          ItemChargeAssgntPurch."Unit Cost" := UnitCost;
          AssignItemChargePurch.CreateShptChargeAssgnt(FromReturnShptLine,ItemChargeAssgntPurch);
        end;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstLine("Document No.","Line No.") then
          DocumentNoHideValue := true;
    end;
}

