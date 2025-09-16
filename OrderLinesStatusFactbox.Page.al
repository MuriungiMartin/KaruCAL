#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36641 "Order Lines Status Factbox"
{
    Caption = 'Sales Lines Status';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = sorting("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date")
                      where("Document Type"=filter(Order|"Return Order"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the record on the document line. ';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the record.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Order No.';
                    Lookup = false;
                    ToolTip = 'Specifies the number of the order.';

                    trigger OnDrillDown()
                    begin
                        GetOrder;
                        case "Document Type" of
                          "document type"::Order:
                            if Page.RunModal(Page::"Sales Order",SalesHeader) = Action::LookupOK then;
                          "document type"::"Return Order":
                            if Page.RunModal(Page::"Sales Return Order",SalesHeader) = Action::LookupOK then;
                        end;
                    end;
                }
                field("SalesHeader.""Order Date""";SalesHeader."Order Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Order Date';
                    Visible = false;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Planned Delivery Date";"Planned Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Planned Shipment Date";"Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Next Shipment Date';
                    ToolTip = 'Specifies the next data a shipment is planned for the order.';
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the item''s unit of measure. ';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Outstanding Quantity";"Outstanding Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how many units on the order line have not yet been shipped.';
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Shipped";"Quantity Shipped")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how many of the units in the Quantity field have been posted as shipped.';
                }
                field("Completely Shipped";"Completely Shipped")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether all the items on the order have been shipped or, in the case of inbound items, completely received.';
                    Visible = false;
                }
                field(LastShipmentDate;LastShipmentDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Last Shipment Date';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        case "Document Type" of
                          "document type"::Order:
                            begin
                              GetLastShipment;
                              if Page.RunModal(Page::"Posted Sales Shipments",SalesShipmentHeader) = Action::LookupOK then;
                            end;
                          "document type"::"Return Order":
                            begin
                              GetLastRetReceipt;
                              if Page.RunModal(Page::"Posted Return Receipts",RetReceiptHeader) = Action::LookupOK then;
                            end;
                        end;
                    end;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how many of the units in the Quantity field have been posted as invoiced.';
                }
                field(LastInvoiceDate;LastInvoiceDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Last Invoice Date';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        case "Document Type" of
                          "document type"::Order:
                            begin
                              GetLastInvoice;
                              if Page.RunModal(Page::"Posted Sales Invoices",SalesInvoiceHeader) = Action::LookupOK then;
                            end;
                          "document type"::"Return Order":
                            begin
                              GetLastCrMemo;
                              if Page.RunModal(Page::"Posted Sales Credit Memos",RetCreditMemoHeader) = Action::LookupOK then;
                            end;
                        end;
                    end;
                }
                field("SalesHeader.Status";SalesHeader.Status)
                {
                    ApplicationArea = Basic;
                    Caption = 'Status';
                    Visible = false;
                }
                field("SalesHeader.""On Hold""";SalesHeader."On Hold")
                {
                    ApplicationArea = Basic;
                    Caption = 'On Hold';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GetLastShipmentInvoice;
        DefaultFromSalesHeader;
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        RetReceiptHeader: Record "Return Receipt Header";
        RetCreditMemoHeader: Record "Sales Cr.Memo Header";
        LastShipmentDate: Date;
        LastInvoiceDate: Date;
        Text000: label 'Warning:  There are orphan sales line records for %1 %2.';


    procedure DefaultFromSalesHeader()
    begin
        GetOrder;
        if "Shipment Date" = 0D then
          "Shipment Date" := SalesHeader."Shipment Date";
        if "Requested Delivery Date" = 0D then
          "Requested Delivery Date" := SalesHeader."Requested Delivery Date";
        if "Promised Delivery Date" = 0D then
          "Promised Delivery Date" := SalesHeader."Promised Delivery Date";
        if CalcDate("Shipping Time",WorkDate) = WorkDate then
          "Shipping Time" := SalesHeader."Shipping Time";
    end;


    procedure GetLastShipmentInvoice()
    begin
        // Calculate values for this row
        // Get order first
        GetOrder;
        // Get shipment and Invoice if they exist
        case "Document Type" of
          "document type"::Order:
            begin
              if GetLastShipment then
                LastShipmentDate := SalesShipmentHeader."Shipment Date"
              else
                LastShipmentDate := 0D;
              if GetLastInvoice then
                LastInvoiceDate := SalesInvoiceHeader."Posting Date"
              else
                LastInvoiceDate := 0D;
            end;
          "document type"::"Return Order":
            begin
              if GetLastRetReceipt then
                LastShipmentDate := RetReceiptHeader."Posting Date"
              else
                LastShipmentDate := 0D;
              if GetLastCrMemo then
                LastInvoiceDate := RetCreditMemoHeader."Posting Date"
              else
                LastInvoiceDate := 0D;
            end;
          else
            begin
            LastShipmentDate := 0D;
            LastInvoiceDate := 0D;
          end;
        end;
    end;


    procedure GetOrder()
    begin
        if (SalesHeader."Document Type" <> "Document Type") or (SalesHeader."No." <> "Document No.") then
          if not SalesHeader.Get("Document Type","Document No.") then
            Message(Text000,"Document Type","Document No.");
    end;


    procedure GetLastShipment(): Boolean
    begin
        SalesShipmentHeader.SetCurrentkey("Order No."/*, "Shipment Date"*/); // may want to create this key
        SalesShipmentHeader.SetRange("Order No.","Document No.");
        exit(SalesShipmentHeader.FindLast);

    end;


    procedure GetLastInvoice(): Boolean
    begin
        SalesInvoiceHeader.SetCurrentkey("Order No."/*, "Shipment Date"*/); // may want to create this key
        SalesInvoiceHeader.SetRange("Order No.","Document No.");
        exit(SalesInvoiceHeader.FindLast);

    end;


    procedure GetLastRetReceipt(): Boolean
    begin
        RetReceiptHeader.SetCurrentkey("Return Order No."/*, "Shipment Date"*/); // may want to create this key
        RetReceiptHeader.SetRange("Return Order No.","Document No.");
        exit(RetReceiptHeader.FindLast);

    end;


    procedure GetLastCrMemo(): Boolean
    begin
        RetCreditMemoHeader.SetCurrentkey("Return Order No."/*, "Shipment Date"*/); // may want to create this key
        RetCreditMemoHeader.SetRange("Return Order No.","Document No.");
        exit(RetCreditMemoHeader.FindLast);

    end;
}

