#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68517 "ACA-Programme Subject Grades"
{
    PageType = ListPart;
    SourceTable = UnknownTable61385;

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
                field("Subject Name";"Subject Name")
                {
                    ApplicationArea = Basic;
                }
                field("Mean Grade";"Mean Grade")
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

