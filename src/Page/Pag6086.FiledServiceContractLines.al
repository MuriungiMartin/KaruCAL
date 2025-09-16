#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6086 "Filed Service Contract Lines"
{
    Caption = 'Filed Service Contract Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Filed Contract Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of contract that was filed.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract or service contract quote that was filed.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the filed contract line.';
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item on the filed service contract line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service item group associated with the filed service item line.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the service item on the filed service item line.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number linked to the service item in the filed contract.';
                }
                field("Service Item Group Code";"Service Item Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the service item group associated with this service item.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the unit of measure used when the service item was sold.';
                    Visible = false;
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated time interval after work on the service order starts.';
                }
                field("Line Cost";"Line Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the calculated cost of the item line in the filed service contract or filed service contract quote.';
                }
                field("Line Value";"Line Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value on the service item line in the service contract.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line discount percentage provided on the service item line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of the discount on the contract line in the filed service contract or filed contract quote.';
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net amount (excluding the invoice discount amount) of the service item line.';
                }
                field(Profit;Profit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the profit on the contract line in the filed service contract or filed contract quote.';
                }
                field("Invoiced to Date";"Invoiced to Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the contract was last invoiced.';
                }
                field("Service Period";"Service Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated time that elapses until service starts on the service item.';
                }
                field("Last Planned Service Date";"Last Planned Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the last planned service on this item.';
                }
                field("Next Planned Service Date";"Next Planned Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the next planned service on this item.';
                }
                field("Last Service Date";"Last Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the last actual service on this item.';
                }
                field("Last Preventive Maint. Date";"Last Preventive Maint. Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the last time preventative service was performed on this item.';
                }
                field("Credit Memo Date";"Credit Memo Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you can create a credit memo for the item that needs to be removed from the service contract.';
                }
                field("Contract Expiration Date";"Contract Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service item should be removed from the service contract.';
                }
                field("New Line";"New Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this service contract line is a new line.';
                }
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
                action("Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        FiledServiceContract.Get("Entry No.");
                        Page.Run(Page::"Filed Service Contract",FiledServiceContract);
                    end;
                }
            }
        }
    }

    var
        FiledServiceContract: Record "Filed Service Contract Header";
}

