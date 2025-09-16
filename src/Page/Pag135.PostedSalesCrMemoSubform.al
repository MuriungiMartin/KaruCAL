#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 135 "Posted Sales Cr. Memo Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Cr.Memo Line";

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
                    ToolTip = 'Specifies a general ledger account number or an item number that identifies the general ledger account or item specified when the line was posted.';
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
                    ToolTip = 'Specifies the variant number of the items sold.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the item or general ledger account, or some descriptive text.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that explains why the item is returned.';
                }
                field("Package Tracking No.";"Package Tracking No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Package Tracking No. field on the sales line.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code for the items sold.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the item (bottle or piece, for example).';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit cost of the item on the line.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the price of one unit of the item.';
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
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sum of the amounts in the Amount Including Tax fields on the associated sales lines.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the line discount % that was given on the line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the discount given on the line.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the credit memo line could have included a possible invoice discount calculation.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job number that the sales line is linked to.';
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
                    ToolTip = 'Specifies the number of the item ledger entry this credit memo was applied to.';
                    Visible = false;
                }
                field("Deferral Code";"Deferral Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
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
            }
            group(Control29)
            {
                group(Control25)
                {
                    field("Invoice Discount Amount";TotalSalesCrMemoHeader."Invoice Discount Amount")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalSalesCrMemoHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATCaption(TotalSalesCrMemoHeader."Prices Including VAT");
                        Caption = 'Invoice Discount Amount';
                        Editable = false;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. Tax field. You can enter or change the amount manually.';
                    }
                }
                group(Control7)
                {
                    field("Total Amount Excl. VAT";TotalSalesCrMemoHeader.Amount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalSalesCrMemoHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalSalesCrMemoHeader."Currency Code");
                        Caption = 'Total Amount Excl. Tax';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount";VATAmount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalSalesCrMemoHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(TotalSalesCrMemoHeader."Currency Code");
                        Caption = 'Total Tax';
                        Editable = false;
                        ToolTip = 'Specifies the sum of tax amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT";TotalSalesCrMemoHeader."Amount Including VAT")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalSalesCrMemoHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalSalesCrMemoHeader."Currency Code");
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
                ToolTip = 'View the deferral schedule that governs how revenue made with this sales document was deferred to different accounting periods when the document was posted.';

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
                action(ItemReturnReceiptLines)
                {
                    AccessByPermission = TableData "Return Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Item Return Receipt &Lines';

                    trigger OnAction()
                    begin
                        PageShowItemReturnRcptLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.CalculatePostedSalesCreditMemoTotals(TotalSalesCrMemoHeader,VATAmount,Rec);
    end;

    var
        TotalSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;

    local procedure PageShowItemReturnRcptLines()
    begin
        if not (Type in [Type::Item,Type::"Charge (Item)"]) then
          TestField(Type);
        ShowItemReturnRcptLines;
    end;
}

