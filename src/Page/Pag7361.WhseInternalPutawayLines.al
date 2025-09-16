#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7361 "Whse. Internal Put-away Lines"
{
    Caption = 'Whse. Internal Put-away Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Whse. Internal Put-away Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location of the internal put-away line.';
                    Visible = false;
                }
                field("From Zone Code";"From Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the zone from which the items to be put away should be taken.';
                    Visible = false;
                }
                field("From Bin Code";"From Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the bin from which the items to be put away should be taken.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number that is recorded on the item card or the stockkeeping unit card of the item being moved.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that you want to put away and have entered on the line.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the item in the line, if any.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item on the line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a second description of the item on the line, if any.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be put away.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be put away, in the base unit of measure.';
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled.';
                }
                field("Qty. Outstanding (Base)";"Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled, expressed in the base unit of measure.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of unit of measure of the item on the line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure, that are in the unit of measure, specified for the item on the line.';
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
                        WhseInternalPutawayHeader: Record "Whse. Internal Put-away Header";
                    begin
                        WhseInternalPutawayHeader.Get("No.");
                        Page.Run(Page::"Whse. Internal Put-away",WhseInternalPutawayHeader);
                    end;
                }
            }
        }
    }
}

