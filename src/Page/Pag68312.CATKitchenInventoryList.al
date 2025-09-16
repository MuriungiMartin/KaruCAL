#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68312 "CAT-Kitchen Inventory List"
{
    Editable = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = where("Location Filter"=const('KITCHEN'));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("Price Unit Conversion";"Price Unit Conversion")
                {
                    ApplicationArea = Basic;
                }
                field("Inventory Posting Group";"Inventory Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Standard Cost";"Standard Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Last Direct Cost";"Last Direct Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                }
                field("Cost is Adjusted";"Cost is Adjusted")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Online Adjustment";"Allow Online Adjustment")
                {
                    ApplicationArea = Basic;
                }
                field("Reorder Quantity";"Reorder Quantity")
                {
                    ApplicationArea = Basic;
                }
                field("Unit List Price";"Unit List Price")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Quantity";"Budget Quantity")
                {
                    ApplicationArea = Basic;
                }
                field("Budgeted Amount";"Budgeted Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

