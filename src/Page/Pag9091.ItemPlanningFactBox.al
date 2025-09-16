#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9091 "Item Planning FactBox"
{
    Caption = 'Item Details - Planning';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Basic;
                Caption = 'Item No.';
                ToolTip = 'Specifies the number of the item.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("Reordering Policy";"Reordering Policy")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the reordering policy that is used to calculate the lot size per planning period (time bucket).';
            }
            field("Reorder Point";"Reorder Point")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a stock quantity that sets the inventory below the level that you must replenish the item.';
            }
            field("Reorder Quantity";"Reorder Quantity")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a standard lot size quantity to be used for all order proposals.';
            }
            field("Maximum Inventory";"Maximum Inventory")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a quantity that you want to use as a maximum inventory level.';
            }
            field("Overflow Level";"Overflow Level")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a quantity you allow projected inventory to exceed the reorder point, before the system suggests to decrease supply orders.';
            }
            field("Time Bucket";"Time Bucket")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a time period that defines the recurring planning horizon used with Fixed Reorder Qty. or Maximum Qty. reordering policies.';
            }
            field("Lot Accumulation Period";"Lot Accumulation Period")
            {
                ApplicationArea = Basic;
                ToolTip = 'Defines a period in which multiple demands are accumulated into one supply order when you use the Lot-for-Lot reordering policy.';
            }
            field("Rescheduling Period";"Rescheduling Period")
            {
                ApplicationArea = Basic;
                ToolTip = 'Defines a period within which any suggestion to change a supply date always consists of a Reschedule action and never a Cancel + New action.';
            }
            field("Safety Lead Time";"Safety Lead Time")
            {
                ApplicationArea = Basic;
                ToolTip = 'Defines a date formula to indicate a safety lead time that can be used as a buffer period for production and other delays.';
            }
            field("Safety Stock Quantity";"Safety Stock Quantity")
            {
                ApplicationArea = Basic;
                ToolTip = 'Defines a quantity of stock to have in inventory to protect against supply-and-demand fluctuations during replenishment lead time.';
            }
            field("Minimum Order Quantity";"Minimum Order Quantity")
            {
                ApplicationArea = Basic;
                ToolTip = 'Defines a minimum allowable quantity for an item order proposal.';
            }
            field("Maximum Order Quantity";"Maximum Order Quantity")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a maximum allowable quantity for an item order proposal.';
            }
            field("Order Multiple";"Order Multiple")
            {
                ApplicationArea = Basic;
                ToolTip = 'Defines a parameter used by the planning system to modify the quantity of planned supply orders.';
            }
            field("Dampener Period";"Dampener Period")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a period of time during which you do not want the planning system to propose to reschedule existing supply orders.';
            }
            field("Dampener Quantity";"Dampener Quantity")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a dampener quantity to block insignificant change suggestions for an existing supply, if the change quantity is lower than the dampener quantity.';
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

