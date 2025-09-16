#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6072 "Filed Service Contract"
{
    Caption = 'Filed Service Contract';
    DataCaptionExpression = FORMAT("Contract Type") + ' ' + "Contract No.";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Filed Service Contract Header";

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
                    Editable = false;
                    ToolTip = 'Specifies the number of the filed service contract or service contract quote.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the filed service contract or contract quote.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the items in the filed service contract or contract quote.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer in the filed service contract or contract quote.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the customer in the filed service contract or contract quote.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional address line.';
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
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with the customer in the filed service contract or contract quote.';
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
                    ToolTip = 'Specifies the number of the contact who will receive the service contract delivery.';
                }
                field("Contract Group Code";"Contract Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contract group code of the filed service contract or contract quote.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson assigned to the filed service contract or contract quote.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the filed service contract or contract quote.';
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the filed service contract expires.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the filed service contract or contract quote.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the responsibility center associated with the customer in the filed service contract or contract quote, or with your company.';
                }
                field("Change Status";"Change Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the service contract or the service contract quote was open or locked for changes at the moment of filing.';
                }
            }
            part(Control93;"Filed Service Contract Subform")
            {
                Editable = false;
                SubPageLink = "Entry No."=field("Entry No.");
                SubPageView = sorting("Entry No.","Line No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer you send the invoice for the filed service contract or contract quote to.';
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact you have chosen to send an invoice to.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer you will send the invoice for the filed service contract or contract quote to.';
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the customer you will send the invoice for the filed service contract or contract quote to.';
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional line of the address.';
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
                    ToolTip = 'Specifies the name of the contact person from your customer''s company who receives the invoice for the service order.';
                }
                field("Your Reference";"Your Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s reference number.';
                }
                field("Serv. Contract Acc. Gr. Code";"Serv. Contract Acc. Gr. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service contract account group that the filed service contract is associated with.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the document.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension value code for the document line.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment terms code for the customer in the filed service contract or contract quote.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the amounts in the filed service contract or contract quote.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer in the filed service contract or contract quote.';
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer at the address where the service items in the filed contract or contract quote are located.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address where the service items in the filed contract or contract quote are located.';
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
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service zone of the customer''s ship-to address.';
                }
                field("Service Period";"Service Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default service period for the service items in the filed service contract or contract quote.';
                }
                field("First Service Date";"First Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the first expected service for the service items in the filed service contract or contract quote.';
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default response time for the service items in the filed service contract or contract quote.';
                }
                field("Service Order Type";"Service Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order type assigned to service orders linked to this filed service contract or contract quote.';
                }
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Annual Amount";"Annual Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that was invoiced annually before the service contract or contract quote was filed.';
                }
                field("Allow Unbalanced Amounts";"Allow Unbalanced Amounts")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the Annual Amount field on the contract or quote is modified automatically or manually.';
                }
                field("Calcd. Annual Amount";"Calcd. Annual Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of the Line Amount field values on all contract lines associated with the filed service contract or contract quote.';
                }
                field("Invoice Period";"Invoice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice period for the filed service contract or contract quote.';
                }
                field("Next Invoice Date";"Next Invoice Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the next invoice date for this filed service contract or contract quote.';
                }
                field("Amount per Period";"Amount per Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that will be invoiced for each invoice period for the filed service contract or contract quote.';
                }
                field(NextInvoicePeriod;NextInvoicePeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Next Invoice Period';
                }
                field("Last Invoice Date";"Last Invoice Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice date when this filed service contract was last invoiced.';
                }
                field(Prepaid;Prepaid)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this filed service contract or contract quote is prepaid.';
                }
                field("Automatic Credit Memos";"Automatic Credit Memos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you want a credit memo created when you remove a contract line from the filed service contract.';
                }
                field("Invoice after Service";"Invoice after Service")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies you can only invoice the contract if you have posted a service order since last time you invoiced the contract.';
                }
                field("Combine Invoices";"Combine Invoices")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies you want to combine invoices for this filed service contract with invoices for other service contracts with the same customer.';
                }
                field("Contract Lines on Invoice";"Contract Lines on Invoice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you want the contract lines for this service contract to appear as text on the invoice created when you invoice the contract.';
                }
            }
            group("Price Update")
            {
                Caption = 'Price Update';
                field("Price Update Period";"Price Update Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price update period for this filed service contract or contract quote.';
                }
                field("Next Price Update Date";"Next Price Update Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the next date when you want contract prices to be updated.';
                }
                field("Last Price Update %";"Last Price Update %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price update percentage you used when you last updated the contract prices.';
                }
                field("Last Price Update Date";"Last Price Update Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you last updated the service contract prices.';
                }
                field("Print Increase Text";"Print Increase Text")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Prints the price increase text specified on invoices for this contract, informing the customer which prices have been updated.';
                }
                field("Price Inv. Increase Code";"Price Inv. Increase Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the standard text code to print on service invoices for this filed service contract, informing the customer which prices have been updated.';
                }
            }
            group(Detail)
            {
                Caption = 'Detail';
                field("Cancel Reason Code";"Cancel Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cancel reason code specified in a service contract or a contract quote at the moment of filing.';
                }
                field("Max. Labor Unit Price";"Max. Labor Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum unit price that can be set for a resource on all service order lines for to the filed service contract or contract quote.';
                }
            }
            group("Filed Detail")
            {
                Caption = 'Filed Detail';
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the user ID of the person who filed the copy of the service contract or contract quote.';
                }
                field("File Date";"File Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when service contract or contract quote is filed.';
                }
                field("File Time";"File Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when the service contract or contract quote is filed.';
                }
                field("Reason for Filing";"Reason for Filing")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason for filing the service contract or contract quote.';
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
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

