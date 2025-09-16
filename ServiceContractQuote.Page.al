#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6053 "Service Contract Quote"
{
    Caption = 'Service Contract Quote';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Service Contract Header";
    SourceTableView = where("Contract Type"=filter(Quote));

    layout
    {
        area(content)
        {
            group(General)
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
                field("Quote Type";"Quote Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the service contract quote.';
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
                    Editable = true;
                    Importance = Promoted;
                    OptionCaption = ' ,,Canceled';
                    ToolTip = 'Specifies the status of the service contract or contract quote.';

                    trigger OnValidate()
                    begin
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
            part(ServContractLines;"Service Contract Quote Subform")
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
                    Importance = Promoted;
                    ToolTip = 'Specifies a default service period for the items in the contract.';

                    trigger OnValidate()
                    begin
                        ServicePeriodOnAfterValidate;
                    end;
                }
                field("First Service Date";"First Service Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date of the first expected service for the service items in the contract.';
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
                field("Invoice Period";"Invoice Period")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the invoice period for the service contract.';
                }
                field("Next Invoice Date";"Next Invoice Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date of the next invoice for this service contract.';
                }
                field("Amount per Period";"Amount per Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that will be invoiced for each invoice period for the service contract.';
                }
                field(NextInvoicePeriod;NextInvoicePeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Next Invoice Period';
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
                    ToolTip = 'Specifies you want to combine invoices for this service contract with invoices for other service contracts with the same customer.';
                }
                field("Contract Lines on Invoice";"Contract Lines on Invoice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you want the lines for this contract to appear as text on the invoice.';
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
                field("Max. Labor Unit Price";"Max. Labor Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum unit price that can be set for a resource on all service orders and lines for the service contract.';
                }
                field("Accept Before";"Accept Before")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date before which the customer must accept this contract quote.';
                }
                field(Probability;Probability)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the probability of the customer approving the service contract quote.';
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
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
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
                                  "Service Contract Type"=filter(Quote);
                }
                separator(Action97)
                {
                }
                action("&Filed Contract Quotes")
                {
                    ApplicationArea = Basic;
                    Caption = '&Filed Contract Quotes';
                    Image = Quote;
                    RunObject = Page "Filed Service Contract List";
                    RunPageLink = "Contract Type Relation"=field("Contract Type"),
                                  "Contract No. Relation"=field("Contract No.");
                    RunPageView = sorting("Contract Type Relation","Contract No. Relation","File Date","File Time")
                                  order(descending);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Select Contract Quote Lines")
                {
                    ApplicationArea = Basic;
                    Caption = '&Select Contract Quote Lines';
                    Image = CalculateLines;

                    trigger OnAction()
                    begin
                        CheckRequiredFields;
                        GetServItemLine;
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
                separator(Action102)
                {
                }
                action("&File Contract Quote")
                {
                    ApplicationArea = Basic;
                    Caption = '&File Contract Quote';
                    Image = FileContract;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if Confirm(Text001) then
                          FiledServContract.FileContract(Rec);
                    end;
                }
                action("Update &Discount % on All Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update &Discount % on All Lines';
                    Image = Refresh;

                    trigger OnAction()
                    begin
                        ServContractLine.Reset;
                        ServContractLine.SetRange("Contract Type","Contract Type");
                        ServContractLine.SetRange("Contract No.","Contract No.");
                        Report.RunModal(Report::"Upd. Disc.% on Contract",true,true,ServContractLine);
                    end;
                }
                action("Update with Contract &Template")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update with Contract &Template';
                    Image = Refresh;

                    trigger OnAction()
                    begin
                        if not Confirm(Text002,true) then
                          exit;
                        CurrPage.Update(true);
                        Clear(ServContrQuoteTmplUpd);
                        ServContrQuoteTmplUpd.Run(Rec);
                        CurrPage.Update(true);
                    end;
                }
                action("Loc&k")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loc&k';
                    Image = Lock;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        LockOpenServContract.LockServContract(Rec);
                        CurrPage.Update;
                    end;
                }
                action("&Open")
                {
                    ApplicationArea = Basic;
                    Caption = '&Open';
                    Image = Edit;
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    begin
                        LockOpenServContract.OpenServContract(Rec);
                        CurrPage.Update;
                    end;
                }
            }
            action("&Make Contract")
            {
                ApplicationArea = Basic;
                Caption = '&Make Contract';
                Image = MakeAgreement;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SignServContractDoc: Codeunit SignServContractDoc;
                begin
                    CurrPage.Update(true);
                    SignServContractDoc.SignContractQuote(Rec);
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
                    DocPrint.PrintServiceContract(Rec);
                end;
            }
        }
        area(reporting)
        {
            action("Service Quote Details")
            {
                ApplicationArea = Basic;
                Caption = 'Service Quote Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Service Contract Quote-Detail";
            }
            action("Contract Quotes to be Signed")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Quotes to be Signed';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Contract Quotes to Be Signed";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("Calcd. Annual Amount");
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
    end;

    var
        Text000: label '%1 must not be blank in %2 %3', Comment='Contract No. must not be blank in Service Contract Header SC00004';
        Text001: label 'Do you want to file the contract quote?';
        Text002: label 'Do you want to update the contract quote using a contract template?';
        FiledServContract: Record "Filed Service Contract Header";
        ServContractLine: Record "Service Contract Line";
        CopyServDoc: Report "Copy Service Document";
        UserMgt: Codeunit "User Setup Management";
        ServContrQuoteTmplUpd: Codeunit "ServContractQuote-Tmpl. Upd.";
        Text003: label '%1 must not be %2 in %3 %4', Comment='Status must not be blank in Signed SC00001';
        LockOpenServContract: Codeunit "Lock-OpenServContract";
        [InDataSet]
        PrepaidEnable: Boolean;
        [InDataSet]
        InvoiceAfterServiceEnable: Boolean;

    local procedure ActivateFields()
    begin
        PrepaidEnable := (not "Invoice after Service" or Prepaid);
        InvoiceAfterServiceEnable := (not Prepaid or "Invoice after Service");
    end;

    local procedure CheckRequiredFields()
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
          Error(Text003,FieldCaption(Status),Format(Status),TableCaption,"Contract No.");
        if "Change Status" = "change status"::Locked then
          Error(Text003,FieldCaption("Change Status"),Format("Change Status"),TableCaption,"Contract No.");
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

    local procedure StatusOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure StartingDateOnAfterValidate()
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

    local procedure ServicePeriodOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

