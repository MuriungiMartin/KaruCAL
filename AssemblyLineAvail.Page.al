#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 909 "Assembly Line Avail."
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Assembly Line";
    SourceTableTemporary = true;
    SourceTableView = sorting("Document Type","Document No.",Type)
                      order(ascending)
                      where("Document Type"=const(Order),
                            Type=const(Item),
                            "No."=filter(<>''));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item or resource that is represented by the assembly order line.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies how many units of the assembly component are in inventory.';
                    Visible = false;
                }
                field(GrossRequirement;GrossRequirement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Requirement';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the total demand for the assembly component.';
                }
                field(ScheduledReceipt;ScheduledRcpt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Scheduled Receipt';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies how many units of the assembly component are inbound on orders.';
                }
                field(ExpectedAvailableInventory;ExpectedInventory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expected Available Inventory';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies how many units of the assembly component are available for the current assembly order on the due date.';
                    Visible = true;
                }
                field(CurrentQuantity;"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Quantity';
                    ToolTip = 'Specifies how many units of the component are required on the assembly order line.';
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are required to assemble one assembly item.';
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Reserved Quantity';
                    ToolTip = 'Specifies how many units of the assembly component have been reserved for this assembly order line.';
                    Visible = false;
                }
                field(EarliestAvailableDate;EarliestDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Earliest Available Date';
                    ToolTip = 'Specifies the late arrival date of an inbound supply order that can cover the needed quantity of the assembly component.';
                }
                field(AbleToAssemble;AbleToAssemble)
                {
                    ApplicationArea = Basic;
                    Caption = 'Able to Assemble';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies how many units of the assembly item on the assembly order header can be assembled, based on the availability of the component.';
                }
                field("Lead-Time Offset";"Lead-Time Offset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the lead-time offset that is defined for the assembly component on the assembly BOM.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure in which the assembly component is consumed on the assembly order.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from which you want to post consumption of the assembly component.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant of the assembly component.';
                }
                field("Substitution Available";"Substitution Available")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a substitute is available for the item on the assembly order line.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetItemFilter(Item);
        CalcAvailToAssemble(
          AssemblyHeader,
          Item,
          GrossRequirement,
          ScheduledRcpt,
          ExpectedInventory,
          Inventory,
          EarliestDate,
          AbleToAssemble);
    end;

    trigger OnInit()
    begin
        SetItemFilter(Item);
    end;

    trigger OnOpenPage()
    begin
        Reset;
        SetRange(Type,Type::Item);
        SetFilter("No.",'<>%1','');
        SetFilter("Quantity per",'<>%1',0);
    end;

    var
        AssemblyHeader: Record "Assembly Header";
        Item: Record Item;
        ExpectedInventory: Decimal;
        GrossRequirement: Decimal;
        ScheduledRcpt: Decimal;
        Inventory: Decimal;
        EarliestDate: Date;
        AbleToAssemble: Decimal;


    procedure SetLinesRecord(var AssemblyLine: Record "Assembly Line")
    begin
        Copy(AssemblyLine,true);
    end;


    procedure SetHeader(AssemblyHeader2: Record "Assembly Header")
    begin
        AssemblyHeader := AssemblyHeader2;
    end;
}

