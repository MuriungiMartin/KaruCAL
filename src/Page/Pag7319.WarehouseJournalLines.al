#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7319 "Warehouse Journal Lines"
{
    Caption = 'Warehouse Journal Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Journal Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Journal Template Name";"Journal Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the journal template that applies to the line.';
                    Visible = false;
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the journal batch that applies to the line.';
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse journal line.';
                    Visible = false;
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of transaction that will be registered from the line.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location to which the journal line applies.';
                }
                field("From Zone Code";"From Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone from which the item on the journal line is taken.';
                }
                field("From Bin Code";"From Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin from which the item on the journal line is taken.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item on the journal line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item in the adjustment (positive or negative) or the reclassification.';
                }
                field("Qty. (Absolute, Base)";"Qty. (Absolute, Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity expressed as an absolute (positive) number, in the base unit of measure.';
                    Visible = false;
                }
                field("To Zone Code";"To Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone to which the item on the journal line will be moved.';
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin to which the item on the journal line will be moved.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code for the warehouse journal line.';
                }
                field(Cubage;Cubage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total cubage of the items on the warehouse journal line.';
                    Visible = false;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total weight of items on the warehouse journal line.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the User ID of the user who created the warehouse journal line.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure in the unit of measure specified for the item on the journal line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the unit of measure for this item.';
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
    }
}

