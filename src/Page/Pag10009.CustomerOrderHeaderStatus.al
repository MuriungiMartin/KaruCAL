#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10009 "Customer Order Header Status"
{
    Caption = 'Customer Order Header Status';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = sorting("Document Type","Sell-to Customer No.","No.")
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
                    ToolTip = 'Specifies the type of the document.';
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
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s reference. The content will be printed on sales documents.';
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the related sales order was created.';
                }
                field(LastShipmentDate;LastShipmentDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last Shipment Date';
                    Editable = false;
                    ToolTip = 'Specifies the date when the order was last posted as shipped.';

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
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last Invoice Date';
                    Editable = false;
                    ToolTip = 'Specifies the date when the order was last posted as invoiced.';

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
                    Editable = "On HoldEditable";
                    ToolTip = 'Specifies if the document was put on hold when it was posted, for example because payment of the resulting customer ledger entries is overdue.';
                }
            }
            group(Control20)
            {
                field(TotalOpenAmountOnHold;TotalOpenAmountOnHold)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Total Open Amount On Hold';
                    Editable = false;
                    ToolTip = 'Specifies the total amount on open documents that are on hold.';
                }
                field(TotalOpenAmount;TotalOpenAmount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Total Open Amount';
                    Editable = false;
                    ToolTip = 'Specifies the total amount on open documents.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1900316107;"Customer Details FactBox")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1904036807;"Order Lines Status Factbox")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "Document Type"=filter(Order|"Return Order"),
                              "Document No."=field("No.");
                Visible = true;
            }
            part(Control1904036507;"Customer Credit FactBox")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1902018507;"Customer Statistics FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = true;
            }
            systempart(Control1905767507;Notes)
            {
                Editable = false;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GetLastShipmentInvoice;
        AfterGetCurrentRecord;
    end;

    trigger OnInit()
    begin
        "On HoldEditable" := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        UpdateTotal;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        AfterGetCurrentRecord;
    end;

    trigger OnOpenPage()
    begin
        OnCreditManagementForm(true);
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
        [InDataSet]
        "On HoldEditable": Boolean;


    procedure OnCreditManagementForm(SetOnCreditManagementForm: Boolean)
    begin
        // Make certain Fields editable
        "On HoldEditable" := SetOnCreditManagementForm;
    end;


    procedure UpdateTotal()
    begin
        TotalOpenAmount := 0;
        TotalOpenAmountOnHold := 0;
        SalesHeader.Copy(Rec);
        if SalesHeader.Find('-') then
          repeat
            SalesHeader.CalcFields("Outstanding Amount ($)");
            TotalOpenAmount := TotalOpenAmount + SalesHeader."Outstanding Amount ($)";
            if SalesHeader."On Hold" <> '' then
              TotalOpenAmountOnHold := TotalOpenAmountOnHold + SalesHeader."Outstanding Amount ($)";
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

    local procedure AfterGetCurrentRecord()
    begin
        xRec := Rec;
        UpdateTotal;
    end;
}

