#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68048 "HRM-Job Resp./Duties Lines"
{
    PageType = ListPart;
    SourceTable = UnknownTable61062;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Job Responsibilities/Duties";"Job Responsibilities/Duties")
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

