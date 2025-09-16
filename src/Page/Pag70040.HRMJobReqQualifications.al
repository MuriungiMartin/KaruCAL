#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70040 "HRM-JobReq-Qualifications"
{
    PageType = List;
    SourceTable = UnknownTable60227;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                }
                field("Criteria Code";"Criteria Code")
                {
                    ApplicationArea = Basic;
                }
                field("Req. No";"Req. No")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Achievable Values";"Achievable Values")
                {
                    ApplicationArea = Basic;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Score";"Minimum Score")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

