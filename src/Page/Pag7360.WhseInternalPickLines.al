#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7360 "Whse. Internal Pick Lines"
{
    Caption = 'Whse. Internal Pick Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Whse. Internal Pick Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location of the internal pick line.';
                    Visible = false;
                }
                field("To Zone Code";"To Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the To Zone Code of the zone where items should be placed once they are picked.';
                    Visible = false;
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin into which the items should be placed when they are picked.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for informational use.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that should be picked.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the item in the line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item in the line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a second description of the item on the line.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be picked.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be picked, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled.';
                }
                field("Qty. Outstanding (Base)";"Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Picked";"Qty. Picked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the line that is registered as picked.';
                }
                field("Qty. Picked (Base)";"Qty. Picked (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the line that is registered as picked, in the base unit of measure.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure, that are in the unit of measure, specified for the item on the line.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the status is Blank, Partially Picked, or Completely Picked.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the due date of the line.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line.';
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
                action("Show Whse. Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Whse. Document';
                    Image = ViewOrder;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        WhseInternalPickHeader: Record "Whse. Internal Pick Header";
                    begin
                        WhseInternalPickHeader.Get("No.");
                        Page.Run(Page::"Whse. Internal Pick",WhseInternalPickHeader);
                    end;
                }
            }
        }
    }
}

