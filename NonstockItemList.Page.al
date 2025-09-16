#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5726 "Nonstock Item List"
{
    ApplicationArea = Basic;
    Caption = 'Nonstock Item List';
    CardPageID = "Nonstock Item Card";
    Editable = false;
    MultipleNewLines = false;
    PageType = List;
    SourceTable = "Nonstock Item";
    SourceTableView = sorting("Vendor Item No.","Manufacturer Code")
                      order(ascending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number the vendor uses to identify the nonstock item.';
                }
                field("Manufacturer Code";"Manufacturer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the manufacturer of the nonstock item.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the item number that the program has generated for this nonstock item.';
                    Visible = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor from whom you can purchase the nonstock item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the nonstock item.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the unit of measure in which the nonstock item is sold.';
                }
                field("Published Cost";"Published Cost")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the published cost or vendor list price for the nonstock item.';
                }
                field("Negotiated Cost";"Negotiated Cost")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the price you negotiated to pay for the nonstock item.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit price of the nonstock item in the local currency ($).';
                }
                field("Gross Weight";"Gross Weight")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the gross weight, including the weight of any packaging, of the nonstock item.';
                }
                field("Net Weight";"Net Weight")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net weight of the item. The weight of packaging materials is not included.';
                }
                field("Item Template Code";"Item Template Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the item template used for this nonstock item.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the nonstock item card was last modified.';
                }
                field("Bar Code";"Bar Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bar code of the nonstock item.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Nonstoc&k Item")
            {
                Caption = 'Nonstoc&k Item';
                Image = NonStockItem;
                action("Substituti&ons")
                {
                    ApplicationArea = Suite;
                    Caption = 'Substituti&ons';
                    Image = ItemSubstitution;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type=const("Nonstock Item"),
                                  "No."=field("Entry No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const("Nonstock Item"),
                                  "No."=field("Entry No.");
                }
            }
        }
        area(creation)
        {
            action("New Item")
            {
                ApplicationArea = Basic;
                Caption = 'New Item';
                Image = NewItem;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Item Card";
                RunPageMode = Create;
            }
        }
        area(reporting)
        {
            action("Inventory - List")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - List";
            }
            action("Inventory Availability")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Availability';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory Availability";
            }
            action("Inventory - Availability Plan")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - Availability Plan';
                Image = ItemAvailability;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Item/Vendor Catalog")
            {
                ApplicationArea = Basic;
                Caption = 'Item/Vendor Catalog';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Item/Vendor Catalog";
            }
            action("Nonstock Item Sales")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Nonstock Item Sales';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Catalog Item Sales";
            }
            action("Item Substitutions")
            {
                ApplicationArea = Suite;
                Caption = 'Item Substitutions';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Substitutions";
                ToolTip = 'View or edit any substitute items that are set up to be traded instead of the item in case it is not available.';
            }
        }
    }
}

