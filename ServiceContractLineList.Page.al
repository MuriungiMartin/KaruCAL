#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6078 "Service Contract Line List"
{
    Caption = 'Service Contract Line List';
    Editable = false;
    PageType = List;
    SourceTable = "Service Contract Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item that is subject to the service contract.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the service item that is subject to the contract.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer associated with the service contract or service item.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the unit of measure used when the service item was sold.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the service item that is subject to the contract.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item linked to the service item in the service contract.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that specifies the variant of the service item on this line.';
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the response time for the service item associated with the service contract.';
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
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net amount (excluding the invoice discount amount) of the service item line.';
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
                }
                field("Last Preventive Maint. Date";"Last Preventive Maint. Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the last time preventative service was performed on this item.';
                }
                field("Last Service Date";"Last Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service item on the line was last serviced.';
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
                field("New Line";"New Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the service contract line is new or existing.';
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
                action("Service &Item Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Item Card';
                    Image = ServiceItem;
                    RunObject = Page "Service Item Card";
                    RunPageLink = "No."=field("Service Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ser&vice Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page "Serv. Contr. List (Serv. Item)";
                    RunPageLink = "Service Item No."=field("Service Item No.");
                    RunPageView = sorting("Service Item No.","Contract Status");
                }
            }
        }
    }
}

