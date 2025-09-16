#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5526 "Make Supply Orders"
{
    Caption = 'Make Supply Orders';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Manufacturing User Template";

    layout
    {
        area(content)
        {
            group("Order Planning")
            {
                Caption = 'Order Planning';
                field("Make Orders";"Make Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Make Orders for';
                    ToolTip = 'Specifies the filters users select in the Make Supply Orders window that opens from the Order Planning window.';
                    ValuesAllowed = "The Active Line","The Active Order","All Lines";
                }
                group(Control4)
                {
                    InstructionalText = 'Multilevel production orders that are made with this function may generate new demand, which you can only see after you have recalculated a plan in the Order Planning window.';
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field("Create Purchase Order";"Create Purchase Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the filters users select in the Make Supply Orders window that opens from the Order Planning window.';

                    trigger OnValidate()
                    begin
                        PurchaseReqWkshTemplateEnable :=
                          "Create Purchase Order" = "create purchase order"::"Copy to Req. Wksh";
                        PurchaseWkshNameEnable :=
                          "Create Purchase Order" = "create purchase order"::"Copy to Req. Wksh";
                        CreatePurchaseOrderOnAfterVali;
                    end;
                }
                field("Purchase Req. Wksh. Template";"Purchase Req. Wksh. Template")
                {
                    ApplicationArea = Basic;
                    Enabled = PurchaseReqWkshTemplateEnable;
                    ToolTip = 'Specifies the template for the purchase requisition worksheet associated with this entry.';

                    trigger OnValidate()
                    begin
                        PurchaseReqWkshTemplateOnAfter;
                    end;
                }
                field("Purchase Wksh. Name";"Purchase Wksh. Name")
                {
                    ApplicationArea = Basic;
                    Enabled = PurchaseWkshNameEnable;
                    ToolTip = 'Specifies the purchase worksheet name associated with this entry.';

                    trigger OnValidate()
                    begin
                        PurchaseWkshNameOnAfterValidat;
                    end;
                }
                field("Create Production Order";"Create Production Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the filters users select in the Make Supply Orders window that opens from the Order Planning window.';

                    trigger OnValidate()
                    begin
                        ProdReqWkshTemplateEnable :=
                          "Create Production Order" = "create production order"::"Copy to Req. Wksh";
                        ProdWkshNameEnable :=
                          "Create Production Order" = "create production order"::"Copy to Req. Wksh";
                        CreateProductionOrderOnAfterVa;
                    end;
                }
                field("Prod. Req. Wksh. Template";"Prod. Req. Wksh. Template")
                {
                    ApplicationArea = Basic;
                    Enabled = ProdReqWkshTemplateEnable;
                    ToolTip = 'Specifies the production requisition worksheet template associated with this entry.';

                    trigger OnValidate()
                    begin
                        ProdReqWkshTemplateOnAfterVali;
                    end;
                }
                field("Prod. Wksh. Name";"Prod. Wksh. Name")
                {
                    ApplicationArea = Basic;
                    Enabled = ProdWkshNameEnable;
                    ToolTip = 'Specifies the production worksheet name associated with this entry.';

                    trigger OnValidate()
                    begin
                        ProdWkshNameOnAfterValidate;
                    end;
                }
                field("Create Transfer Order";"Create Transfer Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the filters users select in the Make Supply Orders window that opens from the Order Planning window.';

                    trigger OnValidate()
                    begin
                        TransferReqWkshTemplateEnable :=
                          "Create Transfer Order" = "create transfer order"::"Copy to Req. Wksh";
                        TransferWkshNameEnable :=
                          "Create Transfer Order" = "create transfer order"::"Copy to Req. Wksh";
                        CreateTransferOrderOnAfterVali;
                    end;
                }
                field("Transfer Req. Wksh. Template";"Transfer Req. Wksh. Template")
                {
                    ApplicationArea = Basic;
                    Enabled = TransferReqWkshTemplateEnable;
                    ToolTip = 'Specifies the transfer requisition worksheet template associated with this entry.';

                    trigger OnValidate()
                    begin
                        TransferReqWkshTemplateOnAfter;
                    end;
                }
                field("Transfer Wksh. Name";"Transfer Wksh. Name")
                {
                    ApplicationArea = Basic;
                    Enabled = TransferWkshNameEnable;
                    ToolTip = 'Specifies the transfer worksheet name associated with this entry.';

                    trigger OnValidate()
                    begin
                        TransferWkshNameOnAfterValidat;
                    end;
                }
                field("Create Assembly Order";"Create Assembly Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the filters users select in the Make Supply Orders window that opens from the Order Planning window.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        PurchaseReqWkshTemplateEnable :=
          "Create Purchase Order" = "create purchase order"::"Copy to Req. Wksh";
        PurchaseWkshNameEnable :=
          "Create Purchase Order" = "create purchase order"::"Copy to Req. Wksh";

        ProdReqWkshTemplateEnable :=
          "Create Production Order" = "create production order"::"Copy to Req. Wksh";
        ProdWkshNameEnable :=
          "Create Production Order" = "create production order"::"Copy to Req. Wksh";

        TransferReqWkshTemplateEnable :=
          "Create Transfer Order" = "create transfer order"::"Copy to Req. Wksh";
        TransferWkshNameEnable :=
          "Create Transfer Order" = "create transfer order"::"Copy to Req. Wksh";
    end;

    trigger OnInit()
    begin
        TransferWkshNameEnable := true;
        TransferReqWkshTemplateEnable := true;
        ProdWkshNameEnable := true;
        ProdReqWkshTemplateEnable := true;
        PurchaseWkshNameEnable := true;
        PurchaseReqWkshTemplateEnable := true;
    end;

    var
        [InDataSet]
        PurchaseReqWkshTemplateEnable: Boolean;
        [InDataSet]
        PurchaseWkshNameEnable: Boolean;
        [InDataSet]
        ProdReqWkshTemplateEnable: Boolean;
        [InDataSet]
        ProdWkshNameEnable: Boolean;
        [InDataSet]
        TransferReqWkshTemplateEnable: Boolean;
        [InDataSet]
        TransferWkshNameEnable: Boolean;

    local procedure CreatePurchaseOrderOnAfterVali()
    begin
        Modify(true);
    end;

    local procedure CreateProductionOrderOnAfterVa()
    begin
        Modify(true);
    end;

    local procedure CreateTransferOrderOnAfterVali()
    begin
        Modify(true);
    end;

    local procedure PurchaseReqWkshTemplateOnAfter()
    begin
        "Purchase Wksh. Name" := '';
        Modify(true);
    end;

    local procedure PurchaseWkshNameOnAfterValidat()
    begin
        Modify(true);
    end;

    local procedure ProdReqWkshTemplateOnAfterVali()
    begin
        "Prod. Wksh. Name" := '';
        Modify(true);
    end;

    local procedure ProdWkshNameOnAfterValidate()
    begin
        Modify(true);
    end;

    local procedure TransferReqWkshTemplateOnAfter()
    begin
        "Transfer Wksh. Name" := '';
        Modify(true);
    end;

    local procedure TransferWkshNameOnAfterValidat()
    begin
        Modify(true);
    end;
}

