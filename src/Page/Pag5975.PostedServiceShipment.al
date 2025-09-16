#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5975 "Posted Service Shipment"
{
    Caption = 'Posted Service Shipment';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Service Shipment Header";

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
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the shipment.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a description of the order from which the shipment was posted.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer who owns the items on the service order.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the address of the customer of the posted service shipment.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional line in the address.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the city of the address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person at the customer company.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the customer phone number.';
                }
                field("Phone No. 2";"Phone No. 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an alternate phone number of the customer.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the email address of the customer.';
                }
                field("Notify Customer";"Notify Customer")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies in what way the customer wants to receive notifications about the service completed.';
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the contact person at the customer''s site.';
                }
                field("Service Order Type";"Service Order Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of the service order from which the shipment was created.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the contract associated with the service order.';
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the approximate date when work on the service order started.';
                }
                field("Response Time";"Response Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the approximate time when work on the service order started.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the priority of the posted service order.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the service order from which the shipment was created.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the responsibility center (for example, a distribution center) assigned to the customer or associated with the service order.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies how many times the shipment has been printed.';
                }
            }
            part(ServShipmentItemLines;"Posted Service Shpt. Subform")
            {
                SubPageLink = "No."=field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer to whom you send the invoice.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer you will send the invoice to.';
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the address to which you will send the invoice.';
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Bill-to City";"Bill-to City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the city of the customer address.';
                }
                field("Bill-to County";"Bill-to County")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the county of the customer that the invoice is sent to.';
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person to whom you send the invoice.';
                }
                field("Your Reference";"Your Reference")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a reference to the customer.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the salesperson assigned to the service order.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the shipment was posted.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when the original service document was created.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the Shortcut Dimension 1, which is defined in the Shortcut Dimension 1 Code field in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the Shortcut Dimension 2, which is defined in the Shortcut Dimension 2 Code field in the General Ledger Setup window.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the customer'' s address.';
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the address where the service is shipped.';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person at the site where the service has been shipped.';
                }
                field("Ship-to Phone";"Ship-to Phone")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Phone/Phone 2';
                    Editable = false;
                    ToolTip = 'Specifies the customer phone number.';
                }
                field("Ship-to Phone 2";"Ship-to Phone 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an alternate phone number of the customer.';
                }
                field("Ship-to E-Mail";"Ship-to E-Mail")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the email address of the customer.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the location, such as warehouse or distribution center, from where the items on the order were shipped.';
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("Warning Status";"Warning Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the warning status for the response time on the original service order.';
                }
                field("Link Service to Service Item";"Link Service to Service Item")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value in this field from the Link Service to Service Item field on the service header.';
                }
                field("Allocated Hours";"Allocated Hours")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of hours allocated to the items within the posted service order.';
                }
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the service zone code assigned to the customer.';
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the service order was created.';
                }
                field("Order Time";"Order Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time when the service order was created.';
                }
                field("Expected Finishing Date";"Expected Finishing Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when service on the order is expected to be finished.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the starting date of the service on the shipment.';
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the starting time of the service on the shipment.';
                }
                field("Actual Response Time (Hours)";"Actual Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the hours since the creation of the service order, to the time when the order status was changed from Pending to In Process.';
                }
                field("Finishing Date";"Finishing Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when the service is finished.';
                }
                field("Finishing Time";"Finishing Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time when the service is finished.';
                }
                field("Service Time (Hours)";"Service Time (Hours)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the total time in hours that the service on the service order has taken.';
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the currency code for various amounts on the shipment.';
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies that the shipment was a part of an EU 3-party trade transaction.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Shipment")
            {
                Caption = '&Shipment';
                Image = Shipment;
                separator(Action12)
                {
                }
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Document Type"=const(Shipment),
                                  "Document No."=field("No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Document No."=field("No.");
                    RunPageView = sorting("Document No.","Posting Date");
                }
                action("&Job Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Job Ledger Entries';
                    Image = JobLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Document No."=field("No.");
                }
                separator(Action39)
                {
                }
                action("&Allocations")
                {
                    ApplicationArea = Basic;
                    Caption = '&Allocations';
                    Image = Allocations;
                    RunObject = Page "Service Order Allocations";
                    RunPageLink = "Document Type"=const(Order),
                                  "Document No."=field("Order No.");
                    RunPageView = sorting(Status,"Document Type","Document No.","Service Item Line No.","Allocation Date","Starting Time",Posted);
                }
                separator(Action147)
                {
                }
                action("S&tatistics")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&tatistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Shipment Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "No."=field("No."),
                                  "Table Name"=const("Service Shipment Header"),
                                  Type=const(General);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                separator(Action150)
                {
                }
                action("Service Document Lo&g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Document Lo&g';
                    Image = Log;

                    trigger OnAction()
                    var
                        ServDocLog: Record "Service Document Log";
                        TempServDocLog: Record "Service Document Log" temporary;
                    begin
                        TempServDocLog.Reset;
                        TempServDocLog.DeleteAll;

                        ServDocLog.Reset;
                        ServDocLog.SetRange("Document Type",ServDocLog."document type"::Shipment);
                        ServDocLog.SetRange("Document No.","No.");
                        if ServDocLog.FindSet then
                          repeat
                            TempServDocLog := ServDocLog;
                            TempServDocLog.Insert;
                          until ServDocLog.Next = 0;

                        ServDocLog.Reset;
                        ServDocLog.SetRange("Document Type",ServDocLog."document type"::Order);
                        ServDocLog.SetRange("Document No.","Order No.");
                        if ServDocLog.FindSet then
                          repeat
                            TempServDocLog := ServDocLog;
                            TempServDocLog.Insert;
                          until ServDocLog.Next = 0;

                        TempServDocLog.Reset;
                        TempServDocLog.SetCurrentkey("Change Date","Change Time");
                        TempServDocLog.Ascending(false);

                        Page.Run(0,TempServDocLog);
                    end;
                }
                action("Service Email &Queue")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Email &Queue';
                    Image = Email;
                    RunObject = Page "Service Email Queue";
                    RunPageLink = "Document Type"=const("Service Order"),
                                  "Document No."=field("Order No.");
                    RunPageView = sorting("Document Type","Document No.");
                }
                action(CertificateOfSupplyDetails)
                {
                    ApplicationArea = Basic;
                    Caption = 'Certificate of Supply Details';
                    Image = Certificate;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Certificates of Supply";
                    RunPageLink = "Document Type"=filter("Service Shipment"),
                                  "Document No."=field("No.");
                }
                action(PrintCertificateofSupply)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Certificate of Supply';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CertificateOfSupply: Record "Certificate of Supply";
                    begin
                        CertificateOfSupply.SetRange("Document Type",CertificateOfSupply."document type"::"Service Shipment");
                        CertificateOfSupply.SetRange("Document No.","No.");
                        CertificateOfSupply.Print;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(ServShptHeader);
                    ServShptHeader.PrintRecords(true);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then
          exit(true);
        SetRange("No.");
        exit(Find(Which));
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Codeunit.Run(Codeunit::"Shipment Header - Edit",Rec);
        exit(false);
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    var
        ServShptHeader: Record "Service Shipment Header";
}

