#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5741 "Transfer Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Transfer Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that will be transferred.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;
                }
                field("Planning Flexibility";"Planning Flexibility")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the supply, represented by the transfer line, is considered by the planning system when calculating action messages.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Transfer-from Bin Code";"Transfer-from Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code from which the items should be transferred.';
                    Visible = false;
                }
                field("Transfer-To Bin Code";"Transfer-To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code to which the items should be transferred.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the item that will be processed as the document stipulates.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Caption = '< Total Amount>';
                }
                field("Reserved Quantity Inbnd.";"Reserved Quantity Inbnd.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the item reserved at the transfer-to location.';
                }
                field("Reserved Quantity Shipped";"Reserved Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units on the shipped transfer order are reserved.';
                }
                field("Reserved Quantity Outbnd.";"Reserved Quantity Outbnd.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the item reserved at the transfer-from location.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the items you are transferring.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item.';
                    Visible = false;
                }
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of items that remains to be shipped.';
                }
                field("Quantity Shipped";"Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the item that has been shipped.';

                    trigger OnDrillDown()
                    var
                        TransShptLine: Record "Transfer Shipment Line";
                    begin
                        TestField("Document No.");
                        TestField("Item No.");
                        TransShptLine.SetCurrentkey("Transfer Order No.","Item No.","Shipment Date");
                        TransShptLine.SetRange("Transfer Order No.","Document No.");
                        TransShptLine.SetRange("Item No.","Item No.");
                        Page.RunModal(0,TransShptLine);
                    end;
                }
                field("Qty. to Receive";"Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of items that remains to be received.';
                }
                field("Quantity Received";"Quantity Received")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the item that has been received.';

                    trigger OnDrillDown()
                    var
                        TransRcptLine: Record "Transfer Receipt Line";
                    begin
                        TestField("Document No.");
                        TestField("Item No.");
                        TransRcptLine.SetCurrentkey("Transfer Order No.","Item No.","Receipt Date");
                        TransRcptLine.SetRange("Transfer Order No.","Document No.");
                        TransRcptLine.SetRange("Item No.","Item No.");
                        Page.RunModal(0,TransRcptLine);
                    end;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment date of the transfer order.';
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that you expect the transfer-to location to receive the items on this line.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the shipping agent you are using to ship the items on this transfer line.';
                    Visible = false;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the shipping agent service you are using to ship the items on this transfer line.';
                    Visible = false;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping time, which is used to calculate the receipt date.';
                    Visible = false;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how long it takes for the transfer-from location to prepare the shipment of the items to the transfer-to location.';
                    Visible = false;
                }
                field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how long it takes the warehouse to make items part of available inventory after they are been posted as received.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
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
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        Find;
                        ShowReservation;
                    end;
                }
            }
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
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByVariant);
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
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
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
                group("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = AllLines;
                    action(Shipment)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Shipment';
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            OpenItemTrackingLines(0);
                        end;
                    }
                    action(Receipt)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Receipt';
                        Image = Receipt;

                        trigger OnAction()
                        begin
                            OpenItemTrackingLines(1);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveTransferLine: Codeunit "Transfer Line-Reserve";
    begin
        Commit;
        if not ReserveTransferLine.DeleteLineConfirm(Rec) then
          exit(false);
        ReserveTransferLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array [8] of Code[20];


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;
}

