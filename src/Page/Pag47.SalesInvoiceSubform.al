#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 47 "Sales Invoice Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type"=filter(Invoice));

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
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that explains why the item is returned.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Visible = LocationCodeVisible;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin from where items on the sales order line are taken from when they are shipped.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies how many units are being sold.';

                    trigger OnValidate()
                    begin
                        ValidateAutoReserve;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    ToolTip = 'Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.';

                    trigger OnValidate()
                    begin
                        ValidateAutoReserve;
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
                field(PriceExists;PriceExists)
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
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
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
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                    Visible = TaxGroupCodeVisible;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
                    ToolTip = 'Specifies the line discount percentage that is valid for the item quantity on the line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
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
                field(LineDiscExists;LineDiscExists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Line Disc. Exists';
                    Editable = false;
                    ToolTip = 'Specifies that there is a specific discount for this customer.';
                    Visible = false;
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
                    ToolTip = 'Specifies the quantity of the item charge that will be assigned to a specified item when you post this sales line.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        ShowItemChargeAssgnt;
                        UpdatePage(false);
                    end;
                }
                field("Qty. Assigned";"Qty. Assigned")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        ShowItemChargeAssgnt;
                        UpdatePage(false);
                    end;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = JobRowEditable;
                    ToolTip = 'Specifies the job number that the sales line is linked to.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    Editable = JobRowEditable;
                    ToolTip = 'Specifies the number of the job task that the sales line is linked to.';
                    Visible = false;
                }
                field("Job Contract Entry No.";"Job Contract Entry No.")
                {
                    ApplicationArea = Jobs;
                    Editable = JobRowEditable;
                    ToolTip = 'Specifies the entry number of the job planning line that the sales line is linked to.';
                    Visible = false;
                }
                field("Tax Category";"Tax Category")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax category in connection with electronic document sending. For example, when you send sales documents through the PEPPOL service, the value in this field is used to populate several fields, such as the ClassifiedTaxCategory element in the Item group. It is also used to populate the TaxCategory element in both the TaxSubtotal and AllowanceCharge group. The number is based on the UNCL5305 standard.';
                    Visible = false;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                    Visible = false;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
                    Visible = false;
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Belongs to the Job application area.';
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
                        ValidateSaveShortcutDimCode(3,ShortcutDimCode[3]);
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
                        ValidateSaveShortcutDimCode(4,ShortcutDimCode[4]);
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
            group(Control39)
            {
                group(Control33)
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
                group(Control15)
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
                    action("Get &Price")
                    {
                        AccessByPermission = TableData "Sales Price"=R;
                        ApplicationArea = Basic;
                        Caption = 'Get &Price';
                        Ellipsis = true;
                        Image = Price;

                        trigger OnAction()
                        begin
                            ShowPrices
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
                    action("E&xplode BOM")
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
                    action(InsertExtTexts)
                    {
                        AccessByPermission = TableData "Extended Text Header"=R;
                        ApplicationArea = Suite;
                        Caption = 'Insert &Ext. Text';
                        Image = Text;
                        Scope = Repeater;
                        ToolTip = 'Insert the extended item description that is set up for the item on the sales document line.';

                        trigger OnAction()
                        begin
                            InsertExtendedText(true);
                        end;
                    }
                    action(GetShipmentLines)
                    {
                        AccessByPermission = TableData "Sales Shipment Header"=R;
                        ApplicationArea = Basic;
                        Caption = 'Get &Shipment Lines';
                        Ellipsis = true;
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            GetShipment;
                        end;
                    }
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
                    action(Dimensions)
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Suite;
                        Caption = 'Dimensions';
                        Image = Dimensions;
                        Scope = Repeater;
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

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
                            ShowItemChargeAssgnt;
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
                    action(DeferralSchedule)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Deferral Schedule';
                        Enabled = "Deferral Code" <> '';
                        Image = PaymentPeriod;
                        ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';

                        trigger OnAction()
                        begin
                            TotalSalesHeader.Get("Document Type","Document No.");
                            ShowDeferrals(TotalSalesHeader."Posting Date",TotalSalesHeader."Currency Code");
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateTotals;
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
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        Currency: Record Currency;
        SalesSetup: Record "Sales & Receivables Setup";
        ApplicationAreaSetup: Record "Application Area Setup";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        ShortcutDimCode: array [8] of Code[20];
        UpdateAllowedVar: Boolean;
        Text000: label 'Unable to run this function while in View mode.';
        JobRowEditable: Boolean;
        LocationCodeVisible: Boolean;
        InvDiscAmountEditable: Boolean;
        RowIsText: Boolean;
        TaxGroupCodeVisible: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Disc. (Yes/No)",Rec);
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get("Document Type","Document No.");
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
        CurrPage.Update(false);
    end;


    procedure CalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Calc. Discount",Rec);
    end;


    procedure ExplodeBOM()
    begin
        Codeunit.Run(Codeunit::"Sales-Explode BOM",Rec);
    end;


    procedure GetShipment()
    begin
        Codeunit.Run(Codeunit::"Sales-Get Shipment",Rec);
    end;


    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          Commit;
          TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          UpdatePage(true);
    end;


    procedure UpdatePage(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;


    procedure ShowPrices()
    begin
        TotalSalesHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(TotalSalesHeader,Rec);
    end;


    procedure ShowLineDisc()
    begin
        TotalSalesHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(TotalSalesHeader,Rec);
    end;


    procedure SetUpdateAllowed(UpdateAllowed: Boolean)
    begin
        UpdateAllowedVar := UpdateAllowed;
    end;


    procedure UpdateAllowed(): Boolean
    begin
        if UpdateAllowedVar = false then begin
          Message(Text000);
          exit(false);
        end;
        exit(true);
    end;

    local procedure NoOnAfterValidate()
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          TestField(Type,Type::Item);
        InsertExtendedText(false);

        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and (xRec."No." <> '') then
          CurrPage.SaveRecord;
    end;

    local procedure UpdateEditableOnRow()
    var
        SalesLine: Record "Sales Line";
    begin
        JobRowEditable := "Job No." = '';
        RowIsText := ("No." = '') and (Description <> '');
        if not RowIsText then
          UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        else
          UnitofMeasureCodeIsChangeable := false;

        if TotalSalesHeader."No." <> '' then begin
          SalesLine.SetRange("Document No.",TotalSalesHeader."No.");
          SalesLine.SetRange("Document Type",TotalSalesHeader."Document Type");
          if not SalesLine.IsEmpty then
            InvDiscAmountEditable :=
              SalesCalcDiscByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") and CurrPage.Editable;
        end;
    end;

    local procedure ValidateAutoReserve()
    begin
        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          AutoReserve;
        end;
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
        InvoiceDiscountPct := SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord;

        TotalSalesHeader.Get("Document Type","Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
        CurrPage.Update;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SaveRecord;
    end;
}

