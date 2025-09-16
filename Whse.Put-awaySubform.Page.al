#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5771 "Whse. Put-away Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    InsertAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Warehouse Activity Line";
    SourceTableView = where("Activity Type"=const("Put-away"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Action Type";"Action Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the action type for the warehouse activity line.';
                    Visible = false;
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ',Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,,Prod. Consumption';
                    ToolTip = 'Specifies the type of document that the line relates to, such as a sales order.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source number of the document from which the entry originates.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number of the item to be handled, such as picked or put away.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code of the item to be handled.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item on the line.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Lookup = false;
                    ToolTip = 'Specifies the serial number to handle in the document.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        SerialNoOnAfterValidate;
                    end;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Lookup = false;
                    ToolTip = 'Specifies the lot number to handle in the document.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        LotNoOnAfterValidate;
                    end;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the expiration date of the serial/lot numbers if you are putting items away.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the activity occurs.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    Editable = ZoneCodeEditable;
                    ToolTip = 'Specifies the zone code where the bin on this line is located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = BinCodeEditable;
                    ToolTip = 'Specifies the bin where items on the line are handled.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BinCodeOnAfterValidate;
                    end;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for informational use.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item to be handled, such as received, put-away, or assigned.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item to be handled, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. to Handle";"Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Editable = QtyToHandleEditable;
                    ToolTip = 'Specifies how many units to handle in this warehouse activity.';

                    trigger OnValidate()
                    begin
                        QtytoHandleOnAfterValidate;
                    end;
                }
                field("Qty. Handled";"Qty. Handled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of items on the line that have been handled in this warehouse activity.';
                }
                field("Qty. to Handle (Base)";"Qty. to Handle (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of items to be handled in this warehouse activity.';
                    Visible = false;
                }
                field("Qty. Handled (Base)";"Qty. Handled (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of items on the line that have been handled in this warehouse activity.';
                    Visible = false;
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of items that have not yet been handled for this warehouse activity line.';
                }
                field("Qty. Outstanding (Base)";"Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of items, expressed in the base unit of measure, that have not yet been handled for this warehouse activity line.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the warehouse activity must be completed.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item on the line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per unit of measure of the item on the line.';
                }
                field("Destination Type";"Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies information about the type of destination, such as customer or vendor, associated with the warehouse activity line.';
                    Visible = false;
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number or code of the customer, vendor or location related to the activity line.';
                    Visible = false;
                }
                field("Whse. Document Type";"Whse. Document Type")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,Receipt,,Internal Put-away';
                    ToolTip = 'Specifies the type of warehouse document from which the line originated.';
                    Visible = false;
                }
                field("Whse. Document No.";"Whse. Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse document that is the basis for the action on the line.';
                    Visible = false;
                }
                field("Whse. Document Line No.";"Whse. Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line in the warehouse document that is the basis for the action on the line.';
                    Visible = false;
                }
                field("Special Equipment Code";"Special Equipment Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the equipment required when you perform the action on the line.';
                    Visible = false;
                }
                field("Cross-Dock Information";"Cross-Dock Information")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an option for specific information regarding the cross-dock activity.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Split Line")
                {
                    ApplicationArea = Basic;
                    Caption = '&Split Line';
                    Image = Split;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction()
                    var
                        WhseActivLine: Record "Warehouse Activity Line";
                    begin
                        WhseActivLine.Copy(Rec);
                        SplitLine(WhseActivLine);
                        CurrPage.Update(false);
                    end;
                }
                action(ChangeUnitOfMeasure)
                {
                    ApplicationArea = Basic;
                    Caption = '&Change Unit Of Measure';
                    Ellipsis = true;
                    Image = UnitConversions;

                    trigger OnAction()
                    begin
                        ChangeUOM;
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Source Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Document Line';
                    Image = SourceDocLine;

                    trigger OnAction()
                    begin
                        ShowSourceLine;
                    end;
                }
                action("Whse. Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Document Line';
                    Image = Line;

                    trigger OnAction()
                    begin
                        ShowWhseLine;
                    end;
                }
                action("Bin Contents List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bin Contents List';
                    Image = BinContent;

                    trigger OnAction()
                    begin
                        ShowBinContents;
                    end;
                }
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
                            ItemAvailability(ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByVariant);
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
                            ItemAvailability(ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableZoneBin;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;

    trigger OnInit()
    begin
        QtyToHandleEditable := true;
        BinCodeEditable := true;
        ZoneCodeEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Activity Type" := xRec."Activity Type";
    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        WMSMgt: Codeunit "WMS Management";
        [InDataSet]
        ZoneCodeEditable: Boolean;
        [InDataSet]
        BinCodeEditable: Boolean;
        [InDataSet]
        QtyToHandleEditable: Boolean;

    local procedure ShowSourceLine()
    begin
        WMSMgt.ShowSourceDocLine(
          "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
    end;

    local procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    begin
        ItemAvailFormsMgt.ShowItemAvailFromWhseActivLine(Rec,AvailabilityType);
    end;

    local procedure ChangeUOM()
    var
        WhseActLine: Record "Warehouse Activity Line";
        WhseChangeOUM: Report "Whse. Change Unit of Measure";
    begin
        TestField("Action Type");
        TestField("Breakbulk No.",0);
        TestField("Action Type",2);
        WhseChangeOUM.DefWhseActLine(Rec);
        WhseChangeOUM.RunModal;
        if WhseChangeOUM.ChangeUOMCode(WhseActLine) = true then
          ChangeUOMCode(Rec,WhseActLine);
        Clear(WhseChangeOUM);
        CurrPage.Update(false);
    end;


    procedure RegisterPutAwayYesNo()
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        WhseActivLine.Copy(Rec);
        WhseActivLine.FilterGroup(3);
        WhseActivLine.SetRange(Breakbulk);
        WhseActivLine.FilterGroup(0);
        Codeunit.Run(Codeunit::"Whse.-Act.-Register (Yes/No)",WhseActivLine);
        Reset;
        SetCurrentkey("Activity Type","No.","Sorting Sequence No.");
        FilterGroup(4);
        SetRange("Activity Type","Activity Type");
        SetRange("No.","No.");
        FilterGroup(3);
        SetRange(Breakbulk,false);
        FilterGroup(0);
        CurrPage.Update(false);
    end;


    procedure AutofillQtyToHandle()
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        WhseActivLine.Copy(Rec);
        AutofillQtyToHandle(WhseActivLine);
    end;


    procedure DeleteQtyToHandle()
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        WhseActivLine.Copy(Rec);
        DeleteQtyToHandle(WhseActivLine);
    end;

    local procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        if "Action Type" = "action type"::Place then
          BinContent.ShowBinContents("Location Code","Item No.","Variant Code",'')
        else
          BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    end;

    local procedure ShowWhseLine()
    begin
        WMSMgt.ShowWhseDocLine(
          "Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
    end;

    local procedure EnableZoneBin()
    begin
        ZoneCodeEditable :=
          ("Action Type" = "action type"::Place) and ("Breakbulk No." = 0);
        BinCodeEditable :=
          ("Action Type" = "action type"::Place) and ("Breakbulk No." = 0);
        QtyToHandleEditable :=
          ("Action Type" = "action type"::Take) or ("Breakbulk No." = 0);
    end;

    local procedure SerialNoOnAfterValidate()
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
        if "Serial No." <> '' then
          ExpDate := ItemTrackingMgt.ExistingExpirationDate("Item No.","Variant Code",
              "Lot No.","Serial No.",false,EntriesExist);

        if ExpDate <> 0D then
          "Expiration Date" := ExpDate;
    end;

    local procedure LotNoOnAfterValidate()
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
        if "Lot No." <> '' then
          ExpDate := ItemTrackingMgt.ExistingExpirationDate("Item No.","Variant Code",
              "Lot No.","Serial No.",false,EntriesExist);

        if ExpDate <> 0D then
          "Expiration Date" := ExpDate;
    end;

    local procedure BinCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QtytoHandleOnAfterValidate()
    begin
        CurrPage.Update(true);
    end;
}

