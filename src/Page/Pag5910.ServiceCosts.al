#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5910 "Service Costs"
{
    ApplicationArea = Basic;
    Caption = 'Service Costs';
    PageType = List;
    SourceTable = "Service Cost";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the service cost.';
                }
                field("Cost Type";"Cost Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost type.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service cost.';
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general ledger account number to which the service cost will be posted.';
                }
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service zone, to which travel applies if the Cost Type is Travel.';
                }
                field("Default Quantity";"Default Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default quantity that is copied to the service lines containing this service cost.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the unit of measure for the cost.';
                }
                field("Default Unit Cost";"Default Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default unit cost that is copied to the service lines containing this service cost.';
                }
                field("Default Unit Price";"Default Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default unit price of the cost that is copied to the service lines containing this service cost.';
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

