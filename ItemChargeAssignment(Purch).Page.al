#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5805 "Item Charge Assignment (Purch)"
{
    AutoSplitKey = true;
    Caption = 'Item Charge Assignment (Purch)';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Worksheet;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Item Charge Assignment (Purch)";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of document that the item charge is assigned to.';
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the document that the item charge is assigned to.';
                }
                field("Applies-to Doc. Line No.";"Applies-to Doc. Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the line number of the line that the item charge is assigned to.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the item number of the document line assigned to the item charge.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item that the item charge will be assigned to.';
                }
                field("Qty. to Assign";"Qty. to Assign")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item charge that will be assigned to this line.';

                    trigger OnValidate()
                    begin
                        if PurchLine2.Quantity * "Qty. to Assign" < 0 then
                          Error(Text000,
                            FieldCaption("Qty. to Assign"),PurchLine2.FieldCaption(Quantity));
                        QtytoAssignOnAfterValidate;
                    end;
                }
                field("Qty. Assigned";"Qty. Assigned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item charge that has been assigned to this line.';
                }
                field("Amount to Assign";"Amount to Assign")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the amount that will be assigned to this assignment line.';
                }
                field(QtyToReceiveBase;QtyToReceiveBase)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Qty. to Receive (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies a value if the purchase line entered into this assignment line Specifies units that have not yet been posted as received.';
                }
                field(QtyReceivedBase;QtyReceivedBase)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Qty. Received (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the number of units that have been posted as received from the purchase line on this assignment line.';
                }
                field(QtyToShipBase;QtyToShipBase)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Qty. to Ship (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies a value if the purchase line entered into this assignment line Specifies units that have not yet been posted as shipped.';
                }
                field(QtyShippedBase;QtyShippedBase)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Qty. Shipped (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the number of units that have been posted as shipped from the purchase line on this assignment line.';
                }
            }
            group(Control22)
            {
                fixed(Control1900669001)
                {
                    group(Assignable)
                    {
                        Caption = 'Assignable';
                        field(AssignableQty;AssignableQty)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Qty.)';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ToolTip = 'Specifies the total quantity of the item charge that you can assign in this window.';
                        }
                        field(AssgntAmount;AssgntAmount)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Amount)';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ToolTip = 'Specifies the total item charge amount that you can assign in this window.';
                        }
                    }
                    group("To Assign")
                    {
                        Caption = 'To Assign';
                        field(TotalQtyToAssign;TotalQtyToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. to Assign';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ToolTip = 'Specifies the quantity of the item charge that is assigned.';
                        }
                        field(TotalAmountToAssign;TotalAmountToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Amount to Assign';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ToolTip = 'Specifies the amount of the item charge that will be assigned on the assignment lines in this window.';
                        }
                    }
                    group("Rem. to Assign")
                    {
                        Caption = 'Rem. to Assign';
                        field(RemQtyToAssign;RemQtyToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Rem. Qty. to Assign';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ToolTip = 'Specifies the quantity of the item charge that has not yet been assigned.';
                        }
                        field(RemAmountToAssign;RemAmountToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Rem. Amount to Assign';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ToolTip = 'Specifies the amount of the item charge that has not yet been assigned.';
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
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
                action(GetReceiptLines)
                {
                    AccessByPermission = TableData "Purch. Rcpt. Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get &Receipt Lines';
                    Image = Receipt;

                    trigger OnAction()
                    var
                        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
                        ReceiptLines: Page "Purch. Receipt Lines";
                    begin
                        ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
                        ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
                        ItemChargeAssgntPurch.SetRange("Document Line No.","Document Line No.");

                        ReceiptLines.SetTableview(PurchRcptLine);
                        if ItemChargeAssgntPurch.FindLast then
                          ReceiptLines.Initialize(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                        else
                          ReceiptLines.Initialize(Rec,PurchLine2."Unit Cost");

                        ReceiptLines.LookupMode(true);
                        ReceiptLines.RunModal;
                    end;
                }
                action(GetTransferReceiptLines)
                {
                    AccessByPermission = TableData "Transfer Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get &Transfer Receipt Lines';
                    Image = TransferReceipt;

                    trigger OnAction()
                    var
                        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
                        PostedTransferReceiptLines: Page "Posted Transfer Receipt Lines";
                    begin
                        ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
                        ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
                        ItemChargeAssgntPurch.SetRange("Document Line No.","Document Line No.");

                        PostedTransferReceiptLines.SetTableview(TransferRcptLine);
                        if ItemChargeAssgntPurch.FindLast then
                          PostedTransferReceiptLines.Initialize(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                        else
                          PostedTransferReceiptLines.Initialize(Rec,PurchLine2."Unit Cost");

                        PostedTransferReceiptLines.LookupMode(true);
                        PostedTransferReceiptLines.RunModal;
                    end;
                }
                action(GetReturnShipmentLines)
                {
                    AccessByPermission = TableData "Return Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get Return &Shipment Lines';
                    Image = ReturnShipment;

                    trigger OnAction()
                    var
                        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
                        ShipmentLines: Page "Return Shipment Lines";
                    begin
                        ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
                        ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
                        ItemChargeAssgntPurch.SetRange("Document Line No.","Document Line No.");

                        ShipmentLines.SetTableview(ReturnShptLine);
                        if ItemChargeAssgntPurch.FindLast then
                          ShipmentLines.Initialize(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                        else
                          ShipmentLines.Initialize(Rec,PurchLine2."Unit Cost");

                        ShipmentLines.LookupMode(true);
                        ShipmentLines.RunModal;
                    end;
                }
                action(GetSalesShipmentLines)
                {
                    AccessByPermission = TableData "Sales Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get S&ales Shipment Lines';
                    Image = SalesShipment;

                    trigger OnAction()
                    var
                        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
                        SalesShipmentLines: Page "Sales Shipment Lines";
                    begin
                        ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
                        ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
                        ItemChargeAssgntPurch.SetRange("Document Line No.","Document Line No.");

                        SalesShipmentLines.SetTableview(SalesShptLine);
                        if ItemChargeAssgntPurch.FindLast then
                          SalesShipmentLines.InitializePurchase(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                        else
                          SalesShipmentLines.InitializePurchase(Rec,PurchLine2."Unit Cost");

                        SalesShipmentLines.LookupMode(true);
                        SalesShipmentLines.RunModal;
                    end;
                }
                action(GetReturnReceiptLines)
                {
                    AccessByPermission = TableData "Return Receipt Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get Ret&urn Receipt Lines';
                    Image = ReturnReceipt;

                    trigger OnAction()
                    var
                        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
                        ReturnRcptLines: Page "Return Receipt Lines";
                    begin
                        ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
                        ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
                        ItemChargeAssgntPurch.SetRange("Document Line No.","Document Line No.");

                        ReturnRcptLines.SetTableview(ReturnRcptLine);
                        if ItemChargeAssgntPurch.FindLast then
                          ReturnRcptLines.InitializePurchase(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                        else
                          ReturnRcptLines.InitializePurchase(Rec,PurchLine2."Unit Cost");

                        ReturnRcptLines.LookupMode(true);
                        ReturnRcptLines.RunModal;
                    end;
                }
                action(SuggestItemChargeAssignment)
                {
                    AccessByPermission = TableData "Item Charge"=R;
                    ApplicationArea = Basic;
                    Caption = 'Suggest &Item Charge Assignment';
                    Ellipsis = true;
                    Image = Suggest;

                    trigger OnAction()
                    var
                        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
                    begin
                        AssignItemChargePurch.SuggestAssgnt(PurchLine2,AssignableQty,AssgntAmount);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateQtyAssgnt;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateQty;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if "Document Type" = "Applies-to Doc. Type" then begin
          PurchLine2.TestField("Receipt No.",'');
          PurchLine2.TestField("Return Shipment No.",'');
        end;
    end;

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        SetRange("Document Type",PurchLine2."Document Type");
        SetRange("Document No.",PurchLine2."Document No.");
        SetRange("Document Line No.",PurchLine2."Line No.");
        SetRange("Item Charge No.",PurchLine2."No.");
        FilterGroup(0);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if RemAmountToAssign <> 0 then
          if not Confirm(Text001,false,RemAmountToAssign,"Document Type","Document No.") then
            exit(false);
    end;

    var
        Text000: label 'The sign of %1 must be the same as the sign of %2 of the item charge.';
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReturnShptLine: Record "Return Shipment Line";
        TransferRcptLine: Record "Transfer Receipt Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        AssignableQty: Decimal;
        TotalQtyToAssign: Decimal;
        RemQtyToAssign: Decimal;
        AssgntAmount: Decimal;
        TotalAmountToAssign: Decimal;
        RemAmountToAssign: Decimal;
        QtyToReceiveBase: Decimal;
        QtyReceivedBase: Decimal;
        QtyToShipBase: Decimal;
        QtyShippedBase: Decimal;
        DataCaption: Text[250];
        Text001: label 'The remaining amount to assign is %1. It must be zero before you can post %2 %3.\ \Are you sure that you want to close the window?', Comment='%2 = Document Type, %3 = Document No.';

    local procedure UpdateQtyAssgnt()
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    begin
        PurchLine2.CalcFields("Qty. to Assign","Qty. Assigned");
        AssignableQty := PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced" -
          PurchLine2."Qty. Assigned";

        ItemChargeAssgntPurch.Reset;
        ItemChargeAssgntPurch.SetCurrentkey("Document Type","Document No.","Document Line No.");
        ItemChargeAssgntPurch.SetRange("Document Type","Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.","Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.","Document Line No.");
        ItemChargeAssgntPurch.CalcSums("Qty. to Assign","Amount to Assign");
        TotalQtyToAssign := ItemChargeAssgntPurch."Qty. to Assign";
        TotalAmountToAssign := ItemChargeAssgntPurch."Amount to Assign";

        RemQtyToAssign := AssignableQty - TotalQtyToAssign;
        RemAmountToAssign := AssgntAmount - TotalAmountToAssign;
    end;

    local procedure UpdateQty()
    begin
        case "Applies-to Doc. Type" of
          "applies-to doc. type"::Order,"applies-to doc. type"::Invoice:
            begin
              PurchLine.Get("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToReceiveBase := PurchLine."Qty. to Receive (Base)";
              QtyReceivedBase := PurchLine."Qty. Received (Base)";
              QtyToShipBase := 0;
              QtyShippedBase := 0;
            end;
          "applies-to doc. type"::"Return Order","applies-to doc. type"::"Credit Memo":
            begin
              PurchLine.Get("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToReceiveBase := 0;
              QtyReceivedBase := 0;
              QtyToShipBase := PurchLine."Return Qty. to Ship (Base)";
              QtyShippedBase := PurchLine."Return Qty. Shipped (Base)";
            end;
          "applies-to doc. type"::Receipt:
            begin
              PurchRcptLine.Get("Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToReceiveBase := 0;
              QtyReceivedBase := PurchRcptLine."Quantity (Base)";
              QtyToShipBase := 0;
              QtyShippedBase := 0;
            end;
          "applies-to doc. type"::"Return Shipment":
            begin
              ReturnShptLine.Get("Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToReceiveBase := 0;
              QtyReceivedBase := 0;
              QtyToShipBase := 0;
              QtyShippedBase := ReturnShptLine."Quantity (Base)";
            end;
          "applies-to doc. type"::"Transfer Receipt":
            begin
              TransferRcptLine.Get("Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToReceiveBase := 0;
              QtyReceivedBase := TransferRcptLine.Quantity;
              QtyToShipBase := 0;
              QtyShippedBase := 0;
            end;
          "applies-to doc. type"::"Sales Shipment":
            begin
              SalesShptLine.Get("Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToReceiveBase := 0;
              QtyReceivedBase := 0;
              QtyToShipBase := 0;
              QtyShippedBase := SalesShptLine."Quantity (Base)";
            end;
          "applies-to doc. type"::"Return Receipt":
            begin
              ReturnRcptLine.Get("Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToReceiveBase := 0;
              QtyReceivedBase := ReturnRcptLine."Quantity (Base)";
              QtyToShipBase := 0;
              QtyShippedBase := 0;
            end;
        end;
    end;


    procedure Initialize(NewPurchLine: Record "Purchase Line";NewLineAmt: Decimal)
    begin
        PurchLine2 := NewPurchLine;
        DataCaption := PurchLine2."No." + ' ' + PurchLine2.Description;
        AssgntAmount := NewLineAmt;
    end;

    local procedure QtytoAssignOnAfterValidate()
    begin
        CurrPage.Update(false);
        UpdateQtyAssgnt;
    end;
}

