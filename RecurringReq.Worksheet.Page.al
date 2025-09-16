#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 296 "Recurring Req. Worksheet"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Recurring Req. Worksheet';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Requisition Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Jobs;
                Caption = 'Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the record.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ReqJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ReqJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Recurring Method";"Recurring Method")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a recurring method, if you have indicated in the Recurring field that the worksheet is a recurring requisition worksheet.';
                }
                field("Recurring Frequency";"Recurring Frequency")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a recurring frequency, if it is indicated in the Recurring field that the worksheet is a recurring requisition worksheet.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of requisition worksheet line you are creating.';

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the general ledger account or item to be entered on the line.';

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;
                }
                field("Action Message";"Action Message")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an action to take to rebalance the demand-supply situation.';
                }
                field("Accept Action Message";"Accept Action Message")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether to accept the action message proposed for the line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies text that describes the entry.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies additional text describing the entry, or a remark about the requisition worksheet line.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for an inventory location where the items that are being ordered will be registered.';
                    Visible = true;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of units of the item.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit of measure code used to determine the unit price.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the vendor who will ship the items in the purchase order.';

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the vendor''s item number for this item.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                    ApplicationArea = Jobs;
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
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Jobs;
                    AssistEdit = true;
                    ToolTip = 'Specifies the currency code for the requisition lines.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then
                          Validate("Currency Factor",ChangeExchangeRate.GetParameter);

                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the direct unit cost of this item.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the discount percentage used to calculate the purchase line discount.';
                    Visible = false;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the order date that will apply to the requisition worksheet line.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when you can expect to receive the items.';
                }
                field("Requester ID";"Requester ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ID of the user who is ordering the items on the line.';
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a value when you calculate the production order.';
                    Visible = false;
                }
                field(Confirmed;Confirmed)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the items on the line have been approved for purchase.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the last date on which the recurring requisition worksheet will be converted to a purchase order.';
                }
            }
            group(Control28)
            {
                fixed(Control1902205001)
                {
                    group(Control1903866901)
                    {
                        Caption = 'Description';
                        field(Description2;Description2)
                        {
                            ApplicationArea = Jobs;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies an additional part of the worksheet description.';
                        }
                    }
                    group("Buy-from Vendor Name")
                    {
                        Caption = 'Buy-from Vendor Name';
                        field(BuyFromVendorName;BuyFromVendorName)
                        {
                            ApplicationArea = Jobs;
                            Caption = 'Buy-from Vendor Name';
                            Editable = false;
                            ToolTip = 'Specifies the vendor according to the values in the Document No. and Document Type fields.';
                        }
                    }
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
                action(Card)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Req. Wksh.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the item or resource.';
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and projected inventory level of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Period';
                        Image = Period;
                        ToolTip = 'Show the actual and projected quantity of an item over time according to a specified time interval, such as by day, week or month.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByVariant)
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
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ToolTip = 'View how the inventory level of an item develops over time according to the bill of materials level that you select.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Jobs;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    ToolTip = 'View all reservations for the item. For example, items can be reserved for production orders or production orders.';

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Jobs;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Item &Tracking Lines")
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
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Calculate Plan")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Calculate Plan';
                    Ellipsis = true;
                    Image = CalculatePlan;
                    ToolTip = 'Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.';

                    trigger OnAction()
                    begin
                        ReorderItems.SetTemplAndWorksheet("Worksheet Template Name","Journal Batch Name");
                        ReorderItems.RunModal;
                        Clear(ReorderItems);
                    end;
                }
                action("Carry &Out Action Message")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Carry &Out Action Message';
                    Ellipsis = true;
                    Image = CarryOutActionMessage;
                    ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';

                    trigger OnAction()
                    var
                        MakePurchOrder: Report "Carry Out Action Msg. - Req.";
                    begin
                        MakePurchOrder.SetReqWkshLine(Rec);
                        MakePurchOrder.RunModal;
                        MakePurchOrder.GetReqWkshLine(Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("&Reserve")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Image = Reserve;
                    ToolTip = 'Reserve one or more units of the item on the job planning line, either from inventory or from incoming supply.';

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord;
                        ShowReservation;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ReqJnlManagement.SetUpNewLine(Rec,xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') and ("Worksheet Template Name" = '');
        if OpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          exit;
        end;
        ReqJnlManagement.TemplateSelection(Page::"Recurring Req. Worksheet",true,0,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        ReorderItems: Report "Calculate Plan - Req. Wksh.";
        ReqJnlManagement: Codeunit ReqJnlManagement;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ChangeExchangeRate: Page "Change Exchange Rate";
        CurrentJnlBatchName: Code[10];
        Description2: Text[50];
        BuyFromVendorName: Text[50];
        ShortcutDimCode: array [8] of Code[20];
        OpenedFromBatch: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ReqJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

