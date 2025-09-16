#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6050 "Service Contract"
{
    Caption = 'Service Contract';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Service Contract Header";
    SourceTableView = where("Contract Type"=filter(Contract));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                Caption = 'General';
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the service contract or service contract quote.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service contract.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer who owns the service items in the service contract/contract quote.';

                    trigger OnValidate()
                    begin
                        CustomerNoOnAfterValidate;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the customer in the service contract.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the customer''s address.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies an additional address line for the customer.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the city in where the customer is located.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with the customer in this service contract.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer phone number.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s email address.';
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact who will receive the service delivery.';
                }
                field("Contract Group Code";"Contract Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contract group code assigned to the service contract.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson assigned to this service contract.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the starting date of the service contract.';

                    trigger OnValidate()
                    begin
                        StartingDateOnAfterValidate;
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the status of the service contract or contract quote.';

                    trigger OnValidate()
                    begin
                        ActivateFields;
                        StatusOnAfterValidate;
                    end;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the responsibility center associated either with the customer in the service contract or with your company.';
                }
                field("Change Status";"Change Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a service contract or contract quote is locked or open for changes.';
                }
            }
            part(ServContractLines;"Service Contract Subform")
            {
                SubPageLink = "Contract No."=field("Contract No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer to whom you will send the invoice.';

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact who receives the invoice.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the customer you will send the invoice to.';
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the customer address.';
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Bill-to City";"Bill-to City")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
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
                    DrillDown = false;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of your customer contact person, who you send the invoice to.';
                }
                field("Your Reference";"Your Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s reference number.';
                }
                field("Serv. Contract Acc. Gr. Code";"Serv. Contract Acc. Gr. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code associated with the service contract account group.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension value code for the document line.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension value code for the document line.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the payment terms code for the customer in the contract.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency used to calculate the amounts in the documents related to this contract.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ship-to code for the customer.';

                    trigger OnValidate()
                    begin
                        ShiptoCodeOnAfterValidate;
                    end;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the customer address.';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
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
                    DrillDown = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the service zone of the customer ship-to address.';
                }
                field("Service Period";"Service Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a default service period for the items in the contract.';

                    trigger OnValidate()
                    begin
                        ServicePeriodOnAfterValidate;
                    end;
                }
                field("First Service Date";"First Service Date")
                {
                    ApplicationArea = Basic;
                    Editable = FirstServiceDateEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date of the first expected service for the service items in the contract.';

                    trigger OnValidate()
                    begin
                        FirstServiceDateOnAfterValidat;
                    end;
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the response time for the service contract.';

                    trigger OnValidate()
                    begin
                        ResponseTimeHoursOnAfterValida;
                    end;
                }
                field("Service Order Type";"Service Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order type assigned to service orders linked to this contract.';
                }
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Annual Amount";"Annual Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that will be invoiced annually for the service contract or contract quote.';

                    trigger OnValidate()
                    begin
                        AnnualAmountOnAfterValidate;
                    end;
                }
                field("Allow Unbalanced Amounts";"Allow Unbalanced Amounts")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the contents of the Calcd. Annual Amount field are copied into the Annual Amount field in the service contract or contract quote.';

                    trigger OnValidate()
                    begin
                        AllowUnbalancedAmountsOnAfterV;
                    end;
                }
                field("Calcd. Annual Amount";"Calcd. Annual Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of the Line Amount field values on all contract lines associated with the service contract or contract quote.';
                }
                field(InvoicePeriod;"Invoice Period")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the invoice period for the service contract.';
                }
                field(NextInvoiceDate;"Next Invoice Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date of the next invoice for this service contract.';
                }
                field(AmountPerPeriod;"Amount per Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that will be invoiced for each invoice period for the service contract.';
                }
                field(NextInvoicePeriod;NextInvoicePeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Next Invoice Period';
                }
                field("Last Invoice Date";"Last Invoice Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when this service contract was last invoiced.';
                }
                field(Prepaid;Prepaid)
                {
                    ApplicationArea = Basic;
                    Enabled = PrepaidEnable;
                    ToolTip = 'Specifies that this service contract is prepaid.';

                    trigger OnValidate()
                    begin
                        PrepaidOnAfterValidate;
                    end;
                }
                field("Automatic Credit Memos";"Automatic Credit Memos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a credit memo is created when you remove a contract line.';
                }
                field("Invoice after Service";"Invoice after Service")
                {
                    ApplicationArea = Basic;
                    Enabled = InvoiceAfterServiceEnable;
                    ToolTip = 'Specifies that you can only invoice the contract if you have posted a service order since last time you invoiced the contract.';

                    trigger OnValidate()
                    begin
                        InvoiceafterServiceOnAfterVali;
                    end;
                }
                field("Combine Invoices";"Combine Invoices")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies you want to combine invoices for this service contract with invoices for other service contracts with the same  customer.';
                }
                field("Contract Lines on Invoice";"Contract Lines on Invoice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you want the lines for this contract to appear as text on the invoice.';
                }
                field("No. of Unposted Invoices";"No. of Unposted Invoices")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of unposted service invoices linked to the service contract.';
                }
                field("No. of Unposted Credit Memos";"No. of Unposted Credit Memos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of unposted credit memos linked to the service contract.';
                }
                field("No. of Posted Invoices";"No. of Posted Invoices")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of posted service invoices linked to the service contract.';
                }
                field("No. of Posted Credit Memos";"No. of Posted Credit Memos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of posted credit memos linked to this service contract.';
                }
            }
            group("Price Update")
            {
                Caption = 'Price Update';
                field("Price Update Period";"Price Update Period")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the price update period for this service contract.';
                }
                field("Next Price Update Date";"Next Price Update Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the next date you want contract prices to be updated.';
                }
                field("Last Price Update %";"Last Price Update %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price update percentage you used the last time you updated the contract prices.';
                }
                field("Last Price Update Date";"Last Price Update Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date you last updated the contract prices.';
                }
                field("Print Increase Text";"Print Increase Text")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the standard text code printed on service invoices, informing the customer which prices have been updated since the last invoice.';
                }
                field("Price Inv. Increase Code";"Price Inv. Increase Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the standard text code printed on service invoices, informing the customer which prices have been updated since the last invoice.';
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service contract expires.';

                    trigger OnValidate()
                    begin
                        ExpirationDateOnAfterValidate;
                    end;
                }
                field("Cancel Reason Code";"Cancel Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a reason code for canceling the service contract.';
                }
                field("Max. Labor Unit Price";"Max. Labor Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum unit price that can be set for a resource on all service orders and lines for the service contract.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507;"Customer Statistics FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1900316107;"Customer Details FactBox")
            {
                SubPageLink = "No."=field("Customer No.");
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
            group(Overview)
            {
                Caption = 'Overview';
                group("Ser&vice Overview")
                {
                    Caption = 'Ser&vice Overview';
                    Image = Tools;
                    action("Service Orders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Orders';
                        Image = Document;
                        RunObject = Page "Service List";
                        RunPageLink = "Document Type"=const(Order),
                                      "Contract No."=field("Contract No.");
                        RunPageView = sorting("Contract No.");
                    }
                    action("Posted Service Shipments")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Service Shipments';
                        Image = PostedShipment;

                        trigger OnAction()
                        var
                            TempServShptHeader: Record "Service Shipment Header" temporary;
                        begin
                            CollectShpmntsByLineContractNo(TempServShptHeader);
                            Page.RunModal(Page::"Posted Service Shipments",TempServShptHeader);
                        end;
                    }
                    action("Posted Service Invoices")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Service Invoices';
                        Image = PostedServiceOrder;
                        RunObject = Page "Service Document Registers";
                        RunPageLink = "Source Document No."=field("Contract No.");
                        RunPageView = sorting("Source Document Type","Source Document No.","Destination Document Type","Destination Document No.")
                                      where("Source Document Type"=const(Contract),
                                            "Destination Document Type"=const("Posted Invoice"));
                    }
                }
            }
            group("&Contract")
            {
                Caption = '&Contract';
                Image = Agreement;
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
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Service Dis&counts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Dis&counts';
                    Image = Discount;
                    RunObject = Page "Contract/Service Discounts";
                    RunPageLink = "Contract Type"=field("Contract Type"),
                                  "Contract No."=field("Contract No.");
                }
                action("Service &Hours")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Hours';
                    Image = ServiceHours;
                    RunObject = Page "Service Hours";
                    RunPageLink = "Service Contract No."=field("Contract No."),
                                  "Service Contract Type"=filter(Contract);
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action178)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Contract Statistics";
                        RunPageLink = "Contract Type"=const(Contract),
                                      "Contract No."=field("Contract No.");
                        ShortCutKey = 'F7';
                    }
                    action("Tr&endscape")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tr&endscape';
                        Image = Trendscape;
                        RunObject = Page "Contract Trendscape";
                        RunPageLink = "Contract Type"=const(Contract),
                                      "Contract No."=field("Contract No.");
                    }
                }
                separator(Action66)
                {
                    Caption = '';
                }
                action("Filed Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Filed Contracts';
                    Image = Agreement;
                    RunObject = Page "Filed Service Contract List";
                    RunPageLink = "Contract Type Relation"=field("Contract Type"),
                                  "Contract No. Relation"=field("Contract No.");
                    RunPageView = sorting("Contract Type Relation","Contract No. Relation","File Date","File Time")
                                  order(descending);
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=const("Service Contract"),
                                  "Table Subtype"=field("Contract Type"),
                                  "No."=field("Contract No."),
                                  "Table Line No."=const(0);
                }
                action("&Gain/Loss Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Gain/Loss Entries';
                    Image = GainLossEntries;
                    RunObject = Page "Contract Gain/Loss Entries";
                    RunPageLink = "Contract No."=field("Contract No.");
                    RunPageView = sorting("Contract No.","Change Date")
                                  order(descending);
                }
                separator(Action65)
                {
                    Caption = '';
                }
            }
            group(History)
            {
                Caption = 'History';
                action("C&hange Log")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&hange Log';
                    Image = ChangeLog;
                    RunObject = Page "Contract Change Log";
                    RunPageLink = "Contract No."=field("Contract No.");
                    RunPageView = sorting("Contract No.")
                                  order(descending);
                }
                separator(Action36)
                {
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Contract No."=field("Contract No.");
                    RunPageView = sorting("Service Contract No.","Posting Date","Document No.");
                }
                separator(Action82)
                {
                    Caption = '';
                }
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Service Contract No."=field("Contract No.");
                    RunPageView = sorting("Service Contract No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                separator(Action98)
                {
                }
            }
        }
        area(processing)
        {
            group(General)
            {
                Caption = 'General';
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
                        DocPrint.PrintServiceContract(Rec);
                    end;
                }
            }
            group("New Documents")
            {
                Caption = 'New Documents';
                action("Create Credit &Memo")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Credit &Memo';
                    Image = CreateCreditMemo;

                    trigger OnAction()
                    var
                        W1: Dialog;
                        CreditNoteNo: Code[20];
                        i: Integer;
                        j: Integer;
                        LineFound: Boolean;
                    begin
                        CurrPage.Update;
                        TestField(Status,Status::Signed);
                        if "No. of Unposted Credit Memos" <> 0 then
                          if not Confirm(Text009) then
                            exit;

                        ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                        if not Confirm(Text010,false) then
                          exit;

                        ServContractLine.Reset;
                        ServContractLine.SetCurrentkey("Contract Type","Contract No.",Credited,"New Line");
                        ServContractLine.SetRange("Contract Type","Contract Type");
                        ServContractLine.SetRange("Contract No.","Contract No.");
                        ServContractLine.SetRange(Credited,false);
                        ServContractLine.SetFilter("Credit Memo Date",'>%1&<=%2',0D,WorkDate);
                        i := ServContractLine.Count;
                        j := 0;
                        if ServContractLine.Find('-') then begin
                          LineFound := true;
                          W1.Open(
                            Text011 +
                            '@1@@@@@@@@@@@@@@@@@@@@@');
                          Clear(ServContractMgt);
                          ServContractMgt.InitCodeUnit;
                          repeat
                            ServContractLine1 := ServContractLine;
                            CreditNoteNo := ServContractMgt.CreateContractLineCreditMemo(ServContractLine1,false);
                            j := j + 1;
                            W1.Update(1,ROUND(j / i * 10000,1));
                          until ServContractLine.Next = 0;
                          ServContractMgt.FinishCodeunit;
                          W1.Close;
                          CurrPage.Update(false);
                        end;
                        ServContractLine.SetFilter("Credit Memo Date",'>%1',WorkDate);
                        if CreditNoteNo <> '' then
                          Message(StrSubstNo(Text012,CreditNoteNo))
                        else
                          if not ServContractLine.Find('-') or LineFound then
                            Message(Text013)
                          else
                            Message(Text016,ServContractLine.FieldCaption("Credit Memo Date"),ServContractLine."Credit Memo Date");
                    end;
                }
                action(CreateServiceInvoice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Service &Invoice';
                    Image = NewInvoice;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.Update;
                        TestField(Status,Status::Signed);
                        TestField("Change Status","change status"::Locked);

                        if "No. of Unposted Invoices" <> 0 then
                          if not Confirm(Text003) then
                            exit;

                        if "Invoice Period" = "invoice period"::None then
                          Error(StrSubstNo(
                              Text004,
                              TableCaption,"Contract No.",FieldCaption("Invoice Period"),Format("Invoice Period")));

                        if "Next Invoice Date" > WorkDate then
                          if ("Last Invoice Date" = 0D) and
                             ("Starting Date" < "Next Invoice Period Start")
                          then begin
                            Clear(ServContractMgt);
                            ServContractMgt.InitCodeUnit;
                            if ServContractMgt.CreateRemainingPeriodInvoice(Rec) <> '' then
                              Message(Text006);
                            ServContractMgt.FinishCodeunit;
                            exit;
                          end else
                            Error(Text005);

                        ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                        if Confirm(Text007) then begin
                          Clear(ServContractMgt);
                          ServContractMgt.InitCodeUnit;
                          ServContractMgt.CreateInvoice(Rec);
                          ServContractMgt.FinishCodeunit;
                          Message(Text008);
                        end;
                    end;
                }
                separator(Action111)
                {
                    Caption = '';
                }
            }
            group(Lock)
            {
                Caption = 'Lock';
                action(LockContract)
                {
                    ApplicationArea = Basic;
                    Caption = '&Lock Contract';
                    Image = Lock;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        LockOpenServContract: Codeunit "Lock-OpenServContract";
                    begin
                        CurrPage.Update;
                        LockOpenServContract.LockServContract(Rec);
                        CurrPage.Update;
                    end;
                }
                action(OpenContract)
                {
                    ApplicationArea = Basic;
                    Caption = '&Open Contract';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        LockOpenServContract: Codeunit "Lock-OpenServContract";
                    begin
                        CurrPage.Update;
                        LockOpenServContract.OpenServContract(Rec);
                        CurrPage.Update;
                    end;
                }
                separator(Action72)
                {
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SelectContractLines)
                {
                    ApplicationArea = Basic;
                    Caption = '&Select Contract Lines';
                    Image = CalculateLines;

                    trigger OnAction()
                    begin
                        CheckRequiredFields;
                        GetServItemLine;
                    end;
                }
                action("&Remove Contract Lines")
                {
                    ApplicationArea = Basic;
                    Caption = '&Remove Contract Lines';
                    Image = RemoveLine;

                    trigger OnAction()
                    begin
                        ServContractLine.Reset;
                        ServContractLine.SetRange("Contract Type","Contract Type");
                        ServContractLine.SetRange("Contract No.","Contract No.");
                        Report.RunModal(Report::"Remove Lines from Contract",true,true,ServContractLine);
                        CurrPage.Update;
                    end;
                }
                action(SignContract)
                {
                    ApplicationArea = Basic;
                    Caption = 'Si&gn Contract';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SignServContractDoc: Codeunit SignServContractDoc;
                    begin
                        CurrPage.Update;
                        SignServContractDoc.SignContract(Rec);
                        CurrPage.Update;
                    end;
                }
                separator(Action89)
                {
                }
                action("C&hange Customer")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&hange Customer';
                    Image = ChangeCustomer;

                    trigger OnAction()
                    begin
                        Clear(ChangeCustomerinContract);
                        ChangeCustomerinContract.SetRecord("Contract No.");
                        ChangeCustomerinContract.RunModal;
                    end;
                }
                action("Copy &Document...")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &Document...';
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CheckRequiredFields;
                        Clear(CopyServDoc);
                        CopyServDoc.SetServContractHeader(Rec);
                        CopyServDoc.RunModal;
                    end;
                }
                action("&File Contract")
                {
                    ApplicationArea = Basic;
                    Caption = '&File Contract';
                    Image = Agreement;

                    trigger OnAction()
                    begin
                        if Confirm(Text014) then
                          FiledServContract.FileContract(Rec);
                    end;
                }
                separator(Action109)
                {
                }
            }
        }
        area(reporting)
        {
            action("Contract Details")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Service Contract-Detail";
                ToolTip = 'Specifies billable prices for the job task that are related to items.';
            }
            action("Contract Gain/Loss Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Gain/Loss Entries';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Contract Gain/Loss Entries";
                ToolTip = 'Specifies billable prices for the job task that are related to G/L accounts, expressed in the local currency.';
            }
            action("Contract Invoicing")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Invoicing';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Contract Invoicing";
                ToolTip = 'Specifies all billable profits for the job task.';
            }
            action("Contract Price Update - Test")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Price Update - Test';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Contract Price Update - Test";
            }
            action("Prepaid Contract")
            {
                ApplicationArea = Basic;
                Caption = 'Prepaid Contract';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prepaid Contr. Entries - Test";
            }
            action("Expired Contract Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Expired Contract Lines';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Expired Contract Lines - Test";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("Calcd. Annual Amount","No. of Posted Invoices","No. of Unposted Invoices");
        ActivateFields;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateShiptoCode;
    end;

    trigger OnInit()
    begin
        InvoiceAfterServiceEnable := true;
        PrepaidEnable := true;
        FirstServiceDateEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetServiceFilter;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetServiceFilter <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetServiceFilter);
          FilterGroup(0);
        end;

        ActivateFields;
    end;

    var
        Text000: label '%1 must not be blank in %2 %3', Comment='Contract No. must not be blank in Service Contract Header SC00004';
        Text003: label 'There are unposted invoices associated with this contract.\\Do you want to continue?';
        Text004: label 'You cannot create an invoice for %1 %2 because %3 is %4.', Comment='You cannot create an invoice for Service Contract Header Contract No. because Invoice Period is Month.';
        Text005: label 'The next invoice date has not expired.';
        Text006: label 'An invoice was created successfully.';
        Text007: label 'Do you want to create an invoice for the contract?';
        Text008: label 'The invoice was created successfully.';
        Text009: label 'There are unposted credit memos associated with this contract.\\Do you want to continue?';
        Text010: label 'Do you want to create a credit note for the contract?';
        Text011: label 'Processing...        \\';
        Text012: label 'Contract lines have been credited.\\Credit memo %1 was created.';
        Text013: label 'A credit memo cannot be created. There must be at least one invoiced and expired service contract line which has not yet been credited.';
        Text014: label 'Do you want to file the contract?';
        ServContractLine: Record "Service Contract Line";
        ServContractLine1: Record "Service Contract Line";
        FiledServContract: Record "Filed Service Contract Header";
        ChangeCustomerinContract: Report "Change Customer in Contract";
        CopyServDoc: Report "Copy Service Document";
        ServContractMgt: Codeunit ServContractManagement;
        UserMgt: Codeunit "User Setup Management";
        Text015: label '%1 must not be %2 in %3 %4', Comment='Status must not be Locked in Service Contract Header SC00005';
        Text016: label 'A credit memo cannot be created, because the %1 %2 is after the work date.', Comment='A credit memo cannot be created, because the Credit Memo Date 03-02-11 is after the work date.';
        [InDataSet]
        FirstServiceDateEditable: Boolean;
        [InDataSet]
        PrepaidEnable: Boolean;
        [InDataSet]
        InvoiceAfterServiceEnable: Boolean;

    local procedure CollectShpmntsByLineContractNo(var TempServShptHeader: Record "Service Shipment Header" temporary)
    var
        ServShptHeader: Record "Service Shipment Header";
        ServShptLine: Record "Service Shipment Line";
    begin
        TempServShptHeader.Reset;
        TempServShptHeader.DeleteAll;
        ServShptLine.Reset;
        ServShptLine.SetCurrentkey("Contract No.");
        ServShptLine.SetRange("Contract No.","Contract No.");
        if ServShptLine.Find('-') then
          repeat
            if ServShptHeader.Get(ServShptLine."Document No.") then begin
              TempServShptHeader.Copy(ServShptHeader);
              if TempServShptHeader.Insert then;
            end;
          until ServShptLine.Next = 0;
    end;

    local procedure ActivateFields()
    begin
        FirstServiceDateEditable := Status <> Status::Signed;
        PrepaidEnable := (not "Invoice after Service" or Prepaid);
        InvoiceAfterServiceEnable := (not Prepaid or "Invoice after Service");
    end;


    procedure CheckRequiredFields()
    begin
        if "Contract No." = '' then
          Error(Text000,FieldCaption("Contract No."),TableCaption,"Contract No.");
        if "Customer No." = '' then
          Error(Text000,FieldCaption("Customer No."),TableCaption,"Contract No.");
        if Format("Service Period") = '' then
          Error(Text000,FieldCaption("Service Period"),TableCaption,"Contract No.");
        if "First Service Date" = 0D then
          Error(Text000,FieldCaption("First Service Date"),TableCaption,"Contract No.");
        if Status = Status::Canceled then
          Error(Text015,FieldCaption(Status),Format(Status),TableCaption,"Contract No.");
        if "Change Status" = "change status"::Locked then
          Error(Text015,FieldCaption("Change Status"),Format("Change Status"),TableCaption,"Contract No.");
    end;

    local procedure GetServItemLine()
    var
        ContractLineSelection: Page "Contract Line Selection";
    begin
        Clear(ContractLineSelection);
        ContractLineSelection.SetSelection("Customer No.","Ship-to Code","Contract Type","Contract No.");
        ContractLineSelection.RunModal;
        CurrPage.Update(false);
    end;

    local procedure StartingDateOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure StatusOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
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

    local procedure ResponseTimeHoursOnAfterValida()
    begin
        CurrPage.Update(true);
    end;

    local procedure ServicePeriodOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure AnnualAmountOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure InvoiceafterServiceOnAfterVali()
    begin
        ActivateFields;
    end;

    local procedure AllowUnbalancedAmountsOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure PrepaidOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure ExpirationDateOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure FirstServiceDateOnAfterValidat()
    begin
        CurrPage.Update;
    end;
}

