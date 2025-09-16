#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 917 "Component - Item FactBox"
{
    Caption = 'Component - Item FactBox';
    PageType = CardPart;
    SourceTable = "Assembly Line";

    layout
    {
        area(content)
        {
            field("Item No.";ShowNo)
            {
                ApplicationArea = Basic;
                Caption = 'Item No.';

                trigger OnDrillDown()
                begin
                    AssemblyInfoPaneManagement.LookupItem(Rec);
                end;
            }
            field("Required Quantity";ShowRequiredQty)
            {
                ApplicationArea = Basic;
                BlankZero = true;
                Caption = 'Required Quantity';
                DecimalPlaces = 0:5;
            }
            group(Availability)
            {
                Caption = 'Availability';
                field("Due Date";ShowDueDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Due Date';
                }
                field("Item Availability";AssemblyInfoPaneManagement.CalcAvailability(Rec))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Item Availability';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByEvent);
                        Clear(ItemAvailFormsMgt);
                    end;
                }
                field("Available Inventory";AssemblyInfoPaneManagement.CalcAvailableInventory(Rec))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Available Inventory';
                    DecimalPlaces = 0:5;
                }
                field("Scheduled Receipt";AssemblyInfoPaneManagement.CalcScheduledReceipt(Rec))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Scheduled Receipt';
                    DecimalPlaces = 0:5;
                }
                field("Reserved Receipt";AssemblyInfoPaneManagement.CalcReservedReceipt(Rec))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Reserved Receipt';
                    DecimalPlaces = 0:5;
                }
                field("Gross Requirement";AssemblyInfoPaneManagement.CalcGrossRequirement(Rec))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Gross Requirement';
                    DecimalPlaces = 0:5;
                }
                field("Reserved Requirement";AssemblyInfoPaneManagement.CalcReservedRequirement(Rec))
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Reserved Requirement';
                    DecimalPlaces = 0:5;
                }
            }
            group(Item)
            {
                Caption = 'Item';
                field("Base Unit of Measure";ShowBaseUoM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Unit of Measure';
                }
                field("Unit of Measure Code";ShowUoM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit of Measure Code';
                }
                field("Qty. per Unit of Measure";ShowQtyPerUoM)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Qty. per Unit of Measure';
                }
                field("Unit Price";Item."Unit Price")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Unit Price';
                }
                field("Unit Cost";Item."Unit Cost")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Unit Cost';
                }
                field("Standard Cost";Item."Standard Cost")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Standard Cost';
                }
                field("No. of Substitutes";Item."No. of Substitutes")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'No. of Substitutes';
                }
                field("Replenishment System";ShowReplenishmentSystem)
                {
                    ApplicationArea = Basic;
                    Caption = 'Replenishment System';
                }
                field("Vendor No.";ShowVendorNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor No.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Clear(Item);
        if (Type = Type::Item) and Item.Get("No.") then
          Item.CalcFields("No. of Substitutes");
    end;

    var
        Item: Record Item;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        AssemblyInfoPaneManagement: Codeunit "Assembly Info-Pane Management";

    local procedure ShowNo(): Code[20]
    begin
        if Type <> Type::Item then
          exit('');
        exit(Item."No.");
    end;

    local procedure ShowBaseUoM(): Code[10]
    begin
        if Type <> Type::Item then
          exit('');
        exit(Item."Base Unit of Measure");
    end;

    local procedure ShowUoM(): Code[10]
    begin
        if Type <> Type::Item then
          exit('');
        exit("Unit of Measure Code");
    end;

    local procedure ShowQtyPerUoM(): Decimal
    begin
        if Type <> Type::Item then
          exit(0);
        exit("Qty. per Unit of Measure");
    end;

    local procedure ShowReplenishmentSystem(): Text[50]
    begin
        if Type <> Type::Item then
          exit('');
        exit(Format(Item."Replenishment System"));
    end;

    local procedure ShowVendorNo(): Code[20]
    begin
        if Type <> Type::Item then
          exit('');
        exit(Item."Vendor No.");
    end;

    local procedure ShowRequiredQty(): Decimal
    begin
        if Type <> Type::Item then
          exit(0);
        CalcFields("Reserved Quantity");
        exit(Quantity - "Reserved Quantity");
    end;

    local procedure ShowDueDate(): Text
    begin
        if Type <> Type::Item then
          exit('');
        exit(Format("Due Date"));
    end;
}

