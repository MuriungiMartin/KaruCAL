#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7387 "Reg. Invt. Movement Lines"
{
    Caption = 'Reg. Invt. Movement Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Registered Invt. Movement Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Action Type";"Action Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the action type for the inventory movement line.';
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the registered inventory movement.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the related inventory movement line.';
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                    Visible = false;
                }
                field("Source Subtype";"Source Subtype")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line on the related inventory movement.';
                }
                field("Source Subline No.";"Source Subline No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the subline on the related inventory movement.';
                    Visible = false;
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone code where the bin on the registered inventory movement is located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
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
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the second description of the item.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                    Visible = false;
                }
                field("Special Equipment Code";"Special Equipment Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Line table.';
                    Visible = false;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping advice for the registered inventory movement line.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
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
                action("Show Registered Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Registered Document';
                    Image = ViewRegisteredOrder;
                    RunObject = Page "Registered Invt. Movement";
                    RunPageLink = "No."=field("No.");
                    RunPageView = sorting("No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Show Source Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Source Document';
                    Image = ViewOrder;

                    trigger OnAction()
                    var
                        WMSMgt: Codeunit "WMS Management";
                    begin
                        WMSMgt.ShowSourceDocCard("Source Type","Source Subtype","Source No.");
                    end;
                }
            }
        }
    }
}

