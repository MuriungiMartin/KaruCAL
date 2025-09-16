#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 671 "Job Queue Category List"
{
    ApplicationArea = Basic;
    Caption = 'Job Queue Category List';
    PageType = List;
    SourceTable = "Job Queue Category";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code for the category of job queue. You can enter a maximum of 10 characters, both numbers and letters.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the job queue category. You can enter a maximum of 30 characters, both numbers and letters.';
                }
            }
        }
    }

    actions
    {
    }
}

