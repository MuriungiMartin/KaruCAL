#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6075 "Serv. Contr. List (Serv. Item)"
{
    Caption = 'Service Contract List';
    DataCaptionFields = "Service Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Contract Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contract Status";"Contract Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the contract.';
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the contract.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract or service contract quote associated with the service contract line.';
                }
                field(ContractDescription;ContractDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Description';
                    ToolTip = 'Specifies billable prices for the job task that are related to G/L accounts.';
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item that is subject to the service contract.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Line Description';
                    ToolTip = 'Specifies billable profits for the job task that are related to G/L accounts, expressed in the local currency.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer associated with the service contract or service item.';
                    Visible = false;
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the response time for the service item associated with the service contract.';
                }
                field("Line Cost";"Line Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the calculated cost of the service item line in the service contract or contract quote.';
                }
                field("Line Value";"Line Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the service item line in the contract or contract quote.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line discount percentage that will be provided on the service item line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of the discount that will be provided on the service contract line.';
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net amount (excluding the invoice discount amount) of the service item line.';
                }
                field(Profit;Profit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the profit, expressed as the difference between the Line Amount and Line Cost fields on the service contract line.';
                }
                field("Service Period";"Service Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the period of time that must pass between each servicing of an item.';
                }
                field("Next Planned Service Date";"Next Planned Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the next planned service on the item included in the contract.';
                }
                field("Last Planned Service Date";"Last Planned Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the last planned service on this item.';
                    Visible = false;
                }
                field("Last Preventive Maint. Date";"Last Preventive Maint. Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the last time preventative service was performed on this item.';
                    Visible = false;
                }
                field("Last Service Date";"Last Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service item on the line was last serviced.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the service contract.';
                }
                field("Contract Expiration Date";"Contract Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when an item should be removed from the contract.';
                }
                field("Credit Memo Date";"Credit Memo Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you can create a credit memo for the service item that needs to be removed from the service contract.';
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("&Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = '&Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        case "Contract Type" of
                          "contract type"::Quote:
                            begin
                              ServContractHeader.Get("Contract Type","Contract No.");
                              Page.Run(Page::"Service Contract Quote",ServContractHeader);
                            end;
                          "contract type"::Contract:
                            begin
                              ServContractHeader.Get("Contract Type","Contract No.");
                              Page.Run(Page::"Service Contract",ServContractHeader);
                            end;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ServContractHeader: Record "Service Contract Header";
    begin
        ServContractHeader.Get("Contract Type","Contract No.");
        ContractDescription := ServContractHeader.Description;
    end;

    var
        ServContractHeader: Record "Service Contract Header";
        ContractDescription: Text[50];
}

