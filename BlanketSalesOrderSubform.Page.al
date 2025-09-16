#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 508 "Blanket Sales Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type"=filter("Blanket Order"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;

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
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CrossReferenceNoLookUp;
                        InsertExtendedText(false);
                    end;

                    trigger OnValidate()
                    begin
                        CrossReferenceNoOnAfterValidat;
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        VariantCodeOnAfterValidate
                    end;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Qty. to Assemble to Order";"Qty. to Assemble to Order")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        ShowAsmToOrderLines;
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                        CurrPage.Update(true);
                    end;
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PriceExists;PriceExists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sale Price Exists';
                    Editable = false;
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
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

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of the amounts in the Amount Including Tax fields on the associated sales lines.';
                }
                field(LineDiscExists;LineDiscExists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Line Disc. Exists';
                    Editable = false;
                    Visible = false;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Quantity Shipped";"Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
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
            }
            group(Control53)
            {
                group(Control49)
                {
                    field("Invoice Discount Amount";TotalSalesLine."Inv. Discount Amount")
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;

                        trigger OnValidate()
                        var
                            SalesHeader: Record "Sales Header";
                        begin
                            SalesHeader.Get("Document Type","Document No.");
                            SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalSalesLine."Inv. Discount Amount",SalesHeader);
                            CurrPage.Update(false);
                        end;
                    }
                    field("Invoice Disc. Pct.";SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec))
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0:2;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                }
                group(Control35)
                {
                    field("Total Amount Excl. VAT";TotalSalesLine.Amount)
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(SalesHeader."Currency Code");
                        Caption = 'Total Amount Excl. Tax';
                        DrillDown = false;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                    field("Total VAT Amount";VATAmount)
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(SalesHeader."Currency Code");
                        Caption = 'Total Tax';
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                    field("Total Amount Incl. VAT";TotalSalesLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic;
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(SalesHeader."Currency Code");
                        Caption = 'Total Amount Incl. Tax';
                        Editable = false;
                        StyleExpr = TotalAmountStyle;
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
                            DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
                            DocumentTotals.SalesUpdateTotalsControls(Rec,TotalSalesHeader,TotalSalesLine,RefreshMessageEnabled,
                              TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,CurrPage.Editable,VATAmount);
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
                group("Unposted Lines")
                {
                    Caption = 'Unposted Lines';
                    Image = "Order";
                    action(Orders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Orders';
                        Image = Document;

                        trigger OnAction()
                        begin
                            ShowOrders;
                        end;
                    }
                    action(Invoices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            ShowInvoices;
                        end;
                    }
                    action("Return Orders")
                    {
                        AccessByPermission = TableData "Return Receipt Header"=R;
                        ApplicationArea = Basic;
                        Caption = 'Return Orders';
                        Image = ReturnOrder;

                        trigger OnAction()
                        begin
                            ShowReturnOrders;
                        end;
                    }
                    action("Credit Memos")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Credit Memos';
                        Image = CreditMemo;

                        trigger OnAction()
                        begin
                            ShowCreditMemos;
                        end;
                    }
                }
                group("Posted Lines")
                {
                    Caption = 'Posted Lines';
                    Image = Post;
                    action(Shipments)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Shipments';
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            ShowPostedOrders;
                        end;
                    }
                    action(Action1901092104)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            ShowPostedInvoices;
                        end;
                    }
                    action("Return Receipts")
                    {
                        AccessByPermission = TableData "Return Receipt Header"=R;
                        ApplicationArea = Basic;
                        Caption = 'Return Receipts';
                        Image = ReturnReceipt;

                        trigger OnAction()
                        begin
                            ShowPostedReturnReceipts;
                        end;
                    }
                    action(Action1901033504)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Credit Memos';
                        Image = CreditMemo;

                        trigger OnAction()
                        begin
                            ShowPostedCreditMemos;
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
                group("Assemble to Order")
                {
                    Caption = 'Assemble to Order';
                    Image = AssemblyBOM;
                    action("Assemble-to-Order Lines")
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
            }
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
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if SalesHeader.Get("Document Type","Document No.") then;

        DocumentTotals.SalesUpdateTotalsControls(Rec,TotalSalesHeader,TotalSalesLine,RefreshMessageEnabled,
          TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,CurrPage.Editable,VATAmount);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        Clear(DocumentTotals);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InitType;
        Clear(ShortcutDimCode);
    end;

    var
        CurrentSalesLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;
        ShortcutDimCode: array [8] of Code[20];
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Disc. (Yes/No)",Rec);
    end;

    local procedure ExplodeBOM()
    begin
        Codeunit.Run(Codeunit::"Sales-Explode BOM",Rec);
    end;

    local procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          Commit;
          TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          UpdateForm(true);
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    local procedure ShowPrices()
    begin
        SalesHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
    end;

    local procedure ShowLineDisc()
    begin
        SalesHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
    end;

    local procedure ShowOrders()
    begin
        CurrentSalesLine := Rec;
        SalesLine.Reset;
        SalesLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
        SalesLine.SetRange("Document Type",SalesLine."document type"::Order);
        SalesLine.SetRange("Blanket Order No.",CurrentSalesLine."Document No.");
        SalesLine.SetRange("Blanket Order Line No.",CurrentSalesLine."Line No.");
        Page.RunModal(Page::"Sales Lines",SalesLine);
    end;

    local procedure ShowInvoices()
    begin
        CurrentSalesLine := Rec;
        SalesLine.Reset;
        SalesLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
        SalesLine.SetRange("Document Type",SalesLine."document type"::Invoice);
        SalesLine.SetRange("Blanket Order No.",CurrentSalesLine."Document No.");
        SalesLine.SetRange("Blanket Order Line No.",CurrentSalesLine."Line No.");
        Page.RunModal(Page::"Sales Lines",SalesLine);
    end;

    local procedure ShowReturnOrders()
    begin
        CurrentSalesLine := Rec;
        SalesLine.Reset;
        SalesLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
        SalesLine.SetRange("Document Type",SalesLine."document type"::"Return Order");
        SalesLine.SetRange("Blanket Order No.",CurrentSalesLine."Document No.");
        SalesLine.SetRange("Blanket Order Line No.",CurrentSalesLine."Line No.");
        Page.RunModal(Page::"Sales Lines",SalesLine);
    end;

    local procedure ShowCreditMemos()
    begin
        CurrentSalesLine := Rec;
        SalesLine.Reset;
        SalesLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
        SalesLine.SetRange("Document Type",SalesLine."document type"::"Credit Memo");
        SalesLine.SetRange("Blanket Order No.",CurrentSalesLine."Document No.");
        SalesLine.SetRange("Blanket Order Line No.",CurrentSalesLine."Line No.");
        Page.RunModal(Page::"Sales Lines",SalesLine);
    end;

    local procedure ShowPostedOrders()
    var
        SaleShptLine: Record "Sales Shipment Line";
    begin
        CurrentSalesLine := Rec;
        SaleShptLine.Reset;
        SaleShptLine.SetCurrentkey("Blanket Order No.","Blanket Order Line No.");
        SaleShptLine.SetRange("Blanket Order No.",CurrentSalesLine."Document No.");
        SaleShptLine.SetRange("Blanket Order Line No.",CurrentSalesLine."Line No.");
        Page.RunModal(Page::"Posted Sales Shipment Lines",SaleShptLine);
    end;

    local procedure ShowPostedInvoices()
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        CurrentSalesLine := Rec;
        SalesInvLine.Reset;
        SalesInvLine.SetCurrentkey("Blanket Order No.","Blanket Order Line No.");
        SalesInvLine.SetRange("Blanket Order No.",CurrentSalesLine."Document No.");
        SalesInvLine.SetRange("Blanket Order Line No.",CurrentSalesLine."Line No.");
        Page.RunModal(Page::"Posted Sales Invoice Lines",SalesInvLine);
    end;

    local procedure ShowPostedReturnReceipts()
    var
        ReturnRcptLine: Record "Return Receipt Line";
    begin
        CurrentSalesLine := Rec;
        ReturnRcptLine.Reset;
        ReturnRcptLine.SetCurrentkey("Blanket Order No.","Blanket Order Line No.");
        ReturnRcptLine.SetRange("Blanket Order No.",CurrentSalesLine."Document No.");
        ReturnRcptLine.SetRange("Blanket Order Line No.",CurrentSalesLine."Line No.");
        Page.RunModal(Page::"Posted Return Receipt Lines",ReturnRcptLine);
    end;

    local procedure ShowPostedCreditMemos()
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        CurrentSalesLine := Rec;
        SalesCrMemoLine.Reset;
        SalesCrMemoLine.SetCurrentkey("Blanket Order No.","Blanket Order Line No.");
        SalesCrMemoLine.SetRange("Blanket Order No.",CurrentSalesLine."Document No.");
        SalesCrMemoLine.SetRange("Blanket Order Line No.",CurrentSalesLine."Line No.");
        Page.RunModal(Page::"Posted Sales Credit Memo Lines",SalesCrMemoLine);
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);

        SaveAndAutoAsmToOrder;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;

    local procedure QuantityOnAfterValidate()
    begin
        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          AutoReserve;
        end;

        if (Type = Type::Item) and
           (Quantity <> xRec.Quantity)
        then
          CurrPage.Update(true);
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          AutoReserve;
        end;
    end;

    local procedure SaveAndAutoAsmToOrder()
    begin
        if (Type = Type::Item) and IsAsmToOrderRequired then begin
          CurrPage.SaveRecord;
          AutoAsmToOrder;
          CurrPage.Update(false);
        end;
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord;

        SalesHeader.Get("Document Type","Document No.");
        if DocumentTotals.SalesCheckNumberOfLinesLimit(SalesHeader) then
          DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
        CurrPage.Update;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SaveRecord;
    end;
}

