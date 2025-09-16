#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7364 "Registered Whse. Act.-Lines"
{
    Caption = 'Registered Whse. Act.-Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Registered Whse. Activity Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Action Type";"Action Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the action you must perform for the items on the line.';
                    Visible = false;
                }
                field("Activity Type";"Activity Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of activity that the warehouse performed on the line, such as put-away, pick, or movement.';
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the registered warehouse activity header.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the registered warehouse activity line.';
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of transaction the source document is associated with, such as sales, purchase, and production.';
                    Visible = false;
                }
                field("Source Subtype";"Source Subtype")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source subtype of the document related to the registered activity line.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document from which the activity line originated.';
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document that relates to this activity line.';
                }
                field("Source Subline No.";"Source Subline No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document subline related to this activity line.';
                    Visible = false;
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document, such as sales order, to which the line relates.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location at which the activity occurs.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone in which the bin on this line is located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin on the registered warehouse activity line.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item on the line for information use.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number of the item to be handled, such as picked or put away.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code of the item to be handled.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item on the line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per unit of measure of the item on the line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item on the line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item on the line.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item that was put-away, picked or moved.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item that was put-away, picked or moved.';
                    Visible = false;
                }
                field("Special Equipment Code";"Special Equipment Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the equipment required when you perform the action on the line.';
                    Visible = false;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping advice about whether a partial delivery was acceptable to the order recipient.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the activity should have been completed.';
                }
                field("Whse. Document Type";"Whse. Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document that the line originated from.';
                    Visible = false;
                }
                field("Whse. Document No.";"Whse. Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse document that is the basis for the action on the line.';
                    Visible = false;
                }
                field("Whse. Document Line No.";"Whse. Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line in the warehouse document that is the basis for the action on the line.';
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
                action("Show Registered Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Registered Document';
                    Image = ViewRegisteredOrder;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        ShowRegisteredActivityDoc;
                    end;
                }
                action("Show &Whse. Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show &Whse. Document';
                    Image = ViewOrder;

                    trigger OnAction()
                    begin
                        ShowWhseDoc;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Caption := FormCaption;
    end;

    var
        Text000: label 'Registered Whse. Put-away Lines';
        Text001: label 'Registered Whse. Pick Lines';
        Text002: label 'Registered Whse. Movement Lines';
        Text003: label 'Registered Whse. Activity Lines';

    local procedure FormCaption(): Text[250]
    begin
        case "Activity Type" of
          "activity type"::"Put-away":
            exit(Text000);
          "activity type"::Pick:
            exit(Text001);
          "activity type"::Movement:
            exit(Text002);
          else
            exit(Text003);
        end;
    end;
}

