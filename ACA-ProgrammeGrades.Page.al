#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68516 "ACA-Programme Grades"
{
    PageType = Document;
    SourceTable = UnknownTable61384;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Programme Name";"Programme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Mean Grade";"Mean Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Min Points";"Min Points")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102760012;"ACA-Programme Subject Grades")
            {
                SubPageLink = Programme=field(Programme);
            }
        }
    }

    actions
    {
    }
}

