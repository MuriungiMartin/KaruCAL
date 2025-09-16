#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 510 "Blanket Purchase Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
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
                }
                field("GST/HST";"GST/HST")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of goods and services tax (GST) for the purchase line. You can select Acquisition, Self-Assessment, Rebate, New Housing Rebates, or Pension Rebate for the GST tax.';
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
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;

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
                field("Provincial Tax Area Code";"Provincial Tax Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax area code for self assessed Provincial Sales Tax for the company.';
                    Visible = false;
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
                field("Use Tax";"Use Tax")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field("Qty. to Receive";"Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Quantity Received";"Quantity Received")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
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
            group(Control37)
            {
                group(Control33)
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
                    }
                }
                group(Control15)
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
                        AccessByPermission = TableData "Return Shipment Header"=R;
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
                    action(Receipts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Receipts';
                        Image = PostedReceipts;

                        trigger OnAction()
                        begin
                            ShowPostedReceipts;
                        end;
                    }
                    action(Action1904522204)
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
                        ApplicationArea = Basic;
                        Caption = 'Return Receipts';
                        Image = ReturnReceipt;

                        trigger OnAction()
                        begin
                            ShowPostedReturnReceipts;
                        end;
                    }
                    action(Action1902056104)
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
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if PurchHeader.Get("Document Type","Document No.") then;

        DocumentTotals.PurchaseUpdateTotalsControls(Rec,TotalPurchaseHeader,TotalPurchaseLine,RefreshMessageEnabled,
          TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,VATAmount);
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
        TotalPurchaseHeader: Record "Purchase Header";
        TotalPurchaseLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        CurrentPurchLine: Record "Purchase Line";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        DocumentTotals: Codeunit "Document Totals";
        ShortcutDimCode: array [8] of Code[20];
        VATAmount: Decimal;
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;


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


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    local procedure ShowOrders()
    begin
        CurrentPurchLine := Rec;
        PurchLine.Reset;
        PurchLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
        PurchLine.SetRange("Document Type",PurchLine."document type"::Order);
        PurchLine.SetRange("Blanket Order No.",CurrentPurchLine."Document No.");
        PurchLine.SetRange("Blanket Order Line No.",CurrentPurchLine."Line No.");
        Page.RunModal(Page::"Purchase Lines",PurchLine);
    end;

    local procedure ShowInvoices()
    begin
        CurrentPurchLine := Rec;
        PurchLine.Reset;
        PurchLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
        PurchLine.SetRange("Document Type",PurchLine."document type"::Invoice);
        PurchLine.SetRange("Blanket Order No.",CurrentPurchLine."Document No.");
        PurchLine.SetRange("Blanket Order Line No.",CurrentPurchLine."Line No.");
        Page.RunModal(Page::"Purchase Lines",PurchLine);
    end;

    local procedure ShowReturnOrders()
    begin
        CurrentPurchLine := Rec;
        PurchLine.Reset;
        PurchLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
        PurchLine.SetRange("Document Type",PurchLine."document type"::"Return Order");
        PurchLine.SetRange("Blanket Order No.",CurrentPurchLine."Document No.");
        PurchLine.SetRange("Blanket Order Line No.",CurrentPurchLine."Line No.");
        Page.RunModal(Page::"Purchase Lines",PurchLine);
    end;

    local procedure ShowCreditMemos()
    begin
        CurrentPurchLine := Rec;
        PurchLine.Reset;
        PurchLine.SetCurrentkey("Document Type","Blanket Order No.","Blanket Order Line No.");
        PurchLine.SetRange("Document Type",PurchLine."document type"::"Credit Memo");
        PurchLine.SetRange("Blanket Order No.",CurrentPurchLine."Document No.");
        PurchLine.SetRange("Blanket Order Line No.",CurrentPurchLine."Line No.");
        Page.RunModal(Page::"Purchase Lines",PurchLine);
    end;

    local procedure ShowPostedReceipts()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        CurrentPurchLine := Rec;
        PurchRcptLine.Reset;
        PurchRcptLine.SetCurrentkey("Blanket Order No.","Blanket Order Line No.");
        PurchRcptLine.SetRange("Blanket Order No.",CurrentPurchLine."Document No.");
        PurchRcptLine.SetRange("Blanket Order Line No.",CurrentPurchLine."Line No.");
        Page.RunModal(Page::"Posted Purchase Receipt Lines",PurchRcptLine);
    end;

    local procedure ShowPostedInvoices()
    var
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        CurrentPurchLine := Rec;
        PurchInvLine.Reset;
        PurchInvLine.SetCurrentkey("Blanket Order No.","Blanket Order Line No.");
        PurchInvLine.SetRange("Blanket Order No.",CurrentPurchLine."Document No.");
        PurchInvLine.SetRange("Blanket Order Line No.",CurrentPurchLine."Line No.");
        Page.RunModal(Page::"Posted Purchase Invoice Lines",PurchInvLine);
    end;

    local procedure ShowPostedReturnReceipts()
    var
        ReturnShptLine: Record "Return Shipment Line";
    begin
        CurrentPurchLine := Rec;
        ReturnShptLine.Reset;
        ReturnShptLine.SetCurrentkey("Blanket Order No.","Blanket Order Line No.");
        ReturnShptLine.SetRange("Blanket Order No.",CurrentPurchLine."Document No.");
        ReturnShptLine.SetRange("Blanket Order Line No.",CurrentPurchLine."Line No.");
        Page.RunModal(Page::"Posted Return Shipment Lines",ReturnShptLine);
    end;

    local procedure ShowPostedCreditMemos()
    var
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
    begin
        CurrentPurchLine := Rec;
        PurchCrMemoLine.Reset;
        PurchCrMemoLine.SetCurrentkey("Blanket Order No.","Blanket Order Line No.");
        PurchCrMemoLine.SetRange("Blanket Order No.",CurrentPurchLine."Document No.");
        PurchCrMemoLine.SetRange("Blanket Order Line No.",CurrentPurchLine."Line No.");
        Page.RunModal(Page::"Posted Purchase Cr. Memo Lines",PurchCrMemoLine);
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord;

        PurchHeader.Get("Document Type","Document No.");
        if DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchHeader) then
          DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
        CurrPage.Update;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SaveRecord;
    end;
}

