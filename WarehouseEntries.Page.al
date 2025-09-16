#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7318 "Warehouse Entries"
{
    ApplicationArea = Basic;
    Caption = 'Warehouse Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Warehouse Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry type, which can be Negative Adjmt., Positive Adjmt., or Movement.';
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the journal batch that the entry was posted from.';
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number of the warehouse document line or warehouse journal line that was registered.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location to which the entry is linked.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the lot number assigned to the warehouse entry.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the expiration date of the serial number.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone to which the entry is linked.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin linked to the entry.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the warehouse entry.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item in the warehouse entry.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the entry, in the base unit of measure.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per item unit of measure.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure that are in the unit of measure specified for the item on the line.';
                    Visible = false;
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the table number that is the source of the entry line, for example, 39 for a purchase line, 37 for a sales line.';
                    Visible = false;
                }
                field("Source Subtype";"Source Subtype")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source subtype of the document to which the warehouse entry line relates.';
                    Visible = false;
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document related to the line.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source number of the document from which the entry originates.';
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source line number of the document from which the entry originates.';
                }
                field("Source Subline No.";"Source Subline No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source subline number of the document from which the entry originates.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code of the entry.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting or registering number series for the entry.';
                    Visible = false;
                }
                field(Cubage;Cubage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total cubage of the items on the warehouse entry line.';
                    Visible = false;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total weight of items on the warehouse entry line.';
                    Visible = false;
                }
                field("Journal Template Name";"Journal Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the journal template name of the warehouse journal line for which the entry is created.';
                    Visible = false;
                }
                field("Whse. Document Type";"Whse. Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the document from which this entry originated.';
                }
                field("Whse. Document No.";"Whse. Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse document from which this entry originated.';
                }
                field("Registering Date";"Registering Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the entry was registered.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user entering or posting this entry.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number for the entry.';
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

