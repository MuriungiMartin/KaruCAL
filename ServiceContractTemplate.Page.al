#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6055 "Service Contract Template"
{
    Caption = 'Service Contract Template';
    PageType = Card;
    SourceTable = "Service Contract Template";

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
                    ToolTip = 'Specifies the number of the service contract template.';

                    trigger OnAssistEdit()
                    begin
                        AssistEdit(Rec);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service contract.';
                }
                field("Contract Group Code";"Contract Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contract group code of the service contract.';
                }
                field("Service Order Type";"Service Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order type assigned to service orders linked to this service contract.';
                }
                field("Default Service Period";"Default Service Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default service period for the items in the contract.';
                }
                field("Price Update Period";"Price Update Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price update period for this service contract.';
                }
                field("Default Response Time (Hours)";"Default Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default response time for the service contract created from this service contract template.';
                }
                field("Max. Labor Unit Price";"Max. Labor Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum unit price that can be set for a resource on lines for service orders associated with the service contract.';
                }
            }
            group(Invoice)
            {
                Caption = 'Invoice';
                field("Serv. Contract Acc. Gr. Code";"Serv. Contract Acc. Gr. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code associated with the service contract account group.';
                }
                field("Invoice Period";"Invoice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice period for the service contract.';
                }
                field("Price Inv. Increase Code";"Price Inv. Increase Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Increase Text';
                    ToolTip = 'Specifies all billable prices for the job task, expressed in the local currency.';
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
                field("Allow Unbalanced Amounts";"Allow Unbalanced Amounts")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the contents of the Calcd. Annual Amount field are copied into the Annual Amount field in the service contract or contract quote.';
                }
                field("Combine Invoices";"Combine Invoices")
                {
                    ApplicationArea = Basic;
                }
                field("Automatic Credit Memos";"Automatic Credit Memos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a credit memo is created when you remove a contract line from the service contract under certain conditions.';
                }
                field("Contract Lines on Invoice";"Contract Lines on Invoice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies you want contract lines to appear as text on the invoice.';
                }
                field("Invoice after Service";"Invoice after Service")
                {
                    ApplicationArea = Basic;
                    Enabled = InvoiceAfterServiceEnable;
                    ToolTip = 'Specifies you can only invoice the contract if you have posted a service order linked to the contract since you last invoiced the contract.';

                    trigger OnValidate()
                    begin
                        InvoiceafterServiceOnAfterVali;
                    end;
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
        area(navigation)
        {
            group("&Contract Template")
            {
                Caption = '&Contract Template';
                Image = Template;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(5968),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                separator(Action17)
                {
                    Caption = '';
                }
                action("Service Dis&counts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Dis&counts';
                    Image = Discount;
                    RunObject = Page "Contract/Service Discounts";
                    RunPageLink = "Contract Type"=const(Template),
                                  "Contract No."=field("No.");
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ActivateFields;
    end;

    trigger OnInit()
    begin
        InvoiceAfterServiceEnable := true;
        PrepaidEnable := true;
    end;

    trigger OnOpenPage()
    begin
        ActivateFields;
    end;

    var
        [InDataSet]
        PrepaidEnable: Boolean;
        [InDataSet]
        InvoiceAfterServiceEnable: Boolean;

    local procedure ActivateFields()
    begin
        PrepaidEnable := (not "Invoice after Service" or Prepaid);
        InvoiceAfterServiceEnable := (not Prepaid or "Invoice after Service");
    end;

    local procedure InvoiceafterServiceOnAfterVali()
    begin
        ActivateFields;
    end;

    local procedure PrepaidOnAfterValidate()
    begin
        ActivateFields;
    end;
}

