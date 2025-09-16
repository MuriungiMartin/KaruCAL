#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 141 "Posted Purch. Cr. Memo Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Purch. Cr. Memo Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line type.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an item number that identifies the item or a general ledger account number that identifies the general ledger account used when posting the line.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the IC partner that the line has been distributed to.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies either the name of, or a description of, the item or general ledger account.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that explains why the item is returned.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the number of units of the item specified on the credit memo line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code for the item.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the item (bottle or piece, for example).';
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the direct cost of one item unit.';
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the percentage indirect cost for the item.';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit cost of the item on the line.';
                    Visible = false;
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the price for one unit of the item.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                    Visible = false;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                    Visible = false;
                }
                field("Provincial Tax Area Code";"Provincial Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Canadian provincial tax area code for the purchase credit memo line. This code is used to calculate sales tax charges defined by the Provincial Sales Tax (PST) rate.';
                    Visible = false;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
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
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the line discount % granted on items on each individual line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the discount amount that was granted on the line.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the credit memo line could have been included in an invoice discount calculation.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job number the purchase invoice line is linked to.';
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the production order number.';
                    Visible = false;
                }
                field("Insurance No.";"Insurance No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the insurance number on the purchase credit memo line.';
                    Visible = false;
                }
                field("Budgeted FA No.";"Budgeted FA No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the budgeted FA number on the purchase credit memo line.';
                    Visible = false;
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the FA posting type of the purchase credit memo line.';
                    Visible = false;
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether depreciation was calculated until the FA posting date of the line.';
                    Visible = false;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the depreciation book code on the purchase credit memo line.';
                    Visible = false;
                }
                field("Depr. Acquisition Cost";"Depr. Acquisition Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of a particular item entry to which the credit memo was applied.';
                    Visible = false;
                }
                field("Deferral Code";"Deferral Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.';
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
                field("IRS 1099 Liable";"IRS 1099 Liable")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the purchase credit memo line is a 1099 liable tax that must be reported to the Internal Revenue Service (IRS).';
                    Visible = false;
                }
            }
            group(Control33)
            {
                group(Control23)
                {
                    field("Invoice Discount Amount";TotalPurchCrMemoHdr."Invoice Discount Amount")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATCaption(TotalPurchCrMemoHdr."Prices Including VAT");
                        Caption = 'Invoice Discount Amount';
                        Editable = false;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. Tax field. You can enter or change the amount manually.';
                    }
                }
                group(Control9)
                {
                    field("Total Amount Excl. VAT";TotalPurchCrMemoHdr.Amount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalPurchCrMemoHdr."Currency Code");
                        Caption = 'Total Amount Excl. Tax';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount";VATAmount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(TotalPurchCrMemoHdr."Currency Code");
                        Caption = 'Total Tax';
                        Editable = false;
                        ToolTip = 'Specifies the sum of tax amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT";TotalPurchCrMemoHdr."Amount Including VAT")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalPurchCrMemoHdr."Currency Code");
                        Caption = 'Total Amount Incl. Tax';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = true;
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
            action(DeferralSchedule)
            {
                ApplicationArea = Suite;
                Caption = 'Deferral Schedule';
                Image = PaymentPeriod;
                ToolTip = 'View the deferral schedule that governs how expenses paid with this purchase document were deferred to different accounting periods when the document was posted.';

                trigger OnAction()
                begin
                    ShowDeferrals;
                end;
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
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
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        ShowLineComments;
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
                action(ItemReturnShipmentLines)
                {
                    AccessByPermission = TableData "Return Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Item Return Shipment &Lines';

                    trigger OnAction()
                    begin
                        if not (Type in [Type::Item,Type::"Charge (Item)"]) then
                          TestField(Type);
                        ShowItemReturnShptLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.CalculatePostedPurchCreditMemoTotals(TotalPurchCrMemoHdr,VATAmount,Rec);
    end;

    var
        TotalPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;
}

