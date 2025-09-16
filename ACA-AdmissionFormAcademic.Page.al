#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68499 "ACA-Admission Form Academic"
{
    PageType = ListPart;
    SourceTable = UnknownTable61375;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Subject Code";"Subject Code")
                {
                    ApplicationArea = Basic;
                }
                field(Subject;Subject)
                {
                    ApplicationArea = Basic;
                }
                field(Grade;Grade)
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

