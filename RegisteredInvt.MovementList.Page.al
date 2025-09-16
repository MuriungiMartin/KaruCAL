#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7386 "Registered Invt. Movement List"
{
    ApplicationArea = Basic;
    Caption = 'Registered Invt. Movement List';
    CardPageID = "Registered Invt. Movement";
    Editable = false;
    PageType = List;
    SourceTable = "Registered Invt. Movement Hdr.";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the registered inventory movement.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("Invt. Movement No.";"Invt. Movement No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the inventory movement from which the activity was registered.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control5;Links)
            {
                Visible = false;
            }
            systempart(Control3;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Movement")
            {
                Caption = '&Movement';
                Image = CreateMovement;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Registered Invt. Movement"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Registered Invt. Movement";
                    RunPageOnRec = true;
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }
}

