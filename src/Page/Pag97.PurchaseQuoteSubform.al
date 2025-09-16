#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 97 "Purchase Quote Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type"=filter(Quote));

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
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

                        if xRec."No." <> '' then
                          RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the entry, depending on what you chose in the Type field.';

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

                        if xRec."No." <> '' then
                          RedistributeTotalsOnAfterValidate;
                    end;
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies the number of units of the item that will be specified on the line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    ToolTip = 'Specifies the unit of measure code that is valid for the purchase line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ShowMandatory = "No." <> '';
                    ToolTip = 'Specifies the direct cost of one item unit.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount (excluding the invoice discount amount) of the line, in the currency of the purchase document.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code linked to the purchase.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control40)
            {
                group(Control31)
                {
                    field("Invoice Discount Amount";TotalPurchaseLine."Inv. Discount Amount")
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        AutoFormatType = 1;
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. Tax field.';

                        trigger OnValidate()
                        var
                            PurchaseHeader: Record "Purchase Header";
                        begin
                            PurchaseHeader.Get("Document Type","Document No.");
                            PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalPurchaseLine."Inv. Discount Amount",PurchaseHeader);
                            CurrPage.Update(false);
                        end;
                    }
                    field("Invoice Disc. Pct.";PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec))
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0:2;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';
                    }
                }
                group(Control17)
                {
                    field("Total Amount Excl. VAT";TotalPurchaseLine.Amount)
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(PurchHeader."Currency Code");
                        Caption = 'Total Amount Excl. Tax';
                        DrillDown = false;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document, minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount";VATAmount)
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(PurchHeader."Currency Code");
                        Caption = 'Total Tax';
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        ToolTip = 'Specifies the sum of tax amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT";TotalPurchaseLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(PurchHeader."Currency Code");
                        Caption = 'Total Amount Incl. Tax';
                        Editable = false;
                        StyleExpr = TotalAmountStyle;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. Tax field on all lines in the document, minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field(RefreshTotals;RefreshMessageText)
                    {
                        ApplicationArea = Basic;
                        DrillDown = true;
                        Editable = false;
                        Enabled = RefreshMessageEnabled;
                        ShowCaption = false;

                        trigger OnDrillDown()
                        begin
                            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
                            DocumentTotals.PurchaseUpdateTotalsControls(Rec,TotalPurchaseHeader,TotalPurchaseLine,RefreshMessageEnabled,
                              TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,VATAmount);
                            RecalculateTaxes;
                        end;
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
                action("Insert &Ext. Text")
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
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateEditableOnRow;
        if PurchHeader.Get("Document Type","Document No.") then;

        DocumentTotals.PurchaseUpdateTotalsControls(Rec,TotalPurchaseHeader,TotalPurchaseLine,RefreshMessageEnabled,
          TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,VATAmount);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        Clear(DocumentTotals);
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
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
        TotalPurchaseHeader: Record "Purchase Header";
        TotalPurchaseLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        DocumentTotals: Codeunit "Document Totals";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array [8] of Code[20];
        VATAmount: Decimal;
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        TaxGroupCodeVisible: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Purch.-Disc. (Yes/No)",Rec);
    end;

    local procedure ExplodeBOM()
    begin
        Codeunit.Run(Codeunit::"Purch.-Explode BOM",Rec);
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

    local procedure ItemChargeAssgnt()
    begin
        ShowItemChargeAssgnt;
    end;

    local procedure OpenItemTrackingLines()
    begin
        OpenItemTrackingLines;
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

        PurchHeader.Get("Document Type","Document No.");
        if DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchHeader) then begin
          DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
          RecalculateTaxes;
        end;
        CurrPage.Update;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SaveRecord;
    end;

    local procedure UpdateEditableOnRow()
    begin
        UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode;
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

