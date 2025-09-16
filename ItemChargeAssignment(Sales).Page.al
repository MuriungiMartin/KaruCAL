#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5814 "Item Charge Assignment (Sales)"
{
    AutoSplitKey = true;
    Caption = 'Item Charge Assignment (Sales)';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Worksheet;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Item Charge Assignment (Sales)";

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
                    ToolTip = 'Specifies the number of the document that you are assigning the item charge to.';
                }
                field("Applies-to Doc. Line No.";"Applies-to Doc. Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the line number of the line that you are assigning the item charge to.';
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
                    ToolTip = 'Specifies a description of the item on the sales line that you will assign the item charge to.';
                }
                field("Qty. to Assign";"Qty. to Assign")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item charge that will be assigned to this line.';

                    trigger OnValidate()
                    begin
                        if SalesLine2.Quantity * "Qty. to Assign" < 0 then
                          Error(Text000,
                            FieldCaption("Qty. to Assign"),SalesLine2.FieldCaption(Quantity));
                        QtytoAssignOnAfterValidate;
                    end;
                }
                field("Qty. Assigned";"Qty. Assigned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item charge that has been assigned.';
                }
                field("Amount to Assign";"Amount to Assign")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the amount that you will assign to this assignment line.';
                }
                field(QtyToShipBase;QtyToShipBase)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Qty. to Ship (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies a value if the sales line on this assignment line Specifies units that have not been posted as shipped.';
                }
                field(QtyShippedBase;QtyShippedBase)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Qty. Shipped (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the number of units that have been posted as shipped from the sales line that you inserted on this assignment line.';
                }
                field(QtyToRetReceiveBase;QtyToRetReceiveBase)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Return Qty. to Receive (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies a value if the sales line on this assignment line Specifies units that have not been posted as a received return from your customer.';
                }
                field(QtyRetReceivedBase;QtyRetReceivedBase)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Return Qty. Received (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the number of returned units that have been posted as received on the sales line on this assignment line.';
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
                        field(AssignableAmount;AssignableAmount)
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
                            ToolTip = 'Specifies the amount of the item charge that will be assigned to the assignment lines.';
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
                            ToolTip = 'Specifies the quantity of the item charge that you have not yet assigned to items in the assignment lines.';
                        }
                        field(RemAmountToAssign;RemAmountToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Rem. Amount to Assign';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ToolTip = 'Specifies the amount of the item charge that you have not yet assigned to items in the assignment lines.';
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
                action(GetShipmentLines)
                {
                    AccessByPermission = TableData "Sales Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get &Shipment Lines';
                    Image = Shipment;

                    trigger OnAction()
                    var
                        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
                        ShipmentLines: Page "Sales Shipment Lines";
                    begin
                        ItemChargeAssgntSales.SetRange("Document Type","Document Type");
                        ItemChargeAssgntSales.SetRange("Document No.","Document No.");
                        ItemChargeAssgntSales.SetRange("Document Line No.","Document Line No.");

                        ShipmentLines.SetTableview(SalesShptLine);
                        if ItemChargeAssgntSales.FindLast then
                          ShipmentLines.InitializeSales(ItemChargeAssgntSales,SalesLine2."Sell-to Customer No.",UnitCost)
                        else
                          ShipmentLines.InitializeSales(Rec,SalesLine2."Sell-to Customer No.",UnitCost);

                        ShipmentLines.LookupMode(true);
                        ShipmentLines.RunModal;
                    end;
                }
                action(GetReturnReceiptLines)
                {
                    AccessByPermission = TableData "Return Receipt Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get &Return Receipt Lines';
                    Image = ReturnReceipt;

                    trigger OnAction()
                    var
                        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
                        ReceiptLines: Page "Return Receipt Lines";
                    begin
                        ItemChargeAssgntSales.SetRange("Document Type","Document Type");
                        ItemChargeAssgntSales.SetRange("Document No.","Document No.");
                        ItemChargeAssgntSales.SetRange("Document Line No.","Document Line No.");

                        ReceiptLines.SetTableview(ReturnRcptLine);
                        if ItemChargeAssgntSales.FindLast then
                          ReceiptLines.InitializeSales(ItemChargeAssgntSales,SalesLine2."Sell-to Customer No.",UnitCost)
                        else
                          ReceiptLines.InitializeSales(Rec,SalesLine2."Sell-to Customer No.",UnitCost);

                        ReceiptLines.LookupMode(true);
                        ReceiptLines.RunModal;
                    end;
                }
                action(SuggestItemChargeAssignment)
                {
                    AccessByPermission = TableData "Item Charge"=R;
                    ApplicationArea = Basic;
                    Caption = 'Suggest Item &Charge Assignment';
                    Image = Suggest;

                    trigger OnAction()
                    var
                        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
                    begin
                        AssignItemChargeSales.SuggestAssignment(SalesLine2,AssignableQty,AssignableAmount);
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
          SalesLine2.TestField("Shipment No.",'');
          SalesLine2.TestField("Return Receipt No.",'');
        end;
    end;

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        SetRange("Document Type",SalesLine2."Document Type");
        SetRange("Document No.",SalesLine2."Document No.");
        SetRange("Document Line No.",SalesLine2."Line No.");
        SetRange("Item Charge No.",SalesLine2."No.");
        FilterGroup(0);
    end;

    var
        Text000: label 'The sign of %1 must be the same as the sign of %2 of the item charge.';
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        ReturnRcptLine: Record "Return Receipt Line";
        SalesShptLine: Record "Sales Shipment Line";
        AssignableQty: Decimal;
        TotalQtyToAssign: Decimal;
        RemQtyToAssign: Decimal;
        AssignableAmount: Decimal;
        TotalAmountToAssign: Decimal;
        RemAmountToAssign: Decimal;
        QtyToRetReceiveBase: Decimal;
        QtyRetReceivedBase: Decimal;
        QtyToShipBase: Decimal;
        QtyShippedBase: Decimal;
        UnitCost: Decimal;
        DataCaption: Text[250];

    local procedure UpdateQtyAssgnt()
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
    begin
        SalesLine2.CalcFields("Qty. to Assign","Qty. Assigned");
        AssignableQty := SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced" -
          SalesLine2."Qty. Assigned";

        if AssignableQty <> 0 then
          UnitCost := AssignableAmount / AssignableQty
        else
          UnitCost := 0;

        ItemChargeAssgntSales.Reset;
        ItemChargeAssgntSales.SetCurrentkey("Document Type","Document No.","Document Line No.");
        ItemChargeAssgntSales.SetRange("Document Type","Document Type");
        ItemChargeAssgntSales.SetRange("Document No.","Document No.");
        ItemChargeAssgntSales.SetRange("Document Line No.","Document Line No.");
        ItemChargeAssgntSales.CalcSums("Qty. to Assign","Amount to Assign");
        TotalQtyToAssign := ItemChargeAssgntSales."Qty. to Assign";
        TotalAmountToAssign := ItemChargeAssgntSales."Amount to Assign";

        RemQtyToAssign := AssignableQty - TotalQtyToAssign;
        RemAmountToAssign := AssignableAmount - TotalAmountToAssign;
    end;

    local procedure UpdateQty()
    begin
        case "Applies-to Doc. Type" of
          "applies-to doc. type"::Order,"applies-to doc. type"::Invoice:
            begin
              SalesLine.Get("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToShipBase := SalesLine."Qty. to Ship (Base)";
              QtyShippedBase := SalesLine."Qty. Shipped (Base)";
              QtyToRetReceiveBase := 0;
              QtyRetReceivedBase := 0;
            end;
          "applies-to doc. type"::"Return Order","applies-to doc. type"::"Credit Memo":
            begin
              SalesLine.Get("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToRetReceiveBase := SalesLine."Return Qty. to Receive (Base)";
              QtyRetReceivedBase := SalesLine."Return Qty. Received (Base)";
              QtyToShipBase := 0;
              QtyShippedBase := 0;
            end;
          "applies-to doc. type"::"Return Receipt":
            begin
              ReturnRcptLine.Get("Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToRetReceiveBase := 0;
              QtyRetReceivedBase := ReturnRcptLine."Quantity (Base)";
              QtyToShipBase := 0;
              QtyShippedBase := 0;
            end;
          "applies-to doc. type"::Shipment:
            begin
              SalesShptLine.Get("Applies-to Doc. No.","Applies-to Doc. Line No.");
              QtyToRetReceiveBase := 0;
              QtyRetReceivedBase := 0;
              QtyToShipBase := 0;
              QtyShippedBase := SalesShptLine."Quantity (Base)";
            end;
        end;
    end;


    procedure Initialize(NewSalesLine: Record "Sales Line";NewLineAmt: Decimal)
    begin
        SalesLine2 := NewSalesLine;
        DataCaption := SalesLine2."No." + ' ' + SalesLine2.Description;
        AssignableAmount := NewLineAmt;
    end;

    local procedure QtytoAssignOnAfterValidate()
    begin
        CurrPage.Update(false);
        UpdateQtyAssgnt;
    end;
}

