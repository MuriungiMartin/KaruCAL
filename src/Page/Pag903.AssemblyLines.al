#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 903 "Assembly Lines"
{
    AutoSplitKey = true;
    Caption = 'Assembly Lines';
    Editable = false;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Assembly Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of assembly document that the assembly order header represents in assemble-to-order scenarios.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the assembly order header that the assembly order line refers to.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the assembly order line is of type Item or Resource.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item or resource that is represented by the assembly order line.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant of the assembly component.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the assembly component.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the second description of the assembly component.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shortcut dimension 1 value that the assembly order line is linked to.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shortcut dimension 2 value that the assembly order line is linked to.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from which you want to post consumption of the assembly component.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin where assembly components must be placed prior to assembly and from where they are posted as consumed.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure in which the assembly component is consumed on the assembly order.';
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are required to assemble one assembly item.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are expected to be consumed.';
                }
                field("Consumed Quantity";"Consumed Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component have been posted as consumed during the assembly.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component remain to be consumed during assembly.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly component must be available for consumption by the assembly order.';
                    Visible = false;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component have been reserved for this assembly order line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per unit of measure of the component item on the assembly order line.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control9;Links)
            {
                Visible = false;
            }
            systempart(Control7;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = 'Line';
                Image = Line;
                action("Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = '&Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        AssemblyHeader: Record "Assembly Header";
                    begin
                        AssemblyHeader.Get("Document Type","Document No.");
                        Page.Run(Page::"Assembly Order",AssemblyHeader);
                    end;
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
            }
        }
    }
}

