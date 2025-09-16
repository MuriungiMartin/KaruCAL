#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 55 "Purch. Invoice Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
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
                    ToolTip = 'Specifies the line type.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;

                        if xRec."No." <> '' then
                          RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of a general ledger account, an item, an additional cost or a fixed asset, depending on what you selected in the Type field.';

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

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
                        InsertExtendedText(false);
                        NoOnAfterValidate;
                    end;

                    trigger OnValidate()
                    begin
                        CrossReferenceNoOnAfterValidat;
                        NoOnAfterValidate;
                    end;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the IC partner code of the partner to whom you want to distribute the cost of the line.';
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
                    ToolTip = 'If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner''s company that corresponds to the line.';
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
                field("GST/HST";"GST/HST")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of goods and services tax (GST) for the purchase line. You can select Acquisition, Self-Assessment, Rebate, New Housing Rebates, or Pension Rebate for the GST tax.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the tax product posting group of the item or general ledger account on this line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description/Comment';
                    ShowMandatory = true;
                    ToolTip = 'Specifies a description of the entry, which is based on the contents of the Type and No. fields.';

                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow;

                        if "No." = xRec."No." then
                          exit;

                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

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
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a bin code for the item.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies the number of units of the item that will be specified on the line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    ToolTip = 'Specifies the unit of measure code that is valid for the purchase line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the unit of measure for the item, such as 1 bottle or 1 piece.';
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies the direct unit cost of the item on the line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item''s indirect cost percentage.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit cost of the item on the line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the price for one unit of the item.';
                    Visible = false;

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
                field("Provincial Tax Area Code";"Provincial Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax area code for self assessed Provincial Sales Tax for the company.';
                    Visible = false;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
                    ShowMandatory = "Tax Area Code"<> '';
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                    Visible = TaxGroupCodeVisible;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Use Tax";"Use Tax")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the purchase is subject to use tax. Use tax is a sales tax that is paid on items that are purchased by a company and are used by that company instead of being sold to a customer.';
                    Visible = false;
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
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = not RowIsText;
                    Enabled = not RowIsText;
                    ToolTip = 'Specifies the line discount percentage that is valid for the item on the line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the line discount that will be granted on the purchase line.';
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
                    ToolTip = 'Specifies the quantity of the item charge that will be assigned when you post this line.';

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
                    ToolTip = 'Specifies how much of the item charge that has been assigned.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        ShowItemChargeAssgnt;
                        UpdateForm(false);
                    end;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the purchase order line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job task that corresponds to the purchase document (invoice or credit memo).';
                    Visible = false;
                }
                field("Job Line Type";"Job Line Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a Job Planning Line together with the posting of a job ledger entry.';
                    Visible = false;
                }
                field("Job Unit Price";"Job Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';
                    Visible = false;
                }
                field("Job Line Amount";"Job Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the net amount of the line that the purchase line applies to.';
                    Visible = false;
                }
                field("Job Line Discount Amount";"Job Line Discount Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount of the discount that the purchase line applies to.';
                    Visible = false;
                }
                field("Job Line Discount %";"Job Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line discount percent that applies to the item or general ledger expense.';
                    Visible = false;
                }
                field("Job Total Price";"Job Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the gross amount of the line that the purchase line applies to.';
                    Visible = false;
                }
                field("Job Unit Price (LCY)";"Job Unit Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';
                    Visible = false;
                }
                field("Job Total Price (LCY)";"Job Total Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the gross amount of the line, in the local currency.';
                    Visible = false;
                }
                field("Job Line Amount (LCY)";"Job Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the net amount of the line that the purchase line applies to.';
                    Visible = false;
                }
                field("Job Line Disc. Amount (LCY)";"Job Line Disc. Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount of the discount that the purchase line applies to.';
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the production order that the purchase order was created for.';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the blanket order from which this purchase line originates.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number of the blanket order line from which this purchase line originates.';
                    Visible = false;
                }
                field("Insurance No.";"Insurance No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an insurance number if you have selected the Acquisition Cost option in the FA Posting Type field.';
                    Visible = false;
                }
                field("Budgeted FA No.";"Budgeted FA No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the FA posting type if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Depr. Acquisition Cost";"Depr. Acquisition Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is relevant when you post an additional acquisition cost and a possible salvage value to an already acquired asset.';
                    Visible = false;
                }
                field("Duplicate in Depreciation Book";"Duplicate in Depreciation Book")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Use Duplication List";"Use Duplication List")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'You can use this field if you have selected Fixed Asset in the Type field for this line.';
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
                    ToolTip = 'Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.';
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
                field("IRS 1099 Liable";"IRS 1099 Liable")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the amount is to be a 1099 amount.';
                    Visible = false;
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
                    ToolTip = 'Specifies the line''s number.';
                    Visible = false;
                }
            }
            group(Control39)
            {
                group(Control33)
                {
                    field(AmountBeforeDiscount;TotalPurchaseLine."Line Amount")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code,TotalPurchaseHeader."Prices Including VAT");
                        Caption = 'Subtotal Excl. Tax';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document.';
                    }
                    field(InvoiceDiscountAmount;InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
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
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. Tax field. You can enter or change the amount manually.';

                        trigger OnValidate()
                        begin
                            InvoiceDiscountAmount := ROUND(TotalPurchaseLine."Line Amount" * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                }
                group(Control15)
                {
                    field("Total Amount Excl. VAT";TotalPurchaseLine.Amount)
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
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total Amount Incl. VAT";TotalPurchaseLine."Amount Including VAT")
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
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
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
                    ToolTip = 'Insert the extended description that is set up.';

                    trigger OnAction()
                    begin
                        InsertExtendedText(true);
                    end;
                }
                action(GetReceiptLines)
                {
                    AccessByPermission = TableData "Purch. Rcpt. Header"=R;
                    ApplicationArea = Basic;
                    Caption = '&Get Receipt Lines';
                    Ellipsis = true;
                    Image = Receipt;

                    trigger OnAction()
                    begin
                        GetReceipt;
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
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByVariant)
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
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByBOM)
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
                action(ItemChargeAssignment)
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
                    ToolTip = 'View or edit the deferral schedule that governs how expenses incurred with this purchase document is deferred to different accounting periods when the document is posted.';

                    trigger OnAction()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.Get("Document Type","Document No.");
                        ShowDeferrals(PurchHeader."Posting Date",PurchHeader."Currency Code");
                    end;
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
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
          Commit;
          if not ReservePurchLine.DeleteLineConfirm(Rec) then
            exit(false);
          ReservePurchLine.DeleteLine(Rec);
        end;
    end;

    trigger OnInit()
    begin
        PurchasesPayablesSetup.Get;
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
        TaxGroup: Record "Tax Group";
    begin
        TaxGroupCodeVisible := not TaxGroup.IsEmpty;
    end;

    var
        Currency: Record Currency;
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        TotalPurchaseHeader: Record "Purchase Header";
        TotalPurchaseLine: Record "Purchase Line";
        ApplicationAreaSetup: Record "Application Area Setup";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        DocumentTotals: Codeunit "Document Totals";
        ShortcutDimCode: array [8] of Code[20];
        VATAmount: Decimal;
        InvDiscAmountEditable: Boolean;
        RowIsText: Boolean;
        TaxGroupCodeVisible: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Purch.-Disc. (Yes/No)",Rec);
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Get("Document Type","Document No.");
        PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,PurchaseHeader);
        CurrPage.Update(false);
    end;

    local procedure CalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Purch.-Calc.Discount",Rec);
    end;

    local procedure ExplodeBOM()
    begin
        Codeunit.Run(Codeunit::"Purch.-Explode BOM",Rec);
    end;

    local procedure GetReceipt()
    begin
        Codeunit.Run(Codeunit::"Purch.-Get Receipt",Rec);
    end;

    local procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.PurchCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          TransferExtendedText.InsertPurchExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          UpdateForm(true);
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    local procedure NoOnAfterValidate()
    begin
        UpdateEditableOnRow;
        InsertExtendedText(false);
        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and
           (xRec."No." <> '')
        then
          CurrPage.SaveRecord;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord;

        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
        RecalculateTaxes;

        CurrPage.Update;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SaveRecord;
    end;

    local procedure UpdateEditableOnRow()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        RowIsText := ("No." = '') and (Description <> '');
        if not RowIsText then
          UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        else
          UnitofMeasureCodeIsChangeable := false;

        if TotalPurchaseHeader."No." <> '' then begin
          PurchaseLine.SetRange("Document No.",TotalPurchaseHeader."No.");
          PurchaseLine.SetRange("Document Type",TotalPurchaseHeader."Document Type");
          if not PurchaseLine.IsEmpty then
            InvDiscAmountEditable :=
              PurchCalcDiscByType.InvoiceDiscIsAllowed(TotalPurchaseHeader."Invoice Disc. Code") and CurrPage.Editable;
        end;
    end;

    local procedure GetTotalPurchHeader()
    begin
        if not TotalPurchaseHeader.Get("Document Type","Document No.") then
          Clear(TotalPurchaseHeader);
        if Currency.Code <> TotalPurchaseHeader."Currency Code" then
          if not Currency.Get(TotalPurchaseHeader."Currency Code") then
            Currency.InitRoundingPrecision;
    end;

    local procedure CalculateTotals()
    begin
        GetTotalPurchHeader;
        TotalPurchaseHeader.CalcFields("Recalculate Invoice Disc.");

        if PurchasesPayablesSetup."Calc. Inv. Discount" and ("Document No." <> '') and
           (TotalPurchaseHeader."Vendor Posting Group" <> '') and TotalPurchaseHeader."Recalculate Invoice Disc."
        then
          CalcInvDisc;

        DocumentTotals.CalculatePurchaseTotals(TotalPurchaseLine,VATAmount,Rec);
        InvoiceDiscountAmount := TotalPurchaseLine."Inv. Discount Amount";
        InvoiceDiscountPct := PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec);
    end;


    procedure RecalculateTaxes()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.Get("Document Type","Document No.");
        PurchaseLine.Reset;
        CalcSalesTaxLines(PurchaseHeader,PurchaseLine);
        UpdateAmounts;
        Find;
    end;
}

