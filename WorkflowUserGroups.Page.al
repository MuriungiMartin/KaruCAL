#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1533 "Workflow User Groups"
{
    ApplicationArea = Basic;
    Caption = 'Workflow User Groups';
    CardPageID = "Workflow User Group";
    PageType = List;
    SourceTable = "Workflow User Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the workflow user group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the workflow user group.';
                }
            }
        }
    }

    actions
    {
    }
}

