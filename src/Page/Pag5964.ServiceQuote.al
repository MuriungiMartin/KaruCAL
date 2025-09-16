#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5964 "Service Quote"
{
    Caption = 'Service Quote';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Service Header";
    SourceTableView = where("Document Type"=filter(Quote));

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
                    ToolTip = 'Specifies the code of the responsibility center associated with the user who created the service order.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
            }
            part(ServItemLine;"Service Quote Subform")
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
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact when sending invoices to the customer.';
                }
                field("Your Reference";"Your Reference")
                {
                    ApplicationArea = Basic;
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
                    ToolTip = 'Specifies the maximum unit price that can be set for a resource (for example, a technician) on all service lines linked to this order.';
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
                    Caption = 'Ship-to Phone/Phone 2';
                    ToolTip = 'Specifies the phone number of the address where the service items in the order are located.';
                }
                field("Ship-to Phone 2";"Ship-to Phone 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional phone number of the address.';
                }
                field("Ship-to E-Mail";"Ship-to E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email address of the customer to whom the service will be shipped.';
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
                Provider = ServItemLine;
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
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
                separator(Action163)
                {
                    Caption = '';
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
                        CurrPage.SaveRecord;
                    end;
                }
                separator(Action49)
                {
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
                separator(Action164)
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
                    begin
                        CalcInvDiscForHeader;
                        Commit;
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Service Statistics",Rec)
                        else
                          Page.RunModal(Page::"Service Stats.",Rec)
                    end;
                }
                action("Customer Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Card';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                separator(Action165)
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
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Create Customer")
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
                separator(Action205)
                {
                }
            }
            action("Make &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.Update;
                    Codeunit.Run(Codeunit::"Serv-Quote to Order (Yes/No)",Rec);
                    CurrPage.Update;
                end;
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
        exit(ConfirmDeletion);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckCreditMaxBeforeInsert(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Document Type" := "document type"::Quote;
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

    var
        ServOrderMgt: Codeunit ServOrderManagement;
        UserMgt: Codeunit "User Setup Management";
        ChangeExchangeRate: Page "Change Exchange Rate";

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
}

