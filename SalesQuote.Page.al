#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 41 "Sales Quote"
{
    Caption = 'Sales Quote';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Quote,View,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
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
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the sales document. The field can be filled automatically or manually and can be set up to be invisible.';
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer';
                    Importance = Promoted;
                    NotBlank = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default. The value is automatically inserted from the customer card when you fill the Sell-to Customer No. field. The value will appear on the printed sales document.';

                    trigger OnValidate()
                    var
                        ApplicationAreaSetup: Record "Application Area Setup";
                    begin
                        if GetFilter("Sell-to Customer No.") = xRec."Sell-to Customer No." then
                          if "Sell-to Customer No." <> xRec."Sell-to Customer No." then
                            SetRange("Sell-to Customer No.");

                        CurrPage.Update;

                        if ApplicationAreaSetup.IsFoundationEnabled then
                          SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                    end;
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field("Sell-to Address";"Sell-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Importance = Additional;
                        ToolTip = 'Specifies the address where the customer is located.';
                    }
                    field("Sell-to Address 2";"Sell-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Sell-to City";"Sell-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Importance = Additional;
                        ToolTip = 'Specifies the city where the customer is located.';
                    }
                    field("Sell-to County";"Sell-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Sell-to Post Code";"Sell-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Sell-to Contact No.";"Sell-to Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact that the sales document will be sent to.';

                        trigger OnValidate()
                        begin
                            ClearSellToFilter;
                            ActivateFields;
                            CurrPage.Update
                        end;
                    }
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the name of the person to contact at the customer.';
                }
                field("No. of Archived Versions";"No. of Archived Versions")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of archived versions for this sales document.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        SalesHeaderArchive.SetRange("Document Type","document type"::Quote);
                        SalesHeaderArchive.SetRange("No.","No.");
                        SalesHeaderArchive.SetRange("Doc. No. Occurrence","Doc. No. Occurrence");
                        if SalesHeaderArchive.Get("document type"::Quote,"No.","Doc. No. Occurrence","No. of Archived Versions") then ;
                        Page.RunModal(Page::"Sales List Archive",SalesHeaderArchive);
                        CurrPage.Update(false);
                    end;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the date on which the exchange rate applies to prices listed in a foreign currency on the sales order.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the date on which you created the sales document.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the salesperson who is assigned to the customer.';

                    trigger OnValidate()
                    begin
                        CurrPage.SalesLines.Page.UpdateForm(true)
                    end;
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the campaign number the document is linked to.';
                }
                field("Opportunity No.";"Opportunity No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the number of the opportunity that the sales quote is assigned to.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    AccessByPermission = TableData "Responsibility Center"=R;
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center that is associated with the user, company, or vendor.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                }
                group("Work Description")
                {
                    Caption = 'Work Description';
                    field(WorkDescription;WorkDescription)
                    {
                        ApplicationArea = Basic;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the products or service being offered';

                        trigger OnValidate()
                        begin
                            SetWorkDescription(WorkDescription);
                        end;
                    }
                }
            }
            part(SalesLines;"Sales Quote Subform")
            {
                ApplicationArea = Basic,Suite;
                Editable = "Sell-to Customer No." <> '';
                Enabled = "Sell-to Customer No." <> '';
                SubPageLink = "Document No."=field("No.");
                UpdatePropagation = Both;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency of amounts on the sales document.';

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          Validate("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                        SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                    end;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date you expect to ship items on the sales document.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount on the sales document.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how the customer must pay for products on the sales document.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                }
                group(Control47)
                {
                    Visible = PaymentServiceVisible;
                    field(SelectedPayments;GetSelectedPaymentServicesText)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Service';
                        Editable = false;
                        Enabled = PaymentServiceEnabled;
                        MultiLine = true;
                        ToolTip = 'Specifies the online payment service, such as PayPal, that customers can use to pay the sales document.';

                        trigger OnAssistEdit()
                        begin
                            ChangePaymentServiceSetting;
                        end;
                    }
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of transaction that the sales document represents, for the purpose of reporting to Intrastat.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update
                    end;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update
                    end;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment discount percentage that is granted if the customer pays on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.';
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the last date the customer can pay the invoice and still receive a payment discount.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
            }
            group("Shipping and Billing")
            {
                Caption = 'Shipping and Billing';
                Enabled = "Sell-to Customer No." <> '';
                group(Control60)
                {
                    group(Control53)
                    {
                        field(ShippingOptions;ShipToOptions)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Ship-to';
                            ToolTip = 'Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer''s sell-to address. Alternate Ship-to Address: One of the customer''s alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.';

                            trigger OnValidate()
                            var
                                ShipToAddress: Record "Ship-to Address";
                                ShipToAddressList: Page "Ship-to Address List";
                            begin
                                case ShipToOptions of
                                  Shiptooptions::"Default (Sell-to Address)":
                                    begin
                                      Validate("Ship-to Code",'');
                                      CopySellToAddressToShipToAddress;
                                    end;
                                  Shiptooptions::"Alternate Shipping Address":
                                    begin
                                      ShipToAddress.SetRange("Customer No.","Sell-to Customer No.");
                                      ShipToAddressList.LookupMode := true;
                                      ShipToAddressList.SetTableview(ShipToAddress);

                                      if ShipToAddressList.RunModal = Action::LookupOK then begin
                                        ShipToAddressList.GetRecord(ShipToAddress);
                                        Validate("Ship-to Code",ShipToAddress.Code);
                                      end else
                                        ShipToOptions := Shiptooptions::"Custom Address";
                                    end;
                                  Shiptooptions::"Custom Address":
                                    Validate("Ship-to Code",'');
                                end;
                            end;
                        }
                        group(Control72)
                        {
                            Visible = not (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
                            field("Ship-to Code";"Ship-to Code")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Code';
                                Editable = ShipToOptions = ShipToOptions::"Alternate Shipping Address";
                                Importance = Promoted;
                                ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';

                                trigger OnValidate()
                                begin
                                    if (xRec."Ship-to Code" <> '') and ("Ship-to Code" = '') then
                                      Error(EmptyShipToCodeErr);
                                end;
                            }
                            field("Ship-to Name";"Ship-to Name")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Name';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                            }
                            field("Ship-to Address";"Ship-to Address")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Address';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the address that products on the sales document will be shipped to. By default, the field is filled with the value in the Address field on the customer card or with the value in the Address field in the Ship-to Address window.';
                            }
                            field("Ship-to Address 2";"Ship-to Address 2")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Address 2';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies additional address information.';
                            }
                            field("Ship-to City";"Ship-to City")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'City';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the city that products on the sales document will be shipped to.';
                            }
                            field("Ship-to County";"Ship-to County")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'State';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the state as a part of the address.';
                            }
                            field("Ship-to Post Code";"Ship-to Post Code")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'ZIP Code';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the ZIP code.';
                            }
                            field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Country/Region';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                            }
                            field("Ship-to Contact";"Ship-to Contact")
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Contact';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the name of the contact person at the address that products on the sales document will be shipped to.';
                            }
                        }
                    }
                    group("Shipment Method")
                    {
                        Caption = 'Shipment Method';
                        field("Shipment Method Code";"Shipment Method Code")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Code';
                            Importance = Additional;
                            ToolTip = 'Specifies how items on the sales document are shipped to the customer.';
                        }
                        field("Shipping Agent Code";"Shipping Agent Code")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Agent';
                            Importance = Additional;
                            ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                        }
                        field("Shipping Agent Service Code";"Shipping Agent Service Code")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Agent service';
                            Importance = Additional;
                            ToolTip = 'Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
                        }
                        field("Package Tracking No.";"Package Tracking No.")
                        {
                            ApplicationArea = Suite;
                            Importance = Additional;
                            ToolTip = 'Specifies the shipping agent''s package number.';
                        }
                    }
                }
                group(Control49)
                {
                    field(BillToOptions;BillToOptions)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Bill-to';
                        ToolTip = 'Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.';

                        trigger OnValidate()
                        begin
                            if BillToOptions = Billtooptions::"Default (Customer)" then
                              Validate("Bill-to Customer No.","Sell-to Customer No.");
                        end;
                    }
                    group(Control41)
                    {
                        Visible = BillToOptions = BillToOptions::"Another Customer";
                    }
                    field("Bill-to Name";"Bill-to Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Name';
                        Enabled = EnableBillToCustomerNo;
                        Importance = Promoted;
                        ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';

                        trigger OnValidate()
                        var
                            ApplicationAreaSetup: Record "Application Area Setup";
                        begin
                            if GetFilter("Bill-to Customer No.") = xRec."Bill-to Customer No." then
                              if "Bill-to Customer No." <> xRec."Bill-to Customer No." then
                                SetRange("Bill-to Customer No.");

                            if ApplicationAreaSetup.IsFoundationEnabled then
                              SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);

                            CurrPage.Update;
                        end;
                    }
                    field("Bill-to Address";"Bill-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the customer that you will send the invoice to.';
                    }
                    field("Bill-to Address 2";"Bill-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Bill-to City";"Bill-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Importance = Additional;
                        ToolTip = 'Specifies the city you will send the invoice to.';
                    }
                    field("Bill-to County";"Bill-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Bill-to Post Code";"Bill-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Bill-to Contact No.";"Bill-to Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact the invoice will be sent to.';
                    }
                    field("Bill-to Contact";"Bill-to Contact")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact';
                        ToolTip = 'Specifies the name of the person you should contact at the customer who you are sending the invoice to.';
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the sales document is part of a three-party trade.';
                }
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the sales document''s transaction specification, for the purpose of reporting to INTRASTAT.';
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
                }
                field("Exit Point";"Exit Point")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.';
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the area of the customer''s address, for the purpose of reporting to INTRASTAT.';
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
                Visible = false;
            }
            part(Control11;"Pending Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID"=const(36),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1903720907;"Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No."=field("Sell-to Customer No.");
            }
            part(Control1907234507;"Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1902018507;"Customer Statistics FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1900316107;"Customer Details FactBox")
            {
                SubPageLink = "No."=field("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1906127307;"Sales Line FactBox")
            {
                ApplicationArea = Suite;
                Provider = SalesLines;
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
            }
            part(Control1901314507;"Item Invoicing FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No."=field("No.");
                Visible = false;
            }
            part(Control1906354007;"Approval FactBox")
            {
                SubPageLink = "Table ID"=const(36),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
                Visible = false;
            }
            part(Control1907012907;"Resource Details FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No."=field("No.");
                Visible = false;
            }
            part(WorkflowStatus;"Workflow Status FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
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
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry"=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(Database::"Sales Header","Document Type","No.");
                        ApprovalEntries.Run;
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Enabled = "No." <> '';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("&View")
            {
                Caption = '&View';
                action(Customer)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Enabled = CustomerSelected;
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View details on the selected customer.';
                }
                action("C&ontact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'C&ontact';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Contact Card";
                    RunPageLink = "No."=field("Sell-to Contact No.");
                    ToolTip = 'View details on the selected contact.';
                }
            }
        }
        area(processing)
        {
            group(ActionGroup59)
            {
                Caption = '&Quote';
                Image = Quote;
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
                        Handled: Boolean;
                    begin
                        OnBeforeStatisticsAction(Rec,Handled);
                        if not Handled then begin
                          CalcInvDiscForHeader;
                          Commit;
                          if "Tax Area Code" = '' then
                            Page.RunModal(Page::"Sales Statistics",Rec)
                          else
                            Page.RunModal(Page::"Sales Stats.",Rec);
                        end
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
                action(Print)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                    Visible = not IsOfficeAddin;

                    trigger OnAction()
                    begin
                        CheckSalesCheckAllLinesHaveQuantityAssigned;
                        DocPrint.PrintSalesHeader(Rec);
                    end;
                }
                action(Email)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Send by &Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Prepare to mail the document. The Send Email window opens prefilled with the customer''s email address so you can add or edit information.';

                    trigger OnAction()
                    begin
                        CheckSalesCheckAllLinesHaveQuantityAssigned;
                        if not Find then
                          Insert(true);
                        DocPrint.EmailSalesHeader(Rec);
                    end;
                }
                action(GetRecurringSalesLines)
                {
                    ApplicationArea = Suite;
                    Caption = 'Get Recurring Sales Lines';
                    Ellipsis = true;
                    Image = CustomerCode;
                    ToolTip = 'Get standard sales lines that are available to assign to customers.';

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                action(CopyDocument)
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.';

                    trigger OnAction()
                    begin
                        if not Find then begin
                          Insert(true);
                          Commit;
                        end;
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                        if Get("Document Type","No.") then;
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'View or add comments.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Create)
            {
                Caption = 'Create';
                Image = NewCustomer;
                action("Make Order")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Convert the sales quote to a sales order.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                          Codeunit.Run(Codeunit::"Sales-Quote to Order (Yes/No)",Rec);
                    end;
                }
                action(MakeInvoice)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Make Invoice';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Convert the sales quote to a sales invoice.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then begin
                          CheckSalesCheckAllLinesHaveQuantityAssigned;
                          Codeunit.Run(Codeunit::"Sales-Quote to Invoice Yes/No",Rec);
                        end;
                    end;
                }
                action("C&reate Customer")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&reate Customer';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        if CheckCustomerCreated(false) then
                          CurrPage.Update(true);
                    end;
                }
                action("Create &To-do")
                {
                    AccessByPermission = TableData Contact=R;
                    ApplicationArea = Basic;
                    Caption = 'Create &To-do';
                    Image = NewToDo;

                    trigger OnAction()
                    begin
                        CreateTodo;
                    end;
                }
            }
            group(ActionGroup3)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open';
                    Enabled = Status <> Status::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = Approval;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                          ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalculateInvoiceDiscount)
                {
                    AccessByPermission = TableData "Cust. Invoice Disc."=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    ToolTip = 'Calculate the invoice discount that applies to the sales quote.';

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                        SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                separator(Action139)
                {
                }
                action("Archive Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchiveSalesDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = Basic;
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document"=R;
                        ApplicationArea = Basic;
                        Caption = 'Select Incoming Document';
                        Image = SelectLineToApply;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            Validate("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RecordId));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = not HasIncomingDocument;
                        Image = Attach;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromSalesDocument(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Remove Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            if IncomingDocument.Get("Incoming Document Entry No.") then
                              IncomingDocument.RemoveLinkToRelatedRecord;
                            "Incoming Document Entry No." := 0;
                            Modify(true);
                        end;
                    }
                }
            }
        }
        area(reporting)
        {
            action("Sales Promotion")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Promotion';
                Image = "Report";
                RunObject = Report "Sales Promotion";
                ToolTip = 'View the sales promotions that you have set up using the prices option on the sales pull-down menu on the item card. This report can show future sales promotions that have been set up but have not yet occurred, as well as sales promotions that have occurred but have not been deleted.';
            }
            action("Customer/Item Statistics")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer/Item Statistics';
                Image = "Report";
                RunObject = Report "Customer/Item Statistics";
                ToolTip = 'View statistics about what items have been purchased by which customers.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ActivateFields;
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.Page.SetFilterOnWorkflowRecord(RecordId);
        UpdatePaymentService;
        SetControlAppearance;
    end;

    trigger OnAfterGetRecord()
    begin
        ActivateFields;
        SetControlAppearance;
        WorkDescription := GetWorkDescription;
        UpdateShipToBillToGroupVisibility
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        EnableBillToCustomerNo := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if DocNoVisible then
          CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetSalesFilter;
        if (not DocNoVisible) and ("No." = '') then
          SetSellToCustomerFromFilter;

        SetDefaultPaymentServices;
        SetControlAppearance;
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        if UserMgt.GetSalesFilter <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetSalesFilter);
          FilterGroup(0);
        end;

        ActivateFields;

        SetDocNoVisible;
        IsOfficeAddin := OfficeMgt.IsAvailable;
        SetControlAppearance;
    end;

    var
        SalesHeaderArchive: Record "Sales Header Archive";
        CopySalesDoc: Report "Copy Sales Document";
        DocPrint: Codeunit "Document-Print";
        UserMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        ChangeExchangeRate: Page "Change Exchange Rate";
        [InDataSet]
        EnableBillToCustomerNo: Boolean;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        IsOfficeAddin: Boolean;
        CanCancelApprovalForRecord: Boolean;
        PaymentServiceVisible: Boolean;
        PaymentServiceEnabled: Boolean;
        CustomerSelected: Boolean;
        WorkDescription: Text;
        ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
        BillToOptions: Option "Default (Customer)","Another Customer";
        EmptyShipToCodeErr: label 'The Code field can only be empty if you select Custom Address in the Ship-to field.';

    local procedure ActivateFields()
    begin
        EnableBillToCustomerNo := "Bill-to Customer Template Code" = '';
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.Page.ApproveCalcInvDisc;
    end;

    local procedure ClearSellToFilter()
    begin
        if GetFilter("Sell-to Customer No.") = xRec."Sell-to Customer No." then
          if "Sell-to Customer No." <> xRec."Sell-to Customer No." then
            SetRange("Sell-to Customer No.");
        if GetFilter("Sell-to Contact No.") = xRec."Sell-to Contact No." then
          if "Sell-to Contact No." <> xRec."Sell-to Contact No." then
            SetRange("Sell-to Contact No.");
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(Doctype::Quote,"No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        HasIncomingDocument := "Incoming Document Entry No." <> 0;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
        CustomerSelected := "Sell-to Customer No." <> '';
    end;

    local procedure CheckSalesCheckAllLinesHaveQuantityAssigned()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
    end;

    local procedure UpdatePaymentService()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
    begin
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    end;

    local procedure UpdateShipToBillToGroupVisibility()
    begin
        case true of
          ("Ship-to Code" = '') and ShipToAddressEqualsSellToAddress:
            ShipToOptions := Shiptooptions::"Default (Sell-to Address)";
          ("Ship-to Code" = '') and (not ShipToAddressEqualsSellToAddress):
            ShipToOptions := Shiptooptions::"Custom Address";
          "Ship-to Code" <> '':
            ShipToOptions := Shiptooptions::"Alternate Shipping Address";
        end;

        if "Bill-to Customer No." = "Sell-to Customer No." then
          BillToOptions := Billtooptions::"Default (Customer)"
        else
          BillToOptions := Billtooptions::"Another Customer";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStatisticsAction(var SalesHeader: Record "Sales Header";var Handled: Boolean)
    begin
    end;
}

