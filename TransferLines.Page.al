#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5749 "Transfer Lines"
{
    Caption = 'Transfer Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number associated with the line or entry.';
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
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment date of the transfer order.';
                }
                field("Qty. in Transit";"Qty. in Transit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item that is in transit.';
                }
                field("Outstanding Quantity";"Outstanding Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the quantity of the items that remains to be shipped.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item.';
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
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        TransferHeader: Record "Transfer Header";
                    begin
                        TransferHeader.Get("Document No.");
                        Page.Run(Page::"Transfer Order",TransferHeader);
                    end;
                }
            }
        }
    }
}

