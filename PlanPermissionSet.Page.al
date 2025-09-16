#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9844 "Plan Permission Set"
{
    Caption = 'Plan Permission Set';
    Editable = false;
    PageType = List;
    SourceTable = "Plan Permission Set";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Plan Name";"Plan Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Plan';
                    ToolTip = 'Specifies the name of the subscription plan.';
                }
                field("Permission Set ID";"Permission Set ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Permission Set';
                    ToolTip = 'Specifies the ID of the permission set.';
                }
            }
        }
    }

    actions
    {
    }
}

