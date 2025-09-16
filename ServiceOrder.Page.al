#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5900 "Service Order"
{
    Caption = 'Service Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Warehouse';
    RefreshOnActivate = true;
    SourceTable = "Service Header";
    SourceTableView = where("Document Type"=filter(Order));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the service document you are creating.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a short description of the service document, such as Order 2001.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer who owns the items in the service document.';

                    trigger OnValidate()
                    begin
                        CustomerNoOnAfterValidate;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom the items on the document will be shipped.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the customer to whom the service will be shipped.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies an alternate address of the customer.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact who will receive the service.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the phone number of the customer in this service order.';
                }
                field("Phone No. 2";"Phone No. 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies your customer''s alternate phone number.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email address of the customer in this service order.';
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact to whom you will deliver the service.';
                }
                field("Notify Customer";"Notify Customer")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies how the customer wants to receive notifications about service completion.';
                }
                field("Service Order Type";"Service Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of this service order.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contract associated with the order.';
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.';
                }
                field("Response Time";"Response Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the priority of the service order.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center associated with the user who created the service order.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Release Status";"Release Status")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies if items in the Service Lines window are ready to be handled in warehouse activities.';
                }
            }
            part(ServItemLines;"Service Order Subform")
            {
                SubPageLink = "Document No."=field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer to whom you send the order invoice.';

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact to whom you will send the invoice.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom you will send invoices.';
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the customer to whom you will send the invoice.';
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies an alternate address of the customer.';
                }
                field("Bill-to City";"Bill-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Bill-to County";"Bill-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP Code of the of the customer that the service order is sent to.';
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact when sending invoices to the customer.';
                }
                field("Bill-to Post Code2";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP Code of the of the customer that the service order is sent to.';
                }
                field("Your Reference";"Your Reference")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies a customer reference, which will be used when printing service documents.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson assigned to this service document.';
                }
                field("Max. Labor Unit Price";"Max. Labor Unit Price")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the maximum unit price that can be set for a resource (for example, a technician) on all service lines linked to this order.';

                    trigger OnValidate()
                    begin
                        MaxLaborUnitPriceOnAfterValida;
                    end;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service document should be posted.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service document was created.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension chosen as Global Dimension 1.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension chosen as Global Dimension 2.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code that represents the service header payment terms, which are used to calculate the due date and payment discount date.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies when the invoice is due.';
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of payment discount given, if the customer pays by the date entered in the Pmt. Discount Date field.';
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date for the customer to pay the invoice and receive a payment discount.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the method the customer uses to pay for the service.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code for the customer'' s address where you will ship the service.';

                    trigger OnValidate()
                    begin
                        ShiptoCodeOnAfterValidate;
                    end;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom you will ship the service on the document.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address where the service on the document should be shipped to.';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the contact person at the place where the service should be shipped to.';
                }
                field("Ship-to Phone";"Ship-to Phone")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Phone';
                    ToolTip = 'Specifies the phone number of the address where the service items in the order are located.';
                }
                field("Ship-to Phone 2";"Ship-to Phone 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional phone number of the address.';
                }
                field("Ship-to E-Mail";"Ship-to E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email address of the customer to whom the service will be shipped.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.';
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies information about whether the customer will accept a partial shipment of the order.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the shipment method of the service order.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that represents a shipping agent.';
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that represents a shipping agent service.';
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time required, from when items on the order are shipped, to when they are delivered to the customer.';
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("Warning Status";"Warning Status")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the response time warning status for the order.';
                }
                field("Link Service to Service Item";"Link Service to Service Item")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that service lines for items and resources must be linked to a service item line.';
                }
                field("Allocated Hours";"Allocated Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of hours allocated to the items in this service order.';
                }
                field("No. of Allocations";"No. of Allocations")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of resource allocations to service items in this order.';
                }
                field("No. of Unallocated Items";"No. of Unallocated Items")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of service items in this order that are not allocated to resources.';
                }
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service zone code of the customer''s ship-to address in the service order.';
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service order was created.';

                    trigger OnValidate()
                    begin
                        OrderDateOnAfterValidate;
                    end;
                }
                field("Order Time";"Order Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when the service order was created.';

                    trigger OnValidate()
                    begin
                        OrderTimeOnAfterValidate;
                    end;
                }
                field("Expected Finishing Date";"Expected Finishing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when service on the order is expected to be finished.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the starting date of the service, that is, the date when the order status changes from Pending, to In Process for the first time.';
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting time of the service, that is, the time when the order status changes from Pending, to In Process for the first time.';
                }
                field("Actual Response Time (Hours)";"Actual Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of hours from order creation, to when the service order status changes from Pending, to In Process.';
                }
                field("Finishing Date";"Finishing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the finishing date of the service, that is, the date when the Status field changes to Finished.';
                }
                field("Finishing Time";"Finishing Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the finishing time of the service, that is, the time when the Status field changes to Finished.';

                    trigger OnValidate()
                    begin
                        FinishingTimeOnAfterValidate;
                    end;
                }
                field("Service Time (Hours)";"Service Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total time in hours that the service specified in the order has taken.';
                }
            }
            group(" Foreign Trade")
            {
                Caption = ' Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code for various amounts on the service lines.';

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          Validate("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a check box in this field if the service order is part of an EU 3-party trade transaction.';
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the transaction type assigned to the service document.';
                }
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transaction specification code used on the service document.';
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the transport method to be used for shipment.';
                }
                field("Exit Point";"Exit Point")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the port of exit through which you ship the service out of your country/region.';
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the area where the customer company is located.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507;"Customer Statistics FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1900316107;"Customer Details FactBox")
            {
                SubPageLink = "No."=field("Customer No.");
                Visible = false;
            }
            part(Control1907829707;"Service Hist. Sell-to FactBox")
            {
                SubPageLink = "No."=field("Customer No.");
                Visible = true;
            }
            part(Control1902613707;"Service Hist. Bill-to FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1906530507;"Service Item Line FactBox")
            {
                Provider = ServItemLines;
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
                Visible = true;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                separator(Action74)
                {
                }
                action("Demand Overview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Demand Overview';
                    Image = Forecast;

                    trigger OnAction()
                    var
                        DemandOverview: Page "Demand Overview";
                    begin
                        DemandOverview.SetCalculationParameter(true);
                        DemandOverview.Initialize(0D,4,"No.",'','');
                        DemandOverview.RunModal;
                    end;
                }
                separator(Action3)
                {
                }
                action("<Action7>")
                {
                    AccessByPermission = TableData "Order Promising Line"=R;
                    ApplicationArea = Basic;
                    Caption = 'Order Promising';
                    Image = OrderPromising;

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "Order Promising Line";
                        OrderPromisingLines: Page "Order Promising Lines";
                    begin
                        Clear(OrderPromisingLines);
                        OrderPromisingLines.SetSourceType(12); // Service order
                        Clear(OrderPromisingLine);
                        OrderPromisingLine.SetRange("Source Type",OrderPromisingLine."source type"::"Service Order");
                        OrderPromisingLine.SetRange("Source ID","No.");
                        OrderPromisingLines.SetTableview(OrderPromisingLine);
                        OrderPromisingLines.RunModal;
                    end;
                }
                separator(Action166)
                {
                    Caption = '';
                }
                action("&Customer Card")
                {
                    ApplicationArea = Basic;
                    Caption = '&Customer Card';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("&Dimensions")
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = '&Dimensions';
                    Enabled = "No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }
                separator(Action170)
                {
                    Caption = '';
                }
                action("Service Document Lo&g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Document Lo&g';
                    Image = Log;

                    trigger OnAction()
                    var
                        ServDocLog: Record "Service Document Log";
                    begin
                        ServDocLog.ShowServDocLog(Rec);
                    end;
                }
                action("Email &Queue")
                {
                    ApplicationArea = Basic;
                    Caption = 'Email &Queue';
                    Image = Email;
                    RunObject = Page "Service Email Queue";
                    RunPageLink = "Document Type"=const("Service Order"),
                                  "Document No."=field("No.");
                    RunPageView = sorting("Document Type","Document No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=const("Service Header"),
                                  "Table Subtype"=field("Document Type"),
                                  "No."=field("No."),
                                  Type=const(General);
                }
            }
            group("<Action36>")
            {
                Caption = 'Statistics';
                Image = Statistics;
                separator(Action5)
                {
                    Caption = '';
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        SalesSetup: Record "Sales & Receivables Setup";
                        ServLine: Record "Service Line";
                        ServLines: Page "Service Lines";
                    begin
                        SalesSetup.Get;
                        if SalesSetup."Calc. Inv. Discount" then begin
                          ServLine.Reset;
                          ServLine.SetRange("Document Type","Document Type");
                          ServLine.SetRange("Document No.","No.");
                          if ServLine.FindFirst then begin
                            ServLines.SetTableview(ServLine);
                            ServLines.CalcInvDisc(ServLine);
                            Commit
                          end;
                        end;
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Service Order Statistics",Rec)
                        else
                          Page.RunModal(Page::"Service Order Stats.",Rec)
                    end;
                }
                separator(Action49)
                {
                    Caption = '';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&hipments';
                    Image = Shipment;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Service Shipments";
                    RunPageLink = "Order No."=field("No.");
                    RunPageView = sorting("Order No.");
                }
                action(Invoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page "Posted Service Invoices";
                    RunPageLink = "Order No."=field("No.");
                    RunPageView = sorting("Order No.");
                }
            }
            group("W&arehouse")
            {
                Caption = 'W&arehouse';
                Image = Warehouse;
                action("Whse. Shipment Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Shipment Lines';
                    Image = ShipmentLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type"=const(5902),
                                  "Source Subtype"=field("Document Type"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Type","Source Subtype","Source No.","Source Line No.");
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Service Order No."=field("No.");
                    RunPageView = sorting("Service Order No.","Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.","Posting Date",Open,Type);
                    ShortCutKey = 'Ctrl+F7';
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Order No."=field("No.");
                    RunPageView = sorting("Service Order No.","Posting Date","Document No.");
                }
                action("&Job Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Job Ledger Entries';
                    Image = JobLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Service Order No."=field("No.");
                    RunPageView = sorting("Service Order No.","Posting Date")
                                  where("Entry Type"=const(Usage));
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Create Customer")
                {
                    ApplicationArea = Basic;
                    Caption = '&Create Customer';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        Clear(ServOrderMgt);
                        ServOrderMgt.CreateNewCustomer(Rec);
                        CurrPage.Update(true);
                    end;
                }
            }
            group(ActionGroup27)
            {
                Caption = 'W&arehouse';
                Image = Warehouse;
                action("Release to Ship")
                {
                    ApplicationArea = Basic;
                    Caption = 'Release to Ship';
                    Image = ReleaseShipment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseServiceDocument: Codeunit "Release Service Document";
                    begin
                        ReleaseServiceDocument.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ReleaseServiceDocument: Codeunit "Release Service Document";
                    begin
                        ReleaseServiceDocument.PerformManualReopen(Rec);
                    end;
                }
                action("Create Whse Shipment")
                {
                    AccessByPermission = TableData "Warehouse Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Create Whse. Shipment';
                    Image = NewShipment;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromServiceOrder(Rec);
                        if not Find('=><') then
                          Init;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(TestReport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    var
                        ReportPrint: Codeunit "Test Report-Print";
                    begin
                        ReportPrint.PrintServiceHeader(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        ServPostYesNo: Codeunit "Service-Post (Yes/No)";
                        InstructionMgt: Codeunit "Instruction Mgt.";
                    begin
                        ServHeader.Get("Document Type","No.");
                        ServPostYesNo.PostDocument(ServHeader);
                        DocumentIsPosted := not ServHeader.Get("Document Type","No.");
                        if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) then
                          ShowPostedConfirmationMessage;
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        ServPostYesNo: Codeunit "Service-Post (Yes/No)";
                    begin
                        ServHeader.Get("Document Type","No.");
                        ServPostYesNo.PreviewDocument(ServHeader);
                        DocumentIsPosted := not ServHeader.Get("Document Type","No.");
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        ServPostPrint: Codeunit "Service-Post+Print";
                    begin
                        ServHeader.Get("Document Type","No.");
                        ServPostPrint.PostDocument(ServHeader);
                    end;
                }
                action("Post &Batch")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        Clear(ServHeader);
                        ServHeader.SetRange(Status,ServHeader.Status::Finished);
                        Report.RunModal(Report::"Batch Post Service Orders",true,true,ServHeader);
                        CurrPage.Update(false);
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    CurrPage.Update(true);
                    DocPrint.PrintServiceHeader(Rec);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        Clear(ServLogMgt);
        ServLogMgt.ServHeaderManualDelete(Rec);
        exit(ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Document Type" := "document type"::Order;
        "Responsibility Center" := UserMgt.GetServiceFilter;
        if "No." = '' then
          SetCustomerFromFilter;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetServiceFilter <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetServiceFilter);
          FilterGroup(0);
        end;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not DocumentIsPosted then
          exit(ConfirmCloseUnposted);
    end;

    var
        ServHeader: Record "Service Header";
        ServOrderMgt: Codeunit ServOrderManagement;
        ServLogMgt: Codeunit ServLogManagement;
        UserMgt: Codeunit "User Setup Management";
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocumentIsPosted: Boolean;
        OpenPostedServiceOrderQst: label 'The order has been posted and moved to the Posted Service Invoices window.\\Do you want to open the posted invoice?';

    local procedure CustomerNoOnAfterValidate()
    begin
        if GetFilter("Customer No.") = xRec."Customer No." then
          if "Customer No." <> xRec."Customer No." then
            SetRange("Customer No.");
        CurrPage.Update;
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure MaxLaborUnitPriceOnAfterValida()
    begin
        CurrPage.SaveRecord;
    end;

    local procedure ShiptoCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure OrderTimeOnAfterValidate()
    begin
        UpdateResponseDateTime;
        CurrPage.Update;
    end;

    local procedure OrderDateOnAfterValidate()
    begin
        UpdateResponseDateTime;
        CurrPage.Update;
    end;

    local procedure FinishingTimeOnAfterValidate()
    begin
        CurrPage.Update(true);
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        OrderServiceHeader: Record "Service Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if not OrderServiceHeader.Get("Document Type","No.") then begin
          ServiceInvoiceHeader.SetRange("No.",ServHeader."Last Posting No.");
          if ServiceInvoiceHeader.FindFirst then
            if InstructionMgt.ShowConfirm(OpenPostedServiceOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) then
              Page.Run(Page::"Posted Service Invoice",ServiceInvoiceHeader);
        end;
    end;
}

