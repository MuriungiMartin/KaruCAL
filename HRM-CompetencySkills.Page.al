#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68350 "HRM-Competency Skills"
{
    PageType = ListPart;
    SourceTable = UnknownTable61291;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Competency Area";"Competency Area")
                {
                    ApplicationArea = Basic;
                }
                field("Competency Area Description";"Competency Area Description")
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
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

