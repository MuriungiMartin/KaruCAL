#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 132 "Posted Sales Invoice"
{
    Caption = 'Posted Sales Invoice';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Correct';
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Editable = false;
                    Importance = Promoted;
                    TableRelation = Customer.Name;
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field("Sell-to Address";"Sell-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the customer that the items on the invoice were shipped to.';
                    }
                    field("Sell-to Address 2";"Sell-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Sell-to City";"Sell-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city the items on the invoice were shipped to.';
                    }
                    field("Sell-to County";"Sell-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Sell-to Post Code";"Sell-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Sell-to Contact No.";"Sell-to Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact that the invoice was sent to.';
                    }
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Contact';
                    Editable = false;
                    ToolTip = 'Specifies the name of the person to contact when you communicate with the customer who you shipped the items to.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date on which you created the sales document.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the invoice was posted.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date on which the invoice is due for payment.';
                }
                group(Control3)
                {
                    Visible = DocExcStatusVisible;
                    field("Document Exchange Status";"Document Exchange Status")
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        Importance = Additional;
                        StyleExpr = DocExchStatusStyle;
                        ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';

                        trigger OnDrillDown()
                        begin
                            DocExchStatusDrillDown;
                        end;
                    }
                }
                field("Quote No.";"Quote No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the sales quote document if a quote was used to start the sales process.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the sales order that this invoice was posted from.';
                }
                field("Pre-Assigned No.";"Pre-Assigned No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the sales document that the posted invoice was created for.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the external document number that is entered on the sales header that this line was posted from.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies which salesperson is associated with the invoice.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    AccessByPermission = TableData "Responsibility Center"=R;
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center associated with the user who created the invoice, your company, or the customer in the sales invoice.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies how many times the invoice has been printed.';
                }
                field(Cancelled;Cancelled)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    Style = Unfavorable;
                    StyleExpr = Cancelled;
                    ToolTip = 'Specifies if the posted sales invoice has been either corrected or canceled.';

                    trigger OnDrillDown()
                    begin
                        ShowCorrectiveCreditMemo;
                    end;
                }
                field(Corrective;Corrective)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    Style = Unfavorable;
                    StyleExpr = Corrective;
                    ToolTip = 'Specifies if the posted sales invoice is a corrective document.';

                    trigger OnDrillDown()
                    begin
                        ShowCancelledCreditMemo;
                    end;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies if the posted invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.';
                }
                group("Work Description")
                {
                    Caption = 'Work Description';
                    field(GetWorkDescription;GetWorkDescription)
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            part(SalesInvLines;"Posted Sales Invoice Subform")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Document No."=field("No.");
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code of the invoice.';

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        ChangeExchangeRate.Editable(false);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          "Currency Factor" := ChangeExchangeRate.GetParameter;
                          Modify;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the shipment date. It is copied from the Shipment Date field on the sales header and is used for planning purposes.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount on the sales document.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies how the customer must pay for products on the sales document.';
                }
                group(Control15)
                {
                    Visible = PaymentServiceVisible;
                    field(SelectedPayments;GetSelectedPaymentsText)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Service';
                        Editable = false;
                        Enabled = PaymentServiceEnabled;
                        MultiLine = true;
                        ToolTip = 'Specifies the payment service, such as PayPal, that the sales invoice can be paid with.';

                        trigger OnAssistEdit()
                        var
                            PaymentServiceSetup: Record "Payment Service Setup";
                        begin
                            PaymentServiceSetup.ChangePaymentServicePostedInvoice(Rec);
                            CurrPage.Update(false);
                        end;
                    }
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code associated with the invoice.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code associated with the invoice.';
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the payment discount percentage granted if payment is made by the date entered in the Pmt. Discount Date field.';
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date by which the invoice must be paid to obtain a payment discount.';
                }
                field("Direct Debit Mandate ID";"Direct Debit Mandate ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the direct-debit mandate that the customer has signed to allow direct debit collection of payments.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the location from which the items were shipped.';
                }
            }
            group("Shipping and Billing")
            {
                Caption = 'Shipping and Billing';
                group("Shipping Details")
                {
                    Caption = 'Shipping Details';
                    field("Shipment Method Code";"Shipment Method Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Method';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the code that represents the shipment method for the invoice.';
                    }
                    field("Shipping Agent Code";"Shipping Agent Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Agent';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                    }
                }
                group("Electronic Invoice")
                {
                    Caption = 'Electronic Invoice';
                    field("Electronic Document Status";"Electronic Document Status")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the status of the document.';
                    }
                    field("Date/Time Stamped";"Date/Time Stamped")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the date and time that the document received a digital stamp from the authorized service provider.';
                    }
                    field("Date/Time Sent";"Date/Time Sent")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the date and time that the document was sent to the customer.';
                    }
                    field("Date/Time Canceled";"Date/Time Canceled")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the date and time that the document was canceled.';
                    }
                    field("Error Code";"Error Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the error code that the authorized service provider, PAC, has returned to Microsoft Dynamics NAV.';
                    }
                    field("Error Description";"Error Description")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the error message that the authorized service provider, PAC, has returned to Microsoft Dynamics NAV.';
                    }
                    field("PAC Web Service Name";"PAC Web Service Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the name of the authorized service provider, PAC, which has processed the electronic document.';
                    }
                    field("Fiscal Invoice Number PAC";"Fiscal Invoice Number PAC")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the official invoice number for the electronic document.';
                    }
                    field("No. of E-Documents Sent";"No. of E-Documents Sent")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the number of times that this document has been sent electronically.';
                    }
                    field("Package Tracking No.";"Package Tracking No.")
                    {
                        ApplicationArea = Suite;
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the shipping agent''s package number.';
                    }
                }
                group("Ship-to")
                {
                    Caption = 'Ship-to';
                    field("Ship-to Code";"Ship-to Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address Code';
                        Editable = false;
                        Importance = Promoted;
                        ToolTip = 'Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.';
                    }
                    field("Ship-to Name";"Ship-to Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Name';
                        Editable = false;
                        ToolTip = 'Specifies the name of the customer that the items were shipped to.';
                    }
                    field("Ship-to Address";"Ship-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        ToolTip = 'Specifies the address that the items on the invoice were shipped to.';
                    }
                    field("Ship-to Address 2";"Ship-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Ship-to Post Code";"Ship-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Ship-to City";"Ship-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        ToolTip = 'Specifies the city the items on the invoice were shipped to.';
                    }
                    field("Ship-to County";"Ship-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Ship-to Contact";"Ship-to Contact")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact';
                        Editable = false;
                        ToolTip = 'Specifies the name of the person you regularly contact at the address that the items were shipped to.';
                    }
                    field("Ship-to UPS Zone";"Ship-to UPS Zone")
                    {
                        ApplicationArea = Basic;
                        Caption = 'UPS Zone';
                        Editable = false;
                        ToolTip = 'Specifies the Ship-to UPS Zone of the customer to whom the invoice was sent.';
                    }
                }
                group("Bill-to")
                {
                    Caption = 'Bill-to';
                    field("Bill-to Name";"Bill-to Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Name';
                        Editable = false;
                        Importance = Promoted;
                        ToolTip = 'Specifies the name of the customer that the invoice was sent to.';
                    }
                    field("Bill-to Address";"Bill-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the customer that the invoice was sent to.';
                    }
                    field("Bill-to Address 2";"Bill-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Bill-to City";"Bill-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city of the customer that the invoice was sent to.';
                    }
                    field("Bill-to County";"Bill-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Bill-to Post Code";"Bill-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Bill-to Contact No.";"Bill-to Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact the invoice was sent to.';
                    }
                    field("Bill-to Contact";"Bill-to Contact")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact';
                        Editable = false;
                        ToolTip = 'Specifies the name of the person you regularly contact when you communicate with the customer to whom the invoice was sent.';
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the transaction specification that was used in the invoice.';
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the transport method of the sales header that this line was posted from.';
                }
                field("Exit Point";"Exit Point")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the port of exit through which you shipped the items out of your country/region.';
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the area code used in the invoice.';
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
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Sales Invoice Statistics",Rec,"No.")
                        else
                          Page.RunModal(Page::"Sales Invoice Stats.",Rec,"No.");
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type"=const("Posted Invoice"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Posted Approval Entry"=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ShowPostedApprovalEntries(RecordId);
                    end;
                }
                separator(Action171)
                {
                }
                action(ChangePaymentService)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Change Payment Service';
                    Image = ElectronicPayment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Change or add the payment service, such as PayPal Standard, that will be included on the sales document so the customer can quickly access the payment site.';
                    Visible = PaymentServiceVisible;

                    trigger OnAction()
                    var
                        PaymentServiceSetup: Record "Payment Service Setup";
                    begin
                        PaymentServiceSetup.ChangePaymentServicePostedInvoice(Rec);
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice';
                    Enabled = CRMIsCoupledToRecord;
                    Image = CoupledSalesInvoice;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM account.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(RecordId);
                    end;
                }
                action(CreateInCRM)
                {
                    ApplicationArea = All;
                    Caption = 'Create Invoice in Dynamics CRM';
                    Enabled = not CRMIsCoupledToRecord;
                    Image = NewSalesInvoice;
                    ToolTip = 'Create a sales invoice in Dynamics CRM that is connected to this posted sales invoice.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.CreateNewRecordInCRM(RecordId,false);
                    end;
                }
            }
        }
        area(processing)
        {
            group("&Electronic Document")
            {
                Caption = '&Electronic Document';
                action("S&end")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'S&end';
                    Ellipsis = true;
                    Image = SendTo;
                    ToolTip = 'Send an email to the customer with the electronic invoice attached as an XML file.';

                    trigger OnAction()
                    begin
                        RequestStampEDocument;
                    end;
                }
                action("Export E-Document as &XML")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Export E-Document as &XML';
                    Image = ExportElectronicDocument;
                    ToolTip = 'Export the posted sales invoice as an electronic invoice, and XML file, and save it to a specified location.';

                    trigger OnAction()
                    begin
                        ExportEDocument;
                    end;
                }
                action("&Cancel")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Cancel';
                    Image = Cancel;
                    ToolTip = 'Cancel the sending of the electronic sales invoice.';

                    trigger OnAction()
                    begin
                        CancelEDocument;
                    end;
                }
            }
            action(SendCustom)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.SendRecords;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = not IsOfficeAddin;

                trigger OnAction()
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.PrintRecords(true);
                end;
            }
            action(Email)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Email';
                Image = Email;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ToolTip = 'Prepare to email the document. The Send Email window opens prefilled with the customer''s email address so you can add or edit information.';

                trigger OnAction()
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.EmailRecords(true);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                Visible = not IsOfficeAddin;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Activity Log';
                Image = Log;
                ToolTip = 'View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.';

                trigger OnAction()
                begin
                    ShowActivityLog;
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
                        IncomingDocument.ShowCard("No.","Posting Date");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document"=R;
                    ApplicationArea = Basic;
                    Caption = 'Select Incoming Document';
                    Enabled = not HasIncomingDocument;
                    Image = SelectLineToApply;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.SelectIncomingDocumentForPostedDocument("No.","Posting Date",RecordId);
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
                        IncomingDocumentAttachment.NewAttachmentFromPostedDocument("No.","Posting Date");
                    end;
                }
            }
            group(Correct)
            {
                Caption = 'Correct';
                action(CorrectInvoice)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Correct';
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';

                    trigger OnAction()
                    var
                        CorrectPstdSalesInvYesNo: Codeunit "Correct PstdSalesInv (Yes/No)";
                    begin
                        if CorrectPstdSalesInvYesNo.CorrectInvoice(Rec) then
                          CurrPage.Close;
                    end;
                }
                action(CancelInvoice)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cancel';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Create and post a sales credit memo that reverses this posted sales invoice. This posted sales invoice will be canceled.';

                    trigger OnAction()
                    var
                        CancelPstdSalesInvYesNo: Codeunit "Cancel PstdSalesInv (Yes/No)";
                    begin
                        if CancelPstdSalesInvYesNo.CancelInvoice(Rec) then
                          CurrPage.Close;
                    end;
                }
                action(CreateCreditMemo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Create Corrective Credit Memo';
                    Image = CreateCreditMemo;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    ToolTip = 'Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
                    begin
                        CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec,SalesHeader);
                        Page.Run(Page::"Sales Credit Memo",SalesHeader);
                        CurrPage.Close;
                    end;
                }
            }
            group(Invoice)
            {
                Caption = 'Invoice';
                Image = Invoice;
                action(Customer)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer.';
                }
                action(ShowCreditMemo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Canceled/Corrective Credit Memo';
                    Enabled = Cancelled or Corrective;
                    Image = CreditMemo;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    ToolTip = 'Open the posted sales credit memo that was created when you canceled the posted sales invoice. If the posted sales invoice is the result of a canceled sales credit memo, then canceled sales credit memo will open.';

                    trigger OnAction()
                    begin
                        ShowCanceledOrCorrCrMemo;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "Incoming Document";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists("No.","Posting Date");
        DocExchStatusStyle := GetDocExchStatusStyle;
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
        UpdatePaymentService;
        DocExcStatusVisible := DocExchangeStatusIsSent;
    end;

    trigger OnAfterGetRecord()
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;
    end;

    trigger OnInit()
    begin
        DocExcStatusVisible := true;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        OfficeMgt: Codeunit "Office Management";
    begin
        SetSecurityFilterOnRespCenter;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        IsOfficeAddin := OfficeMgt.IsAvailable;
        CurrPage.Editable(false);
    end;

    var
        SalesInvHeader: Record "Sales Invoice Header";
        ChangeExchangeRate: Page "Change Exchange Rate";
        HasIncomingDocument: Boolean;
        DocExchStatusStyle: Text;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        PaymentServiceVisible: Boolean;
        PaymentServiceEnabled: Boolean;
        DocExcStatusVisible: Boolean;
        IsOfficeAddin: Boolean;

    local procedure UpdatePaymentService()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
    begin
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    end;
}

