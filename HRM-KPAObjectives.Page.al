#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68347 "HRM-KPA Objectives"
{
    PageType = ListPart;
    SourceTable = UnknownTable61293;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("KPA Code";"KPA Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("KPA Description";"KPA Description")
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

