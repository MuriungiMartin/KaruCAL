#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 428 "Shipping Agents"
{
    ApplicationArea = Basic;
    Caption = 'Shipping Agents';
    PageType = List;
    SourceTable = "Shipping Agent";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a shipping agent code.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the shipping agent.';
                }
                field("Internet Address";"Internet Address")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies an Internet address for the shipping agent.';
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the account number that the shipping agent has assigned to your company.';
                    Visible = false;
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
                action(ShippingAgentServices)
                {
                    ApplicationArea = Suite;
                    Caption = 'Shipping A&gent Services';
                    Image = CheckList;
                    RunObject = Page "Shipping Agent Services";
                    RunPageLink = "Shipping Agent Code"=field(Code);
                    ToolTip = 'View the types of services that your shipping agent can offer you and their shipping time.';
                }
            }
        }
    }
}

