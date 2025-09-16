#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5793 "Source Documents"
{
    Caption = 'Source Documents';
    DataCaptionFields = Type,"Location Code";
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Request";
    SourceTableView = sorting(Type,"Location Code","Completely Handled","Document Status","Expected Receipt Date","Shipment Date","Source Document","Source No.");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code to which the request line is linked.';
                    Visible = false;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when receipt of the items is expected.';
                    Visible = ExpectedReceiptDateVisible;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the items are expected to be shipped.';
                    Visible = ShipmentDateVisible;
                }
                field("Put-away / Pick No.";"Put-away / Pick No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the inventory put-away or pick that was created from this warehouse request.';
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document, such as sales order, to which the request relates.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document from which the request line originates.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the external document number from the source document related to the warehouse request.';
                }
                field("Destination Type";"Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the type of destination associated with the warehouse request is a customer or a vendor.';
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number or code of the customer or vendor related to the warehouse request.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment method code for the shipment.';
                    Visible = false;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shipping agent who delivers the shipment.';
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping advice, which informs whether partial deliveries are acceptable, copied from the source document header.';
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PurchHeader: Record "Purchase Header";
                        SalesHeader: Record "Sales Header";
                        TransHeader: Record "Transfer Header";
                        ProdOrder: Record "Production Order";
                        ServiceHeader: Record "Service Header";
                    begin
                        case "Source Document" of
                          "source document"::"Purchase Order":
                            begin
                              PurchHeader.Get("Source Subtype","Source No.");
                              Page.Run(Page::"Purchase Order",PurchHeader);
                            end;
                          "source document"::"Purchase Return Order":
                            begin
                              PurchHeader.Get("Source Subtype","Source No.");
                              Page.Run(Page::"Purchase Return Order",PurchHeader);
                            end;
                          "source document"::"Sales Order":
                            begin
                              SalesHeader.Get("Source Subtype","Source No.");
                              Page.Run(Page::"Sales Order",SalesHeader);
                            end;
                          "source document"::"Sales Return Order":
                            begin
                              SalesHeader.Get("Source Subtype","Source No.");
                              Page.Run(Page::"Sales Return Order",SalesHeader);
                            end;
                          "source document"::"Inbound Transfer","source document"::"Outbound Transfer":
                            begin
                              TransHeader.Get("Source No.");
                              Page.Run(Page::"Transfer Order",TransHeader);
                            end;
                          "source document"::"Prod. Consumption","source document"::"Prod. Output":
                            begin
                              ProdOrder.Get("Source Subtype","Source No.");
                              Page.Run(Page::"Released Production Order",ProdOrder);
                            end;
                          "source document"::"Service Order":
                            begin
                              ServiceHeader.Get("Source Subtype","Source No.");
                              Page.Run(Page::"Service Order",ServiceHeader);
                            end;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateVisible;
    end;

    trigger OnInit()
    begin
        ShipmentDateVisible := true;
        ExpectedReceiptDateVisible := true;
    end;

    var
        [InDataSet]
        ExpectedReceiptDateVisible: Boolean;
        [InDataSet]
        ShipmentDateVisible: Boolean;


    procedure GetResult(var WhseReq: Record "Warehouse Request")
    begin
        CurrPage.SetSelectionFilter(WhseReq);
    end;

    local procedure UpdateVisible()
    begin
        ExpectedReceiptDateVisible := Type = Type::Inbound;
        ShipmentDateVisible := Type = Type::Outbound;
    end;
}

