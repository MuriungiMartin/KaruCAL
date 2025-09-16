#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5943 "Service Order Status Setup"
{
    ApplicationArea = Basic;
    Caption = 'Service Order Status Setup';
    PageType = List;
    SourceTable = "Service Status Priority Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Service Order Status";"Service Order Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order status to which you are assigning a priority.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority level for the service order status.';
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

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then
          CurrPage.Editable(false)
        else
          CurrPage.Editable(true);
    end;
}

