#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6663 "Posted Return Receipt Lines"
{
    Caption = 'Posted Return Receipt Lines';
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
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
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
}

