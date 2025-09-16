#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9089 "Item Invoicing FactBox"
{
    Caption = 'Item Details - Invoicing';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Item No.';
                ToolTip = 'Specifies the number of the item.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("Costing Method";"Costing Method")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies how the item''s cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.';
            }
            field("Cost is Adjusted";"Cost is Adjusted")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies whether the item''s unit cost has been adjusted, either automatically or manually.';
            }
            field("Cost is Posted to G/L";"Cost is Posted to G/L")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies that all the inventory costs for this item have been posted to the general ledger.';
            }
            field("Standard Cost";"Standard Cost")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the unit cost that is used as a standard measure. You must fill in this field if you selected Standard in the Costing Method field.';
            }
            field("Unit Cost";"Unit Cost")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the cost per unit of the item.';
            }
            field("Overhead Rate";"Overhead Rate")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the item''s indirect cost as an absolute amount.';
            }
            field("Indirect Cost %";"Indirect Cost %")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the percentage of the item''s direct unit cost that makes up indirect costs, such as freight and warehouse handling.';
            }
            field("Last Direct Cost";"Last Direct Cost")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the most recent direct unit cost of the item.';
            }
            field("Profit %";"Profit %")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
            }
            field("Unit Price";"Unit Price")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the price for one unit of the item, in $. You can enter a price manually or have it entered according to the Price/Profit Calculation field.';
            }
        }
    }

    actions
    {
    }

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Item Card",Rec);
    end;
}

