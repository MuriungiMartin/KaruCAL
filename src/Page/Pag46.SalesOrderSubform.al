#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 46 "Sales Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type"=filter(Order));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                        SetLocationCodeMandatory;

                        if xRec."No." <> '' then
                          RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                        UpdateEditableOnRow;
                        ShowShortcutDimCode(ShortcutDimCode);

                        QuantityOnAfterValidate;
                        if xRec."No." <> '' then
                          RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CrossReferenceNoLookUp;
                        NoOnAfterValidate;
                    end;

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                    end;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the IC partner code of the partner to whom you want to distribute the revenue of the sales line.';
                    Visible = false;
                }
                field("IC Partner Ref. Type";"IC Partner Ref. Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.';
                    Visible = false;
                }
                field("IC Partner Reference";"IC Partner Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        VariantCodeOnAfterValidate;
                    end;
                }
                field("Substitution Available";"Substitution Available")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that a substitute is available for the item on the sales line.';
                    Visible = false;
                }
                field("Purchasing Code";"Purchasing Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the purchasing code for the item.';
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that this item is a nonstock item.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the tax product posting group of the item, resource, or general ledger account on this line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a description of the entry, which is based on the contents of the Type and No. fields.';

                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow;

                        if "No." = xRec."No." then
                          exit;

                        NoOnAfterValidate;
                        ShowShortcutDimCode(ShortcutDimCode);
                        if xRec."No." <> '' then
                          RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if your vendor will ship the items on the line directly to your customer.';
                    Visible = false;
                }
                field("Special Order";"Special Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the item on the sales line is a special-order item.';
                    Visible = false;
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that explains why the item is returned.';
                    Visible = false;
                }
                field("Package Tracking No.";"Package Tracking No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping agent''s package number.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                    ShowMandatory = LocationCodeMandatory;
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Visible = LocationCodeVisible;

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate;
                    end;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin from where items on the sales order line are taken from when they are shipped.';
                    Visible = false;
                }
                field(Control50;Reserve)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether a reservation can be made for items on this line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveOnAfterValidate;
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies how many units are being sold.';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Qty. to Assemble to Order";"Qty. to Assemble to Order")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the sales line quantity that you want to supply by assembly.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        ShowAsmToOrderLines;
                    end;

                    trigger OnValidate()
                    begin
                        QtyToAsmToOrderOnAfterValidate;
                    end;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    QuickEntry = false;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    QuickEntry = false;
                    ToolTip = 'Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.';

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the item or resource on the sales line.';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit cost of the item on the line.';
                    Visible = false;
                }
                field(SalesPriceExist;PriceExists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Price Exists';
                    Editable = false;
                    ToolTip = 'Specifies that there is a specific price for this customer.';
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies the price for one unit on the sales line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                    Visible = false;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                    Visible = TaxGroupCodeVisible;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sum of the amounts in the Amount Including Tax fields on the associated sales lines.';
                }
                field(SalesLineDiscExists;LineDiscExists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Line Disc. Exists';
                    Editable = false;
                    ToolTip = 'Specifies that there is a specific discount for this customer.';
                    Visible = false;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ToolTip = 'Specifies the line discount percentage that is valid for the item quantity on the line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the discount that will be given on the invoice line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepayment %";"Prepayment %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the prepayment percentage if a prepayment should apply to the sales line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepmt. Line Amount";"Prepmt. Line Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the prepayment amount of the line in the currency of the sales document if a prepayment percentage is specified for the sales line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepmt. Amt. Inv.";"Prepmt. Amt. Inv.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the prepayment amount that has already been invoiced to the customer for this sales line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the invoice line is included when the invoice discount is calculated.';
                    Visible = false;
                }
                field("Inv. Discount Amount";"Inv. Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the invoice discount amount for the line.';
                    Visible = false;
                }
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item are to be shipped when the sales order is posted.';

                    trigger OnValidate()
                    begin
                        if "Qty. to Asm. to Order (Base)" <> 0 then begin
                          CurrPage.SaveRecord;
                          CurrPage.Update(false);
                        end;
                    end;
                }
                field("Quantity Shipped";"Quantity Shipped")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    QuickEntry = false;
                    ToolTip = 'Specifies the number of units of the ordered item that have been shipped.';
                }
                field("Qty. to Invoice";"Qty. to Invoice")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how much of the line should be invoiced.';
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item on the line have already been invoiced.';
                }
                field("Prepmt Amt to Deduct";"Prepmt Amt to Deduct")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the prepayment amount that will be deducted from the next ordinary invoice for this line.';
                    Visible = false;
                }
                field("Prepmt Amt Deducted";"Prepmt Amt Deducted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.';
                    Visible = false;
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
                    QuickEntry = false;
                    ToolTip = 'Specifies the quantity of the item charge that will be assigned to a specified item when you post this sales line. You fill this field through the Qty. to Assign field in the Item Charge Assignment (Sales) window that you open with the Item Charge Assignment action on the Lines FastTab.';

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
                    QuickEntry = false;
                    ToolTip = 'Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        ShowItemChargeAssgnt;
                        CurrPage.Update(false);
                    end;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Planned Delivery Date";"Planned Delivery Date")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                    ToolTip = 'Specifies the planned date that the shipment will be delivered at the customer''s address.';

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Planned Shipment Date";"Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that the shipment should ship from the warehouse.';

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    ToolTip = 'Specifies the date that the items on the line are in inventory and available to be picked.';

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code that represents the shipping agent.';
                    Visible = false;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code that represents a shipping agent service.';
                    Visible = false;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how long it takes from when the sales order line is shipped from the warehouse to when the order is delivered.';
                    Visible = false;
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Belongs to the Job application area.';
                    Visible = false;
                }
                field("Whse. Outstanding Qty.";"Whse. Outstanding Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units on the sales order line remain to be handled in warehouse documents.';
                    Visible = false;
                }
                field("Whse. Outstanding Qty. (Base)";"Whse. Outstanding Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units on the sales order line remain to be handled in warehouse documents.';
                    Visible = false;
                }
                field("ATO Whse. Outstanding Qty.";"ATO Whse. Outstanding Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many assemble-to-order units on the sales order line need to be assembled and handled in warehouse documents.';
                    Visible = false;
                }
                field("ATO Whse. Outstd. Qty. (Base)";"ATO Whse. Outstd. Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many assemble-to-order units on the sales order line remain to be assembled and handled in warehouse documents.';
                    Visible = false;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the outbound warehouse handling time.';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the blanket order from which this sales line originates.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number of the blanket order line from which this sales line originates.';
                    Visible = false;
                }
                field("FA Posting Date";"FA Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that will be used as the FA posting date on FA ledger entries.';
                    Visible = false;
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Use Duplication List";"Use Duplication List")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Duplicate in Depreciation Book";"Duplicate in Depreciation Book")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item ledger entry that the sales credit memo line is applied from.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the item ledger entry number the line should be applied to.';
                    Visible = false;
                }
                field("Deferral Code";"Deferral Code")
                {
                    ApplicationArea = Suite;
                    Enabled = (Type <> Type::"Fixed Asset") and (Type <> Type::" ");
                    TableRelation = "Deferral Template"."Deferral Code";
                    ToolTip = 'Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
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
                        ValidateSaveShortcutDimCode(5,ShortcutDimCode[5]);
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
                        ValidateSaveShortcutDimCode(6,ShortcutDimCode[6]);
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
                        ValidateSaveShortcutDimCode(7,ShortcutDimCode[7]);
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
                        ValidateSaveShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                    Visible = false;
                }
            }
            group(Control51)
            {
                group(Control45)
                {
                    field("TotalSalesLine.""Line Amount""";TotalSalesLine."Line Amount")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code,TotalSalesHeader."Prices Including VAT");
                        Caption = 'Subtotal Excl. Tax';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document.';
                    }
                    field("Invoice Discount Amount";InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(FIELDCAPTION("Inv. Discount Amount"),Currency.Code);
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. Tax field. You can enter or change the amount manually.';

                        trigger OnValidate()
                        begin
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                    field("Invoice Disc. Pct.";InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0:2;
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';

                        trigger OnValidate()
                        begin
                            InvoiceDiscountAmount := ROUND(TotalSalesLine."Line Amount" * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                }
                group(Control28)
                {
                    field("Total Amount Excl. VAT";TotalSalesLine.Amount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                        Caption = 'Total Amount Excl. Tax';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount";VATAmount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                        Caption = 'Total Tax';
                        Editable = false;
                        ToolTip = 'Specifies the sum of tax amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT";TotalSalesLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                        Caption = 'Total Amount Incl. Tax';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. Tax field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
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
                group("F&unctions")
                {
                    Caption = 'F&unctions';
                    Image = "Action";
                    action(GetPrice)
                    {
                        AccessByPermission = TableData "Sales Price"=R;
                        ApplicationArea = Basic;
                        Caption = 'Get Price';
                        Ellipsis = true;
                        Image = Price;

                        trigger OnAction()
                        begin
                            ShowPrices;
                        end;
                    }
                    action("Get Li&ne Discount")
                    {
                        AccessByPermission = TableData "Sales Line Discount"=R;
                        ApplicationArea = Basic;
                        Caption = 'Get Li&ne Discount';
                        Ellipsis = true;
                        Image = LineDiscount;

                        trigger OnAction()
                        begin
                            ShowLineDisc
                        end;
                    }
                    action(ExplodeBOM_Functions)
                    {
                        AccessByPermission = TableData "BOM Component"=R;
                        ApplicationArea = Basic;
                        Caption = 'E&xplode BOM';
                        Image = ExplodeBOM;

                        trigger OnAction()
                        begin
                            ExplodeBOM;
                        end;
                    }
                    action("Insert Ext. Texts")
                    {
                        AccessByPermission = TableData "Extended Text Header"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Insert &Ext. Text';
                        Image = Text;
                        ToolTip = 'Insert the extended item description that is set up for the item on the sales document line.';

                        trigger OnAction()
                        begin
                            InsertExtendedText(true);
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
                            Find;
                            ShowReservation;
                        end;
                    }
                    action(OrderTracking)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Order &Tracking';
                        Image = OrderTracking;

                        trigger OnAction()
                        begin
                            ShowTracking;
                        end;
                    }
                    action("Nonstoc&k Items")
                    {
                        AccessByPermission = TableData "Nonstock Item"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Nonstoc&k Items';
                        Image = NonStockItem;

                        trigger OnAction()
                        begin
                            ShowNonstockItems;
                        end;
                    }
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("<Action3>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByVariant)
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
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
                group("Related Information")
                {
                    Caption = 'Related Information';
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
                    action(ItemTrackingLines)
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
                    action("Select Item Substitution")
                    {
                        AccessByPermission = TableData "Item Substitution"=R;
                        ApplicationArea = Suite;
                        Caption = 'Select Item Substitution';
                        Image = SelectItemSubstitution;
                        ToolTip = 'Select another item that has been set up to be sold instead of the original item if it is unavailable.';

                        trigger OnAction()
                        begin
                            ShowItemSub;
                        end;
                    }
                    action(Dimensions)
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Basic;
                        Caption = 'Dimensions';
                        Image = Dimensions;
                        ShortCutKey = 'Shift+Ctrl+D';

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

                        trigger OnAction()
                        begin
                            ShowLineComments;
                        end;
                    }
                    action("Item Charge &Assignment")
                    {
                        AccessByPermission = TableData "Item Charge"=R;
                        ApplicationArea = Basic;
                        Caption = 'Item Charge &Assignment';
                        Image = ItemCosts;

                        trigger OnAction()
                        begin
                            ItemChargeAssgnt;
                        end;
                    }
                    action(OrderPromising)
                    {
                        AccessByPermission = TableData "Order Promising Line"=R;
                        ApplicationArea = Basic;
                        Caption = 'Order &Promising';
                        Image = OrderPromising;

                        trigger OnAction()
                        begin
                            OrderPromisingLine;
                        end;
                    }
                    group("Assemble to Order")
                    {
                        Caption = 'Assemble to Order';
                        Image = AssemblyBOM;
                        action(AssembleToOrderLines)
                        {
                            AccessByPermission = TableData "BOM Component"=R;
                            ApplicationArea = Basic;
                            Caption = 'Assemble-to-Order Lines';

                            trigger OnAction()
                            begin
                                ShowAsmToOrderLines;
                            end;
                        }
                        action("Roll Up &Price")
                        {
                            AccessByPermission = TableData "BOM Component"=R;
                            ApplicationArea = Basic;
                            Caption = 'Roll Up &Price';
                            Ellipsis = true;

                            trigger OnAction()
                            begin
                                RollupAsmPrice;
                            end;
                        }
                        action("Roll Up &Cost")
                        {
                            AccessByPermission = TableData "BOM Component"=R;
                            ApplicationArea = Basic;
                            Caption = 'Roll Up &Cost';
                            Ellipsis = true;

                            trigger OnAction()
                            begin
                                RollUpAsmCost;
                            end;
                        }
                    }
                    action(DeferralSchedule)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Deferral Schedule';
                        Enabled = "Deferral Code" <> '';
                        Image = PaymentPeriod;
                        ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';

                        trigger OnAction()
                        begin
                            SalesHeader.Get("Document Type","Document No.");
                            ShowDeferrals(SalesHeader."Posting Date",SalesHeader."Currency Code");
                        end;
                    }
                }
            }
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                group("Dr&op Shipment")
                {
                    Caption = 'Dr&op Shipment';
                    Image = Delivery;
                    action("Purchase &Order")
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Header"=R;
                        ApplicationArea = Suite;
                        Caption = 'Purchase &Order';
                        Image = Document;
                        ToolTip = 'View the purchase order that is linked to the sales order, for drop shipment.';

                        trigger OnAction()
                        begin
                            OpenPurchOrderForm;
                        end;
                    }
                }
                group("Speci&al Order")
                {
                    Caption = 'Speci&al Order';
                    Image = SpecialOrder;
                    action(OpenSpecialPurchaseOrder)
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Header"=R;
                        ApplicationArea = Basic;
                        Caption = 'Purchase &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            OpenSpecialPurchOrderForm;
                        end;
                    }
                }
                action(BlanketOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Blanket Order';
                    Image = BlanketOrder;
                    ToolTip = 'View the blanket sales order.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        BlanketSalesOrder: Page "Blanket Sales Order";
                    begin
                        TestField("Blanket Order No.");
                        SalesHeader.SetRange("No.","Blanket Order No.");
                        if not SalesHeader.IsEmpty then begin
                          BlanketSalesOrder.SetTableview(SalesHeader);
                          BlanketSalesOrder.Editable := false;
                          BlanketSalesOrder.Run;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateTotals;
        SetLocationCodeMandatory;
        UpdateEditableOnRow;
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
          Commit;
          if not ReserveSalesLine.DeleteLineConfirm(Rec) then
            exit(false);
          ReserveSalesLine.DeleteLine(Rec);
        end;
    end;

    trigger OnInit()
    begin
        SalesSetup.Get;
        Currency.InitRoundingPrecision;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          Type := Type::Item;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          Type := Type::Item
        else
          InitType;
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        Location: Record Location;
        TaxGroup: Record "Tax Group";
    begin
        if Location.ReadPermission then
          LocationCodeVisible := not Location.IsEmpty;
        TaxGroupCodeVisible := not TaxGroup.IsEmpty;
    end;

    var
        Currency: Record Currency;
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        ApplicationAreaSetup: Record "Application Area Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;
        ShortcutDimCode: array [8] of Code[20];
        Text001: label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        LocationCodeMandatory: Boolean;
        InvDiscAmountEditable: Boolean;
        RowIsNotText: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        LocationCodeVisible: Boolean;
        TaxGroupCodeVisible: Boolean;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Disc. (Yes/No)",Rec);
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get("Document Type","Document No.");
        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
        CurrPage.Update(false);
    end;


    procedure CalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Calc. Discount",Rec);
    end;


    procedure ExplodeBOM()
    begin
        if "Prepmt. Amt. Inv." <> 0 then
          Error(Text001);
        Codeunit.Run(Codeunit::"Sales-Explode BOM",Rec);
    end;


    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
    begin
        TestField("Purchase Order No.");
        PurchHeader.SetRange("No.","Purchase Order No.");
        PurchOrder.SetTableview(PurchHeader);
        PurchOrder.Editable := false;
        PurchOrder.Run;
    end;


    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
    begin
        TestField("Special Order Purchase No.");
        PurchHeader.SetRange("No.","Special Order Purchase No.");
        if not PurchHeader.IsEmpty then begin
          PurchOrder.SetTableview(PurchHeader);
          PurchOrder.Editable := false;
          PurchOrder.Run;
        end else begin
          PurchRcptHeader.SetRange("Order No.","Special Order Purchase No.");
          if PurchRcptHeader.Count = 1 then
            Page.Run(Page::"Posted Purchase Receipt",PurchRcptHeader)
          else
            Page.Run(Page::"Posted Purchase Receipts",PurchRcptHeader);
        end;
    end;


    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          Commit;
          TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          UpdateForm(true);
    end;


    procedure ShowNonstockItems()
    begin
        ShowNonstock;
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


    procedure ShowPrices()
    begin
        SalesHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
    end;


    procedure ShowLineDisc()
    begin
        SalesHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
    end;


    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
        OrderPromisingLines: Page "Order Promising Lines";
    begin
        OrderPromisingLine.SetRange("Source Type","Document Type");
        OrderPromisingLine.SetRange("Source ID","Document No.");
        OrderPromisingLine.SetRange("Source Line No.","Line No.");

        OrderPromisingLines.SetSourceType(OrderPromisingLine."source type"::Sales);
        OrderPromisingLines.SetTableview(OrderPromisingLine);
        OrderPromisingLines.RunModal;
    end;

    local procedure NoOnAfterValidate()
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          TestField(Type,Type::Item);

        InsertExtendedText(false);
        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and
           (xRec."No." <> '')
        then
          CurrPage.SaveRecord;

        SaveAndAutoAsmToOrder;

        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          if ("Outstanding Qty. (Base)" <> 0) and ("No." <> xRec."No.") then begin
            AutoReserve;
            CurrPage.Update(false);
          end;
        end;
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;

        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Location Code" <> xRec."Location Code")
        then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure ReserveOnAfterValidate()
    begin
        if (Reserve = Reserve::Always) and ("Outstanding Qty. (Base)" <> 0) then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure QuantityOnAfterValidate()
    var
        UpdateIsDone: Boolean;
    begin
        if Type = Type::Item then
          case Reserve of
            Reserve::Always:
              begin
                CurrPage.SaveRecord;
                AutoReserve;
                CurrPage.Update(false);
                UpdateIsDone := true;
              end;
            Reserve::Optional:
              if (Quantity < xRec.Quantity) and (xRec.Quantity > 0) then begin
                CurrPage.SaveRecord;
                CurrPage.Update(false);
                UpdateIsDone := true;
              end;
          end;

        if (Type = Type::Item) and
           (Quantity <> xRec.Quantity) and
           not UpdateIsDone
        then
          CurrPage.Update(true);
    end;

    local procedure QtyToAsmToOrderOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        if Reserve = Reserve::Always then
          AutoReserve;
        CurrPage.Update(true);
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Shipment Date" <> xRec."Shipment Date")
        then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end else
          CurrPage.Update(true);
    end;

    local procedure SaveAndAutoAsmToOrder()
    begin
        if (Type = Type::Item) and IsAsmToOrderRequired then begin
          CurrPage.SaveRecord;
          AutoAsmToOrder;
          CurrPage.Update(false);
        end;
    end;

    local procedure SetLocationCodeMandatory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get;
        LocationCodeMandatory := InventorySetup."Location Mandatory" and (Type = Type::Item);
    end;

    local procedure GetTotalSalesHeader()
    begin
        if not TotalSalesHeader.Get("Document Type","Document No.") then
          Clear(TotalSalesHeader);
        if Currency.Code <> TotalSalesHeader."Currency Code" then
          if not Currency.Get(TotalSalesHeader."Currency Code") then
            Currency.InitRoundingPrecision;
    end;

    local procedure CalculateTotals()
    begin
        GetTotalSalesHeader;
        TotalSalesHeader.CalcFields("Recalculate Invoice Disc.");

        if SalesSetup."Calc. Inv. Discount" and ("Document No." <> '') and (TotalSalesHeader."Customer Posting Group" <> '') and
           TotalSalesHeader."Recalculate Invoice Disc."
        then
          CalcInvDisc;

        DocumentTotals.CalculateSalesTotals(TotalSalesLine,VATAmount,Rec);
        InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
        InvoiceDiscountPct := SalesCalcDiscountByType.GetCustInvoiceDiscountPct(Rec);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord;

        SalesHeader.Get("Document Type","Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
        CurrPage.Update;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SaveRecord;
    end;

    local procedure UpdateEditableOnRow()
    var
        SalesLine: Record "Sales Line";
    begin
        RowIsNotText := not (("No." = '') and (Description <> ''));
        if RowIsNotText then
          UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        else
          UnitofMeasureCodeIsChangeable := false;

        if TotalSalesHeader."No." <> '' then begin
          SalesLine.SetRange("Document No.",TotalSalesHeader."No.");
          SalesLine.SetRange("Document Type",TotalSalesHeader."Document Type");
          if not SalesLine.IsEmpty then
            InvDiscAmountEditable :=
              SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") and CurrPage.Editable;
        end;
    end;
}

