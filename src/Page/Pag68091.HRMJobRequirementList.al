#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68091 "HRM-Job Requirement List"
{
    PageType = List;
    SourceTable = UnknownTable61059;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Job Specification";"Job Specification")
                {
                    ApplicationArea = Basic;
                }
                field("Qualification Code";"Qualification Code")
                {
                    ApplicationArea = Basic;
                }
                field(Qualification;Qualification)
                {
                    ApplicationArea = Basic;
                }
                field("Job Requirements";"Job Requirements")
                {
                    ApplicationArea = Basic;
                }
                field(Priority;Priority)
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

