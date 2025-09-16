#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68324 "HRM-Recruitment stages"
{
    PageType = ListPart;
    SourceTable = UnknownTable61276;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Recruitement Stage";"Recruitement Stage")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Failed Response Templates";"Failed Response Templates")
                {
                    ApplicationArea = Basic;
                }
                field("Passed Response Templates";"Passed Response Templates")
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

