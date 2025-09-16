#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68096 "HRM-Shortlist Applicant lines"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = UnknownTable61067;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Short Listed ID";"Short Listed ID")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
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

