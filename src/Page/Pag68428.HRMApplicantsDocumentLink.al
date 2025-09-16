#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68428 "HRM-Applicants Document Link"
{
    PageType = ListPart;
    SourceTable = UnknownTable61318;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Document Description";"Document Description")
                {
                    ApplicationArea = Basic;
                }
                field("Document Link";"Document Link")
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

