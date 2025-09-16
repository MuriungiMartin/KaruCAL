#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 168 "Service Ledger Entries Preview"
{
    Caption = 'Service Ledger Entries Preview';
    DataCaptionFields = "Service Contract No.","Service Item No. (Serviced)","Service Order No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Ledger Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when this entry was posted.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type for this entry.';
                }
                field("Service Order Type";"Service Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the service order if this entry was created for a service order.';
                    Visible = false;
                }
                field("Service Contract No.";"Service Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract, if this entry is linked to a service contract.';
                }
                field("Service Order No.";"Service Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service order, if this entry was created for a service order.';
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job number assigned to this entry.';
                    Visible = false;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job task number assigned to this entry.';
                    Visible = false;
                }
                field("Job Line Type";"Job Line Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the journal line type that is created in the Job Planning Line table and linked to this job ledger entry.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document type of the service ledger entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the document from which this entry was created.';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number of this entry.';
                    Visible = false;
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer related to this entry.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer associated with this entry.';
                    Visible = false;
                }
                field("Service Item No. (Serviced)";"Service Item No. (Serviced)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the serviced item associated with this entry.';
                }
                field("Item No. (Serviced)";"Item No. (Serviced)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the serviced item associated with this entry.';
                }
                field("Serial No. (Serviced)";"Serial No. (Serviced)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the serviced item associated with this entry.';
                }
                field("Contract Invoice Period";"Contract Invoice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice period of that contract, if this entry originates from a service contract.';
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Global Dimension 1 code associated with this entry.';
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Global Dimension 2 code associated with this entry.';
                }
                field("Contract Group Code";"Contract Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contract group code of the service contract to which this entry is associated.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of origin of this entry.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contract number, standard text code, resource number, item number, service cost code, or the general ledger account for this entry.';
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total cost amount of this entry.';
                }
                field("Discount Amount";"Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total discount amount on this entry.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit cost of this entry.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units in this entry.';
                }
                field("Charged Qty.";"Charged Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units in this entry that should be invoiced.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price of one unit of the service item in this entry.';
                }
                field("Discount %";"Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount percentage of this entry.';
                }
                field("Contract Disc. Amount";"Contract Disc. Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total contract discount amount of this entry.';
                    Visible = false;
                }
                field("Amount (LCY)";"Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of this entry.';
                }
                field("Moved from Prepaid Acc.";"Moved from Prepaid Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this entry is not a prepaid entry from a service contract.';
                }
                field("Serv. Contract Acc. Gr. Code";"Serv. Contract Acc. Gr. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service contract account group code the service contract is associated with, if this entry is included in a service contract.';
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault reason code for this entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the resource, item, cost, standard text, general ledger account, or service contract associated with this entry.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the general business posting group associated with this entry.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the general production posting group associated with this entry.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location associated with this entry.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code for this entry.';
                    Visible = false;
                }
                field(Prepaid;Prepaid)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the service contract or contract-related service order was prepaid.';
                    Visible = false;
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies contract-related service ledger entries.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who worked on the document associated with this entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount on this entry.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Entry")
            {
                Caption = '&Entry';
                Image = Entry;
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
                    end;
                }
            }
        }
    }
}

