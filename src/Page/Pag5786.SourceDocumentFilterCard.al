#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5786 "Source Document Filter Card"
{
    Caption = 'Source Document Filter Card';
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Warehouse Source Filter";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that identifies the filter record.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of filter combinations in the Source Document Filter Card window to retrieve lines from source documents.';
                }
                field("Source No. Filter";"Source No. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number, or number range, that is used to filter the source documents to get.';
                }
                field("Item No. Filter";"Item No. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number used to filter the source documents to get.';
                }
                field("Variant Code Filter";"Variant Code Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item variant used to filter the source documents to get.';
                }
                field("Unit of Measure Filter";"Unit of Measure Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure used to filter the source documents to get.';
                }
                field("Shipment Method Code Filter";"Shipment Method Code Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment method code used to filter the source documents to get.';
                }
                field("Show Filter Request";"Show Filter Request")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Filters to Get Source Docs. window appears when you choose Use Filters to Get Source Docs on a warehouse shipment or receipt.';
                }
                field("Sales Return Orders";"Sales Return Orders")
                {
                    ApplicationArea = Basic;
                    Enabled = SalesReturnOrdersEnable;
                    ToolTip = 'Specifies that sales return orders are retrieved when you choose Use Filters to Get Src. Docs in the Warehouse Shipment window.';
                }
                field("Purchase Orders";"Purchase Orders")
                {
                    ApplicationArea = Basic;
                    Enabled = PurchaseOrdersEnable;
                    ToolTip = 'Specifies that purchase orders are retrieved when you choose Use Filters to Get Src. Docs in the Warehouse Receipt window.';
                }
                field("Inbound Transfers";"Inbound Transfers")
                {
                    ApplicationArea = Basic;
                    Enabled = InboundTransfersEnable;
                    ToolTip = 'Specifies that inbound transfer orders are retrieved when you choose Use Filters to Get Src. Docs in the Warehouse Receipt.';

                    trigger OnValidate()
                    begin
                        InboundTransfersOnAfterValidat;
                    end;
                }
                field("Shipping Agent Code Filter";"Shipping Agent Code Filter")
                {
                    ApplicationArea = Basic;
                    Enabled = ShippingAgentCodeFilterEnable;
                    ToolTip = 'Specifies the shipping agent code used to filter the source documents.';
                }
                field("Shipping Agent Service Filter";"Shipping Agent Service Filter")
                {
                    ApplicationArea = Basic;
                    Enabled = ShippingAgentServiceFilterEnab;
                    ToolTip = 'Specifies the shipping agent service used to filter the source documents.';
                }
                field("Do Not Fill Qty. to Handle";"Do Not Fill Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that inventory quantities are assigned when you get outbound source document lines for shipment.';
                }
                group("Source Document:")
                {
                    Caption = 'Source Document:';
                    field("Sales Orders";"Sales Orders")
                    {
                        ApplicationArea = Basic;
                        Enabled = SalesOrdersEnable;
                        ToolTip = 'Specifies that sales orders are retrieved when you choose Use Filters to Get Src. Docs in the Warehouse Shipment window.';

                        trigger OnValidate()
                        begin
                            SalesOrdersOnAfterValidate;
                        end;
                    }
                    field("Service Orders";"Service Orders")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies that service lines with a Released to Ship status are retrieved by the function that gets source documents for warehouse shipment.';
                    }
                    field("Purchase Return Orders";"Purchase Return Orders")
                    {
                        ApplicationArea = Basic;
                        Enabled = PurchaseReturnOrdersEnable;
                        ToolTip = 'Specifies that purchase return orders are retrieved when you choose Use Filters to Get Src. Docs in the Warehouse Shipment window.';
                    }
                    field("Outbound Transfers";"Outbound Transfers")
                    {
                        ApplicationArea = Basic;
                        Enabled = OutboundTransfersEnable;
                        ToolTip = 'Specifies that outbound transfer orders are retrieved when you choose Use Filters to Get Src. Docs in the Warehouse Shipment window.';

                        trigger OnValidate()
                        begin
                            OutboundTransfersOnAfterValida;
                        end;
                    }
                }
                group("Shipping Advice Filter:")
                {
                    Caption = 'Shipping Advice Filter:';
                    field(Partial;Partial)
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies the Shipping Advice field on sales orders must contain Partial when you choose Use Filters to Get Src. Docs.';
                    }
                    field(Complete;Complete)
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies the Shipping Advice field on sales orders must contain Complete when you choose Use Filters to Get Src. Docs.';
                    }
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                field("Sell-to Customer No. Filter";"Sell-to Customer No. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sell-to customer number used to filter the source documents to get.';
                }
            }
            group(Purchase)
            {
                Caption = 'Purchase';
                field("Buy-from Vendor No. Filter";"Buy-from Vendor No. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the buy-from vendor number used to filter the source documents to get.';
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                field("In-Transit Code Filter";"In-Transit Code Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the in-transit code used to filter the source documents.';
                }
                field("Transfer-from Code Filter";"Transfer-from Code Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transfer-from code used to filter the source documents.';
                }
                field("Transfer-to Code Filter";"Transfer-to Code Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transfer-to code used to filter the source documents to get.';
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field("Customer No. Filter";"Customer No. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which customers are included when you use the Filters to Get Source Docs. window to retrieve source document lines.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Run)
            {
                ApplicationArea = Basic;
                Caption = '&Run';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GetSourceBatch: Report "Get Source Documents";
                begin
                    "Planned Delivery Date" := CopyStr(GetFilter("Planned Delivery Date Filter"),1,MaxStrLen("Planned Delivery Date"));
                    "Planned Shipment Date" := CopyStr(GetFilter("Planned Shipment Date Filter"),1,MaxStrLen("Planned Shipment Date"));
                    "Sales Shipment Date" := CopyStr(GetFilter("Sales Shipment Date Filter"),1,MaxStrLen("Sales Shipment Date"));
                    "Planned Receipt Date" := CopyStr(GetFilter("Planned Receipt Date Filter"),1,MaxStrLen("Planned Receipt Date"));
                    "Expected Receipt Date" := CopyStr(GetFilter("Expected Receipt Date Filter"),1,MaxStrLen("Expected Receipt Date"));
                    "Shipment Date" := CopyStr(GetFilter("Shipment Date Filter"),1,MaxStrLen("Shipment Date"));
                    "Receipt Date" := CopyStr(GetFilter("Receipt Date Filter"),1,MaxStrLen("Receipt Date"));

                    case RequestType of
                      Requesttype::Receive:
                        begin
                          GetSourceBatch.SetOneCreatedReceiptHeader(WhseReceiptHeader);
                          SetFilters(GetSourceBatch,WhseReceiptHeader."Location Code");
                        end;
                      Requesttype::Ship:
                        begin
                          GetSourceBatch.SetOneCreatedShptHeader(WhseShptHeader);
                          SetFilters(GetSourceBatch,WhseShptHeader."Location Code");
                        end;
                    end;

                    GetSourceBatch.UseRequestPage("Show Filter Request");
                    GetSourceBatch.RunModal;
                    if GetSourceBatch.NotCancelled then
                      CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        ShippingAgentServiceFilterEnab := true;
        ShippingAgentCodeFilterEnable := true;
        InboundTransfersEnable := true;
        SalesReturnOrdersEnable := true;
        PurchaseOrdersEnable := true;
        OutboundTransfersEnable := true;
        PurchaseReturnOrdersEnable := true;
        SalesOrdersEnable := true;
    end;

    trigger OnOpenPage()
    begin
        DataCaption := CurrPage.Caption;
        FilterGroup := 2;
        if GetFilter(Type) <> '' then
          DataCaption := DataCaption + ' - ' + GetFilter(Type);
        FilterGroup := 0;
        CurrPage.Caption(DataCaption);

        EnableControls;
    end;

    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        DataCaption: Text[250];
        RequestType: Option Receive,Ship;
        [InDataSet]
        SalesOrdersEnable: Boolean;
        [InDataSet]
        PurchaseReturnOrdersEnable: Boolean;
        [InDataSet]
        OutboundTransfersEnable: Boolean;
        [InDataSet]
        PurchaseOrdersEnable: Boolean;
        [InDataSet]
        SalesReturnOrdersEnable: Boolean;
        [InDataSet]
        InboundTransfersEnable: Boolean;
        [InDataSet]
        ShippingAgentCodeFilterEnable: Boolean;
        [InDataSet]
        ShippingAgentServiceFilterEnab: Boolean;


    procedure SetOneCreatedShptHeader(WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        RequestType := Requesttype::Ship;
        WhseShptHeader := WhseShptHeader2;
    end;


    procedure SetOneCreatedReceiptHeader(WhseReceiptHeader2: Record "Warehouse Receipt Header")
    begin
        RequestType := Requesttype::Receive;
        WhseReceiptHeader := WhseReceiptHeader2;
    end;

    local procedure EnableControls()
    begin
        case Type of
          Type::Inbound:
            begin
              SalesOrdersEnable := false;
              PurchaseReturnOrdersEnable := false;
              OutboundTransfersEnable := false;
            end;
          Type::Outbound:
            begin
              PurchaseOrdersEnable := false;
              SalesReturnOrdersEnable := false;
              InboundTransfersEnable := false;
            end;
        end;
        if "Sales Orders" or "Inbound Transfers" or "Outbound Transfers" then begin
          ShippingAgentCodeFilterEnable := true;
          ShippingAgentServiceFilterEnab := true;
        end else begin
          ShippingAgentCodeFilterEnable := false;
          ShippingAgentServiceFilterEnab := false;
        end;
    end;

    local procedure SalesOrdersOnAfterValidate()
    begin
        EnableControls;
    end;

    local procedure InboundTransfersOnAfterValidat()
    begin
        EnableControls;
    end;

    local procedure OutboundTransfersOnAfterValida()
    begin
        EnableControls;
    end;
}

