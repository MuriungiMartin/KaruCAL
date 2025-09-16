#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5970 "Posted Service Shipment Lines"
{
    AutoSplitKey = true;
    Caption = 'Posted Service Shipment Lines';
    DataCaptionFields = "Document No.";
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Service Shipment Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SelectionFilter;SelectionFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Selection Filter';
                    OptionCaption = 'All Service Shipment Lines,Lines per Selected Service Item,Lines Not Item Related';
                    ToolTip = 'Specifies a selection filter.';

                    trigger OnValidate()
                    begin
                        SelectionFilterOnAfterValidate;
                    end;
                }
            }
            repeater(Control1)
            {
                Editable = false;
                field("Service Item Line No.";"Service Item Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item line to which this service line is linked.';
                    Visible = false;
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item to which this service line is linked.';
                    Visible = false;
                }
                field("Service Item Serial No.";"Service Item Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the service item to which this shipment line is linked.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of this shipment line.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item, general ledger account, resource code, or cost on the line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of an item, resource, cost, or a standard text on the service line.';
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the type of work performed under the posted service order.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of one unit of measure of the item, resource time, general ledger account, or cost on the shipment line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the number of item units, resource hours, general ledger account payments, or cost that have been shipped to the customer.';
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Indicates how many item units, resource hours, general ledger account payments, or costs on the line have been invoiced.';
                }
                field("Quantity Consumed";"Quantity Consumed")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the number of units of items, resource hours, general ledger account payments, or costs that have been posted as consumed.';
                }
                field("Qty. Shipped Not Invoiced";"Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Indicates how many item units, resource hours, general ledger account payments, or cost on the line have been shipped but not invoiced or consumed.';
                }
                field("Fault Area Code";"Fault Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault area associated with this service line.';
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the symptom associated with this service shipment line.';
                }
                field("Fault Code";"Fault Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault code associated with this service shipment line.';
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault reason for the service shipment line.';
                    Visible = false;
                }
                field("Resolution Code";"Resolution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the resolution associated with this service shipment line.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location, such as warehouse or distribution center, from which the items should be taken and where they should be registered.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin from which the service items were shipped.';
                    Visible = false;
                }
                field("Spare Part Action";"Spare Part Action")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the item has been used to replace the whole service item, one of the service item components, installed as a new component, or as a supplementary tool in the service process.';
                }
                field("Replaced Item Type";"Replaced Item Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the service item component replaced by the item on the service line.';
                }
                field("Replaced Item No.";"Replaced Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item component replaced by the item on the service line.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contract associated with the posted service order.';
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the posting group used when the service line was posted.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service line was posted.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code assigned to this shipment line.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code assigned to this shipment line.';
                    Visible = false;
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimenions)
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
                action(ItemTrackingEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        ShowItemTrackingLines;
                    end;
                }
                separator(Action27)
                {
                }
                action(ItemInvoiceLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Invoice &Lines';
                    Image = ItemInvoice;

                    trigger OnAction()
                    begin
                        TestField(Type,Type::Item);
                        ShowItemServInvLines;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Order Tracking")
                {
                    ApplicationArea = Basic;
                    Caption = '&Order Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        ShowTracking;
                    end;
                }
                separator(Action86)
                {
                }
                action(UndoShipment)
                {
                    ApplicationArea = Basic;
                    Caption = '&Undo Shipment';
                    Image = UndoShipment;

                    trigger OnAction()
                    begin
                        UndoServShptPosting;
                    end;
                }
                action(UndoConsumption)
                {
                    ApplicationArea = Basic;
                    Caption = 'U&ndo Consumption';
                    Image = Undo;

                    trigger OnAction()
                    begin
                        UndoServConsumption;
                    end;
                }
            }
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Clear(SelectionFilter);
        SetSelectionFilter;
    end;

    var
        SelectionFilter: Option "All Shipment Lines","Lines per Selected Service Item","Lines Not Item Related";
        ServItemLineNo: Integer;


    procedure Initialize(ServItemLineNo2: Integer)
    begin
        ServItemLineNo := ServItemLineNo2;
    end;


    procedure SetSelectionFilter()
    begin
        case SelectionFilter of
          Selectionfilter::"All Shipment Lines":
            SetRange("Service Item Line No.");
          Selectionfilter::"Lines per Selected Service Item":
            SetRange("Service Item Line No.",ServItemLineNo);
          Selectionfilter::"Lines Not Item Related":
            SetFilter("Service Item Line No.",'=%1',0);
        end;
        CurrPage.Update(false);
    end;

    local procedure ShowTracking()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        TrackingForm: Page "Order Tracking";
    begin
        TestField(Type,Type::Item);
        if "Item Shpt. Entry No." <> 0 then begin
          ItemLedgEntry.Get("Item Shpt. Entry No.");
          TrackingForm.SetItemLedgEntry(ItemLedgEntry);
        end else
          TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
            Database::"Service Shipment Line",0,"Document No.",'',0,"Line No.");
        TrackingForm.RunModal;
    end;

    local procedure UndoServShptPosting()
    var
        ServShptLine: Record "Service Shipment Line";
    begin
        ServShptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(ServShptLine);
        Codeunit.Run(Codeunit::"Undo Service Shipment Line",ServShptLine);
    end;

    local procedure UndoServConsumption()
    var
        ServShptLine: Record "Service Shipment Line";
    begin
        ServShptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(ServShptLine);
        Codeunit.Run(Codeunit::"Undo Service Consumption Line",ServShptLine);
    end;

    local procedure SelectionFilterOnAfterValidate()
    begin
        CurrPage.Update;
        SetSelectionFilter;
    end;
}

