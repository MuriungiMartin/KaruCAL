#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5407 "Prod. Order Comp. Line List"
{
    Caption = 'Prod. Order Comp. Line List';
    Editable = false;
    PageType = List;
    SourceTable = "Prod. Order Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the production order to which the component list belongs.';
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the production order to which the component list belongs.';
                }
                field("Prod. Order Line No.";"Prod. Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the production order line to which the component list belongs.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that is a component in the production order component list.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code when you calculate the production order.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the description from the corresponding field in the production BOM when you calculate the production order.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the dimension value code from the corresponding field in the production BOM when you calculate the production order.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the dimension value code from the corresponding field in the production BOM when you calculate the production order.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the location code from the corresponding field on the production order line.';
                    Visible = true;
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the value in this field from the corresponding field in the production BOM when you calculate the production order.';
                }
                field("Expected Quantity";"Expected Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the component expected to be consumed during the production of the quantity on this line.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the remaining quantity of the component to be consumed during the production of the quantity on the production order line.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the date from the Starting Date on the production order line associated with the component.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the amount from the corresponding field on the component''s item card.';
                    Visible = false;
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Calculates the amount as the Unit Cost multiplied by the Quantity.';
                    Visible = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the position code from the production BOM when you calculate the production order.';
                    Visible = false;
                }
                field("Position 2";"Position 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the position code from the production BOM when you calculate the production order.';
                    Visible = false;
                }
                field("Position 3";"Position 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the position code from the production BOM when you calculate the production order.';
                    Visible = false;
                }
                field("Lead-Time Offset";"Lead-Time Offset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Copies the lead-time offset from the corresponding field in the production BOM when you calculate the production order.';
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
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array [8] of Code[20];
}

