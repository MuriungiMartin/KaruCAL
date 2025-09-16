#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5744 "Posted Transfer Shpt. Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Transfer Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that will be transferred.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Transfer-from Bin Code";"Transfer-from Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the bin from which the items should be transferred.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the item specified on the line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the items that you are transferring.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item.';
                    Visible = false;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping time, which the program uses to calculate the receipt date.';
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

                    trigger OnAction()
                    begin
                        ShowItemTrackingLines;
                    end;
                }
            }
        }
    }
}

