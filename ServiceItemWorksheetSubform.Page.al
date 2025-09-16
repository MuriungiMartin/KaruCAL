#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5907 "Service Item Worksheet Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Service Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the service line.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of an item, general ledger account, resource code, cost, or standard text.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code of a variant set up for the item on this line.';
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the item is a nonstock item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of an item, resource, cost, or a standard text on the line.';
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the type of work performed by the resource registered on this line.';
                    Visible = false;
                }
                field(Control86;Reserve)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates whether a reservation can be made for items on this line.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the inventory location from where the items on the line should be taken and where they should be registered.';

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate;
                    end;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that describes the bin.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of one unit of measure of the item, resource time, or cost on this line.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the unit of measure for the item, resource or cost on the line.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of item units, resource hours, cost on the service line.';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates how many item units on this line have been reserved.';
                    Visible = false;
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault reason for this service line.';
                }
                field("Fault Area Code";"Fault Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault area associated with this line.';
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the symptom associated with this line.';
                }
                field("Fault Code";"Fault Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault associated with this line.';
                }
                field("Resolution Code";"Resolution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the resolution associated with this line.';
                }
                field("Serv. Price Adjmt. Gr. Code";"Serv. Price Adjmt. Gr. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service price adjustment group code that applies to this line.';
                    Visible = false;
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price per item unit, resource, or cost on the line.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount defined for a particular group, item, or combination of the two.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of discount calculated for this line.';
                }
                field("Line Discount Type";"Line Discount Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the line discount assigned to this line.';
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net amount (excluding the invoice discount amount) on the line, in the currency of the service document.';
                }
                field("Exclude Warranty";"Exclude Warranty")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the warranty discount is excluded on this line.';
                }
                field("Exclude Contract Discount";"Exclude Contract Discount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the contract discount is excluded for the item, resource, or cost on this line.';
                }
                field(Warranty;Warranty)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a warranty discount is available on this line of type Item or Resource.';
                }
                field("Warranty Disc. %";"Warranty Disc. %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of the warranty discount that is valid for the items or resources on this line.';
                    Visible = false;
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contract, if the service order originated from a service contract.';
                }
                field("Contract Disc. %";"Contract Disc. %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contract discount percentage that is valid for the items, resources, and costs on this line.';
                    Visible = false;
                }
                field("VAT %";"VAT %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax percentage used to calculate Amount Including Tax on this line.';
                    Visible = false;
                }
                field("VAT Base Amount";"VAT Base Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that serves as a base for calculating Amount Including Tax.';
                    Visible = false;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net amount, including Tax, for this line.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the customer general business posting group.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the general product posting group.';
                    Visible = false;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the Tax business posting group of the customer.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the Tax product posting group of the item, resource, or general ledger account on this line.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service line should be posted.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("Planned Delivery Date";"Planned Delivery Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when is planned to deliver the item, resource, or G/L account payment associated with this order.';
                }
                field("Needed by Date";"Needed by Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you require the item to be available for a service order.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the Shortcut Dimension 1, which is defined in the Shortcut Dimension 1 Code field in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the Shortcut Dimension 2, which is specified in the Shortcut Dimension 2 Code field in the General Ledger Setup window.';
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
                action("Insert Ext. Texts")
                {
                    AccessByPermission = TableData "Extended Text Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Insert &Ext. Text';
                    Image = Text;

                    trigger OnAction()
                    begin
                        InsertExtendedText(true);
                    end;
                }
                action("Insert Starting Fee")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Starting Fee';
                    Image = InsertStartingFee;

                    trigger OnAction()
                    begin
                        InsertStartFee;
                    end;
                }
                action("Insert Travel Fee")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Travel Fee';
                    Image = InsertTravelFee;

                    trigger OnAction()
                    begin
                        InsertTravelFee;
                    end;
                }
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        Find;
                        ShowReservation;
                    end;
                }
                action("Order Tracking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Order Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        Find;
                        ShowTracking;
                    end;
                }
                action("&Nonstock Items")
                {
                    AccessByPermission = TableData "Nonstock Item"=R;
                    ApplicationArea = Basic;
                    Caption = '&Nonstock Items';
                    Image = NonStockItem;

                    trigger OnAction()
                    begin
                        ShowNonstock;
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
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByVariant);
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
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByBOM);
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
                action("Select Item Substitution")
                {
                    AccessByPermission = TableData "Item Substitution"=R;
                    ApplicationArea = Basic;
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        SelectItemSubstitution;
                    end;
                }
                action("&Fault/Resol. Codes Relationships")
                {
                    ApplicationArea = Basic;
                    Caption = '&Fault/Resol. Codes Relationships';
                    Image = FaultDefault;

                    trigger OnAction()
                    begin
                        SelectFaultResolutionCode;
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
                separator(Action3)
                {
                }
                action("Order &Promising Line")
                {
                    AccessByPermission = TableData "Order Promising Line"=R;
                    ApplicationArea = Basic;
                    Caption = 'Order &Promising Line';

                    trigger OnAction()
                    begin
                        ShowOrderPromisingLine;
                    end;
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
        ReserveServLine: Codeunit "Service Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
          Commit;
          if not ReserveServLine.DeleteLineConfirm(Rec) then
            exit(false);
          ReserveServLine.DeleteLine(Rec);
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Line No." := GetNextLineNo(xRec,BelowxRec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := xRec.Type;
        Clear(ShortcutDimCode);
        Validate("Service Item Line No.",ServItemLineNo);
    end;

    var
        Text000: label 'You cannot open the window because %1 is %2 in the %3 table.';
        ServMgtSetup: Record "Service Mgt. Setup";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ServItemLineNo: Integer;
        ShortcutDimCode: array [8] of Code[20];


    procedure SetValues(TempServItemLineNo: Integer)
    begin
        ServItemLineNo := TempServItemLineNo;
        SetFilter("Service Item Line No.",'=%1|=%2',0,ServItemLineNo);
    end;

    local procedure InsertStartFee()
    var
        ServOrderMgt: Codeunit ServOrderManagement;
    begin
        Clear(ServOrderMgt);
        if ServOrderMgt.InsertServCost(Rec,1,true) then
          CurrPage.Update;
    end;

    local procedure InsertTravelFee()
    var
        ServOrderMgt: Codeunit ServOrderManagement;
    begin
        Clear(ServOrderMgt);
        if ServOrderMgt.InsertServCost(Rec,0,true) then
          CurrPage.Update;
    end;

    local procedure InsertExtendedText(Unconditionally: Boolean)
    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
    begin
        if TransferExtendedText.ServCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          TransferExtendedText.InsertServExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          CurrPage.Update;
    end;

    local procedure ShowReservationEntries()
    begin
        ShowReservationEntries(true);
    end;

    local procedure SelectFaultResolutionCode()
    var
        ServItemLine: Record "Service Item Line";
        FaultResolutionRelation: Page "Fault/Resol. Cod. Relationship";
    begin
        ServMgtSetup.Get;
        case ServMgtSetup."Fault Reporting Level" of
          ServMgtSetup."fault reporting level"::None:
            Error(
              Text000,
              ServMgtSetup.FieldCaption("Fault Reporting Level"),ServMgtSetup."Fault Reporting Level",ServMgtSetup.TableCaption);
        end;
        ServItemLine.Get("Document Type","Document No.","Service Item Line No.");
        Clear(FaultResolutionRelation);
        FaultResolutionRelation.SetDocument(Database::"Service Line","Document Type","Document No.","Line No.");
        FaultResolutionRelation.SetFilters("Symptom Code","Fault Code","Fault Area Code",ServItemLine."Service Item Group Code");
        FaultResolutionRelation.RunModal;
        CurrPage.Update(false);
    end;

    local procedure SelectItemSubstitution()
    begin
        ShowItemSub;
        Modify;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);

        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("No." <> xRec."No.")
        then begin
          CurrPage.SaveRecord;
          AutoReserve(true);
          CurrPage.Update(false);
        end;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Location Code" <> xRec."Location Code")
        then begin
          CurrPage.SaveRecord;
          AutoReserve(true);
          CurrPage.Update(false);
        end;
    end;

    local procedure QuantityOnAfterValidate()
    begin
        if Type = Type::Item then
          case Reserve of
            Reserve::Always:
              begin
                CurrPage.SaveRecord;
                AutoReserve(true);
                CurrPage.Update(false);
              end;
            Reserve::Optional:
              if (Quantity < xRec.Quantity) and (xRec.Quantity > 0) then begin
                CurrPage.SaveRecord;
                CurrPage.Update(false);
              end;
          end;
    end;

    local procedure PostingDateOnAfterValidate()
    begin
        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Posting Date" <> xRec."Posting Date")
        then begin
          CurrPage.SaveRecord;
          AutoReserve(true);
          CurrPage.Update(false);
        end;
    end;
}

