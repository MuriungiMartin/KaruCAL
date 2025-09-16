#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5758 "Posted Transfer Shipment Lines"
{
    Caption = 'Posted Transfer Shipment Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Shipment Line";

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
                    ToolTip = 'Specifies the number of the item that will be transferred.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the entry.';
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
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment date of the transfer shipment line.';
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
                        TransShptHeader: Record "Transfer Shipment Header";
                    begin
                        TransShptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Transfer Shipment",TransShptHeader);
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

    var
        TempTransShptLine: Record "Transfer Shipment Line" temporary;
        [InDataSet]
        DocumentNoHideValue: Boolean;

    local procedure IsFirstLine(DocNo: Code[20];LineNo: Integer): Boolean
    var
        TransShptLine: Record "Transfer Shipment Line";
    begin
        TempTransShptLine.Reset;
        TempTransShptLine.CopyFilters(Rec);
        TempTransShptLine.SetRange("Document No.",DocNo);
        if not TempTransShptLine.FindFirst then begin
          TransShptLine.CopyFilters(Rec);
          TransShptLine.SetRange("Document No.",DocNo);
          TransShptLine.FindFirst;
          TempTransShptLine := TransShptLine;
          TempTransShptLine.Insert;
        end;
        if TempTransShptLine."Line No." = LineNo then
          exit(true);
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstLine("Document No.","Line No.") then
          DocumentNoHideValue := true;
    end;
}

