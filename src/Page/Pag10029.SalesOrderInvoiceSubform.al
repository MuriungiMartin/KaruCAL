#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10029 "Sales Order Invoice Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type"=filter(Order),
                            "Qty. Shipped Not Invoiced"=filter(<>0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of the record on the document line. ';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;
                    end;
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the cross-reference number of the item specified on the line.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // Item Cross Ref - start
                        if Type = Type::Item then begin
                          SalesHeader.Get("Document Type","Document No.");
                          ItemCrossReference.Reset;
                          ItemCrossReference.SetCurrentkey("Cross-Reference Type","Cross-Reference Type No.");
                          ItemCrossReference.SetRange("Cross-Reference Type",ItemCrossReference."cross-reference type"::Customer);
                          ItemCrossReference.SetRange("Cross-Reference Type No.",SalesHeader."Sell-to Customer No.");
                          if Page.RunModal(Page::"Cross Reference List",ItemCrossReference) = Action::LookupOK then begin
                            Validate("Cross-Reference No.",ItemCrossReference."Cross-Reference No.");
                            InsertExtendedText(false);
                          end;
                        end;
                        // Item Cross Ref - end
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Substitution Available";"Substitution Available")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Purchasing Code";"Purchasing Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a description of the invoice line.';
                }
                field(Control26;"Drop Shipment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Control106;"Special Order")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Package Tracking No.";"Package Tracking No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the shipping agent''s package number.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of items on document line.';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the item''s unit of measure. ';

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the price for one unit of the item. ';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the amount of the sales line, calculated as the quantity times the unit price minus any percentage value in the Line Discount % field. If the Prices Including Tax check box on the customer card is selected, the amount includes tax.';
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of the amounts in the Amount Including Tax fields on the associated sales lines.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the discount percentage that is granted to the amount on the line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if  the invoice line can be included in a possible invoice discount calculation. The value is copied from the Allow Invoice Disc. field on the sales line.';
                    Visible = false;
                }
                field("Inv. Discount Amount";"Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Shipped";"Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies how many of the units in the Quantity field have been posted as shipped.';
                }
                field("Qty. to Invoice";"Qty. to Invoice")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies how many of the units in the Quantity field to post as invoiced. ';
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies how many of the units in the Quantity field have been posted as invoiced.';
                }
                field("Allow Item Charge Assignment";"Allow Item Charge Assignment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you can assign item charges to this line.';
                    Visible = false;
                }
                field("Qty. to Assign";"Qty. to Assign")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        ShowItemChargeAssgnt;
                        UpdateForm(false);
                    end;
                }
                field("Qty. Assigned";"Qty. Assigned")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        ShowItemChargeAssgnt;
                        CurrPage.Update(false);
                    end;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date that the items on the line are in inventory and available to be picked. The shipment date is the date you expect to ship the items on the line.';
                }
                field("FA Posting Date";"FA Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
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
                group("Drop Shipment")
                {
                    Caption = 'Drop Shipment';
                    Image = Delivery;
                    action("Purchase &Order")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            OpenPurchOrderForm;
                        end;
                    }
                }
                group("Special Order")
                {
                    Caption = 'Special Order';
                    Image = SpecialOrder;
                    action(Action1902819104)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            OpenPurchOrderForm;
                        end;
                    }
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Item Charge &Assignment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Charge &Assignment';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        ItemChargeAssgnt;
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := xRec.Type;
        Clear(ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        ItemCrossReference: Record "Item Cross Reference";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ShortcutDimCode: array [8] of Code[20];


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Disc. (Yes/No)",Rec);
    end;


    procedure CalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Calc. Discount",Rec);
    end;


    procedure ExplodeBOM()
    begin
        Codeunit.Run(Codeunit::"Sales-Explode BOM",Rec);
    end;


    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
    begin
        PurchHeader.SetRange("No.","Purchase Order No.");
        PurchOrder.SetTableview(PurchHeader);
        PurchOrder.Editable := false;
        PurchOrder.Run;
    end;


    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          UpdateForm(true);
    end;


    procedure ShowReservation()
    begin
        Find;
        ShowReservation;
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        ItemAvailability(AvailabilityType);
    end;


    procedure ShowReservationEntries()
    begin
        ShowReservationEntries(true);
    end;


    procedure ShowDimensions()
    begin
        ShowDimensions;
    end;


    procedure ShowItemSub()
    begin
        ShowItemSub;
    end;


    procedure ShowNonstockItems()
    begin
        ShowNonstock;
    end;


    procedure OpenItemTrackingLines()
    begin
        OpenItemTrackingLines;
    end;


    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetSalesLine(Rec);
        TrackingForm.RunModal;
    end;


    procedure ItemChargeAssgnt()
    begin
        ShowItemChargeAssgnt;
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and
           (xRec."No." <> '')
        then
          CurrPage.SaveRecord;
    end;

    local procedure QuantityOnAfterValidate()
    begin
        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;
}

