#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9109 "Item Warehouse FactBox"
{
    Caption = 'Item Details - Warehouse';
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
            field("Identifier Code";"Identifier Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies a unique code for the item in terms that are useful for automatic data capture.';
            }
            field("Base Unit of Measure";"Base Unit of Measure")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the unit in which the item is held in inventory.';
            }
            field("Put-away Unit of Measure Code";"Put-away Unit of Measure Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the code of the item unit of measure in which the program will put the item away.';
            }
            field("Purch. Unit of Measure";"Purch. Unit of Measure")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
            }
            field("Item Tracking Code";"Item Tracking Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the code that indicates how the program will track the item in inventory.';

                trigger OnDrillDown()
                var
                    ItemTrackCode: Record "Item Tracking Code";
                begin
                    ItemTrackCode.SetFilter(Code,"Item Tracking Code");

                    Page.Run(Page::"Item Tracking Code Card",ItemTrackCode);
                end;
            }
            field("Special Equipment Code";"Special Equipment Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the code of the equipment that warehouse employees must use when handling the item.';
            }
            field("Last Phys. Invt. Date";"Last Phys. Invt. Date")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the date on which you last posted the results of a physical inventory for the item to the item ledger.';
            }
            field(NetWeight;NetWeight)
            {
                ApplicationArea = Basic;
                Caption = 'Net Weight';
            }
            field("Warehouse Class Code";"Warehouse Class Code")
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse Class Code';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        NetWeight;
    end;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Item Card",Rec);
    end;

    local procedure NetWeight(): Decimal
    var
        ItemBaseUOM: Record "Item Unit of Measure";
    begin
        if ItemBaseUOM.Get("No.","Base Unit of Measure") then
          exit(ItemBaseUOM.Weight);

        exit(0);
    end;
}

