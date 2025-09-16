#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5785 "Warehouse Activity Lines"
{
    Caption = 'Warehouse Activity Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Activity Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Action Type";"Action Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the action type for the warehouse activity line.';
                    Visible = false;
                }
                field("Activity Type";"Activity Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of warehouse activity for the line.';
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse activity.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse activity line.';
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of source document to which the warehouse activity line relates, such as sales, purchase, and production.';
                    Visible = false;
                }
                field("Source Subtype";"Source Subtype")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source subtype of the document related to the warehouse request.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source number of the document from which the entry originates.';
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number in the Line No. field on the warehouse receipt line related to this cross-dock opportunity.';
                }
                field("Source Subline No.";"Source Subline No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source subline number.';
                    Visible = false;
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document that the line relates to, such as a sales order.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the activity occurs.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone code where the bin on this line is located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin where items on the line are handled.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for informational use.';
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
                    ToolTip = 'Specifies the quantity of the item to be handled, such as received, put-away, or assigned.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item to be handled, in the base unit of measure.';
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of items that have not yet been handled for this warehouse activity line.';
                }
                field("Qty. Outstanding (Base)";"Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of items, expressed in the base unit of measure, that have not yet been handled for this warehouse activity line.';
                }
                field("Qty. to Handle";"Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units to handle in this warehouse activity.';
                }
                field("Qty. to Handle (Base)";"Qty. to Handle (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of items to be handled in this warehouse activity.';
                }
                field("Qty. Handled";"Qty. Handled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of items on the line that have been handled in this warehouse activity.';
                }
                field("Qty. Handled (Base)";"Qty. Handled (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of items on the line that have been handled in this warehouse activity.';
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
                    ToolTip = 'Specifies the shipping advice, informing whether partial deliveries are acceptable, copied from the source document header.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the warehouse activity must be completed.';
                }
                field("Whse. Document Type";"Whse. Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of warehouse document from which the line originated.';
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
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        ShowActivityDoc;
                    end;
                }
                action("Show &Whse. Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show &Whse. Document';
                    Image = ViewOrder;
                    Promoted = true;
                    PromotedCategory = Process;

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
        Text000: label 'Warehouse Put-away Lines';
        Text001: label 'Warehouse Pick Lines';
        Text002: label 'Warehouse Movement Lines';
        Text003: label 'Warehouse Activity Lines';
        Text004: label 'Inventory Put-away Lines';
        Text005: label 'Inventory Pick Lines';

    local procedure FormCaption(): Text[250]
    begin
        case "Activity Type" of
          "activity type"::"Put-away":
            exit(Text000);
          "activity type"::Pick:
            exit(Text001);
          "activity type"::Movement:
            exit(Text002);
          "activity type"::"Invt. Put-away":
            exit(Text004);
          "activity type"::"Invt. Pick":
            exit(Text005);
          else
            exit(Text003);
        end;
    end;
}

