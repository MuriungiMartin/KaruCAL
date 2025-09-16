#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1508 "Workflow Categories"
{
    ApplicationArea = Basic;
    Caption = 'Workflow Categories';
    PageType = List;
    SourceTable = "Workflow Category";
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
                    ToolTip = 'Specifies the code for the workflow category.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the workflow category.';
                }
            }
        }
    }

    actions
    {
    }
}

