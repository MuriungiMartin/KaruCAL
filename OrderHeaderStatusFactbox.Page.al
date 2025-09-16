#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36640 "Order Header Status Factbox"
{
    Caption = 'Sales Order Status';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Header";
    SourceTableView = sorting("Document Type","Combine Shipments","Bill-to Customer No.","Currency Code")
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
                    Editable = false;
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';

                    trigger OnDrillDown()
                    begin
                        case "Document Type" of
                          "document type"::Order:
                            if Page.RunModal(Page::"Sales Order",Rec) = Action::LookupOK then;
                          "document type"::"Return Order":
                            if Page.RunModal(Page::"Sales Return Order",Rec) = Action::LookupOK then;
                        end;
                    end;
                }
                field("Your Reference";"Your Reference")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the related sales order was created.';
                }
                field(LastShipmentDate;LastShipmentDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Last Shipment Date';
                    Editable = false;
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
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Next Shipment Date';
                    Editable = false;
                    ToolTip = 'Specifies the next data a shipment is planned for the order.';
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Completely Shipped";"Completely Shipped")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies whether all the items on the order have been shipped or, in the case of inbound items, completely received.';
                    Visible = false;
                }
                field(LastInvoiceDate;LastInvoiceDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Last Invoice Date';
                    Editable = false;
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
                field("Outstanding Amount ($)";"Outstanding Amount ($)")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Open Amount';
                    Editable = false;
                    ToolTip = 'Specifies the outstanding amount that is calculated, based on the Sales Line table and the Outstanding Amount ($) field.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the status of the document.';
                }
                field("On Hold";"On Hold")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the document was put on hold when it was posted, for example because payment of the resulting customer ledger entries is overdue.';
                }
            }
            group("Open Amounts")
            {
                Caption = 'Open Amounts';
                field(TotalOpenAmount;TotalOpenAmount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Total';
                    Editable = false;
                    ToolTip = 'Specifies the total amount less any invoice discount amount and exclusive of tax for the posted document.';
                }
                field(TotalOpenAmountOnHold;TotalOpenAmountOnHold)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'On Hold';
                    Editable = false;
                    ToolTip = 'Specifies lines that are on orders that are on hold.';
                }
                field(TotalOpenAmountPendingApproval;TotalOpenAmountPendingApproval)
                {
                    ApplicationArea = Suite;
                    Caption = 'Pending Approval';
                    Editable = false;
                    ToolTip = 'Specifies that the document remains to be approved.';
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
        UpdateTotal;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        UpdateTotal;
    end;

    trigger OnOpenPage()
    begin
        UpdateTotal;
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        RetReceiptHeader: Record "Return Receipt Header";
        RetCreditMemoHeader: Record "Sales Cr.Memo Header";
        LastShipmentDate: Date;
        LastInvoiceDate: Date;
        TotalOpenAmount: Decimal;
        TotalOpenAmountOnHold: Decimal;
        TotalOpenAmountPendingApproval: Decimal;


    procedure UpdateTotal()
    begin
        TotalOpenAmount := 0;
        TotalOpenAmountOnHold := 0;
        SalesHeader.Copy(Rec);
        if SalesHeader.FindSet then
          repeat
            SalesHeader.CalcFields("Outstanding Amount ($)");
            TotalOpenAmount := TotalOpenAmount + SalesHeader."Outstanding Amount ($)";
            if SalesHeader."On Hold" <> '' then
              TotalOpenAmountOnHold := TotalOpenAmountOnHold + SalesHeader."Outstanding Amount ($)";
            if SalesHeader.Status = SalesHeader.Status::"Pending Approval" then
              TotalOpenAmountPendingApproval := TotalOpenAmountPendingApproval + SalesHeader."Outstanding Amount ($)";
          until SalesHeader.Next = 0;
    end;


    procedure GetLastShipmentInvoice()
    begin
        // Calculate values for this row
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


    procedure GetLastShipment(): Boolean
    begin
        SalesShipmentHeader.SetCurrentkey("Order No."/*, "Shipment Date"*/); // may want to create this key
        SalesShipmentHeader.SetRange("Order No.","No.");
        exit(SalesShipmentHeader.FindLast);

    end;


    procedure GetLastInvoice(): Boolean
    begin
        SalesInvoiceHeader.SetCurrentkey("Order No."/*, "Shipment Date"*/); // may want to create this key
        SalesInvoiceHeader.SetRange("Order No.","No.");
        exit(SalesInvoiceHeader.FindLast);

    end;


    procedure GetLastRetReceipt(): Boolean
    begin
        RetReceiptHeader.SetCurrentkey("Return Order No."/*, "Shipment Date"*/); // may want to create this key
        RetReceiptHeader.SetRange("Return Order No.","No.");
        exit(RetReceiptHeader.FindLast);

    end;


    procedure GetLastCrMemo(): Boolean
    begin
        RetCreditMemoHeader.SetCurrentkey("Return Order No."/*, "Shipment Date"*/); // may want to create this key
        RetCreditMemoHeader.SetRange("Return Order No.","No.");
        exit(RetCreditMemoHeader.FindLast);

    end;
}

