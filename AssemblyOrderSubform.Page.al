#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 901 "Assembly Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Assembly Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Avail. Warning";"Avail. Warning")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    DrillDown = true;
                    ToolTip = 'Specifies Yes if the assembly component is not available in the quantity and on the due date of the assembly order line.';

                    trigger OnDrillDown()
                    begin
                        ShowAvailabilityWarning;
                    end;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the assembly order line is of type Item or Resource.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item or resource that is represented by the assembly order line.';

                    trigger OnValidate()
                    begin
                        ReserveItem;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the assembly component.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the second description of the assembly component.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant of the assembly component.';

                    trigger OnValidate()
                    begin
                        ReserveItem;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from which you want to post consumption of the assembly component.';

                    trigger OnValidate()
                    begin
                        ReserveItem;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure in which the assembly component is consumed on the assembly order.';

                    trigger OnValidate()
                    begin
                        ReserveItem;
                    end;
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are required to assemble one assembly item.';

                    trigger OnValidate()
                    begin
                        ReserveItem;
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are expected to be consumed.';

                    trigger OnValidate()
                    begin
                        ReserveItem;
                    end;
                }
                field("Quantity to Consume";"Quantity to Consume")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component you want to post as consumed when you post the assembly order.';
                }
                field("Consumed Quantity";"Consumed Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component have been posted as consumed during the assembly.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component remain to be consumed during assembly.';
                }
                field("Qty. Picked";"Qty. Picked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component have been moved or picked for the assembly order line.';
                    Visible = false;
                }
                field("Pick Qty.";"Pick Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are currently on warehouse pick lines.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly component must be available for consumption by the assembly order.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveItem;
                    end;
                }
                field("Lead-Time Offset";"Lead-Time Offset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the lead-time offset that is defined for the assembly component on the assembly BOM.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shortcut dimension 1 value that the assembly order line is linked to.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shortcut dimension 2 value that the assembly order line is linked to.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin where assembly components must be placed prior to assembly and from where they are posted as consumed.';
                    Visible = false;
                }
                field("Inventory Posting Group";"Inventory Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory posting group to which the item on this assembly order line is posted.';
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit cost of the assembly component.';
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost of the assembly order line.';
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component have been reserved for this assembly order line.';
                }
                field(Control57;Reserve)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reserve option for the assembly order line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveItem;
                    end;
                }
                field(ReservationStatusField;ReservationStatusField)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reservation Status';
                    Editable = false;
                    OptionCaption = ' ,Partial,Full';
                    ToolTip = 'Specifies if the value in the Quantity field on the assembly order line is fully or partially reserved.';
                    Visible = false;
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per unit of measure of the component item on the assembly order line.';
                }
                field("Resource Usage Type";"Resource Usage Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the cost of the resource on the assembly order line is allocated to the assembly item.';
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of a particular item ledger entry that the assembly order line is applied to.';
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the assembly order line is applied from.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location=R;
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action("Item Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
                action("Show Warning")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Warning';
                    Image = ShowWarning;

                    trigger OnAction()
                    begin
                        ShowAvailabilityWarning;
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Assembly Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "Document No."=field("Document No."),
                                  "Document Line No."=field("Line No.");
                }
                action(AssemblyBOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Assembly BOM';
                    Image = AssemblyBOM;

                    trigger OnAction()
                    begin
                        ShowAssemblyList;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SelectItemSubstitution)
                {
                    ApplicationArea = Basic;
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        ShowItemSub;
                        CurrPage.Update;
                    end;
                }
                action(ExplodeBOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin
                        ExplodeAssemblyList;
                        CurrPage.Update;
                    end;
                }
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        ShowReservation;
                    end;
                }
                action("Order &Tracking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        ShowTracking;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ReservationStatusField := ReservationStatus;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
          Commit;
          if not AssemblyLineReserve.DeleteLineConfirm(Rec) then
            exit(false);
          AssemblyLineReserve.DeleteLine(Rec);
        end;
    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ReservationStatusField: Option " ",Partial,Full;

    local procedure ReserveItem()
    begin
        if Type <> Type::Item then
          exit;

        if ("Remaining Quantity (Base)" <> xRec."Remaining Quantity (Base)") or
           ("No." <> xRec."No.") or
           ("Location Code" <> xRec."Location Code") or
           ("Variant Code" <> xRec."Variant Code") or
           ("Due Date" <> xRec."Due Date") or
           ((Reserve <> xRec.Reserve) and ("Remaining Quantity (Base)" <> 0))
        then
          if Reserve = Reserve::Always then begin
            CurrPage.SaveRecord;
            AutoReserve;
            CurrPage.Update(false);
          end;

        ReservationStatusField := ReservationStatus;
    end;
}

