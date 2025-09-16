#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6051 "Service Contract List"
{
    Caption = 'Service Contract List';
    DataCaptionFields = "Contract Type";
    Editable = false;
    PageType = List;
    SourceTable = "Service Contract Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the service contract or contract quote.';
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the contract.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract or service contract quote.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service contract.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the service items in the service contract/contract quote.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer in the service contract.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer.';
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer name.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the service contract.';
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service contract expires.';
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
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        case "Contract Type" of
                          "contract type"::Quote:
                            Page.Run(Page::"Service Contract Quote",Rec);
                          "contract type"::Contract:
                            Page.Run(Page::"Service Contract",Rec);
                        end;
                    end;
                }
            }
        }
        area(reporting)
        {
            group(General)
            {
                Caption = 'General';
                Image = "Report";
                action("Service Items Out of Warranty")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Items Out of Warranty';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Service Items Out of Warranty";
                }
            }
            group(Contract)
            {
                Caption = 'Contract';
                Image = "Report";
                action("Service Contract-Customer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Contract-Customer';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Service Contract - Customer";
                }
                action("Service Contract-Salesperson")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Contract-Salesperson';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Serv. Contract - Salesperson";
                }
                action("Service Contract Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Contract Details';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Service Contract-Detail";
                }
                action("Service Contract Profit")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Contract Profit';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Service Profit (Contracts)";
                }
                action("Maintenance Visit - Planning")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Maintenance Visit - Planning';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Maintenance Visit - Planning";
                    ToolTip = 'View the service zone code, group code, contract number, customer number, service period, as well as the service date. You can select the schedule for one or more responsibility centers. The report shows the service dates of all the maintenance visits for the chosen responsibility centers. You can print all your schedules for maintenance visits.';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = "Report";
                action("Contract, Service Order Test")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract, Service Order Test';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Contr. Serv. Orders - Test";
                }
                action("Contract Invoice Test")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Invoice Test';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Contract Invoicing";
                    ToolTip = 'Specifies billable profits for the job task that are related to G/L accounts.';
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
            }
        }
    }
}

